/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:tpos_mobile/src/facebook_apis/src/models/GetFacebookPostResult.dart';
import 'package:http/http.dart';
import 'package:tpos_mobile/src/facebook_apis/src/models/fetch_facebook_comment_result.dart';

import 'package:tpos_mobile/src/facebook_apis/src/models/send_message_result.dart';
import 'package:w3c_event_source/event_source.dart';

import '../models.dart';

abstract class IFacebookApiService {
  Future loginFacebook();
  Future logoutFacebook();
  void setNewFacebookLogin(String accessToken, DateTime dateExpire);
  Future<List<FacebookAccount>> getFacebookAccount(
      {@required String accessToken});
  Future<List<FacebookPost>> getFacebookPost(
      {String pageId, String accessToken, bool isMeAccount});

  Future<GetFacebookPostResult> getFacebookPostWithPaging({
    String pageId,
    String accessToken,
    FacebookListPaging paging,
    int take = 20,
    String type,
  });

  /// Lấy thông tin bài đăng theo id bài đăng
  Future<FacebookPost> getFacebookPostById(String postId, [String accessToken]);

  Future<FacebookUser> getFacebookUserInfo({String accessToken});

  String getAccessToken();

  Future<FetchFacebookCommentResult> fetchCommentWithPaging(
      {String postId,
      String accessToken,
      bool isNewestOnTop = true,
      int limit = 50});

  /// Lấy thêm bình luận theo paging
  Future<FetchFacebookCommentResult> fetchMoreCommentWithPaging(
      FacebookListPaging paging, String accessToken,
      {int limit = 50});
  Future<EventSource> fetchCommentInRealTime(
      String liveId, String accessToken, callBack);

  /// Lấy 50 bình luận đầu
  Future<List<FacebookComment>> fetchTopComment(
      {@required int top,
      String accessToken,
      @required String postId,
      DateTime lastTime});

  /// Trả lời bình luận facebook
  /// Trả về
  Future<String> replyPageComment(
      {String commentId, String message, String accessToken});

  /// Ẩn bình luận facebook
  Future<void> hiddenComment(
      {@required String commentId,
      @required accessToken,
      bool isHidden = true});

  /// Lấy bình luận trả lời
  Future<FetchFacebookCommentResult> fetchReplyComment(String commentParentId,
      {String accessToken, bool isNewestOnTop});

  /// Gủi tin nhắn tới người dùng
  Future<SendMessageResult> sendPageMessage({
    @required String accessToken,
    @required String psid,
    @required String message,
  });

  Future<LiveVideo> getLiveVideo({@required accessToken, String liveVideoId});

  Future<List<BatchResult>> getLiveVideoBatch(
      List<String> postIds, String accessToken);
}

void getFacebookResult(Response reponse) {}

class FacebookApiError {
  String message;
  String type;
  int code;
  int errorSubcode;
  String errorUserTitle;
  String errorUserMsg;
  String fbtraceId;

  FacebookApiError(
      {this.message,
      this.type,
      this.code,
      this.errorSubcode,
      this.errorUserTitle,
      this.errorUserMsg,
      this.fbtraceId});

  FacebookApiError.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    type = json['type'];
    code = json['code'];
    errorSubcode = json['error_subcode'];
    errorUserTitle = json['error_user_title'];
    errorUserMsg = json['error_user_msg'];
    fbtraceId = json['fbtrace_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['type'] = this.type;
    data['code'] = this.code;
    data['error_subcode'] = this.errorSubcode;
    data['error_user_title'] = this.errorUserTitle;
    data['error_user_msg'] = this.errorUserMsg;
    data['fbtrace_id'] = this.fbtraceId;
    return data;
  }

  String toString() {
    return "${this.message}";
  }
}

class FacebookApiResult<T> {
  FacebookApiError error;
  T data;
  FacebookApiResult({this.error, this.data, Function getData});

  FacebookApiResult.fromJson(Map<String, dynamic> json, Function getData) {
    if (json["error"] != null) {
      this.error = FacebookApiError.fromJson(json["error"]);
    }

    if (getData != null) {
      data = getData();
    }
  }
}

class FacebookApiErrorCode {}
