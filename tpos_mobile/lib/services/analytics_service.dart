import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics();

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  /// Thiết lập thông tin người dùng (email đăng nhập)
  Future<void> setUserId({String userId}) async {
    await _analytics.setUserId(userId);
  }

  Future<void> setUserProperty({String name, String value}) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  /// Log sự kiện đăng nhập
  Future<void> logLoginEvent() async {
    await _analytics.logLogin(loginMethod: "email");
  }

  /// Log sự kiện đăng ký thành công
  Future<void> logSignUpEvent() async {
    await _analytics.logSignUp(signUpMethod: "email");
  }

  /// Log sự kiện nhấn vào nút đăng ký ứng dụng
  Future<void> logRegisterButtonPressed() async {
    await _analytics.logEvent(name: 'register_button_pressed');
  }

  Future<void> logSignUpWithParamEvent(String phone, String email) async {
    await _analytics.logEvent(
      name: 'signUpCompleted',
      parameters: {
        'phone': phone,
        "email": email,
      },
    );
  }

  /// Log sự kiện hóa đơn bán hàng nhanh đã được tạo thành công
  Future<void> logFastSaleOrderCreated() async {
    await _analytics.logEvent(name: 'fast_sale_order_created');
  }

  /// Log sự kiện hóa đơn bán hàng nhanh có chọn đối tác giao hàng được tạo thành công
  Future<void> logFastSaleOrderCreatedWithCarrier(
      {String carrierType, String shopUrl, int shippingFee}) async {
    await _analytics.logEvent(
      name: 'fast_sale_order_has_carrier_created',
      parameters: {
        'carrierType': carrierType,
        "shopUrl": shopUrl,
        "shippingFee": shippingFee,
      },
    );
  }

  /// Log sự kiện tạo hóa đơn bán hàng nhanh từ đơn hàng sale online
  Future<void> logCreateFastSaleOrderFromDefaultProduct(
      {String carrierType = "N/A", String shopUrl = "N/A"}) async {
    await _analytics.logEvent(
      name: 'fast_sale_order_default_created',
      parameters: {
        'carrierType': carrierType,
        "shopUrl": shopUrl,
      },
    );
  }

  Future<void> logOpenRegisterPage() async {
    await _analytics.logEvent(name: "open_register_page");
  }
}
