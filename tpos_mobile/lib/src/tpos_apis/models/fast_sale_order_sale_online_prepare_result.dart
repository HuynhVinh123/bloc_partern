import 'package:tpos_api_client/tpos_api_client.dart';

class FastSaleOrderSaleLinePrepareResult {
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
      orderLines = <FastSaleOrderLine>[];
      json['orderLines'].forEach((v) {
        orderLines.add(FastSaleOrderLine.fromJson(v));
      });
    }
    partner =
        json['partner'] != null ? Partner.fromJson(json['partner']) : null;
  }
  String odataContext;
  int id;
  String facebookId;
  String facebookName;
  List<String> ids;
  String comment;
  List<FastSaleOrderLine> orderLines;
  Partner partner;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['@odata.context'] = odataContext;
    data['Id'] = id;
    data['facebookId'] = facebookId;
    data['facebookName'] = facebookName;
    data['ids'] = ids;
    data['comment'] = comment;
    if (orderLines != null) {
      data['orderLines'] = orderLines.map((v) => v.toJson()).toList();
    }
    if (partner != null) {
      data['partner'] = partner.toJson();
    }
    return data;
  }
}
