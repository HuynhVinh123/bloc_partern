import 'dart:async';

import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class ProductCategoryAddEditViewModel extends ScopedViewModel {
  ProductCategoryAddEditViewModel({ITposApiService tposApi}) {
    _tposApi = tposApi ?? locator<ITposApiService>();
  }
  final _log = Logger("ProductCategoryAddEditViewModel");
  ITposApiService _tposApi;

  List<Map<String, dynamic>> sorts = [
    {"name": "Giá cố định"},
    {"name": "Nhập trước xuất trước"},
    {"name": "Bình quân giá quyền"},
  ];
  String selectedPrice = "Giá cố định";

  // Product Category Command
  void selectProductCategoryCommand(ProductCategory selectedCat) {
    productCategory.parent = selectedCat;
    productCategory.parentId = selectedCat.id;
    onPropertyChanged("category");
  }

  // Active check
  bool isActive = true;
  void isCheckActive(bool value) {
    isActive = value;
    onPropertyChanged("isCheckActive");
  }

  // Số thứ tự
  int _ordinalNumber = 1;
  int get ordinalNumber => _ordinalNumber;

  final BehaviorSubject<int> _ordinalNumberController = BehaviorSubject();
  Stream<int> get productCategoryQuantityStream =>
      _ordinalNumberController.stream;
  set ordinalNumber(int value) {
    _ordinalNumber = value;
    _ordinalNumberController.add(value);
  }

  // Product Category
  ProductCategory _productCategory = ProductCategory();
  ProductCategory get productCategory => _productCategory;
  set productCategory(ProductCategory value) {
    _productCategory = value;
    _productCategoryController.add(_productCategory);
  }

  final BehaviorSubject<ProductCategory> _productCategoryController =
      BehaviorSubject();
  Stream<ProductCategory> get productCategoryStream =>
      _productCategoryController.stream;

  // Load Product Category
  Future<bool> loadProductCategory(int id) async {
    try {
      setBusy(true, message: S.current.loading);
      final getResult = await _tposApi.getProductCategory(id);
      if (getResult.error == null) {
        _productCategory = getResult.value;
        if (_productCategoryController.isClosed == false)
          _productCategoryController.add(_productCategory);
      } else {
        onDialogMessageAdd(
            OldDialogMessage.flashMessage(getResult.error.message));
      }
      return true;
    } catch (ex, stack) {
      _log.severe("Load fail", ex, stack);
      onDialogMessageAdd(OldDialogMessage.error(
        S.current.loadFailed,
        ex.toString(),
      ));
    }
    setBusy(false);
    return false;
  }

  // Save Product Category
  Future<bool> save() async {
    try {
      setBusy(true, message: S.current.saving);
      if (selectedPrice == "Giá cố định")
        productCategory.propertyCostMethod = "standard";
      else if (selectedPrice == "Nhập trước xuất trước")
        productCategory.type = "average";
      else
        productCategory.type = "fifo";

      productCategory.isPos = isActive;
      productCategory.sequence = ordinalNumber;
      productCategory.version = 570;

      if (productCategory.id == null) {
        await _tposApi.insertProductCategory(productCategory);
        setBusy(false);
      } else {
        final result = await _tposApi.editProductCategory(productCategory);
        if (result.result == true) {
          onDialogMessageAdd(OldDialogMessage.flashMessage(S.current.success));
          setBusy(false);
        } else {
          onDialogMessageAdd(OldDialogMessage.error("", result.message));
          setBusy(false);
        }
      }
      return true;
    } catch (ex, stack) {
      _log.severe("save fail", ex, stack);
      onDialogMessageAdd(
        OldDialogMessage.error(
          S.current.saveFailed,
          ex.toString(),
        ),
      );
    }
    setBusy(false);
    return false;
  }

  Future<void> init() async {
    setBusy(true, message: S.current.loading);
    if (productCategory.id != null) {
      await loadProductCategory(productCategory.id);
      if (productCategory.isPos != null) isActive = productCategory.isPos;
      if (productCategory.sequence != null)
        ordinalNumber = productCategory.sequence;
    }
    onPropertyChanged("init");
    setBusy(false);
  }

  @override
  void dispose() {
    _productCategoryController.close();
    _ordinalNumberController.close();
    super.dispose();
  }
}
