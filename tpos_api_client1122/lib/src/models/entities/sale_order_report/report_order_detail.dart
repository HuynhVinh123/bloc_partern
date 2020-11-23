class ReportOrderDetailOverview {

  ReportOrderDetailOverview({this.odataContext, this.odataCount, this.reportOrderDetails});

  ReportOrderDetailOverview.fromJson(Map<String, dynamic> json) {
    odataContext = json['@odata.context'];
    odataCount = json['@odata.count'];
    if (json['value'] != null) {
      reportOrderDetails = <ReportOrderDetail>[];
      json['value'].forEach((v) {
        reportOrderDetails.add(ReportOrderDetail.fromJson(v));
      });
    }
  }

  String odataContext;
  int odataCount;
  List<ReportOrderDetail> reportOrderDetails;


}

class ReportOrderDetail {
  bool selected = false;
  int id;
  DateTime dateOrder;
  int partnerId;
  String partnerDisplayName;
  double amountTax;
  dynamic amountUntaxed;
  double amountTotal;
  dynamic amountTotalSigned;
  dynamic note;
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
  int countInvoices;

  ReportOrderDetail(
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
      this.search,this.countInvoices});

  ReportOrderDetail.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    if (json["DateOrder"] != null) {
      String unixTimeStr =
          RegExp(r"(?<=Date\()\d+").stringMatch(json["DateOrder"]);

      if (unixTimeStr != null && unixTimeStr.isNotEmpty) {
        int unixTime = int.parse(unixTimeStr);
        dateOrder = DateTime.fromMillisecondsSinceEpoch(unixTime);
      } else {
        if (json["DateOrder"] != null) {
          dateOrder = DateTime.parse(json["DateOrder"]).toLocal();
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