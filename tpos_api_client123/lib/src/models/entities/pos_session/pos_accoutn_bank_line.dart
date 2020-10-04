class PosAccountBankLine {
  PosAccountBankLine(
      {this.id,
      this.statementId,
      this.statementName,
      this.sequence,
      this.journalId,
      this.journalName,
      this.partnerId,
      this.partnerName,
      this.companyId,
      this.note,
      this.ref,
      this.accountId,
      this.moveName,
      this.date,
      this.currencyId,
      this.name,
      this.amount,
      this.amountCurrency,
      this.posStatementId});

  PosAccountBankLine.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    statementId = json['StatementId'];
    statementName = json['StatementName'];
    sequence = json['Sequence'];
    journalId = json['JournalId'];
    journalName = json['JournalName'];
    partnerId = json['PartnerId'];
    partnerName = json['PartnerName'];
    companyId = json['CompanyId'];
    note = json['Note'];
    ref = json['Ref'];
    accountId = json['AccountId'];
    moveName = json['MoveName'];
    date = json['Date'];
    currencyId = json['CurrencyId'];
    name = json['Name'];
    amount = json['Amount'];
    amountCurrency = json['AmountCurrency'];
    posStatementId = json['PosStatementId'];
  }

  int id;
  int statementId;
  String statementName;
  int sequence;
  int journalId;
  String journalName;
  int partnerId;
  String partnerName;
  int companyId;
  String note;
  String ref;
  int accountId;
  String moveName;
  String date;
  String currencyId;
  String name;
  double amount;
  String amountCurrency;
  int posStatementId;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['StatementId'] = statementId;
    data['StatementName'] = statementName;
    data['Sequence'] = sequence;
    data['JournalId'] = journalId;
    data['JournalName'] = journalName;
    data['PartnerId'] = partnerId;
    data['PartnerName'] = partnerName;
    data['CompanyId'] = companyId;
    data['Note'] = note;
    data['Ref'] = ref;
    data['AccountId'] = accountId;
    data['MoveName'] = moveName;
    data['Date'] = date;
    data['CurrencyId'] = currencyId;
    data['Name'] = name;
    data['Amount'] = amount;
    data['AmountCurrency'] = amountCurrency;
    data['PosStatementId'] = posStatementId;
    return data;
  }
}
