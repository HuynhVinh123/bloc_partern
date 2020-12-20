import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/models/filter_stock.dart';

class InventoryMinEvent {}

/// Event load danh sách sản phẩm hết hạn
class InventoryMinLoaded extends InventoryMinEvent {
  InventoryMinLoaded({this.skip, this.limit});
  final int limit;
  final int skip;
}

/// Event lưu và lấy danh sách sản phẩm hết hạn
class InventoryMinFilterSaved extends InventoryMinEvent {
  InventoryMinFilterSaved(
      {this.stockFilter, this.limit, this.skip, this.isFilter});
  final StockFilter stockFilter;
  final int limit;
  final int skip;
  final bool isFilter;
}

/// Event lưu filter
class InventoryMinLocalFilterSaved extends InventoryMinEvent {
  InventoryMinLocalFilterSaved({this.stockFilter});
  final StockFilter stockFilter;
}

/// Event load more danh sách sản phẩm hết hạn
class InventoryMinLoadMoreLoaded extends InventoryMinEvent {
  InventoryMinLoadMoreLoaded({this.skip, this.limit, this.products});
  final int limit;
  final int skip;
  final List<StockWarehouseProduct> products;
}
