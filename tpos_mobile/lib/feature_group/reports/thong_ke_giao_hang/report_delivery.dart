import 'package:tpos_api_client/tpos_api_client.dart';

class ReportDeliveryOrderLine {
  ReportDeliveryOrderLine(
      {this.id,
      this.productId,
      this.productUOMId,
      this.priceUnit,
      this.productUOMQty,
      this.discount,
      this.discountFixed,
      this.priceTotal,
      this.priceSubTotal,
      this.weight,
      this.weightTotal,
      this.accountId,
      this.priceRecent,
      this.productName,
      this.productUOMName,
      this.saleLineIds,
      this.productNameGet,
      this.saleLineId,
      this.type,
      this.promotionProgramId,
      this.note,
      this.productBarcode,
      this.product,
      this.productUOM,
      this.account});

  ReportDeliveryOrderLine.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    productId = json['ProductId'];
    productUOMId = json['ProductUOMId'];
    priceUnit = json['PriceUnit'];
    productUOMQty = json['ProductUOMQty'];
    discount = json['Discount'];
    discountFixed = json['Discount_Fixed'];
    priceTotal = json['PriceTotal'];
    priceSubTotal = json['PriceSubTotal'];
    weight = json['Weight'];
    weightTotal = json['WeightTotal'];
    accountId = json['AccountId'];
    priceRecent = json['PriceRecent']?.toDouble();
    productName = json['ProductName'];
    productUOMName = json['ProductUOMName'];
//    if (json['SaleLineIds'] != null) {
//      saleLineIds = new List<Null>();
//      json['SaleLineIds'].forEach((v) {
//        saleLineIds.add(new Null.fromJson(v));
//      });
//    }
    productNameGet = json['ProductNameGet'];
    saleLineId = json['SaleLineId'];
    type = json['Type'];
    promotionProgramId = json['PromotionProgramId'];
    note = json['Note'];
    productBarcode = json['ProductBarcode'];
    product =
        json['Product'] != null ? Product.fromJson(json['Product']) : null;
    productUOM = json['ProductUOM'] != null
        ? ProductUOM.fromJson(json['ProductUOM'])
        : null;
    account =
        json['Account'] != null ? Account.fromJson(json['Account']) : null;
  }

  int id;
  int productId;
  int productUOMId;
  double priceUnit;
  double productUOMQty;
  double discount;
  double discountFixed;
  double priceTotal;
  double priceSubTotal;
  double weight;
  double weightTotal;
  int accountId;
  double priceRecent;
  String productName;
  String productUOMName;
  List<dynamic> saleLineIds;
  String productNameGet;
  int saleLineId;
  String type;
  int promotionProgramId;
  String note;
  String productBarcode;
  Product product;
  ProductUOM productUOM;
  Account account;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['ProductId'] = productId;
    data['ProductUOMId'] = productUOMId;
    data['PriceUnit'] = priceUnit;
    data['ProductUOMQty'] = productUOMQty;
    data['Discount'] = discount;
    data['Discount_Fixed'] = discountFixed;
    data['PriceTotal'] = priceTotal;
    data['PriceSubTotal'] = priceSubTotal;
    data['Weight'] = weight;
    data['WeightTotal'] = weightTotal;
    data['AccountId'] = accountId;
    data['PriceRecent'] = priceRecent;
    data['ProductName'] = productName;
    data['ProductUOMName'] = productUOMName;
//    if (this.saleLineIds != null) {
//      data['SaleLineIds'] = this.saleLineIds.map((v) => v.toJson()).toList();
//    }
    data['ProductNameGet'] = productNameGet;
    data['SaleLineId'] = saleLineId;
    data['Type'] = type;
    data['PromotionProgramId'] = promotionProgramId;
    data['Note'] = note;
    data['ProductBarcode'] = productBarcode;
    if (product != null) {
      data['Product'] = product.toJson();
    }
    if (productUOM != null) {
      data['ProductUOM'] = productUOM.toJson();
    }
    if (account != null) {
      data['Account'] = account.toJson();
    }
    return data;
  }
}
