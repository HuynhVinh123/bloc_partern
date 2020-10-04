import 'package:tpos_mobile/src/facebook_apis/src/models/GetFacebookPostResult.dart';
import 'package:tpos_mobile/src/facebook_apis/src/models/fetch_facebook_comment_result.dart';
import 'package:tpos_mobile/src/facebook_apis/src/models/send_message_result.dart';
import 'package:w3c_event_source/event_source.dart';

import '../models.dart';
import 'facebook_api_service.dart';

class MockFacebookApiService implements IFacebookApiService {
  List<FacebookAccount> _facebookAccounts = new List<FacebookAccount>();
  List<FacebookPost> _facebookPost = new List<FacebookPost>();
  List<FacebookComment> _facebookComment = new List<FacebookComment>();

  MockFacebookApiService() {
    _facebookAccounts.add(new FacebookAccount(
        id: "2134", accessToken: "2l34k34", name: "Cá nhân"));

    _facebookAccounts.add(new FacebookAccount(
        id: "2", accessToken: "2l34k34", name: "Trang bán hàng"));

    _facebookPost.add(
      new FacebookPost(
          id: "post1",
          name: "0239",
          createdTime: DateTime.now(),
          message: "Bài đăng số 1. Nhấp để xem chi tiết bài đăng",
          totalComment: 10,
          picture:
              "https://cdn4.iconfinder.com/data/icons/social-media-icons-the-circle-set/48/facebook_circle-512.png",
          toltalLike: 20),
    );
    _facebookPost.add(new FacebookPost(
        id: "post2",
        name: "0239",
        createdTime: DateTime.now(),
        picture:
            "https://cdn4.iconfinder.com/data/icons/social-media-icons-the-circle-set/48/facebook_circle-512.png",
        message: "Bài đăng số 2. Nhấp để xem chi tiết bài đăng",
        totalComment: 20,
        toltalLike: 30));

    _facebookPost.add(new FacebookPost(
        id: "post3",
        name: "0239",
        createdTime: DateTime.now(),
        message: "Bài đăng số 3. Nhấp để xem chi tiết bài đăng",
        totalComment: 90,
        picture:
            "https://cdn4.iconfinder.com/data/icons/social-media-icons-the-circle-set/48/facebook_circle-512.png",
        toltalLike: 30));

    for (int i = 0; i <= 100; i++) {
      _facebookPost.add(new FacebookPost(
          id: "post3",
          name: "0239",
          createdTime: DateTime.now(),
          message: "Bài đăng số 3. Nhấp để xem chi tiết bài đăng",
          totalComment: 90,
          picture:
              "https://cdn4.iconfinder.com/data/icons/social-media-icons-the-circle-set/48/facebook_circle-512.png",
          toltalLike: 30));
    }

    for (int i = 0; i <= 20000; i++) {
      _facebookComment.add(
        new FacebookComment(
          id: i.toString(),
          message: "Đây là comment thứ $i",
          createdTime: DateTime.now(),
        ),
      );
    }
  }

  @override
  Future<EventSource> fetchCommentInRealTime(
      String liveId, String accessToken, callBack) async {
    // TODO: implement fetchCommentInRealTime

    Future(() async {
      for (int i = 0; i <= 100; i++) {
        await Future.delayed(new Duration(
          seconds: 2,
        ));

        callBack(new FacebookComment(
            id: i.toString(),
            from: new FacebookUser(id: "100000520869190", name: "Nguyễn Nam"),
            message: "Comment số " + i.toString(),
            comments: <FacebookComment>[],
            createdTime: DateTime.now()));
      }
    });

    return null;
  }

  @override
  String getAccessToken() {
    // TODO: implement getAccessToken
    return "facekAccessToken";
  }

  @override
  Future<List<FacebookAccount>> getFacebookAccount({String accessToken}) {
    // TODO: implement getFacebookAccount
    return Future(() {
      return _facebookAccounts;
    });
  }

  @override
  Future<List<FacebookPost>> getFacebookPost(
      {String pageId, String accessToken, bool isMeAccount}) {
    return Future(() {
      return _facebookPost;
    });
  }

  @override
  Future<GetFacebookPostResult> getFacebookPostWithPaging(
      {String pageId,
      String accessToken,
      bool isMeAccount,
      FacebookListPaging paging,
      int take = 20,
      String type}) {
    // TODO: implement getFacebookPostWithPagingr

    return Future.value(
        new GetFacebookPostResult(data: _facebookPost, paging: null));
  }

  @override
  Future loginFacebook() {
    // TODO: implement loginFacebook
    return null;
  }

  @override
  Future logoutFacebook() {
    // TODO: implement logoutFacebook
    return null;
  }

  @override
  void setNewFacebookLogin(String accessToken, DateTime dateExpire) {
    // TODO: implement setAccessToken
  }

  @override
  Future<FacebookUser> getFacebookUserInfo({String accessToken}) {
    // TODO: implement getFacebookUserInfo
    return null;
  }

  @override
  Future<String> replyPageComment(
      {String commentId, String message, String accessToken}) {
    // TODO: implement replyPageComment
    return null;
  }

  @override
  Future<void> hiddenComment(
      {String commentId, accessToken, bool isHidden = true}) {
    // TODO: implement hiddenComment
    return null;
  }

  @override
  Future<FetchFacebookCommentResult> fetchReplyComment(String commentParentId,
      {String accessToken, bool isNewestOnTop}) {
    // TODO: implement fetchReplyComment
    return null;
  }

  @override
  Future<SendMessageResult> sendPageMessage(
      {String accessToken, String psid, String message}) {
    // TODO: implement sendPageMessage
    return null;
  }

  @override
  Future<FetchFacebookCommentResult> fetchCommentWithPaging(
      {String postId,
      String accessToken,
      bool isNewestOnTop = true,
      int limit = 50}) {
    // TODO: implement fetchCommentWithPaging
    return null;
  }

  @override
  Future<FetchFacebookCommentResult> fetchMoreCommentWithPaging(
      FacebookListPaging paging, String accessToken,
      {int limit = 50}) {
    // TODO: implement fetchMoreCommentWithPaging
    return null;
  }

  @override
  Future<FacebookPost> getFacebookPostById(String postId,
      [String accessToken]) {
    // TODO: implement getFacebookPostById
    return null;
  }

  @override
  Future<LiveVideo> getLiveVideo({accessToken, String liveVideoId}) {
    return null;
  }

  @override
  Future<List<FacebookComment>> fetchTopComment(
      {int top, String accessToken, String postId, DateTime lastTime}) {
    // TODO: implement fetchTopComment
    return null;
  }

  @override
  Future<List<BatchResult>> getLiveVideoBatch(
      List<String> postIds, String accessToken) {
    // TODO: implement getLiveVideoBatch
    return null;
  }
}
