class SupplierReport {
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
