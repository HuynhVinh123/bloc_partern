import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';

import '../tpos_api.dart';

class StockFilter {
  StockFilter(
      {this.productCategory,
      this.filterDateRange,
      this.dateTo,
      this.dateFrom,
      this.isFilterByProductCategory = false ,
        this.isFilterByWarehouseStock = false,
      this.wareHouseStock,
      this.includeCancelled = false,
      this.includeReturned = false});



  DateTime dateFrom;
  DateTime dateTo;
  bool isFilterByProductCategory;
  bool isFilterByWarehouseStock;

  AppFilterDateModel filterDateRange;
  WareHouseStock wareHouseStock;
  ProductCategory productCategory;
  bool includeCancelled;
  bool includeReturned;
}
