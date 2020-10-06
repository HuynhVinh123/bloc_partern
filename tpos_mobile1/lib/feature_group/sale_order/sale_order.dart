import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/sale_order/partner_invoice.dart';
import 'package:tpos_mobile/feature_group/sale_order/partner_shipping.dart';
import 'package:tpos_mobile/feature_group/sale_order/sale_order_line.dart';
import 'package:tpos_mobile/src/tpos_apis/models/account_journal.dart';

import 'package:tpos_mobile/src/tpos_apis/models/currency.dart';

import 'package:tpos_mobile/src/tpos_apis/models/stock_warehouse.dart';

class SaleOrder {
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
  Null shipped;
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
  List<Null> pickings;
  List<Null> invoices;
  List<Null> fastInvoices;
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
  Null project;
  String shippingAddress;
  String phoneNumber;
  String note2;
  String dateShipped;
  int carrierId;
  Null carrier;
  double deliveryPrice;
  String invoiceShippingOnDelivery;
  String deliveryRatingSuccess;
  String deliveryRatingMessage;
  String partnerNameNoSign;
  String priceListName;
  int paymentTermId;
  Null paymentTerm;
  bool isFast;
  Null tableSearch;
  String nameTypeOrder;
  int residual;

  bool get isStepDraft => true;
  bool get isStepConfirm => this.state == "sale";
  bool get isStepCompleted =>
      this.state == "sale" && this.invoiceStatus == "invoiced";

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

    if (json["DateExpected"] != null) {
      dateExpected = DateTime.parse(json["DateExpected"])?.toLocal();
    }
    id = json['Id'];
    partnerId = json['PartnerId'];
    if (json["Partner"] != null) {
      this.partner = Partner.fromJson(json["Partner"]);
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
      this.company = Company.fromJson(json["Company"]);
    }
    userId = json['UserId'];
    if (json["User"] != null) {
      this.user = ApplicationUser.fromJson(json["User"]);
    }
    userName = json['UserName'];
    orderPolicy = json['OrderPolicy'];
    pickingPolicy = json['PickingPolicy'];
    dateConfirm = json['DateConfirm'];
    shipped = json['Shipped'];
    priceListId = json['PriceListId'];
    if (json["PriceList"] != null) {
      this.priceList = ProductPrice.fromJson(json["PriceList"]);
    }
    showState = json['ShowState'];
    showFastState = json['ShowFastState'];
    currencyId = json['CurrencyId'];
    if (json["Currency"] != null) {
      this.currency = Currency.fromJson(json["Currency"]);
    }
    paymentJournalId = json['PaymentJournalId'];
    if (json["PaymentJournal"] != null) {
      this.paymentJournal = AccountJournal.fromJson(json["PaymentJournal"]);
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
        ? new PartnerInvoice.fromJson(json['PartnerInvoice'])
        : null;
    partnerShipping = json['PartnerShipping'] != null
        ? new PartnerShipping.fromJson(json['PartnerShipping'])
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

  get dateQuotation => null;

  Map<String, dynamic> toJson({bool removeIfNull = true}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['DateOrder'] = this.dateOrder.toUtc().toIso8601String();
    data['PartnerId'] = this.partnerId;
    if (this.partner != null) {
      data['Partner'] = this.partner.toJson(true);
    }

    data["OrderLines"] = this.orderLines != null
        ? orderLines.map((map) {
            return map.toJson(removeIfNull: true);
          }).toList()
        : null;
    data['PartnerDisplayName'] = this.partnerDisplayName;
    data['AmountTax'] = this.amountTax;
    data['LoaiDonGia'] = this.loaiDonGia;
    data['InvoiceCount'] = this.invoiceCount;
    data['AmountDeposit'] = this.amountDeposit;
    data['AmountUntaxed'] = this.amountUntaxed;
    data['AmountTotal'] = this.amountTotal;
    data['Note'] = this.note;
    data['State'] = this.state;
    data['Name'] = this.name;
    data['WarehouseId'] = this.warehouseId;
    data['Warehouse'] = this.warehouse;
    data['ProcurementGroupId'] = this.procurementGroupId;
    data['CompanyId'] = this.companyId;
    data['Company'] = this.company;
    data['UserId'] = this.userId;
    data["User"] = this.user?.toJson(removeIfNull);
    data['UserName'] = this.userName;
    data['OrderPolicy'] = this.orderPolicy;
    data['PickingPolicy'] = this.pickingPolicy;
    data['DateConfirm'] = this.dateConfirm;
    data['Shipped'] = this.shipped;
    data['PriceListId'] = this.priceListId;
    data['PriceList'] = this.priceList;
    data['ShowState'] = this.showState;
    data['ShowFastState'] = this.showFastState;
    data['CurrencyId'] = this.currencyId;
    data['Currency'] = this.currency;
    data['PaymentJournalId'] = this.paymentJournalId;
    data['PaymentJournal'] = this.paymentJournal;
    data['InvoiceStatus'] = this.invoiceStatus;
    data['ShowInvoiceStatus'] = this.showInvoiceStatus;
    data['TongTrongLuong'] = this.tongTrongLuong;
    data['TongTaiTrong'] = this.tongTaiTrong;
    data['DonGiaKg'] = this.donGiaKg;

    data['TransportRef'] = this.transportRef;
    data['PartnerInvoiceId'] = this.partnerInvoiceId;
    data['PartnerInvoice'] = this.partnerInvoice?.toJson(removeIfNull: true);
    data['PartnerShippingId'] = this.partnerShippingId;
    data['PartnerShipping'] = this.partnerShipping?.toJson(removeIfNull: true);
    data['AmountTotalStr'] = this.amountTotalStr;
    data['SearchPartnerId'] = this.searchPartnerId;
    data['CongNo'] = this.congNo;
    data['ProjectId'] = this.projectId;
    data['Project'] = this.project;
    data['ShippingAddress'] = this.shippingAddress;
    data['PhoneNumber'] = this.phoneNumber;
    data['Note2'] = this.note2;
    data['DateShipped'] = this.dateShipped;
    data['CarrierId'] = this.carrierId;
    data['Carrier'] = this.carrier;
    data['DeliveryPrice'] = this.deliveryPrice;
    data['InvoiceShippingOnDelivery'] = this.invoiceShippingOnDelivery;
    data['DeliveryRatingSuccess'] = this.deliveryRatingSuccess;
    data['DeliveryRatingMessage'] = this.deliveryRatingMessage;
    data['PartnerNameNoSign'] = this.partnerNameNoSign;
    data['PriceListName'] = this.priceListName;
    data['PaymentTermId'] = this.paymentTermId;
    data['PaymentTerm'] = this.paymentTerm;
    data['IsFast'] = this.isFast;
    data['TableSearch'] = this.tableSearch;
    data['NameTypeOrder'] = this.nameTypeOrder;
    data['Residual'] = this.residual;

    if (dateExpected != null) {
      data['DateExpected'] = this.dateExpected.toUtc().toIso8601String();
    }

    if (removeIfNull == true) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
