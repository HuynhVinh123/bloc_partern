class PosSessionConfig {
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['NameGet'] = this.nameGet;
    data['PickingTypeId'] = this.pickingTypeId;
    data['StockLocationId'] = this.stockLocationId;
    data['JournalId'] = this.journalId;
    data['InvoiceJournalId'] = this.invoiceJournalId;
    data['Active'] = this.active;
    data['GroupBy'] = this.groupBy;
    data['PriceListId'] = this.priceListId;
    data['CompanyId'] = this.companyId;
    data['CurrentSessionId'] = this.currentSessionId;
    data['CurrentSessionState'] = this.currentSessionState;
    data['POSSessionUserName'] = this.pOSSessionUserName;
    data['GroupPosManagerId'] = this.groupPosManagerId;
    data['GroupPosUserId'] = this.groupPosUserId;
    data['BarcodeNomenclatureId'] = this.barcodeNomenclatureId;
    data['IfacePrintAuto'] = this.ifacePrintAuto;
    data['IfacePrintSkipScreen'] = this.ifacePrintSkipScreen;
    data['CashControl'] = this.cashControl;
    data['LastSessionClosingDate'] = this.lastSessionClosingDate;
    data['LastSessionClosingCash'] = this.lastSessionClosingCash;
    data['IfaceSplitbill'] = this.ifaceSplitbill;
    data['IfacePrintbill'] = this.ifacePrintbill;
    data['IfaceOrderlineNotes'] = this.ifaceOrderlineNotes;
    if (this.printerIds != null) {
      data['PrinterIds'] = this.printerIds.map((v) => v.toJson()).toList();
    }
    data['LoyaltyId'] = this.loyaltyId;
    data['IfacePaymentAuto'] = this.ifacePaymentAuto;
    data['ReceiptHeader'] = this.receiptHeader;
    data['ReceiptFooter'] = this.receiptFooter;
    data['IsHeaderOrFooter'] = this.isHeaderOrFooter;
    data['IfaceDiscount'] = this.ifaceDiscount;
    data['IfaceDiscountFixed'] = this.ifaceDiscountFixed;
    data['DisplayNote'] = this.displayNote;
    data['DiscountPc'] = this.discountPc;
    data['DiscountProductId'] = this.discountProductId;
    data['IfaceVAT'] = this.ifaceVAT;
    data['VatPc'] = this.vatPc;
    data['IfaceLogo'] = this.ifaceLogo;
    data['IfaceTax'] = this.ifaceTax;
    data['TaxId'] = this.taxId;
    if (this.promotionIds != null) {
      data['PromotionIds'] = this.promotionIds.map((v) => v.toJson()).toList();
    }
    if (this.voucherIds != null) {
      data['VoucherIds'] = this.voucherIds.map((v) => v.toJson()).toList();
    }
    data['UUId'] = this.uUId;
    data['Printer'] = this.printer;
    data['UseCache'] = this.useCache;
    data['OldestCacheTime'] = this.oldestCacheTime;
    return data;
  }
}
