class PosConfig {
  PosConfig(
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

  PosConfig.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    nameGet = json['NameGet'];
    pickingTypeId = json['PickingTypeId'];
    stockLocationId = json['StockLocationId'];
    journalId = json['JournalId'];
    invoiceJournalId = json['InvoiceJournalId'];
    if (json['Active'] == 1 || json['Active'] == 0) {
      if (json['Active'] == 1) {
        active = true;
      } else {
        active = false;
      }
    } else {
      active = json['Active'];
    }
    if (json['GroupBy'] == 1 || json['GroupBy'] == 0) {
      if (json['GroupBy'] == 1) {
        groupBy = true;
      } else {
        groupBy = false;
      }
    } else {
      groupBy = json['GroupBy'];
    }
    priceListId = json['PriceListId'];
    companyId = json['CompanyId'];
    currentSessionId = json['CurrentSessionId'];
    currentSessionState = json['CurrentSessionState'];
    pOSSessionUserName = json['POSSessionUserName'];
    groupPosManagerId = json['GroupPosManagerId'];
    groupPosUserId = json['GroupPosUserId'];
    barcodeNomenclatureId = json['BarcodeNomenclatureId'];
    if (json['IfacePrintAuto'] == 1 || json['IfacePrintAuto'] == 0) {
      if (json['IfacePrintAuto'] == 1) {
        ifacePrintAuto = true;
      } else {
        ifacePrintAuto = false;
      }
    } else {
      ifacePrintAuto = json['IfacePrintAuto'];
    }
    if (json['IfacePrintSkipScreen'] == 1 ||
        json['IfacePrintSkipScreen'] == 0) {
      if (json['IfacePrintSkipScreen'] == 1) {
        ifacePrintSkipScreen = true;
      } else {
        ifacePrintSkipScreen = false;
      }
    } else {
      ifacePrintSkipScreen = json['IfacePrintSkipScreen'];
    }
    if (json['CashControl'] == 1 || json['CashControl'] == 0) {
      if (json['CashControl'] == 1) {
        cashControl = true;
      } else {
        cashControl = false;
      }
    } else {
      cashControl = json['CashControl'];
    }
    lastSessionClosingDate = json['LastSessionClosingDate'];
    lastSessionClosingCash = json['LastSessionClosingCash'];
    if (json['IfaceSplitbill'] == 1 || json['IfaceSplitbill'] == 0) {
      if (json['IfaceSplitbill'] == 1) {
        ifaceSplitbill = true;
      } else {
        ifaceSplitbill = false;
      }
    } else {
      ifaceSplitbill = json['IfaceSplitbill'];
    }
    if (json['IfacePrintbill'] == 1 || json['IfacePrintbill'] == 0) {
      if (json['IfacePrintbill'] == 1) {
        ifacePrintbill = true;
      } else {
        ifacePrintbill = false;
      }
    } else {
      ifacePrintbill = json['IfacePrintbill'];
    }
    if (json['IfaceOrderlineNotes'] == 1 || json['IfaceOrderlineNotes'] == 0) {
      if (json['IfaceOrderlineNotes'] == 1) {
        ifaceOrderlineNotes = true;
      } else {
        ifaceOrderlineNotes = false;
      }
    } else {
      ifaceOrderlineNotes = json['IfaceOrderlineNotes'];
    }
    loyaltyId = json['LoyaltyId'];
    if (json['IfacePaymentAuto'] == 1 || json['IfacePaymentAuto'] == 0) {
      if (json['IfacePaymentAuto'] == 1) {
        ifacePaymentAuto = true;
      } else {
        ifacePaymentAuto = false;
      }
    } else {
      ifacePaymentAuto = json['IfacePaymentAuto'];
    }
    receiptHeader = json['ReceiptHeader'];
    receiptFooter = json['ReceiptFooter'];
    if (json['IsHeaderOrFooter'] == 1 || json['IsHeaderOrFooter'] == 0) {
      if (json['IsHeaderOrFooter'] == 1) {
        isHeaderOrFooter = true;
      } else {
        isHeaderOrFooter = false;
      }
    } else {
      isHeaderOrFooter = json['IsHeaderOrFooter'];
    }
    if (json['IfaceDiscount'] == 1 || json['IfaceDiscount'] == 0) {
      if (json['IfaceDiscount'] == 1) {
        ifaceDiscount = true;
      } else {
        ifaceDiscount = false;
      }
    } else {
      ifaceDiscount = json['IfaceDiscount'];
    }
    if (json['IfaceDiscountFixed'] == 1 || json['IfaceDiscountFixed'] == 0) {
      if (json['IfaceDiscountFixed'] == 1) {
        ifaceDiscountFixed = true;
      } else {
        ifaceDiscountFixed = false;
      }
    } else {
      ifaceDiscountFixed = json['IfaceDiscountFixed'];
    }
    discountPc = json['DiscountPc'] == 0 ? 0 : json['DiscountPc'];
    discountProductId = json['DiscountProductId'];
    if (json['IfaceVAT'] == 1 || json['IfaceVAT'] == 0) {
      if (json['IfaceVAT'] == 1) {
        ifaceVAT = true;
      } else {
        ifaceVAT = false;
      }
    } else {
      ifaceVAT = json['IfaceVAT'];
    }
    vatPc = json['VatPc'];
    if (json['IfaceLogo'] == 1 || json['IfaceLogo'] == 0) {
      if (json['IfaceLogo'] == 1) {
        ifaceLogo = true;
      } else {
        ifaceLogo = false;
      }
    } else {
      ifaceLogo = json['IfaceLogo'];
    }
    if (json['IfaceTax'] == 1 || json['IfaceTax'] == 0) {
      if (json['IfaceTax'] == 1) {
        ifaceTax = true;
      } else {
        ifaceTax = false;
      }
    } else {
      ifaceTax = json['IfaceTax'];
    }
    taxId = json['TaxId'];
    uUId = json['UUId'];
    printer = json['Printer'];
    if (json['UseCache'] == 1 || json['UseCache'] == 0) {
      if (json['UseCache'] == 1) {
        useCache = true;
      } else {
        useCache = false;
      }
    } else {
      useCache = json['UseCache'];
    }
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
  int currentSessionId;
  bool currentSessionState;
  String pOSSessionUserName;
  int groupPosManagerId;
  int groupPosUserId;
  int barcodeNomenclatureId;
  bool ifacePrintAuto;
  bool ifacePrintSkipScreen;
  bool cashControl;
  String lastSessionClosingDate;
  String lastSessionClosingCash;
  bool ifaceSplitbill;
  bool ifacePrintbill;
  bool ifaceOrderlineNotes;
  List<dynamic> printerIds;
  int loyaltyId;
  bool ifacePaymentAuto;
  String receiptHeader;
  String receiptFooter;
  bool isHeaderOrFooter;
  bool ifaceDiscount;
  bool ifaceDiscountFixed;
  double discountPc;
  int discountProductId;
  bool ifaceVAT;
  int vatPc;
  bool ifaceLogo;
  bool ifaceTax;
  int taxId;
  List<dynamic> promotionIds;
  List<dynamic> voucherIds;
  String uUId;
  String printer;
  bool useCache;
  String oldestCacheTime;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Active'] = active != null ? active ? 1 : 0 : 0;
    data['GroupBy'] = groupBy != null ? groupBy ? 1 : 0 : 0;
    data['IfacePrintAuto'] =
        ifacePrintAuto != null ? ifacePrintAuto ? 1 : 0 : 0;
    data['IfacePrintSkipScreen'] =
        ifacePrintSkipScreen != null ? ifacePrintSkipScreen ? 1 : 0 : 0;
    data['CashControl'] = cashControl != null ? cashControl ? 1 : 0 : 0;
    data['IfaceSplitbill'] =
        ifaceSplitbill != null ? ifaceSplitbill ? 1 : 0 : 0;
    data['IfacePrintbill'] =
        ifacePrintbill != null ? ifacePrintbill ? 1 : 0 : 0;
    data['IfaceOrderlineNotes'] =
        ifaceOrderlineNotes != null ? ifaceOrderlineNotes ? 1 : 0 : 0;

    data['IfacePaymentAuto'] =
        ifacePaymentAuto != null ? ifacePaymentAuto ? 1 : 0 : 0;

    data['IsHeaderOrFooter'] =
        isHeaderOrFooter != null ? isHeaderOrFooter ? 1 : 0 : 0;
    data['IfaceDiscount'] = ifaceDiscount != null ? ifaceDiscount ? 1 : 0 : 0;
    data['IfaceDiscountFixed'] =
        ifaceDiscountFixed != null ? ifaceDiscountFixed ? 1 : 0 : 0;
    data['DiscountPc'] = discountPc;
    data['IfaceVAT'] = ifaceVAT != null ? ifaceVAT ? 1 : 0 : 0;
    data['VatPc'] = vatPc;
    data['IfaceLogo'] = ifaceLogo != null ? ifaceLogo ? 1 : 0 : 0;
    data['IfaceTax'] = ifaceTax != null ? ifaceTax ? 1 : 0 : 0;

    data['UseCache'] = useCache != null ? useCache ? 1 : 0 : 0;
    data['TaxId'] = taxId;
    data['PriceListId'] = priceListId;
    data['ReceiptHeader'] = receiptHeader;
    data['ReceiptFooter'] = receiptFooter;
    return data;
  }
}
