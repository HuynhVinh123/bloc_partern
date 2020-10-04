import 'package:tmt_flutter_untils/sources/string_utils/string_utils.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/services/log_services/log_service.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/product_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_models.dart';
import 'package:rxdart/rxdart.dart';

class ProductSearchViewModel extends ViewModel {
  ITposApiService _tposApi;
  DialogService _dialog;
  ProductApi _productApi;
  ProductSearchViewModel(
      {ITposApiService tposApiService,
      DialogService dialog,
      ProductApi productApi,
      LogService log})
      : super(logService: log) {
    _tposApi = tposApiService ?? locator<ITposApiService>();
    _dialog = dialog ?? locator<DialogService>();
    _productApi = productApi ?? locator<ProductApi>();

    /// Listen keyword change
    _keywordSubject.stream
        .debounceTime(
      const Duration(milliseconds: 400),
    )
        .listen((keyword) {
      if (_keyword != keyword) {
        _onSearching(keyword);
        print('tìm');
      }
    });
  }

  void init({ProductPrice priceList}) {
    _priceList = priceList;
    onStateAdd(false);
  }

  String _keyword;
  List<Product> _products;
  Map<String, dynamic> _inventoryMap;
  Map<String, dynamic> _priceListMap;
  final BehaviorSubject<String> _keywordSubject = BehaviorSubject<String>();
  ProductPrice _priceList;
  bool _isListMode = true;

  List<Product> get products => _products;
  int get productCount => _products?.length ?? 0;
  Sink<String> get keywordSink => _keywordSubject.sink;

  String get keyword => _keyword;
  String get priceListName => _priceList?.name ?? "Giá cố định";
  bool get isListMode => _isListMode;

  set isListMode(bool value) {
    _isListMode = value;
    notifyListeners();
  }

  Future _onSearching(String keyword) async {
    _keyword = keyword;
    onStateAdd(true);
    String keywordNoSign = StringUtils.removeVietnameseMark(keyword ?? "").toLowerCase();
    try {
      var result = await _productApi.productSearch(keywordNoSign, top: 100);
      _products = result.result;
      // Map to inventory
      _products?.forEach((f) {
        if (_inventoryMap != null) {
          f.inventory = (_inventoryMap[f.id.toString()] != null
              ? _inventoryMap[f.id.toString()]["QtyAvailable"]?.toDouble()
              : 0);
          f.focastInventory = (_inventoryMap[f.id.toString()] != null
              ? _inventoryMap[f.id.toString()]["VirtualAvailable"]?.toDouble()
              : 0);
        }

        if (_priceListMap != null) {
          f.price = _priceListMap["${f.id}_${f.uOMId}"] ?? f.price;
        }
      });
      notifyListeners();
    } catch (e, s) {
      logger.error("", e, s);
      _dialog.showError(content: e.toString());
    }
    onStateAdd(false);
  }

  Future refreshPriceList() async {
    if (_priceList == null) return;
    try {
      _priceListMap = await _tposApi.getPriceListItems(_priceList?.id);
    } catch (e, s) {
      logger.error("refresh pricelist", e, s);
      _dialog.showNotify(message: "Không thể lấy bảng giá");
    }
  }

  Future<void> refreshInventory() async {
    try {
      _inventoryMap = await _tposApi.getProductInventory();
    } catch (e, s) {
      logger.error("refresh inventory", e, s);
      _dialog.showNotify(message: "Không thể lấy thông tin tồn kho");
    }
  }

  Future<void> initData() async {
    await this.refreshPriceList();
    if (_inventoryMap == null) {
      await this.refreshInventory();
    }
  }
}
