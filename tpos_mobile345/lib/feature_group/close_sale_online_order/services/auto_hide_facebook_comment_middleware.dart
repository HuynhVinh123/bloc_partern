import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:tpos_mobile/feature_group/close_sale_online_order/models/comment_data.dart';
import 'package:tpos_mobile/feature_group/close_sale_online_order/models/comment_setting.dart';

import 'package:tpos_mobile/src/facebook_apis/facebook_api.dart';

import 'auto_hide_facebook_comment_helper.dart';
import 'comment_exception.dart';
import 'package:tpos_mobile/extensions/string_extensions.dart';

import 'comment_midleware.dart';

/// Tự động ẩn comment trên facebook theo cấu hình mỗi khi comment mới được thêm vào danh sách
class AutoHideCommentMiddleWare extends CommentMiddleware {
  AutoHideCommentMiddleWare(
      {IFacebookApiService facebookApiService,
      @required String accessToken,
      HideCommentOnFacebookConfig hideCommentSetting}) {
    _facebookApi = facebookApiService;
    _accessToken = accessToken;
    _hideCommentSetting = hideCommentSetting;

    assert(_accessToken != null);
    assert(_hideCommentSetting != null);
  }

  final Logger _logger = Logger();
  IFacebookApiService _facebookApi;
  String _accessToken;
  HideCommentOnFacebookConfig _hideCommentSetting;

  Queue _hideCommentQuene = Queue<CommentData>();
  bool _isHideCommentQueueRunning = false;

  @override
  Future<CommentException> onError(CommentException err) async {
    return err;
  }

  @override
  Future<CommentData> onReceiver(CommentData comment) async {
    // Ko bật thì trả về và bỏ qua
    if (!_hideCommentSetting.enableHideComment) {
      return comment;
    }

    if (_hideCommentSetting.isHideAllComment) {
      _hideComment(comment);
      return comment;
    }

    // TODO(namnv): Tự động ẩn bình luận theo cấu hình

    return comment;
  }

  Future<void> _hideComment(CommentData comment) async {
    if (comment.comment.canHide == true && comment.comment.isHidden == false) {
      // call hidden comment
      try {
        await _facebookApi.hiddenComment(
          commentId: comment.comment.id,
          accessToken: _accessToken,
        );
        comment.comment.isHidden = true;
      } catch (e, s) {
        _logger.e('Hide comment out facebook failed', e, s);
      }
    }
  }

  Future<void> _runHideCommentQueue() async {
    if (!_isHideCommentQueueRunning) {
      return;
    }
    _isHideCommentQueueRunning = true;
    while (_hideCommentQuene.isNotEmpty) {
      var comment = _hideCommentQuene.first;
      await _hideComment(comment);
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
    _isHideCommentQueueRunning = false;
  }

  void _addToQueue(CommentData commentData) {
    _hideCommentQuene.addLast(commentData);
    _runHideCommentQueue();
  }
}
