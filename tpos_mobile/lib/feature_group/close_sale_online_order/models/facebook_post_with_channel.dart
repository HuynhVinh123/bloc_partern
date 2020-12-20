import 'package:facebook_api_client/facebook_api_client.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

class FacebookPostWithChannel {
  FacebookPostWithChannel({this.crmTeam, this.post});

  /// Kênh bán hàng của bài live
  CRMTeam crmTeam;

  /// Bài đăng facebook
  FacebookPost post;
}
