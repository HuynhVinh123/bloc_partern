import 'package:flutter/cupertino.dart';

abstract class ApplicationEvent {}

class ApplicationLoaded extends ApplicationEvent {}

/// Yêu cầu đăng xuất ứng dụng
class ApplicationLogout extends ApplicationEvent {}

/// Thay đổi ngôn ngữ
class ApplicationLanguageChanged extends ApplicationEvent {
  ApplicationLanguageChanged(this.locale);
  final Locale locale;
}

/// Khởi động lại ứng dụng
class ApplicationRestarted extends ApplicationEvent {}
