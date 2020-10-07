abstract class LoginEvent {}

/// UI được khởi tạo trong initState
class LoginLoaded extends LoginEvent {}

/// Nút đăng nhập được nhấn
class LoginButtonPressed extends LoginEvent {
  LoginButtonPressed({this.shopUrl, this.username, this.password});
  final String shopUrl;
  final String username;
  final String password;
}

/// Xử lý khi nút đăng kí được nhấn
class LoginRegisterPressed extends LoginEvent {}
