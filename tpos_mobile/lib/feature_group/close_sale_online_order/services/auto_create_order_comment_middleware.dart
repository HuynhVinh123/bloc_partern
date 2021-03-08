import 'package:tpos_mobile/feature_group/close_sale_online_order/models/comment_data.dart';

import 'comment_exception.dart';
import 'comment_midleware.dart';

class AutoCreateOrderMidlleware extends CommentMiddleware {
  @override
  Future<CommentException> onError(CommentException err) async {
    return err;
  }

  @override
  Future<CommentData> onReceiver(CommentData comment) async {
    return comment;
  }
}
