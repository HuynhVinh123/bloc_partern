import 'package:diacritic/diacritic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpos_mobile/feature_group/category/stock_change_product_quantity/bloc/stock_location/stock_location_event.dart';
import 'package:tpos_mobile/feature_group/category/stock_change_product_quantity/bloc/stock_location/stock_location_state.dart';
import 'package:tpos_mobile/src/tpos_apis/models/stock_location.dart';

class StockLocationBloc extends Bloc<StockLocationEvent, StockLocationState> {
  StockLocationBloc() : super(StockLocationLoading(stockProductions: []));
  List<StockLocation> _stockProductions;

  @override
  Stream<StockLocationState> mapEventToState(StockLocationEvent event) async* {
    if (event is StockLocationStarted) {
      _stockProductions = event.stockLocations;
      yield StockLocationLoadSuccess(stockProductions: _stockProductions);
    } else if (event is StockLocationSearched) {
      yield StockLocationLoading(stockProductions: _stockProductions);
      if (event.search == '') {
        yield StockLocationLoadSuccess(stockProductions: _stockProductions);
      } else {
        final String search = removeDiacritics(event.search.toLowerCase().trim());
        List<StockLocation> searchProducts = [];
        searchProducts.addAll(_stockProductions);
        searchProducts = searchProducts
            .where((StockLocation product) =>
                removeDiacritics(product.name.toLowerCase()).contains(search) ||
                removeDiacritics(product.nameGet.toLowerCase()).contains(search))
            .toList();
        yield StockLocationLoadSuccess(stockProductions: searchProducts);
      }
    }
  }
}
