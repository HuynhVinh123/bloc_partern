import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/sale_order/partner_invoice.dart';
import 'package:tpos_mobile/feature_group/sale_order/partner_shipping.dart';
import 'package:tpos_mobile/feature_group/sale_order/sale_order_line.dart';


import 'package:tpos_mobile/src/tpos_apis/models/stock_warehouse.dart';

class SaleOrder {
  SaleOrder(
      {this.id,
      this.dateOrder,
      this.partnerId,
      this.partner,
      this.partnerDisplayName,
      this.amountTax,
      this.amountDeposit,
      this.amountUntaxed,
      this.amountTotal,
      this.note,
      this.state,
      this.name,
      this.warehouseId,
      this.warehouse,
      this.procurementGroupId,
      this.companyId,
      this.company,
      this.userId,
      this.user,
      this.userName,
      this.orderPolicy,
      this.pickingPolicy,
      this.dateConfirm,
      this.shipped,
      this.priceListId,
      this.priceList,
      this.showState,
      this.showFastState,
      this.currencyId,
      this.currency,
      this.paymentJournalId,
      this.paymentJournal,
      this.orderLines,
      this.loaiDonGia,
      this.deliveryCount,
      this.invoiceCount,
      this.pickings,
      this.invoices,
      this.fastInvoices,
      this.invoiceStatus,
      this.showInvoiceStatus,
      this.tongTrongLuong,
      this.tongTaiTrong,
      this.donGiaKg,
      this.dateExpected,
      this.transportRef,
      this.partnerInvoiceId,
      this.partnerInvoice,
      this.partnerShippingId,
      this.partnerShipping,
      this.amountTotalStr,
      this.searchPartnerId,
      this.congNo,
      this.projectId,
      this.project,
      this.shippingAddress,
      this.phoneNumber,
      this.note2,
      this.dateShipped,
      this.carrierId,
      this.carrier,
      this.deliveryPrice,
      this.invoiceShippingOnDelivery,
      this.deliveryRatingSuccess,
      this.deliveryRatingMessage,
      this.partnerNameNoSign,
      this.priceListName,
      this.paymentTermId,
      this.paymentTerm,
      this.isFast,
      this.tableSearch,
      this.nameTypeOrder,
      this.residual});

  SaleOrder.fromJson(Map<String, dynamic> json) {
    if (json["DateOrder"] != null) {
      final String unixTimeStr =
          RegExp(r"(?<=Date\()\d+").stringMatch(json["DateOrder"]);

      if (unixTimeStr != null && unixTimeStr.isNotEmpty) {
        final int unixTime = int.parse(unixTimeStr);
        dateOrder = DateTime.fromMillisecondsSinceEpoch(unixTime);
      } else {
        if (json["DateOrder"] != null) {
          dateOrder = DateTime.parse(json["DateOrder"]).toLocal();
        }
      }
    }

    if (json["DateExpected"] != null) {
      dateExpected = DateTime.parse(json["DateExpected"])?.toLocal();
    }
    id = json['Id'];
    partnerId = json['PartnerId'];
    if (json["Partner"] != null) {
      partner = Partner.fromJson(json["Partner"]);
    }
    partnerDisplayName = json['PartnerDisplayName'];
    amountTax = json['AmountTax']?.toDouble();
    amountDeposit = json['AmountDeposit']?.toDouble();
    amountUntaxed = json['AmountUntaxed']?.toDouble();
    amountTotal = json['AmountTotal']?.toDouble();
    note = json['Note'];
    state = json['State'];
    name = json['Name'];
    warehouseId = json['WarehouseId'];
    if (json["Warehouse"] != null) {
      warehouse = StockWareHouse.fromJson(json["Warehouse"]);
    }
    procurementGroupId = json['ProcurementGroupId'];
    companyId = json['CompanyId'];
    if (json["Company"] != null) {
      company = Company.fromJson(json["Company"]);
    }
    userId = json['UserId'];
    if (json["User"] != null) {
      user = ApplicationUser.fromJson(json["User"]);
    }
    userName = json['UserName'];
    orderPolicy = json['OrderPolicy'];
    pickingPolicy = json['PickingPolicy'];
    dateConfirm = json['DateConfirm'];
    shipped = json['Shipped'];
    priceListId = json['PriceListId'];
    if (json["PriceList"] != null) {
      priceList = ProductPrice.fromJson(json["PriceList"]);
    }
    showState = json['ShowState'];
    showFastState = json['ShowFastState'];
    currencyId = json['CurrencyId'];
    if (json["Currency"] != null) {
      currency = Currency.fromJson(json["Currency"]);
    }
    paymentJournalId = json['PaymentJournalId'];
    if (json["PaymentJournal"] != null) {
      paymentJournal = AccountJournal.fromJson(json["PaymentJournal"]);
    }
    loaiDonGia = json['LoaiDonGia'];
    deliveryCount = json['DeliveryCount'];
    invoiceCount = json['InvoiceCount'];
    invoiceStatus = json['InvoiceStatus'];
    showInvoiceStatus = json['ShowInvoiceStatus'];
    tongTrongLuong = json['TongTrongLuong'];
    tongTaiTrong = json['TongTaiTrong'];
    donGiaKg = json['DonGiaKg']?.toDouble();

    transportRef = json['TransportRef'];
    partnerInvoiceId = json['PartnerInvoiceId'];
    partnerInvoice = json['PartnerInvoice'] != null
        ? PartnerInvoice.fromJson(json['PartnerInvoice'])
        : null;
    partnerShipping = json['PartnerShipping'] != null
        ? PartnerShipping.fromJson(json['PartnerShipping'])
        : null;
    partnerShippingId = json['PartnerShippingId'];
    amountTotalStr = json['AmountTotalStr'];
    searchPartnerId = json['SearchPartnerId'];
    congNo = json['CongNo']?.toDouble();
    projectId = json['ProjectId'];
    project = json['Project'];
    shippingAddress = json['ShippingAddress'];
    phoneNumber = json['PhoneNumber'];
    note2 = json['Note2'];
    dateShipped = json['DateShipped'];
    carrierId = json['CarrierId'];
    carrier = json['Carrier'];
    deliveryPrice = json['DeliveryPrice'];
    invoiceShippingOnDelivery = json['InvoiceShippingOnDelivery'];
    deliveryRatingSuccess = json['DeliveryRatingSuccess'];
    deliveryRatingMessage = json['DeliveryRatingMessage'];
    partnerNameNoSign = json['PartnerNameNoSign'];
    priceListName = json['PriceListName'];
    paymentTermId = json['PaymentTermId'];
    paymentTerm = json['PaymentTerm'];
    isFast = json['IsFast'];
    tableSearch = json['TableSearch'];
    nameTypeOrder = json['NameTypeOrder'];
    residual = json['Residual'];
  }

  int id;
  DateTime dateOrder;
  int partnerId;
  Partner partner;
  String partnerDisplayName;
  double amountTax;
  double amountDeposit;
  double amountUntaxed;
  double amountTotal;
  String note;
  String state;
  String name;
  int warehouseId;
  StockWareHouse warehouse;
  int procurementGroupId;
  int companyId;
  Company company;
  String userId;
  ApplicationUser user;
  String userName;
  String orderPolicy;
  String pickingPolicy;
  DateTime dateConfirm;
  dynamic shipped;
  int priceListId;
  ProductPrice priceList;
  String showState;
  String showFastState;
  int currencyId;
  Currency currency;
  int paymentJournalId;
  AccountJournal paymentJournal;
  PartnerShipping partnerShipping;
  PartnerInvoice partnerInvoice;
  List<SaleOrderLine> orderLines;
  String loaiDonGia;
  int deliveryCount;
  int invoiceCount;
  List<dynamic> pickings;
  List<dynamic> invoices;
  List<dynamic> fastInvoices;
  String invoiceStatus;
  String showInvoiceStatus;
  double tongTrongLuong;
  double tongTaiTrong;
  double donGiaKg;
  DateTime dateExpected;
  String transportRef;
  int partnerInvoiceId;
  int partnerShippingId;
  String amountTotalStr;
  int searchPartnerId;
  double congNo;
  int projectId;
  dynamic project;
  String shippingAddress;
  String phoneNumber;
  String note2;
  String dateShipped;
  int carrierId;
  dynamic carrier;
  double deliveryPrice;
  String invoiceShippingOnDelivery;
  String deliveryRatingSuccess;
  String deliveryRatingMessage;
  String partnerNameNoSign;
  String priceListName;
  int paymentTermId;
  dynamic paymentTerm;
  bool isFast;
  dynamic tableSearch;
  String nameTypeOrder;
  int residual;

  bool get isStepDraft => true;
  bool get isStepConfirm => state == "sale";
  bool get isStepCompleted => state == "sale" && invoiceStatus == "invoiced";

  dynamic get dateQuotation => null;

  Map<String, dynamic> toJson({bool removeIfNull = true}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['DateOrder'] = dateOrder.toUtc().toIso8601String();
    data['PartnerId'] = partnerId;
    if (partner != null) {
      data['Partner'] = partner.toJson(true);
    }

    data["OrderLines"] = orderLines != null
        ? orderLines.map((map) {
            return map.toJson(removeIfNull: true);
          }).toList()
        : null;
    data['PartnerDisplayName'] = partnerDisplayName;
    data['AmountTax'] = amountTax;
    data['LoaiDonGia'] = loaiDonGia;
    data['InvoiceCount'] = invoiceCount;
    data['AmountDeposit'] = amountDeposit;
    data['AmountUntaxed'] = amountUntaxed;
    data['AmountTotal'] = amountTotal;
    data['Note'] = note;
    data['State'] = state;
    data['Name'] = name;
    data['WarehouseId'] = warehouseId;
    data['Warehouse'] = warehouse;
    data['ProcurementGroupId'] = procurementGroupId;
    data['CompanyId'] = companyId;
    data['Company'] = company;
    data['UserId'] = userId;
    data["User"] = user?.toJson(removeIfNull);
    data['UserName'] = userName;
    data['OrderPolicy'] = orderPolicy;
    data['PickingPolicy'] = pickingPolicy;
    data['DateConfirm'] = dateConfirm;
    data['Shipped'] = shipped;
    data['PriceListId'] = priceListId;
    data['PriceList'] = priceList;
    data['ShowState'] = showState;
    data['ShowFastState'] = showFastState;
    data['CurrencyId'] = currencyId;
    data['Currency'] = currency;
    data['PaymentJournalId'] = paymentJournalId;
    data['PaymentJournal'] = paymentJournal;
    data['InvoiceStatus'] = invoiceStatus;
    data['ShowInvoiceStatus'] = showInvoiceStatus;
    data['TongTrongLuong'] = tongTrongLuong;
    data['TongTaiTrong'] = tongTaiTrong;
    data['DonGiaKg'] = donGiaKg;

    data['TransportRef'] = transportRef;
    data['PartnerInvoiceId'] = partnerInvoiceId;
    data['PartnerInvoice'] = partnerInvoice?.toJson(removeIfNull: true);
    data['PartnerShippingId'] = partnerShippingId;
    data['PartnerShipping'] = partnerShipping?.toJson(removeIfNull: true);
    data['AmountTotalStr'] = amountTotalStr;
    data['SearchPartnerId'] = searchPartnerId;
    data['CongNo'] = congNo;
    data['ProjectId'] = projectId;
    data['Project'] = project;
    data['ShippingAddress'] = shippingAddress;
    data['PhoneNumber'] = phoneNumber;
    data['Note2'] = note2;
    data['DateShipped'] = dateShipped;
    data['CarrierId'] = carrierId;
    data['Carrier'] = carrier;
    data['DeliveryPrice'] = deliveryPrice;
    data['InvoiceShippingOnDelivery'] = invoiceShippingOnDelivery;
    data['DeliveryRatingSuccess'] = deliveryRatingSuccess;
    data['DeliveryRatingMessage'] = deliveryRatingMessage;
    data['PartnerNameNoSign'] = partnerNameNoSign;
    data['PriceListName'] = priceListName;
    data['PaymentTermId'] = paymentTermId;
    data['PaymentTerm'] = paymentTerm;
    data['IsFast'] = isFast;
    data['TableSearch'] = tableSearch;
    data['NameTypeOrder'] = nameTypeOrder;
    data['Residual'] = residual;

    if (dateExpected != null) {
      data['DateExpected'] = dateExpected.toUtc().toIso8601String();
    }

    if (removeIfNull == true) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
