import 'package:tpos_mobile/feature_group/close_sale_online_order/models/comment_data.dart';

import 'comment_exception.dart';

typedef CommentMiddlewareCallback = dynamic Function(CommentData comment);

abstract class CommentMiddleware {
  /// This callback will be executed when comment added to [CommentProcessor]
  Future<CommentData> onReceiver(CommentData comment);

  /// This callback will be executed when an error occured in function
  Future<CommentException> onError(CommentException err);
}

class CommentWrapperMiddleware extends CommentMiddleware {
  CommentWrapperMiddleware({CommentMiddlewareCallback onReceiver})
      : _onReceiver = onReceiver;
  final CommentMiddlewareCallback _onReceiver;

  @override
  Future<CommentData> onReceiver(CommentData comment) async {
    if (_onReceiver != null) {
      return await _onReceiver(comment);
    }
    return null;
  }

  @override
  Future<CommentException> onError(CommentException err) {
    // TODO: implement onError
    throw UnimplementedError();
  }
}
