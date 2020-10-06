import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/data_helper.dart';

class FastPurchaseOrderPayment {
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
    currency = json['Currency'] != null
        ? new Currency.fromJson(json['Currency'])
        : null;
    if (json['FastPurchaseOrders'] != null) {
      fastPurchaseOrders = new List<FastPurchaseOrders>();
      json['FastPurchaseOrders'].forEach((v) {
        fastPurchaseOrders.add(new FastPurchaseOrders.fromJson(v));
      });
    }
    journal = json['Journal'] != null
        ? new JournalFPO.fromJson(json['Journal'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['CompanyId'] = this.companyId;
    data['CurrencyId'] = this.currencyId;
    data['PartnerId'] = this.partnerId;
    data['PartnerDisplayName'] = this.partnerDisplayName;
    data['ContactId'] = this.contactId;
    data['ContactName'] = this.contactName;
    data['PaymentMethodId'] = this.paymentMethodId;
    data['PartnerType'] = this.partnerType;
    data['PaymentDate'] = dateTimeOffset(convertDateTime(this.paymentDate));
    data['DateCreated'] = dateTimeOffset(convertDateTime(this.dateCreated));
    data['JournalId'] = this.journalId;
    data['JournalName'] = this.journalName;
    data['State'] = this.state;
    data['Name'] = this.name;
    data['PaymentType'] = this.paymentType;
    data['Amount'] = this.amount;
    data['AmountStr'] = this.amountStr;
    data['Communication'] = this.communication;
    data['SearchDate'] = this.searchDate;
    data['StateGet'] = this.stateGet;
    data['PaymentType2'] = this.paymentType2;
    data['Description'] = this.description;
    data['PaymentDifferenceHandling'] = this.paymentDifferenceHandling;
    data['WriteoffAccountId'] = this.writeoffAccountId;
    data['PaymentDifference'] = this.paymentDifference;
    data['SenderReceiver'] = this.senderReceiver;
    data['Phone'] = this.phone;
    data['Address'] = this.address;
    data['AccountId'] = this.accountId;
    data['AccountName'] = this.accountName;
    data['CompanyName'] = this.companyName;
    data['OrderCode'] = this.orderCode;
    data['SaleOrderId'] = this.saleOrderId;
    if (this.currency != null) {
      data['Currency'] = this.currency.toJson();
    }
    if (this.fastPurchaseOrders != null) {
      data['FastPurchaseOrders'] =
          this.fastPurchaseOrders.map((v) => v.toJson()).toList();
    }
    if (this.journal != null) {
      data['Journal'] = this.journal.toJson();
    }
    return data;
  }
}

class Currency {
  dynamic id;
  String name;
  dynamic rounding;
  dynamic symbol;
  bool active;
  String position;
  dynamic rate;

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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['Rounding'] = this.rounding;
    data['Symbol'] = this.symbol;
    data['Active'] = this.active;
    data['Position'] = this.position;
    data['Rate'] = this.rate;
    return data;
  }
}

class FastPurchaseOrders {
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
      paymentInfo = new List<dynamic>();
      /* json['PaymentInfo'].forEach((v) {
        paymentInfo.add(new Null.fromJson(v));
      });*/
    }
    outstandingInfo = json['OutstandingInfo'];
    //journal = JournalFPO.fromJson(json['Journal']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['PartnerId'] = this.partnerId;
    data['PartnerDisplayName'] = this.partnerDisplayName;
    data['State'] = this.state;
    data['Date'] = this.date;
    data['PickingTypeId'] = this.pickingTypeId;
    data['AmountTotal'] = this.amountTotal;
    data['Amount'] = this.amount;
    data['Discount'] = this.discount;
    data['DiscountAmount'] = this.discountAmount;
    data['DecreaseAmount'] = this.decreaseAmount;
    data['AmountTax'] = this.amountTax;
    data['AmountUntaxed'] = this.amountUntaxed;
    data['TaxId'] = this.taxId;
    data['Note'] = this.note;
    data['CompanyId'] = this.companyId;
    data['JournalId'] = this.journalId;
    data['DateInvoice'] = this.dateInvoice;
    data['Number'] = this.number;
    data['Type'] = this.type;
    data['Residual'] = this.residual;
    data['RefundOrderId'] = this.refundOrderId;
    data['Reconciled'] = this.reconciled;
    data['AccountId'] = this.accountId;
    data['UserId'] = this.userId;
    data['AmountTotalSigned'] = this.amountTotalSigned;
    data['ResidualSigned'] = this.residualSigned;
    data['UserName'] = this.userName;
    data['PartnerNameNoSign'] = this.partnerNameNoSign;
    data['PaymentJournalId'] = this.paymentJournalId;
    data['PaymentAmount'] = this.paymentAmount;
    data['Origin'] = this.origin;
    data['CompanyName'] = this.companyName;
    data['PartnerPhone'] = this.partnerPhone;
    data['Address'] = this.address;
    data['DateCreated'] = this.dateCreated;
    data['TaxView'] = this.taxView;
    if (this.paymentInfo != null) {
      data['PaymentInfo'] = [];
    }
    data['OutstandingInfo'] = this.outstandingInfo;
    //data['Journal'] = this.journal;
    return data;
  }
}

class JournalFPO {
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Code'] = this.code;
    data['Name'] = this.name;
    data['Type'] = this.type;
    data['UpdatePosted'] = this.updatePosted;
    data['CurrencyId'] = this.currencyId;
    data['DefaultDebitAccountId'] = this.defaultDebitAccountId;
    data['DefaultCreditAccountId'] = this.defaultCreditAccountId;
    data['CompanyId'] = this.companyId;
    data['CompanyName'] = this.companyName;
    data['JournalUser'] = this.journalUser;
    data['ProfitAccountId'] = this.profitAccountId;
    data['LossAccountId'] = this.lossAccountId;
    data['AmountAuthorizedDiff'] = this.amountAuthorizedDiff;
    data['DedicatedRefund'] = this.dedicatedRefund;
    return data;
  }
}
