abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

/// Xử lý sau khi Loaed được gọi. Trả về biến đã lưu [shopUrl] và [username]
class LoginLoadSuccess extends LoginState {
  LoginLoadSuccess({this.shopUrl, this.username});
  final String shopUrl;
  final String username;
}

/// Đăng nhập thành công
class LoginSuccess extends LoginState {}

/// Đăng nhập thất bại
class LoginFailure extends LoginState {
  LoginFailure({this.message});
  final String message;
}

class LoginValidateFailure extends LoginState {
  LoginValidateFailure(this.message);
  final String message;
}

/// Đang đăng nhập
class LoginLogging extends LoginState {}
