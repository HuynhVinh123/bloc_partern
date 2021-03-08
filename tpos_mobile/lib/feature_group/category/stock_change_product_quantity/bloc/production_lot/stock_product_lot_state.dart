import 'package:tpos_api_client/tpos_api_client.dart';

abstract class StockProductionLotState {
  StockProductionLotState({this.stockProductionLots});

  final List<StockProductionLot> stockProductionLots;
}

class StockProductionLotLoading extends StockProductionLotState {
  StockProductionLotLoading({List<StockProductionLot> stockProductions}) : super(stockProductionLots: stockProductions);
}

class StockProductionLotLoadSuccess extends StockProductionLotState {
  StockProductionLotLoadSuccess({List<StockProductionLot> stockProductions})
      : super(stockProductionLots: stockProductions);
}
