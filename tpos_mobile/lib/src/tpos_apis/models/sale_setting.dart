import 'dart:convert' as json;
import 'dart:convert';

import 'package:tpos_api_client/tpos_api_client.dart';

class SaleSetting {
  SaleSetting(
      {this.odataContext,
      this.id,
      this.companyId,
      this.groupUOM,
      this.groupDiscountPerSOLine,
      this.groupWeightPerSOLine,
      this.defaultInvoicePolicy,
      this.salePricelistSetting,
      this.defaultPickingPolicy,
      this.groupProductPricelist,
      this.groupPricelistItem,
      this.groupSalePricelist,
      this.groupCreditLimit,
      this.groupSaleDeliveryAddress,
      this.groupDelivery,
      this.saleNote,
      this.allowSaleNegative,
      this.groupFastSaleDeliveryCarrier,
      this.groupFastSaleShowPartnerCredit,
      this.salePartnerId,
      this.groupSaleLayout,
      this.deliveryCarrierId,
      this.groupSaleOnlineNote,
      this.groupFastSaleReceiver,
      this.taxId,
      this.groupPriceRecent,
      this.groupFastSalePriceRecentFill,
      this.groupDiscountTotal,
      this.groupFastSaleTax,
      this.groupFastSaleInitCode,
      this.groupAmountPaid,
      this.groupSalePromotion,
      this.quatityDecimal,
      this.groupSearchboxWithInventory,
      this.groupPartnerSequence,
      this.groupProductSequence,
      this.weight,
      this.shipAmount,
      this.deliveryNote,
      this.salePartner,
      this.deliveryCarrier,
      this.tax,
      this.groupFastSaleAddressFull,
      this.productId,
      this.product,
      this.groupDenyPrintNoShippingConnection,
      this.statusDenyPrintSale,
      this.statusDenyPrintShip});

  SaleSetting.fromJson(Map<String, dynamic> json) {
    odataContext = json['@odata.context'];
    id = json['Id'];
    companyId = json['CompanyId'];
    groupUOM = json['GroupUOM'];
    groupDiscountPerSOLine = json['GroupDiscountPerSOLine'];
    groupWeightPerSOLine = json['GroupWeightPerSOLine'];
    defaultInvoicePolicy = json['DefaultInvoicePolicy'];
    salePricelistSetting = json['SalePricelistSetting'];
    defaultPickingPolicy = json['DefaultPickingPolicy'];
    groupProductPricelist = json['GroupProductPricelist'];
    groupPricelistItem = json['GroupPricelistItem'];
    groupSalePricelist = json['GroupSalePricelist'];
    groupCreditLimit = json['GroupCreditLimit'];
    groupSaleDeliveryAddress = json['GroupSaleDeliveryAddress'];
    groupDelivery = json['GroupDelivery'];
    saleNote = json['SaleNote'];
    allowSaleNegative = json['AllowSaleNegative'];
    groupFastSaleDeliveryCarrier = json['GroupFastSaleDeliveryCarrier'];
    groupFastSaleShowPartnerCredit = json['GroupFastSaleShowPartnerCredit'];
    salePartnerId = json['SalePartnerId'];
    groupSaleLayout = json['GroupSaleLayout'];
    deliveryCarrierId = json['DeliveryCarrierId'];
    groupSaleOnlineNote = json['GroupSaleOnlineNote'];
    groupFastSaleReceiver = json['GroupFastSaleReceiver'];
    taxId = json['TaxId'];
    groupPriceRecent = json['GroupPriceRecent'];
    groupFastSalePriceRecentFill = json['GroupFastSalePriceRecentFill'];
    groupDiscountTotal = json['GroupDiscountTotal'];
    groupFastSaleTax = json['GroupFastSaleTax'];
    groupFastSaleInitCode = json['GroupFastSaleInitCode'];
    groupAmountPaid = json['GroupAmountPaid'];
    groupSalePromotion = json['GroupSalePromotion'];
    quatityDecimal = json['QuatityDecimal'];
    groupSearchboxWithInventory = json['GroupSearchboxWithInventory'];
    groupPartnerSequence = json['GroupPartnerSequence'];
    groupProductSequence = json['GroupProductSequence'];
    weight = json['Weight']?.toDouble();
    shipAmount = json['ShipAmount']?.toDouble();
    deliveryNote = json['DeliveryNote'];
    salePartner = json['SalePartner'];
    deliveryCarrier = json['DeliveryCarrier'];
    tax = json['Tax'];
    groupFastSaleAddressFull = json["GroupFastSaleAddressFull"];
    productId = json["ProductId"];
    groupDenyPrintNoShippingConnection =
        json["GroupDenyPrintNoShippingConnection"] ?? false;
    print(json["StatusDenyPrintSale"]
        .toString()
        .substring(1, json["StatusDenyPrintSale"].toString().length - 1));

    statusDenyPrintSale = json["StatusDenyPrintSale"] != null &&
            json["StatusDenyPrintSale"] != "null"
        ? (jsonDecode(json["StatusDenyPrintSale"]) as List)
            .map((e) => e as Map<String, dynamic>)
            .toList()
        : [];

    statusDenyPrintShip = json["StatusDenyPrintShip"] != null &&
            json["StatusDenyPrintShip"] != "null"
        ? (jsonDecode(json["StatusDenyPrintShip"]) as List)
            .map((e) => e as Map<String, dynamic>)
            .toList()
        : [];

    if (json["Product"] != null) {
      product = Product.fromJson(json["Product"]);
    }
  }
  String odataContext;
  int id;
  int companyId;
  int groupUOM;
  int groupDiscountPerSOLine;
  int groupWeightPerSOLine;
  String defaultInvoicePolicy;
  String salePricelistSetting;
  int defaultPickingPolicy;
  bool groupProductPricelist;
  bool groupPricelistItem;
  bool groupSalePricelist;
  int groupCreditLimit;
  int groupSaleDeliveryAddress;
  int groupDelivery;
  String saleNote;
  bool allowSaleNegative;
  bool groupFastSaleDeliveryCarrier;
  bool groupFastSaleShowPartnerCredit;
  int salePartnerId;
  bool groupSaleLayout;
  int deliveryCarrierId;
  bool groupSaleOnlineNote;
  bool groupFastSaleReceiver;
  int taxId;
  bool groupPriceRecent;
  bool groupFastSalePriceRecentFill;
  bool groupDiscountTotal;
  bool groupFastSaleTax;
  bool groupFastSaleInitCode;
  bool groupAmountPaid;
  bool groupSalePromotion;
  dynamic quatityDecimal;
  bool groupSearchboxWithInventory;
  bool groupPartnerSequence;
  bool groupProductSequence;
  double weight;
  double shipAmount;
  String deliveryNote;
  dynamic salePartner;
  dynamic deliveryCarrier;
  dynamic tax;

  /// Id sản phẩm
  int productId;

  /// sản phẩm
  Product product;

  /// In địa chỉ đẩy đủ hay không
  bool groupFastSaleAddressFull;
  bool groupDenyPrintNoShippingConnection;
  List<Map<String, dynamic>> statusDenyPrintSale;
  List<Map<String, dynamic>> statusDenyPrintShip;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['@odata.context'] = odataContext;
    data['Id'] = id;
    data['CompanyId'] = companyId;
    data['GroupUOM'] = groupUOM;
    data['GroupDiscountPerSOLine'] = groupDiscountPerSOLine;
    data['GroupWeightPerSOLine'] = groupWeightPerSOLine;
    data['DefaultInvoicePolicy'] = defaultInvoicePolicy;
    data['SalePricelistSetting'] = salePricelistSetting;
    data['DefaultPickingPolicy'] = defaultPickingPolicy;
    data['GroupProductPricelist'] = groupProductPricelist;
    data['GroupPricelistItem'] = groupPricelistItem;
    data['GroupSalePricelist'] = groupSalePricelist;
    data['GroupCreditLimit'] = groupCreditLimit;
    data['GroupSaleDeliveryAddress'] = groupSaleDeliveryAddress;
    data['GroupDelivery'] = groupDelivery;
    data['SaleNote'] = saleNote;
    data['AllowSaleNegative'] = allowSaleNegative;
    data['GroupFastSaleDeliveryCarrier'] = groupFastSaleDeliveryCarrier;
    data['GroupFastSaleShowPartnerCredit'] = groupFastSaleShowPartnerCredit;
    data['SalePartnerId'] = salePartnerId;
    data['GroupSaleLayout'] = groupSaleLayout;
    data['DeliveryCarrierId'] = deliveryCarrierId;
    data['GroupSaleOnlineNote'] = groupSaleOnlineNote;
    data['GroupFastSaleReceiver'] = groupFastSaleReceiver;
    data['TaxId'] = taxId;
    data['GroupPriceRecent'] = groupPriceRecent;
    data['GroupFastSalePriceRecentFill'] = groupFastSalePriceRecentFill;
    data['GroupDiscountTotal'] = groupDiscountTotal;
    data['GroupFastSaleTax'] = groupFastSaleTax;
    data['GroupFastSaleInitCode'] = groupFastSaleInitCode;
    data['GroupAmountPaid'] = groupAmountPaid;
    data['GroupSalePromotion'] = groupSalePromotion;
    data['QuatityDecimal'] = quatityDecimal;
    data['GroupSearchboxWithInventory'] = groupSearchboxWithInventory;
    data['GroupPartnerSequence'] = groupPartnerSequence;
    data['GroupProductSequence'] = groupProductSequence;
    data['Weight'] = weight;
    data['ShipAmount'] = shipAmount;
    data['DeliveryNote'] = deliveryNote;
    data['SalePartner'] = salePartner;
    data['DeliveryCarrier'] = deliveryCarrier;
    data['Tax'] = tax;
    data["GroupFastSaleAddressFull"] = groupFastSaleAddressFull;
    data["GroupDenyPrintNoShippingConnection"] =
        groupDenyPrintNoShippingConnection;
    data["StatusDenyPrintSale"] = json.json.encode(statusDenyPrintSale);
    data["StatusDenyPrintShip"] = json.json.encode(statusDenyPrintShip);
    if (product != null) {
      data["Product"] = product.toJson(removeIfNull: true);
    }
    data["ProductId"] = productId;
    return data;
  }
}
