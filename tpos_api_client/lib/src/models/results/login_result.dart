import 'package:tpos_api_client/tpos_api_client.dart';

class LoginResult {
  LoginResult({this.accessToken, this.refreshToken, this.expires, this.user});

  factory LoginResult.fromJson(Map<String, dynamic> json) {
    return LoginResult(
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"],
        user: json['user'] != null ? ApplicationUser.fromJson(json['user']) : null
        // expires: json['.expires'] != null
        //     ? DateFormat("EE, dd MMM yyyy HH:mm:ss GMT").parse(json[".expires"])
        //     : null,
        );
  }

  String accessToken = "";
  String refreshToken = "";
  DateTime expires;
  ApplicationUser user;
}
