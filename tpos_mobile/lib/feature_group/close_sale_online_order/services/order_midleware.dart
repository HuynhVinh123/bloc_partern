import 'package:tpos_mobile/feature_group/close_sale_online_order/models/order_data.dart';

import 'comment_exception.dart';

typedef OrderMiddlewareCallback = dynamic Function(OrderData order);

abstract class OrderMiddleware {
  /// This callback will be executed when comment added to [CommentProcessor]
  Future<OrderData> onReceiver(OrderData comment);

  /// This callback will be executed when an error occured in function
  Future<CommentException> onError(CommentException err);
}

class OrderWrapperMiddleware extends OrderMiddleware {
  OrderWrapperMiddleware({OrderMiddlewareCallback onReceiver})
      : _onReceiver = onReceiver;
  final OrderMiddlewareCallback _onReceiver;

  @override
  Future<OrderData> onReceiver(OrderData comment) async {
    if (_onReceiver != null) {
      return await _onReceiver(comment);
    }
    return null;
  }

  @override
  Future<CommentException> onError(CommentException err) async {
    return err;
  }
}
