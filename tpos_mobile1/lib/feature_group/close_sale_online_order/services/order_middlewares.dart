import 'dart:async';
import 'dart:collection';

import 'comment_middlewares.dart';
import 'order_midleware.dart';

typedef EnqueueCallback = FutureOr Function();

class OrderMiddlewares extends ListMixin<OrderMiddleware> {
  final List<OrderMiddleware> _list = <OrderMiddleware>[];
  final Lock _commentLock = Lock();
  final Lock _errorLock = Lock();
  @override
  int length = 0;

  @override
  OrderMiddleware operator [](int index) {
    return _list[index];
  }

  @override
  void operator []=(int index, OrderMiddleware value) {
    if (_list.length == index) {
      _list.add(value);
    } else {
      _list[index] = value;
    }
  }
}
