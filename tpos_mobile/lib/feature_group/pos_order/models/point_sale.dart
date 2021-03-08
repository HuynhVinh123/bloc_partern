import 'package:tpos_mobile/feature_group/pos_order/models/pos_make_payment.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/price_list.dart';

class PointSale {
  PointSale(
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
      this.oldestCacheTime,
      this.invoiceJournal,
      this.journal,
      this.journals,
      this.priceList,
      this.stockLocation,
      this.pickingType,
      this.tax});

  PointSale.fromJson(Map<String, dynamic> json) {
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
//    if (json['PrinterIds'] != null) {
//      printerIds = new List<Null>();
//      json['PrinterIds'].forEach((v) {
//        printerIds.add(new Null.fromJson(v));
//      });
//    }
    loyaltyId = json['LoyaltyId'];
    ifacePaymentAuto = json['IfacePaymentAuto'];
    receiptHeader = json['ReceiptHeader'];
    receiptFooter = json['ReceiptFooter'];
    isHeaderOrFooter = json['IsHeaderOrFooter'];
    ifaceDiscount = json['IfaceDiscount'];
    ifaceDiscountFixed = json['IfaceDiscountFixed'];
    discountPc = json['DiscountPc'];
    discountProductId = json['DiscountProductId'];
    ifaceVAT = json['IfaceVAT'];
    vatPc = json['VatPc'];
    ifaceLogo = json['IfaceLogo'];
    ifaceTax = json['IfaceTax'];
    taxId = json['TaxId'];
//    if (json['PromotionIds'] != null) {
//      promotionIds = new List<Null>();
//      json['PromotionIds'].forEach((v) {
//        promotionIds.add(new Null.fromJson(v));
//      });
//    }
//    if (json['VoucherIds'] != null) {
//      voucherIds = new List<Null>();
//      json['VoucherIds'].forEach((v) {
//        voucherIds.add(new Null.fromJson(v));
//      });
//    }
    uUId = json['UUId'];
    printer = json['Printer'];
    useCache = json['UseCache'];
    oldestCacheTime = json['OldestCacheTime'];
    if (json['InvoiceJournal'] != null) {
      invoiceJournal = PosMakePaymentJournal.fromJson(json['InvoiceJournal']);
    } else {
      invoiceJournal = null;
    }
    journal = json['Journal'] != null
        ? PosMakePaymentJournal.fromJson(json['Journal'])
        : null;

    if (json['Journals'] != null) {
      journals = <PosMakePaymentJournal>[];
      json['Journals'].forEach((v) {
        journals.add(PosMakePaymentJournal.fromJson(v));
      });
    }
    priceList = json['PriceList'] != null
        ? PriceList.fromJson(json['PriceList'])
        : null;
    stockLocation = json['StockLocation'] != null
        ? StockLocation.fromJson(json['StockLocation'])
        : null;
    pickingType = json['PickingType'] != null
        ? PickingType.fromJson(json['PickingType'])
        : null;
    tax = json['Tax'] != null ? Tax.fromJson(json['Tax']) : null;
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
  String currentSessionState;
  String pOSSessionUserName;
  int groupPosManagerId;
  int groupPosUserId;
  int barcodeNomenclatureId;
  bool ifacePrintAuto;
  bool ifacePrintSkipScreen;
  bool cashControl;
  String lastSessionClosingDate;
  dynamic lastSessionClosingCash;
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
  String discountProductId;
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
  PosMakePaymentJournal invoiceJournal;
  PosMakePaymentJournal journal;
  List<PosMakePaymentJournal> journals;
  PriceList priceList;
  StockLocation stockLocation;
  PickingType pickingType;
  Tax tax;

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
//    if (this.printerIds != null) {
//      data['PrinterIds'] = this.printerIds.map((v) => v.toJson()).toList();
//    }
    data['LoyaltyId'] = loyaltyId;
    data['IfacePaymentAuto'] = ifacePaymentAuto;
    data['ReceiptHeader'] = receiptHeader;
    data['ReceiptFooter'] = receiptFooter;
    data['IsHeaderOrFooter'] = isHeaderOrFooter;
    data['IfaceDiscount'] = ifaceDiscount;
    data['IfaceDiscountFixed'] = ifaceDiscountFixed;
    data['DiscountPc'] = discountPc;
    data['DiscountProductId'] = discountProductId;
    data['IfaceVAT'] = ifaceVAT;
    data['VatPc'] = vatPc;
    data['IfaceLogo'] = ifaceLogo;
    data['IfaceTax'] = ifaceTax;
    data['TaxId'] = taxId;
//    if (this.promotionIds != null) {
//      data['PromotionIds'] = this.promotionIds.map((v) => v.toJson()).toList();
//    }
//    if (this.voucherIds != null) {
//      data['VoucherIds'] = this.voucherIds.map((v) => v.toJson()).toList();
//    }
    data['UUId'] = uUId;
    data['Printer'] = printer;
    data['UseCache'] = useCache;
    data['OldestCacheTime'] = oldestCacheTime;
    if (invoiceJournal != null) {
      data['InvoiceJournal'] = invoiceJournal.toJson();
    }
    if (invoiceJournal != null) {
      data['InvoiceJournal'] = invoiceJournal.toJson();
    }
    if (journals != null) {
      data['Journals'] = journals.map((v) => v.toJson()).toList();
    }
    if (priceList != null) {
      data['PriceList'] = priceList.toJson();
    }
    if (stockLocation != null) {
      data['StockLocation'] = stockLocation.toJson();
    }
    if (pickingType != null) {
      data['PickingType'] = pickingType.toJson();
    }
    if (tax != null) {
      data['Tax'] = tax.toJson();
    }
    return data;
  }
}

class StockLocation {
  StockLocation(
      {this.id,
      this.usage,
      this.scrapLocation,
      this.name,
      this.completeName,
      this.parentLocationId,
      this.active,
      this.parentLeft,
      this.companyId,
      this.showUsage,
      this.nameGet});

  StockLocation.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    usage = json['Usage'];
    scrapLocation = json['ScrapLocation'];
    name = json['Name'];
    completeName = json['CompleteName'];
    parentLocationId = json['ParentLocationId'];
    active = json['Active'];
    parentLeft = json['ParentLeft'];
    companyId = json['CompanyId'];
    showUsage = json['ShowUsage'];
    nameGet = json['NameGet'];
  }

  int id;
  String usage;
  bool scrapLocation;
  String name;
  String completeName;
  int parentLocationId;
  bool active;
  int parentLeft;
  int companyId;
  String showUsage;
  String nameGet;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Usage'] = usage;
    data['ScrapLocation'] = scrapLocation;
    data['Name'] = name;
    data['CompleteName'] = completeName;
    data['ParentLocationId'] = parentLocationId;
    data['Active'] = active;
    data['ParentLeft'] = parentLeft;
    data['CompanyId'] = companyId;
    data['ShowUsage'] = showUsage;
    data['NameGet'] = nameGet;
    return data;
  }
}

class PickingType {
  PickingType(
      {this.id,
      this.code,
      this.sequence,
      this.defaultLocationDestId,
      this.warehouseId,
      this.warehouseName,
      this.iRSequenceId,
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
      this.countPickingBackOrders});

  PickingType.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    code = json['Code'];
    sequence = json['Sequence'];
    defaultLocationDestId = json['DefaultLocationDestId'];
    warehouseId = json['WarehouseId'];
    warehouseName = json['WarehouseName'];
    iRSequenceId = json['IRSequenceId'];
    active = json['Active'];
    name = json['Name'];
    defaultLocationSrcId = json['DefaultLocationSrcId'];
    returnPickingTypeId = json['ReturnPickingTypeId'];
    useCreateLots = json['UseCreateLots'];
    useExistingLots = json['UseExistingLots'];
    inverseOperation = json['InverseOperation'];
    nameGet = json['NameGet'];
    countPickingReady = json['CountPickingReady'];
    countPickingDraft = json['CountPickingDraft'];
    countPicking = json['CountPicking'];
    countPickingWaiting = json['CountPickingWaiting'];
    countPickingLate = json['CountPickingLate'];
    countPickingBackOrders = json['CountPickingBackOrders'];
  }

  int id;
  String code;
  int sequence;
  int defaultLocationDestId;
  int warehouseId;
  String warehouseName;
  int iRSequenceId;
  bool active;
  String name;
  int defaultLocationSrcId;
  int returnPickingTypeId;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Code'] = code;
    data['Sequence'] = sequence;
    data['DefaultLocationDestId'] = defaultLocationDestId;
    data['WarehouseId'] = warehouseId;
    data['WarehouseName'] = warehouseName;
    data['IRSequenceId'] = iRSequenceId;
    data['Active'] = active;
    data['Name'] = name;
    data['DefaultLocationSrcId'] = defaultLocationSrcId;
    data['ReturnPickingTypeId'] = returnPickingTypeId;
    data['UseCreateLots'] = useCreateLots;
    data['UseExistingLots'] = useExistingLots;
    data['InverseOperation'] = inverseOperation;
    data['NameGet'] = nameGet;
    data['CountPickingReady'] = countPickingReady;
    data['CountPickingDraft'] = countPickingDraft;
    data['CountPicking'] = countPicking;
    data['CountPickingWaiting'] = countPickingWaiting;
    data['CountPickingLate'] = countPickingLate;
    data['CountPickingBackOrders'] = countPickingBackOrders;
    return data;
  }
}

class Tax {
  Tax(
      {this.accountId,
      this.active,
      this.amount,
      this.amountType,
      this.companyId,
      this.companyName,
      this.description,
      this.id,
      this.name,
      this.priceInclude,
      this.refundAccountId,
      this.sequence,
      this.typeTaxUse});

  Tax.fromJson(Map<String, dynamic> json) {
    accountId = json['AccountId'];
    active = json['Active'];
    amount = json['Amount'];
    amountType = json['AmountType'];
    companyId = json['CompanyId'];
    companyName = json['CompanyName'];
    description = json['Description'];
    id = json['Id'];
    name = json['Name'];
    priceInclude = json['PriceInclude'];
    refundAccountId = json['RefundAccountId'];
    sequence = json['Sequence'];
    typeTaxUse = json['TypeTaxUse'];
  }

  int accountId;
  bool active;
  double amount;
  String amountType;
  int companyId;
  String companyName;
  String description;
  int id;
  String name;
  bool priceInclude;
  int refundAccountId;
  int sequence;
  String typeTaxUse;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AccountId'] = accountId;
    if (active != null) {
      data['Active'] = active;
    }
    data['Amount'] = amount;
    data['AmountType'] = amountType;
    data['CompanyId'] = companyId;
    data['CompanyName'] = companyName;
    data['Description'] = description;
    data['Id'] = id;
    data['Name'] = name;
    if (priceInclude != null) {
      data['PriceInclude'] = priceInclude;
    }
    data['RefundAccountId'] = refundAccountId;
    data['Sequence'] = sequence;
    data['TypeTaxUse'] = typeTaxUse;

    return data;
  }
}
