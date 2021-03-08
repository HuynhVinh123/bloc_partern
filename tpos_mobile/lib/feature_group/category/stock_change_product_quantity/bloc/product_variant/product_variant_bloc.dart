import 'package:diacritic/diacritic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/stock_change_product_quantity/bloc/product_variant/product_variant_event.dart';
import 'package:tpos_mobile/feature_group/category/stock_change_product_quantity/bloc/product_variant/product_variant_state.dart';

class ProductVariantBloc extends Bloc<ProductVariantEvent, ProductVariantState> {
  ProductVariantBloc() : super(ProductVariantLoading(products: []));
  List<Product> _products;

  @override
  Stream<ProductVariantState> mapEventToState(ProductVariantEvent event) async* {
    if (event is ProductVariantStarted) {
      _products = event.products;
      yield ProductVariantLoadSuccess(products: _products);
    } else if (event is ProductVariantSearched) {
      yield ProductVariantLoading(products: _products);
      if (event.search == '') {
        yield ProductVariantLoadSuccess(products: _products);
      } else {
        final String search = removeDiacritics(event.search.toLowerCase().trim());
        List<Product> searchProducts = [];
        searchProducts.addAll(_products);
        searchProducts = searchProducts
            .where((Product product) =>
                removeDiacritics(product.name.toLowerCase()).contains(search) ||
                removeDiacritics(product.nameGet.toLowerCase()).contains(search))
            .toList();
        yield ProductVariantLoadSuccess(products: searchProducts);
      }
    }
  }
}
