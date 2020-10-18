import 'package:flutter/material.dart';

import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tmt_flutter_untils/sources/string_utils/string_utils.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/helpers/string_helper.dart';

import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/helpers/helpers.dart' as prefix0;
import 'package:tpos_mobile/services/analytics_service.dart';
import 'package:tpos_mobile/services/app_setting_service.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/services/log_services/log_service.dart';
import 'package:tpos_mobile/src/facebook_apis/facebook_api.dart';
import 'package:tpos_mobile/src/tpos_apis/models/register_tpos_result.dart';
import 'package:tpos_mobile/src/tpos_apis/models/tpos_city.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/register_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';

class RegisterViewModel extends ViewModel {
  static const REGISTER_ERROR_EVENT = "RegisterError";
  static const REGISTER_COMPLETE_EVENT = "RegisterComplete";
  ITposApiService _tposApi;
  IRegisterApi _registerService;
  IFacebookApiService _fbApi;
  DialogService _dialog;
  ISettingService _setting;
  AnalyticsService _analyticService;
  RegisterViewModel({
    ITposApiService tposApi,
    DialogService dialog,
    LogService log,
    IRegisterApi registerApi,
    ISettingService setting,
    IFacebookApiService fbApi,
    AnalyticsService analyticsService,
  }) : super(logService: log) {
    _tposApi = tposApi ?? locator<ITposApiService>();
    _dialog = dialog ?? locator<DialogService>();
    _registerService = registerApi ?? locator<IRegisterApi>();
    _setting = setting ?? locator<ISettingService>();

    _fbApi = fbApi ?? locator<IFacebookApiService>();
    _analyticService = analyticsService ?? locator<AnalyticsService>();
  }
  String name;
  String phone;
  String email;
  String shopUrl;
  String _token;
  bool get isLoginFacebook => _token != null;
  FacebookUser _facebookUser;
  bool isShowRegisterForm = false;

  String emailValidate;
  String phoneValidate;
  String shopUrlValidate;
  String cityCodeValidate;

  String note;
  List<TPosCity> _cities;
  List<TPosCity> viewCities;
  List<TPosCity> get cities => _cities;
  final BehaviorSubject<List<TPosCity>> _citiSubject = BehaviorSubject();
  Stream<List<TPosCity>> get cityStream => _citiSubject.stream;
  FacebookUser get facebookUser => _facebookUser;
  TPosCity _selectedCity;
  TPosCity get selectedCity => _selectedCity;
  set selectedCity(TPosCity value) {
    _selectedCity = value;
    notifyListeners();
  }

  Future<void> initData() async {
    //initAccountKit();
    try {
      onStateAdd(true);
      _cities = await _tposApi.getTposCity();
      viewCities = _cities;
      addSubject(_citiSubject, viewCities);
      notifyListeners();
    } catch (e, s) {
      logger.error("", e, s);
      _dialog.showError(error: e);
    }
    onStateAdd(false);
  }

  Future<void> loginFacebook() async {
    isShowRegisterForm = false;
    try {
      final FacebookLogin _facebookLogin = FacebookLogin();
      var result = await _facebookLogin.logIn(["public_profile", "email"]);
      if (result.status == FacebookLoginStatus.loggedIn) {
        _token = result.accessToken.token;
        await _fetchFacebookInfo();
      } else if (result.status == FacebookLoginStatus.error) {
        _dialog.showError(content: result.errorMessage);
      } else if (result.status == FacebookLoginStatus.cancelledByUser) {
        _dialog.showError(content: "Hủy bỏ bởi người dùng");
      }
    } catch (e, s) {
      _dialog.showError(content: "Hủy bỏ bởi người dùng");
      logger.error("", e, s);
    }
    notifyListeners();
  }

  Future<void> _fetchFacebookInfo() async {
    try {
      _facebookUser = await _fbApi.getFacebookUserInfo(accessToken: _token);
      email = _facebookUser?.email;
      name = _facebookUser?.name;
      //shopUrl = _facebookUser?.name?.toLowerCase()?.replaceAll(" ", "");
      notifyListeners();
      await Future.delayed(const Duration(seconds: 5));
      isShowRegisterForm = true;
      notifyListeners();
    } catch (e, s) {
      logger.error("", e, s);
    }
  }

  void searchCity(String keyword) {
    final key = StringUtils.removeVietnameseMark(keyword.toLowerCase());
    viewCities = _cities
        ?.where((f) => StringUtils.removeVietnameseMark(f.label.toLowerCase())
            .contains(key))
        ?.toList();
    addSubject(_citiSubject, viewCities);
  }

  RegisterTposResult _lastRegisterSubmitResult;

  /// Bước 2. Gửi thông tin đăng kí
  Future<bool> submitRegister() async {
    bool isSuccess = false;
    _lastRegisterSubmitResult = null;
    emailValidate = null;
    phoneValidate = null;
    shopUrlValidate = null;
    onStateAdd(true, message: "Đang đăng ký...");
    try {
      _lastRegisterSubmitResult = await _registerService.registerTpos(
          name: name,
          email: email,
          phone: phone,
          prefix: shopUrl,
          cityCode: _selectedCity?.value,
          message: this.note,
          facebookUserToken: _token);

      if (_lastRegisterSubmitResult.success) {
        onEventAdd(REGISTER_COMPLETE_EVENT, null);
        _analyticService.logSignUpEvent();
        _analyticService.logSignUpWithParamEvent(phone, email);

        // Xác minh số đt sau đó
        //await loginWithPhone();
//        _dialog.showInfo(
//            title: "Hoàn tất đăng kí",
//            content:
//                "Thông tin đăng kí của bạn đã được gửi và đang được xem xét. Có thể mất tới 24h để chúng tôi có thể liên hệ cho bạn");
        isSuccess = true;
      } else {
        if (_lastRegisterSubmitResult.errors != null) {
          this.emailValidate = _lastRegisterSubmitResult.errors?.email?.first;
          this.phoneValidate =
              _lastRegisterSubmitResult.errors?.telephone?.first;
          this.shopUrlValidate =
              _lastRegisterSubmitResult.errors?.prefix?.first;
          this.cityCodeValidate =
              _lastRegisterSubmitResult.errors?.cityCode?.first;
          onEventAdd(REGISTER_ERROR_EVENT, null);

          _dialog.showNotify(
              message: _lastRegisterSubmitResult.message,
              type: DialogType.NOTIFY_ERROR);
        }
        isSuccess = false;
      }
    } catch (e, s) {
      logger.error("", e, s);
      _dialog.showError(error: e);
      isSuccess = false;
    }
    onStateAdd(false);
    return isSuccess;
  }

  /// Bước 3. Gửi thông tin xác thực phone
  Future<void> _submitPhoneAuthentication() async {
    try {
      _lastRegisterSubmitResult = await _registerService.registerTpos(
          name: name,
          email: email,
          phone: phone,
          prefix: shopUrl,
          cityCode: _selectedCity?.value,
          facebookUserToken: _token);
    } catch (e, s) {
      logger.error("", e, s);
      _dialog.showError(error: e);
    }
  }

  /// Xác thực sđt

  Future<bool> confirmPhone({@required String verifyCode}) async {
    bool success = false;
    if (verifyCode == null || verifyCode == "") {
      _dialog.showError(content: "Vui lòng nhập mã code nhận được");
      return false;
    }
    onStateAdd(true, message: "Đang xác nhận...");
    try {
      var verifyResult = await _registerService.verifyPhoneNumber(
          phoneNumber: this.phone,
          hash: _lastRegisterSubmitResult.hash,
          code: verifyCode,
          orderCode: _lastRegisterSubmitResult.data?.orderCode,
          timestamp: _lastRegisterSubmitResult?.data?.timestamp);

      if (verifyResult.success) {
        success = true;
        _setting.shopUrl = "https://${verifyResult?.data?.prefix}.tpos.vn";
        _setting.shopUsername = "admin";
      } else if (verifyResult.message != null) {
        throw Exception(verifyResult.message);
      } else {
        throw Exception("Xác nhận không thành công");
      }
    } catch (e, s) {
      logger.error("", e, s);
      _dialog.showError(error: e);
      success = false;
    }
    onStateAdd(false);
    return success;
  }

  Future<bool> resendCode() async {
    try {
      var result = await _registerService.resendVerifyPhone(
        hash: _lastRegisterSubmitResult?.hash,
        orderCode: _lastRegisterSubmitResult?.data?.orderCode,
        phoneNumber: _lastRegisterSubmitResult.data?.phoneNumber,
        isRequired: _lastRegisterSubmitResult.data?.isRequired,
        time: _lastRegisterSubmitResult?.data?.timestamp,
      );

      _dialog.showNotify(
          type: DialogType.NOTIFY_INFO, message: "Đã gửi lại code tới $phone");
      return true;
    } catch (e, s) {
      logger.error("", e, s);
      _dialog.showNotify(type: DialogType.NOTIFY_ERROR, message: e.toString());
      return false;
    }
  }

  String validatePhone(String value) {
    if (getPhoneNumber(value ?? "") == "") {
      return "Nhập một số điện thoại hợp lệ";
    }

    return phoneValidate;
  }

  String validateShopUrl(String value) {
    if (value == null || value == "") {
      return "Nhập một địa chỉ shop hợp lệ";
    }
    return null;
  }

  void resetServerValidate() {
    phoneValidate = null;
    emailValidate = null;
    shopUrlValidate = null;
    cityCodeValidate = null;
  }

//  FlutterAccountKit akt = FlutterAccountKit();
  bool _isInitialized = false;
//  Future loginWithPhone() async {
//    initAccountKit();
//    try {
//      akt = new FlutterAccountKit();
//
//      LoginResult result = await akt.logInWithPhone();
//
//      switch (result.status) {
//        case LoginStatus.loggedIn:
//          print(result.accessToken.token);
//          // send token to server
//          _submitPhoneAuthentication();
//          break;
//        case LoginStatus.cancelledByUser:
//        // _showCancelledMessage();
//          break;
//        case LoginStatus.error:
//        // _showErrorOnUI();
//          break;
//      }
//    } catch (e, s) {
//      logger.error("", e, s);
//    }
//  }

  Future loginWithEmail() async {}

//  Future initAccountKit() async {
//    print('Init account kit called');
//    bool initialized = false;
//    // Platform messages may fail, so we use a try/catch PlatformException.
//    try {
//      final theme = AccountKitTheme(
//          headerBackgroundColor: Colors.green,
//          buttonBackgroundColor: Colors.yellow,
//          buttonBorderColor: Colors.yellow,
//          buttonTextColor: Colors.black87);
//      await akt.configure(accountKit.Config()
//        ..initialPhoneNumber = PhoneNumber(countryCode: "84", number: phone)
//        ..facebookNotificationsEnabled = true
//        ..receiveSMS = true
//        ..readPhoneStateEnabled = true
//        ..theme = theme);
//      initialized = true;
//    } on PlatformException {
//      print('Failed to initialize account kit');
//    }
//  }

  @override
  void dispose() {
    _citiSubject?.close();
    super.dispose();
  }
}
