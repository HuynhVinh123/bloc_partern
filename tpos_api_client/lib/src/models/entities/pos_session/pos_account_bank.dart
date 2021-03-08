class PosAccountBank {
  PosAccountBank(
      {this.id,
      this.name,
      this.reference,
      this.date,
      this.dateDone,
      this.balanceStart,
      this.journalId,
      this.userId,
      this.companyId,
      this.state,
      this.showState,
      this.difference,
      this.balanceEnd,
      this.balanceEndReal,
      this.posSessionId,
      this.totalEntryEncoding,
      this.accountId,
      this.currencyId,
      this.journal});

  PosAccountBank.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    reference = json['Reference'];
    date = json['Date'];
    dateDone = json['DateDone'];
    balanceStart = json['BalanceStart'];
    journalId = json['JournalId'];
    userId = json['UserId'];
    companyId = json['CompanyId'];
    state = json['State'];
    showState = json['ShowState'];
    difference = json['Difference'];
    balanceEnd = json['BalanceEnd'];
    balanceEndReal = json['BalanceEndReal'];
    posSessionId = json['PosSessionId'];
    totalEntryEncoding = json['TotalEntryEncoding'];
    accountId = json['AccountId'];
    currencyId = json['CurrencyId'];
    journal =
        json['Journal'] != null ? PosJournal.fromJson(json['Journal']) : null;
  }
  int id;
  String name;
  String reference;
  String date;
  String dateDone;
  double balanceStart;
  int journalId;
  String userId;
  int companyId;
  String state;
  String showState;
  double difference;
  double balanceEnd;
  double balanceEndReal;
  int posSessionId;
  double totalEntryEncoding;
  int accountId;
  int currencyId;
  PosJournal journal;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Name'] = name;
    data['Reference'] = reference;
    data['Date'] = date;
    data['DateDone'] = dateDone;
    data['BalanceStart'] = balanceStart;
    data['JournalId'] = journalId;
    data['UserId'] = userId;
    data['CompanyId'] = companyId;
    data['State'] = state;
    data['ShowState'] = showState;
    data['Difference'] = difference;
    data['BalanceEnd'] = balanceEnd;
    data['BalanceEndReal'] = balanceEndReal;
    data['PosSessionId'] = posSessionId;
    data['TotalEntryEncoding'] = totalEntryEncoding;
    data['AccountId'] = accountId;
    data['CurrencyId'] = currencyId;
    if (journal != null) {
      data['Journal'] = journal.toJson();
    }
    return data;
  }
}

class PosJournal {
  PosJournal(
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
      this.dedicatedRefund});

  PosJournal.fromJson(Map<String, dynamic> json) {
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
  int amountAuthorizedDiff;
  bool dedicatedRefund;

  Map<String, dynamic> toJson() {
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
    return data;
  }
}
