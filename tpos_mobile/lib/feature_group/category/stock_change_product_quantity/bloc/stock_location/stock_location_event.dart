import 'package:tpos_mobile/src/tpos_apis/models/stock_location.dart';

abstract class StockLocationEvent {}

class StockLocationStarted extends StockLocationEvent {
  StockLocationStarted({this.stockLocations});

  final List<StockLocation> stockLocations;
}

class StockLocationSearched extends StockLocationEvent {
  StockLocationSearched({this.search});

  final String search;
}
