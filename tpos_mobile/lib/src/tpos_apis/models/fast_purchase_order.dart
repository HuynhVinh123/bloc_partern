// To parse this JSON data, do
//
//     final fastPurchaseOrder = fastPurchaseOrderFromJson(jsonString);

import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/data_helper.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_purchase_order_account_tax.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_purchase_order_application_user.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_purchase_order_partner.dart';

class FastPurchaseOrder {
  FastPurchaseOrder({
    this.odataContext,
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
    this.partner,
    this.pickingType,
    this.company,
    this.journal,
    this.account,
    this.user,
    this.refundOrder,
    this.paymentJournal,
    this.tax,
    this.orderLines,
  });
  factory FastPurchaseOrder.fromJson(Map<String, dynamic> json) =>
      FastPurchaseOrder(
        odataContext: json["@odata.context"],
        id: json["Id"] ?? 0,
        name: json["Name"],
        partnerId: json["PartnerId"],
        partnerDisplayName: json["PartnerDisplayName"],
        state: json["State"],
        date: convertDateTime(json["Date"]),
        pickingTypeId: json["PickingTypeId"],
        amountTotal: json["AmountTotal"],
        amount: json["Amount"],
        discount: convertDouble(json["Discount"]),
        discountAmount: convertDouble(json["DiscountAmount"]),
        decreaseAmount: convertDouble(json["DecreaseAmount"]),
        amountTax: convertDouble(json["AmountTax"]),
        amountUntaxed: convertDouble(json["AmountUntaxed"]),
        taxId: json["TaxId"],
        note: json["Note"],
        companyId: json["CompanyId"],
        journalId: json["JournalId"],
        dateInvoice: convertDateTime(json["DateInvoice"]),
        number: json["Number"],
        type: json["Type"],
        residual: json["Residual"],
        refundOrderId: json["RefundOrderId"],
        reconciled: json["Reconciled"],
        accountId: json["AccountId"],
        userId: json["UserId"],
        amountTotalSigned: json["AmountTotalSigned"],
        residualSigned: json["ResidualSigned"],
        userName: json["UserName"],
        partnerNameNoSign: json["PartnerNameNoSign"],
        paymentJournalId: json["PaymentJournalId"],
        paymentAmount: json["PaymentAmount"] is int
            ? double.parse(json["PaymentAmount"].toString())
            : json["PaymentAmount"],
        origin: json["Origin"],
        companyName: json["CompanyName"],
        partnerPhone: json["PartnerPhone"],
        address: json["Address"],
        dateCreated: convertDateTime(json["DateCreated"]),
        taxView: json["TaxView"],
        paymentInfo: json["PaymentInfo"] != null
            ? List<PaymentInfoFP>.from(
                json["PaymentInfo"].map((x) => PaymentInfoFP.fromJson(x)))
            : null,
        outstandingInfo: json["OutstandingInfo"] != null
            ? OutstandingInfo.fromJson(json["OutstandingInfo"])
            : null,
        partner: json["Partner"] != null
            ? PartnerFPO.fromJson(json["Partner"])
            : null,
        pickingType: json["PickingType"] != null
            ? PickingTypeFP.fromJson(json["PickingType"])
            : null,
        company:
            json["Company"] != null ? Company.fromJson(json["Company"]) : null,
        journal:
            json["Journal"] != null ? Journal.fromJson(json["Journal"]) : null,
        account:
            json["Account"] != null ? Account.fromJson(json["Account"]) : null,
        user: json["User"] != null
            ? ApplicationUserFPO.fromJson(json["User"])
            : null,
        refundOrder: json["RefundOrder"] != null
            ? FastPurchaseOrder.fromJson(json["RefundOrder"])
            : null,
        paymentJournal: json["PaymentJournal"] != null
            ? Journal.fromJson(json["PaymentJournal"])
            : null,
        tax: json["Tax"] != null ? AccountTaxFPO.fromJson(json["Tax"]) : null,
        orderLines: json["OrderLines"] != null
            ? List<OrderLine>.from(
                json["OrderLines"].map((x) => OrderLine.fromJson(x)))
            : [],
      );

  FastPurchaseOrder.fromJsonResponse(Map<String, dynamic> json) {
    odataContext = json['@odata.context'];
    id = json['Id'];
    name = json['Name'];
    partnerId = json['PartnerId'];
    partnerDisplayName = json['PartnerDisplayName'];
    state = json['State'];
    date = convertDateTime(json["Date"]);
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
    dateInvoice = convertDateTime(json["DateInvoice"]);
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
    dateCreated = convertDateTime(json["DateCreated"]);
    taxView = json['TaxView'];
    if (json['PaymentInfo'] != null) {
      paymentInfo = <PaymentInfoFP>[];
      json['PaymentInfo'].forEach((v) {
        paymentInfo.add(PaymentInfoFP.fromJson(v));
      });
    }
    outstandingInfo = json['OutstandingInfo'] != null
        ? OutstandingInfo.fromJson(json['OutstandingInfo'])
        : null;
  }
  String odataContext;
  int id;
  String name;
  int partnerId;
  String partnerDisplayName;
  String state;
  DateTime date;
  int pickingTypeId;
  double amountTotal;
  double amount;
  double discount;
  double discountAmount;
  double decreaseAmount;
  dynamic amountTax;
  dynamic amountUntaxed;
  int taxId;
  String note;
  int companyId;
  int journalId;
  DateTime dateInvoice;
  String number;
  String type;
  double residual;
  dynamic refundOrderId;
  bool reconciled;
  int accountId;
  String userId;
  double amountTotalSigned;
  double residualSigned;
  String userName;
  String partnerNameNoSign;
  int paymentJournalId;
  double paymentAmount;
  dynamic origin;
  String companyName;
  dynamic partnerPhone;
  dynamic address;
  DateTime dateCreated;
  dynamic taxView;
  List<PaymentInfoFP> paymentInfo;
  OutstandingInfo outstandingInfo;
  PartnerFPO partner;
  PickingTypeFP pickingType;
  Company company;
  Journal journal;
  Account account;
  ApplicationUserFPO user;
  FastPurchaseOrder refundOrder;
  Journal paymentJournal;
  AccountTaxFPO tax;
  List<OrderLine> orderLines;

  Map<String, dynamic> toJson() => {
        "Id": id ?? 0,
        "Name": name,
        "PartnerId": partnerId,
        "PartnerDisplayName": partnerDisplayName,
        "State": state,
        "Date": dateTimeOffset(date),
        "PickingTypeId": pickingTypeId,
        "AmountTotal": amountTotal,
        "Amount": amount,
        "Discount": discount,
        "DiscountAmount": discountAmount,
        "DecreaseAmount": decreaseAmount,
        "AmountTax": amountTax,
        "AmountUntaxed": amountUntaxed,
        "TaxId": taxId,
        "Note": note,
        "CompanyId": companyId,
        "JournalId": journalId,
        "DateInvoice": dateTimeOffset(dateInvoice ?? DateTime.now()),
        "Number": number,
        "Type": type,
        "Residual": residual,
        "RefundOrderId": refundOrderId,
        "Reconciled": reconciled,
        "AccountId": accountId,
        "UserId": userId,
        "AmountTotalSigned": amountTotalSigned,
        "ResidualSigned": residualSigned,
        "UserName": userName,
        "PartnerNameNoSign": partnerNameNoSign,
        "PaymentJournalId": paymentJournalId,
        "PaymentAmount": paymentAmount,
        "Origin": origin,
        "CompanyName": companyName,
        "PartnerPhone": partnerPhone,
        "Address": address,
        "DateCreated": dateTimeOffset(dateCreated),
        "TaxView": taxView,
        "PaymentInfo": List<dynamic>.from(paymentInfo.map((x) => x.toJson())),
        "OutstandingInfo":
            outstandingInfo != null ? outstandingInfo.toJson() : null,
        "Partner": partner != null ? partner.toJson() : null,
        "PickingType": pickingType != null ? pickingType.toJson() : null,
        "Company": company != null ? company.toJson() : null,
        "Journal": journal != null ? journal.toJson() : null,
        "Account": account != null ? account.toJson() : null,
        "User": user != null ? user.toJson() : null,
        "RefundOrder": refundOrder,
        "PaymentJournal":
            paymentJournal != null ? paymentJournal.toJson() : null,
        "Tax": tax != null
            ? tax.name == "Không thuế"
                ? null
                : tax
            : null,
        "OrderLines": orderLines ?? [],
      };

  Map<String, dynamic> toJsonOnChangeProduct() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Name'] = name;
    data['PartnerId'] = partnerId;
    data['PartnerDisplayName'] = partnerDisplayName;
    data['State'] = state;
    data['Date'] = dateTimeOffset(date);
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
    data['DateInvoice'] = dateTimeOffset(dateInvoice);
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
    data['DateCreated'] = dateTimeOffset(dateCreated);
    data['TaxView'] = taxView;
    if (paymentInfo != null) {
      data['PaymentInfo'] = paymentInfo.map((v) => v.toJson()).toList();
    }
    data['OutstandingInfo'] = outstandingInfo;
    if (company != null) {
      data['Company'] = company.toJson();
    }
    if (pickingType != null) {
      data['PickingType'] = pickingType.toJson();
    }
    if (journal != null) {
      data['Journal'] = journal.toJson();
    }
    if (user != null) {
      data['User'] = user.toJson();
    }
    if (paymentJournal != null) {
      data['PaymentJournal'] = paymentJournal.toJson();
    }
    if (partner != null) {
      data['Partner'] = partner.toJson();
    }
    if (account != null) {
      data['Account'] = account.toJson();
    }
    return data;
  }
}

class OrderLine {
  OrderLine({
    this.id,
    this.productId,
    this.productName,
    this.productUOMId,
    this.productUomName,
    this.productQty,
    this.priceUnit,
    this.priceSubTotal,
    //this.priceTotal,
    this.priceRecent,
    this.discount,
    this.factor,
    this.name,
    this.state,
    this.accountId,
    this.priceSubTotalSigned,
    this.productNameGet,
    this.productBarcode,
    this.product,
    this.productUom,
    this.account,
  });

  factory OrderLine.fromJson(Map<String, dynamic> json) => OrderLine(
        id: json["Id"],
        productId: json["ProductId"],
        productName: json["ProductName"],
        productUOMId: json["ProductUOMId"],
        productUomName: json["ProductUOMName"],
        productQty: json["ProductQty"]?.toDouble(),
        priceUnit: convertDouble(json["PriceUnit"]),
        priceSubTotal: convertDouble(json["PriceSubTotal"]) ?? 0,
        // priceTotal: convertDouble(json["PriceTotal"]) ?? 0,
        priceRecent: convertDouble(json["PriceRecent"]),
        discount: convertDouble(json["Discount"]) ?? 0,
        factor: json["Factor"],
        name: json["Name"],
        state: json["State"],
        accountId: json["AccountId"],
        priceSubTotalSigned: convertDouble(json["PriceSubTotalSigned"]),
        productNameGet: json["ProductNameGet"],
        productBarcode: json["ProductBarcode"],
        product:
            json["Product"] != null ? Product.fromJson(json["Product"]) : null,
        productUom: ProductUOM.fromJson(json["ProductUOM"]),
        account: Account.fromJson(json["Account"]),
      );
  int id;
  int productId;
  String productName;
  int productUOMId;
  String productUomName;
  double productQty;
  double priceUnit;
  double priceSubTotal;
  //double priceTotal;
  double priceRecent;
  double discount;
  dynamic factor;
  String name;
  String state;
  int accountId;
  double priceSubTotalSigned;
  String productNameGet;
  String productBarcode;
  Product product;
  ProductUOM productUom;
  Account account;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != 0) {
      data["Id"] = id ?? 0;
    }

    data["ProductId"] = productId;
    data["ProductName"] = productName;
    data["ProductUOMId"] = productUOMId;
    data["ProductUOMName"] = productUomName;
    data["ProductQty"] = productQty;
    data["PriceUnit"] = priceUnit;
    data["PriceSubTotal"] = priceSubTotal;
    //data["PriceTotal"] = priceTotal;
    data["PriceRecent"] = priceRecent;
    data["Discount"] = discount;
    data["Factor"] = factor;
    data["Name"] = name;
    data["State"] = state;
    if (accountId != null) {
      data["AccountId"] = accountId;
    }

    data["PriceSubTotalSigned"] = priceSubTotalSigned;
    data["ProductNameGet"] = productNameGet;
    data["ProductBarcode"] = productBarcode;
    data["Product"] = product.toJson();
    data["ProductUOM"] = productUom != null ? productUom.toJson() : null;
    if (account != null) {
      data["Account"] = account.toJson();
    }

    return data;
  }

  /*Map<String, dynamic> toJson2() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    if (this.product != null) {
      data['Product'] = this.product.toJson();
    }
    data['Name'] = this.name;
    data['ProductId'] = this.productId;
    data['ProductUOMId'] = this.productUOMId;
    data['ProductQty'] = this.productQty;
    data['PriceUnit'] = this.priceUnit;
    data['Discount'] = this.discount;
    return data;
  }*/
}

class OutstandingInfo {
  OutstandingInfo({
    this.hasOutstanding,
    this.title,
    this.invoiceId,
    this.fastSaleOrderId,
    this.fastPurchaseOrderId,
  });

  factory OutstandingInfo.fromJson(Map<String, dynamic> json) =>
      OutstandingInfo(
        hasOutstanding: json["HasOutstanding"],
        title: json["Title"],
        invoiceId: json["InvoiceId"],
        fastSaleOrderId: json["FastSaleOrderId"],
        fastPurchaseOrderId: json["FastPurchaseOrderId"],
      );

  bool hasOutstanding;
  dynamic title;
  int invoiceId;
  dynamic fastSaleOrderId;
  dynamic fastPurchaseOrderId;

  Map<String, dynamic> toJson() => {
        "HasOutstanding": hasOutstanding,
        "Title": title,
        "InvoiceId": invoiceId,
        "FastSaleOrderId": fastSaleOrderId,
        "FastPurchaseOrderId": fastPurchaseOrderId,
      };
}

class PaymentInfoFP {
  PaymentInfoFP({
    this.name,
    this.journalName,
    this.amount,
    this.currency,
    this.date,
    this.paymentId,
    this.moveId,
    this.ref,
    this.accountPaymentId,
    this.paymentPartnerType,
  });

  factory PaymentInfoFP.fromJson(Map<String, dynamic> json) => PaymentInfoFP(
        name: json["Name"],
        journalName: json["JournalName"],
        amount: json["Amount"],
        currency: json["Currency"],
        date: DateTime.tryParse(json["Date"]),
        paymentId: json["PaymentId"],
        moveId: json["MoveId"],
        ref: json["Ref"],
        accountPaymentId: json["AccountPaymentId"],
        paymentPartnerType: json["PaymentPartnerType"],
      );
  String name;
  dynamic journalName;
  double amount;
  String currency;
  DateTime date;
  int paymentId;
  int moveId;
  String ref;
  int accountPaymentId;
  String paymentPartnerType;
  Map<String, dynamic> toJson() => {
        "Name": name,
        "JournalName": journalName,
        "Amount": amount,
        "Currency": currency,
        "Date": dateTimeOffset(date),
        "PaymentId": paymentId,
        "MoveId": moveId,
        "Ref": ref,
        "AccountPaymentId": accountPaymentId,
        "PaymentPartnerType": paymentPartnerType,
      };
}

class PickingTypeFP {
  PickingTypeFP({
    this.id,
    this.code,
    this.sequence,
    this.defaultLocationDestId,
    this.warehouseId,
    this.warehouseName,
    this.irSequenceId,
    this.active,
    this.name,
    this.defaultLocationSrcId,
    this.returnPickingTypeId,
    this.useCreateLots,
    this.useExistingLots,
    this.inverseOperation,
    this.nameGet,
    this.countPickingReady,
    this.countPickingDraft,
    this.countPicking,
    this.countPickingWaiting,
    this.countPickingLate,
    this.countPickingBackOrders,
  });

  factory PickingTypeFP.fromJson(Map<String, dynamic> json) => PickingTypeFP(
        id: json["Id"],
        code: json["Code"],
        sequence: json["Sequence"],
        defaultLocationDestId: json["DefaultLocationDestId"],
        warehouseId: json["WarehouseId"],
        warehouseName: json["WarehouseName"],
        irSequenceId: json["IRSequenceId"],
        active: json["Active"],
        name: json["Name"],
        defaultLocationSrcId: json["DefaultLocationSrcId"],
        returnPickingTypeId: json["ReturnPickingTypeId"],
        useCreateLots: json["UseCreateLots"],
        useExistingLots: json["UseExistingLots"],
        inverseOperation: json["InverseOperation"],
        nameGet: json["NameGet"],
        countPickingReady: json["CountPickingReady"],
        countPickingDraft: json["CountPickingDraft"],
        countPicking: json["CountPicking"],
        countPickingWaiting: json["CountPickingWaiting"],
        countPickingLate: json["CountPickingLate"],
        countPickingBackOrders: json["CountPickingBackOrders"],
      );

  int id;
  String code;
  int sequence;
  dynamic defaultLocationDestId;
  dynamic warehouseId;
  dynamic warehouseName;
  int irSequenceId;
  bool active;
  String name;
  dynamic defaultLocationSrcId;
  dynamic returnPickingTypeId;
  bool useCreateLots;
  bool useExistingLots;
  bool inverseOperation;
  String nameGet;
  int countPickingReady;
  int countPickingDraft;
  int countPicking;
  int countPickingWaiting;
  int countPickingLate;
  int countPickingBackOrders;

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Code": code,
        "Sequence": sequence,
        "DefaultLocationDestId": defaultLocationDestId,
        "WarehouseId": warehouseId,
        "WarehouseName": warehouseName,
        "IRSequenceId": irSequenceId,
        "Active": active,
        "Name": name,
        "DefaultLocationSrcId": defaultLocationSrcId,
        "ReturnPickingTypeId": returnPickingTypeId,
        "UseCreateLots": useCreateLots,
        "UseExistingLots": useExistingLots,
        "InverseOperation": inverseOperation,
        "NameGet": nameGet,
        "CountPickingReady": countPickingReady,
        "CountPickingDraft": countPickingDraft,
        "CountPicking": countPicking,
        "CountPickingWaiting": countPickingWaiting,
        "CountPickingLate": countPickingLate,
        "CountPickingBackOrders": countPickingBackOrders,
      };
}

class ProductFPO {
  ProductFPO(
      {this.id,
      this.name,
      this.uOMId,
      this.uOMName,
      this.nameGet,
      this.barcode,
      this.price,
      this.image,
      this.defaultCode,
      this.productTmplId,
      this.purchaseOK,
      this.saleOK,
      this.purchasePrice,
      this.discountSale,
      this.weight,
      this.discountPurchase,
      this.version,
      this.oldPrice,
      this.nameNoSign,
      this.description,
      this.pOSCategId,
      this.posSalesCount,
      this.imageUrl,
      this.availableInPOS,
      this.factor});

  ProductFPO.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    uOMId = json['UOMId'];
    uOMName = json['UOMName'];
    nameGet = json['NameGet'];
    barcode = json['Barcode'];
    price = json['Price'];
    image = json['Image'];
    defaultCode = json['DefaultCode'];
    productTmplId = json['ProductTmplId'];
    purchaseOK = json['PurchaseOK'];
    saleOK = json['SaleOK'];
    purchasePrice = json['PurchasePrice'];
    discountSale = json['DiscountSale'];
    weight = convertDouble(json['Weight']);
    discountPurchase = json['DiscountPurchase'];
    version = json['Version'];
    oldPrice = json['OldPrice'];
    nameNoSign = json['NameNoSign'];
    description = json['Description'];
    pOSCategId = json['POSCategId'];
    posSalesCount = json['PosSalesCount'];
    imageUrl = json['ImageUrl'];
    availableInPOS = json['AvailableInPOS'];
    factor = json['Factor'];
  }

  ProductFPO.fromJsonConvert(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    uOMId = json['UOMId'];
    uOMName = json['UOMName'];
    nameGet = json['NameGet'];
    barcode = json['Barcode'];
    price = json['Price'];
    image = json['Image'];
    defaultCode = json['DefaultCode'];
    productTmplId = json['ProductTmplId'];
    purchaseOK = json['PurchaseOK'];
    saleOK = json['SaleOK'];
    purchasePrice = json['PurchasePrice'];
    discountSale = json['DiscountSale'];
    weight = json['Weight'];
    discountPurchase = json['DiscountPurchase'];
    version = json['Version'];
    oldPrice = json['OldPrice'];
    nameNoSign = json['NameNoSign'];
    description = json['Description'];
    pOSCategId = json['POSCategId'];
    posSalesCount = json['PosSalesCount'];
    imageUrl = json['ImageUrl'];
    availableInPOS = json['AvailableInPOS'];
    factor = json['Factor'];
  }
  int id;
  String name;
  int uOMId;
  String uOMName;
  String nameGet;
  String barcode;
  double price;
  dynamic image;
  String defaultCode;
  int productTmplId;
  bool purchaseOK;
  bool saleOK;
  double purchasePrice;
  double discountSale;
  double weight;
  double discountPurchase;
  int version;
  double oldPrice;
  String nameNoSign;
  dynamic description;
  dynamic pOSCategId;
  int posSalesCount;
  String imageUrl;
  bool availableInPOS;
  double factor;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Name'] = name;
    data['UOMId'] = uOMId;
    data['UOMName'] = uOMName;
    data['NameGet'] = nameGet;
    data['Barcode'] = barcode;
    data['Price'] = price;
    data['Image'] = image;
    data['DefaultCode'] = defaultCode;
    data['ProductTmplId'] = productTmplId;
    data['PurchaseOK'] = purchaseOK;
    data['SaleOK'] = saleOK;
    data['PurchasePrice'] = purchasePrice;
    data['DiscountSale'] = discountSale;
    data['Weight'] = weight;
    data['DiscountPurchase'] = discountPurchase;
    data['Version'] = version;
    data['OldPrice'] = oldPrice;
    data['NameNoSign'] = nameNoSign;
    data['Description'] = description;
    data['POSCategId'] = pOSCategId;
    data['PosSalesCount'] = posSalesCount;
    data['ImageUrl'] = imageUrl;
    data['AvailableInPOS'] = availableInPOS;
    data['Factor'] = factor;
    return data;
  }
}
