import 'package:tpos_mobile/feature_group/pos_order/models/pos_make_payment.dart';

class AccountBank {
  AccountBank(
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

  AccountBank.fromJson(Map<String, dynamic> json) {
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
        json['Journal'] != null ? Journal.fromJson(json['Journal']) : null;
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
  String balanceEndReal;
  int posSessionId;
  double totalEntryEncoding;
  int accountId;
  int currencyId;
  Journal journal;

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
