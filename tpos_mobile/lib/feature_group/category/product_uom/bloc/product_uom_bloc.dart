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
  final List<ProductUOM> _allProductUoms = [];
  final Logger _logger = Logger();

  String _keyWord = '';
  int _categoryId;

  void _load() {
    final List<ProductUOM> allProductUoms = [];
    for (final ProductUOM productUom in _allProductUoms) {
      allProductUoms.add(ProductUOM.cloneWith(productUom));
    }

    final List<ProductUOM> removeProductUoms = [];

    for (final ProductUomCategory productUomCategory in _allProductUomCategories) {
      removeProductUoms.clear();
      productUomCategory.productUoms.clear();

      for (final ProductUOM productUom in allProductUoms) {
        if (productUom.categoryId == productUomCategory.id) {
          productUomCategory.productUoms.add(productUom);

          removeProductUoms.add(productUom);
        }
      }

      if (removeProductUoms.isNotEmpty) {
        allProductUoms
            .removeWhere((ProductUOM productUom) => removeProductUoms.any((element) => element.id == productUom.id));
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
    if (_keyWord != '') {
      _productUomCategories = _productUomCategories
          .where((ProductUomCategory productUomCategory) => checkSameSearch(productUomCategory, _keyWord))
          .toList();
    }
  }

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

        _allProductUoms.clear();

        _allProductUoms.addAll(productUomResult.value);

        _productUomCategories = productUomCategoryResult.value;
        _categoryId = event.categoryId;
        if (_categoryId != null) {
          _productUomCategories = _productUomCategories.where((element) => element.id == _categoryId).toList();
        }
        _allProductUomCategories.addAll(_productUomCategories);
        _load();

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

      if (_keyWord != '') {
        _productUomCategories = _productUomCategories
            .where((ProductUomCategory productUomCategory) => checkSameSearch(productUomCategory, _keyWord))
            .toList();
      }

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
        _allProductUoms.clear();

        _allProductUoms.addAll(productUomResult.value);

        _allProductUomCategories = productUomCategoryResult.value;
        if (_categoryId != null) {
          _allProductUomCategories = _allProductUomCategories.where((element) => element.id == _categoryId).toList();
        }

        _load();

        // final List<ProductUOM> removeProductUoms = [];
        // for (final ProductUomCategory productUomCategory in _allProductUomCategories) {
        //   removeProductUoms.clear();
        //   for (final ProductUOM productUom in _allProductUoms) {
        //     if (productUom.categoryId == productUomCategory.id) {
        //       productUomCategory.productUoms.add(productUom);
        //
        //       removeProductUoms.add(productUom);
        //     }
        //   }
        //
        //   if (removeProductUoms.isNotEmpty) {
        //     _allProductUoms.removeWhere(
        //         (ProductUOM productUom) => removeProductUoms.any((element) => element.id == productUom.id));
        //   }
        // }
        //
        // _productUomCategories.clear();
        //
        // for (final ProductUomCategory productUomCategory in _allProductUomCategories) {
        //   final List<ProductUOM> clones = [];
        //
        //   for (final ProductUOM productUOM in productUomCategory.productUoms) {
        //     clones.add(ProductUOM.cloneWith(productUOM));
        //   }
        //   final ProductUomCategory cloneUomCategory = ProductUomCategory.cloneWith(productUomCategory);
        //   cloneUomCategory.productUoms = clones;
        //   _productUomCategories.add(cloneUomCategory);
        // }
        //
        // _productUomCategories = _productUomCategories
        //     .where((ProductUomCategory productUomCategory) => checkSameSearch(productUomCategory, _keyWord))
        //     .toList();

        yield ProductUomLoadSuccess(productUomCategories: _productUomCategories);
      } catch (e, stack) {
        _logger.e('ProductUomLoadFailure', e, stack);
        yield ProductUomLoadFailure(error: e.toString());
      }
    } else if (event is ProductUomDeleted) {
      try {
        yield ProductUomBusy();
        await _productUomApi.delete(event.productUom.id);
        _allProductUoms.removeWhere((element) => element.id == event.productUom.id);

        _load();

        yield ProductUomDeleteSuccess(productUomCategories: _productUomCategories);
      } catch (e, stack) {
        _logger.e('ProductUomDeleteFailure', e, stack);
        yield ProductUomDeleteFailure(error: e.toString());
      }
    }
  }

  bool checkSameSearch(ProductUomCategory productUomCategory, String search) {
    if (productUomCategory.productUoms.isNotEmpty) {
      final List<ProductUOM> removeProductUoms = [];
      for (final ProductUOM productUOM in productUomCategory.productUoms) {
        if (removeDiacritics(productUOM.name.toLowerCase()).contains(removeDiacritics(_keyWord))) {
          removeProductUoms.add(productUOM);
        }
      }

      if (removeProductUoms.isNotEmpty) {
        productUomCategory.productUoms
            .removeWhere((ProductUOM productUOM) => removeProductUoms.any((element) => productUOM.id != element.id));
        return true;
      } else {
        productUomCategory.productUoms.clear();
        if (removeDiacritics(productUomCategory.name.toLowerCase()).contains(removeDiacritics(_keyWord))) {
          return true;
        }
      }
    }

    return false;
  }
}
