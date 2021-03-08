import 'package:tpos_mobile/feature_group/category/product_template/bloc/details/product_template_details_event.dart';

abstract class ProductDetailsStockMoveEvent {}

class ProductDetailsStockMoveStarted extends ProductDetailsStockMoveEvent {
  ProductDetailsStockMoveStarted({this.productTemplateId});

  final int productTemplateId;
}

class ProductDetailsStockMoveLoadMore extends ProductDetailsStockMoveEvent {}

class ProductDetailsStockMoveFilter extends ProductDetailsStockMoveEvent {
  ProductDetailsStockMoveFilter({this.filter});

  final StockType filter;
}

class ProductDetailsStockMoveRefresh extends ProductDetailsStockMoveEvent {
  ProductDetailsStockMoveRefresh({this.filter});

  final StockType filter;
}
