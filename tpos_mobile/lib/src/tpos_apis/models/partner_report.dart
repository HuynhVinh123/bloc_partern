class PartnerReport {
  PartnerReport(
      {this.partnerId,
      this.partnerDisplayName,
      this.begin,
      this.debit,
      this.credit,
      this.end,
      this.dateFrom,
      this.dateTo,
      this.code,
      this.partnerName,
      this.partnerPhone,
      this.partnerFacebookUserId,
      this.totalItem});

  PartnerReport.fromJson(Map<String, dynamic> json) {
    partnerId = json['PartnerId'];
    partnerDisplayName = json['PartnerDisplayName'];
    begin = double.parse(json['Begin'].toString());
    debit = double.parse(json['Debit'].toString());
    credit = double.parse(json['Credit'].toString());
    end = double.parse(json['End'].toString());
    dateFrom = json['DateFrom'];
    dateTo = json['DateTo'];
    code = json['Code'];
    partnerName = json['PartnerName'];
    partnerPhone = json['PartnerPhone'];
    partnerFacebookUserId = json['PartnerFacebook_UserId'];
  }
  int partnerId;
  String partnerDisplayName;
  double begin;
  double debit;
  double credit;
  double end;
  String dateFrom;
  String dateTo;
  String code;
  String partnerName;
  String partnerPhone;
  String partnerFacebookUserId;
  int totalItem;

  Map<String, dynamic> toJson() {
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
    return data;
  }
}
