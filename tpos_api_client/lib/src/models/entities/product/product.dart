/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'package:tpos_api_client/src/models/entities/product/product_attribute_value.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

import 'productUOM.dart';
import 'product_attribute.dart';
import 'product_category.dart';
import 'product_uom_line.dart';

class Product {
  Product(
      {this.uOMPO,
      this.productAttributeLines,
      this.uomLines,
      this.categ,
      this.uOM,
      this.id,
      this.uOMId,
      this.version,
      this.productTmplId,
      this.price,
      this.oldPrice,
      this.discountPurchase,
      this.weight,
      this.discountSale,
      this.name,
      this.uOMName,
      this.nameGet,
      this.nameNoSign,
      this.image,
      this.imageUrl,
      this.type,
      this.showType,
      this.listPrice,
      this.lstPrice,
      this.purchasePrice,
      this.standardPrice,
      this.saleOK,
      this.purchaseOK,
      this.active,
      this.uOMPOId,
      this.isProductVariant,
      this.qtyAvailable,
      this.virtualAvailable,
      this.outgoingQty,
      this.incomingQty,
      this.categId,
      this.tracking,
      this.saleDelay,
      this.companyId,
      this.invoicePolicy,
      this.purchaseMethod,
      this.availableInPOS,
      this.productVariantCount,
      this.bOMCount,
      this.isCombo,
      this.enableAll,
      this.variantFistId,
      this.defaultCode,
      this.barcode,
      this.nameTemplate,
      this.inventory,
      this.focastInventory,
      this.posSalesCount,
      this.isAvailableOnTPage,
      this.attributeValues,
      this.displayAttributeValues,
      this.priceVariant,
      this.uOMPOName,
      this.lastUpdated,
      this.isDiscount,
      this.dateCreated});

  Product.fromJson(Map<String, dynamic> jsonMap) {
    List<ProductUOMLine> productUOMLines;

    if (jsonMap["UOMLines"] != null)
      productUOMLines = jsonMap["UOMLines"].map((map) {
        return ProductUOMLine.fromJson(map);
      }).toList();
    uomLines = productUOMLines;
    uOM = jsonMap["UOM"] != null ? ProductUOM.fromJson(jsonMap["UOM"]) : null;
    categ = jsonMap["Categ"] != null ? ProductCategory.fromJson(jsonMap["Categ"]) : null;
    uOMPO = jsonMap["UOMPO"] != null ? ProductUOM.fromJson(jsonMap["UOMPO"]) : null;

    List<ProductAttribute> attributeLines;

    if (jsonMap["AttributeLines"] != null)
      attributeLines = jsonMap["AttributeLines"].map((map) {
        return ProductAttribute.fromJson(map);
      }).toList();
    productAttributeLines = attributeLines;

    attributeValues = <ProductAttributeValue>[];

    if (jsonMap["AttributeValues"] != null)
      attributeValues = jsonMap["AttributeValues"].map<ProductAttributeValue>((map) {
        return ProductAttributeValue.fromJson(map);
      }).toList();

    id = jsonMap["Id"];
    priceVariant = (jsonMap["PriceVariant"] ?? 0).toDouble();
    name = jsonMap["Name"];
    uOMId = jsonMap["UOMId"];
    uOMName = jsonMap["UOMName"];
    nameNoSign = jsonMap["NameNoSign"];
    nameGet = jsonMap["NameGet"];
    nameTemplate = jsonMap["NameTemplate"];
    price = jsonMap["Price"];
    oldPrice = jsonMap["OldPrice"];
    version = jsonMap["Version"];
    discountPurchase = jsonMap["DiscountPurchase"]?.toDouble();
    weight = (jsonMap["Weight"] ?? 0).toDouble();
    discountSale = jsonMap["DiscountSale"]?.toDouble();
    productTmplId = jsonMap["ProductTmplId"];
    image = jsonMap["Image"];
    imageUrl = jsonMap["ImageUrl"];

    type = jsonMap["Type"];
    showType = jsonMap["ShowType"];
    listPrice = (jsonMap["ListPrice"] ?? 0).toDouble();
    lstPrice = (jsonMap["LstPrice"] ?? 0).toDouble();

    purchasePrice = jsonMap["PurchasePrice"];
    standardPrice = (jsonMap["StandardPrice"] ?? 0).toDouble();
    saleOK = jsonMap["SaleOK"];
    purchaseOK = jsonMap["PurchaseOK"];
    active = jsonMap["Active"];
    uOMPOId = jsonMap["UOMPOId"];
    isProductVariant = jsonMap["IsProductVariant"];
    qtyAvailable = (jsonMap["QtyAvailable"] ?? 0).toDouble();
    virtualAvailable = (jsonMap["VirtualAvailable"] ?? 0).toDouble();
    outgoingQty = jsonMap["OutgoingQty"]?.toDouble();
    incomingQty = jsonMap["IncomingQty"]?.toDouble();
    categId = jsonMap["CategId"];
    tracking = jsonMap["Tracking"];
    saleDelay = (jsonMap["SaleDelay"] ?? 0).toDouble();
    companyId = jsonMap["CompanyId"];
    invoicePolicy = jsonMap["InvoicePolicy"];
    purchaseMethod = jsonMap["PurchaseMethod"];
    availableInPOS = jsonMap["AvailableInPOS"];
    productVariantCount = jsonMap["ProductVariantCount"];
    bOMCount = jsonMap["BOMCount"];
    isCombo = jsonMap["IsCombo"];
    enableAll = jsonMap["EnableAll"];
    variantFistId = jsonMap["VariantFistId"];
    defaultCode = jsonMap["DefaultCode"];
    barcode = jsonMap["Barcode"];
    displayAttributeValues = jsonMap["DisplayAttributeValues"];
    isAvailableOnTPage = jsonMap["IsAvailableOnTPage"];
    uOMPOName = jsonMap["uOMPOName"];
    isDiscount = jsonMap["IsDiscount"];
    nameTemplateNoSign = jsonMap["NameTemplateNoSign"];
    lastUpdated = jsonMap["LastUpdated"] != null ? DateTime.parse(jsonMap["LastUpdated"]) : null;
    dateCreated = jsonMap["DateCreated"] != null ? DateTime.parse(jsonMap["DateCreated"]) : null;
  }

  factory Product.copyWith(Product product) {
    return Product(
      uOM: product.uOM,
      productAttributeLines: product.productAttributeLines,
      uomLines: product.uomLines,
      categ: product.categ,
      uOMPO: product.uOMPO,
      id: product.id,
      uOMId: product.uOMId,
      version: product.version,
      productTmplId: product.productTmplId,
      price: product.price,
      oldPrice: product.oldPrice,
      discountPurchase: product.discountPurchase,
      weight: product.weight,
      discountSale: product.discountSale,
      name: product.name,
      uOMName: product.uOMName,
      nameGet: product.nameGet,
      nameNoSign: product.nameNoSign,
      image: product.image,
      imageUrl: product.imageUrl,
      type: product.type,
      showType: product.showType,
      listPrice: product.listPrice,
      lstPrice: product.lstPrice,
      purchasePrice: product.purchasePrice,
      standardPrice: product.standardPrice,
      saleOK: product.saleOK,
      purchaseOK: product.purchaseOK,
      active: product.active,
      uOMPOId: product.uOMPOId,
      isProductVariant: product.isProductVariant,
      qtyAvailable: product.qtyAvailable,
      virtualAvailable: product.virtualAvailable,
      outgoingQty: product.outgoingQty,
      incomingQty: product.incomingQty,
      categId: product.categId,
      tracking: product.tracking,
      saleDelay: product.saleDelay,
      companyId: product.companyId,
      invoicePolicy: product.invoicePolicy,
      purchaseMethod: product.purchaseMethod,
      availableInPOS: product.availableInPOS,
      productVariantCount: product.productVariantCount,
      bOMCount: product.bOMCount,
      isCombo: product.isCombo,
      enableAll: product.enableAll,
      variantFistId: product.variantFistId,
      defaultCode: product.defaultCode,
      barcode: product.barcode,
      nameTemplate: product.nameTemplate,
      inventory: product.inventory,
      focastInventory: product.focastInventory,
      posSalesCount: product.posSalesCount,
      attributeValues: product.attributeValues,
      displayAttributeValues: product.displayAttributeValues,
      isAvailableOnTPage: product.isAvailableOnTPage,
      priceVariant: product.priceVariant,
      uOMPOName: product.uOMPOName,
      lastUpdated: product.lastUpdated,
      isDiscount: product.isDiscount,
      dateCreated: product.dateCreated,
    );
  }

  int id, uOMId, version, productTmplId;
  double price, oldPrice, discountPurchase, discountSale;
  String name, uOMName, nameGet, nameNoSign, nameTemplate;
  String image, imageUrl;
  String defaultCode;
  double weight;

  String type;
  String showType;
  double listPrice;
  double lstPrice;
  double purchasePrice;
  double standardPrice;
  bool saleOK;
  bool purchaseOK;
  bool active;
  int uOMPOId;
  bool isProductVariant;
  double qtyAvailable;
  double virtualAvailable;
  double outgoingQty;
  double incomingQty;
  int categId;
  String tracking;
  double saleDelay;
  double priceVariant;
  int companyId;
  String invoicePolicy;
  String purchaseMethod;
  bool availableInPOS;
  int productVariantCount;
  int bOMCount;
  bool isCombo;
  bool enableAll;
  int variantFistId;
  ProductUOM uOM;
  ProductCategory categ;
  ProductUOM uOMPO;
  List<ProductUOMLine> uomLines;
  List<ProductAttribute> productAttributeLines;
  List<ProductAttributeValue> attributeValues;
  String barcode;
  String uOMPOName;
  String displayAttributeValues;
  double inventory;
  double focastInventory;
  double posSalesCount;
  bool isAvailableOnTPage;
  bool isDiscount;
  List<int> imageBytes;
  String defaultImageUrl;
  String nameTemplateNoSign;
  DateTime lastUpdated;
  DateTime dateCreated;

  Map<String, dynamic> toJson({bool removeIfNull = false}) {
    final map = {
      "UOM": uOM != null ? uOM.toJson(removeIfNull) : null,
      "UOMPO": uOMPO != null ? uOMPO.toJson(removeIfNull) : null,
      "Categ": categ != null ? categ.toJson(removeIfNull) : null,
      "Id": id,
      "Name": name,
      "UOMPOId": uOMPOId,
      "UOMId": uOMId,
      "UOMName": uOMName,
      "NameNoSign": nameNoSign,
      "NameGet": nameGet,
      "Price": price?.toInt(),
      "LstPrice": lstPrice?.toInt(),
      "OldPrice": oldPrice,
      "Version": null,
      "DiscountSale": discountSale,
      "DiscountPurchase": discountPurchase,
      "Weight": weight?.toInt(),
      "ProductTmplId": productTmplId,
      "Image": image,
      // "ImageUrl": imageUrl,
      "ImageUrl": null,
      "Type": type,
      "ShowType": showType,
      "ListPrice": listPrice?.toInt(),
      "PurchasePrice": purchasePrice?.toInt(),
      "StandardPrice": standardPrice?.toInt(),
      "SaleOK": saleOK,
      "PurchaseOK": purchaseOK,
      "Active": active,

      "IsProductVariant": isProductVariant,
      "QtyAvailable": qtyAvailable?.toInt(),
      "VirtualAvailable": virtualAvailable?.toInt(),
      "OutgoingQty": outgoingQty?.toInt(),
      "IncomingQty": incomingQty?.toInt(),
      "CategId": categId,
      "Tracking": tracking,
      "SaleDelay": saleDelay?.toInt(),
      "CompanyId": companyId,
      "InvoicePolicy": invoicePolicy,
      "PurchaseMethod": purchaseMethod,
      "AvailableInPOS": availableInPOS,
      "ProductVariantCount": productVariantCount,
      "BOMCount": bOMCount,
      "IsCombo": isCombo,
      "EnableAll": enableAll,
      "VariantFistId": variantFistId,
      "DefaultCode": defaultCode,
      "Barcode": barcode,
      "IsAvailableOnTPage": isAvailableOnTPage,
      "UOMLines": uomLines != null ? uomLines.map((f) => f?.toJson(removeIfNull)).toList() : null,
      "AttributeLines": productAttributeLines?.map((f) => f?.toJson(removeIfNull))?.toList(),
      "AttributeValues": attributeValues?.map((f) => f?.toJson(removeIfNull))?.toList(),
      "PriceVariant": priceVariant?.toInt(),
      "IsDiscount": isDiscount,
      "NameTemplate": nameTemplate,
      "NameTemplateNoSign": nameTemplateNoSign,
      "LastUpdated": lastUpdated != null ? lastUpdated.toUtc().toIso8601String() : null,
      "DateCreated": dateCreated != null ? dateCreated.toUtc().toIso8601String() : null
    };
    // map['TaxesIds'] = <int>[];
    // map['NameCombos'] = <String>[];
    // map['ComboProducts'] = <ProductCombo>[];

    map.removeWhere((key, value) => value == null || value == "");

    return map;
  }
}
