class PosSessionConfig {
  PosSessionConfig(
      {this.id,
      this.name,
      this.nameGet,
      this.pickingTypeId,
      this.stockLocationId,
      this.journalId,
      this.invoiceJournalId,
      this.active,
      this.groupBy,
      this.priceListId,
      this.companyId,
      this.currentSessionId,
      this.currentSessionState,
      this.pOSSessionUserName,
      this.groupPosManagerId,
      this.groupPosUserId,
      this.barcodeNomenclatureId,
      this.ifacePrintAuto,
      this.ifacePrintSkipScreen,
      this.cashControl,
      this.lastSessionClosingDate,
      this.lastSessionClosingCash,
      this.ifaceSplitbill,
      this.ifacePrintbill,
      this.ifaceOrderlineNotes,
      this.printerIds,
      this.loyaltyId,
      this.ifacePaymentAuto,
      this.receiptHeader,
      this.receiptFooter,
      this.isHeaderOrFooter,
      this.ifaceDiscount,
      this.ifaceDiscountFixed,
      this.displayNote,
      this.discountPc,
      this.discountProductId,
      this.ifaceVAT,
      this.vatPc,
      this.ifaceLogo,
      this.ifaceTax,
      this.taxId,
      this.promotionIds,
      this.voucherIds,
      this.uUId,
      this.printer,
      this.useCache,
      this.oldestCacheTime});

  PosSessionConfig.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    nameGet = json['NameGet'];
    pickingTypeId = json['PickingTypeId'];
    stockLocationId = json['StockLocationId'];
    journalId = json['JournalId'];
    invoiceJournalId = json['InvoiceJournalId'];
    active = json['Active'];
    groupBy = json['GroupBy'];
    priceListId = json['PriceListId'];
    companyId = json['CompanyId'];
    currentSessionId = json['CurrentSessionId'];
    currentSessionState = json['CurrentSessionState'];
    pOSSessionUserName = json['POSSessionUserName'];
    groupPosManagerId = json['GroupPosManagerId'];
    groupPosUserId = json['GroupPosUserId'];
    barcodeNomenclatureId = json['BarcodeNomenclatureId'];
    ifacePrintAuto = json['IfacePrintAuto'];
    ifacePrintSkipScreen = json['IfacePrintSkipScreen'];
    cashControl = json['CashControl'];
    lastSessionClosingDate = json['LastSessionClosingDate'];
    lastSessionClosingCash = json['LastSessionClosingCash'];
    ifaceSplitbill = json['IfaceSplitbill'];
    ifacePrintbill = json['IfacePrintbill'];
    ifaceOrderlineNotes = json['IfaceOrderlineNotes'];
    if (json['PrinterIds'] != null) {
//      printerIds = new List<Null>();
//      json['PrinterIds'].forEach((v) {
//        printerIds.add(new Null.fromJson(v));
//      });
      printerIds = [];
    }
    loyaltyId = json['LoyaltyId'];
    ifacePaymentAuto = json['IfacePaymentAuto'];
    receiptHeader = json['ReceiptHeader'];
    receiptFooter = json['ReceiptFooter'];
    isHeaderOrFooter = json['IsHeaderOrFooter'];
    ifaceDiscount = json['IfaceDiscount'];
    ifaceDiscountFixed = json['IfaceDiscountFixed'];
    displayNote = json['DisplayNote'];
    discountPc = json['DiscountPc'];
    discountProductId = json['DiscountProductId'];
    ifaceVAT = json['IfaceVAT'];
    vatPc = json['VatPc'];
    ifaceLogo = json['IfaceLogo'];
    ifaceTax = json['IfaceTax'];
    taxId = json['TaxId'];
    if (json['PromotionIds'] != null) {
      promotionIds = [];
//      json['PromotionIds'].forEach((v) {
//        promotionIds.add(new Null.fromJson(v));
//      });
    }
    if (json['VoucherIds'] != null) {
      voucherIds = [];
//      json['VoucherIds'].forEach((v) {
//        voucherIds.add(new Null.fromJson(v));
//      });
    }
    uUId = json['UUId'];
    printer = json['Printer'];
    useCache = json['UseCache'];
    oldestCacheTime = json['OldestCacheTime'];
  }

  int id;
  String name;
  String nameGet;
  int pickingTypeId;
  int stockLocationId;
  int journalId;
  int invoiceJournalId;
  bool active;
  bool groupBy;
  int priceListId;
  int companyId;
  dynamic currentSessionId;
  dynamic currentSessionState;
  String pOSSessionUserName;
  dynamic groupPosManagerId;
  dynamic groupPosUserId;
  int barcodeNomenclatureId;
  bool ifacePrintAuto;
  bool ifacePrintSkipScreen;
  bool cashControl;
  dynamic lastSessionClosingDate;
  dynamic lastSessionClosingCash;
  bool ifaceSplitbill;
  bool ifacePrintbill;
  bool ifaceOrderlineNotes;
  List<dynamic> printerIds;
  dynamic loyaltyId;
  bool ifacePaymentAuto;
  dynamic receiptHeader;
  dynamic receiptFooter;
  bool isHeaderOrFooter;
  bool ifaceDiscount;
  bool ifaceDiscountFixed;
  dynamic displayNote;
  int discountPc;
  dynamic discountProductId;
  bool ifaceVAT;
  int vatPc;
  bool ifaceLogo;
  bool ifaceTax;
  dynamic taxId;
  List<dynamic> promotionIds;
  List<dynamic> voucherIds;
  String uUId;
  String printer;
  dynamic useCache;
  dynamic oldestCacheTime;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Name'] = name;
    data['NameGet'] = nameGet;
    data['PickingTypeId'] = pickingTypeId;
    data['StockLocationId'] = stockLocationId;
    data['JournalId'] = journalId;
    data['InvoiceJournalId'] = invoiceJournalId;
    data['Active'] = active;
    data['GroupBy'] = groupBy;
    data['PriceListId'] = priceListId;
    data['CompanyId'] = companyId;
    data['CurrentSessionId'] = currentSessionId;
    data['CurrentSessionState'] = currentSessionState;
    data['POSSessionUserName'] = pOSSessionUserName;
    data['GroupPosManagerId'] = groupPosManagerId;
    data['GroupPosUserId'] = groupPosUserId;
    data['BarcodeNomenclatureId'] = barcodeNomenclatureId;
    data['IfacePrintAuto'] = ifacePrintAuto;
    data['IfacePrintSkipScreen'] = ifacePrintSkipScreen;
    data['CashControl'] = cashControl;
    data['LastSessionClosingDate'] = lastSessionClosingDate;
    data['LastSessionClosingCash'] = lastSessionClosingCash;
    data['IfaceSplitbill'] = ifaceSplitbill;
    data['IfacePrintbill'] = ifacePrintbill;
    data['IfaceOrderlineNotes'] = ifaceOrderlineNotes;
    if (printerIds != null) {
      data['PrinterIds'] = printerIds.map((v) => v.toJson()).toList();
    }
    data['LoyaltyId'] = loyaltyId;
    data['IfacePaymentAuto'] = ifacePaymentAuto;
    data['ReceiptHeader'] = receiptHeader;
    data['ReceiptFooter'] = receiptFooter;
    data['IsHeaderOrFooter'] = isHeaderOrFooter;
    data['IfaceDiscount'] = ifaceDiscount;
    data['IfaceDiscountFixed'] = ifaceDiscountFixed;
    data['DisplayNote'] = displayNote;
    data['DiscountPc'] = discountPc;
    data['DiscountProductId'] = discountProductId;
    data['IfaceVAT'] = ifaceVAT;
    data['VatPc'] = vatPc;
    data['IfaceLogo'] = ifaceLogo;
    data['IfaceTax'] = ifaceTax;
    data['TaxId'] = taxId;
    if (promotionIds != null) {
      data['PromotionIds'] = promotionIds.map((v) => v.toJson()).toList();
    }
    if (voucherIds != null) {
      data['VoucherIds'] = voucherIds.map((v) => v.toJson()).toList();
    }
    data['UUId'] = uUId;
    data['Printer'] = printer;
    data['UseCache'] = useCache;
    data['OldestCacheTime'] = oldestCacheTime;
    return data;
  }
}
