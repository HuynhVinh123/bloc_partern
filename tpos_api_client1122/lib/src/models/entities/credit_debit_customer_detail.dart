class CreditDebitCustomerDetail {
  CreditDebitCustomerDetail(
      {this.date,
      this.journalCode,
      this.accountCode,
      this.displayedName,
      this.amountResidual});
  CreditDebitCustomerDetail.fromJson(Map<String, dynamic> json) {
    journalCode = json['JournalCode'];
    accountCode = json['AccountCode'];
    displayedName = json['DisplayedName'];
    amountResidual = json['AmountResidual'];
    if (json["Date"] != null) {
      final String unixTimeStr =
          RegExp(r"(?<=Date\()\d+").stringMatch(json["Date"]);

      if (unixTimeStr != null && unixTimeStr.isNotEmpty) {
        final int unixTime = int.parse(unixTimeStr);
        date = DateTime.fromMillisecondsSinceEpoch(unixTime);
      } else {
        if (json["Date"] != null) {
          date = DateTime.parse(json["Date"]).toLocal();
        }
      }
    }
  }
  DateTime date;
  int journalCode;
  int accountCode;
  String displayedName;
  double amountResidual;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Date'] = date;
    data['JournalCode'] = journalCode;
    data['AccountCode'] = accountCode;
    data['DisplayedName'] = displayedName;
    data['AmountResidual'] = amountResidual;
    return data;
  }
}
