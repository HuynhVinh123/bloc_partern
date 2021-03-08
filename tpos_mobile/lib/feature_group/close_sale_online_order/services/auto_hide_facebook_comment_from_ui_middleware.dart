import 'package:tpos_mobile/feature_group/close_sale_online_order/models/comment_data.dart';
import 'package:tpos_mobile/feature_group/close_sale_online_order/models/comment_setting.dart';

import 'comment_exception.dart';
import 'comment_midleware.dart';

/// Tự động ẩn comment trên facebook theo cấu hình mỗi khi comment mới được thêm vào danh sách
class AutoHideCommentFromUiMiddlware extends CommentMiddleware {
  AutoHideCommentFromUiMiddlware();

  HideCommentOnFacebookConfig _hideCommentSetting;

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

  void _hideComment(CommentData comment) {
    if (comment.comment.canHide == true && comment.comment.isHidden == false) {
      // call hidden comment
      comment.isHiddenFromUi = true;
    }
  }
}
