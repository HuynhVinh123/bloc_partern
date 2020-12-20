import 'package:tpos_api_client/tpos_api_client.dart';

class InventoryMinState {}

/// Chạy loading khi load danh sách sản phẩm hết hạn
class InventoryMinLoading extends InventoryMinState {}

/// Chạy loading khi thực hiện load more danh sách sản phẩm hết hạn
class InventoryMinLoadMoreLoading extends InventoryMinState {}

/// Trả về dữ liệu khi thực hiện load danh sách sản phẩm hết hạn thành công
class InventoryMinLoadSuccess extends InventoryMinState {
  InventoryMinLoadSuccess({this.products, this.isFilter = false});
  final List<StockWarehouseProduct> products;
  final bool isFilter;
}

/// Báo lỗi khi thực hiện lấy danh sách dữ liệu thất bại
class InventoryMinLoadFailure extends InventoryMinState {
  InventoryMinLoadFailure({this.title, this.content});

  final String title;
  final String content;
}
