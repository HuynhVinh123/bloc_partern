import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:logging/logging.dart';

class RemoteConfigService {
  Logger _log = new Logger("RemoteConfigService");
  RemoteConfig _remoteConfig = new RemoteConfig();
  RemoteConfig get remoteConfig => _remoteConfig;
  Future<void> setupRemoteConfig() async {
    _remoteConfig = await RemoteConfig.instance;
    // Enable developer mode to relax fetch throttling
    _remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));
    _remoteConfig.setDefaults(<String, dynamic>{
      'android_last_version': "",
      'ios_lastest_version': "",
      'update_required_message': 'Phiên bản mới đã sẵn sàng để cập nhật!',
      "current_android_version": "",
      "current_ios_version": "",
      "crash_report_server_name": "sentry",
      "facebook_option":
          '{"permissions":["email public_profile user_likes user_posts user_videos publish_video pages_show_list manage_pages publish_pages pages_messaging groups_access_member_info pages_messaging pages_messaging_subscriptions"],"enable_fetch_duration_user":true}',
      "calculateFeeCarriers":
          '{"value":["ViettelPost","GHN","TinToc","SuperShip","FlashShip","OkieLa","MyVNPost","JNT","FulltimeShip", "BEST"]}',
      'facebookFeedPath': '/posts'
    });
  }

  Future<void> fetchLastestConfig() async {
    try {
      await _remoteConfig.fetch(expiration: const Duration(seconds: 0));
      await _remoteConfig.activateFetched();
    } catch (e, s) {
      _log.severe("", e, s);
    }
  }

  String get androidLastVersion =>
      _remoteConfig.getString("android_last_version");

  String get iosLastVersion => _remoteConfig.getString("ios_lastest_version");
  String get facebookFeedPath => _remoteConfig.getString('facebookFeedPath');

  UpdateNotify get currentAndroidVersion {
    String objString = _remoteConfig.getString("current_android_version");
    if (objString != null && objString != "") {
      return UpdateNotify.fromJson(jsonDecode(objString));
    } else {
      return null;
    }
  }

  UpdateNotify get currentIosVersion {
    String objString = _remoteConfig.getString("current_ios_version");
    if (objString != null && objString != "") {
      return UpdateNotify.fromJson(jsonDecode(objString));
    } else {
      return null;
    }
  }

  String get crashReportServerName =>
      _remoteConfig.getString("crash_report_server_name");

  FacebookOption get facebookOption {
    String jsonFacebookOption = _remoteConfig.getString("facebook_option");
    if (jsonFacebookOption != null && jsonFacebookOption != "") {
      return FacebookOption.fromJson(jsonDecode(jsonFacebookOption));
    }
    return null;
  }

  List<String> get calculateFeeCarriers {
    String json = _remoteConfig.getString("calculateFeeCarriers");
    return (jsonDecode(json)["value"]).cast<String>();
  }
}

class UpdateNotify {
  String version;
  int buildNumber;
  bool notifyEnable;
  String notifyTitle;
  String notifyContent;

  UpdateNotify(
      {this.version, this.notifyEnable, this.notifyTitle, this.notifyContent});

  UpdateNotify.fromJson(Map<String, dynamic> json) {
    version = json["version"];
    notifyEnable = json["notify_enable"] ?? false;
    notifyTitle = json["notify_title"] ?? "";
    notifyContent = json["notify_content"] ?? "";
    buildNumber = json["build_number"] ?? 0;
  }
}

class FacebookOption {
  List<String> permissions = new List<String>();
  bool enableFetchDurationUser;
  FacebookOption.fromJson(Map<String, dynamic> json) {
    permissions =
        (json["permissions"] as List).map((f) => f.toString()).toList();
    enableFetchDurationUser = json["enable_fetch_duration_user"];
  }
}
