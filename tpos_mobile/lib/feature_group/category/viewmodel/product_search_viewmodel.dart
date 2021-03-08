import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tmt_flutter_untils/sources/string_utils/string_utils.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/cache_service/cache_service.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/services/log_services/log_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/pos_sales_count_dict.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/product_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class ProductSearchViewModel extends ScopedViewModel {
  ProductSearchViewModel(
      {ITposApiService tposApiService,
      DialogService dialog,
      ProductApi productApi,
      LogService log,
      CacheService cacheService})
      : super(logService: log) {
    _tposApi = tposApiService ?? locator<ITposApiService>();
    _dialog = dialog ?? locator<DialogService>();
    _productApi = productApi ?? locator<ProductApi>();
    _cacheService = cacheService ?? GetIt.instance<CacheService>();

    /// Listen keyword change
    _keywordSubject.stream
        .debounceTime(
      const Duration(milliseconds: 400),
    )
        .listen((keyword) {
      _onSearch(keyword);
    });
  }

  ITposApiService _tposApi;
  DialogService _dialog;
  ProductApi _productApi;

  void init({ProductPrice priceList}) {
    _priceList = priceList;
    _productCategory = ProductCategory();
    setBusy(false);
  }

  int filterStack = 0;
  ProductCategory _productCategory;
  String _keyword;
  List<Product> _products;
  Map<String, dynamic> _inventoryMap;
  Map<String, dynamic> _priceListMap;
  final BehaviorSubject<String> _keywordSubject = BehaviorSubject<String>();
  ProductPrice _priceList;
  bool _isListMode = true;
  CacheService _cacheService;

  List<Product> _productDefaults = <Product>[];
  List<Product> get products => _products;
  int get productCount => _products?.length ?? 0;
  Sink<String> get keywordSink => _keywordSubject.sink;

  String get keyword => _keyword;
  String get priceListName => _priceList?.name ?? "Giá cố định";
  bool get isListMode => _isListMode;

  ProductCategory get productCategory => _productCategory;
  set productCategory(ProductCategory value) {
    _productCategory = value;
    notifyListeners();
  }

  set isListMode(bool value) {
    _isListMode = value;
    notifyListeners();
  }

  void changePositionStack(int value) {
    filterStack = value;
    notifyListeners();
  }

  Future<void> handleFilter() async {
    if (filterStack == 1) {
      // bán chạy
      filterSaleCount();
    } else if (filterStack == 2) {
      // theo mã
      filterDefaultCode();
    } else if (filterStack == 3) {
      // theo tên
      filterName();
    } else if (filterStack == 5) {
      filterNew(false);
    } else {
      // mới nhất
      filterNew();
    }
    _productDefaults = _products;
  }

  void filterSaleCount() {
    List<Product> _stackProducts = [];
    _stackProducts = _productDefaults;
    _stackProducts.sort((a, b) => a.posSalesCount.compareTo(b.posSalesCount));
    _products = List.from(_stackProducts.reversed);
    notifyListeners();
  }

  void filterName() {
    List<Product> _stackProducts = [];
    _stackProducts = _productDefaults;
    _stackProducts
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    _products = _stackProducts;
    notifyListeners();
  }

  void filterDefaultCode() {
    List<Product> _stackProducts = [];
    _stackProducts = _productDefaults;
    _stackProducts.sort((a, b) => (a.defaultCode ?? "")
        .toLowerCase()
        .compareTo((b.defaultCode ?? "").toLowerCase()));

    _products = _stackProducts;
    notifyListeners();
  }

  void filterNew([bool isNew = true]) {
    List<Product> _stackProducts = [];
    _stackProducts = _productDefaults;
    _stackProducts.sort((a, b) {
      return b.id - a.id;
    });

    _products = _stackProducts;

    if (!isNew) {
      _products = List.from(_products.reversed);
    }
    notifyListeners();
  }

  void resetFilter() {
    filterStack = 1;
    handleFilter();
    notifyListeners();
  }

  void _onSearch(String keyWord) {
    setBusy(true);
    final List<Product> _productsSearch = <Product>[];
    final String keywordNoSign =
        StringUtils.removeVietnameseMark(keyWord ?? "").toLowerCase();
    // ignore: avoid_function_literals_in_foreach_calls
    _productDefaults.forEach((product) {
      if ((product.defaultCode != null &&
              StringUtils.removeVietnameseMark(product.defaultCode)
                  .toLowerCase()
                  .contains(keywordNoSign)) ||
          (product.nameNoSign != null &&
              StringUtils.removeVietnameseMark(product.nameNoSign)
                  .toLowerCase()
                  .contains(keywordNoSign)) ||
          (product.barcode != null &&
              StringUtils.removeVietnameseMark(product.barcode)
                  .toLowerCase()
                  .contains(keywordNoSign))) {
        _productsSearch.add(product);
      }
    });
    _products = <Product>[];
    _products.addAll(_productsSearch);
    notifyListeners();
    setBusy(false);
  }

  Future getProducts() async {
    setBusy(true);
    try {
      if (_cacheService.getProducts.isEmpty) {
        final result = await _productApi.productSearch("");
        final List<PosSalesCountDict> posSaleCounts =
            await _productApi.getPosSalesCountDict();
        _products = result.result;

        /// Cập nhật giá trị tồn kho số lượng sản phẩm đã bán để filter bán hàng
        ///  // ignore: avoid_function_literals_in_foreach_calls
        _products?.forEach((f) {
          if (_inventoryMap != null) {
            f.inventory = _inventoryMap[f.id.toString()] != null
                ? _inventoryMap[f.id.toString()]["QtyAvailable"]?.toDouble()
                : 0;
            f.focastInventory = _inventoryMap[f.id.toString()] != null
                ? _inventoryMap[f.id.toString()]["VirtualAvailable"]?.toDouble()
                : 0;
            if (posSaleCounts != null && posSaleCounts.isNotEmpty) {
              final int position = posSaleCounts
                  .indexWhere((element) => f.id.toString() == element.key);
              f.posSalesCount =
                  position != -1 ? posSaleCounts[position].value : 0;
            }
          }
        });
        _cacheService.setProducts = _products;
        _productDefaults = _products;
        // Map to inventory
      } else {
        _products = <Product>[];
        // ignore: avoid_function_literals_in_foreach_calls
        _cacheService.getProducts.forEach((item) {
          final Product productItem = Product.copyWith(item);
          _products.add(productItem);
        });

        /// Khởi tạo lại bảng giá cho danh sách sản phẩm
        // Map to inventory
        // ignore: avoid_function_literals_in_foreach_calls
        _products?.forEach((f) {
          if (_priceListMap != null) {
            f.price = _priceListMap["${f.productTmplId}_${f.uOMId}"] ?? f.price;
          }
        });

        _productDefaults = _products;
      }
      notifyListeners();
    } catch (e, s) {
      logger.error("", e, s);
      _dialog.showError(content: e.toString());
    }
    setBusy(false);
  }

  Future refreshPriceList() async {
    if (_priceList == null) return;
    try {
      _priceListMap = await _tposApi.getPriceListItems(_priceList?.id);
    } catch (e, s) {
      logger.error("refresh pricelist", e, s);
      _dialog.showNotify(message: S.current.searchProduct_cannotGetPriceList);
    }
  }

  Future<void> refreshInventory() async {
    try {
      _inventoryMap = await _tposApi.getProductInventory();
    } catch (e, s) {
      logger.error("refresh inventory", e, s);
      _dialog.showNotify(message: S.current.searchProduct_cannotGetInventory);
    }
  }

  Future<void> initData([bool isRefresh = false]) async {
    if (!isRefresh) {
      await refreshPriceList();
      if (_inventoryMap == null) {
        await refreshInventory();
      }
    }
    await getProducts();
  }

  Future<void> refreshData() async {
    _cacheService.clearProducts();
    await getProducts();
    initData(true);
  }
}
