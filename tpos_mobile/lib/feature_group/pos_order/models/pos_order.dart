import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/point_sale.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/pos_config.dart';

import 'application_user.dart';

class PosOrderResult {
  PosOrderResult({this.data, this.total, this.aggregates});

  PosOrderResult.fromJson(Map<String, dynamic> json) {
    if (json['Data'] != null) {
      data = <PosOrder>[];
      json['Data'].forEach((v) {
        data.add(PosOrder.fromJson(v));
      });
    }
    total = json['Total'];
    aggregates = json['Aggregates'];
  }

  List<PosOrder> data;
  int total;
  dynamic aggregates;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['Data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['Total'] = total;
    data['Aggregates'] = aggregates;
    return data;
  }
}

class PosOrder {
  PosOrder(
      {this.id,
      this.name,
      this.companyId,
      this.companyName,
      this.company,
      this.dateOrder,
      this.userId,
      this.user,
      this.userName,
      this.priceListId,
      this.priceList,
      this.priceListName,
      this.partnerId,
      this.partner,
      this.partnerName,
      this.partnerRef,
      this.sequenceNumber,
      this.sessionId,
      this.session,
      this.sessionName,
      this.state,
      this.showState,
      this.beganPoints,
      this.invoiceId,
      this.accountMoveId,
      this.pickingId,
      this.pickingName,
      this.locationId,
      this.locationName,
      this.note,
      this.nbPrint,
      this.pOSReference,
      this.saleJournalId,
      this.dateCreated,
      this.amountSubTotal,
      this.amountDiscount,
      this.amountTax,
      this.amountUntaxed,
      this.amountTotal,
      this.amountPaid,
      this.amountReturn,
      this.wonPoints,
      this.spentPoints,
      this.totalPoints,
      this.tableId,
      this.table,
      this.customerCount,
      this.lines,
      this.taxId,
      this.tax,
      this.discount,
      this.discountFixed,
      this.discountType});

  PosOrder.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    companyId = json['CompanyId'];
    companyName = json['CompanyName'];
    if (json['Company'] != null) {
      company = Company.fromJson(json['Company']);
    } else {
      company = null;
    }
    if (json["DateOrder"] != null) {
      final String unixTimeStr =
          RegExp(r"(?<=Date\()\d+").stringMatch(json["DateOrder"]);

      if (unixTimeStr != null && unixTimeStr.isNotEmpty) {
        final int unixTime = int.parse(unixTimeStr);
        dateOrder = DateTime.fromMillisecondsSinceEpoch(unixTime);
      } else {
        if (json["DateOrder"] != null) {
          dateOrder = DateTime.parse(json["DateOrder"]).toUtc();
        }
      }
    }
    userId = json['UserId'];
    if (json["User"] != null) {
      user = PosApplicationUser.fromJson(json["User"]);
    }
    userName = json['UserName'];
    priceListId = json['PriceListId'];
    if (json["PriceList"] != null) {
      priceList = ProductPrice.fromJson(json["PriceList"]);
    }
    priceListName = json['PriceListName'];
    partnerId = json['PartnerId'];
    if (json["Partner"] != null) {
      partner = Partner.fromJson(json["Partner"]);
    }
    partnerName = json['PartnerName'];
    partnerRef = json['PartnerRef'];
    sequenceNumber = json['SequenceNumber'];
    sessionId = json['SessionId'];
    if (json['Session'] != null) {
      session = Session.fromJson(json['Session']);
    } else {
      session = null;
    }
    sessionName = json['SessionName'];
    state = json['State'];
    showState = json['ShowState'];
    beganPoints = json['BeganPoints'].toDouble();
    invoiceId = json['InvoiceId'];
    accountMoveId = json['AccountMoveId'];
    pickingId = json['PickingId'];
    pickingName = json['PickingName'];
    locationId = json['LocationId'];
    locationName = json['LocationName'];
    note = json['Note'];
    nbPrint = json['NbPrint'];
    pOSReference = json['POSReference'];
    saleJournalId = json['SaleJournalId'];
    dateCreated = json['DateCreated'];
    amountSubTotal = json['AmountSubTotal'];
    amountDiscount = json['AmountDiscount'];
    amountTax = json['AmountTax'];
    amountUntaxed = json['AmountUntaxed'];
    amountTotal = json['AmountTotal'];
    amountPaid = json['AmountPaid'];
    amountReturn = json['AmountReturn'];
    wonPoints = json['Won_Points'];
    spentPoints = json['Spent_Points'];
    totalPoints = json['Total_Points'];
    tableId = json['TableId'];
    table = json['Table'];
    customerCount = json['CustomerCount'];
    if (json['Lines'] != null) {
      lines = <Null>[];
      json['Lines'].forEach((v) {
        lines.add(PosOrderLine.fromJson(v));
      });
    }
    taxId = json['TaxId'];
    if (json["Tax"] != null) {
      tax = Tax.fromJson(json['Tax']);
    }
    discount = json['Discount'];
    discountFixed = json['DiscountFixed'];
    discountType = json['DiscountType'];
  }

  int id;
  String name;
  int companyId;
  String companyName;
  Company company;
  DateTime dateOrder;
  String userId;
  PosApplicationUser user;
  String userName;
  int priceListId;
  ProductPrice priceList;
  String priceListName;
  int partnerId;
  Partner partner;
  String partnerName;
  String partnerRef;
  int sequenceNumber;
  int sessionId;
  Session session;
  String sessionName;
  String state;
  String showState;
  double beganPoints;
  int invoiceId;
  int accountMoveId;
  int pickingId;
  String pickingName;
  int locationId;
  String locationName;
  String note;
  int nbPrint;
  String pOSReference;
  int saleJournalId;
  String dateCreated;
  double amountSubTotal;
  double amountDiscount;
  double amountTax;
  double amountUntaxed;
  double amountTotal;
  double amountPaid;
  double amountReturn;
  double wonPoints;
  double spentPoints;
  double totalPoints;
  dynamic tableId;
  dynamic table;
  int customerCount;
  List<PosOrderLine> lines;
  int taxId;
  Tax tax;
  double discount;
  double discountFixed;
  String discountType;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Name'] = name;
    data['CompanyId'] = companyId;
    data['CompanyName'] = companyName;
    if (company != null) {
      data['Company'] = company.toJson();
    }
    data['DateOrder'] = dateOrder.toUtc().toIso8601String();
    data['UserId'] = userId;
    data['User'] = user;
    data['UserName'] = userName;
    data['PriceListId'] = priceListId;
    data['PriceList'] = priceList;
    data['PriceListName'] = priceListName;
    data['PartnerId'] = partnerId;
    data['Partner'] = partner;
    data['PartnerName'] = partnerName;
    data['PartnerRef'] = partnerRef;
    data['SequenceNumber'] = sequenceNumber;
    data['SessionId'] = sessionId;
    data['Session'] = session;
    data['SessionName'] = sessionName;
    data['State'] = state;
    data['ShowState'] = showState;
    data['BeganPoints'] = beganPoints;
    data['InvoiceId'] = invoiceId;
    data['AccountMoveId'] = accountMoveId;
    data['PickingId'] = pickingId;
    data['PickingName'] = pickingName;
    data['LocationId'] = locationId;
    data['LocationName'] = locationName;
    data['Note'] = note;
    data['NbPrint'] = nbPrint;
    data['POSReference'] = pOSReference;
    data['SaleJournalId'] = saleJournalId;
    data['DateCreated'] = dateCreated;
    data['AmountSubTotal'] = amountSubTotal;
    data['AmountDiscount'] = amountDiscount;
    data['AmountTax'] = amountTax;
    data['AmountUntaxed'] = amountUntaxed;
    data['AmountTotal'] = amountTotal;
    data['AmountPaid'] = amountPaid;
    data['AmountReturn'] = amountReturn;
    data['Won_Points'] = wonPoints;
    data['Spent_Points'] = spentPoints;
    data['Total_Points'] = totalPoints;
    data['TableId'] = tableId;
    data['Table'] = table;
    data['CustomerCount'] = customerCount;
    if (lines != null) {
      data['Lines'] = lines.map((v) => v.toJson()).toList();
    }
    data['TaxId'] = taxId;
    data['Tax'] = tax;
    data['Discount'] = discount;
    data['DiscountFixed'] = discountFixed;
    data['DiscountType'] = discountType;
    return data;
  }
}

class Session {
  Session(
      {this.id,
      this.configId,
      this.configName,
      this.name,
      this.userId,
      this.userName,
      this.startAt,
      this.stopAt,
      this.state,
      this.showState,
      this.sequenceNumber,
      this.loginNumber,
      this.cashControl,
      this.cashRegisterId,
      this.cashRegisterBalanceStart,
      this.cashRegisterTotalEntryEncoding,
      this.cashRegisterBalanceEnd,
      this.cashRegisterBalanceEndReal,
      this.cashRegisterDifference,
      this.dateCreated,
      this.user,
      this.config});

  Session.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    configId = json['ConfigId'];
    configName = json['ConfigName'];
    name = json['Name'];
    userId = json['UserId'];
    userName = json['UserName'];
    startAt = json['StartAt'];
    stopAt = json['StopAt'];
    state = json['State'];
    showState = json['ShowState'];
    sequenceNumber = json['SequenceNumber'];
    loginNumber = json['LoginNumber'];
    cashRegisterId = json['CashRegisterId'];
    cashRegisterBalanceStart = json['CashRegisterBalanceStart'] == 0 ? 0 : 0;
    cashRegisterTotalEntryEncoding =
        json['CashRegisterTotalEntryEncoding'] == 0 ? 0 : 0;
    cashRegisterBalanceEnd = json['CashRegisterBalanceEnd'] == 0 ? 0 : 0;
    cashRegisterBalanceEndReal =
        json['CashRegisterBalanceEndReal'] == 0 ? 0 : 0;
    cashRegisterDifference = json['CashRegisterDifference'] == 0 ? 0 : 0;
    dateCreated = json['DateCreated'];
    user = json['User'] != null ? User.fromJson(json['User']) : null;
    config = json['Config'] != null ? PosConfig.fromJson(json['Config']) : null;
  }

  int id;
  int configId;
  String configName;
  String name;
  String userId;
  String userName;
  String startAt;
  String stopAt;
  String state;
  String showState;
  int sequenceNumber;
  int loginNumber;
  bool cashControl;
  int cashRegisterId;
  double cashRegisterBalanceStart;
  double cashRegisterTotalEntryEncoding;
  double cashRegisterBalanceEnd;
  double cashRegisterBalanceEndReal;
  double cashRegisterDifference;
  String dateCreated;
  User user;
  PosConfig config;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['ConfigId'] = configId;
    data['ConfigName'] = configName;
    data['Name'] = name;
    data['UserId'] = userId;
    data['UserName'] = userName;
    data['StartAt'] = startAt;
    data['StopAt'] = stopAt;
    data['State'] = state;
    data['ShowState'] = showState;
    data['SequenceNumber'] = sequenceNumber;
    data["LoginNumber"] = loginNumber;
    if (cashControl != null) {
      data['CashControl'] = cashControl;
    }
    data['CashRegisterId'] = cashRegisterId;
    data['CashRegisterBalanceStart'] = cashRegisterBalanceStart;
    data['CashRegisterTotalEntryEncoding'] = cashRegisterTotalEntryEncoding;
    data['CashRegisterBalanceEnd'] = cashRegisterBalanceEnd;
    data['CashRegisterBalanceEndReal'] = cashRegisterBalanceEndReal;
    data['CashRegisterDifference'] = cashRegisterDifference;
    data['DateCreated'] = dateCreated;
    if (user != null) {
      data['User'] = user.toJson();
    }
    if (config != null) {
      data['Config'] = config.toJson();
    }
    return data;
  }
}

class PosOrderSort {
  PosOrderSort(this.id, this.name, this.value, this.orderBy);

  String name;
  int id;
  String value;
  String orderBy;
}

class PosOrderLine {
  PosOrderLine(
      {this.id,
      this.companyId,
      this.name,
      this.notice,
      this.productId,
      this.uOMId,
      this.uOMName,
      this.productNameGet,
      this.priceUnit,
      this.qty,
      this.discount,
      this.orderId,
      this.priceSubTotal,
      this.product,
      this.uOM});

  PosOrderLine.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    companyId = json['CompanyId'];
    name = json['Name'];
    notice = json['Notice'];
    productId = json['ProductId'];
    uOMId = json['UOMId'];
    uOMName = json['UOMName'];
    productNameGet = json['ProductNameGet'];
    priceUnit = json['PriceUnit'];
    qty = json['Qty'];
    discount = json['Discount'];
    orderId = json['OrderId'];
    priceSubTotal = json['PriceSubTotal'];
    if (json['Product'] != null) {
      product = Product.fromJson(json['Product']);
    } else {
      product = null;
    }
    if (json['UOM'] != null) {
      uOM = ProductUOM.fromJson(json['UOM']);
    } else {
      uOM = null;
    }
  }

  int id;
  int companyId;
  String name;
  String notice;
  int productId;
  int uOMId;
  String uOMName;
  String productNameGet;
  double priceUnit;
  double qty;
  double discount;
  int orderId;
  double priceSubTotal;
  Product product;
  ProductUOM uOM;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['CompanyId'] = companyId;
    data['Name'] = name;
    data['Notice'] = notice;
    data['ProductId'] = productId;
    data['UOMId'] = uOMId;
    data['UOMName'] = uOMName;
    data['ProductNameGet'] = productNameGet;
    data['PriceUnit'] = priceUnit;
    data['Qty'] = qty;
    data['Discount'] = discount;
    data['OrderId'] = orderId;
    data['PriceSubTotal'] = priceSubTotal;
    if (product != null) {
      data['Product'] = product.toJson();
    }
    if (uOM != null) {
      data['UOM'] = uOM.toJson();
    }
    return data;
  }
}

class PosAccountBankStatement {
  PosAccountBankStatement(
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

  PosAccountBankStatement.fromJson(Map<String, dynamic> json) {
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
    if (json["Date"] != null) {
      date = DateTime.parse(json['Date']).toUtc();
    }
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
  DateTime date;
  int currencyId;
  String name;
  double amount;
  double amountCurrency;
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
