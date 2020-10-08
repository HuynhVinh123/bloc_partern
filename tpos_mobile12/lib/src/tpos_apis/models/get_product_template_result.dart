import 'package:tpos_mobile/src/tpos_apis/models/ProductTemplate.dart';

class GetProductTemplateResult {
  List<ProductTemplate> data;
  int total;
  dynamic aggregates;

  GetProductTemplateResult({this.data, this.total, this.aggregates});

  GetProductTemplateResult.fromJson(Map<String, dynamic> json) {
    if (json['Data'] != null) {
      data = new List<ProductTemplate>();
      json['Data'].forEach((v) {
        data.add(new ProductTemplate.fromJson(v));
      });
    }
    total = json['Total'];
    aggregates = json['Aggregates'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['Data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['Total'] = this.total;
    data['Aggregates'] = this.aggregates;
    return data;
  }
}
