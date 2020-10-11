import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/services/dialog_service/new_dialog_service.dart';
import 'package:tpos_mobile/state_management/viewmodel/base_viewmodel.dart';
import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';

/// The ViewModel for add and edit partner
class PartnerViewModel extends PViewModel<PViewModelState> {
  PartnerViewModel({PartnerApi partnerApi, NewDialogService dialogService}) {
    _partnerApi = partnerApi ?? GetIt.I<PartnerApi>();
    _newDialog = dialogService ?? GetIt.I<NewDialogService>();
  }
  /*SERVICE*/
  final Logger _logger = Logger();
  PartnerApi _partnerApi;
  NewDialogService _newDialog;

  Logger get logger => _logger;

  /*PROPERTY*/
  int _id;
  String _checkAddress;
  Partner _partner;
  bool _isPersonal = true;
  String _name;
  String _ref;
  DateTime _birthDay;
  List<PartnerCategory> _categories;
  String _status;
  String _statusStyle;
  String _statusText;
  String _phone;
  String _email;
  String _zalo;
  String _facebook;
  String _website;
  String _street;
  CityAddress _city;
  DistrictAddress _district;
  WardAddress _ward;
  bool _isCustomer = false;
  bool _isSupplier = false;
  ProductPrice _priceList;
  double _defaultDiscount;
  double _defaultDiscountAmount;
  String _barcode;
  String _taxCode;
  bool _active = true;
  String _imageLink;

  /*PUBLIC*/
  PartnerApi get partnerApi => _partnerApi;

  NewDialogService get newDialog => _newDialog;

  String get checkAddress => _checkAddress;

  Partner get partner => _partner;

  bool get isPersonal => _isPersonal;

  String get name => _name;

  String get ref => _ref;

  DateTime get birthDay => _birthDay;

  List<PartnerCategory> get categories => _categories ?? (_categories = []);

  String get status => _status;

  String get statusStyle => _statusStyle;

  String get statusText => _statusText;

  String get phone => _phone;

  String get email => _email;

  String get zalo => _zalo;

  String get facebook => _facebook;

  String get website => _website;

  String get street => _street;

  CityAddress get city => _city;

  DistrictAddress get district => _district;

  WardAddress get ward => _ward;

  bool get isCustomer => _isCustomer;

  bool get isSupplier => _isSupplier;

  ProductPrice get priceList => _priceList;

  double get defaultDiscount => _defaultDiscount;

  double get defaultDiscountAmount => _defaultDiscountAmount;
  String get barcode => _barcode;
  String get taxCode => _taxCode;
  bool get active => _active;
  String get imageLink => _imageLink;

  set isPersonal(bool value) {
    _isPersonal = value;
    notifyListeners();
  }

  set name(String value) {
    _name = value;
    notifyListeners();
  }

  void setPartnerStatus(
      {String status, String statusText, String statusStyle}) {
    _status = status;
    _statusText = statusText;
    notifyListeners();
  }

  set isActive(bool value) {
    _active = value;
    notifyListeners();
  }

  set isCustomer(bool value) {
    _isCustomer = value;
    notifyListeners();
  }

  set isSupplier(bool value) {
    _isSupplier = value;
    notifyListeners();
  }

  void setRef(String value, [bool notify = false]) {
    _ref = value;
    if (notify) {
      notifyListeners();
    }
  }

  void setPhone(String value, [bool notify = false]) {
    _phone = value;
    if (notify) {
      notifyListeners();
    }
  }

  void setAddress(String value, [bool notify = false]) {
    _street = value;
    if (notify) {
      notifyListeners();
    }
  }

  void setEmail(String value, [bool notify = false]) {
    _email = value;
    if (notify) {
      notifyListeners();
    }
  }

  void setZalo(String value, [bool notify = false]) {
    _zalo = value;
    if (notify) {
      notifyListeners();
    }
  }

  void setFacebook(String value, [bool notify = false]) {
    _facebook = value;
    if (notify) {
      notifyListeners();
    }
  }

  void setWebsite(String value, [bool notify = false]) {
    _website = value;
    if (notify) {
      notifyListeners();
    }
  }

  void setDiscount(double value, [bool notify = true]) {
    _defaultDiscount = value;
    if (notify) {
      notifyListeners();
    }
  }

  void setDiscountAmount(double value, [bool notify = true]) {
    _defaultDiscountAmount = value;
    if (notify) {
      notifyListeners();
    }
  }

  void setCity(CityAddress city) {
    _city = city;
    _district = null;
    _ward = null;
    notifyListeners();
  }

  void setDistrict(DistrictAddress value) {
    _district = value;
    _ward = null;
    notifyListeners();
  }

  void setWard(WardAddress value) {
    _ward = value;
    notifyListeners();
  }

  void updateStreetBaseOnAddress() {
    if (_city == null || _district == null || _ward == null) {
      _newDialog.showToast(
        message: 'Bạn phải nhập đầy đủ tỉnh thành, quận huyện, phường xã',
        type: AlertDialogType.warning,
        marginBottom: 65,
      );
      return;
    }

    _street = _getAddressFromSelect;
    notifyListeners();
  }

  String get _getAddressFromSelect {
    String add = "";
    if (_ward != null) {
      add += _ward.name;
    }

    if (add.isNotEmpty) {
      if (_district != null) {
        add += ", " + _district.name;
      } else {
        add += _district.name;
      }
    }

    if (add.isNotEmpty) {
      if (_city != null) {
        add += ", " + _city.name;
      } else {
        add += _city.name;
      }
    }
    return add;
  }

  /*BIẾN XÁC ĐỊNH*/
  bool get isAddNew =>
      _partner == null || _partner.id == null || _partner.id == 0;
  /*METHOD*/
  @override
  void init() {
    // TODO: implement init
  }

  void setParam({bool isSupplier = false, bool isCustomer = false, int id}) {
    assert(isSupplier != null && isCustomer != null);
    _isSupplier = isSupplier.getValue();
    _isCustomer = isCustomer.getValue();
    _id = id;
  }

  @override
  Future<void> start() async {
    try {
      if (isAddNew) {
        // Create default value
      } else {
        // download data
        _partner = await _partnerApi.getById(_id);
        _mapPartnerToViewModel();
      }
    } catch (e, s) {
      _logger.e('', e, s);
    }

    notifyListeners();
  }

  /// Convert Partner Object to PartnerViewModel
  void _mapPartnerToViewModel() {
    _isPersonal = !_partner.isCompany;
    _name = _partner.name;
    _ref = _partner.ref;
    _birthDay = _partner.birthDay;
    _categories = _partner.partnerCategories;
    _status = _partner.status;
    _statusText = _partner.statusText;
    _statusStyle = _partner.statusStyle;
    _phone = _partner.phone;
    _email = _partner.email;
    _zalo = _partner.zalo;
    _facebook = _partner.facebook;
    _website = _partner.website;
    _street = _partner.street;
    _city = _partner.city;
    _district = _partner.district;
    _ward = _partner.ward;
    _isCustomer = _partner.customer;
    _isSupplier = _partner.supplier;
    _priceList = _partner.propertyProductPricelist;
    _defaultDiscount = _partner.discount;
    _defaultDiscountAmount = _partner.amountDiscount;
    _barcode = _partner.barcode;
    _taxCode = _partner.taxCode;
    _active = _partner.active;
  }

  /// Convert PartnerViewModel to Partner Object
  void _mapViewModelToPartner() {
    _partner ??= Partner();
    _partner.isCompany = !_isPersonal;
    _partner.name = _name;
    _partner.ref = _ref;
    _partner.birthDay = _birthDay;
    _partner.partnerCategories = _categories;
    _partner.status = _status;
    _partner.statusText = _statusText;
    _partner.statusStyle = _statusStyle;
    _partner.phone = _phone;
    _partner.email = _email;
    _partner.zalo = _zalo;
    _partner.facebook = _facebook;
    _partner.website = _website;
    _partner.street = _street;
    _partner.city = _city;
    _partner.district = _district;
    _partner.ward = _ward;
    _partner.customer = _isCustomer;
    _partner.supplier = _isSupplier;
    _partner.propertyProductPricelist = _priceList;
    _partner.discount = _defaultDiscount;
    _partner.amountDiscount = _defaultDiscountAmount;
    _partner.barcode = _barcode;
    _partner.taxCode = _taxCode;
    _partner.active = _active;
  }

  /// Validate all date for insert or update
  String _validateData() {
    if (_partner.name.isNullOrEmpty()) {
      return 'Tên đối tác không được để trống';
    }
    if (_partner.isCompany == null) {
      return 'Bạn phải chọn đối tác là cá nhân, nhà cung cấp hoặc cả hai';
    }

    if (_partner.birthDay != null &&
        _partner.birthDay.isAfter(DateTime.now())) {
      return 'Sinh nhật đối tác không hợp lệ. Thời gian phải trước thời điểm hiện tại';
    }

    if (_partner.phone.isNotNullOrEmpty() && !_partner.phone.isPhoneNumber()) {
      return 'Số điện thoại không hợp lệ';
    }

    if (!_partner.customer.getValue() && !_partner.supplier.getValue()) {
      return 'Bạn phải chọn khách hàng là nhà cung cấp hoặc khách hàng hoặc cả hai';
    }

    if (_partner.discount.getValueOrDefault() > 100) {
      return 'Chiết khấu chỉ nằm trong khoảng từ 0 tới 100%';
    }
    return null;
  }

  /// Lưu dữ liệu
  Future<void> save() async {
    _mapViewModelToPartner();
    final String validateResult = _validateData();
    if (validateResult != null) {
      setState(PViewModelValidateFailure(validateResult));
      _newDialog.showToast(
        title: 'Dữ liệu không hợp lệ!',
        message: validateResult,
        type: AlertDialogType.warning,
        marginBottom: 65,
      );
      return;
    }
    setState(PViewModelLoading());
    try {
      if (isAddNew) {
        await _partnerApi.insert(_partner);
      } else {
        await _partnerApi.update(_partner);
      }
    } catch (e, s) {
      _logger.e('', e, s);
      _newDialog.showError(content: e.toString());
    }

    setState();
  }
}
