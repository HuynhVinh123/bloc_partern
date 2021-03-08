import 'package:diacritic/diacritic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/bloc/product_attribute_line/product_attribute_line_event.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/bloc/product_attribute_line/product_attribute_line_state.dart';

class ProductAttributeLineBloc extends Bloc<ProductAttributeLineEvent, ProductAttributeLineState> {
  ProductAttributeLineBloc({ProductAttributeApi productAttributeApi, ProductAttributeValueApi productAttributeValueApi})
      : super(ProductAttributeLineLoading(productAttributes: [])) {
    _productAttributeApi = productAttributeApi ?? GetIt.I<ProductAttributeApi>();
    _productAttributeValueApi = productAttributeValueApi ?? GetIt.I<ProductAttributeValueApi>();
  }

  ProductAttributeApi _productAttributeApi;
  ProductAttributeValueApi _productAttributeValueApi;
  List<ProductAttribute> _productAttributes = [];
  final List<ProductAttributeValue> _productAttributeValues = [];
  final List<ProductAttribute> _totalProductAttributes = [];
  final Logger _logger = Logger();
  String _keyword = '';

  Future<void> _load() async {
    _totalProductAttributes.clear();
    _productAttributeValues.clear();
    final OdataListQuery query = OdataListQuery(filter: null, top: 1000, orderBy: null);
    final OdataListResult<ProductAttribute> result = await _productAttributeApi.getList(query: query);
    _productAttributes = result.value;
    _totalProductAttributes.addAll(_productAttributes);

    final GetProductAttributeForSearchQuery valueQuery =
        GetProductAttributeForSearchQuery(filter: null, keyword: '', top: 1000, skip: 0);
    final OdataListResult<ProductAttributeValue> valueResult =
        await _productAttributeValueApi.getList(query: valueQuery);
    _productAttributeValues.addAll(valueResult.value);

    for (final ProductAttribute productAttribute in _productAttributes) {
      final List<ProductAttributeValue> productAttributeValues =
          valueResult.value.where((element) => element.attributeId == productAttribute.id).toList();

      productAttribute.productAttribute = ProductAttributeValue(
          id: productAttribute.id,
          sequence: productAttribute.sequence,
          code: productAttribute.code,
          name: productAttribute.name,
          createVariant: productAttribute.createVariant);
      productAttribute.attributeValues = productAttributeValues;

      _totalProductAttributes[_productAttributes.indexOf(productAttribute)].productAttribute =
          productAttribute.productAttribute;

      _totalProductAttributes[_productAttributes.indexOf(productAttribute)].attributeValues = productAttributeValues;
    }

    if (_keyword != '') {
      _productAttributes.clear();

      _productAttributes.addAll(_totalProductAttributes
          .where((element) =>
              element.name.toLowerCase().contains(_keyword) ||
              removeDiacritics(element.name.toLowerCase()).contains(removeDiacritics(_keyword)))
          .toList());
    }
  }

  @override
  Stream<ProductAttributeLineState> mapEventToState(ProductAttributeLineEvent event) async* {
    if (event is ProductAttributeLineStarted) {
      try {
        yield ProductAttributeLineLoading(productAttributes: _productAttributes);
        _keyword = event.keyword;
        if (event.productTemplate != null) {
          _productAttributes = event.productTemplate.productAttributeLines;
        } else {
          await _load();
        }
        yield ProductAttributeLineLoadSuccess(productAttributes: _productAttributes);
      } catch (e, stack) {
        _logger.e('ProductAttributeLoadFailure', e, stack);
        yield ProductAttributeLineLoadFailure(error: e.toString(), productAttributes: _productAttributes);
      }
    } else if (event is ProductAttributeLineRefreshed) {
      try {
        yield ProductAttributeLineLoading(productAttributes: _productAttributes);
        _keyword = '';
        await _load();

        yield ProductAttributeLineLoadSuccess(productAttributes: _productAttributes);
      } catch (e, stack) {
        _logger.e('ProductAttributeLoadFailure', e, stack);
        yield ProductAttributeLineLoadFailure(error: e.toString(), productAttributes: _productAttributes);
      }
    } else if (event is ProductAttributeLineSearched) {
      try {
        yield ProductAttributeLineLoading(productAttributes: _productAttributes);
        _keyword = event.keyword;
        _productAttributes.clear();

        _productAttributes.addAll(_totalProductAttributes
            .where((element) =>
                element.name.toLowerCase().contains(_keyword) ||
                removeDiacritics(element.name.toLowerCase()).contains(removeDiacritics(_keyword)))
            .toList());

        yield ProductAttributeLineLoadSuccess(productAttributes: _productAttributes);
      } catch (e, stack) {
        _logger.e('ProductAttributeLoadFailure', e, stack);
        yield ProductAttributeLineLoadFailure(error: e.toString(), productAttributes: _productAttributes);
      }
    } else if (event is ProductAttributeInserted) {
      try {
        yield ProductAttributeLineBusy(productAttributes: _productAttributes);

        await _productAttributeApi.insert(event.productAttribute);

        yield ProductAttributeInsertSuccess(productAttributes: _productAttributes);

        ///Lấy lại dữ liệu khi thêm xong
        try {
          yield ProductAttributeLineBusy(productAttributes: _productAttributes);

          await _load();

          yield ProductAttributeLineLoadSuccess(productAttributes: _productAttributes);
        } catch (e, stack) {
          _logger.e('ProductAttributeLoadFailure', e, stack);
          yield ProductAttributeLineLoadFailure(error: e.toString(), productAttributes: _productAttributes);
        }
      } catch (e, stack) {
        _logger.e('ProductAttributeInsertFailure', e, stack);
        yield ProductAttributeInsertFailure(error: e.toString(), productAttributes: _productAttributes);
      }
    } else if (event is ProductAttributeUpdated) {
      try {
        yield ProductAttributeLineBusy(productAttributes: _productAttributes);

        await _productAttributeApi.update(event.productAttribute);

        yield ProductAttributeUpdateSuccess(productAttributes: _productAttributes);

        ///Lấy lại dữ liệu khi cập nhật xong
        try {
          await _load();

          yield ProductAttributeLineLoadSuccess(productAttributes: _productAttributes);
        } catch (e, stack) {
          _logger.e('ProductAttributeLoadFailure', e, stack);
          yield ProductAttributeLineLoadFailure(error: e.toString(), productAttributes: _productAttributes);
        }
      } catch (e, stack) {
        _logger.e('ProductAttributeUpdateFailure', e, stack);
        yield ProductAttributeUpdateFailure(error: e.toString(), productAttributes: _productAttributes);
      }
    } else if (event is ProductAttributeDeleted) {
      try {
        yield ProductAttributeLineBusy(productAttributes: _productAttributes);

        await _productAttributeApi.delete(event.productAttributeLine.productAttribute?.id);
        // event.productAttributeLine
        _productAttributes.removeWhere((element) => element.id == event.productAttributeLine.id);
        _totalProductAttributes.removeWhere((element) => element.id == event.productAttributeLine.id);

        yield ProductAttributeDeleteSuccess(productAttributes: _productAttributes);
      } catch (e, stack) {
        _logger.e('ProductAttributeDeletedFailure', e, stack);
        yield ProductAttributeDeleteFailure(error: e.toString(), productAttributes: _productAttributes);
      }
    } else if (event is ProductAttributeValueDeleted) {
      try {
        yield ProductAttributeLineBusy(productAttributes: _productAttributes);

        await _productAttributeValueApi.delete(event.productAttributeValue.id);
        _productAttributeValues.removeWhere((element) => element.id == event.productAttributeValue.id);

        for (final ProductAttribute productAttribute in _productAttributes) {
          final List<ProductAttributeValue> productAttributeValues =
              _productAttributeValues.where((element) => element.attributeId == productAttribute.id).toList();

          productAttribute.productAttribute = ProductAttributeValue(
              id: productAttribute.id,
              sequence: productAttribute.sequence,
              code: productAttribute.code,
              name: productAttribute.name,
              createVariant: productAttribute.createVariant);
          productAttribute.attributeValues = productAttributeValues;

          _totalProductAttributes[_productAttributes.indexOf(productAttribute)].productAttribute =
              productAttribute.productAttribute;

          _totalProductAttributes[_productAttributes.indexOf(productAttribute)].attributeValues =
              productAttributeValues;
        }

        if (_keyword != '') {
          _productAttributes.clear();

          _productAttributes.addAll(_totalProductAttributes
              .where((element) =>
                  element.name.toLowerCase().contains(_keyword) ||
                  removeDiacritics(element.name.toLowerCase()).contains(removeDiacritics(_keyword)))
              .toList());
        }

        yield ProductAttributeValueDeleteSuccess(productAttributes: _productAttributes);
      } catch (e, stack) {
        _logger.e('ProductAttributeDeletedFailure', e, stack);
        yield ProductAttributeDeleteFailure(error: e.toString(), productAttributes: _productAttributes);
      }
    }
  }
}
