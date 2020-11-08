/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:53 AM
 *
 */

import 'dart:async';
import 'dart:convert';

import 'package:facebook_api_client/facebook_api_client.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/services/app_setting_service.dart';

import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';

class SaleOnlineFacebookPostViewModel extends ViewModel
    implements ViewModelBase {
  SaleOnlineFacebookPostViewModel(
      {FacebookApi fbApi, ITposApiService tposApi}) {
    _fbApi = fbApi ?? GetIt.I<FacebookApi>();
    _tposApi = tposApi ?? locator<ITposApiService>();
    _setting = locator<ISettingService>();
  }
  //log
  final log = Logger("SaleOnlineFacebookPostViewModel");
  FacebookApi _fbApi;
  ITposApiService _tposApi;
  CRMTeam _crmTeam;
  ISettingService _setting;

  //Facebook Post Type
  FacebookPostType _postType = FacebookPostType.video;
  FacebookPostType get postType => _postType;

  CRMTeam get crmTeam => _crmTeam;
  String get _accessToken => _crmTeam.facebookTypeId == "User"
      ? _crmTeam.facebookUserToken
      : _crmTeam.facebookTypeId == "Page"
          ? _crmTeam.facebookPageToken
          : _crmTeam.facebookPageToken;
  String get accessToken => _accessToken;

  String get _userOrPageId => _crmTeam.facebookTypeId == "User"
      ? _crmTeam.facebookASUserId
      : _crmTeam.facebookTypeId == "Page"
          ? _crmTeam.facebookPageId
          : _crmTeam.facebookPageId;

  final BehaviorSubject<FacebookPostType> _postTypeController =
      BehaviorSubject();
  Stream<FacebookPostType> get postTypeStream => _postTypeController.stream;

  set postType(FacebookPostType value) {
    _postType = value;
    if (!_postTypeController.isClosed) {
      _postTypeController.add(value);
    }
  }

  final List<FacebookAccount> _facebookAccounts = <FacebookAccount>[];
  FacebookListPaging get facebookPostPaging => _facebookPostPaging;
  FacebookListPaging _facebookPostPaging;
  //FacebookPosts
  final List<FacebookPost> _facebookPosts = <FacebookPost>[];
  List<FacebookPost> get facebookPosts => _facebookPosts;

  final BehaviorSubject<List<FacebookPost>> _facebookPostsController =
      BehaviorSubject();
  Stream<List<FacebookPost>> get facebookPostsStream =>
      _facebookPostsController.stream;

  // isLoadingMoreFacebookPost
  bool _isLoadingMoreFacebookPost = false;

  bool get isLoadingMoreFacebookPost => _isLoadingMoreFacebookPost;
  set isLoadingMoreFacebookPost(bool value) {
    _isLoadingMoreFacebookPost = value;
    if (!_isLoadingMoreFacebookPostController.isClosed)
      _isLoadingMoreFacebookPostController.add(value);
  }

  final BehaviorSubject<bool> _isLoadingMoreFacebookPostController =
      BehaviorSubject();
  Stream<bool> get isLoadingMoreFacebookPostStream =>
      _isLoadingMoreFacebookPostController.stream;

  // isLoadingFacebookPost
  bool _isLoadingFacebookPost = false;
  bool get isLoadingFacebookPost => _isLoadingFacebookPost;

  set isLoadingFacebookPost(bool value) {
    _isLoadingFacebookPost = value;
    if (!_isLoadingFacebookPostController.isClosed)
      _isLoadingFacebookPostController.sink.add(_isLoadingFacebookPost);
  }

  final BehaviorSubject<bool> _isLoadingFacebookPostController =
      BehaviorSubject();
  Stream<bool> get isLoadingFacebookPostStream =>
      _isLoadingFacebookPostController.stream;
  //
  bool get isFacebookLogined => _isFacebookLogined;
  bool _isFacebookLogined;

  bool isBusy = false;

  bool isOnlyShowPostHasComment = false;
  List<FacebookAccount> get facebookAccounts => _facebookAccounts;

  Future<void> init({
    @required CRMTeam crmTeam,
  }) async {
    _crmTeam = crmTeam;
    initCommand();
  }

  /// Gọi sau khi khởi tạo
  Future initCommand() async {
    try {
      await refreshFacebookPost();
      onPropertyChanged("");
    } catch (e, s) {
      log.severe("initCommand", e, s);
      onDialogMessageAdd(OldDialogMessage.error(
          "Tải danh sách bài đăng thất bại", e.toString()));
    }
    onStateAdd(false);
  }

  /// Gọi để tải thêm danh sách
  Future loadMoreFacebookPostCommand() async {
    await loadFacebookPost();
  }

  /// Lây danh sách bài đăng/ video
  Future refreshFacebookPost() async {
    isBusy = true;
    isLoadingFacebookPost = true;
    facebookPosts.clear();
    _facebookPostPaging = null;
    try {
      final facebookPostWithPaging = await _fbApi.getFacebookPostWithPaging(
          pageId: _userOrPageId,
          accessToken: _accessToken,
          take: _setting.getFacebookPostTake,
          type: _postType.toString().replaceAll("FacebookPostType.", ""));

      if (facebookPostWithPaging.error == null) {
        final itemsWillAdd = facebookPostWithPaging.data.where(
          (FacebookPost post) {
            return (isOnlyShowPostHasComment && post.totalComment >= 10 ||
                    isOnlyShowPostHasComment == false) &&
                (postType != FacebookPostType.all &&
                        post.type == postType.toString().split(".")[1] ||
                    postType == FacebookPostType.all);
          },
        ).toList();

        mapLiveStatus(itemsWillAdd);

        _facebookPosts.addAll(itemsWillAdd);
        if (!_facebookPostsController.isClosed)
          _facebookPostsController.sink.add(_facebookPosts);

        mapLiveCampaignWithFacebookPost(itemsWillAdd);
        _facebookPostPaging = facebookPostWithPaging.paging;
      } else {
        String message = facebookPostWithPaging.error.message;
        if (facebookPostWithPaging.error.type == "OAuthException") {
          if (facebookPostWithPaging.error.code == 190) {
            message =
                "$message \n\n Token có thể đã hết hạn. Vui lòng kiểm tra và làm mới nếu cần thiết";
          } else if (facebookPostWithPaging.error.code == 2) {
            message =
                "$message \n\n Sự cố tạm thời do facebook báo lỗi. Vui lòng chờ và thử lại";
          } else {
            message = "$message \n\n Đã xảy ra lỗi.";
          }
        }

        if (_facebookPostsController.isClosed == false) {
          _facebookPostsController.addError(message);
        }
      }
    } catch (ex, stack) {
      log.severe("refreshFacebookPost fail", ex, stack);
      if (_facebookPostsController.isClosed == false)
        _facebookPostsController.addError("Lỗi facebook", stack);
    }
    isLoadingFacebookPost = false;
    isBusy = false;
  }

  Future mapLiveStatus(List<FacebookPost> posts) async {
    try {
      if (posts != null) {
        final ids = posts.where((s) => s.type == "video").map((f) {
          return f.id.split("_")[1];
        }).toList();
        final batch =
            await _fbApi.getLiveVideoBatch(ids, _crmTeam.userOrPageToken);

        for (int i = 0; i < ids.length; i++) {
          final rs = batch[i];
          if (rs.code == 200) {
            final live = LiveVideo.fromJson(jsonDecode(rs.body));
            final post = posts.firstWhere((f) => f.id.contains(ids[i]),
                orElse: () => null);
            post?.isLive = live.liveStatus == "LIVE";
            post?.isVideo = live.liveStatus == "VOD";
          }
        }
      }
    } catch (e, s) {
      log.severe("batch", e, s);
    }

    onPropertyChanged("");
  }

  /// Lấy thêm danh sách bài đăng video
  Future loadFacebookPost() async {
    isBusy = true;
    if (_facebookPostPaging == null) {
      return;
    }
    if (_facebookPostPaging.next == null) {
      return;
    }
    if (_isLoadingMoreFacebookPost == true) {
      return;
    }
    try {
      isLoadingMoreFacebookPost = true;
      final facebookPostWithPaging = await _fbApi.getFacebookPostWithPaging(
        pageId: _userOrPageId,
        accessToken: _accessToken,
        paging: _facebookPostPaging,
        take: _setting.getFacebookPostTake,
        type: _postType.toString().replaceAll("FacebookPostType.", ""),
      );

      if (facebookPostWithPaging != null &&
          facebookPostWithPaging.data != null) {
        final itemsWillAdd = facebookPostWithPaging.data.where(
          (FacebookPost post) {
            return isOnlyShowPostHasComment && (post.totalComment ?? 0) >= 10 ||
                isOnlyShowPostHasComment == false;
          },
        ).toList();

        mapLiveStatus(itemsWillAdd);
        _facebookPosts.addAll(itemsWillAdd);
        mapLiveCampaignWithFacebookPost(itemsWillAdd);
        if (_facebookPostsController.isClosed == false)
          _facebookPostsController.add(_facebookPosts);
        _facebookPostPaging = facebookPostWithPaging.paging;
      } else {
        if (facebookPostWithPaging.error != null) {
          final String message = facebookPostWithPaging.error.message;

          onDialogMessageAdd(OldDialogMessage.error("", message));
        }
      }
    } catch (ex, stackTrade) {
      log.severe("loadFacebookPost fail", ex, stackTrade);
    }

    isLoadingMoreFacebookPost = false;
    isBusy = false;
  }

  Future<void> mapLiveCampaignWithFacebookPost(
      List<FacebookPost> facebookPosts) async {
    final savedPosts = await _tposApi.getSavedFacebookPost(
        _userOrPageId, facebookPosts.map((f) => f.id).toList().toList());

    // ignore: prefer_is_empty
    if (savedPosts != null && savedPosts.length >= 0) {
      // ignore: avoid_function_literals_in_foreach_calls
      savedPosts.forEach((savedPost) {
        final facebookPost = facebookPosts
            .firstWhere((f) => f.id == savedPost.id, orElse: () => null);

        if (facebookPost != null) {
          facebookPost.liveCampaignId = savedPost.liveCampaignId;
          facebookPost.liveCampaignName = savedPost.liveCampaignName;
          facebookPost.isSave = true;
        }
      });
    }

    onPropertyChanged("");
  }

  // Lưu bình luận

  Future<bool> saveComment(FacebookPost post) async {
    onStateAdd(true, message: "Đang lưu...");
    final TposFacebookPost fbPost =
        TposFacebookPost(comment: <TPosFacebookComment>[]);
    // Get all comment
    FacebookListPaging paging;
    List<FacebookComment> lastFetchResults;

    final result = await _fbApi.fetchCommentWithPaging(
        postId: post.id, accessToken: _accessToken);
    paging = result.paging;
    lastFetchResults = result.data;

    // ignore: avoid_function_literals_in_foreach_calls
    result.data.forEach(
      (f) {
        fbPost.comment.add(
          TPosFacebookComment(
              id: f.id,
              message: f.message,
              from: TposFacebookFrom(
                  id: f.from.id,
                  picture: f.from.pictureLink,
                  name: f.from.name),
              createdTime: f.createdTime,
              createdTimeConverted: f.createdTimeConverted),
        );
      },
    );

    while (paging != null &&
        paging.next != null &&
        lastFetchResults != null &&
        lastFetchResults.isNotEmpty) {
      try {
        final result =
            await _fbApi.fetchMoreCommentWithPaging(paging, accessToken);
        paging = result.paging;
        lastFetchResults = result.data;
        // ignore: avoid_function_literals_in_foreach_calls
        result.data.forEach(
          (f) {
            fbPost.comment.add(
              TPosFacebookComment(
                  id: f.id,
                  message: f.message,
                  from: TposFacebookFrom(
                      id: f.from.id,
                      picture: f.from.pictureLink,
                      name: f.from.name),
                  createdTime: f.createdTime,
                  createdTimeConverted: f.createdTimeConverted),
            );
          },
        );
      } catch (e, s) {
        log.severe("", e, s);
      }
    }

    // save comment
    fbPost.createdTime = post.createdTime;
    fbPost.from = TposFacebookFrom(
        id: post.from.id, name: post.from.name, picture: post.from.pictureLink);
    fbPost.id = post.id;
    fbPost.message = post.message;
    fbPost.story = post.story;
    fbPost.picture = post.picture;

    try {
      await _tposApi.insertFacebookPostComment([fbPost], _crmTeam.id);
      onStateAdd(false);
      return true;
    } catch (e, s) {
      log.severe("save comment", e, s);
      onDialogMessageAdd(OldDialogMessage.error("", "", error: e));
    }
    onStateAdd(false);
    return false;
  }

  @override
  void dispose() {
    super.dispose();
    _postTypeController.close();
    _facebookPostsController.close();
    _isLoadingFacebookPostController.close();
    _isLoadingMoreFacebookPostController.close();
  }
}
