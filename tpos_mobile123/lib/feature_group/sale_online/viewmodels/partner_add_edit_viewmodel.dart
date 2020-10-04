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
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/Address.dart';
import 'package:tpos_mobile/src/tpos_apis/models/CheckAddress.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_api.dart';

class PartnerAddEditViewModel extends ViewModel implements ViewModelBase {
  //log
  final _log = new Logger("PartnerAddEditViewModel");
  PartnerApi _partnerApi;
  ITposApiService _tposApi;
  DialogService _dialog;
  PartnerAddEditViewModel(
      {PartnerApi partnerApi,
      ITposApiService tposApiService,
      DialogService dialog}) {
    _partnerApi = partnerApi ?? GetIt.I<PartnerApi>();
    _tposApi = tposApiService ?? locator<ITposApiService>();
    _dialog = dialog ?? locator<DialogService>();
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

  //List<CheckAddress>
  List<CheckAddress> _checkAddressResults;
  List<CheckAddress> get checkAddressResults => _checkAddressResults;

  set checkAddressResults(List<CheckAddress> value) {
    _checkAddressResults = value;
    _checkAddressResultsController.sink.add(_checkAddressResults);
  }

  BehaviorSubject<List<CheckAddress>> _checkAddressResultsController =
      new BehaviorSubject();
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

  BehaviorSubject<CheckAddress> _selectedCheckAddressController =
      new BehaviorSubject();
  Stream<CheckAddress> get selectedCheckAddressStream =>
      _selectedCheckAddressController.stream;
  Sink<CheckAddress> get selectedCheckAddressSink =>
      _selectedCheckAddressController.sink;

  /// Kiểm tra địa chỉ nhanh
  RxCommand<String, bool> quickCheckAddressCommand;

  /// Lựa chọn địa chỉ kiểm tra
  RxCommand<CheckAddress, bool> selectCheckAddressCommand;

  // Partner
  Partner _partner = new Partner();

  Partner get partner => _partner;
  set partner(Partner value) {
    _partner = value;
    _partnerController.add(_partner);
  }

  BehaviorSubject<Partner> _partnerController = new BehaviorSubject();
  Stream<Partner> get partnerStream => _partnerController.stream;

  // dialog
  BehaviorSubject<OldDialogMessage> dialogController = new BehaviorSubject();

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
      onDialogMessageAdd(
        (OldDialogMessage.error(
          "Load dữ liệu thất bại",
          ex.toString(),
        )),
      );
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
    if (partner.partnerCategories == null)
      partner.partnerCategories = partnerCategories;
//    partner.categoryNames = "";
    partner.categoryId = 0;

    if (radioValue == 0) {
      partner.companyType = "person";
    } else {
      partner.companyType = "company";
    }

    try {
      var result;
      if (partner.id == null) {
        result = await _partnerApi.insert(partner);
        partner = result.result;
      } else {
        await _partnerApi.update(partner);
      }

      if (result.result == true || !result.error) {
        onDialogMessageAdd(
            OldDialogMessage.flashMessage("Lưu khách hàng thành công"));
        onStateAdd(false);
        return true;
      } else {
        onDialogMessageAdd(
            OldDialogMessage.error("Lưu dữ liệu thất bại", result.message));
        onStateAdd(false);
        return false;
      }
    } catch (ex, stack) {
      _log.severe("save fail", ex, stack);
      onDialogMessageAdd(
        (OldDialogMessage.error(
          "Lưu dữ liệu thất bại",
          ex.toString(),
        )),
      );
      onStateAdd(false);
      return false;
    }
  }

  // Stream PartnerCategory
  BehaviorSubject<List<PartnerCategory>> _partnerCategoriesController =
      new BehaviorSubject();

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
          .add(new OldDialogMessage.error("Đã xảy ra lỗi", ex.toString()));
    }

    partner = partner;
  }

  Future init({bool isSupplier, bool isCustomer}) async {
    onStateAdd(true);
    _log.info(
        "PartnerAddEditViewModel init with param isSuppler: $isSupplier | isCustomer: $isCustomer");

    if (partner == null || partner.id == null || partner.id == 0) {
      this.isProvider = isSupplier;
      this.isCustomer = isCustomer;
    }
    try {
      if (partner.id != null) await loadPartner(partner.id);
//   / await getProductPrices();
      await getAccountPayments();
      if (partner.partnerCategories != null)
        partnerCategories = partner.partnerCategories;
      if (partner.active != null) isActive = partner.active;
      if (partner.customer != null) isCustomer = partner.customer;
      if (partner.supplier != null) isProvider = partner.supplier;
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
      onPropertyChanged("init");
      onIsBusyAdd(false);
    } catch (e, s) {
      _log.severe("", e, s);
      _dialog.showError(error: e, isRetry: true).then((result) {
        if (result.type == DialogResultType.RETRY)
          this.init();
        else if (result.type == DialogResultType.GOBACK)
          onEventAdd("GO_BACK", null);
      });
    }
    onPropertyChanged("init");
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
