import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/models/Order.dart';

import 'comment_data.dart';

class OrderData {
  OrderData({this.lastComment, this.order});
  CommentData lastComment;
  SaleOnlineOrder order;
}
