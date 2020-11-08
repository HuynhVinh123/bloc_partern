// import 'dart:io';
//
// import 'package:tpos_mobile/app.dart';
// import 'package:tpos_mobile/app_core/helper/string_helper.dart';
// import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
// import 'package:tpos_mobile/app_route_old.dart';
// import 'package:tpos_mobile/locator.dart';
// import 'package:tpos_mobile/services/app_setting_service.dart';
//
// import 'package:tpos_mobile/services/authentication_service.dart';
// import 'package:tpos_mobile/services/dialog_service.dart';
// import 'package:tpos_mobile/services/navigation_service.dart';
// import 'package:tpos_mobile/services/remote_config_service.dart';
// import 'package:tpos_mobile/src/tpos_apis/models/application_user.dart';
// import 'package:tpos_mobile/src/tpos_apis/models/company.dart';
// import 'package:tpos_mobile/src/tpos_apis/models/company_current_info.dart';
// import 'package:tpos_mobile/src/tpos_apis/models/web_app_route.dart';
// import 'package:tpos_mobile/src/tpos_apis/services/object_apis/application_user_api.dart';
// import 'package:tpos_mobile/src/tpos_apis/services/object_apis/company_api.dart';
// import 'package:tpos_mobile/src/tpos_apis/services/object_apis/notification_api.dart';
// import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
// import 'package:tpos_mobile/src/tpos_apis/models/notification.dart'
//     as notificatoinModel;
//
// import '../../app_route.dart';
//
// ///Viewmodel toàn bộ app
// ///Chứa các thông tin toàn bộ ứng dụng
// class ApplicationViewModel extends ViewModel {
//   static const EVENT_AVAIABLE_UPDATE = "AVAIBLE_UPDATE";
//
//   ISettingService _setting;
//   DialogService _dialog;
//   ITposApiService _tposApi;
//   ICompanyApi _companyApi;
//   IApplicationUserApi _applicationUserApi;
//   IAuthenticationService _authenticationService;
//   INotificationApi _notificatonApi;
//   RemoteConfigService _remoteConfig;
//   final NavigationService _navigation = locator<NavigationService>();
//   ApplicationViewModel(
//       {ISettingService settingService,
//       DialogService dialog,
//       ICompanyApi companyApi,
//       IAuthenticationService authenticationService,
//       INotificationApi notificationApi,
//       IApplicationUserApi applicationUserApi,
//       RemoteConfigService remoteConfig,
//       ITposApiService tposApiService}) {
//     _setting = settingService ?? locator<ISettingService>();
//     _dialog = dialog ?? locator<DialogService>();
//     _tposApi = tposApiService ?? locator<ITposApiService>();
//     _companyApi = companyApi ?? locator<ICompanyApi>();
//     _authenticationService =
//         authenticationService ?? locator<IAuthenticationService>();
//     _applicationUserApi = applicationUserApi ?? locator<IApplicationUserApi>();
//     _remoteConfig = remoteConfig ?? locator<RemoteConfigService>();
//     _notificatonApi = notificationApi ?? locator<INotificationApi>();
//   }
//
//   /// Thông tin công ty hiện tại
//   /// Tải sau khi đăng nhập hoặc app được khởi động
//   Company _company;
//
//   /// Danh sách công ty khả dụng hiện tại bao gồm công ty đang chọn hiện tại
//   CompanyCurrentInfo _companyCurrentInfo;
//
//   /// Thông tin tài khoản đang đăng nhập hiện tại
//   /// Tải sau khi đăng nhập hoặc app được khởi động
//   ApplicationUser _loginUser;
//
//   /// Lỗi hiển thị nếu khởi tạo thất bại
//   Exception _lastException;
//
//   /// Cấu hình hệ thống và người dùng
//   /// Phải tải sau khi đăng nhập và khi mở ứng dụng
//   WebUserConfig _webUserConfig;
//
//   /// Thông báo cập nhật gần nhất
//   UpdateNotify _lastUpdateNotify;
//
//   /// Số lượng  thông báo chưa đóng
//   int _notreadNotifyCount = 0;
//
//   /// Thông báo popup cuối
//   notificatoinModel.Notification _notification;
//
//   Company get company => _company;
//   ApplicationUser get loginUser => _loginUser;
//   Exception get lastException => _lastException;
//   UpdateNotify get lastUpdateNotify => _lastUpdateNotify;
//   CompanyCurrentInfo get companyCurrentInfo => _companyCurrentInfo;
//   int get notReadNotifyCount => _notreadNotifyCount;
//   notificatoinModel.Notification get notification => _notification;
//
//   /// Danh sách quyền
//   List<String> get userPermission => _webUserConfig?.functions;
//   List<String> get userFieldPermission => _webUserConfig?.fields;
//
//   void setNotReadNotifyCount(int value, {dynamic notify}) {
//     _notreadNotifyCount = value;
//     if (notify != null) {
//       this._notification = notify;
//     }
//     notifyListeners();
//   }
//
//   /// Tài dữ liêu từ server
//   /// Công ty hiện tại, tài khoản đăng nhập hiện tại.
//   /// Khởi chạy khi tải trang chủ
//   Future<void> initData() async {
//     onStateAdd(true, message: "Đang tải...");
//     try {
//       var tokenIsValid = await _tposApi.checkTokenIsValid();
//       if (!tokenIsValid) {
//         await locator<IAuthenticationService>().logout();
//         _navigation.navigateAndPopUntil(AppRoute.login);
//         return;
//       }
//       await Future.wait([
//         _loadUserConfig(),
//         _loadCurrentUser(),
//         _loadCurrentCompany(),
//         _remoteConfig.fetchLastestConfig(),
//       ]);
//
//       _loadNotreadNotify().then((value) {
//         notifyListeners();
//       }).catchError((e, s) {
//         logger.error("", e, s);
//         _dialog.showNotify(
//             message: e.toString(), type: DialogType.NOTIFY_ERROR);
//       });
//
//       _lastException = null;
//       notifyListeners();
//     } on SocketException catch (e, s) {
//       logger.error("", e, s);
//       _lastException = e;
//       _dialog.showNotify(
//           type: DialogType.NOTIFY_ERROR,
//           message: "Không kết nối được máy chủ. Vui lòng thử lại",
//           showOnTop: false,
//           title: "Error");
//     } catch (e, s) {
//       logger.error("", e, s);
//       _lastException = e;
//       _dialog.showNotify(
//           type: DialogType.NOTIFY_ERROR,
//           message: e.toString(),
//           showOnTop: false,
//           title: "Error");
//     }
//     onStateAdd(false);
//
//     // Kiểm tra cập nhật
//     _checkForUpdate();
//   }
//
//   Future _loadUserConfig() async {
//     _webUserConfig = await _applicationUserApi.getUserConfig();
//   }
//
//   /// Lấy thông tin tài khoản đăng nhập
//   Future _loadCurrentUser() async {
//     this._loginUser = await _applicationUserApi.getCurrentUser();
//   }
//
//   /// Lấy thông tin công ty hiện tại
//   Future _loadCurrentCompany() async {
//     var currentCompanyInfo = await _companyApi.getCompanyCurrent();
//     this._company = await _companyApi.getById(currentCompanyInfo.companyId);
//     this._companyCurrentInfo =
//         await _applicationUserApi.getCompanyCurrentInfo();
//   }
//
//   Future _loadNotreadNotify() async {
//     var getNotReadResult = await _notificatonApi.getNotRead();
//     _notreadNotifyCount = getNotReadResult.count;
//     _notification = getNotReadResult.popup;
//   }
//
//   Future markPopupNotifyReaded() async {
//     try {
//       if (_notification != null) {
//         await _notificatonApi.markRead(_notification.id);
//         _notification = null;
//         notifyListeners();
//       }
//     } catch (e, s) {
//       logger.error("", e, s);
//       _dialog.showNotify(message: e.toString(), type: DialogType.NOTIFY_ERROR);
//     }
//   }
//
//   /// Đổi công ty hiện tại
//   Future<void> switchCompany(int targetCompanyId) async {
//     try {
//       // call switch company
//       await _applicationUserApi.switchCompany(targetCompanyId);
//       // refresh access token
//       await _authenticationService.refreshToken();
//       await this.initData();
//       notifyListeners();
//     } catch (e, s) {
//       logger.error("switchCompany", e, s);
//     }
//   }
//
//   /// Kiểm tra tài khoản có quyền với permissionName hay không
//   bool checkPermission(String permissionName) {
//     return userPermission?.any((f) => f == permissionName);
//   }
//
//   /// Kiểm tra cập nhật ứng dụng
//   Future<void> _checkForUpdate() async {
//     try {
//       UpdateNotify _checkUpdateResult;
//       if (Platform.isAndroid) {
//         // Andoird
//         _checkUpdateResult = _remoteConfig.currentAndroidVersion;
//       } else if (Platform.isIOS) {
//         _checkUpdateResult = _remoteConfig.currentIosVersion;
//       }
//
//       logger.debug(
//           "App Version${_checkUpdateResult?.version}; Build: ${_checkUpdateResult?.buildNumber}");
//
//       if (_checkUpdateResult != null &&
//           _checkUpdateResult.version != null &&
//           _checkUpdateResult.notifyEnable == true &&
//           App.appVersion != null &&
//           compareVersion(_checkUpdateResult.version, App.appVersion)) {
//         _lastUpdateNotify = _checkUpdateResult;
//         notifyListeners();
//       } else {
//         // Không có update
//         _lastUpdateNotify = null;
//         notifyListeners();
//       }
//     } catch (e, s) {
//       logger.error("CheckForUpdate", e, s);
//       _dialog.showNotify(
//           type: DialogType.NOTIFY_ERROR,
//           message: "Kiểm tra cập nhật đã xảy ra lỗi: ${e.toString()}");
//     }
//   }
// }
