import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/add_edit/product_template_add_edit_event.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/add_edit/product_template_add_edit_state.dart';
import 'package:tpos_mobile/resources/permission.dart';
import 'package:tpos_mobile/services/cache_service/cache_service.dart';

class ProductTemplateAddEditBloc
    extends Bloc<ProductTemplateAddEditEvent, ProductTemplateAddEditState> {
  ProductTemplateAddEditBloc(
      {ProductTemplateApi productTemplateApi,
      CommonApi commonApi,
      ProductAttributeApi productAttributeLineApi,
      CacheService cacheService})
      : super(ProductTemplateAddEditLoading()) {
    _productTemplateApi = productTemplateApi ?? GetIt.I<ProductTemplateApi>();
    _productAttributeLineApi =
        productAttributeLineApi ?? GetIt.I<ProductAttributeApi>();
    _commonApi = commonApi ?? GetIt.I<CommonApi>();
    _cacheService = cacheService ?? GetIt.instance<CacheService>();
  }

  UserPermission _userRight;
  ProductTemplateApi _productTemplateApi;
  ProductTemplate _productTemplate;
  CommonApi _commonApi;
  ProductAttributeApi _productAttributeLineApi;
  CacheService _cacheService;
  final Logger _logger = Logger();

  @override
  Stream<ProductTemplateAddEditState> mapEventToState(
      ProductTemplateAddEditEvent event) async* {
    if (event is ProductTemplateAddEditStarted) {
      yield ProductTemplateAddEditLoading();
      try {
        final bool permissionStandardPrice = _cacheService.fields.any(
                (element) =>
            element == PermissionField.productTemplate_standardPrice);

        final bool permissionPurchasePrice = _cacheService.fields.any(
                (element) =>
            element == PermissionField.productTemplate_purchasePrice);
        final bool permissionPrice = _cacheService.fields.any((element) =>
        element == PermissionField.productTemplate_Price);
        final bool permissionCode = _cacheService.fields
            .any((element) => element == PermissionField.productTemplate_Code);
        final bool permissionName = _cacheService.fields
            .any((element) => element == PermissionField.productTemplate_Name);
        final bool permissionEAN13 = _cacheService.fields
            .any((element) => element == PermissionField.productTemplate_EAN13);
        final bool permissionBarcode = _cacheService.fields.any(
                (element) => element == PermissionField.productTemplate_Barcode);
        _userRight = UserPermission(
            permissionProductTemplateStandardPrice: permissionStandardPrice,
            permissionProductTemplatePurchasePrice: permissionPurchasePrice,
            permissionProductTemplatePrice: permissionPrice,
            permissionProductTemplateCode: permissionCode,
            permissionProductTemplateName: permissionName,
            permissionProductTemplateEAN13: permissionEAN13,
            productProductTemplateBarcode: permissionBarcode);

        if (event.productTemplate != null) {
          _productTemplate = event.productTemplate;
          _productTemplate = await _productTemplateApi.getById(
              event.productTemplate.id,
              'UOM,UOMCateg,Categ,UOMPO,POSCateg,Taxes,SupplierTaxes,Product_Teams,Images,UOMView,Distributor,Importer,Producer,OriginCountry');

          ///lấy danh sách productAttributeLines
          _productTemplate.productAttributeLines =
              (await _productAttributeLineApi.getProductAttributeLineList(
                      event.productTemplate.id, 'Attribute,Values'))
                  .value;
          final OdataListResult<ProductUOMLine> productUOMLines =
              await _productTemplateApi.getProductUOMLines(
                  productTemplateId: _productTemplate.id);
          _productTemplate.uomLines = productUOMLines.value;

          yield ProductTemplateAddEditLoadSuccess(
              productTemplate: _productTemplate, userRight: _userRight);
        } else {
          _productTemplate =
              await _productTemplateApi.getDefault('UOM,Categ,UOMPO');
          _productTemplate.id = 0;
          _productTemplate.discountSale = null;
          _productTemplate.discountPurchase = null;

          yield ProductTemplateAddEditLoadSuccess(
              productTemplate: _productTemplate, userRight: _userRight);
        }
      } catch (e, stack) {
        _logger.e('ProductTemplateAddEditLoadFailure', e, stack);
        yield ProductTemplateAddEditLoadFailure(
            error: e.toString(),
            productTemplate: _productTemplate,
            userRight: _userRight);
      }
    } else if (event is ProductTemplateAddEditSaved) {
      yield ProductTemplateAddEditBusy(
          productTemplate: _productTemplate, userRight: _userRight);
      try {
        if (_productTemplate.name == '' || _productTemplate.name == null) {
          yield ProductTemplateAddEditNameEmpty(
              productTemplate: _productTemplate, userRight: _userRight);
        } else {
          if (_productTemplate.id == 0) {
            _productTemplate.id =
                (await _productTemplateApi.insert(_productTemplate)).id;
          } else {
            await _productTemplateApi.update(_productTemplate);
          }

          yield ProductTemplateAddEditSaveSuccess(
              productTemplate: _productTemplate, userRight: _userRight);
        }
      } catch (e, stack) {
        _logger.e('ProductTemplateAddEditSaveError', e, stack);
        yield ProductTemplateAddEditSaveError(
            error: e.toString(),
            productTemplate: _productTemplate,
            userRight: _userRight);
      }
    } else if (event is ProductTemplateAddEditUploadImage) {
      try {
        yield ProductTemplateAddEditBusy(
            productTemplate: _productTemplate, userRight: _userRight);
        final List<int> imageBytes = event.file.readAsBytesSync();
        final String base64Image = base64Encode(imageBytes);

        if ((_productTemplate.imageUrl == null ||
                _productTemplate.imageUrl == '') &&
            (_productTemplate.image == '' || _productTemplate.image == null)) {
          _productTemplate.image = base64Image;
          _productTemplate.imageBytes = imageBytes;
        } else {
          final String fileName = event.file.path.split('/').last;
          final String imageUrl =
              await _commonApi.uploadImage(base64Image, fileName);

          final ProductImage productImage = ProductImage(
            type: 'url',
            name: fileName,
            mineType: 'image/${fileName.split('.').last}',
            resModel: 'product.template',
            url: imageUrl.replaceAll('\"', ''),
          );
          _productTemplate.images.add(productImage);
        }

        yield ProductTemplateAddEditUploadImageSuccess(
            productTemplate: _productTemplate, userRight: _userRight);
      } catch (e, stack) {
        _logger.e('ProductTemplateAddEditUploadImageError', e, stack);
        yield ProductTemplateAddEditUploadImageError(
            error: e.toString(),
            productTemplate: _productTemplate,
            userRight: _userRight);
      }
    } else if (event is ProductTemplateAddEditUpdateLocal) {
      _productTemplate = event.productTemplate;
      yield ProductTemplateAddEditLoadSuccess(
          productTemplate: _productTemplate, userRight: _userRight);
    } else if (event is ProductTemplateAddEditOnChangeUOM) {
      try {
        _productTemplate = event.productTemplate;

        yield ProductTemplateAddEditBusy(
            productTemplate: _productTemplate, userRight: _userRight);

        final ProductTemplate result = await _productTemplateApi.onChangeUOM(
            productTemplate: event.productTemplate, expand: 'UOMPO');
        _productTemplate.uOMPOId = result.uOMPOId;
        _productTemplate.uOMPO = result.uOMPO;
        _productTemplate.uOMPOName = result.uOMPOName;
        yield ProductTemplateAddEditLoadSuccess(
            productTemplate: _productTemplate, userRight: _userRight);
      } catch (e, stack) {
        _logger.e('ProductTemplateAddEditChangeUOMError', e, stack);
        yield ProductTemplateAddEditChangeUOMError(
            error: e.toString(),
            productTemplate: _productTemplate,
            userRight: _userRight);
      }
    }
  }
}
