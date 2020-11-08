/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:tmt_flutter_untils/sources/string_utils/string_utils.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/tpos_service/odata_filter.dart';
import 'package:tpos_mobile/services/app_setting_service.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/services/log_services/log_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/base_list_order_by_type.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/product_template_api.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_api.dart';

class ProductTemplateSearchViewModel extends ViewModel {
  ProductTemplateSearchViewModel(
      {ISettingService settingService,
      DialogService dialog,
      PriceListApi priceListApi,
      ProductTemplateApi productTemplateApi,
      LogService logService})
      : super(logService: logService) {
    _settingService = settingService ?? locator<ISettingService>();
    _dialog = dialog ?? locator<DialogService>();
    _productTemplateApi = productTemplateApi ?? locator<ProductTemplateApi>();
    _priceListApi = priceListApi ?? GetIt.I<PriceListApi>();
    // _applicationVM = locator<ApplicationViewModel>();
    // Listen keyword changing
    _keywordController
        .debounceTime(const Duration(milliseconds: 500))
        .listen((newKeyword) {
      loadProduct(isBarcode: isBarcode, isLoadMore: false);
    });

    try {
      _selectedOrderBy =
          BaseListOrderBy.values[_settingService.productSearchOrderByIndex];
    } catch (e) {
      _selectedOrderBy = BaseListOrderBy.NAME_ASC;
    }
  }
  ISettingService _settingService;
  //ApplicationViewModel _applicationVM;
  ProductTemplateApi _productTemplateApi;
  PriceListApi _priceListApi;
  DialogService _dialog;

/*  ĐIỀU KIỆN LỌC*/

  bool _isFilterByPriceList = false;
  bool _isFilterByCategory = false;
  ProductPrice _filterProductPrice;
  List<ProductCategory> _filterProductCategories = <ProductCategory>[];
  List<ProductPrice> _productPriceList;

  bool get isFilterByPriceList => _isFilterByPriceList;
  bool get isFilterByCategory => _isFilterByCategory;
  ProductPrice get filterProductPrice => _filterProductPrice;
  List<ProductCategory> get filterProductCategories => _filterProductCategories;
  List<ProductPrice> get productPriceList => _productPriceList;
  int get filterCount {
    int count = 0;
    if (_isFilterByCategory) {
      count += 1;
    }
    if (_isFilterByPriceList) {
      count += 1;
    }
    return count;
  }

  set isFilterByPriceList(bool value) {
    _isFilterByPriceList = value;
    notifyListeners();
  }

  set isFilterByCategory(bool value) {
    _isFilterByCategory = value;
    notifyListeners();
  }

  set filterProductPrice(ProductPrice value) {
    _filterProductPrice = value;
    notifyListeners();
  }

  set filterProductCategory(List<ProductCategory> value) {
    _filterProductCategories = value;
    notifyListeners();
  }

  void addFilterCategory(ProductCategory value) {
    if (_filterProductCategories.any((f) => f.id == value.id)) {
      _dialog.showNotify(message: "${value.name} đã có trong danh sách");
      return;
    }

    _filterProductCategories.add(value);
    notifyListeners();
  }

  void deleteFilterCategory(ProductCategory value) {
    if (_filterProductCategories.any((f) => f.id == value.id)) {
      _filterProductCategories.remove(value);
      notifyListeners();
    }
  }

  Future fetchProductPriceLists() async {
    try {
      final result =
          await _priceListApi.getPriceListAvailable(data: DateTime.now());
      _productPriceList = result.value;
      notifyListeners();
    } catch (e, s) {
      logger.error("", e, s);
      _dialog.showNotify(
          type: DialogType.NOTIFY_ERROR,
          message: "Không tải được bảng giá : ${e.toString()}");
    }
  }
  /* HẾT  ĐIỀU KIỆN LỌC*/

  bool _isLoaddingMore = false;
  bool get isLoadingMore => _isLoaddingMore;

  //bool get canAdd => _applicationVM.checkPermission(permissonInsertName);
  //bool get canUpdate => _applicationVM.checkPermission(permissonUpdateName);
  //bool get canDelete => _applicationVM.checkPermission(permissionDeleteName);

  /* FILTER */

  BaseListOrderBy _selectedOrderBy;
  BaseListOrderBy get selectedOrderBy => _selectedOrderBy;
  final Map<BaseListOrderBy, String> _orderByList = {
    BaseListOrderBy.NAME_ASC: "Tên (A-Z)",
    BaseListOrderBy.NAME_DESC: "Tên (Z-A)",
    BaseListOrderBy.PRICE_ASC: "Giá bán tăng dần",
    BaseListOrderBy.PRICE_DESC: "Giá bán giảm dần",
  };

  Map<BaseListOrderBy, String> get orderByList => _orderByList;

  /* FILTER */
  // Keyword controll
  String _keyword = "";
  String get keyword => _keyword;
  set keyword(String value) {
    _keyword = value;
    _keywordController.add(_keyword);
  }

  bool isBarcode = false;
  final int _take = 500;
  int _listCount = 0;
  List<ProductTemplate> _products;
  List<ProductTemplate> get products => _products;

  bool get canLoadMore {
    return (_products?.length ?? 0) < (_listCount ?? 0);
  }

  int get productCount => _products?.length ?? 0;

  final BehaviorSubject<String> _keywordController = BehaviorSubject();
  void _onKeywordAdd(String value) {
    _keyword = value;
    if (_keywordController.isClosed == false) {
      _keywordController.add(value);
    }
  }

  Future<void> initCommand() async {
    onStateAdd(true);
    await fetchProductPriceLists();
  }

  Future<void> keywordChangedCommand(String keyword) async {
    _onKeywordAdd(keyword);
    notifyListeners();
  }

  List<FilterBase> filterItems = <FilterBase>[];

  Future loadProduct({bool isBarcode = false, bool isLoadMore = false}) async {
    if (!isLoadMore) {
      onStateAdd(true);
      _products?.clear();
    } else {
      _isLoaddingMore = true;
    }

    notifyListeners();

    final OdataSortItem sort = OdataSortItem(field: "Name", dir: "ASC");
    if (selectedOrderBy != null) {
      if (_selectedOrderBy == BaseListOrderBy.NAME_ASC) {
        sort.field = "Name";
        sort.dir = "asc";
      } else if (_selectedOrderBy == BaseListOrderBy.NAME_DESC) {
        sort.field = "Name";
        sort.dir = "desc";
      } else if (_selectedOrderBy == BaseListOrderBy.PRICE_ASC) {
        sort.field = "ListPrice";
        sort.dir = "asc";
      } else if (_selectedOrderBy == BaseListOrderBy.PRICE_DESC) {
        sort.field = "ListPrice";
        sort.dir = "desc";
      }
    }
    // Bộ lọc

    final String keywordNoSign =
        StringUtils.removeVietnameseMark(keyword?.toLowerCase() ?? "");
    OdataFilter filter = OdataFilter(logic: "and", filters: <FilterBase>[
      // Tìm kiếm theo tên, hoặc mã
      if (keywordNoSign != null && keywordNoSign != "")
        OdataFilter(logic: "or", filters: <OdataFilterItem>[
          OdataFilterItem(
              field: "Name", operator: "contains", value: keywordNoSign),
          OdataFilterItem(
              field: "NameNoSign", operator: "contains", value: keywordNoSign),
          OdataFilterItem(
              field: "Barcode", operator: "contains", value: keywordNoSign),
          OdataFilterItem(
              field: "DefaultCode", operator: "contains", value: keywordNoSign),
        ]),

      if (_filterProductCategories.isNotEmpty && _isFilterByCategory)
        OdataFilter(logic: "or", filters: <OdataFilterItem>[
          ...filterProductCategories.map(
            (f) =>
                OdataFilterItem(field: "CategId", operator: "eq", value: f.id),
          )
        ])

      // Lọc theo nhóm sản phẩm
      // Lọc theo bảng giá
    ]);

    if (filter.filters.isEmpty) {
      filter = null;
    }

    // Gọi request
    try {
      final result = await _productTemplateApi.gets(
          filter: filter,
          sorts: [sort],
          pageSize: _take,
          take: _take,
          skip: productCount,
          priceListId: _isFilterByPriceList ? _filterProductPrice?.id : null);

      _listCount = result.total ?? 0;

      if (isLoadMore) {
        products.addAll(result?.data);
        _isLoaddingMore = false;
        notifyListeners();
      } else {
        _products = result?.data;
      }
    } catch (e, s) {
      logger.error("", e, s);
      _dialog.showError(error: e);
    }
    _isLoaddingMore = false;
    onStateAdd(false);
    notifyListeners();
  }

  Future loadMoreProductCommand() async {
    loadProduct(isBarcode: isBarcode, isLoadMore: true);
  }

  /// selectOrderByCommand
  Future<void> selectOrderByCommand(BaseListOrderBy selectOrderBy) async {
    _selectedOrderBy = selectOrderBy;
    onPropertyChanged("selectedOrderBy");
    await amplyFilterCommand();
  }

  /// Aply Filter COmmand
  /// amplyFilterCommand
  Future<void> amplyFilterCommand() async {
    //save setting
    onStateAdd(true);
    try {
      _settingService.productSearchOrderByIndex = _selectedOrderBy.index;
      await loadProduct(isBarcode: isBarcode, isLoadMore: false);
    } catch (e, s) {
      logger.error("amplyFilterCommand", e, s);
    }
    //await _filter();
    onStateAdd(false);
  }

  bool get isViewAsList {
    return _settingService.isProductSearchViewList;
  }

  Future<void> changeViewTypeCommand(bool isList) async {
    _settingService.isProductSearchViewList = isList;
    onPropertyChanged("");
  }

  Future<void> addNewProductCommand(Product newProduct) async {
    _onKeywordAdd(newProduct.name);
  }

  Future<bool> deleteProductTemplate(int id) async {
    try {
      await _productTemplateApi.delete(id);
      _dialog.showNotify(message: "Đã xóa sản phẩm");
      return true;
    } catch (e, s) {
      logger.error("deleteProductTemplate fail", e, s);
      _dialog.showError(error: e);
      return false;
    }
  }

  @override
  void dispose() {
    _keywordController.close();
    super.dispose();
  }
}
