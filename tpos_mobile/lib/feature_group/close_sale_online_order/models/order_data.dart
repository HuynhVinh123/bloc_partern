import 'package:tpos_api_client/tpos_api_client.dart';

import 'comment_data.dart';

class OrderData {
  OrderData({this.lastComment, this.order});
  CommentData lastComment;
  SaleOnlineOrder order;
}
