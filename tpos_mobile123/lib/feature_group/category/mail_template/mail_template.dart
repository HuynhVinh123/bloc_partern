import 'package:tpos_mobile/src/tpos_apis/models/mail_template.dart';

class MailTemplateResult {
  int odataCount;
  List<MailTemplate> value;

  MailTemplateResult({this.odataCount, this.value});

  MailTemplateResult.fromJson(Map<String, dynamic> json) {
    odataCount = json['@odata.count'];
    if (json['value'] != null) {
      value = new List<MailTemplate>();
      json['value'].forEach((v) {
        value.add(new MailTemplate.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['@odata.count'] = this.odataCount;
    if (this.value != null) {
      data['value'] = this.value.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MailTemplateType {
  String value;
  String text;

  MailTemplateType({this.value, this.text});

  MailTemplateType.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['text'] = this.text;
    return data;
  }
}
