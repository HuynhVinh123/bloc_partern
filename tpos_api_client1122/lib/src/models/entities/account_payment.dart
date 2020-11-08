import 'package:intl/intl.dart';
import 'package:tpos_api_client/src/models/entities/currency.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

class AccountPayment {
  AccountPayment(
      {this.odataContext,
      this.id,
      this.companyId,
      this.currencyId,
      this.partnerId,
      this.partnerDisplayName,
      this.paymentMethodId,
      this.partnerType,
      this.paymentDate,
      this.dateCreated,
      this.journalId,
      this.journalName,
      this.state,
      this.name,
      this.paymentType,
      this.amount,
      this.amountStr,
      this.communication,
      this.searchDate,
      this.stateGet,
      this.paymentType2,
      this.description,
      this.paymentDifferenceHandling,
      this.writeoffAccountId,
      this.paymentDifference,
      this.senderReceiver,
      this.phone,
      this.address,
      this.accountId,
      this.accountName,
      this.currency,
      this.fastSaleOrders,
      this.journal,
      this.account,
      this.partner,
      this.contact,
      this.contactId});

  AccountPayment.fromJson(Map<String, dynamic> json) {
    odataContext = json['@odata.context'];
    id = json['Id'];
    companyId = json['CompanyId'];
    currencyId = json['CurrencyId'];
    partnerId = json['PartnerId'];
    partnerDisplayName = json['PartnerDisplayName'];
    paymentMethodId = json['PaymentMethodId'];
    partnerType = json['PartnerType'];
    if (json["PaymentDate"] != null) {
      paymentDate = DateTime.parse(json["PaymentDate"]).toLocal();
    }
    if (json['DateCreated'] != null) {
      dateCreated = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSSSZZZZZZ")
          .parse(json['DateCreated']);
    }

    journalId = json['JournalId'];
    journalName = json['JournalName'];
    state = json['State'];
    name = json['Name'];
    paymentType = json['PaymentType'];
    amount = json['Amount']?.toDouble() ?? 0;
    amountStr = json['AmountStr'];
    communication = json['Communication'];
    searchDate = json['SearchDate'];
    stateGet = json['StateGet'];
    paymentType2 = json['PaymentType2'];
    description = json['Description'];
    paymentDifferenceHandling = json['PaymentDifferenceHandling'];
    writeoffAccountId = json['WriteoffAccountId'];
    paymentDifference = json['PaymentDifference'];
    senderReceiver = json['SenderReceiver'];
    phone = json['Phone'];
    address = json['Address'];
    accountId = json['AccountId'];
    accountName = json['AccountName'];
    contactId = json["ContactId"];
    currency =
        json['Currency'] != null ? Currency.fromJson(json['Currency']) : null;
    if (json['FastSaleOrders'] != null) {
      fastSaleOrders = <FastSaleOrder>[];
      json['FastSaleOrders'].forEach((v) {
        fastSaleOrders.add(FastSaleOrder.fromJson(v));
      });
    }

    if (json["Journal"] != null) {
      journal = AccountJournal.fromJson(json["Journal"]);
    }
    companyName = json['CompanyName'];
    if (json['Partner'] != null) {
      partner = Partner.fromJson(json['Partner']);
    }
    if (json['Contact'] != null) {
      contact = Partner.fromJson(json['Contact']);
    }
    if (json['Account'] != null) {
      account = Account.fromJson(json['Account']);
    }
  }
  String odataContext;
  int id;
  int companyId;
  int currencyId;
  int partnerId;
  String partnerDisplayName;
  int paymentMethodId;
  String partnerType;
  DateTime paymentDate;
  DateTime dateCreated;
  int journalId;
  String journalName;
  String state;
  String name;
  String paymentType;
  double amount;
  String amountStr;
  String communication;
  dynamic searchDate;
  String stateGet;
  String paymentType2;
  String description;
  String paymentDifferenceHandling;
  String writeoffAccountId;
  int paymentDifference;
  String senderReceiver;
  String phone;
  String address;
  int accountId;
  String accountName;
  Currency currency;
  List<FastSaleOrder> fastSaleOrders;
  AccountJournal journal;
  String companyName;
  Account account;
  Partner partner;
  Partner contact;
  int contactId;

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['CompanyId'] = companyId;
    data['CurrencyId'] = currencyId;
    data['PartnerId'] = partnerId;
    data['PartnerDisplayName'] = partnerDisplayName;
    data['PaymentMethodId'] = paymentMethodId;
    data['PartnerType'] = partnerType;
    if (paymentDate != null) {
      data['PaymentDate'] = paymentDate.toUtc().toIso8601String();
//          DateFormat("yyyy-MM-ddTHH:mm:ss'+07:00'").format( paymentDate);
    }

    if (dateCreated != null) {
      data['DateCreated'] =
          DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSSS'+07:00'").format(dateCreated);
    }

    data['JournalId'] = journalId;
    data['JournalName'] = journalName;
    data['State'] = state;
    data['Name'] = name;
    data['PaymentType'] = paymentType;
    data['Amount'] = amount;
    data['AmountStr'] = amountStr;
    data['Communication'] = communication;
    data['SearchDate'] = searchDate;
    data['StateGet'] = stateGet;
    data['PaymentType2'] = paymentType2;
    data['Description'] = description;
    data['PaymentDifferenceHandling'] = paymentDifferenceHandling;
    data['WriteoffAccountId'] = writeoffAccountId;
    data['PaymentDifference'] = paymentDifference;
    data['SenderReceiver'] = senderReceiver;
    data['Phone'] = phone;
    data['Address'] = address;
    data['AccountId'] = accountId;
    data['AccountName'] = accountName;
    if (currency != null) {
      data['Currency'] = currency.toJson();
    }
    if (fastSaleOrders != null) {
      data['FastSaleOrders'] = fastSaleOrders
          .map((v) => v.toJson(removeIfNull: removeIfNull))
          .toList();
    }

    data["Journal"] = journal?.toJson();
    data['CompanyName'] = companyName;
    data['Account'] = account?.toJson();
    data['Partner'] = partner?.toJson(true);
    data['Contact'] = contact?.toJson(true);
    data['ContactId'] = contactId;

    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
