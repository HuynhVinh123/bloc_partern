class ReportSaleOrderGeneral {
  String odataContext;
  int odataCount;
  List<ReportSaleOrderGeneralInfo> value;

  ReportSaleOrderGeneral({this.odataContext, this.odataCount, this.value});

  ReportSaleOrderGeneral.fromJson(Map<String, dynamic> json) {
    odataContext = json['@odata.context'];
    odataCount = json['@odata.count'];
    if (json['value'] != null) {
      value = new List<ReportSaleOrderGeneralInfo>();
      json['value'].forEach((v) {
        value.add(new ReportSaleOrderGeneralInfo.fromJson(v));
      });
    }
  }
}

class ReportSaleOrderGeneralInfo {
  DateTime date;
  int countOrder;
  double totalAmountBeforeCK;
  double totalCK;
  double totalKM;
  double totalAmount;

  ReportSaleOrderGeneralInfo(
      {this.date,
      this.countOrder,
      this.totalAmountBeforeCK,
      this.totalCK,
      this.totalKM,
      this.totalAmount});

  ReportSaleOrderGeneralInfo.fromJson(Map<String, dynamic> json) {
    date = DateTime.parse(json['Date']);
    countOrder = json['CountOrder']?.toInt();
    totalAmountBeforeCK = json['TotalAmountBeforeCK']?.toDouble();
    totalCK = json['TotalCK']?.toDouble();
    totalKM = json['TotalKM']?.toDouble();

    countOrder = json['CountOrder'];
    totalAmountBeforeCK = double.parse(json['TotalAmountBeforeCK'].toString());
    totalCK = json['TotalCK'];
    totalKM = double.parse(json['TotalKM'].toString());
    totalAmount = json['TotalAmount'];
  }
}

class SumReportSaleGeneral {
  String odataContext;
  int id;
  int totalOrder;
  double totalSale;
  double totalCk;
  double totalAmount;
  double totalKM;

  SumReportSaleGeneral(
      {this.odataContext,
      this.id,
      this.totalOrder,
      this.totalSale,
      this.totalCk,
      this.totalAmount,
      this.totalKM});

  SumReportSaleGeneral.fromJson(Map<String, dynamic> json) {
    odataContext = json['@odata.context'];
    id = json['Id'];
    totalOrder = json['TotalOrder'];
    totalSale = json['TotalSale']?.toDouble();
    totalCk = json['TotalCk']?.toDouble();
    totalAmount = json['TotalAmount']?.toDouble();
    totalKM = json['TotalKM']?.toDouble();
  }
}

class SumAmountReportSale {
  String odataContext;
  double sumAmountSaleOrder;
  double sumAmountPostOrder;
  double sumAmountFastOrder;
  double sumPaidtSaleOrder;
  double sumPaidPostOrder;
  double sumPaidFastOrder;
  double sumAmountBeforeDiscountPostOrder;
  double sumAmountBeforeDiscountFastOrder;
  double sumDiscountAmountPostOrder;
  double sumDiscountAmountFastOrder;
  double sumDecreateAmountPostOrder;
  double sumDecreateAmountFastOrder;

  SumAmountReportSale(
      {this.odataContext,
      this.sumAmountSaleOrder,
      this.sumAmountPostOrder,
      this.sumAmountFastOrder,
      this.sumPaidtSaleOrder,
      this.sumPaidPostOrder,
      this.sumPaidFastOrder,
      this.sumAmountBeforeDiscountPostOrder,
      this.sumAmountBeforeDiscountFastOrder,
      this.sumDiscountAmountPostOrder,
      this.sumDiscountAmountFastOrder,
      this.sumDecreateAmountPostOrder,
      this.sumDecreateAmountFastOrder});

  SumAmountReportSale.fromJson(Map<String, dynamic> json) {
    odataContext = json['@odata.context'];
    sumAmountSaleOrder = json['SumAmountSaleOrder']?.toDouble();
    sumAmountPostOrder = json['SumAmountPostOrder']?.toDouble();
    sumAmountFastOrder = json['SumAmountFastOrder']?.toDouble();
    sumPaidtSaleOrder = json['SumPaidtSaleOrder']?.toDouble();
    sumPaidPostOrder = json['SumPaidPostOrder']?.toDouble();
    sumPaidFastOrder = json['SumPaidFastOrder']?.toDouble();
    sumAmountBeforeDiscountPostOrder =
        json['SumAmountBeforeDiscountPostOrder']?.toDouble();
    sumAmountBeforeDiscountFastOrder =
        json['SumAmountBeforeDiscountFastOrder']?.toDouble();
    sumDiscountAmountPostOrder = json['SumDiscountAmountPostOrder']?.toDouble();
    sumDiscountAmountFastOrder = json['SumDiscountAmountFastOrder']?.toDouble();
    sumDecreateAmountPostOrder = json['SumDecreateAmountPostOrder']?.toDouble();
    sumDecreateAmountFastOrder = json['SumDecreateAmountFastOrder']?.toDouble();
  }
}

class ReportSaleOrder {
  String odataContext;
  int odataCount;
  List<ReportSaleOrderInfo> value;

  ReportSaleOrder({this.odataContext, this.odataCount, this.value});

  ReportSaleOrder.fromJson(Map<String, dynamic> json) {
    odataContext = json['@odata.context'];
    odataCount = json['@odata.count'];
    if (json['value'] != null) {
      value = new List<ReportSaleOrderInfo>();
      json['value'].forEach((v) {
        value.add(new ReportSaleOrderInfo.fromJson(v));
      });
    }
  }
}

class ReportSaleOrderInfo {
  bool selected = false;
  int id;
  DateTime dateOrder;
  int partnerId;
  String partnerDisplayName;
  double amountTax;
  Null amountUntaxed;
  double amountTotal;
  Null amountTotalSigned;
  Null note;
  String comment;
  String state;
  String name;
  int warehouseId;
  dynamic procurementGroupId;
  int companyId;
  String companyName;
  String userId;
  String userName;
  String orderPolicy;
  String pickingPolicy;
  dynamic dateConfirm;
  dynamic shipped;
  int priceListId;
  double residual;
  String showState;
  int currencyId;
  String loaiDonGia;
  int deliveryCount;
  int invoiceCount;
  String invoiceStatus;
  dynamic tongTrongLuong;
  dynamic tongTaiTrong;
  int donGiaKg;
  dynamic dateExpected;
  dynamic transportRef;
  int partnerInvoiceId;
  int partnerShippingId;
  dynamic amountTotalStr;
  dynamic searchPartnerId;
  int congNo;
  dynamic projectId;
  dynamic shippingAddress;
  dynamic phoneNumber;
  dynamic note2;
  String dateShipped;
  dynamic carrierId;
  dynamic deliveryPrice;
  dynamic invoiceShippingOnDelivery;
  dynamic deliveryRatingSuccess;
  dynamic deliveryRatingMessage;
  dynamic partnerNameNoSign;
  dynamic priceListName;
  dynamic paymentTermId;
  bool isFast;
  String tableSearch;
  String nameTypeOrder;
  double discount;
  double discountAmount;
  double decreaseAmount;
  double totalAmountBeforeDiscount;
  String type;
  dynamic search;

  ReportSaleOrderInfo(
      {this.id,
      this.selected,
      this.dateOrder,
      this.partnerId,
      this.partnerDisplayName,
      this.amountTax,
      this.amountUntaxed,
      this.amountTotal,
      this.amountTotalSigned,
      this.note,
      this.comment,
      this.state,
      this.name,
      this.warehouseId,
      this.procurementGroupId,
      this.companyId,
      this.companyName,
      this.userId,
      this.userName,
      this.orderPolicy,
      this.pickingPolicy,
      this.dateConfirm,
      this.shipped,
      this.priceListId,
      this.residual,
      this.showState,
      this.currencyId,
      this.loaiDonGia,
      this.deliveryCount,
      this.invoiceCount,
      this.invoiceStatus,
      this.tongTrongLuong,
      this.tongTaiTrong,
      this.donGiaKg,
      this.dateExpected,
      this.transportRef,
      this.partnerInvoiceId,
      this.partnerShippingId,
      this.amountTotalStr,
      this.searchPartnerId,
      this.congNo,
      this.projectId,
      this.shippingAddress,
      this.phoneNumber,
      this.note2,
      this.dateShipped,
      this.carrierId,
      this.deliveryPrice,
      this.invoiceShippingOnDelivery,
      this.deliveryRatingSuccess,
      this.deliveryRatingMessage,
      this.partnerNameNoSign,
      this.priceListName,
      this.paymentTermId,
      this.isFast,
      this.tableSearch,
      this.nameTypeOrder,
      this.discount,
      this.discountAmount,
      this.decreaseAmount,
      this.totalAmountBeforeDiscount,
      this.type,
      this.search});

  ReportSaleOrderInfo.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    if (json["DateOrder"] != null) {
      String unixTimeStr =
          RegExp(r"(?<=Date\()\d+").stringMatch(json["DateOrder"]);

      if (unixTimeStr != null && unixTimeStr.isNotEmpty) {
        int unixTime = int.parse(unixTimeStr);
        dateOrder = DateTime.fromMillisecondsSinceEpoch(unixTime);
      } else {
        if (json["DateOrder"] != null) {
          dateOrder = DateTime.parse(json["DateOrder"]);
        }
      }
    }
    partnerId = json['PartnerId'];
    partnerDisplayName = json['PartnerDisplayName'];
    amountTax = json['AmountTax']?.toDouble();
    amountUntaxed = json['AmountUntaxed'];
    amountTotal = json['AmountTotal'];
    amountTotalSigned = json['AmountTotalSigned'];
    note = json['Note'];
    comment = json['Comment'];
    state = json['State'];
    name = json['Name'];
    warehouseId = json['WarehouseId'];
    procurementGroupId = json['ProcurementGroupId'];
    companyId = json['CompanyId'];
    companyName = json['CompanyName'];
    userId = json['UserId'];
    userName = json['UserName'];
    orderPolicy = json['OrderPolicy'];
    pickingPolicy = json['PickingPolicy'];
    dateConfirm = json['DateConfirm'];
    shipped = json['Shipped'];
    priceListId = json['PriceListId'];
    residual = json['Residual']?.toDouble();
    showState = json['ShowState'];
    currencyId = json['CurrencyId'];
    loaiDonGia = json['LoaiDonGia'];
    deliveryCount = json['DeliveryCount'];
    invoiceCount = json['InvoiceCount'];
    invoiceStatus = json['InvoiceStatus'];
    tongTrongLuong = json['TongTrongLuong'];
    tongTaiTrong = json['TongTaiTrong'];
    donGiaKg = json['DonGiaKg'];
    dateExpected = json['DateExpected'];
    transportRef = json['TransportRef'];
    partnerInvoiceId = json['PartnerInvoiceId'];
    partnerShippingId = json['PartnerShippingId'];
    amountTotalStr = json['AmountTotalStr'];
    searchPartnerId = json['SearchPartnerId'];
    congNo = json['CongNo'];
    projectId = json['ProjectId'];
    shippingAddress = json['ShippingAddress'];
    phoneNumber = json['PhoneNumber'];
    note2 = json['Note2'];
    dateShipped = json['DateShipped'];
    carrierId = json['CarrierId'];
    deliveryPrice = json['DeliveryPrice'];
    invoiceShippingOnDelivery = json['InvoiceShippingOnDelivery'];
    deliveryRatingSuccess = json['DeliveryRatingSuccess'];
    deliveryRatingMessage = json['DeliveryRatingMessage'];
    partnerNameNoSign = json['PartnerNameNoSign'];
    priceListName = json['PriceListName'];
    paymentTermId = json['PaymentTermId'];
    isFast = json['IsFast'];
    tableSearch = json['TableSearch'];
    nameTypeOrder = json['NameTypeOrder'];
    discount = json['Discount'];
    discountAmount = json['DiscountAmount'];
    decreaseAmount = json['DecreaseAmount'];
    totalAmountBeforeDiscount = json['TotalAmountBeforeDiscount'];
    type = json['Type'];
    search = json['Search'];
  }
}

class ReportSaleOrderLine {
  String odataType;
  int id;
  dynamic productUOSQty;
  int productUOMId;
  dynamic invoiceUOMId;
  int invoiceQty;
  int sequence;
  double priceUnit;
  int productUOMQty;
  String name;
  String state;
  dynamic orderPartnerId;
  int orderId;
  int discount;
  double discountFixed;
  String discountType;
  dynamic productId;
  bool invoiced;
  dynamic companyId;
  double priceTax;
  dynamic priceSubTotal;
  double priceTotal;
  dynamic priceRecent;
  dynamic barem;
  dynamic tai;
  dynamic virtualAvailable;
  dynamic qtyAvailable;
  String priceOn;
  double khoiLuongDelivered;
  int qtyDelivered;
  double qtyInvoiced;
  double khoiLuong;
  dynamic note;
  bool hasProcurements;
  dynamic warningMessage;
  double customerLead;
  String productUOMName;
  String type;
  dynamic pOSId;
  int fastId;
  dynamic productNameGet;
  dynamic productName;
  dynamic uOMDomain;

  ReportSaleOrderLine(
      {this.odataType,
      this.id,
      this.productUOSQty,
      this.productUOMId,
      this.invoiceUOMId,
      this.invoiceQty,
      this.sequence,
      this.priceUnit,
      this.productUOMQty,
      this.name,
      this.state,
      this.orderPartnerId,
      this.orderId,
      this.discount,
      this.discountFixed,
      this.discountType,
      this.productId,
      this.invoiced,
      this.companyId,
      this.priceTax,
      this.priceSubTotal,
      this.priceTotal,
      this.priceRecent,
      this.barem,
      this.tai,
      this.virtualAvailable,
      this.qtyAvailable,
      this.priceOn,
      this.khoiLuongDelivered,
      this.qtyDelivered,
      this.qtyInvoiced,
      this.khoiLuong,
      this.note,
      this.hasProcurements,
      this.warningMessage,
      this.customerLead,
      this.productUOMName,
      this.type,
      this.pOSId,
      this.fastId,
      this.productNameGet,
      this.productName,
      this.uOMDomain});

  ReportSaleOrderLine.fromJson(Map<String, dynamic> json) {
    odataType = json['@odata.type'];
    id = json['Id'];
    productUOSQty = json['ProductUOSQty'];
    productUOMId = json['ProductUOMId'];
    invoiceUOMId = json['InvoiceUOMId'];
    invoiceQty = json['InvoiceQty'];
    sequence = json['Sequence'];
    priceUnit = json['PriceUnit'];
    productUOMQty = json['ProductUOMQty'];
    name = json['Name'];
    state = json['State'];
    orderPartnerId = json['OrderPartnerId'];
    orderId = json['OrderId'];
    discount = json['Discount'];
    discountFixed = json['Discount_Fixed'];
    discountType = json['DiscountType'];
    productId = json['ProductId'];
    invoiced = json['Invoiced'];
    companyId = json['CompanyId'];
    priceTax = json['PriceTax'];
    priceSubTotal = json['PriceSubTotal'];
    priceTotal = json['PriceTotal'];
    priceRecent = json['PriceRecent'];
    barem = json['Barem'];
    tai = json['Tai'];
    virtualAvailable = json['VirtualAvailable'];
    qtyAvailable = json['QtyAvailable'];
    priceOn = json['PriceOn'];
    khoiLuongDelivered = json['KhoiLuongDelivered']?.toDouble();
    qtyDelivered = json['QtyDelivered'];
    qtyInvoiced = json['QtyInvoiced'];
    khoiLuong = json['KhoiLuong']?.toDouble();
    note = json['Note'];
    hasProcurements = json['HasProcurements'];
    warningMessage = json['WarningMessage'];
    customerLead = json['CustomerLead'];
    productUOMName = json['ProductUOMName'];
    type = json['Type'];
    pOSId = json['POSId'];
    fastId = json['FastId'];
    productNameGet = json['ProductNameGet'];
    productName = json['ProductName'];
    uOMDomain = json['UOMDomain'];
  }
}
