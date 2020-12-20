class MailTemplate {
  MailTemplate(
      {this.id,
      this.name,
      this.emailFrom,
      this.partnerTo,
      this.subject,
      this.bodyHtml,
      this.bodyPlain,
      this.reportName,
      this.model,
      this.autoDelete,
      this.typeId,
      this.typeName,
      this.active});

  MailTemplate.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    emailFrom = json['EmailFrom'];
    partnerTo = json['PartnerTo'];
    subject = json['Subject'];
    bodyHtml = json['BodyHtml'];
    bodyPlain = json['BodyPlain'];
    reportName = json['ReportName'];
    model = json['Model'];
    autoDelete = json['AutoDelete'];
    typeId = json['TypeId'];
    typeName = json['TypeName'];
    active = json['Active'];
  }

  int id;
  String name;
  String emailFrom;
  String partnerTo;
  String subject;
  String bodyHtml;
  String bodyPlain;
  dynamic reportName;
  dynamic model;
  bool autoDelete;
  String typeId;
  String typeName;
  bool active;

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Name'] = name;
    data['EmailFrom'] = emailFrom;
    data['PartnerTo'] = partnerTo;
    data['Subject'] = subject;
    data['BodyHtml'] = bodyHtml;
    data['BodyPlain'] = bodyPlain;
    data['ReportName'] = reportName;
    data['Model'] = model;
    data['AutoDelete'] = autoDelete;
    data['TypeId'] = typeId;
    data['TypeName'] = typeName;
    data['Active'] = active;
    return data..removeWhere((key, value) => value == null);
  }
}
