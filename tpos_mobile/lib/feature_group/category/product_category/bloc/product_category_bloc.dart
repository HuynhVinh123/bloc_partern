import 'package:diacritic/diacritic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/product_category/bloc/product_category_event.dart';
import 'package:tpos_mobile/feature_group/category/product_category/bloc/product_category_state.dart';

///Bloc dùng để lấy danh sách [ProductCategory] hiện có
class ProductCategoryBloc extends Bloc<ProductCategoryEvent, ProductCategoryState> {
  ProductCategoryBloc({ProductCategoryApi productCategoryApi}) : super(ProductCategoryLoading()) {
    _productCategoryApi = productCategoryApi ?? GetIt.I<ProductCategoryApi>();
  }

  ProductCategoryApi _productCategoryApi;
  List<ProductCategory> _productCategories = [];
  final List<ProductCategory> _originProductCategories = [];
  final List<ProductCategory> _allProductCategories = [];

  String _search = '';
  final Logger _logger = Logger();
  ProductCategory _current;
  int _total = 0;

  bool _checkSameSearch(ProductCategory productCategory, String search) {
    if (productCategory.name.toLowerCase().contains(_search) ||
        productCategory.nameNoSign.toLowerCase().contains(removeDiacritics(_search))) {
      return true;
    }

    if (productCategory.children.isNotEmpty) {
      for (final ProductCategory child in productCategory.children) {
        return _checkSameSearch(child, search);
      }
    }

    return false;
  }

  Future<void> refresh() async {
    _allProductCategories.clear();
    final OdataListQuery query = OdataListQuery(filter: 'IsDelete eq false', top: 10000);

    final OdataListResult<ProductCategory> result = await _productCategoryApi.gets(odataListQuery: query);

    _productCategories = result.value;
    _originProductCategories.clear();
    _originProductCategories.addAll(result.value);
    _total = result.count;
    if (_current != null) {
      _productCategories.removeWhere((ProductCategory element) => element.id == _current.id);
    }

    for (final ProductCategory productCategory in _productCategories) {
      final List<ProductCategory> children =
          _productCategories.where((value) => value.parentId == productCategory.id).toList();
      productCategory.children = children;
    }

    _productCategories.removeWhere((ProductCategory productCategory) => productCategory.parentId != null);
    _allProductCategories.addAll(_productCategories);

    if (_search != '') {
      _productCategories.clear();

      final List<ProductCategory> searchProductCategories = _allProductCategories
          .where((ProductCategory productCategory) => _checkSameSearch(productCategory, _search))
          .toList();
      _productCategories.addAll(searchProductCategories);
    }
  }

  @override
  Stream<ProductCategoryState> mapEventToState(ProductCategoryEvent event) async* {
    if (event is ProductCategoryStarted) {
      try {
        final OdataListQuery query = OdataListQuery(filter: 'IsDelete eq false', top: 10000);

        final OdataListResult<ProductCategory> result = await _productCategoryApi.gets(odataListQuery: query);

        _productCategories = result.value;
        _originProductCategories.clear();
        _originProductCategories.addAll(result.value);
        _total = result.count;
        _current = event.current;
        if (_current != null) {
          _productCategories.removeWhere((ProductCategory element) => element.id == _current.id);
        }

        for (final ProductCategory productCategory in _productCategories) {
          final List<ProductCategory> children =
              _productCategories.where((value) => value.parentId == productCategory.id).toList();
          productCategory.children = children;
        }

        _productCategories.removeWhere((ProductCategory productCategory) => productCategory.parentId != null);
        _allProductCategories.addAll(_productCategories);
        yield ProductCategoryLoadSuccess(productCategories: _productCategories, total: _total);
      } catch (e, stack) {
        _logger.e('ProductCategoryLoadFailure', e, stack);
        yield ProductCategoryLoadFailure(error: e.toString());
      }
    } else if (event is ProductCategorySearched) {
      try {
        yield ProductCategoryLoading();
        _search = event.keyword.toLowerCase().trim();

        if (_search == '') {
          _productCategories.clear();
          _productCategories.addAll(_allProductCategories);
        } else {
          _productCategories.clear();

          final List<ProductCategory> searchProductCategories = _allProductCategories
              .where((ProductCategory productCategory) => _checkSameSearch(productCategory, _search))
              .toList();
          _productCategories.addAll(searchProductCategories);
        }

        yield ProductCategoryLoadSuccess(productCategories: _productCategories, total: _total);
      } catch (e, stack) {
        _logger.e('ProductCategoryLoadFailure', e, stack);
        yield ProductCategoryLoadFailure(error: e.toString());
      }
    } else if (event is ProductCategoryDeleted) {
      try {
        yield ProductCategoryBusy();
        await _productCategoryApi.delete(event.productCategory.id);

        await refresh();

        yield ProductCategoryDeleteSuccess(productCategories: _productCategories, total: _total);
      } catch (e, stack) {
        _logger.e('ProductCategoryDeleteFailure', e, stack);
        yield ProductCategoryDeleteFailure(error: e.toString());
        yield ProductCategoryLoadSuccess(productCategories: _productCategories, total: _total);
      }
    } else if (event is ProductCategoryTemporaryDeleted) {
      try {
        yield ProductCategoryBusy();

        if (event.selectAll) {
          await _productCategoryApi.setDelete(
              _originProductCategories.map((ProductCategory productCategory) => productCategory.id).toList(), true);
        } else {
          await _productCategoryApi.setDelete(
              event.productCategories.map((ProductCategory productCategory) => productCategory.id).toList(), true);
        }

        await refresh();

        yield ProductCategoryDeleteSuccess(productCategories: _productCategories, total: _total);
      } catch (e, stack) {
        _logger.e('ProductCategoryDeleteFailure', e, stack);
        yield ProductCategoryDeleteFailure(error: e.toString());
        yield ProductCategoryLoadSuccess(productCategories: _productCategories, total: _total);
      }
    } else if (event is ProductCategoryRefreshed) {
      try {
        yield ProductCategoryBusy();

        await refresh();

        yield ProductCategoryLoadSuccess(productCategories: _productCategories, total: _total);
      } catch (e, stack) {
        _logger.e('ProductCategoryLoadFailure', e, stack);
        yield ProductCategoryLoadFailure(error: e.toString());
      }
    }
  }
}
