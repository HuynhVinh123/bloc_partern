class PartnerReport {
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['PartnerId'] = this.partnerId;
    data['PartnerDisplayName'] = this.partnerDisplayName;
    data['Begin'] = this.begin;
    data['Debit'] = this.debit;
    data['Credit'] = this.credit;
    data['End'] = this.end;
    data['DateFrom'] = this.dateFrom;
    data['DateTo'] = this.dateTo;
    data['Code'] = this.code;
    data['PartnerName'] = this.partnerName;
    data['PartnerPhone'] = this.partnerPhone;
    data['PartnerFacebook_UserId'] = this.partnerFacebookUserId;
    return data;
  }
}
