import 'package:tpos_api_client/tpos_api_client.dart';

class ProductEvent {}

///Event lấy danh sách sản phẩm
class ProductLoaded extends ProductEvent {
  ProductLoaded({this.skip, this.top, this.keySearch});
  final int skip;
  final int top;
  final String keySearch;
}

/// Event loadmore danh sách sản phẩm
class ProductLoadMoreLoaded extends ProductEvent {
  ProductLoadMoreLoaded(
      {this.productTPages, this.top, this.skip, this.keySearch});
  final List<Product> productTPages;
  final int skip;
  final int top;
  final String keySearch;
}

/// Event xóa 1 sản phẩm
class ProductDeleted extends ProductEvent {
  ProductDeleted({this.id, this.countProduct});
  final String id;
  final int countProduct;
}

/// Event cập nhật thông tin 1 sản phẩm
class ProductUpdated extends ProductEvent {
  ProductUpdated({this.products});
  final String products;
}

/// Event cập nhật tràng thái của sản phẩm
class StatusProductUpdated extends ProductEvent {
  StatusProductUpdated({this.productId, this.countProduct});
  final int productId;
  final int countProduct;
}

/// Event thêm mới 1 sản phẩm
class ProductAdded extends ProductEvent {
  ProductAdded({this.reply});
  final String reply;
}
