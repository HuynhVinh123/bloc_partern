/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:53 AM
 *
 */

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/helpers/helpers.dart';

import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/src/tpos_apis/models/product.dart';
import 'package:tpos_mobile/src/tpos_apis/models/productUOM.dart';
import 'package:tpos_mobile/src/tpos_apis/models/product_attribute_line.dart';
import 'package:tpos_mobile/src/tpos_apis/models/product_category.dart';
import 'package:tpos_mobile/src/tpos_apis/models/product_uom_line.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/product_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';

class ProductQuickAddEditViewModel extends ViewModel implements ViewModelBase {
  //log
  final _log = new Logger("ProductQuickAddEditViewModel");

  ITposApiService _tposApi;
  ProductApi _productApi;
  ProductQuickAddEditViewModel({
    ITposApiService tposApi,
    ProductApi productApi,
  }) {
    _tposApi = tposApi ?? locator<ITposApiService>();
    _productApi = productApi ?? locator<ProductApi>();
  }

  List<Map<String, dynamic>> sorts = [
    {"name": "Có thể lưu trữ"},
    {"name": "Có thể tiêu thụ"},
    {"name": "Dịch vụ"},
  ];
  String selectedProductType = "Có thể lưu trữ";

  // Product UOMLine
  List<ProductUOMLine> productUOMLines;

  // ProductAttribute
  List<ProductAttributeLine> productAttributes;

  // Product
  Product _product = new Product();

  Product get product => _product;
  set product(Product value) {
    _product = value;
    _productController.add(_product);
  }

  BehaviorSubject<Product> _productController = new BehaviorSubject();
  Stream<Product> get productStream => _productController.stream;

  void selectProductCategoryCommand(ProductCategory selectedCat) {
    product.categ = selectedCat;
    product.categId = selectedCat.id;
    onPropertyChanged("category");
  }

  void selectUomCommand(ProductUOM selectUom) {
    product.uOM = selectUom;
    product.uOMId = selectUom.id;
    product.uOMName = selectUom.name;
    onPropertyChanged("category");
  }

  void selectUomPCommand(ProductUOM selectUOMPO) {
    product.uOMPO = selectUOMPO;
    product.uOMPOId = selectUOMPO.id;
    onPropertyChanged("category");
  }

  // Load product
  Future<bool> loadProduct(int id) async {
    try {
      product = await _productApi.loadProduct(id);

      return true;
    } catch (ex, stack) {
      _log.severe("load fail", ex, stack);
      onDialogMessageAdd(
        (OldDialogMessage.error(
          "Load dữ liệu thất bại",
          ex.toString(),
        )),
      );
    }
    return false;
  }

  // Load product UOMLine
  Future<bool> loadProductUOMLine(int productId) async {
    try {
      productUOMLines = await _tposApi.getProductUOMLine(productId);

      return true;
    } catch (ex, stack) {
      _log.severe("load fail", ex, stack);
      onDialogMessageAdd(
        (OldDialogMessage.error(
          "Load dữ liệu thất bại",
          ex.toString(),
        )),
      );
    }
    return false;
  }

  // Load product UOMLine
  Future<bool> loadProductAttribute(int productId) async {
    try {
      productAttributes = await _tposApi.getProductAttribute(productId);

      return true;
    } catch (ex, stack) {
      _log.severe("load fail", ex, stack);
      onDialogMessageAdd(
        (OldDialogMessage.error(
          "Load dữ liệu thất bại",
          ex.toString(),
        )),
      );
    }
    return false;
  }

  static Future<String> convertImageBase64(File image) async {
    try {
      List<int> imageBytes = image.readAsBytesSync();
      return base64Encode(imageBytes);
    } catch (ex) {
      return null;
    }
  }

  // Add product
  Future<bool> save(File image) async {
    try {
      onIsBusyAdd(true);
      if (image != null) {
        product.image = await compute(convertImageBase64, image);
      }

//      product.showType = selectedProductType;
      if (selectedProductType == "Dịch vụ")
        product.type = "service";
      else if (selectedProductType == "Có thể tiêu thụ")
        product.type = "consu";
      else
        product.type = "product";
//      product.discountSale = 0;
//      product.discountPurchase = 0;
//      product.purchasePrice = 0;
      product.saleOK = true;
      product.purchaseOK = true;
      product.active = true;
//      product.isProductVariant = false;
      product.qtyAvailable = 0;
      product.virtualAvailable = 0;
//      product.outgoingQty = 0;
//      product.incomingQty = 0;
      //product.companyId = 5;
      product.saleDelay = 0;
      product.invoicePolicy = "order";
      product.purchaseMethod = "receive";
      product.availableInPOS = true;
//      product.productVariantCount = 0;
//      product.bOMCount = 0;
//      product.isCombo = false;
//      product.enableAll = true;
//      product.version = 559;
//      product.variantFistId = 0;
//      product.id = 0;
      if (product.weight == null) product.weight = 0;
      product.productTmplId = product.id;
      if (product.listPrice == null) product.listPrice = 0;
      if (product.standardPrice == null) product.standardPrice = 0;
      product.companyId = 1;

      if (product.id == null) {
        await _productApi.quickInsertProduct(product);
      } else {
        var result = await _productApi.editProduct(product);
        if (result.result == true) {
          onDialogMessageAdd(
              OldDialogMessage.flashMessage("Lưu sản phẩm thành công"));
          onIsBusyAdd(false);
        } else {
          onDialogMessageAdd(new OldDialogMessage.error("", result.message));
          onIsBusyAdd(false);
        }
      }

      // update cache product
//      _repo.cacheProducts = await _tposApi.getProducts();
      return true;
    } catch (ex, stack) {
      _log.severe("save fail", ex, stack);
      onDialogMessageAdd(
        (OldDialogMessage.error(
          "Lưu dữ liệu thất bại",
          ex.toString(),
        )),
      );
    }
    onIsBusyAdd(false);
    return false;
  }

  Future init() async {
    onIsBusyAdd(true);
    if (product.id != null) {
      await loadProductAttribute(product.id);
      await loadProduct(product.id);
      product.uOMId = product.uOM?.id;
      product.uOMPOId = product.uOMPO?.id;
      product.categId = product.categ?.id;
      selectedProductType = product.showType;
//      product.productAttributeLines = productAttributes;
//      print(product.productAttributeLines.length);
    } else {
      var categ = await _tposApi.getProductCategories();
      product.categ = categ.firstWhere((f) {
        return f.id == 1;
      });

      product.categId = product.categ?.id;
      var uOM = await _tposApi.getProductUOM();
      product.uOM = uOM.first;
      product.uOMId = product.uOM?.id;
//      product.uOMName = product.uOM.name;

      var uOMPO =
          await _tposApi.getProductUOM(uomCateogoryId: product.uOM.categoryId);
      if (uOMPO.isNotEmpty) {
        product.uOMPO = uOMPO.first;
        product.uOMPOId = product.uOMPO.id;
      }
    }
    onPropertyChanged("init");
    onIsBusyAdd(false);
  }

  @override
  void dispose() {
    _productController.close();
    super.dispose();
  }
}
