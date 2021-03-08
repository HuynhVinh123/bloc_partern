import 'dart:async';
import 'dart:collection';

import 'comment_midleware.dart';

typedef EnqueueCallback = FutureOr Function();

class CommentMiddlewares extends ListMixin<CommentMiddleware> {
  final List<CommentMiddleware> _list = <CommentMiddleware>[];
  final Lock _commentLock = Lock();

  Lock get commentLock => _commentLock;
  @override
  int length = 0;

  @override
  CommentMiddleware operator [](int index) {
    return _list[index];
  }

  @override
  void operator []=(int index, CommentMiddleware value) {
    if (_list.length == index) {
      _list.add(value);
    } else {
      _list[index] = value;
    }
  }
}

/// Lock or unlock receiver data
class Lock {
  Future _lock;
  Completer _completer;

  bool get locked => _lock != null;

  void lock() {
    if (!locked) {
      _completer = Completer();
      _lock = _completer.future;
    }
  }

  void unLock() {
    if (locked) {
      _completer.complete();
      _lock = null;
    }
  }

  /// If the middleware is locked, the incoming commentData will enter a queue.
  Future enqueue(EnqueueCallback callback) {
    if (locked) {
      return _lock.then((value) => callback());
    }
    return null;
  }
}
