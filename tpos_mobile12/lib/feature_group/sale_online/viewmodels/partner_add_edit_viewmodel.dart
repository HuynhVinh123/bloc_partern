/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:53 AM
 *
 */

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:rx_command/rx_command.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/services/dialog_service/new_dialog_service.dart';
import 'package:tpos_mobile/services/navigation_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/Address.dart';
import 'package:tpos_mobile/src/tpos_apis/models/CheckAddress.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_api.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';

class PartnerAddEditViewModel extends ViewModel implements ViewModelBase {
  PartnerAddEditViewModel(
      {PartnerApi partnerApi,
      ITposApiService tposApiService,
      NewDialogService newDialogService}) {
    _partnerApi = partnerApi ?? GetIt.I<PartnerApi>();
    _tposApi = tposApiService ?? locator<ITposApiService>();
    _newDialog = newDialogService ?? GetIt.I<NewDialogService>();
    _navigationService = locator<NavigationService>();

    // quick check Address
    quickCheckAddressCommand = RxCommand.createAsync<String, bool>(
      (String keyword) async {
        if (keyword != null || keyword.isNotEmpty) {
          checkAddressResults = await _tposApi.quickCheckAddress(keyword);
        }
        if (_checkAddressResults != null && _checkAddressResults.isNotEmpty) {
          selectedCheckAddress = checkAddressResults.first;
          selectCheckAddressCommand(_selectedCheckAddress);
        }
        return true;
      },
    );

    // select check address
    selectCheckAddressCommand = RxCommand.createAsync<CheckAddress, bool>(
        (CheckAddress selectedCheckAddress) async {
      if (selectedCheckAddress.cityCode != null) {
        _partner.city = CityAddress(
            code: selectedCheckAddress.cityCode,
            name: selectedCheckAddress.cityName);
      }

      if (selectedCheckAddress.districtCode != null) {
        _partner.district = DistrictAddress(
            code: selectedCheckAddress.districtCode,
            name: selectedCheckAddress.districtName);
      }

      if (selectedCheckAddress.wardCode != null) {
        _partner.ward = WardAddress(
            code: selectedCheckAddress.wardCode,
            name: selectedCheckAddress.wardName);
      }
      _partner.street = selectedCheckAddress.address;
      _partnerController.sink.add(_partner);
      return true;
    });

    quickCheckAddressCommand.thrownExceptions.listen((e) {
      _log.severe("test", e);
    });
  }
  //log
  final _log = Logger("PartnerAddEditViewModel");
  PartnerApi _partnerApi;
  ITposApiService _tposApi;
  NewDialogService _newDialog;
  NavigationService _navigationService;

  //List<CheckAddress>
  List<CheckAddress> _checkAddressResults;
  List<CheckAddress> get checkAddressResults => _checkAddressResults;

  set checkAddressResults(List<CheckAddress> value) {
    _checkAddressResults = value;
    _checkAddressResultsController.sink.add(_checkAddressResults);
  }

  final BehaviorSubject<List<CheckAddress>> _checkAddressResultsController =
      BehaviorSubject();
  Stream<List<CheckAddress>> get checkAddressStream =>
      _checkAddressResultsController.stream;
  Sink<List<CheckAddress>> get checkAddressSink =>
      _checkAddressResultsController.sink;

  // Selected checkaddress
  CheckAddress _selectedCheckAddress;
  CheckAddress get selectedCheckAddress => _selectedCheckAddress;
  set selectedCheckAddress(CheckAddress value) {
    _selectedCheckAddress = value;
    _selectedCheckAddressController.sink.add(_selectedCheckAddress);
  }

  final BehaviorSubject<CheckAddress> _selectedCheckAddressController =
      BehaviorSubject();
  Stream<CheckAddress> get selectedCheckAddressStream =>
      _selectedCheckAddressController.stream;
  Sink<CheckAddress> get selectedCheckAddressSink =>
      _selectedCheckAddressController.sink;

  /// Kiểm tra địa chỉ nhanh
  RxCommand<String, bool> quickCheckAddressCommand;

  /// Lựa chọn địa chỉ kiểm tra
  RxCommand<CheckAddress, bool> selectCheckAddressCommand;

  // Partner
  Partner _partner = Partner();

  Partner get partner => _partner;
  set partner(Partner value) {
    _partner = value;
    _partnerController.add(_partner);
  }

  final BehaviorSubject<Partner> _partnerController = BehaviorSubject();
  Stream<Partner> get partnerStream => _partnerController.stream;

  // dialog
  BehaviorSubject<OldDialogMessage> dialogController = BehaviorSubject();

  void selectPartnerCategoryCommand(PartnerCategory selectedCat) {
    partnerCategories.add(selectedCat);
    onPropertyChanged("category");
  }

  void removePartnerCategoryCommand(PartnerCategory selectedCat) {
    partnerCategories.remove(selectedCat);
    onPropertyChanged("category");
  }

  // Add partner
  Future<bool> loadPartner(int id) async {
    try {
      partner = await _partnerApi.getById(id);

      return true;
    } catch (ex, stack) {
      _log.severe("load fail", ex, stack);
      _newDialog.showDialog(
          type: AlertDialogType.error, content: ex.toString());
      _navigationService.goBack();
    }
    return false;
  }

  static Future<String> convertImageBase64(File image) async {
    try {
      List<int> imageBytes = image.readAsBytesSync();
      return base64Encode(imageBytes);
    } catch (ex) {
      return null;
    }
  }

  // Add partner
  Future<bool> save(File image) async {
    onStateAdd(true);
    if (image != null) partner.image = await compute(convertImageBase64, image);
    if (selectedAccountPayment != null) {
      partner.propertyPaymentTermId = selectedAccountPayment.id;
      partner.propertyPaymentTerm = selectedAccountPayment;
    }
    if (selectedSupplierPayment != null) {
      partner.propertySupplierPaymentTerm = selectedSupplierPayment;
      partner.propertySupplierPaymentTermId = selectedSupplierPayment.id;
    }

    partner.supplier = isProvider;
    partner.active = isActive;
    partner.customer = isCustomer;
    partner.partnerCategories ??= partnerCategories;
    partner.categoryId = 0;
    // set ref = null để server tự sinh mã khách hàng
    if (partner.ref.isNullOrEmpty()) {
      partner.ref = null;
    }

    if (radioValue == 0) {
      partner.companyType = "person";
    } else {
      partner.companyType = "company";
    }

    try {
      if (partner.id == null) {
        _partner = await _partnerApi.insert(partner);
      } else {
        await _partnerApi.update(partner);
      }

      _newDialog.showToast(message: 'Lưu khách hàng thành công');
      onStateAdd(false);
      return true;
    } catch (e, s) {
      _log.severe("save fail", e, s);
      _newDialog.showDialog(type: AlertDialogType.error, content: s.toString());
      onStateAdd(false);
      return false;
    }
  }

  // Stream PartnerCategory
  final BehaviorSubject<List<PartnerCategory>> _partnerCategoriesController =
      BehaviorSubject();

  Stream<List<PartnerCategory>> get partnerCategoriesStream =>
      _partnerCategoriesController.stream;

  List<PartnerCategory> _partnerCategories = [];
  List<PartnerCategory> get partnerCategories => _partnerCategories;

  set partnerCategories(List<PartnerCategory> value) {
    _partnerCategories = value;
    _partnerCategoriesController.add(_partnerCategories);
  }

  // addressFromSelect
  String get addressFromSelect {
    String add = "";
    if (_partner.ward != null) {
      add += _partner.ward.name;
    }

    if (add.isNotEmpty) {
      if (_partner.district != null) {
        add += ", " + _partner.district.name;
      } else {
        add += _partner.district.name;
      }
    }

    if (add.isNotEmpty) {
      if (_partner.city != null) {
        add += ", " + _partner.city.name;
      } else {
        add += _partner.city.name;
      }
    }
    return add;
  }

  set partnerCity(Address selectedCity) {
    if (selectedCity != null) {
      _partner.city = new CityAddress(
        code: selectedCity.code,
        name: selectedCity.name,
      );

      _partner.district = null;
      _partner.ward = null;
      _partner.street = this.addressFromSelect;

      _partnerController.sink.add(_partner);
      onPropertyChanged("partner");
    }
  }

  set partnerDistrict(Address selectedDistrict) {
    if (selectedDistrict != null) {
      _partner.district = new DistrictAddress(
        code: selectedDistrict.code,
        name: selectedDistrict.name,
      );
      _partner.ward = null;

      _partner.street = this.addressFromSelect;
      _partnerController.sink.add(_partner);
      onPropertyChanged("partner");
    }
  }

  set partnerWard(Address selectedWard) {
    if (selectedWard != null) {
      _partner.ward = new WardAddress(
        code: selectedWard.code,
        name: selectedWard.name,
      );
      _partner.street = this.addressFromSelect;
      _partnerController.sink.add(_partner);
      onPropertyChanged("partner");
    }
  }

  // Active check
  bool isActive = true;
  void isCheckActive(bool value) {
    isActive = value;
    onPropertyChanged("isCheckActive");
  }

  // isCustomer check
  bool isCustomer = true;
  void isCheckCustomer(bool value) {
    isCustomer = value;
    onPropertyChanged("isCheckCustomer");
  }

  // isProvider check
  bool isProvider = false;
  void isCheckProvider(bool value) {
    isProvider = value;
    onPropertyChanged("isCheckProvider");
  }

  // Bảng giá
  ProductPrice selectedProductPrice;
  List<ProductPrice> productPrices;
//  Future<void> getProductPrices() async {
//    try {
//      productPrices = await _tposApi.getProductPrices();
//      selectedProductPrice = productPrices.first;
//    } catch (ex, stack) {
//      _log.severe("getProductPrices fail", ex, stack);
//    }
//  }

  // Điều khoản thanh toán
  AccountPaymentTerm selectedAccountPayment;
  AccountPaymentTerm selectedSupplierPayment;
  List<AccountPaymentTerm> accountPayments;
  Future<void> getAccountPayments() async {
    try {
      accountPayments = await _tposApi.getAccountPayments();
    } catch (ex, stack) {
      _log.severe("getAccountPayments fail", ex, stack);
    }
  }

  // Radio button
  int radioValue = 0;
  void handleRadioValueChanged(int value) {
    radioValue = value;
  }

  // update partner status
  Future updateParterStatus(String status, String statusText) async {
    try {
      await _partnerApi.updateStatus(partner.id,
          status: "${status}_$statusText");
      partner.status = status;
      partner.statusText = statusText;
    } catch (ex, stack) {
      _log.severe("updateParterStatus fail", ex, stack);
      dialogController
          .add(OldDialogMessage.error("Đã xảy ra lỗi", ex.toString()));
    }

    partner = partner;
  }

  Future init({bool isSupplier = false, bool isCustomer = false}) async {
    onStateAdd(true);
    _log.info(
        "PartnerAddEditViewModel init with param isSuppler: $isSupplier | isCustomer: $isCustomer");

    if (partner == null || partner.id == null || partner.id == 0) {
      isProvider = isSupplier;
      this.isCustomer = isCustomer;
    }
    try {
      if (partner.id != null) {
        await loadPartner(partner.id);
      }

      await getAccountPayments();
      if (partner.partnerCategories != null)
        partnerCategories = partner.partnerCategories;
      if (partner.active != null) {
        isActive = partner.active;
      }
      if (partner.customer != null) {
        isCustomer = partner.customer;
      }
      if (partner.supplier != null) {
        isProvider = partner.supplier;
      }
      if (partner.companyType == "person" || partner.companyType == null) {
        radioValue = 0;
      } else {
        radioValue = 1;
      }

      selectedAccountPayment = accountPayments.firstWhere(
          (f) => f.id == partner.propertyPaymentTerm?.id,
          orElse: () => null);
      selectedSupplierPayment = accountPayments.firstWhere(
          (f) => f.id == partner.propertySupplierPaymentTerm?.id,
          orElse: () => null);
      onIsBusyAdd(false);
    } catch (e, s) {
      _log.severe("", e, s);
      _newDialog.showDialog(content: e.toString(), type: AlertDialogType.error);
    }
    onStateAdd(false);
    notifyListeners();
  }

  @override
  void dispose() {
    _partnerController.close();
    _selectedCheckAddressController.close();
    _checkAddressResultsController.close();
    super.dispose();
  }
}
