import 'package:tpos_mobile/src/tpos_apis/models/product.dart';
import 'package:tpos_mobile/src/tpos_apis/models/productUOM.dart';

class SaleOrderLine {
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
  Null discountType;
  int productId;
  bool invoiced;
  int companyId;
  double priceTax;
  double priceSubTotal;
  double priceTotal;
  double priceRecent;
  Null barem;
  double tai;
  Null virtualAvailable;
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
    this.priceTotal = _priceAfterDiscount * (this.productUOMQty ?? 0);
  }

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
        json['Product'] != null ? new Product.fromJson(json['Product']) : null;
    productUOM = json['ProductUOM'] != null
        ? new ProductUOM.fromJson(json['ProductUOM'])
        : null;
    invoiceUOM = json['InvoiceUOM'];
  }

  Map<String, dynamic> toJson({bool removeIfNull = false}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['ProductUOSQty'] = this.productUOSQty;
    data['ProductUOMId'] = this.productUOMId;
    data['InvoiceUOMId'] = this.invoiceUOMId;
    data['InvoiceQty'] = this.invoiceQty;
    data['Sequence'] = this.sequence;
    data['PriceUnit'] = this.priceUnit;
    data['ProductUOMQty'] = this.productUOMQty;
    data['Name'] = this.name;
    data['State'] = this.state;
    data['OrderPartnerId'] = this.orderPartnerId;
    data['OrderId'] = this.orderId;
    data['Discount'] = this.discount;
    data['Discount_Fixed'] = this.discountFixed;
    data['DiscountType'] = this.discountType;
    data['ProductId'] = this.productId;
    data['Invoiced'] = this.invoiced;
    data['CompanyId'] = this.companyId;
    data['PriceTax'] = this.priceTax;
    data['PriceSubTotal'] = this.priceSubTotal;
    data['PriceTotal'] = this.priceTotal;
    data['PriceRecent'] = this.priceRecent;
    data['Barem'] = this.barem;
    data['Tai'] = this.tai;
    data['VirtualAvailable'] = this.virtualAvailable;
    data['QtyAvailable'] = this.qtyAvailable;
    data['PriceOn'] = this.priceOn;
    data['KhoiLuongDelivered'] = this.khoiLuongDelivered;
    data['QtyDelivered'] = this.qtyDelivered;
    data['QtyInvoiced'] = this.qtyInvoiced;
    data['KhoiLuong'] = this.khoiLuong;
    data['Note'] = this.note;
    data['HasProcurements'] = this.hasProcurements;
    data['WarningMessage'] = this.warningMessage;
    data['CustomerLead'] = this.customerLead;
    data['ProductUOMName'] = this.productUOMName;
    data['Type'] = this.type;
    data['POSId'] = this.pOSId;
    data['FastId'] = this.fastId;
    data['ProductNameGet'] = this.productNameGet;
    data['ProductName'] = this.productName;
    data['UOMDomain'] = this.uOMDomain;
    if (this.product != null) {
      data['Product'] = this.product.toJson();
    }
    if (this.productUOM != null) {
      data['ProductUOM'] = this.productUOM.toJson();
    }
    data['InvoiceUOM'] = this.invoiceUOM;
    if (removeIfNull == true) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
