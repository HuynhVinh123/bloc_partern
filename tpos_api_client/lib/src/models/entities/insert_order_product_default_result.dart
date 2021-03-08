import 'package:tpos_api_client/tpos_api_client.dart';

class InsertOrderProductDefaultResult {
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
    if (json["Ids"] != null) {
      ids = json["Ids"].cast<int>();
    }
    if (json["Errors"] != null) {
      errors = json["Errors"].cast<String>();
    }

    if (json['DataErrorDefault'] != null) {
      dataErrorDefault = (json['DataErrorDefault'] as List)
          .map((e) => CreateQuickFastSaleOrderLineModel.fromJson(e))
          .toList();
    }
  }
  String odataContext;
  bool success;
  dynamic warning;
  String error;
  List<dynamic> errors;
  int orderId;
  List<int> ids;
  List<CreateQuickFastSaleOrderLineModel> dataErrorDefault;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['@odata.context'] = odataContext;
    data['Success'] = success;
    data['Warning'] = warning;
    data['Error'] = error;
    data['OrderId'] = orderId;
    return data;
  }
}
