import 'package:tpos_api_client/tpos_api_client.dart';

class InventoryMaxState {}

/// Chạy loading khi load danh sách sản phẩm vượt tồn
class InventoryMaxLoading extends InventoryMaxState {}

/// Chạy loading khi thực hiện load more danh sách sản phẩm vượt tồn
class InventoryMaxLoadMoreLoading extends InventoryMaxState {}

/// Trả về dữ liệu khi thực hiện load danh sách sản phẩm vượt tồn thành công
class InventoryMaxLoadSuccess extends InventoryMaxState {
  InventoryMaxLoadSuccess({this.products, this.isFilter = false});
  final List<StockWarehouseProduct> products;
  final bool isFilter;
}

/// Báo lỗi khi thực hiện lấy danh sách dữ liệu thất bại
class InventoryMaxLoadFailure extends InventoryMaxState {
  InventoryMaxLoadFailure({this.title, this.content});

  final String title;
  final String content;
}
