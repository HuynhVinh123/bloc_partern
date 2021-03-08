import 'package:flutter/foundation.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/stock_change_product_quantity.dart';
import 'package:tpos_mobile/src/tpos_apis/models/stock_location.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/product_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/stock_change_product_qty_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/stock_location_api.dart';

class StockChangeProductQuantityViewModel extends ScopedViewModel {
  StockChangeProductQuantityViewModel({
    DialogService dialogService,
    IStockChangeProductQtyApi stockChangeProductQtyApi,
    ProductApi productApi,
    StockLocationApi stockLocationApi,
  }) {
    _dialog = dialogService ?? locator<DialogService>();
    _stockChangeProductQtyApi =
        stockChangeProductQtyApi ?? locator<IStockChangeProductQtyApi>();
    _productApi = productApi ?? locator<ProductApi>();
    _stockLocationApi = stockLocationApi ?? locator<StockLocationApi>();
  }
  //Param
  int _productTemplateId;
  DialogService _dialog;
  IStockChangeProductQtyApi _stockChangeProductQtyApi;

  ProductApi _productApi;
  StockLocationApi _stockLocationApi;

  StockChangeProductQuantity _model;
  List<StockLocation> _locations;
  List<Product> _products;

  StockChangeProductQuantity get model => _model;
  List<Product> get products => _products;
  List<StockLocation> get stockLocations => _locations;

  Product get selectedProduct =>
      _products?.firstWhere((f) => f.id == _model?.product?.id);

  StockLocation get selectedLocation =>
      _locations?.firstWhere((f) => f.id == _model?.location?.id);

  /// Param paser
  void init({@required int productTemplateId}) {
    _productTemplateId = productTemplateId;
    initData();
  }

  Future<void> initData() async {
    setBusy(true);
    try {
      await Future.wait([
        _getProducts(),
        _getStockLocations(),
        _getDefaultModel(),
      ]);
      notifyListeners();
    } catch (e, s) {
      logger.error("", e, s);
      _dialog.showError(error: e);
    }
    setBusy(false);
  }

  Future<void> _getDefaultModel() async {
    _model = await _stockChangeProductQtyApi.defaultGet(_productTemplateId);
  }

  Future<void> _getStockLocations() async {
    _locations = await _stockLocationApi.getAll();
  }

  Future<void> _getProducts() async {
    _products = await _productApi.getByTemplateId(_productTemplateId);
  }

  //  Thay đổi sản phẩm tải lại bảng giá
  Future<void> _onChangeProduct() async {
    final newModel =
        await _stockChangeProductQtyApi.getOnChangedProduct(_model);
    if (newModel != null) {
      _model = newModel;
    }

    notifyListeners();
  }

//  void tryOnChangeProduct() {
//    try {
//      _onChangeProduct
//    }
//    catch (e,s);
//  }

  Future<bool> save() async {
    bool isSuccess = false;
    setBusy(true);

    _model.locationId = _model.location?.id;
    _model.productId = _model.product?.id;
    _model.productTmplId = _model.productTmpl?.id;
    try {
      // Thêm
      final result = await _stockChangeProductQtyApi.insert(_model);
      _dialog.showNotify(message: "Đã thêm mới điều chỉnh tồn kho");
      // Xác nhận
      await _stockChangeProductQtyApi.changeProductQuantity(result.id);
      _dialog.showNotify(message: "Đã thay đổi tồn kho");
      isSuccess = true;
    } catch (e, s) {
      logger.error("", e, s);
      _dialog.showError(error: e);
    }
    setBusy(false);
    return isSuccess;
  }

  Future setProduct(Product product) async {
    _model.productId = product?.id;
    _model.product = product;
    notifyListeners();

    setBusy(true);
    await _onChangeProduct().catchError((e, s) {
      logger.error("", e, s);
      _dialog.showError(error: e);
    });
    setBusy(false);
  }

  void setStockLocation(StockLocation item) {
    _model.locationId = item.id;
    _model.location = item;
    notifyListeners();
  }
}
