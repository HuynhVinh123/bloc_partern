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
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/resources/permission.dart';
import 'package:tpos_mobile/services/cache_service.dart';
import 'package:tpos_mobile/services/dialog_service.dart';

import 'package:tpos_mobile/src/tpos_apis/services/object_apis/product_template_api.dart' as old;
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';

class ProductTemplateQuickAddEditViewModel extends ViewModel
    implements ViewModelBase {
  //log
  final _log = new Logger("ProductQuickAddEditViewModel");

  ITposApiService _tposApi;
  old.ProductTemplateApi _productTemplateApi;
  DialogService _dialogSerivce;
  CacheService _cacheService;
  //ApplicationViewModel _application;

  ProductTemplateQuickAddEditViewModel(
      {ITposApiService tposApi,
        old.ProductTemplateApi productTemplateApi,
      DialogService dialogService,
      CacheService cacheService}) {
    _tposApi = tposApi ?? locator<ITposApiService>();
    _productTemplateApi = productTemplateApi ?? locator<old.ProductTemplateApi>();
    _dialogSerivce = dialogService ?? locator<DialogService>();
    _cacheService = cacheService ?? GetIt.instance<CacheService>();
    //_application = locator<ApplicationViewModel>();
  }

  /// Các option để cấu hình sản phẩm
  bool isSaleOK = true;
  bool isPurchaseOK = true;
  bool isCombo = false;
  bool isAvailableInPOS = true;
  bool isEnableAll = true;

  // bool get permissionStandartPrice => _application.userFieldPermission
  //     ?.contains(PERMISSION_PRODUCT_TEMPLATE_STANDART_PRICE);
  //
  // bool get permissionPrice => _application.userFieldPermission
  //     ?.contains(PERMISSION_PRODUCT_TEMPLATE_PRICE);

  bool get permissionStandartPrice => _cacheService.fields.any(
      (element) => element == PermissionField.productTemplate_standardPrice);

  bool get permissionPrice => _cacheService.fields
      .any((element) => element == PermissionField.productTemplate_Price);

  List<Map<String, dynamic>> sorts = [
    {"name": "Có thể lưu trữ"},
    {"name": "Có thể tiêu thụ"},
    {"name": "Dịch vụ"},
  ];
  String selectedProductType = "Có thể lưu trữ";
  int indexEdit = -1;

  ProductAttributeValue _productAttribute = ProductAttributeValue();
  ProductAttributeValue get productAttribute => _productAttribute;
  set productAttribute(ProductAttributeValue value) {
    _productAttribute = value;
    _productAttributeController.add(value);
  }

  List<ProductAttributeValue> _prdAttributes = [];
  List<ProductAttributeValue> _productAttributeValuess = [];
  List<ProductAttributeValue> get productAttributeValues => _productAttributeValuess;

  set productAttributeValuess(ProductAttributeValue value) {
    bool _checkValue = false;
    for (var i = 0; i < _productAttributeValuess.length; i++) {
      if (_productAttributeValuess[i].id == value.id) {
        _checkValue = true;
        break;
      }
    }
    if (!_checkValue) {
      _productAttributeValuess.add(value);
    }

    _productAttributeValuesController.add(_productAttributeValuess);
  }

  void deleteProductAttributeValue(ProductAttributeValue value) {
    _productAttributeValuess.remove(value);
    _productAttributeValuesController.add(_productAttributeValuess);
  }

  void deleteAllAttributeValue() {
    _productAttributeValuess = List();
    _productAttributeValuess.clear();
    _productAttributeValuesController.add(_productAttributeValuess);
  }

  void addAllAttributeValue(List<ProductAttributeValue> values) {
    _productAttributeValuess = List();
    _productAttributeValuess = values;
    _productAttributeValuesController.add(_productAttributeValuess);
  }

  void removeAttribute(ProductAttribute value) {
    productAttributes.remove(value);
    _productAttributeListController.add(productAttributes);
  }

  // Product UOMLine
  List<ProductUOMLine> productUOMLines;

  // ProductAttribute
  List<ProductAttribute> productAttributes;

  // Product
  ProductTemplate _product = new ProductTemplate();

  ProductTemplate get product => _product;
  set product(ProductTemplate value) {
    _product = value;
    _productController.add(_product);
  }

  void editBienThe() {
    productAttributes[indexEdit].productAttribute = _productAttribute;
    productAttributes[indexEdit].attributeValues = _productAttributeValuess;
    _productAttributeListController.add(productAttributes);
    _productAttributeValuess = List();
    deleteAllAttributeValue();
    productAttribute = ProductAttributeValue(name: null);
  }

  void addBienThe() async {
    List<ProductAttributeValue> lstAttb = List();
    lstAttb = _productAttributeValuess;

    ProductAttribute productAttributeLine = ProductAttribute();
    productAttributeLine.productAttribute = _productAttribute;
    productAttributeLine.attributeValues = lstAttb;
    productAttributeLine.attributeId = _productAttribute.id;
    productAttributes.add(productAttributeLine);
    _productAttributeListController.add(productAttributes);
    _productAttributeValuess = List();
    deleteAllAttributeValue();
    productAttribute = ProductAttributeValue(name: null);
  }

  void cancelAddEdit() {
    _productAttributeValuess = List();
    deleteAllAttributeValue();
    productAttribute = ProductAttributeValue(name: null);
  }

  BehaviorSubject<List<ProductAttribute>> _productAttributeListController =
      new BehaviorSubject();
  Stream<List<ProductAttribute>> get productAttributeListStream =>
      _productAttributeListController.stream;

  BehaviorSubject<List<ProductAttributeValue>> _productAttributeValuesController =
      new BehaviorSubject();
  Stream<List<ProductAttributeValue>> get productAttributeValuesStream =>
      _productAttributeValuesController.stream;

  BehaviorSubject<ProductAttributeValue> _productAttributeController =
      new BehaviorSubject();
  Stream<ProductAttributeValue> get productAttributeStream =>
      _productAttributeController.stream;

  BehaviorSubject<ProductTemplate> _productController = new BehaviorSubject();
  Stream<ProductTemplate> get productStream => _productController.stream;

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
      product = await _productTemplateApi.loadProductTemplate(id);
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
      final List<int> imageBytes = image.readAsBytesSync();
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

      product.showType = selectedProductType;
      if (selectedProductType == "Dịch vụ")
        product.type = "service";
      else if (selectedProductType == "Có thể tiêu thụ")
        product.type = "consu";
      else
        product.type = "product";
      product.discountSale = 0;
      product.discountPurchase = 0;
      product.saleOK = isSaleOK;
      product.purchaseOK = isPurchaseOK;
      product.isProductVariant = false;
      product.qtyAvailable = 0;
      product.virtualAvailable = 0;
      product.outgoingQty = 0;
      product.incomingQty = 0;
      //product.companyId = 5;
      product.saleDelay = 0;
      product.invoicePolicy = "order";
      product.purchaseMethod = "receive";
      product.availableInPOS = isAvailableInPOS;
      product.productVariantCount = 0;
      product.bOMCount = 0;
      product.isCombo = isCombo;
      product.enableAll = isEnableAll;
      //product.Version = 545;
      product.variantFistId = 0;
      product.productAttributeLines = productAttributes;

      if (product.id == null) {
        await _productTemplateApi.quickInsertProductTemplate(product);
      } else {
        var result = await _productTemplateApi.editProductTemplate(product);
        if (result.result == true) {
          _dialogSerivce.showNotify(message: 'Lưu sản phẩm thành công');
          onIsBusyAdd(false);
        } else {
          _dialogSerivce.showError(error: "Lưu sản phẩm thất bại");
          onIsBusyAdd(false);
        }
      }
      return true;
    } catch (ex, stack) {
      _log.severe("save fail", ex, stack);
      _dialogSerivce.showError(error: ex);
    }
    onIsBusyAdd(false);
    return false;
  }

  Future init() async {
    onIsBusyAdd(true);
    if (product.id != null) {
      await loadProductUOMLine(product.id);
      await loadProductAttribute(product.id);
      await loadProduct(product.id);
      selectedProductType = product.showType;
      product.uomLines = productUOMLines;
      product.productAttributeLines = productAttributes;
      print(product.productAttributeLines.length);
    } else {
      var categ = await _tposApi.getProductCategories();
      product.categ = categ?.first;

      product.categId = product.categ?.id;
      var uOM = await _tposApi.getProductUOM();
      product.uOM = uOM.first;
      product.uOMId = product.uOM.id;
      product.uOMName = product.uOM.name;

      final uOMPO =
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
    _productAttributeListController.close();
    _productAttributeValuesController.close();
    _productAttributeController.close();
    super.dispose();
  }
}
