class GetAccountCommonPartnerReportQuery {
  GetAccountCommonPartnerReportQuery({
    this.dateFrom,
    this.dateTo,
    this.display,
    this.page,
    this.pageSize,
    this.resultSelection,
    this.skip,
    this.take,
    this.categId,
    this.companyId,
    this.partnerId,
    this.userId,
  });
  DateTime dateFrom;
  DateTime dateTo;
  String display;
  int page;
  int pageSize;
  String resultSelection;
  int skip;
  int take;
  String categId;
  String companyId;
  String partnerId;
  String userId;

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['DateFrom'] = dateFrom.toIso8601String();
    data['DateTo'] = dateTo.toIso8601String();
    data['Display'] = display;
    data['page'] = page;
    data['pageSize'] = pageSize;
    data['PartnerId'] = partnerId;
    data['ResultSelection'] = resultSelection;
    data['skip'] = skip;
    data['take'] = take;
    data['UserId'] = userId;
    data['CompanyId'] = companyId;
    data['CategId'] = categId;
    data['PartnerId'] = partnerId;
    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
