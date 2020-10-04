import 'package:intl/intl.dart';

class LoginResult {
  String accessToken = "";
  String refreshToken = "";
  DateTime expires;

  factory LoginResult.fromJson(Map<String, dynamic> json) {
    return LoginResult(
      accessToken: json["access_token"],
      refreshToken: json["refresh_token"],
      // expires: json['.expires'] != null
      //     ? DateFormat("EE, dd MMM yyyy HH:mm:ss GMT").parse(json[".expires"])
      //     : null,
    );
  }

  LoginResult({this.accessToken, this.refreshToken, this.expires});
}
