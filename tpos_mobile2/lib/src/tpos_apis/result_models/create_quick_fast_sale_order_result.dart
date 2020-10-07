

import 'package:tpos_mobile/src/tpos_apis/models/create_quick_fast_sale_order_model.dart';

class InsertOrderProductDefaultResult {
  String odataContext;
  bool success;
  dynamic warning;
  String error;
  List<dynamic> errors;
  int orderId;
  List<int> ids;
  List<CreateQuickFastSaleOrderLineModel> dataErrorDefault;

  InsertOrderProductDefaultResult(
      {this.odataContext,
      this.success,
      this.warning,
      this.error,
      this.errors,
      this.orderId,
      this.dataErrorDefault});

  InsertOrderProductDefaultResult.fromJson(Map<String, dynamic> json) {
    odataContext = json['@odata.context'];
    success = json['Success'];
    warning = json['Warning'];
    error = json['Error'];
    orderId = json['OrderId'];
    if (json["Ids"] != null) ids = json["Ids"].cast<int>();
    if (json["Errors"] != null) {
      errors = json["Errors"].cast<String>();
    }

    if (json['DataErrorDefault'] != null) {
      dataErrorDefault = (json['DataErrorDefalt'] as List)
          .map((e) => CreateQuickFastSaleOrderLineModel.fromJson(e))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['@odata.context'] = this.odataContext;
    data['Success'] = this.success;
    data['Warning'] = this.warning;
    data['Error'] = this.error;
    data['OrderId'] = this.orderId;
    return data;
  }
}
