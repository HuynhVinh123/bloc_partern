import 'package:diacritic/diacritic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/product_category/bloc/product_category_event.dart';
import 'package:tpos_mobile/feature_group/category/product_category/bloc/product_category_state.dart';

extension ProductCategoryListExtension on List<ProductCategory> {
  List<ProductCategory> clone() {
    final List<ProductCategory> clones = [];

    for (final ProductCategory productCategory in this) {
      final ProductCategory cloneProductCategory = ProductCategory.clone(productCategory);
      clones.add(cloneProductCategory);
    }

    return clones;
  }
}

///Bloc dùng để lấy danh sách [ProductCategory] hiện có
class ProductCategoryBloc extends Bloc<ProductCategoryEvent, ProductCategoryState> {
  ProductCategoryBloc({ProductCategoryApi productCategoryApi}) : super(ProductCategoryLoading()) {
    _productCategoryApi = productCategoryApi ?? GetIt.I<ProductCategoryApi>();
  }

  ProductCategoryApi _productCategoryApi;
  List<ProductCategory> _productCategories = [];
  final List<ProductCategory> _originProductCategories = [];
  final List<ProductCategory> _allProductCategories = [];
  List<ProductCategory> _allTemporaryProductCategories = [];

  String _search = '';
  bool _filter;

  final Logger _logger = Logger();
  ProductCategory _current;
  int _total = 0;

  bool _checkSameSearch(ProductCategory productCategory, String search, bool filter) {
    if (filter != null) {
      if (productCategory.isDelete != filter) {
        bool check = false;
        final List<ProductCategory> removeList = [];
        for (final ProductCategory child in productCategory.children) {
          if (_checkSameSearch(child, search, filter)) {
            check = true;
          } else {
            removeList.add(child);
          }
        }

        if (removeList.isNotEmpty) {
          productCategory.children.removeWhere((child) => removeList.any((element) => child.id == element.id));
        }

        return check;
      }

      // else {
      //   filterChild(productCategory);
      // }
    }

    if (search == '') {
      return true;
    }

    if (removeDiacritics(productCategory.name.toLowerCase()).contains(search)) {
      ///Xóa các child của root nếu không thỏa điều kiện lọc
      // filterChild(productCategory);
      return true;
    }

    if (productCategory.children.isNotEmpty) {
      for (final ProductCategory child in productCategory.children) {
        return _checkSameSearch(child, search, filter);
      }
    }

    return false;
  }

  void filterChild(ProductCategory productCategory, String search, bool filter) {
    final List<ProductCategory> removeList = [];
    for (final ProductCategory child in productCategory.children) {
      if (_checkSameSearch(child, search, filter)) {
        filterChild(child, search, filter);
      } else {
        removeList.add(child);
      }
    }

    if (removeList.isNotEmpty) {
      productCategory.children.removeWhere((child) => removeList.any((element) => child.id == element.id));
    }
  }

  Future<void> refresh() async {
    _allProductCategories.clear();

    final OdataListQuery query = OdataListQuery(filter: null, top: 10000);

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

    _productCategories.clear();

    final List<ProductCategory> tempResult = _allProductCategories.clone();
    final List<ProductCategory> tempSelect = _originProductCategories.clone();

    _allTemporaryProductCategories =
        tempSelect.where((ProductCategory productCategory) => _checkSameSearch(productCategory, '', _filter)).toList();

    final List<ProductCategory> searchProductCategories = tempResult
        .where((ProductCategory productCategory) => _checkSameSearch(productCategory, _search, _filter))
        .toList();
    _productCategories.addAll(searchProductCategories);
  }

  @override
  Stream<ProductCategoryState> mapEventToState(ProductCategoryEvent event) async* {
    if (event is ProductCategoryStarted) {
      try {
        final OdataListQuery query = OdataListQuery(filter: null, top: 10000);

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
        _allTemporaryProductCategories = _originProductCategories.clone();
        yield ProductCategoryLoadSuccess(
            productCategories: _productCategories, total: _total, allProductCategories: _allTemporaryProductCategories);
      } catch (e, stack) {
        _logger.e('ProductCategoryLoadFailure', e, stack);
        yield ProductCategoryLoadFailure(error: e.toString());
      }
    } else if (event is ProductCategorySearched) {
      try {
        yield ProductCategoryLoading();
        _search = removeDiacritics(event.keyword.toLowerCase().trim());

        _productCategories.clear();

        final List<ProductCategory> temp = _allProductCategories.clone();

        final List<ProductCategory> searchProductCategories = temp
            .where((ProductCategory productCategory) => _checkSameSearch(productCategory, _search, _filter))
            .toList();
        _productCategories.addAll(searchProductCategories);

        yield ProductCategoryLoadSuccess(
            productCategories: _productCategories, total: _total, allProductCategories: _allTemporaryProductCategories);
      } catch (e, stack) {
        _logger.e('ProductCategoryLoadFailure', e, stack);
        yield ProductCategoryLoadFailure(error: e.toString());
      }
    } else if (event is ProductCategoryDeleted) {
      try {
        yield ProductCategoryBusy();
        await _productCategoryApi.delete(event.productCategory.id);

        _allProductCategories.removeWhere((element) => element.id == event.productCategory.id);

        _allTemporaryProductCategories.removeWhere((element) => element.id == event.productCategory.id);

        _productCategories.clear();

        final List<ProductCategory> temp = _allProductCategories.clone();

        final List<ProductCategory> searchProductCategories = temp
            .where((ProductCategory productCategory) => _checkSameSearch(productCategory, _search, _filter))
            .toList();

        _productCategories.addAll(searchProductCategories);

        yield ProductCategoryDeleteSuccess(
            productCategories: _productCategories,
            total: _total,
            allProductCategories: _allTemporaryProductCategories,
            productCategory: event.productCategory);
      } catch (e, stack) {
        _logger.e('ProductCategoryDeleteFailure', e, stack);
        yield ProductCategoryDeleteFailure(error: e.toString());
        // yield ProductCategoryLoadSuccess(productCategories: _productCategories, total: _total, allProductCategories: _allTemporaryProductCategories);
      }
    } else if (event is ProductCategoryTemporaryDeleted) {
      try {
        yield ProductCategoryBusy();

        if (event.selectAll) {
          await _productCategoryApi.setDelete(
              _originProductCategories.map((ProductCategory productCategory) => productCategory.id).toList(),
              event.isDelete);
        } else {
          await _productCategoryApi.setDelete(
              event.productCategories.map((ProductCategory productCategory) => productCategory.id).toList(),
              event.isDelete);
        }

        await refresh();

        yield ProductCategoryDeleteTemporarySuccess(
            productCategories: _productCategories, total: _total, allProductCategories: _allTemporaryProductCategories);
      } catch (e, stack) {
        _logger.e('ProductCategoryDeleteFailure', e, stack);
        yield ProductCategoryDeleteFailure(error: e.toString());
        // yield ProductCategoryLoadSuccess(productCategories: _productCategories, total: _total, allProductCategories: _allTemporaryProductCategories);
      }
    } else if (event is ProductCategoryRefreshed) {
      try {
        yield ProductCategoryBusy();

        await refresh();

        yield ProductCategoryLoadSuccess(
            productCategories: _productCategories, total: _total, allProductCategories: _allTemporaryProductCategories);
      } catch (e, stack) {
        _logger.e('ProductCategoryLoadFailure', e, stack);
        yield ProductCategoryLoadFailure(error: e.toString());
      }
    } else if (event is ProductCategoryFiltered) {
      _filter = event.filter;

      _productCategories.clear();

      final List<ProductCategory> tempResult = _allProductCategories.clone();
      final List<ProductCategory> tempSelect = _originProductCategories.clone();

      final List<ProductCategory> searchProductCategories = tempResult
          .where((ProductCategory productCategory) => _checkSameSearch(productCategory, _search, _filter))
          .toList();
      _productCategories.addAll(searchProductCategories);

      _allTemporaryProductCategories = tempSelect
          .where((ProductCategory productCategory) => _checkSameSearch(productCategory, '', _filter))
          .toList();

      yield ProductCategoryFilterSuccess(
          productCategories: _productCategories, total: _total, allProductCategories: _allTemporaryProductCategories);
    }
  }
}
