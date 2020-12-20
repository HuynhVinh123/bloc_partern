import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tmt_flutter_untils/sources/string_utils/string_utils.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/product_template_event.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/product_template_state.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/tpos_service/odata_filter.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/src/tpos_apis/models/product_search_order_by.dart';

class ProductTemplateBloc
    extends Bloc<ProductTemplateEvent, ProductTemplateState> {
  ProductTemplateBloc(
      {ProductTemplateApi productTemplateApi,
      PriceListApi priceListApi,
      TagPartnerApi tagPartnerApi,
      int pageSize = 20})
      : super(ProductTemplateLoading(
            isFilterTag: false,
            productPrices: [],
            tags: [],
            isFilterCategory: false,
            productTemplates: [],
            filterTags: [],
            isFilterProductPrice: false,
            productCategories: [],
            productTemplateExecutes: [])) {
    _productTemplateApi = productTemplateApi ?? GetIt.I<ProductTemplateApi>();
    _priceListApi = priceListApi ?? GetIt.I<PriceListApi>();

    _tagPartnerApi = tagPartnerApi ?? GetIt.I<TagPartnerApi>();
    _pageSize = pageSize;
    _orderBy = BaseListOrderBy.NAME_ASC;
  }

  final List<ProductCategory> _filterProductCategories = <ProductCategory>[];
  List<ProductTemplate> _productTemplates = <ProductTemplate>[];
  final List<ProductTemplate> _productTemplateExecutes = <ProductTemplate>[];
  final List<Tag> _filterTags = <Tag>[];

  List<Tag> _tags = <Tag>[];
  ProductTemplateApi _productTemplateApi;
  PriceListApi _priceListApi;
  OdataFilter _filter;
  TagPartnerApi _tagPartnerApi;

  bool _isFilterByCategory = false;
  bool _isFilterByPriceList = false;
  bool _isFilterByTag = false;
  bool _selectedAll = false;
  final Logger _logger = Logger();
  int _pageSize;
  OdataSortItem _sort;
  List<ProductPrice> _productPrices = <ProductPrice>[];

  String _keyWord;

  BaseListOrderBy _orderBy;
  ProductPrice _productPrice;

  int _total = 0;

  @override
  Stream<ProductTemplateState> mapEventToState(
      ProductTemplateEvent event) async* {
    if (event is ProductTemplateStarted) {
      yield ProductTemplateLoading()..copyWith(state);
      yield* mapEventToProductTemplateStarted(event);
    } else if (event is ProductTemplateFiltered) {
      yield* mapEventToProductTemplateFiltered(event);
    } else if (event is ProductTemplateSorted) {
      yield ProductTemplateBusy()..copyWith(state);
      yield* mapEventToProductTemplateSorted(event);
    } else if (event is ProductTemplateLoadedMore) {
      yield* mapEventToProductTemplateLoadedMore(event);
    } else if (event is ProductTemplateSearched) {
      yield ProductTemplateBusy()..copyWith(state);
      yield* mapEventToProductTemplateSearched(event);
    } else if (event is ProductTemplateRefreshed) {
      yield ProductTemplateLoading()..copyWith(state);
      yield* mapEventToProductTemplateRefreshed(event);
    } else if (event is ProductTemplateExecuteAdded) {
      _productTemplateExecutes.add(event.productTemplate);
      yield ProductTemplateLoadSuccess(
          productTemplates: _productTemplates,
          filterTags: _filterTags,
          orderBy: _orderBy,
          productPrice: _productPrice,
          productCategories: _filterProductCategories,
          isFilterCategory: _isFilterByCategory,
          isFilterProductPrice: _isFilterByPriceList,
          isFilterTag: _isFilterByTag,
          tags: _tags,
          productPrices: _productPrices,
          productTemplateExecutes: _productTemplateExecutes,
          selectedAll: _selectedAll);
    } else if (event is ProductTemplateExecuteRemoved) {
      _productTemplateExecutes.removeWhere((ProductTemplate productTemplate) =>
          productTemplate.id == event.productTemplate.id);
      yield ProductTemplateLoadSuccess(
          productTemplates: _productTemplates,
          filterTags: _filterTags,
          orderBy: _orderBy,
          productPrice: _productPrice,
          productCategories: _filterProductCategories,
          isFilterCategory: _isFilterByCategory,
          isFilterProductPrice: _isFilterByPriceList,
          isFilterTag: _isFilterByTag,
          tags: _tags,
          productPrices: _productPrices,
          productTemplateExecutes: _productTemplateExecutes,
          selectedAll: _selectedAll);
    } else if (event is ProductTemplateDeleteSelected) {
      if (_selectedAll) {
        try {
          yield ProductTemplateBusy()..copyWith(state);
          await _productTemplateApi.deletes(_productTemplates
              .map((ProductTemplate productTemplate) => productTemplate.id)
              .toList());
          _total -= _productTemplates.length;

          _productTemplates.clear();
          _productTemplateExecutes.clear();

          yield ProductTemplateDeleteSuccess(
              productTemplates: _productTemplates,
              filterTags: _filterTags,
              orderBy: _orderBy,
              productPrice: _productPrice,
              productCategories: _filterProductCategories,
              isFilterCategory: _isFilterByCategory,
              isFilterProductPrice: _isFilterByPriceList,
              isFilterTag: _isFilterByTag,
              tags: _tags,
              productPrices: _productPrices,
              productTemplateExecutes: _productTemplateExecutes,
              selectedAll: _selectedAll);
        } catch (e, stack) {
          _logger.e('ProductTemplateDeleteFailure', e, stack);
          yield ProductTemplateDeleteFailure(error: e.toString())
            ..copyWith(state);
        }
      } else if (_productTemplateExecutes.isNotEmpty) {
        try {
          yield ProductTemplateBusy()..copyWith(state);
          await _productTemplateApi.deletes(_productTemplateExecutes
              .map((ProductTemplate productTemplate) => productTemplate.id)
              .toList());

          _total -= _productTemplateExecutes.length;
          for (final ProductTemplate productTemplate
              in _productTemplateExecutes) {
            _productTemplates.removeWhere(
                (ProductTemplate item) => item.id == productTemplate.id);
          }

          _productTemplateExecutes.clear();
          yield ProductTemplateDeleteSuccess(
              productTemplates: _productTemplates,
              filterTags: _filterTags,
              orderBy: _orderBy,
              productPrice: _productPrice,
              productCategories: _filterProductCategories,
              isFilterCategory: _isFilterByCategory,
              isFilterProductPrice: _isFilterByPriceList,
              isFilterTag: _isFilterByTag,
              tags: _tags,
              productPrices: _productPrices,
              productTemplateExecutes: _productTemplateExecutes,
              selectedAll: _selectedAll);
        } catch (e, stack) {
          _logger.e('ProductTemplateDeleteFailure', e, stack);
          yield ProductTemplateDeleteFailure(error: e.toString())
            ..copyWith(state);
        }
      }
    } else if (event is ProductTemplateFilterAdded) {
      _filterTags.clear();
      _filterTags.addAll(event.filterTags);
      _filterProductCategories.clear();
      _filterProductCategories.addAll(event.productCategories);
      _productPrice = event.productPrice;
    } else if (event is ProductTemplateSelectAll) {
      _selectedAll = event.check;
      yield ProductTemplateLoadSuccess(
          productTemplates: _productTemplates,
          filterTags: _filterTags,
          orderBy: _orderBy,
          productPrice: _productPrice,
          productCategories: _filterProductCategories,
          isFilterCategory: _isFilterByCategory,
          isFilterProductPrice: _isFilterByPriceList,
          isFilterTag: _isFilterByTag,
          tags: _tags,
          productPrices: _productPrices,
          productTemplateExecutes: _productTemplateExecutes,
          selectedAll: _selectedAll);
    } else if (event is ProductTemplateRemoved) {
      try {
        yield ProductTemplateBusy()..copyWith(state);
        await _productTemplateApi.delete(event.productTemplate.id);
        _productTemplateExecutes.remove(event.productTemplate);
        _productTemplates.remove(event.productTemplate);
        _total -= 1;
        yield ProductTemplateDeleteSuccess(
            productTemplates: _productTemplates,
            filterTags: _filterTags,
            orderBy: _orderBy,
            productPrice: _productPrice,
            productCategories: _filterProductCategories,
            isFilterCategory: _isFilterByCategory,
            isFilterProductPrice: _isFilterByPriceList,
            isFilterTag: _isFilterByTag,
            tags: _tags,
            productPrices: _productPrices,
            productTemplateExecutes: _productTemplateExecutes,
            selectedAll: _selectedAll);
      } catch (e, stack) {
        _logger.e('ProductTemplateDeleteFailure', e, stack);
        yield ProductTemplateDeleteFailure(error: e.toString())
          ..copyWith(state);
      }
    }
  }

  void updateFilter() {
    _filter = OdataFilter(logic: 'and', filters: <FilterBase>[
      // Tìm kiếm theo tên, hoặc mã
      if (_keyWord != null && _keyWord != '')
        OdataFilter(logic: 'or', filters: <OdataFilterItem>[
          OdataFilterItem(field: 'Name', operator: 'contains', value: _keyWord),
          OdataFilterItem(
              field: 'NameNoSign', operator: 'contains', value: _keyWord),
          OdataFilterItem(
              field: 'Barcode', operator: 'contains', value: _keyWord),
          OdataFilterItem(
              field: 'DefaultCode', operator: 'contains', value: _keyWord),
        ]),
      // OdataFilterItem(field: 'Active', operator: 'eq', value: true),
      if (_filterProductCategories.isNotEmpty && _isFilterByCategory)
        OdataFilter(logic: 'or', filters: <OdataFilterItem>[
          ..._filterProductCategories.map(
            (f) =>
                OdataFilterItem(field: 'CategId', operator: 'eq', value: f.id),
          )
        ])
      // Lọc theo nhóm sản phẩm
      // Lọc theo bảng giá
    ]);

    if (_filter.filters.isEmpty) {
      _filter = null;
    }
  }

  void updateSort() {
    _sort = OdataSortItem(field: "DateCreated", dir: "asc");

    if (_sort != null) {
      if (_orderBy == BaseListOrderBy.NAME_ASC) {
        _sort.field = "Name";
        _sort.dir = "asc";
      } else if (_orderBy == BaseListOrderBy.NAME_DESC) {
        _sort.field = "Name";
        _sort.dir = "desc";
      } else if (_orderBy == BaseListOrderBy.PRICE_ASC) {
        _sort.field = "ListPrice";
        _sort.dir = "asc";
      } else if (_orderBy == BaseListOrderBy.PRICE_DESC) {
        _sort.field = "ListPrice";
        _sort.dir = "desc";
      } else if (_orderBy == BaseListOrderBy.DATE_CREATED_INCREASE) {
        _sort.field = "DateCreated";
        _sort.dir = "asc";
      } else if (_orderBy == BaseListOrderBy.DATE_CREATED_DECREASE) {
        _sort.field = "DateCreated";
        _sort.dir = "desc";
      }
    }
  }

  Stream<ProductTemplateState> mapEventToProductTemplateStarted(
      ProductTemplateStarted event) async* {
    try {
      _orderBy = BaseListOrderBy.DATE_CREATED_DECREASE;
      _keyWord = event.search;
      updateFilter();
      updateSort();
      final GetProductTemplateQuery query = GetProductTemplateQuery(
        filter: _filter?.toJson(),
        skip: 0,
        sort: _sort.toJson(),
        take: _pageSize,
      );

      final List<String> tagIdList = _isFilterByTag
          ? _filterTags.map((Tag tag) => tag.id.toString()).toList()
          : null;

      final String tagIds = tagIdList != null
          ? _filterTags.isNotEmpty
              ? tagIdList.join(',')
              : null
          : null;
      final int priceId = _isFilterByPriceList
          ? _productPrice != null
              ? _productPrice.id
              : null
          : null;

      final GetProductTemplateResult result = await _productTemplateApi.getList(
          priceId: priceId, tagIds: tagIds, query: query);
      _total = result.total;
      _productTemplates = result.data;
      final OdataListResult<Tag> odataListResult =
          await _tagPartnerApi.getTagsByType('producttemplate');
      _tags = odataListResult.value;
      final priceListResult =
          await _priceListApi.getPriceListAvailable(data: DateTime.now());

      _productPrices = priceListResult.value;
      yield ProductTemplateLoadSuccess(
          productTemplates: _productTemplates,
          filterTags: _filterTags,
          orderBy: _orderBy,
          productPrice: _productPrice,
          productCategories: _filterProductCategories,
          isFilterCategory: _isFilterByCategory,
          isFilterProductPrice: _isFilterByPriceList,
          isFilterTag: _isFilterByTag,
          tags: _tags,
          productPrices: _productPrices,
          productTemplateExecutes: _productTemplateExecutes,
          selectedAll: _selectedAll);
    } catch (e, stack) {
      _logger.e('ProductTemplateLoadFailure', e, stack);
      yield ProductTemplateLoadFailure(error: e.toString())..copyWith(state);
    }
  }

  Stream<ProductTemplateState> mapEventToProductTemplateRefreshed(
      ProductTemplateRefreshed event) async* {
    try {
      updateFilter();
      final GetProductTemplateQuery query = GetProductTemplateQuery(
        filter: _filter?.toJson(),
        skip: 0,
        sort: _sort.toJson(),
        take: _pageSize,
      );

      final List<String> tagIdList = _isFilterByTag
          ? _filterTags.map((Tag tag) => tag.id.toString()).toList()
          : null;

      final String tagIds = tagIdList != null
          ? _filterTags.isNotEmpty
              ? tagIdList.join(',')
              : null
          : null;
      final int priceId = _isFilterByPriceList
          ? _productPrice != null
              ? _productPrice.id
              : null
          : null;

      final GetProductTemplateResult result = await _productTemplateApi.getList(
          priceId: priceId, tagIds: tagIds, query: query);
      _total = result.total;
      _productTemplates = result.data;
      yield ProductTemplateLoadSuccess(
          productTemplates: _productTemplates,
          filterTags: _filterTags,
          orderBy: _orderBy,
          productPrice: _productPrice,
          productCategories: _filterProductCategories,
          isFilterCategory: _isFilterByCategory,
          isFilterProductPrice: _isFilterByPriceList,
          isFilterTag: _isFilterByTag,
          tags: _tags,
          productPrices: _productPrices,
          productTemplateExecutes: _productTemplateExecutes,
          selectedAll: _selectedAll);
    } catch (e, stack) {
      _logger.e('ProductTemplateLoadFailure', e, stack);
      yield ProductTemplateLoadFailure(error: e.toString())..copyWith(state);
    }
  }

  Stream<ProductTemplateState> mapEventToProductTemplateSearched(
      ProductTemplateSearched event) async* {
    try {
      _productTemplateExecutes.clear();
      _keyWord =
          StringUtils.removeVietnameseMark(event.search.toLowerCase() ?? '');
      updateFilter();
      updateSort();
      final GetProductTemplateQuery query = GetProductTemplateQuery(
        filter: _filter?.toJson(),
        skip: 0,
        sort: _sort.toJson(),
        take: _pageSize,
      );

      final List<String> tagIdList = _isFilterByTag
          ? _filterTags.map((Tag tag) => tag.id.toString()).toList()
          : null;

      final String tagIds = tagIdList != null
          ? _filterTags.isNotEmpty
              ? tagIdList.join(',')
              : null
          : null;
      final int priceId = _isFilterByPriceList
          ? _productPrice != null
              ? _productPrice.id
              : null
          : null;

      final GetProductTemplateResult result = await _productTemplateApi.getList(
          priceId: priceId, tagIds: tagIds, query: query);
      _total = result.total;
      _productTemplates = result.data;

      yield ProductTemplateLoadSuccess(
          productTemplates: _productTemplates,
          filterTags: _filterTags,
          orderBy: _orderBy,
          productPrice: _productPrice,
          productCategories: _filterProductCategories,
          isFilterCategory: _isFilterByCategory,
          isFilterProductPrice: _isFilterByPriceList,
          isFilterTag: _isFilterByTag,
          tags: _tags,
          productPrices: _productPrices,
          productTemplateExecutes: _productTemplateExecutes,
          selectedAll: _selectedAll);
    } catch (e, stack) {
      _logger.e('ProductTemplateLoadFailure', e, stack);
      yield ProductTemplateLoadFailure(error: e.toString())..copyWith(state);
    }
  }

  Stream<ProductTemplateState> mapEventToProductTemplateSorted(
      ProductTemplateSorted event) async* {
    try {
      _productTemplateExecutes.clear();

      _orderBy = event.orderBy;
      updateSort();
      // updateFilter();
      final GetProductTemplateQuery query = GetProductTemplateQuery(
        filter: _filter?.toJson(),
        skip: 0,
        sort: _sort.toJson(),
        take: _pageSize,
      );

      final List<String> tagIdList = _isFilterByTag
          ? _filterTags.map((Tag tag) => tag.id.toString()).toList()
          : null;

      final String tagIds = tagIdList != null
          ? _filterTags.isNotEmpty
              ? tagIdList.join(',')
              : null
          : null;
      final int priceId = _isFilterByPriceList
          ? _productPrice != null
              ? _productPrice.id
              : null
          : null;

      final GetProductTemplateResult result = await _productTemplateApi.getList(
          priceId: priceId, tagIds: tagIds, query: query);
      _total = result.total;
      _productTemplates = result.data;
      yield ProductTemplateLoadSuccess(
          productTemplates: _productTemplates,
          filterTags: _filterTags,
          orderBy: _orderBy,
          productPrice: _productPrice,
          productCategories: _filterProductCategories,
          isFilterCategory: _isFilterByCategory,
          isFilterProductPrice: _isFilterByPriceList,
          isFilterTag: _isFilterByTag,
          tags: _tags,
          productPrices: _productPrices,
          productTemplateExecutes: _productTemplateExecutes,
          selectedAll: _selectedAll);
    } catch (e, stack) {
      _logger.e('ProductTemplateLoadFailure', e, stack);
      yield ProductTemplateLoadFailure(error: e.toString())..copyWith(state);
    }
  }

  Stream<ProductTemplateState> mapEventToProductTemplateFiltered(
      ProductTemplateFiltered event) async* {
    try {
      _isFilterByTag = event.isFilterByTag;
      _isFilterByCategory = event.isFilterByCategory;
      _isFilterByPriceList = event.isFilterByProductPrice;
      yield ProductTemplateBusy(
          productTemplates: _productTemplates,
          filterTags: _filterTags,
          orderBy: _orderBy,
          productPrice: _productPrice,
          productCategories: _filterProductCategories,
          isFilterCategory: _isFilterByCategory,
          isFilterProductPrice: _isFilterByPriceList,
          isFilterTag: _isFilterByTag,
          tags: _tags,
          productPrices: _productPrices,
          productTemplateExecutes: _productTemplateExecutes,
          selectedAll: _selectedAll);
      _productTemplateExecutes.clear();
      updateFilter();

      final GetProductTemplateQuery query = GetProductTemplateQuery(
        filter: _filter?.toJson(),
        skip: 0,
        sort: _sort.toJson(),
        take: _pageSize,
      );

      final List<String> tagIdList = _isFilterByTag
          ? _filterTags.map((Tag tag) => tag.id.toString()).toList()
          : null;

      final String tagIds = tagIdList != null
          ? _filterTags.isNotEmpty
              ? tagIdList.join(',')
              : null
          : null;
      final int priceId = _isFilterByPriceList
          ? _productPrice != null
              ? _productPrice.id
              : null
          : null;

      final GetProductTemplateResult result = await _productTemplateApi.getList(
          priceId: priceId, tagIds: tagIds, query: query);
      _total = result.total;
      _productTemplates = result.data;
      yield ProductTemplateLoadSuccess(
          productTemplates: _productTemplates,
          filterTags: _filterTags,
          orderBy: _orderBy,
          productPrice: _productPrice,
          productCategories: _filterProductCategories,
          isFilterCategory: _isFilterByCategory,
          isFilterProductPrice: _isFilterByPriceList,
          isFilterTag: _isFilterByTag,
          tags: _tags,
          productPrices: _productPrices,
          productTemplateExecutes: _productTemplateExecutes,
          selectedAll: _selectedAll);
    } catch (e, stack) {
      _logger.e('ProductTemplateLoadFailure', e, stack);
      yield ProductTemplateLoadFailure(error: e.toString())..copyWith(state);
    }
  }

  Stream<ProductTemplateState> mapEventToProductTemplateLoadedMore(
      ProductTemplateLoadedMore event) async* {
    try {
      if (_productTemplates.length < _total) {
        final GetProductTemplateQuery query = GetProductTemplateQuery(
          filter: _filter?.toJson(),
          skip: _productTemplates.length,
          sort: _sort.toJson(),
          take: _pageSize,
        );

        final List<String> tagIdList = _isFilterByTag
            ? _filterTags.map((Tag tag) => tag.id.toString()).toList()
            : null;

        final String tagIds = tagIdList != null
            ? _filterTags.isNotEmpty
                ? tagIdList.join(',')
                : null
            : null;
        final int priceId = _isFilterByPriceList
            ? _productPrice != null
                ? _productPrice.id
                : null
            : null;
        final GetProductTemplateResult result = await _productTemplateApi
            .getList(priceId: priceId, tagIds: tagIds, query: query);
        _total = result.total;
        _productTemplates.addAll(result.data);

        yield ProductTemplateLoadSuccess(
            productTemplates: _productTemplates,
            filterTags: _filterTags,
            orderBy: _orderBy,
            productPrice: _productPrice,
            productCategories: _filterProductCategories,
            isFilterCategory: _isFilterByCategory,
            isFilterProductPrice: _isFilterByPriceList,
            isFilterTag: _isFilterByTag,
            tags: _tags,
            productPrices: _productPrices,
            productTemplateExecutes: _productTemplateExecutes,
            selectedAll: _selectedAll);
      } else {
        yield ProductTemplateLoadNoMore(
            productTemplates: _productTemplates,
            filterTags: _filterTags,
            orderBy: _orderBy,
            productPrice: _productPrice,
            productCategories: _filterProductCategories,
            isFilterCategory: _isFilterByCategory,
            isFilterProductPrice: _isFilterByPriceList,
            isFilterTag: _isFilterByTag,
            tags: _tags,
            productPrices: _productPrices,
            productTemplateExecutes: _productTemplateExecutes,
            selectedAll: _selectedAll);
      }
    } catch (e, stack) {
      _logger.e('ProductTemplateLoadFailure', e, stack);
      yield ProductTemplateLoadFailure(error: e.toString())..copyWith(state);
    }
  }
}
