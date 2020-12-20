import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/product_uom/bloc/add_edit/product_uom_add_edit_event.dart';
import 'package:tpos_mobile/feature_group/category/product_uom/bloc/add_edit/product_uom_add_edit_state.dart';

class ProductUomAddEditBloc extends Bloc<ProductUomAddEditEvent, ProductUomAddEditState> {
  ProductUomAddEditBloc({ProductUomApi productUomApi}) : super(ProductUomAddEditLoading()) {
    _productUomApi = productUomApi ?? GetIt.I<ProductUomApi>();
  }

  ProductUomApi _productUomApi;
  ProductUOM _productUom;
  final Logger _logger = Logger();

  @override
  Stream<ProductUomAddEditState> mapEventToState(ProductUomAddEditEvent event) async* {
    if (event is ProductUomAddEditStarted) {
      yield ProductUomAddEditLoading();
      try {
        if (event.productUom != null) {
          final OdataObjectQuery query = OdataObjectQuery(expand: 'Category');
          _productUom = await _productUomApi.getById(event.productUom.id, query: query);

          yield ProductUomAddEditLoadSuccess(productUom: _productUom);
        } else {
          _productUom = ProductUOM(
              active: true,
              rounding: 0.01,
              factor: 1,
              factorInv: 1,
              uOMType: 'reference',
              showUOMType: 'Đơn vị gốc của nhóm này');
          if (event.productUomCategory != null) {
            _productUom.categoryName = event.productUomCategory.name;
            _productUom.categoryId = event.productUomCategory.id;
            _productUom.productUomCategory = event.productUomCategory;
          }


          yield ProductUomAddEditLoadSuccess(productUom: _productUom);
        }
      } catch (e, stack) {
        _logger.e('ProductUomAddEditLoadFailure', e, stack);
        yield ProductUomAddEditLoadFailure(error: e.toString());
      }
    } else if (event is ProductUomAddEditSaved) {
      yield ProductUomAddEditBusy();
      try {
        _productUom = event.productUom;
        if (_productUom.name == '' || _productUom.name == null) {
          yield ProductUomAddEditNameError(productUom: _productUom, error: 'Tên không được để trống');
        } else {
          if (_productUom.id == null) {
            _productUom.id = (await _productUomApi.insert(_productUom)).id;
          } else {
            await _productUomApi.update(_productUom);
          }

          yield ProductUomAddEditSaveSuccess(productUom: _productUom);
        }
      } catch (e, stack) {
        _logger.e('ProductUomAddEditSaveError', e, stack);
        yield ProductUomAddEditSaveError(error: e.toString());
        yield ProductUomAddEditLoadSuccess(productUom: _productUom);
      }
    } else if (event is ProductUomAddEditUpdateLocal) {
      _productUom = event.productUom;
      yield ProductUomAddEditLoadSuccess(productUom: _productUom);
    }

    // else if (event is ProductUomAddEditDeleteTemporary) {
    //   try{
    //     await _productUomApi.setDelete([event.productUom.id], true);
    //     yield ProductUomAddEditDeleteSuccess(productUom: _productUom);
    //   }catch (e, stack) {
    //     _logger.e('ProductUomAddEditSaveError', e, stack);
    //     yield ProductUomAddEditSaveError(error: e.toString());
    //   }
    // }else if (event is ProductUomAddEditDeleted) {
    //   try{
    //     await _productUomApi.delete(event.productUom.id);
    //     yield ProductUomAddEditDeleteSuccess(productUom: _productUom);
    //   }catch (e, stack) {
    //     _logger.e('ProductUomAddEditSaveError', e, stack);
    //     yield ProductUomAddEditSaveError(error: e.toString());
    //   }
    // }
  }
}
