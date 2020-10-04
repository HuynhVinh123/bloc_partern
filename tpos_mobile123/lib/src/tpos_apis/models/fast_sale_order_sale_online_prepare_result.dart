import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_sale_order_line.dart';

class FastSaleOrderSaleLinePrepareResult {
  String odataContext;
  int id;
  String facebookId;
  String facebookName;
  List<String> ids;
  String comment;
  List<FastSaleOrderLine> orderLines;
  Partner partner;

  FastSaleOrderSaleLinePrepareResult(
      {this.odataContext,
      this.id,
      this.facebookId,
      this.facebookName,
      this.ids,
      this.comment,
      this.orderLines,
      this.partner});

  FastSaleOrderSaleLinePrepareResult.fromJson(Map<String, dynamic> json) {
    odataContext = json['@odata.context'];
    id = json['Id'];
    facebookId = json['facebookId'];
    facebookName = json['facebookName'];
    ids = json['ids'].cast<String>();
    comment = json['comment'];
    if (json['orderLines'] != null) {
      orderLines = new List<FastSaleOrderLine>();
      json['orderLines'].forEach((v) {
        orderLines.add(new FastSaleOrderLine.fromJson(v));
      });
    }
    partner =
        json['partner'] != null ? new Partner.fromJson(json['partner']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['@odata.context'] = this.odataContext;
    data['Id'] = this.id;
    data['facebookId'] = this.facebookId;
    data['facebookName'] = this.facebookName;
    data['ids'] = this.ids;
    data['comment'] = this.comment;
    if (this.orderLines != null) {
      data['orderLines'] = this.orderLines.map((v) => v.toJson()).toList();
    }
    if (this.partner != null) {
      data['partner'] = this.partner.toJson();
    }
    return data;
  }
}
