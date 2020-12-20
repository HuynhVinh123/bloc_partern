import 'package:tpos_api_client/tpos_api_client.dart';

class MailTemplateResult {
  MailTemplateResult({this.odataCount, this.value});
  MailTemplateResult.fromJson(Map<String, dynamic> json) {
    odataCount = json['@odata.count'];
    if (json['value'] != null) {
      value = <MailTemplate>[];
      json['value'].forEach((v) {
        value.add(MailTemplate.fromJson(v));
      });
    }
  }
  int odataCount;
  List<MailTemplate> value;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['@odata.count'] = odataCount;
    if (value != null) {
      data['value'] = value.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MailTemplateType {
  MailTemplateType({this.value, this.text});
  MailTemplateType.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    text = json['text'];
  }
  String value;
  String text;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['text'] = text;
    return data;
  }
}
