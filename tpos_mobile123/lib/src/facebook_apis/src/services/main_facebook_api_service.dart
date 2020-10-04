import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/remote_config_service.dart';
import 'package:tpos_mobile/src/facebook_apis/src/models/GetFacebookPostResult.dart';
import 'package:tpos_mobile/src/facebook_apis/src/models/fetch_facebook_comment_result.dart';
import 'package:tpos_mobile/src/facebook_apis/src/models/send_message_result.dart';
import 'package:w3c_event_source/event_source.dart';

import '../models.dart';
import 'facebook_api_service.dart';

class FacebookApiService implements IFacebookApiService {
  final _log = Logger("FacebookApiService");

  String _accessToken = "";
  final String _requestUrl = "https://graph.facebook.com";
  final Client _client = new Client();

  // Hàm tạo
  FacebookApiService() {
    _log.fine("Facebook api service created");
  }

  Future<String> fbGet({
    String path,
    Map<String, dynamic> param,
    bool useBasePath = true,
    String accessToken,
  }) async {
    String url = path;
    if (param == null) param = Map();
    if (useBasePath) {
      if (param["access_token"] == null)
        param["access_token"] = accessToken ?? _accessToken;
      String content = buildHtmlUrlEncodeFromParam(param);
      url = "$_requestUrl$path?$content";
    }
    _log.info("FACEBOOK API GET " + url);
    var result = await http.get(url);
    _log.info("===>>>>>>Result: " + result.body);
    if (result.statusCode.toString().startsWith("2") != true) {
      throw new Exception(
          "Lỗi get request fbApi. Status code: ${result.statusCode}, Reason: ${result.reasonPhrase}, ${result.body}");
    }

    return result.body;
  }

  Future<Response> fbHttpGet(
      {String path,
      Map<String, dynamic> params,
      String accessToken,
      bool useBasePath = true}) async {
    String url = path;
    if (params == null) params = new Map();
    if (useBasePath) {
      if (params["access_token"] == null)
        params["access_token"] = accessToken ?? _accessToken;
      String content = buildHtmlUrlEncodeFromParam(params);
      url = "$_requestUrl$path?$content";
    }
    _log.info("FACEBOOK API GET " + url);
    var result = await http.get(url);
    _log.info("===>>>>>>Result: " + result.body);
    return result;
  }

  Future<Response> _httpGet(
      {String path, Map<String, dynamic> params, String accessToken}) async {
    String queryString = buildHtmlUrlEncodeFromParam(params);
    String url =
        "$_requestUrl$path${queryString != null ? "?access_token=$accessToken&$queryString" : "?access_token=$accessToken"}";

    return await _client.get(url);
  }

  Future<Response> _httpPost(
      {String path,
      Map<String, dynamic> params,
      Map<String, dynamic> body,
      Map<String, dynamic> headers,
      String contentType = "application/x-www-form-urlencoded"}) async {
    String queryString = buildHtmlUrlEncodeFromParam(params);
    String url =
        "$_requestUrl$path${queryString != null ? "?$queryString" : ""}";
    _log.info("FB API POST: $url");
    return await _client
        .post(
      url,
      body: body,
      headers: headers ??
          {
            "Content-Type": "$contentType",
          },
    )
        .then((value) {
      _log.info("FB API RESULT: ${value.body}");
      return value;
    });
  }

  String buildHtmlUrlEncodeFromParam(Map<String, dynamic> param) {
    if (param != null && param.isNotEmpty)
      return param.keys.map((key) => "${(key)}=${(param[key])}").join("&");
    else
      return "";
  }

  @override
  void setNewFacebookLogin(String accessToken, DateTime dateExpire) {
    _accessToken = accessToken;
  }

  /// Lấy danh sách Page của user facebook
  Future<List<FacebookAccount>> getFacebookAccount({String accessToken}) async {
    List<FacebookAccount> facebookAccount;
    await http
        .get(
            "$_requestUrl/v3.2/me/accounts?access_token=$accessToken&fields=access_token,category,name,id,picture")
        .then((response) {
      _log.info(response.body);
      if (response.statusCode == 200) {
        final String json = response.body;
        final jsonMap = jsonDecode(json);
        final mapDataList = jsonMap["data"] as List;
        final data = mapDataList.map((item) {
          return FacebookAccount.fromMap(item);
        }).toList();

        facebookAccount = data;
      } else {
        final String json = response.body;
        final jsonMap = jsonDecode(json);

        var error = FacebookApiError.fromJson(jsonMap["error"]);
        throw Exception(error.message);
      }
    });

    return facebookAccount;
  }

  /// Lấy danh sách bài viết theo access token
  Future<List<FacebookPost>> getFacebookPost(
      {String pageId, String accessToken, bool isMeAccount}) async {
    List<FacebookPost> data;
    await http
        .get(
            "$_requestUrl/v3.2/$pageId$_facebookFeedPath?fields=id,type,status_type,story,caption,description,message,created_time,updated_time,picture,from{id,name,picture},comments.summary(true),reactions.summary(true)&access_token=${accessToken == "" ? _accessToken : accessToken}")
        .then((response) {
      if (response.statusCode == 200) {
        String json = response.body;
        var jsonMap = jsonDecode(json);
        var mapDataList = jsonMap["data"] as List;
        data = mapDataList.map((item) {
          return FacebookPost.fromMap(item);
        }).toList();
      } else {
        throw new Exception(
            "Lỗi request " + response.statusCode.toString() + "");
      }
    });

    return data;
  }

  String get _facebookFeedPath =>
      locator<RemoteConfigService>().facebookFeedPath ?? '/posts';

  /// Lấy danh sách bài viết theo access token
  Future<GetFacebookPostResult> getFacebookPostWithPaging(
      {String pageId,
      String accessToken,
      FacebookListPaging paging,
      int take = 20,
      String type}) async {
    assert(accessToken != null);
    assert(pageId != null);
    if (pageId == null && accessToken == null) {
      throw NullThrownError();
    }
    if (paging != null && paging.next != null) {
      var jsonResult = await fbGet(
          path: paging.next, useBasePath: false, accessToken: accessToken);
      return GetFacebookPostResult.fromMap(jsonDecode(jsonResult));
    } else {
      if (type == "all") type = null;
      var response = await fbHttpGet(
        path: "/v3.2/$pageId$_facebookFeedPath",
        params: {
          "fields":
              "id,type,status_type,caption,description,message,created_time,updated_time,picture,from{id,name,picture},comments.limit(0).summary(true),reactions.limit(0).summary(true)",
          "access_token": accessToken,
          "limit": take,
          "type": type,
        }..removeWhere((key, value) => value == null),
      );

      return GetFacebookPostResult.fromMap(jsonDecode(response.body));
    }
  }

  Future loginFacebook() async {
    var facebookLogin = new FacebookLogin();
    var result =
        await facebookLogin.logIn(["email", "user_posts", "user_friends"]);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        // _sendTokenToServer(result.accessToken.token);
        //_showLoggedInUI();
        break;
      case FacebookLoginStatus.cancelledByUser:
        //_showCancelledMessage();
        break;
      case FacebookLoginStatus.error:
        //_showErrorOnUI(result.errorMessage);
        break;
    }
  }

  @override
  Future logoutFacebook() {
    this._accessToken = "";
    return Future.value();
  }

  /// Lấy thông tin tài khoản đăng nhập , id, name
  @override
  Future<FacebookUser> getFacebookUserInfo({String accessToken}) async {
    var result = await fbGet(path: "/v3.2/me", param: {
      "access_token": accessToken,
      'fields': "id, name, picture, email",
    });
    return FacebookUser.fromMap(jsonDecode(result));
  }

  @override
  String getAccessToken() {
    return _accessToken;
  }

  Future<EventSource> fetchCommentInRealTime(
      String liveId, String accessToken, callBack) async {
    var events = EventSource(Uri.parse(
        'https://streaming-graph.facebook.com/$liveId/live_comments?access_token=$accessToken&%20comment_rate=one_hundred_per_second&%20fields=from{name,id},message'));

    final subscription = events.events.listen((MessageEvent message) {
      callBack(FacebookComment.fromMap(json.decode(message.data)));
    });

    // Auto close connection after 4h
    Timer(Duration(hours: 4), () {
      subscription.cancel();
    });
    return events;
  }

  @override
  Future<FetchFacebookCommentResult> fetchCommentWithPaging(
      {String postId,
      String accessToken,
      bool isNewestOnTop = true,
      int limit = 50}) async {
    Map<String, dynamic> requestParam = {
      "fields":
          "id,is_hidden,message,view_id,from{id,name,picture},created_time,comments.order(chronological).limit(50){id,message,created_time,is_hidden,from{id,name,picture}}",
      "limit": limit,
      "live_filter": "no_filter",
      "order": isNewestOnTop ? "reverse_chronological" : "chronological",
    };
    var json = await fbGet(
      accessToken: accessToken,
      path: "/v3.2/$postId/comments",
      param: requestParam,
    );

    return FetchFacebookCommentResult.fromMap(
      jsonDecode(json),
    );
  }

  Future<void> fetchAllFacebookComment(
      {String postId,
      String accessToken,
      Function callBack,
      int limit = 100}) async {
    Map<String, dynamic> requestParam = {
      "fields":
          "id,is_hidden,message,view_id,from{id,name,picture},created_time,comments.order(chronological).limit(50){id,message,created_time,is_hidden,from{id,name,picture}}",
      "limit": "50",
      "live_filter": "no_filter",
      "order": "reverse_chronological"
    };

    var json = await fbGet(
      accessToken: accessToken,
      path: "/v3.2/$postId/comments",
      param: requestParam,
    );
  }

  @override
  Future<FetchFacebookCommentResult> fetchReplyComment(String commentParentId,
      {String accessToken, bool isNewestOnTop}) async {
    Map<String, dynamic> requestParam = {
      "fields":
          "id,is_hidden,message,view_id,from{id,name,picture},created_time",
      "limit": "50",
      "live_filter": "no_filter",
      "order": isNewestOnTop ? "reverse_chronological" : "chronological",
    };
    var json = await fbGet(
      accessToken: accessToken,
      path: "/v3.2/$commentParentId/comments",
      param: requestParam,
    );

    return FetchFacebookCommentResult.fromMap(jsonDecode(json));
  }

  @override
  Future<FetchFacebookCommentResult> fetchMoreCommentWithPaging(
      FacebookListPaging paging, String accessToken,
      {int limit = 50}) async {
    var json = await fbGet(
      path: paging.next,
      accessToken: accessToken,
      useBasePath: false,
    );

    return FetchFacebookCommentResult.fromMap(
      jsonDecode(json),
    );
  }

  @override
  Future<List<FacebookComment>> fetchTopComment(
      {@required String postId,
      int top,
      String accessToken,
      DateTime lastTime}) async {
    Map<String, dynamic> params = {
      "fields":
          "id,is_hidden,message,view_id,from{id,name,picture},created_time,comments.order(chronological).limit(50){id,message,created_time,from{id,name,picture}}",
      "limit": "50",
      "live_filter": "no_filter",
      "order": "reverse_chronological",
    };

    if (lastTime != null) {
      params["since"] = lastTime.toIso8601String();
    }
    var json = await fbGet(
      path: "/v3.2/$postId/comments",
      accessToken: accessToken,
      param: params,
    );

    var jsonMap = jsonDecode((json));
    return (jsonMap["data"] as List)
        .map((f) => FacebookComment.fromMap(f))
        .toList();
  }

  @override
  Future<FacebookPost> getFacebookPostById(String postId,
      [String accessToken]) async {
    assert(accessToken != null);
    assert(postId != null);
    var response = await fbHttpGet(
      path: "/v3.3/$postId",
      params: {
        "fields":
            "id,story,caption,description,message,created_time,updated_time,picture,from{id,name,picture},comments.summary(true),reactions.summary(true)",
        "access_token": accessToken,
      },
    );
    if (response.statusCode == 200) {
      return (FacebookPost.fromMap(jsonDecode(response.body)));
    } else {
      throwFacebookErrorException(response);
    }
    return null;
  }

  @override
  Future<String> replyPageComment(
      {String commentId, String message, String accessToken}) async {
    var reponse = await _httpPost(
      path: "/v3.2/$commentId/comments",
      params: {
        "access_token": accessToken,
      },
      body: {
        "method": "post",
        "message": message,
      },
    );

    if (reponse.statusCode == 200) {
      return (jsonDecode(reponse.body))["id"];
    } else {
      throw new Exception("${reponse.statusCode}, ${reponse.reasonPhrase}");
    }
  }

  @override
  Future<void> hiddenComment({
    @required String commentId,
    @required accessToken,
    bool isHidden = true,
  }) async {
    assert(commentId != null && commentId != "");
    assert(accessToken != null && accessToken != "");
    var response = await _httpPost(path: "/v3.2/$commentId", params: {
      "access_token": accessToken
    }, body: {
      "is_hidden": "$isHidden",
      "method": "post",
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body)["success"];
    } else {
      throw new Exception(
          FacebookApiError.fromJson(jsonDecode(response.body)["error"])
              .message);
    }
  }

  @override
  Future<List<BatchResult>> getLiveVideoBatch(
      List<String> postIds, String accessToken) async {
    // build batch query
    var queries = postIds
        .map((f) => {
              "method": "GET",
              "relative_url":
                  "$f?fields=id,description,live_status,status,title",
            })
        .toList();

    var response = await _httpPost(path: "/v3.2/me", params: {
      "access_token": accessToken
    }, body: {
      "batch": jsonEncode(queries),
      "include_headers": "false",
      "method": "post",
      "pretty": "0",
      "suppress_http_code": "1",
    });

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((f) => BatchResult.fromJson(f))
          .toList();
    }
    throwFacebookErrorException(response);
    return null;
  }

  /// https://graph.facebook.com/v3.3/me/messages?access_token=<PAGE_ACCESS_TOKEN>
  @override
  Future<SendMessageResult> sendPageMessage(
      {String accessToken, String psid, String message}) async {
    assert(accessToken != null && psid != null && message != null);
    var response = await _client.post(
      "https://graph.facebook.com/v3.3/me/messages?access_token=$accessToken",
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(
        {
          "messaging_type": "RESPONSE",
          "recipient": {"id": psid},
          "message": {
            "text": message,
          }
        },
      ),
    );

    if (response.statusCode == 200) {
      return SendMessageResult.fromJson(jsonDecode(response.body));
    } else {
      throwFacebookErrorException(response);
    }

    return null;
  }

  void throwFacebookErrorException(http.Response response) {
    var error = FacebookApiError.fromJson(jsonDecode(response.body)["error"]);
    throw new Exception(error.toString());
  }

  @override
  Future<LiveVideo> getLiveVideo(
      {@required accessToken, String liveVideoId}) async {
    assert(liveVideoId != null);
    assert(accessToken != null);

    var response = await _httpGet(
        path: "/v4.0/$liveVideoId",
        accessToken: accessToken,
        params: {"fields": "live_status,id"});

    if (response.statusCode == 200) {
      return LiveVideo.fromJson(
        (jsonDecode(response.body)),
      );
    }

    throwFacebookErrorException(response);
    return null;
  }
}
