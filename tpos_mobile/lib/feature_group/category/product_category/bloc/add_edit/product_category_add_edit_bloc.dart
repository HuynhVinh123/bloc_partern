import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/product_category/bloc/add_edit/product_category_add_edit_event.dart';
import 'package:tpos_mobile/feature_group/category/product_category/bloc/add_edit/product_category_add_edit_state.dart';

class ProductCategoryAddEditBloc extends Bloc<ProductCategoryAddEditEvent, ProductCategoryAddEditState> {
  ProductCategoryAddEditBloc({ProductCategoryApi productCategoryApi}) : super(ProductCategoryAddEditLoading()) {
    _productCategoryApi = productCategoryApi ?? GetIt.I<ProductCategoryApi>();
  }

  ProductCategoryApi _productCategoryApi;
  ProductCategory _productCategory;
  final Logger _logger = Logger();

  @override
  Stream<ProductCategoryAddEditState> mapEventToState(ProductCategoryAddEditEvent event) async* {
    if (event is ProductCategoryAddEditStarted) {
      yield ProductCategoryAddEditLoading();
      try {
        if (event.productCategory != null) {
          final OdataObjectQuery query = OdataObjectQuery(
              expand:
                  'Parent,StockAccountInputCateg,StockAccountOutputCateg,StockValuationAccount,StockJournal,AccountIncomeCateg,AccountExpenseCateg,Routes');
          _productCategory = await _productCategoryApi.getById(event.productCategory.id, query: query);

          yield ProductCategoryAddEditLoadSuccess(productCategory: _productCategory);
        } else {
          _productCategory = await _productCategoryApi.getDefault();
          _productCategory.id = 0;

          yield ProductCategoryAddEditLoadSuccess(productCategory: _productCategory);
        }
      } catch (e, stack) {
        _logger.e('ProductCategoryAddEditLoadFailure', e, stack);
        yield ProductCategoryAddEditLoadFailure(error: e.toString());
      }
    } else if (event is ProductCategoryAddEditSaved) {
      yield ProductCategoryAddEditBusy();
      try {
        _productCategory = event.productCategory;
        if (_productCategory.name == '' || _productCategory.name == null) {
          yield ProductCategoryAddEditNameError(productCategory: _productCategory, error: 'Tên không được để trống');
        } else {
          if (_productCategory.id == 0) {
            _productCategory.id = (await _productCategoryApi.insert(_productCategory)).id;
          } else {
            await _productCategoryApi.update(_productCategory);
          }

          yield ProductCategoryAddEditSaveSuccess(productCategory: _productCategory);
        }
      } catch (e, stack) {
        _logger.e('ProductCategoryAddEditSaveError', e, stack);
        yield ProductCategoryAddEditSaveError(error: e.toString());
        yield ProductCategoryAddEditLoadSuccess(productCategory: _productCategory);
      }
    } else if (event is ProductCategoryAddEditUpdateLocal) {
      _productCategory = event.productCategory;
      yield ProductCategoryAddEditLoadSuccess(productCategory: _productCategory);
    } else if (event is ProductCategoryAddEditDeleteTemporary) {
      try {
        yield ProductCategoryAddEditBusy();
        await _productCategoryApi.setDelete([event.productCategory.id], true);
        yield ProductCategoryAddEditDeleteSuccess(productCategory: _productCategory);
      } catch (e, stack) {
        _logger.e('ProductCategoryAddEditSaveError', e, stack);
        yield ProductCategoryAddEditSaveError(error: e.toString());
        yield ProductCategoryAddEditLoadSuccess(productCategory: _productCategory);
      }
    } else if (event is ProductCategoryAddEditDeleted) {
      try {
        yield ProductCategoryAddEditBusy();
        await _productCategoryApi.delete(event.productCategory.id);
        yield ProductCategoryAddEditDeleteSuccess(productCategory: _productCategory);
      } catch (e, stack) {
        _logger.e('ProductCategoryAddEditSaveError', e, stack);
        yield ProductCategoryAddEditSaveError(error: e.toString());
        yield ProductCategoryAddEditLoadSuccess(productCategory: _productCategory);
      }
    }
  }
}
