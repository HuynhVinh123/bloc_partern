/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'productUOM.dart';
import 'product_attribute_line.dart';
import 'product_category.dart';
import 'product_uom_line.dart';

class Product {
  Product({
    this.uOMPO,
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
  });
  Product.fromJson(Map<String, dynamic> jsonMap) {
    List<ProductUOMLine> productUOMLines;
    var productUOMLinesMap = jsonMap["UOMLines"] as List;
    if (productUOMLines != null)
      productUOMLines = productUOMLinesMap.map((map) {
        return ProductUOMLine.fromJson(map);
      }).toList();
    uomLines = productUOMLines;
    uOM = jsonMap["UOM"] != null ? ProductUOM.fromJson(jsonMap["UOM"]) : null;
    categ = jsonMap["Categ"] != null
        ? ProductCategory.fromJson(jsonMap["Categ"])
        : null;
    uOMPO =
        jsonMap["UOMPO"] != null ? ProductUOM.fromJson(jsonMap["UOMPO"]) : null;

    List<ProductAttributeLine> attributeLines;
    var productAttributeLinesMap = jsonMap["AttributeLines"] as List;
    if (productAttributeLinesMap != null)
      attributeLines = productAttributeLinesMap.map((map) {
        return ProductAttributeLine.fromJson(map);
      }).toList();
    productAttributeLines = attributeLines;

    id = jsonMap["Id"];
    name = jsonMap["Name"];
    uOMId = jsonMap["UOMId"];
    uOMName = jsonMap["UOMName"];
    nameNoSign = jsonMap["NameNoSign"];
    nameGet = jsonMap["NameGet"];
    nameTemplate = jsonMap["NameTemplate"];
    price = jsonMap["Price"];
    oldPrice = jsonMap["OldPrice"];
    version = jsonMap["Version"];
    discountPurchase = (jsonMap["DiscountPurchase"] ?? 0).toDouble();
    weight = (jsonMap["Weight"] ?? 0).toDouble();
    discountSale = jsonMap["DiscountSale"];
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
    version = jsonMap["Version"];
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
  List<ProductAttributeLine> productAttributeLines;
  String barcode;

  double inventory;
  double focastInventory;

  Map<String, dynamic> toJson({bool removeIfNull = false}) {
    final map = {
      "UOM": uOM != null ? uOM.toJson() : null,
      "UOMPO": uOMPO != null ? uOMPO.toJson() : null,
      "Categ": categ != null ? categ.toJson() : null,
      "Id": this.id,
      "Name": this.name,
      "UOMId": this.uOMId,
      "UOMName": this.uOMName,
      "NameNoSign": this.nameNoSign,
      "NameGet": this.nameGet,
      "Price": this.price,
      "LstPrice": this.lstPrice,
      "OldPrice": this.oldPrice,
      "Version": this.version,
      "DiscountSale": this.discountSale,
      "DiscountPurchase": this.discountPurchase,
      "Weight": this.weight,
      "ProductTmplId": this.productTmplId,
      "Image": this.image,
      "ImageUrl": this.imageUrl,
      "Type": this.type,
      "ShowType": this.showType,
      "ListPrice": this.listPrice,
      "PurchasePrice": this.purchasePrice,
      "StandardPrice": this.standardPrice,
      "SaleOK": this.saleOK,
      "PurchaseOK": this.purchaseOK,
      "Active": this.active,
      "UOMPOId": this.uOMPOId,
      "IsProductVariant": this.isProductVariant,
      "QtyAvailable": this.qtyAvailable,
      "VirtualAvailable": this.virtualAvailable,
      "OutgoingQty": this.outgoingQty,
      "IncomingQty": this.incomingQty,
      "CategId": this.categId,
      "Tracking": this.tracking,
      "SaleDelay": this.saleDelay,
      "CompanyId": this.companyId,
      "InvoicePolicy": this.invoicePolicy,
      "PurchaseMethod": this.purchaseMethod,
      "AvailableInPOS": this.availableInPOS,
      "ProductVariantCount": this.productVariantCount,
      "BOMCount": this.bOMCount,
      "IsCombo": this.isCombo,
      "EnableAll": this.enableAll,
      "VariantFistId": this.variantFistId,
      "DefaultCode": this.defaultCode,
      "Barcode": this.barcode,
      "Version": this.version,
      "UOMLines": uomLines != null
          ? uomLines.map((f) => f.toJson(removeIfNull)).toList()
          : null,
      "AttributeLines": productAttributeLines != null
          ? productAttributeLines.map((f) => f.toJson(removeIfNull)).toList()
          : null,
    };

    map.removeWhere((key, value) => value == null || value == "");

    return map;
  }
}
