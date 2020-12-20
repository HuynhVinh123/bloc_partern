import 'dart:convert' as JSON;
import 'package:tpos_api_client/tpos_api_client.dart';

class SaleSetting {
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
        ? (JSON.jsonDecode(json["StatusDenyPrintSale"]) as List)
            .map((e) => e as Map<String, dynamic>)
            .toList()
        : [];

    statusDenyPrintShip = json["StatusDenyPrintShip"] != null &&
            json["StatusDenyPrintShip"] != "null"
        ? (JSON.jsonDecode(json["StatusDenyPrintShip"]) as List)
            .map((e) => e as Map<String, dynamic>)
            .toList()
        : [];

    if (json["Product"] != null) {
      product = Product.fromJson(json["Product"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['@odata.context'] = this.odataContext;
    data['Id'] = this.id;
    data['CompanyId'] = this.companyId;
    data['GroupUOM'] = this.groupUOM;
    data['GroupDiscountPerSOLine'] = this.groupDiscountPerSOLine;
    data['GroupWeightPerSOLine'] = this.groupWeightPerSOLine;
    data['DefaultInvoicePolicy'] = this.defaultInvoicePolicy;
    data['SalePricelistSetting'] = this.salePricelistSetting;
    data['DefaultPickingPolicy'] = this.defaultPickingPolicy;
    data['GroupProductPricelist'] = this.groupProductPricelist;
    data['GroupPricelistItem'] = this.groupPricelistItem;
    data['GroupSalePricelist'] = this.groupSalePricelist;
    data['GroupCreditLimit'] = this.groupCreditLimit;
    data['GroupSaleDeliveryAddress'] = this.groupSaleDeliveryAddress;
    data['GroupDelivery'] = this.groupDelivery;
    data['SaleNote'] = this.saleNote;
    data['AllowSaleNegative'] = this.allowSaleNegative;
    data['GroupFastSaleDeliveryCarrier'] = this.groupFastSaleDeliveryCarrier;
    data['GroupFastSaleShowPartnerCredit'] =
        this.groupFastSaleShowPartnerCredit;
    data['SalePartnerId'] = this.salePartnerId;
    data['GroupSaleLayout'] = this.groupSaleLayout;
    data['DeliveryCarrierId'] = this.deliveryCarrierId;
    data['GroupSaleOnlineNote'] = this.groupSaleOnlineNote;
    data['GroupFastSaleReceiver'] = this.groupFastSaleReceiver;
    data['TaxId'] = this.taxId;
    data['GroupPriceRecent'] = this.groupPriceRecent;
    data['GroupFastSalePriceRecentFill'] = this.groupFastSalePriceRecentFill;
    data['GroupDiscountTotal'] = this.groupDiscountTotal;
    data['GroupFastSaleTax'] = this.groupFastSaleTax;
    data['GroupFastSaleInitCode'] = this.groupFastSaleInitCode;
    data['GroupAmountPaid'] = this.groupAmountPaid;
    data['GroupSalePromotion'] = this.groupSalePromotion;
    data['QuatityDecimal'] = this.quatityDecimal;
    data['GroupSearchboxWithInventory'] = this.groupSearchboxWithInventory;
    data['GroupPartnerSequence'] = this.groupPartnerSequence;
    data['GroupProductSequence'] = this.groupProductSequence;
    data['Weight'] = this.weight;
    data['ShipAmount'] = this.shipAmount;
    data['DeliveryNote'] = this.deliveryNote;
    data['SalePartner'] = this.salePartner;
    data['DeliveryCarrier'] = this.deliveryCarrier;
    data['Tax'] = this.tax;
    data["GroupFastSaleAddressFull"] = this.groupFastSaleAddressFull;
    data["GroupDenyPrintNoShippingConnection"] =
        this.groupDenyPrintNoShippingConnection;
    data["StatusDenyPrintSale"] = JSON.json.encode(statusDenyPrintSale);
    data["StatusDenyPrintShip"] = JSON.json.encode(statusDenyPrintShip);
    if (this.product != null) {
      data["Product"] = this.product.toJson(removeIfNull: true);
    }
    data["ProductId"] = this.productId;
    return data;
  }
}
