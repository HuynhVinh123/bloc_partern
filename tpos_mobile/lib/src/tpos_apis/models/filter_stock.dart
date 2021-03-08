import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';

class StockFilter {
  StockFilter(
      {this.productCategory,
      this.filterDateRange,
      this.dateTo,
      this.dateFrom,
      this.isFilterByProductCategory = false,
      this.isFilterByWarehouseStock = false,
      this.wareHouseStock,
      this.includeCancelled = false,
      this.includeReturned = false,
      this.isFilterByKeyWord = false,
      this.keyWord,
      this.isApply = false,
      this.isReset = false,
      this.filterByKeyWord = false,
      this.filterByProductCategory = false,
      this.filterByWarehouseStock = false,
      this.productCategoryCache,
      this.wareHouseStockCache,
      this.dateFromCache,
      this.dateToCache,
      this.filterDateRangeCache});

  DateTime dateFrom;
  DateTime dateTo;
  bool isFilterByProductCategory;
  bool isFilterByWarehouseStock;
  bool isFilterByKeyWord;

  bool filterByProductCategory;
  bool filterByWarehouseStock;
  bool filterByKeyWord;

  bool isReset;
  bool isApply;

  String keyWord;
  AppFilterDateModel filterDateRange;
  WareHouseStock wareHouseStock;
  ProductCategory productCategory;

  /// Lưu tạm khi xác nhận mới cập nhật. Dùng để hiển thị trên header filter
  WareHouseStock wareHouseStockCache;
  ProductCategory productCategoryCache;
  DateTime dateFromCache;
  DateTime dateToCache;
  AppFilterDateModel filterDateRangeCache;

  bool includeCancelled;
  bool includeReturned;
}
