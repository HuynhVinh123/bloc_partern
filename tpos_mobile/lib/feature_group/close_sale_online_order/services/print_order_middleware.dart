import 'dart:collection';

import 'package:tpos_mobile/feature_group/close_sale_online_order/models/comment_setting.dart';
import 'package:tpos_mobile/feature_group/close_sale_online_order/models/order_data.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/print_service.dart';

import 'comment_exception.dart';
import 'order_midleware.dart';

class PrintOrderMiddleware extends OrderMiddleware {
  PrintOrderMiddleware({
    PrintService printService,
    PrintOrderSetting printOrderSetting,
  }) {
    _printService = printService ?? locator<PrintService>();
    _printOrderSetting = printOrderSetting;
    assert(_printOrderSetting != null);
  }

  PrintService _printService;
  PrintOrderSetting _printOrderSetting;
  final Queue<OrderData> _printQueue = Queue<OrderData>();
  bool _isPrintOrderQueue;

  @override
  Future<CommentException> onError(CommentException err) async {
    return err;
  }

  @override
  Future<OrderData> onReceiver(OrderData comment) async {
    // Không in nếu ko đi kèm một comment
    if (comment.lastComment == null) {
      return comment;
    }
    // Không in nếu cài đặt bị tắt
    if (_printOrderSetting.printOrder == false) {
      return comment;
    }

    // Nếu đã in trên comment này 1 lần rồi thì ko in nữa
    if (_printOrderSetting.printOrderOnlyOnePerComment) {
      if (comment.lastComment.printCount > 0) {
        return comment;
      }
    }

    // Nếu đã in 1 lần trên khách hàng này thì không in nữa
    if (_printOrderSetting.printOrderOnlyOnePerPartner) {
      if (comment.lastComment.order.printCount > 0) {
        return comment;
      }
    }
    _addToQueue(comment);
    return comment;
  }

  Future<void> _addToQueue(OrderData data) async {
    _printQueue.addFirst(data);
    await _printOrderQuene();
  }

  Future<void> _printOrderQuene() async {
    if (_isPrintOrderQueue) {
      return;
    }

    _isPrintOrderQueue = true;
    while (_printQueue.isNotEmpty) {
      final orderData = _printQueue.first;
      await _printService.printSaleOnlineTag(order: orderData.order);
      orderData.order.printCount += 1;
      orderData.lastComment.printCount += 1;
      _printQueue.remove(orderData);
    }
    _isPrintOrderQueue = false;
  }
}
