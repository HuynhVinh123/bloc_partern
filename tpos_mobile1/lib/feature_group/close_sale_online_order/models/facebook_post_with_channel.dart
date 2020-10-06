import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/src/facebook_apis/src/models/facebook_post.dart';


class FacebookPostWithChannel {
  FacebookPostWithChannel({this.crmTeam, this.post});

  /// Kênh bán hàng của bài live
  CRMTeam crmTeam;

  /// Bài đăng facebook
  FacebookPost post;
}
