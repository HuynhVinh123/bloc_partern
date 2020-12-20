import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/models/stock_change_product_quantity.dart';
import 'package:tpos_mobile/src/tpos_apis/models/stock_location.dart';

abstract class StockChangeProductQuantityState {}

class StockChangeProductQuantityLoadSuccess extends StockChangeProductQuantityState {
  StockChangeProductQuantityLoadSuccess(
      {this.stockChangeProductQuantity, this.products, this.locations, this.stockProductionLots});

  final StockChangeProductQuantity stockChangeProductQuantity;
  final List<Product> products;
  final List<StockProductionLot> stockProductionLots;
  final List<StockLocation> locations;
}

class StockChangeProductQuantitySaveSuccess extends StockChangeProductQuantityLoadSuccess {
  StockChangeProductQuantitySaveSuccess(
      {StockChangeProductQuantity stockChangeProductQuantity,
      List<Product> products,
      List<StockLocation> locations,
      List<StockProductionLot> stockProductionLots})
      : super(
            stockChangeProductQuantity: stockChangeProductQuantity,
            locations: locations,
            products: products,
            stockProductionLots: stockProductionLots);
}

class StockChangeProductQuantityLoadFailure extends StockChangeProductQuantityState {
  StockChangeProductQuantityLoadFailure({this.error});

  final String error;
}

class StockChangeProductQuantitySaveError extends StockChangeProductQuantityState {
  StockChangeProductQuantitySaveError({this.error});

  final String error;
}

class StockChangeProductQuantityLoading extends StockChangeProductQuantityState {}

class StockChangeProductQuantityBusy extends StockChangeProductQuantityState {}
