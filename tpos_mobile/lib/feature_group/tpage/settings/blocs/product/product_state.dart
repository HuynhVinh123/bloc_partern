import 'package:tpos_api_client/tpos_api_client.dart';

class ProductState {}

/// Loading
class ProductLoading extends ProductState {}

/// State loading khi loadmore sản phẩm
class ProductLoadMoreLoading extends ProductState {}

/// State trả về dữ liệu khi load sản phẩm thành công
class ProductLoadSuccess extends ProductState {
  ProductLoadSuccess({this.products});
  final List<Product> products;
}

/// State khi thực thi thêm, xóa, sửa sản phẩm thành công
class ActionSuccess extends ProductState {
  ActionSuccess({this.title, this.content,this.countProduct});
  final String title;
  final String content;
  final int countProduct;
}

/// State khi thực thi thêm, xóa, sửa thất bại
class ActionFailed extends ProductState {
  ActionFailed({this.title, this.content});
  final String title;
  final String content;
}

/// State thi thực thi load dữ liệu thất bại
class ProductLoadFailure extends ProductState {
  ProductLoadFailure({this.title, this.content});
  final String title;
  final String content;
}
