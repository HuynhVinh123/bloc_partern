import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/bloc/add_edit/product_attribute_line_add_edit_event.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/bloc/add_edit/product_attribute_line_add_edit_state.dart';

class ProductAttributeLineAddEditBloc extends Bloc<ProductAttributeLineAddEditEvent, ProductAttributeLineAddEditState> {
  ProductAttributeLineAddEditBloc({ProductAttributeApi productAttributeLineApi, ProductAttributeValueApi productAttributeValueApi})
      : super(ProductAttributeLineAddEditLoading()) {
    _productAttributeLineApi = productAttributeLineApi ?? GetIt.I<ProductAttributeApi>();
    _productAttributeValueApi = productAttributeValueApi ?? GetIt.I<ProductAttributeValueApi>();
  }

  ProductAttributeApi _productAttributeLineApi;
  ProductAttributeValueApi _productAttributeValueApi;
  ProductAttribute _productAttributeLine;

  final Logger _logger = Logger();

  @override
  Stream<ProductAttributeLineAddEditState> mapEventToState(ProductAttributeLineAddEditEvent event) async* {
    if (event is ProductAttributeLineAddEditStarted) {
      try {
        if (event.productAttributeLine != null && event.productAttributeLine.productAttribute != null) {
          _productAttributeLine =
              await _productAttributeLineApi.getById(event.productAttributeLine.productAttribute.id);
          _productAttributeLine.attributeValues = null;
          yield ProductAttributeLineAddEditLoadSuccess(productAttributeLine: _productAttributeLine);
        } else {
          _productAttributeLine = ProductAttribute();
          _productAttributeLine.sequence = 0;
          _productAttributeLine.name = '';
          _productAttributeLine.code = '';

          yield ProductAttributeLineAddEditLoadSuccess(productAttributeLine: _productAttributeLine);
        }
      } catch (e, stack) {
        _logger.e('ProductAttributeLineAddEditLoadFailure', e, stack);
        yield ProductAttributeLineAddEditLoadFailure(error: e.toString(), productAttributeLine: _productAttributeLine);
      }
    } else if (event is ProductAttributeLineAddEditSaved) {
      yield ProductAttributeLineAddEditBusy(productAttributeLine: _productAttributeLine);
      try {
        if (_productAttributeLine.id == null) {
          _productAttributeLine.id = (await _productAttributeLineApi.insert(event.productAttributeLine)).id;
        } else {
          _productAttributeLine = event.productAttributeLine;

          await _productAttributeLineApi.update(event.productAttributeLine);
        }

        yield ProductAttributeLineAddEditSaveSuccess(productAttributeLine: _productAttributeLine);
      } catch (e, stack) {
        _logger.e('ProductAttributeLineAddEditSaveError', e, stack);
        yield ProductAttributeLineAddEditSaveError(error: e.toString(), productAttributeLine: _productAttributeLine);
      }
    } else if (event is ProductAttributeLineAddEditUpdateLocal) {
      _productAttributeLine = event.productAttributeLine;
      yield ProductAttributeLineAddEditLoadSuccess(productAttributeLine: _productAttributeLine);
    } else if (event is ProductAttributeValueDelete) {
      yield ProductAttributeLineAddEditBusy(productAttributeLine: _productAttributeLine);
      try {

        await _productAttributeValueApi.delete(event.productAttributeLine.id);

        yield ProductAttributeValueDeleteSuccess(productAttributeLine: _productAttributeLine);
      } catch (e, stack) {
        _logger.e('ProductAttributeValueDeleteError', e, stack);
        yield ProductAttributeValueDeleteError(error: e.toString(), productAttributeLine: _productAttributeLine);
      }
    }
  }
}
