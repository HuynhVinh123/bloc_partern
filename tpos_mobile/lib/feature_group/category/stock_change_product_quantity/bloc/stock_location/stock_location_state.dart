import 'package:tpos_mobile/src/tpos_apis/models/stock_location.dart';

abstract class StockLocationState {
  StockLocationState({this.stockProductions});

  final List<StockLocation> stockProductions;
}

class StockLocationLoading extends StockLocationState {
  StockLocationLoading({List<StockLocation> stockProductions}) : super(stockProductions: stockProductions);
}

class StockLocationLoadSuccess extends StockLocationState {
  StockLocationLoadSuccess({List<StockLocation> stockProductions}) : super(stockProductions: stockProductions);
}
