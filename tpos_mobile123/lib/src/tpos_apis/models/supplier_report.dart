class SupplierReport {
  double begin;
  String code;
  double credit;
  String dateFrom;
  String dateTo;
  double debit;
  double end;
  String partnerDisplayName;
  String partnerFacebookUserId;
  int partnerId;
  String partnerName;
  String partnerPhone;
  int totalItem;

  SupplierReport(
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
      this.partnerPhone,
      this.totalItem});

  SupplierReport.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
