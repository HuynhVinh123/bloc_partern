import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/product/bloc/add_edit/product_variant_add_edit_event.dart';
import 'package:tpos_mobile/feature_group/category/product/bloc/add_edit/product_variant_add_edit_state.dart';
import 'package:tpos_mobile/services/config_service/config_service.dart';

class ProductVariantAddEditBloc extends Bloc<ProductVariantAddEditEvent, ProductVariantAddEditState> {
  ProductVariantAddEditBloc({ProductVariantApi productVariantApi, ConfigService configService})
      : super(ProductVariantAddEditLoading()) {
    _productVariantApi = productVariantApi ?? GetIt.I<ProductVariantApi>();
    _configService = configService ?? GetIt.instance<ConfigService>();
  }

  ProductVariantApi _productVariantApi;

  final Logger _logger = Logger();
  Product _productVariant;
  ConfigService _configService;

  @override
  Stream<ProductVariantAddEditState> mapEventToState(ProductVariantAddEditEvent event) async* {
    if (event is ProductVariantAddEditStarted) {
      try {
        yield ProductVariantAddEditLoading();

        if (event.productVariantId != null) {
          _productVariant = await _productVariantApi.getById(event.productVariantId,
              expand: 'UOM,Categ,UOMPO,POSCateg,AttributeValues');
          _productVariant.imageUrl =
              '${_configService.shopUrl}/web/image?model=product.product&id=${_productVariant.id}&field=image_medium';
        } else {
          _productVariant = Product(id: 0);
        }

        _productVariant.defaultImageUrl = '${_configService.shopUrl}/Content/images/placeholder.png';

        yield ProductVariantAddEditLoadSuccess(productVariant: _productVariant);
      } catch (e, stack) {
        _logger.e('ProductVariantAddEditLoadFailure', e, stack);
        yield ProductVariantAddEditLoadFailure(error: e.toString());
      }
    } else if (event is ProductVariantAddEditSaved) {
      try {
        yield ProductVariantAddEditBusy();
        _productVariant = event.productVariant;
        if (_productVariant.uOM != null) {
          _productVariant.uOMId = _productVariant.uOM.id;
          _productVariant.uOMName = _productVariant.uOM.name;
        }
        if (_productVariant.uOMPO != null) {
          _productVariant.uOMPOId = _productVariant.uOMPO.id;
        }
        if (_productVariant.categ != null) {
          _productVariant.categId = _productVariant.categ.id;
        }

        _productVariant.version = null;

        if (_productVariant.id == 0) {
          final Product product = await _productVariantApi.insert(_productVariant);
          _productVariant.id = product.id;
        } else {
          await _productVariantApi.update(_productVariant);
        }

        yield ProductVariantAddEditSaveSuccess(productVariant: _productVariant);
      } catch (e, stack) {
        _logger.e('ProductVariantAddEditSaveFailure', e, stack);
        yield ProductVariantAddEditSaveFailure(error: e.toString());
      }
    } else if (event is ProductVariantAddEditLocalUpdated) {
      _productVariant = event.productVariant;
    } else if (event is ProductVariantAddEditUploadImage) {
      try {
        yield ProductVariantAddEditBusy();
        final List<int> imageBytes = event.file.readAsBytesSync();
        final String base64Image = base64Encode(imageBytes);

        if ((_productVariant.imageUrl == null || _productVariant.imageUrl == '') &&
            (_productVariant.image == '' || _productVariant.image == null)) {
          _productVariant.image = base64Image;
          _productVariant.imageBytes = imageBytes;
        }

        yield ProductVariantAddEditUploadImageSuccess(productVariant: _productVariant);
      } catch (e, stack) {
        _logger.e('ProductVariantAddEditUploadImageError', e, stack);
        yield ProductVariantAddEditUploadImageError(error: e.toString());
      }
    }
  }
}
