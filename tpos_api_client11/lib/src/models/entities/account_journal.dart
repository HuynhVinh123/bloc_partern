class AccountJournal {
  AccountJournal(
      {this.id,
      this.code,
      this.name,
      this.type,
      this.updatePosted,
      this.currencyId,
      this.defaultDebitAccountId,
      this.defaultCreditAccountId,
      this.companyId,
      this.companyName,
      this.journalUser,
      this.profitAccountId,
      this.lossAccountId,
      this.amountAuthorizedDiff,
      this.dedicatedRefund,
      this.isCheckSelect});
  AccountJournal.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    code = json['Code'];
    name = json['Name'];
    type = json['Type'];
    updatePosted = json['UpdatePosted'];
    currencyId = json['CurrencyId'];
    defaultDebitAccountId = json['DefaultDebitAccountId'];
    defaultCreditAccountId = json['DefaultCreditAccountId'];
    companyId = json['CompanyId'];
    companyName = json['CompanyName'];
    journalUser = json['JournalUser'];
    profitAccountId = json['ProfitAccountId'];
    lossAccountId = json['LossAccountId'];
    amountAuthorizedDiff = json['AmountAuthorizedDiff'];
    dedicatedRefund = json['DedicatedRefund'];
  }

  int id;
  String code;
  String name;
  String type;
  bool updatePosted;
  int currencyId;
  int defaultDebitAccountId;
  int defaultCreditAccountId;
  int companyId;
  String companyName;
  bool journalUser;
  int profitAccountId;
  int lossAccountId;
  dynamic amountAuthorizedDiff;
  dynamic dedicatedRefund;
  bool isCheckSelect = false;

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Code'] = code;
    data['Name'] = name;
    data['Type'] = type;
    data['UpdatePosted'] = updatePosted;
    data['CurrencyId'] = currencyId;
    data['DefaultDebitAccountId'] = defaultDebitAccountId;
    data['DefaultCreditAccountId'] = defaultCreditAccountId;
    data['CompanyId'] = companyId;
    data['CompanyName'] = companyName;
    data['JournalUser'] = journalUser;
    data['ProfitAccountId'] = profitAccountId;
    data['LossAccountId'] = lossAccountId;
    data['AmountAuthorizedDiff'] = amountAuthorizedDiff;
    data['DedicatedRefund'] = dedicatedRefund;

    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}