import 'package:tpos_api_client/src/models/results/login_result.dart';

abstract class AuthenticationApi {
  Future<LoginResult> login({String url, String username, String password});
  Future<LoginResult> refreshToken({String refreshToken});

  /// Kiểm tra token còn sử dụng được hay không.
  /// Gửi 1 request tới server và chờ phản hồi code 401
  Future<bool> checkToken(String token);
}
