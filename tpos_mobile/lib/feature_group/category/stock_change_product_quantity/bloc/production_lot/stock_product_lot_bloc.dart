import 'package:diacritic/diacritic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/stock_change_product_quantity/bloc/production_lot/stock_product_lot_event.dart';
import 'package:tpos_mobile/feature_group/category/stock_change_product_quantity/bloc/production_lot/stock_product_lot_state.dart';

class StockProductionLotBloc extends Bloc<StockProductionLotEvent, StockProductionLotState> {
  StockProductionLotBloc() : super(StockProductionLotLoading(stockProductions: []));
  List<StockProductionLot> _stockProductions;

  @override
  Stream<StockProductionLotState> mapEventToState(StockProductionLotEvent event) async* {
    if (event is StockProductionLotStarted) {
      _stockProductions = event.stockProductionLots;
      yield StockProductionLotLoadSuccess(stockProductions: _stockProductions);
    } else if (event is StockProductionLotSearched) {
      yield StockProductionLotLoading(stockProductions: _stockProductions);
      if (event.search == '') {
        yield StockProductionLotLoadSuccess(stockProductions: _stockProductions);
      } else {
        final String search = removeDiacritics(event.search.toLowerCase().trim());
        List<StockProductionLot> searchProducts = [];
        searchProducts.addAll(_stockProductions);
        searchProducts = searchProducts
            .where((StockProductionLot product) =>
                removeDiacritics(product.name.toLowerCase()).contains(search) ||
                removeDiacritics(product.productNameGet.toLowerCase()).contains(search))
            .toList();
        yield StockProductionLotLoadSuccess(stockProductions: searchProducts);
      }
    }
  }
}
