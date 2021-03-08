/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'dart:convert';

import 'package:tpos_api_client/src/model.dart';

import 'productUOM.dart';
import 'product_attribute.dart';
import 'product_category.dart';
import 'product_uom_line.dart';

class ProductTemplate {
  ProductTemplate(
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
      this.initInventory,
      this.virtualQuantity,
      this.availableQuantity,
      this.yearOfManufacture,
      this.tags,
      this.distributor,
      this.importer,
      this.producer});

  ProductTemplate.fromJson(Map<String, dynamic> jsonMap) {
    List<ProductUOMLine> productUOMLines;

    if (jsonMap["UOMLines"] != null)
      productUOMLines = (jsonMap["UOMLines"] as List).map((map) {
        return ProductUOMLine.fromJson(map);
      }).toList();
    uomLines = productUOMLines;
    uOM = jsonMap["UOM"] != null ? ProductUOM.fromJson(jsonMap["UOM"]) : null;
    categ = jsonMap["Categ"] != null ? ProductCategory.fromJson(jsonMap["Categ"]) : null;
    uOMPO = jsonMap["UOMPO"] != null ? ProductUOM.fromJson(jsonMap["UOMPO"]) : null;

    producer = jsonMap["Producer"] != null ? PartnerExt.fromJson(jsonMap["Producer"]) : null;
    importer = jsonMap["Importer"] != null ? PartnerExt.fromJson(jsonMap["Importer"]) : null;
    distributor = jsonMap["Distributor"] != null ? PartnerExt.fromJson(jsonMap["Distributor"]) : null;
    originCountry = jsonMap["OriginCountry"] != null ? OriginCountry.fromJson(jsonMap["OriginCountry"]) : null;
    List<ProductAttribute> attributeLines = [];
    List<ProductImage> productImages = [];

    if (jsonMap["Images"] != null)
      productImages = (jsonMap["Images"] as List).map((map) {
        return ProductImage.fromJson(map);
      }).toList();

    images = productImages;

    if (jsonMap["AttributeLines"] != null)
      attributeLines = (jsonMap["AttributeLines"] as List).map((map) {
        return ProductAttribute.fromJson(map);
      }).toList();
    productAttributeLines = attributeLines;

    id = jsonMap["Id"];
    distributorId = jsonMap["DistributorId"];
    distributorName = jsonMap["DistributorName"];
    importerId = jsonMap["ImporterId"];
    importerName = jsonMap["ImporterName"];
    producerId = jsonMap["ProducerId"];
    producerName = jsonMap["ProducerName"];
    originCountryId = jsonMap["OriginCountryId"];
    originCountryName = jsonMap["OriginCountryName"];
    name = jsonMap["Name"];
    uOMId = jsonMap["UOMId"];
    uOMName = jsonMap["UOMName"];
    categName = jsonMap["CategName"];
    uOMPOName = jsonMap["UOMPOName"];
    nameNoSign = jsonMap["NameNoSign"];
    nameGet = jsonMap["NameGet"];
    price = jsonMap["Price"];
    oldPrice = jsonMap["OldPrice"];
    version = jsonMap["Version"];
    discountPurchase = (jsonMap["DiscountPurchase"] ?? 0).toDouble();
    volume = (jsonMap["Volume"] ?? 0).toDouble();
    weight = (jsonMap["Weight"] ?? 0).toDouble();
    yearOfManufacture = jsonMap["YearOfManufacture"] ?? 0;
    discountSale = jsonMap["DiscountSale"]?.toDouble();
    productTmplId = jsonMap["ProductTmplId"];
    image = jsonMap["Image"];
    imageUrl = jsonMap["ImageUrl"];

    type = jsonMap["Type"];
    showType = jsonMap["ShowType"];
    listPrice = (jsonMap["ListPrice"] ?? 0).toDouble();
    purchasePrice = jsonMap["PurchasePrice"]?.toDouble();
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
    initInventory = jsonMap["InitInventory"]?.toDouble();
    availableQuantity = jsonMap["QtyAvailable"]?.toDouble();
    virtualQuantity = jsonMap["VirtualAvailable"]?.toDouble();
    element = jsonMap["Element"];
    specifications = jsonMap["Specifications"];
    infoWarning = jsonMap["InfoWarning"];
    description = jsonMap["Description"];
    dateCreated = jsonMap["DateCreated"] != null ? DateTime.tryParse(jsonMap["DateCreated"]) : null;
    tags = <Tag>[];
    if (jsonMap['Tags'] != null) {
      final dynamic decode = json.decode(jsonMap['Tags']);
      tags = (decode as List).map((dynamic tag) => Tag.fromJson(tag)).toList();
    }
    if (jsonMap['ProductVariants'] != null) {
      productVariants = (jsonMap['ProductVariants'] as List).map((dynamic product) => Product.fromJson(product)).toList();
    }

    if (imageUrl == null || imageUrl == '') {
      image = null;
    }
  }

  Map<String, dynamic> toJson({bool removeIfNull = false}) {
    final Map<String, dynamic> map = {
      "UOM": uOM?.toJson(removeIfNull),
      "UOMPO": uOMPO?.toJson(removeIfNull),
      "Categ": categ?.toJson(removeIfNull),
      "Producer": producer?.toJson(removeIfNull),
      "Importer": importer?.toJson(removeIfNull),
      "Distributor": distributor?.toJson(removeIfNull),
      "OriginCountry": originCountry?.toJson(removeIfNull),
      "Id": id,
      "DistributorId": distributorId,
      "ImporterId": importerId,
      "ProducerId": producerId,
      "OriginCountryId": originCountryId,
      "Element": element,
      "Specifications": specifications,
      "InfoWarning": infoWarning,
      "Description": description,
      "YearOfManufacture": yearOfManufacture,
      "Name": name,
      "UOMId": uOM != null ? uOM.id : null,
      "UOMName": uOMName,
      "NameNoSign": nameNoSign,
      "NameGet": nameGet,
      "Price": price,
      "OldPrice": oldPrice,
      "DiscountSale": discountSale,
      "DiscountPurchase": discountPurchase,
      "Weight": weight,
      "ProductTmplId": productTmplId,
      "Image": image,
      "ImageUrl": imageUrl,
      "Type": type,
      "ShowType": showType,
      "ListPrice": listPrice,
      "PurchasePrice": purchasePrice,
      "StandardPrice": standardPrice,
      "SaleOK": saleOK,
      "PurchaseOK": purchaseOK,
      "Active": active,
      "UOMPOId": uOMPO != null ? uOMPO.id : null,
      "IsProductVariant": isProductVariant,
      "QtyAvailable": qtyAvailable,
      "VirtualAvailable": virtualAvailable,
      "OutgoingQty": outgoingQty,
      "IncomingQty": incomingQty,
      "CategId": categ != null ? categ.id : null,
      "Tracking": tracking,
      "SaleDelay": saleDelay,
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
      "Version": version??0,
      "Volume": volume,
      "InitInventory": initInventory,
      "DateCreated": dateCreated != null ? dateCreated.toIso8601String() : null,
      "UOMLines": uomLines != null ? uomLines.map((f) => f.toJson(removeIfNull)).toList() : [],
      "AttributeLines": productAttributeLines != null ? productAttributeLines.map((f) => f.toJson(removeIfNull)).toList() : [],
      "Images": images != null ? images.map((f) => f.toJson(removeIfNull)).toList() : [],
      'Tags': tags != null ? tags.map((f) => f.toJson()).toList() : null,
    };

    map['Items'] = [];
    map['ProductSupplierInfos'] = [];
    map['ComboProducts'] = [];

    if (tags != null && tags.isEmpty) {
      map['Tags'] = null;
    }
    if (removeIfNull) {
      map.removeWhere((key, value) => value == null || value == "");
    }

    return map;
  }

  int id, uOMId, version, productTmplId;
  double price, oldPrice, discountPurchase, discountSale;
  String name,
      uOMName,
      nameGet,
      nameNoSign,
      uOMPOName,
      categName,
      producerName,
      importerName,
      distributorName,
      originCountryName;

  String image, imageUrl;
  String defaultCode;
  double weight;

  String type;
  String showType;
  double listPrice;
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
  List<ProductAttribute> productAttributeLines;
  String barcode;
  List<Tag> tags;
  List<Product> productVariants;

  /// Tồn kho đầu kỳ
  double initInventory;

  double availableQuantity;
  double virtualQuantity;
  double volume;

  PartnerExt producer;
  PartnerExt importer;
  PartnerExt distributor;
  OriginCountry originCountry;
  int distributorId;
  int importerId;
  int producerId;
  int originCountryId;
  int yearOfManufacture;
  String element;
  String specifications;
  String infoWarning;
  String description;
  DateTime dateCreated;
  List<ProductImage> images;

  ///dùng dể lưu lại bytes của base64
  List<int> imageBytes;
}
