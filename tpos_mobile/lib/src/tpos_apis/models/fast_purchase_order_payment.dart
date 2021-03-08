import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/data_helper.dart';

class FastPurchaseOrderPayment {
  FastPurchaseOrderPayment(
      {this.id,
      this.companyId,
      this.currencyId,
      this.partnerId,
      this.partnerDisplayName,
      this.contactId,
      this.contactName,
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
      this.companyName,
      this.orderCode,
      this.saleOrderId,
      this.currency,
      this.fastPurchaseOrders,
      this.journal});

  FastPurchaseOrderPayment.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    companyId = json['CompanyId'];
    currencyId = json['CurrencyId'];
    partnerId = json['PartnerId'];
    partnerDisplayName = json['PartnerDisplayName'];
    contactId = json['ContactId'];
    contactName = json['ContactName'];
    paymentMethodId = json['PaymentMethodId'];
    partnerType = json['PartnerType'];
    paymentDate = json['PaymentDate'];
    dateCreated = json['DateCreated'];
    journalId = json['JournalId'];
    journalName = json['JournalName'];
    state = json['State'];
    name = json['Name'];
    paymentType = json['PaymentType'];
    amount = json['Amount'];
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
    companyName = json['CompanyName'];
    orderCode = json['OrderCode'];
    saleOrderId = json['SaleOrderId'];
    currency =
        json['Currency'] != null ? Currency.fromJson(json['Currency']) : null;
    if (json['FastPurchaseOrders'] != null) {
      fastPurchaseOrders = <FastPurchaseOrders>[];
      json['FastPurchaseOrders'].forEach((v) {
        fastPurchaseOrders.add(FastPurchaseOrders.fromJson(v));
      });
    }
    journal =
        json['Journal'] != null ? JournalFPO.fromJson(json['Journal']) : null;
  }
  dynamic id;
  dynamic companyId;
  dynamic currencyId;
  dynamic partnerId;
  dynamic partnerDisplayName;
  dynamic contactId;
  dynamic contactName;
  dynamic paymentMethodId;
  String partnerType;
  String paymentDate;
  String dateCreated;
  dynamic journalId;
  dynamic journalName;
  String state;
  dynamic name;
  String paymentType;
  dynamic amount;
  dynamic amountStr;
  String communication;
  dynamic searchDate;
  String stateGet;
  dynamic paymentType2;
  dynamic description;
  String paymentDifferenceHandling;
  dynamic writeoffAccountId;
  dynamic paymentDifference;
  dynamic senderReceiver;
  dynamic phone;
  dynamic address;
  dynamic accountId;
  dynamic accountName;
  dynamic companyName;
  dynamic orderCode;
  dynamic saleOrderId;
  Currency currency;
  List<FastPurchaseOrders> fastPurchaseOrders;
  JournalFPO journal;
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['CompanyId'] = companyId;
    data['CurrencyId'] = currencyId;
    data['PartnerId'] = partnerId;
    data['PartnerDisplayName'] = partnerDisplayName;
    data['ContactId'] = contactId;
    data['ContactName'] = contactName;
    data['PaymentMethodId'] = paymentMethodId;
    data['PartnerType'] = partnerType;
    data['PaymentDate'] = dateTimeOffset(convertDateTime(paymentDate));
    data['DateCreated'] = dateTimeOffset(convertDateTime(dateCreated));
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
    data['CompanyName'] = companyName;
    data['OrderCode'] = orderCode;
    data['SaleOrderId'] = saleOrderId;
    if (currency != null) {
      data['Currency'] = currency.toJson();
    }
    if (fastPurchaseOrders != null) {
      data['FastPurchaseOrders'] =
          fastPurchaseOrders.map((v) => v.toJson()).toList();
    }
    if (journal != null) {
      data['Journal'] = journal.toJson();
    }
    return data;
  }
}

class Currency {
  Currency(
      {this.id,
      this.name,
      this.rounding,
      this.symbol,
      this.active,
      this.position,
      this.rate});
  Currency.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    rounding = json['Rounding'];
    symbol = json['Symbol'];
    active = json['Active'];
    position = json['Position'];
    rate = json['Rate'];
  }

  dynamic id;
  String name;
  dynamic rounding;
  dynamic symbol;
  bool active;
  String position;
  dynamic rate;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Name'] = name;
    data['Rounding'] = rounding;
    data['Symbol'] = symbol;
    data['Active'] = active;
    data['Position'] = position;
    data['Rate'] = rate;
    return data;
  }
}

class FastPurchaseOrders {
  FastPurchaseOrders({
    this.id,
    this.name,
    this.partnerId,
    this.partnerDisplayName,
    this.state,
    this.date,
    this.pickingTypeId,
    this.amountTotal,
    this.amount,
    this.discount,
    this.discountAmount,
    this.decreaseAmount,
    this.amountTax,
    this.amountUntaxed,
    this.taxId,
    this.note,
    this.companyId,
    this.journalId,
    this.dateInvoice,
    this.number,
    this.type,
    this.residual,
    this.refundOrderId,
    this.reconciled,
    this.accountId,
    this.userId,
    this.amountTotalSigned,
    this.residualSigned,
    this.userName,
    this.partnerNameNoSign,
    this.paymentJournalId,
    this.paymentAmount,
    this.origin,
    this.companyName,
    this.partnerPhone,
    this.address,
    this.dateCreated,
    this.taxView,
    this.paymentInfo,
    this.outstandingInfo,
//    this.journal,
  });

  FastPurchaseOrders.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    partnerId = json['PartnerId'];
    partnerDisplayName = json['PartnerDisplayName'];
    state = json['State'];
    date = json['Date'];
    pickingTypeId = json['PickingTypeId'];
    amountTotal = json['AmountTotal'];
    amount = json['Amount'];
    discount = json['Discount'];
    discountAmount = json['DiscountAmount'];
    decreaseAmount = json['DecreaseAmount'];
    amountTax = json['AmountTax'];
    amountUntaxed = json['AmountUntaxed'];
    taxId = json['TaxId'];
    note = json['Note'];
    companyId = json['CompanyId'];
    journalId = json['JournalId'];
    dateInvoice = json['DateInvoice'];
    number = json['Number'];
    type = json['Type'];
    residual = json['Residual'];
    refundOrderId = json['RefundOrderId'];
    reconciled = json['Reconciled'];
    accountId = json['AccountId'];
    userId = json['UserId'];
    amountTotalSigned = json['AmountTotalSigned'];
    residualSigned = json['ResidualSigned'];
    userName = json['UserName'];
    partnerNameNoSign = json['PartnerNameNoSign'];
    paymentJournalId = json['PaymentJournalId'];
    paymentAmount = json['PaymentAmount'];
    origin = json['Origin'];
    companyName = json['CompanyName'];
    partnerPhone = json['PartnerPhone'];
    address = json['Address'];
    dateCreated = json['DateCreated'];
    taxView = json['TaxView'];
    if (json['PaymentInfo'] != null) {
      paymentInfo = <dynamic>[];
      /* json['PaymentInfo'].forEach((v) {
        paymentInfo.add(new Null.fromJson(v));
      });*/
    }
    outstandingInfo = json['OutstandingInfo'];
    //journal = JournalFPO.fromJson(json['Journal']);
  }
  dynamic id;
  dynamic name;
  dynamic partnerId;
  String partnerDisplayName;
  String state;
  dynamic date;
  dynamic pickingTypeId;
  dynamic amountTotal;
  dynamic amount;
  dynamic discount;
  dynamic discountAmount;
  dynamic decreaseAmount;
  dynamic amountTax;
  dynamic amountUntaxed;
  dynamic taxId;
  dynamic note;
  dynamic companyId;
  dynamic journalId;
  String dateInvoice;
  String number;
  String type;
  dynamic residual;
  dynamic refundOrderId;
  bool reconciled;
  dynamic accountId;
  String userId;
  dynamic amountTotalSigned;
  dynamic residualSigned;
  String userName;
  String partnerNameNoSign;
  dynamic paymentJournalId;
  dynamic paymentAmount;
  dynamic origin;
  String companyName;
  dynamic partnerPhone;
  dynamic address;
  String dateCreated;
  dynamic taxView;
  List<dynamic> paymentInfo;
  dynamic outstandingInfo;
  //JournalFPO journal;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Name'] = name;
    data['PartnerId'] = partnerId;
    data['PartnerDisplayName'] = partnerDisplayName;
    data['State'] = state;
    data['Date'] = date;
    data['PickingTypeId'] = pickingTypeId;
    data['AmountTotal'] = amountTotal;
    data['Amount'] = amount;
    data['Discount'] = discount;
    data['DiscountAmount'] = discountAmount;
    data['DecreaseAmount'] = decreaseAmount;
    data['AmountTax'] = amountTax;
    data['AmountUntaxed'] = amountUntaxed;
    data['TaxId'] = taxId;
    data['Note'] = note;
    data['CompanyId'] = companyId;
    data['JournalId'] = journalId;
    data['DateInvoice'] = dateInvoice;
    data['Number'] = number;
    data['Type'] = type;
    data['Residual'] = residual;
    data['RefundOrderId'] = refundOrderId;
    data['Reconciled'] = reconciled;
    data['AccountId'] = accountId;
    data['UserId'] = userId;
    data['AmountTotalSigned'] = amountTotalSigned;
    data['ResidualSigned'] = residualSigned;
    data['UserName'] = userName;
    data['PartnerNameNoSign'] = partnerNameNoSign;
    data['PaymentJournalId'] = paymentJournalId;
    data['PaymentAmount'] = paymentAmount;
    data['Origin'] = origin;
    data['CompanyName'] = companyName;
    data['PartnerPhone'] = partnerPhone;
    data['Address'] = address;
    data['DateCreated'] = dateCreated;
    data['TaxView'] = taxView;
    if (paymentInfo != null) {
      data['PaymentInfo'] = [];
    }
    data['OutstandingInfo'] = outstandingInfo;
    //data['Journal'] = this.journal;
    return data;
  }
}

class JournalFPO {
  JournalFPO(
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

  JournalFPO.fromJson(Map<String, dynamic> json) {
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

  dynamic id;
  String code;
  String name;
  String type;
  bool updatePosted;
  dynamic currencyId;
  dynamic defaultDebitAccountId;
  dynamic defaultCreditAccountId;
  dynamic companyId;
  String companyName;
  bool journalUser;
  dynamic profitAccountId;
  dynamic lossAccountId;
  dynamic amountAuthorizedDiff;
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
