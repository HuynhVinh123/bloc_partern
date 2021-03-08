import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/bloc/add_edit/product_attribute_line_add_edit_event.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/bloc/add_edit/product_attribute_line_add_edit_state.dart';

class ProductAttributeValueAddEditBloc
    extends Bloc<ProductAttributeValueAddEditEvent, ProductAttributeValueAddEditState> {
  ProductAttributeValueAddEditBloc({ProductAttributeValueApi productAttributeValueApi})
      : super(ProductAttributeValueAddEditLoading()) {
    _productAttributeValueApi = productAttributeValueApi ?? GetIt.I<ProductAttributeValueApi>();
  }

  ProductAttributeValueApi _productAttributeValueApi;
  ProductAttributeValue _productAttributeLine;

  final Logger _logger = Logger();

  @override
  Stream<ProductAttributeValueAddEditState> mapEventToState(ProductAttributeValueAddEditEvent event) async* {
    if (event is ProductAttributeValueAddEditStarted) {
      try {
        if (event.productAttributeLine != null) {
          _productAttributeLine = await _productAttributeValueApi.getById(event.productAttributeLine.id);
          _productAttributeLine.productAttribute?.attributeValues = null;
          yield ProductAttributeValueAddEditLoadSuccess(productAttributeLine: _productAttributeLine);
        } else {
          _productAttributeLine = ProductAttributeValue();
          _productAttributeLine.sequence = 0;
          _productAttributeLine.name = '';
          _productAttributeLine.code = '';

          yield ProductAttributeValueAddEditLoadSuccess(productAttributeLine: _productAttributeLine);
        }
      } catch (e, stack) {
        _logger.e('ProductAttributeLineAddEditLoadFailure', e, stack);
        yield ProductAttributeValueAddEditLoadFailure(error: e.toString(), productAttributeLine: _productAttributeLine);
      }
    } else if (event is ProductAttributeValueAddEditSaved) {
      yield ProductAttributeValueAddEditBusy(productAttributeLine: _productAttributeLine);
      try {
        if (_productAttributeLine.id == null) {
          _productAttributeLine.id = (await _productAttributeValueApi.insert(event.productAttributeLine)).id;
        } else {
          _productAttributeLine = event.productAttributeLine;

          await _productAttributeValueApi.update(event.productAttributeLine);
        }

        yield ProductAttributeValueAddEditSaveSuccess(productAttributeLine: _productAttributeLine);
      } catch (e, stack) {
        _logger.e('ProductAttributeLineAddEditSaveError', e, stack);
        yield ProductAttributeValueAddEditSaveError(error: e.toString(), productAttributeLine: _productAttributeLine);
      }
    } else if (event is ProductAttributeValueAddEditUpdateLocal) {
      _productAttributeLine = event.productAttributeLine;
      yield ProductAttributeValueAddEditLoadSuccess(productAttributeLine: _productAttributeLine);
    } else if (event is ProductAttributeValueDelete) {
      yield ProductAttributeValueAddEditBusy(productAttributeLine: _productAttributeLine);
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
