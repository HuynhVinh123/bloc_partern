import 'package:tpos_api_client/tpos_api_client.dart';

class ProductEvent {}

class ProductLoaded extends ProductEvent {
  ProductLoaded({this.skip, this.top});
  final int skip;
  final int top;
}

class ProductLoadMoreLoaded extends ProductEvent {
  ProductLoadMoreLoaded({this.productTPage, this.top, this.skip});
  final ProductTPage productTPage;
  final int skip;
  final int top;
}

class ProductDeleted extends ProductEvent {
  ProductDeleted({this.id});
  final String id;
}

class ProductUpdated extends ProductEvent {
  ProductUpdated({this.products});
  final String products;
}

class StatusProductUpdated extends ProductEvent {
  StatusProductUpdated({this.productId});
  final int productId;
}

class ProductAdded extends ProductEvent {
  ProductAdded({this.reply});
  final String reply;
}
