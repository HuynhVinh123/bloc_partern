import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/models/filter_stock.dart';

class InventoryMaxEvent {}

/// Event load danh sách sản phẩm vượt tồn
class InventoryMaxLoaded extends InventoryMaxEvent {
  InventoryMaxLoaded({this.skip, this.limit});
  final int limit;
  final int skip;
}

/// Event lưu và lấy danh sách sản phẩm vượt tồn
class InventoryMaxFilterSaved extends InventoryMaxEvent {
  InventoryMaxFilterSaved(
      {this.stockFilter, this.limit, this.skip, this.isFilter});
  final StockFilter stockFilter;
  final int limit;
  final int skip;
  final bool isFilter;
}

/// Thực hiện lưu filter
class InventoryMaxLocalFilterSaved extends InventoryMaxEvent {
  InventoryMaxLocalFilterSaved({this.stockFilter});
  final StockFilter stockFilter;
}

/// Event load more danh sách sản phẩm vượt tồn
class InventoryMaxLoadMoreLoaded extends InventoryMaxEvent {
  InventoryMaxLoadMoreLoaded({this.skip, this.limit, this.products});
  final int limit;
  final int skip;
  final List<StockWarehouseProduct> products;
}
