import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ProductDetailsImageState {}

class ProductDetailsImageLoadSuccess extends ProductDetailsImageState {
  ProductDetailsImageLoadSuccess({this.productImages});

  final List<ProductImage> productImages;
}

class ProductDetailsImageLoading extends ProductDetailsImageState {}

class ProductDetailsImageLoadFailure extends ProductDetailsImageState {
  ProductDetailsImageLoadFailure({this.error});

  final String error;
}
