import 'package:tpos_api_client/tpos_api_client.dart';

abstract class StockProductionLotEvent {}

class StockProductionLotStarted extends StockProductionLotEvent {
  StockProductionLotStarted({this.stockProductionLots});

  final List<StockProductionLot> stockProductionLots;
}

class StockProductionLotSearched extends StockProductionLotEvent {
  StockProductionLotSearched({this.search});

  final String search;
}
