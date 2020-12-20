import 'package:diacritic/diacritic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/product_uom/bloc/product_uom_event.dart';
import 'package:tpos_mobile/feature_group/category/product_uom/bloc/product_uom_state.dart';

class ProductUomBloc extends Bloc<ProductUomEvent, ProductUomState> {
  ProductUomBloc({ProductUomCategoryApi productUomCategoryApi, ProductUomApi productUomApi})
      : super(ProductUomLoading()) {
    _productUomCategoryApi = productUomCategoryApi ?? GetIt.I<ProductUomCategoryApi>();
    _productUomApi = productUomApi ?? GetIt.I<ProductUomApi>();
  }

  ProductUomCategoryApi _productUomCategoryApi;
  ProductUomApi _productUomApi;

  List<ProductUomCategory> _allProductUomCategories = [];
  List<ProductUomCategory> _productUomCategories = [];

  final Logger _logger = Logger();

  String _keyWord = '';
  int _categoryId;

  @override
  Stream<ProductUomState> mapEventToState(ProductUomEvent event) async* {
    if (event is ProductUomStarted) {
      try {
        yield ProductUomLoading();

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
        final List<ProductUOM> allProductUoms = productUomResult.value;

        _productUomCategories = productUomCategoryResult.value;
        _categoryId = event.categoryId;
        if (_categoryId != null) {
          _productUomCategories = _productUomCategories.where((element) => element.id == _categoryId).toList();
        }

        final List<ProductUOM> removeProductUoms = [];
        for (final ProductUomCategory productUomCategory in _productUomCategories) {
          removeProductUoms.clear();
          for (final ProductUOM productUom in allProductUoms) {
            if (productUom.categoryId == productUomCategory.id) {
              productUomCategory.productUoms.add(productUom);

              removeProductUoms.add(productUom);
            }
          }

          if (removeProductUoms.isNotEmpty) {
            allProductUoms.removeWhere(
                (ProductUOM productUom) => removeProductUoms.any((element) => element.id == productUom.id));
          }
        }

        _allProductUomCategories.addAll(_productUomCategories);

        yield ProductUomLoadSuccess(productUomCategories: _productUomCategories);
      } catch (e, stack) {
        _logger.e('ProductUomLoadFailure', e, stack);
        yield ProductUomLoadFailure(error: e.toString());
      }
    } else if (event is ProductUomSearched) {
      yield ProductUomLoading();
      _keyWord = event.search.trim().toLowerCase();
      _productUomCategories.clear();

      for (final ProductUomCategory productUomCategory in _allProductUomCategories) {
        final List<ProductUOM> clones = [];

        for (final ProductUOM productUOM in productUomCategory.productUoms) {
          clones.add(ProductUOM.cloneWith(productUOM));
        }
        final ProductUomCategory cloneUomCategory = ProductUomCategory.cloneWith(productUomCategory);
        cloneUomCategory.productUoms = clones;
        _productUomCategories.add(cloneUomCategory);
      }

      _productUomCategories = _productUomCategories
          .where((ProductUomCategory productUomCategory) => checkSameSearch(productUomCategory, _keyWord))
          .toList();

      yield ProductUomLoadSuccess(productUomCategories: _productUomCategories);
    } else if (event is ProductUomRefreshed) {
      try {
        yield ProductUomLoading();

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
        final List<ProductUOM> allProductUoms = productUomResult.value;

        _allProductUomCategories = productUomCategoryResult.value;
        if (_categoryId != null) {
          _allProductUomCategories = _allProductUomCategories.where((element) => element.id == _categoryId).toList();
        }
        final List<ProductUOM> removeProductUoms = [];
        for (final ProductUomCategory productUomCategory in _allProductUomCategories) {
          removeProductUoms.clear();
          for (final ProductUOM productUom in allProductUoms) {
            if (productUom.categoryId == productUomCategory.id) {
              productUomCategory.productUoms.add(productUom);

              removeProductUoms.add(productUom);
            }
          }

          if (removeProductUoms.isNotEmpty) {
            allProductUoms.removeWhere(
                (ProductUOM productUom) => removeProductUoms.any((element) => element.id == productUom.id));
          }
        }

        _productUomCategories.clear();

        for (final ProductUomCategory productUomCategory in _allProductUomCategories) {
          final List<ProductUOM> clones = [];

          for (final ProductUOM productUOM in productUomCategory.productUoms) {
            clones.add(ProductUOM.cloneWith(productUOM));
          }
          final ProductUomCategory cloneUomCategory = ProductUomCategory.cloneWith(productUomCategory);
          cloneUomCategory.productUoms = clones;
          _productUomCategories.add(cloneUomCategory);
        }

        _productUomCategories = _productUomCategories
            .where((ProductUomCategory productUomCategory) => checkSameSearch(productUomCategory, _keyWord))
            .toList();

        yield ProductUomLoadSuccess(productUomCategories: _productUomCategories);
      } catch (e, stack) {
        _logger.e('ProductUomLoadFailure', e, stack);
        yield ProductUomLoadFailure(error: e.toString());
      }
    }
  }

  bool checkSameSearch(ProductUomCategory productUomCategory, String search) {
    if (productUomCategory.name.toLowerCase().contains(_keyWord) ||
        removeDiacritics(productUomCategory.name.toLowerCase()).contains(removeDiacritics(_keyWord))) {
      return true;
    }

    if (productUomCategory.productUoms.isNotEmpty) {
      final List<ProductUOM> removeProductUoms = [];
      for (final ProductUOM productUOM in productUomCategory.productUoms) {
        if (!(productUOM.name.toLowerCase().contains(_keyWord) ||
            removeDiacritics(productUomCategory.name.toLowerCase()).contains(removeDiacritics(_keyWord)))) {
          removeProductUoms.add(productUOM);
        }
      }

      if (removeProductUoms.isNotEmpty) {
        if (removeProductUoms.length == productUomCategory.productUoms.length) {
          productUomCategory.productUoms
              .removeWhere((ProductUOM productUOM) => removeProductUoms.any((element) => productUOM.id == element.id));
          return false;
        } else {
          productUomCategory.productUoms
              .removeWhere((ProductUOM productUOM) => removeProductUoms.any((element) => productUOM.id == element.id));
          return true;
        }
      }
    }

    return false;
  }
}
