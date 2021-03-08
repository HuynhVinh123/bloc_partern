
import 'package:tpos_api_client/tpos_api_client.dart';

class SaleOrderLine {
  SaleOrderLine(
      {this.id,
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
      this.uOMDomain,
      this.product,
      this.productUOM,
      this.invoiceUOM});

  SaleOrderLine.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    productUOSQty = json['ProductUOSQty'];
    productUOMId = json['ProductUOMId'];
    invoiceUOMId = json['InvoiceUOMId'];
    invoiceQty = json['InvoiceQty']?.toDouble();
    sequence = json['Sequence'];
    priceUnit = json['PriceUnit'];
    productUOMQty = json['ProductUOMQty'];
    name = json['Name'];
    state = json['State'];
    orderPartnerId = json['OrderPartnerId'];
    orderId = json['OrderId'];
    discount = json['Discount']?.toDouble();
    discountFixed = json['Discount_Fixed'];
    discountType = json['DiscountType'];
    productId = json['ProductId'];
    invoiced = json['Invoiced'];
    companyId = json['CompanyId'];
    priceTax = json['PriceTax'];
    priceSubTotal = json['PriceSubTotal'];
    priceTotal = json['PriceTotal'];
    priceRecent = json['PriceRecent']?.toDouble();
    barem = json['Barem'];
    tai = json['Tai'];
    virtualAvailable = json['VirtualAvailable'];
    qtyAvailable = json['QtyAvailable'];
    priceOn = json['PriceOn'];
    khoiLuongDelivered = json['KhoiLuongDelivered']?.toDouble();
    qtyDelivered = json['QtyDelivered']?.toDouble();
    qtyInvoiced = json['QtyInvoiced']?.toDouble();
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
    product =
        json['Product'] != null ? Product.fromJson(json['Product']) : null;
    productUOM = json['ProductUOM'] != null
        ? ProductUOM.fromJson(json['ProductUOM'])
        : null;
    invoiceUOM = json['InvoiceUOM'];
  }

  int id;
  double productUOSQty;
  int productUOMId;
  int invoiceUOMId;
  double invoiceQty;
  int sequence;
  double priceUnit;
  double productUOMQty;
  String name;
  String state;
  int orderPartnerId;
  int orderId;
  double discount;
  double discountFixed;
  dynamic discountType;
  int productId;
  bool invoiced;
  int companyId;
  double priceTax;
  double priceSubTotal;
  double priceTotal;
  double priceRecent;
  dynamic barem;
  double tai;
  dynamic virtualAvailable;
  double qtyAvailable;
  String priceOn;
  double khoiLuongDelivered;
  double qtyDelivered;
  double qtyInvoiced;
  double khoiLuong;
  String note;
  bool hasProcurements;
  String warningMessage;
  double customerLead;
  String productUOMName;
  String type;
  int pOSId;
  int fastId;
  String productNameGet;
  String productName;
  String uOMDomain;
  Product product;
  ProductUOM productUOM;
  String invoiceUOM;

  // add
  double _priceAfterDiscount;
  double get priceAfterDiscount => _priceAfterDiscount;

  // Tinh tổng tiền
  void calculateTotal() {
    if (type == "percent") {
      _priceAfterDiscount = (priceUnit ?? 0) * (100 - discount) / 100;
    } else {
      _priceAfterDiscount = priceUnit - discountFixed;
    }
    priceTotal = _priceAfterDiscount * (productUOMQty ?? 0);
  }

  Map<String, dynamic> toJson({bool removeIfNull = false}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['ProductUOSQty'] = productUOSQty;
    data['ProductUOMId'] = productUOMId;
    data['InvoiceUOMId'] = invoiceUOMId;
    data['InvoiceQty'] = invoiceQty;
    data['Sequence'] = sequence;
    data['PriceUnit'] = priceUnit;
    data['ProductUOMQty'] = productUOMQty;
    data['Name'] = name;
    data['State'] = state;
    data['OrderPartnerId'] = orderPartnerId;
    data['OrderId'] = orderId;
    data['Discount'] = discount;
    data['Discount_Fixed'] = discountFixed;
    data['DiscountType'] = discountType;
    data['ProductId'] = productId;
    data['Invoiced'] = invoiced;
    data['CompanyId'] = companyId;
    data['PriceTax'] = priceTax;
    data['PriceSubTotal'] = priceSubTotal;
    data['PriceTotal'] = priceTotal;
    data['PriceRecent'] = priceRecent;
    data['Barem'] = barem;
    data['Tai'] = tai;
    data['VirtualAvailable'] = virtualAvailable;
    data['QtyAvailable'] = qtyAvailable;
    data['PriceOn'] = priceOn;
    data['KhoiLuongDelivered'] = khoiLuongDelivered;
    data['QtyDelivered'] = qtyDelivered;
    data['QtyInvoiced'] = qtyInvoiced;
    data['KhoiLuong'] = khoiLuong;
    data['Note'] = note;
    data['HasProcurements'] = hasProcurements;
    data['WarningMessage'] = warningMessage;
    data['CustomerLead'] = customerLead;
    data['ProductUOMName'] = productUOMName;
    data['Type'] = type;
    data['POSId'] = pOSId;
    data['FastId'] = fastId;
    data['ProductNameGet'] = productNameGet;
    data['ProductName'] = productName;
    data['UOMDomain'] = uOMDomain;
    if (product != null) {
      data['Product'] = product.toJson();
    }
    if (productUOM != null) {
      data['ProductUOM'] = productUOM.toJson();
    }
    data['InvoiceUOM'] = invoiceUOM;
    if (removeIfNull == true) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
