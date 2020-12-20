import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/add_edit/product_template_add_edit_event.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/add_edit/product_template_add_edit_state.dart';

class ProductTemplateAddEditBloc extends Bloc<ProductTemplateAddEditEvent, ProductTemplateAddEditState> {
  ProductTemplateAddEditBloc(
      {ProductTemplateApi productTemplateApi, CommonApi commonApi, ProductAttributeApi productAttributeLineApi})
      : super(ProductTemplateAddEditLoading()) {
    _productTemplateApi = productTemplateApi ?? GetIt.I<ProductTemplateApi>();
    _productAttributeLineApi = productAttributeLineApi ?? GetIt.I<ProductAttributeApi>();
    _commonApi = commonApi ?? GetIt.I<CommonApi>();
  }

  ProductTemplateApi _productTemplateApi;
  ProductTemplate _productTemplate;
  CommonApi _commonApi;
  ProductAttributeApi _productAttributeLineApi;
  final Logger _logger = Logger();

  @override
  Stream<ProductTemplateAddEditState> mapEventToState(ProductTemplateAddEditEvent event) async* {
    if (event is ProductTemplateAddEditStarted) {
      yield ProductTemplateAddEditLoading();
      try {
        if (event.productTemplate != null) {
          _productTemplate = await _productTemplateApi.getById(event.productTemplate.id,
              'UOM,UOMCateg,Categ,UOMPO,POSCateg,Taxes,SupplierTaxes,Product_Teams,Images,UOMView,Distributor,Importer,Producer,OriginCountry');

          ///lấy danh sách productAttributeLines
          _productTemplate.productAttributeLines =
              (await _productAttributeLineApi.getProductAttributeLineList(event.productTemplate.id, 'Attribute,Values'))
                  .value;

          yield ProductTemplateAddEditLoadSuccess(productTemplate: _productTemplate);
        } else {
          _productTemplate = await _productTemplateApi.getDefault('UOM,Categ,UOMPO');
          _productTemplate.id = 0;
          _productTemplate.discountSale = null;
          _productTemplate.discountPurchase = null;

          yield ProductTemplateAddEditLoadSuccess(productTemplate: _productTemplate);
        }
      } catch (e, stack) {
        _logger.e('ProductTemplateAddEditLoadFailure', e, stack);
        yield ProductTemplateAddEditLoadFailure(error: e.toString(), productTemplate: _productTemplate);
      }
    } else if (event is ProductTemplateAddEditSaved) {
      yield ProductTemplateAddEditBusy(productTemplate: _productTemplate);
      try {
        if (_productTemplate.name == '' || _productTemplate.name == null) {
          yield ProductTemplateAddEditNameError(productTemplate: _productTemplate, error: 'Tên không được để trống');
        } else {
          if (_productTemplate.id == 0) {
            _productTemplate.id = (await _productTemplateApi.insert(_productTemplate)).id;
          } else {
            await _productTemplateApi.update(_productTemplate);
          }

          yield ProductTemplateAddEditSaveSuccess(productTemplate: _productTemplate);
        }
      } catch (e, stack) {
        _logger.e('ProductTemplateAddEditSaveError', e, stack);
        yield ProductTemplateAddEditSaveError(error: e.toString(), productTemplate: _productTemplate);
        yield ProductTemplateAddEditLoadSuccess(productTemplate: _productTemplate);
      }
    } else if (event is ProductTemplateAddEditUploadImage) {
      try {
        yield ProductTemplateAddEditBusy(productTemplate: _productTemplate);
        final List<int> imageBytes = event.file.readAsBytesSync();
        final String base64Image = base64Encode(imageBytes);

        if ((_productTemplate.imageUrl == null || _productTemplate.imageUrl == '') &&
            (_productTemplate.image == '' || _productTemplate.image == null)) {
          _productTemplate.image = base64Image;
          _productTemplate.imageBytes = imageBytes;
        } else {
          final String fileName = event.file.path.split('/').last;
          final String imageUrl = await _commonApi.uploadImage(base64Image, fileName);

          final ProductImage productImage = ProductImage(
            type: 'url',
            name: fileName,
            mineType: 'image/${fileName.split('.').last}',
            resModel: 'product.template',
            url: imageUrl.replaceAll('\"', ''),
          );
          _productTemplate.images.add(productImage);
        }

        yield ProductTemplateAddEditUploadImageSuccess(productTemplate: _productTemplate);
      } catch (e, stack) {
        _logger.e('ProductTemplateAddEditUploadImageError', e, stack);
        yield ProductTemplateAddEditUploadImageError(error: e.toString(), productTemplate: _productTemplate);
      }
    } else if (event is ProductTemplateAddEditUpdateLocal) {
      _productTemplate = event.productTemplate;
      yield ProductTemplateAddEditLoadSuccess(productTemplate: _productTemplate);
    }
  }
}
