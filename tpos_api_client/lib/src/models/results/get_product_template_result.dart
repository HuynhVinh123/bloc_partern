import 'package:tpos_api_client/tpos_api_client.dart';

class GetProductTemplateResult {
  GetProductTemplateResult({this.data, this.total, this.aggregates});

  GetProductTemplateResult.fromJson(Map<String, dynamic> json) {
    if (json['Data'] != null) {
      data = <ProductTemplate>[];
      json['Data'].forEach((v) {
        data.add(ProductTemplate.fromJson(v));
      });
    }
    total = json['Total'];
    aggregates = json['Aggregates'];
  }

  List<ProductTemplate> data;
  int total;
  dynamic aggregates;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['Data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['Total'] = total;
    data['Aggregates'] = aggregates;
    return data;
  }
}
