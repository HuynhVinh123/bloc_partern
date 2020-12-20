class AccountCommonPartnerReport {
  AccountCommonPartnerReport(
      {this.begin,
      this.code,
      this.credit,
      this.dateFrom,
      this.dateTo,
      this.debit,
      this.end,
      this.partnerDisplayName,
      this.partnerFacebookUserId,
      this.partnerId,
      this.partnerName,
      this.partnerPhone});
  AccountCommonPartnerReport.fromJson(Map<String, dynamic> json) {
    if (json['Begin'] != null) {
      begin = double.parse(json['Begin']?.toString());
    }
    code = json['Code'];
    if (json['Credit'] != null) {
      credit = double.parse(json['Credit'].toString());
    }
    if (json['DateFrom'] != null) {
      dateFrom = DateTime.fromMillisecondsSinceEpoch(int.parse(json['DateFrom']
          .toString()
          .substring(6, json['DateFrom'].toString().length - 2)));
    }
    if (json['DateTo'] != null) {
      dateTo = DateTime.fromMillisecondsSinceEpoch(int.parse(json['DateTo']
          .toString()
          .substring(6, json['DateTo'].toString().length - 2)));
    }
    if (json['Debit'] != null) {
      debit = double.parse(json['Debit']?.toString());
    }
    if (json['End'] != null) {
      end = double.parse(json['End']?.toString());
    }
    partnerDisplayName = json['PartnerDisplayName'];
    partnerFacebookUserId = json['PartnerFacebook_UserId'];
    partnerId = json['PartnerId'];
    partnerName = json['PartnerName'];
    partnerPhone = json['PartnerPhone'];

    number = json['Number'];
    if (json['DateInvoice'] != null) {
      dateInvoice = DateTime.fromMillisecondsSinceEpoch(int.parse(
          json['DateInvoice']
              .toString()
              .substring(6, json['DateInvoice'].toString().length - 2)));
    }
    amountTotal = json['AmountTotal'];
    residual = json['Residual'];

    name = json['Name'];
    if (json['Date'] != null) {
      date = DateTime.fromMillisecondsSinceEpoch(int.parse(json['Date']
          .toString()
          .substring(6, json['Date'].toString().length - 2)));

    }
    id = json['Id'];
    moveName = json['MoveName'];
    ref = json['Ref'];
  }
  double begin;
  String code;
  double credit;
  DateTime dateFrom;
  DateTime dateTo;
  double debit;
  double end;
  String partnerDisplayName;
  String partnerFacebookUserId;
  int partnerId;
  String partnerName;
  String partnerPhone;

  String number;
  DateTime dateInvoice;
  double amountTotal;
  double residual;

  String name;
  DateTime date;
  int id;
  String moveName;
  String ref;
  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PartnerId'] = partnerId;
    data['PartnerDisplayName'] = partnerDisplayName;
    data['Begin'] = begin;
    data['Debit'] = debit;
    data['Credit'] = credit;
    data['End'] = end;
    data['DateFrom'] = dateFrom;
    data['DateTo'] = dateTo;
    data['Code'] = code;
    data['PartnerName'] = partnerName;
    data['PartnerPhone'] = partnerPhone;
    data['PartnerFacebook_UserId'] = partnerFacebookUserId;

    data['Number'] = number;
    data['DateInvoice'] = dateInvoice;
    data['AmountTotal'] = amountTotal;
    data['Residual'] = residual;

    data['Name'] = name;
    data['Date'] = date.toIso8601String();
    data['Id'] = id;
    data['MoveName'] = moveName;
    data['Ref'] = ref;
    if (removeIfNull) {
      return data..removeWhere((key, value) => value == null);
    } else {
      return data;
    }
  }
}
