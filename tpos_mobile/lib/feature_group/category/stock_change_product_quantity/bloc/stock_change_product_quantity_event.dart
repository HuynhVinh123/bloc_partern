import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/models/stock_change_product_quantity.dart';

abstract class StockChangeProductQuantityEvent {}

class StockChangeProductQuantityInitial extends StockChangeProductQuantityEvent {
  StockChangeProductQuantityInitial({this.productTemplateId});

  final int productTemplateId;
}

class StockChangeProductQuantitySaved extends StockChangeProductQuantityEvent {
  StockChangeProductQuantitySaved({this.stockChangeProductQuantity});

  final StockChangeProductQuantity stockChangeProductQuantity;
}

class StockChangeProductQuantityUpdateLocal extends StockChangeProductQuantityEvent {
  StockChangeProductQuantityUpdateLocal({this.stockChangeProductQuantity});

  final StockChangeProductQuantity stockChangeProductQuantity;
}

class StockChangeProductQuantityLocationLoad extends StockChangeProductQuantityEvent {
  StockChangeProductQuantityLocationLoad({this.productTemplateId});

  final int productTemplateId;
}

class StockChangeProductQuantityProductChanged extends StockChangeProductQuantityEvent {
  StockChangeProductQuantityProductChanged({this.product, this.stockChangeProductQuantity});
  final StockChangeProductQuantity stockChangeProductQuantity;
  final Product product;
}
