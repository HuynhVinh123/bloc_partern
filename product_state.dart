import 'package:tpos_api_client/tpos_api_client.dart';

class ProductState {}

/// Loading
class ProductLoading extends ProductState {}

class ProductLoadMoreLoading extends ProductState {}

class ProductLoadSuccess extends ProductState {
  ProductLoadSuccess({this.product});
  final ProductTPage product;
}

class ActionSuccess extends ProductState {
  ActionSuccess({this.title, this.content});
  final String title;
  final String content;
}

class ActionFailed extends ProductState {
  ActionFailed({this.title, this.content});
  final String title;
  final String content;
}

class ProductLoadFailure extends ProductState {
  ProductLoadFailure({this.title, this.content});
  final String title;
  final String content;
}
