import 'package:diacritic/diacritic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/product_uom_category/bloc/product_uom_category_event.dart';
import 'package:tpos_mobile/feature_group/category/product_uom_category/bloc/product_uom_category_state.dart';

class ProductUomCategoryBloc extends Bloc<ProductUomCategoryEvent, ProductUomCategoryState> {
  ProductUomCategoryBloc({ProductUomCategoryApi productUomCategoryApi, ProductUomApi productUomApi})
      : super(ProductUomCategoryLoading()) {
    _productUomCategoryApi = productUomCategoryApi ?? GetIt.I<ProductUomCategoryApi>();
    _productUomApi = productUomApi ?? GetIt.I<ProductUomApi>();
  }

  ProductUomCategoryApi _productUomCategoryApi;
  ProductUomApi _productUomApi;

  final List<ProductUomCategory> _allProductUomCategoryCategories = [];
  List<ProductUomCategory> _productUomCategories = [];

  final Logger _logger = Logger();

  String _keyWord = '';

  @override
  Stream<ProductUomCategoryState> mapEventToState(ProductUomCategoryEvent event) async* {
    if (event is ProductUomCategoryStarted) {
      try {
        yield ProductUomCategoryLoading();

        final OdataListQuery uomCategoryQuery = OdataListQuery(
          filter: null,
          top: 10000,
          orderBy: null,
          skip: 0,
        );
        final OdataListResult<ProductUomCategory> productUomCategoryResult =
            await _productUomCategoryApi.getList(query: uomCategoryQuery);

        final OdataListQuery uomQuery = OdataListQuery(filter: 'Active eq true', top: 10000, orderBy: null, skip: 0);
        final OdataListResult<ProductUOM> productUomResult = await _productUomApi.getList(query: uomQuery);
        final List<ProductUOM> allProductUomCategories = productUomResult.value;

        _productUomCategories = productUomCategoryResult.value;

        final List<ProductUOM> removeProductUomCategories = [];
        for (final ProductUomCategory productUomCategory in _productUomCategories) {
          removeProductUomCategories.clear();
          for (final ProductUOM productUom in allProductUomCategories) {
            if (productUom.categoryId == productUomCategory.id) {
              productUomCategory.productUoms.add(productUom);

              removeProductUomCategories.add(productUom);
            }
          }

          if (removeProductUomCategories.isNotEmpty) {
            allProductUomCategories.removeWhere(
                (ProductUOM productUom) => removeProductUomCategories.any((element) => element.id == productUom.id));
          }
        }

        _allProductUomCategoryCategories.addAll(_productUomCategories);

        yield ProductUomCategoryLoadSuccess(productUomCategories: _productUomCategories);
      } catch (e, stack) {
        _logger.e('ProductUomCategoryLoadFailure', e, stack);
        yield ProductUomCategoryLoadFailure(error: e.toString());
      }
    } else if (event is ProductUomCategorySearched) {
      yield ProductUomCategoryLoading();
      _keyWord = event.search.trim().toLowerCase();
      _productUomCategories.clear();

      _productUomCategories = _allProductUomCategoryCategories
          .where((ProductUomCategory productUomCategory) =>
              productUomCategory.name.toLowerCase().contains(_keyWord) ||
              removeDiacritics(productUomCategory.name.toLowerCase()).contains(removeDiacritics(_keyWord)))
          .toList();

      yield ProductUomCategoryLoadSuccess(productUomCategories: _productUomCategories);
    } else if (event is ProductUomCategoryInserted) {
      try {
        yield ProductUomCategoryBusy();
        final ProductUomCategory productUomCategory = await _productUomCategoryApi.insert(event.productUomCategory);

        _productUomCategories.add(productUomCategory);

        _allProductUomCategoryCategories.add(productUomCategory);

        yield ProductUomCategoryInsertSuccess(productUomCategories: _productUomCategories);
      } catch (e, stack) {
        _logger.e('ProductUomCategoryActionFailure', e, stack);
        yield ProductUomCategoryActionFailure(error: e.toString());
      }
    } else if (event is ProductUomCategoryDeleted) {
      try {
        yield ProductUomCategoryBusy();
        await _productUomCategoryApi.delete(event.productUomCategory.id);

        _productUomCategories.remove(event.productUomCategory);

        _allProductUomCategoryCategories.add(event.productUomCategory);

        yield ProductUomCategoryDeleteSuccess(productUomCategories: _productUomCategories);
      } catch (e, stack) {
        _logger.e('ProductUomCategoryActionFailure', e, stack);
        yield ProductUomCategoryActionFailure(error: e.toString());
      }
    } else if (event is ProductUomCategoryUpdated) {
      try {
        yield ProductUomCategoryBusy();
        await _productUomCategoryApi.update(event.productUomCategory);

        yield ProductUomCategoryUpdateSuccess(productUomCategories: _productUomCategories);
      } catch (e, stack) {
        _logger.e('ProductUomCategoryActionFailure', e, stack);
        yield ProductUomCategoryActionFailure(error: e.toString());
      }
    } else if (event is ProductUomCategoryRefreshed) {
      try {
        yield ProductUomCategoryUpdateSuccess(productUomCategories: _productUomCategories);
      } catch (e, stack) {
        _logger.e('ProductUomCategoryActionFailure', e, stack);
        yield ProductUomCategoryActionFailure(error: e.toString());
      }
    }
  }
}
