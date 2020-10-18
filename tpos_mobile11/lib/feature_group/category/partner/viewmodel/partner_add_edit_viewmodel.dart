import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/resources/app_route.dart';
import 'package:tpos_mobile/services/dialog_service/new_dialog_service.dart';
import 'package:tpos_mobile/services/navigation_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/CheckAddress.dart';
import 'package:tpos_mobile/state_management/viewmodel/base_viewmodel.dart';
import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile_localization/generated/l10n.dart';

/// The ViewModel for add and edit partner
class PartnerViewModel extends PViewModel {
  PartnerViewModel(
      {PartnerApi partnerApi,
      NewDialogService dialogService,
      NavigationService navigationService}) {
    _partnerApi = partnerApi ?? GetIt.I<PartnerApi>();
    _newDialog = dialogService ?? GetIt.I<NewDialogService>();
    _navigation = navigationService ?? GetIt.I<NavigationService>();
  }
  /*SERVICE*/
  final Logger _logger = Logger();
  PartnerApi _partnerApi;
  NewDialogService _newDialog;
  NavigationService _navigation;
  Logger get logger => _logger;

  String get title {
    if (_isCustomer && _isSupplier) {
      if (_id != null) {
        return S.current.editPartner;
      } else {
        return S.current.addPartner;
      }
    } else if (_isCustomer) {
      if (_id != null) {
        return S.current.editCustomer;
      } else {
        return S.current.addCustomer;
      }
    } else if (_isSupplier) {
      if (_id != null) {
        return S.current.editSupplier;
      } else {
        return S.current.addSupplier;
      }
    }
    return 'N/A';
  }

  //setting
  /// Pop qua route mới khi lưu thành công hay không
  bool _popWhenSaved = true;

  /// Route nào
  String _popRoute;
  Function(Partner) _onSaved;

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
  String _imageBase64;
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
  String get imageBase64 => _imageBase64;

  set isPersonal(bool value) {
    _isPersonal = value;
    notifyListeners();
  }

  void setName(String value, [bool notify = false]) {
    _name = value;
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

  void setDiscount(double value, [bool notify = false]) {
    _defaultDiscount = value;
    if (notify) {
      notifyListeners();
    }
  }

  void setDiscountAmount(double value, [bool notify = false]) {
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

  void setBase64Image(String base64) {
    _imageBase64 = base64;
  }

  void setCheckAddress(CheckAddress value) {
    if (value == null) {
      return;
    }

    _city = CityAddress(code: value.cityCode, name: value.cityName);
    _district =
        DistrictAddress(code: value.districtCode, name: value.districtName);
    _ward = WardAddress(code: value.wardCode, name: value.wardName);
    _street = value.address;
    setState(PViewModelLoadSuccess());
    notifyListeners();
  }

  void setBirthday(DateTime value) {
    _birthDay = value?.toLocal()?.toUtc();
    notifyListeners();
  }

  void setPriceList(ProductPrice value) {
    _priceList = value;
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

  /// Thêm một nhóm khách hàng vào dánh ách nhóm khách hàng
  void addPartnerCategory(PartnerCategory partnerCategory) {
    _categories ??= <PartnerCategory>[];

    if (!_categories.any((element) => element.id == partnerCategory.id)) {
      _categories.add(partnerCategory);
    }
    notifyListeners();
  }

  /// Xóa 1 nhóm khách hàng ra khỏi Danh sách nhóm khách hàng
  void removePartnerCategory(PartnerCategory partnerCategory) {
    final exitsPartnerCategory = _categories.firstWhere(
        (element) => element.id == partnerCategory.id,
        orElse: () => null);

    if (exitsPartnerCategory != null) {
      _categories.removeWhere((element) => element.id == partnerCategory.id);
    }
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
  bool get isAddNew => _id == null || _id == 0;
  /*METHOD*/

  /// Truyền param cho [PartnerViewModel] và khởi tọa dữ liệu ban đầu
  /// Nếu id hoặc partner được truyền vào thì sẽ ở chế độ sửa
  void init(
      {bool isSupplier = false,
      bool isCustomer = false,
      int id,
      Partner partner,
      closeWhenSaved = false,
      Function(Partner) onSaved}) {
    assert(isSupplier != null && isCustomer != null);
    _isSupplier = isSupplier.getValue();
    _isCustomer = isCustomer.getValue();
    _id = id;
    _popWhenSaved = closeWhenSaved;
    _onSaved = onSaved;
    _partner = partner;
    initData();
  }

  /// Khởi tạo dữ liệu. Nếu có [partner] truyền vào thì dữ liệu sửa được lấy từ partner này.
  /// Nếu không ViewModel sẽ lấy dữ liệu mới bởi lệnh GetById
  Future<PCommandResult> initData() async {
    setState(PViewModelBusy(S.current.loading));
    try {
      if (isAddNew) {
        // Create default value
      } else {
        // download data
        _partner ??= await _partnerApi.getById(_id);
        _mapPartnerToViewModel();
      }

      notifyListeners();
      setState(PViewModelLoadSuccess());
      return PCommandResult(true);
    } catch (e, s) {
      _logger.e('', e, s);
      //TODO(namnv): Using state instate
      _newDialog.showError(content: e.toString());
      setState(PViewModelLoadFailure(e.toString()));
      return PCommandResult(false);
    }
  }

  /// Cập nhật lại dữ liệu.
  Future<PCommandResult> refreshData() async {
    return await initData();
  }

  /// Convert Partner Object to PartnerViewModel
  void _mapPartnerToViewModel() {
    _isPersonal = !_partner.isCompany.getValue();
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
    _imageBase64 = _partner.image;
    _imageLink = _partner.imageUrl;
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
    _partner.image = _imageBase64;
  }

  /// Validate all date for insert or update
  String _validateData() {
    assert(_partner.birthDay == null || _partner.birthDay.isUtc);
    if (_partner.name.isNullOrEmpty()) {
      return S.current.partner_notifyPartnerNameCanNotBeEmpty;
    }
    if (_partner.isCompany == null) {
      return 'Bạn phải chọn đối tác là cá nhân, nhà cung cấp hoặc cả hai';
    }

    if (_partner.birthDay != null &&
        _partner.birthDay.isAfter(DateTime.now())) {
      return S.current.partner_notifyPartnerBirthdayValidateFailure;
    }

    // if (_partner.phone.isNotNullOrEmpty() && !_partner.phone.isPhoneNumber()) {
    //   return 'Số điện thoại không hợp lệ';
    // }

    if (!_partner.customer.getValue() && !_partner.supplier.getValue()) {
      return S.current.partner_notifyPartnerTypeNotSelectedYet;
    }

    if (_partner.discount.getValueOrDefault() > 100) {
      return 'Chiết khấu chỉ nằm trong khoảng từ 0 tới 100%';
    }

    if (_partner.birthDay != null && !_partner.birthDay.isUtc) {
      return 'Định dạng thời gian sinh nhật không hợp lệ';
    }
    return null;
  }

  /// Lưu dữ liệu
  Future<PCommandResult> save() async {
    bool saveResult = true;
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

      return PCommandResult(false);
    }
    setState(PViewModelBusy());
    try {
      if (isAddNew) {
        _partner = await _partnerApi.insert(_partner);
        _id = _partner.id;
        // Cập nhật lại UI
        notifyListeners();
        // Thông báo cái cho mừng
        _newDialog.showToast(message: 'Đã lưu khách hàng với tên $_name');
        App.showSnackbar(title: 'test', message: 'test');
      } else {
        await _partnerApi.update(_partner);
        // _newDialog.showToast(
        //     message: 'Đã lưu khách hàng với tên $_name', marginBottom: 64);
      }

      if (_onSaved != null) {
        _onSaved(_partner);
      }
    } catch (e, s) {
      _logger.e('', e, s);
      _newDialog.showError(content: e.toString());
      saveResult = false;
    }

    setState();
    return PCommandResult(saveResult);
  }
}
