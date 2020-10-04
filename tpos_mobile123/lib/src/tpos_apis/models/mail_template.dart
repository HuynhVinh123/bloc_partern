class MailTemplate {
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
      this.typeName});

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
  }

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['EmailFrom'] = this.emailFrom;
    data['PartnerTo'] = this.partnerTo;
    data['Subject'] = this.subject;
    data['BodyHtml'] = this.bodyHtml;
    data['BodyPlain'] = this.bodyPlain;
    data['ReportName'] = this.reportName;
    data['Model'] = this.model;
    data['AutoDelete'] = this.autoDelete;
    data['TypeId'] = this.typeId;
    data['TypeName'] = this.typeName;
    return data..removeWhere((key, value) => value == null);
  }
}
