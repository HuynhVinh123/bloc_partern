import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/product/bloc/product_variant_details_event.dart';
import 'package:tpos_mobile/feature_group/category/product/bloc/product_variant_details_state.dart';
import 'package:tpos_mobile/resources/permission.dart';
import 'package:tpos_mobile/services/cache_service/cache_service.dart';
import 'package:tpos_mobile/services/config_service/config_service.dart';

class ProductVariantDetailsBloc
    extends Bloc<ProductVariantDetailsEvent, ProductVariantDetailsState> {
  ProductVariantDetailsBloc(
      {ProductVariantApi productApi,
      SecureConfigService secureConfigService,
      CacheService cacheService})
      : super(ProductVariantDetailsLoading()) {
    _productApi = productApi ?? GetIt.I<ProductVariantApi>();
    _secureConfig = secureConfigService ?? GetIt.I<SecureConfigService>();
    _cacheService = cacheService ?? GetIt.instance<CacheService>();
  }

  ProductVariantApi _productApi;
  final Logger _logger = Logger();
  Product _product;
  SecureConfigService _secureConfig;
  int _productId;
  UserPermission _userPermission;
  CacheService _cacheService;

  @override
  Stream<ProductVariantDetailsState> mapEventToState(
      ProductVariantDetailsEvent event) async* {
    if (event is ProductVariantDetailsStarted) {
      try {
        yield ProductVariantDetailsLoading();

        final bool permissionPurchasePrice = _cacheService.fields
            .any((element) => element == PermissionField.product_PurchasePrice);
        final bool permissionPrice = _cacheService.fields
            .any((element) => element == PermissionField.product_Price);
        final bool permissionCode = _cacheService.fields
            .any((element) => element == PermissionField.product_Code);
        final bool permissionName = _cacheService.fields
            .any((element) => element == PermissionField.product_Name);
        final bool permissionEAN13 = _cacheService.fields
            .any((element) => element == PermissionField.product_EAN13);
        final bool permissionBarcode = _cacheService.fields
            .any((element) => element == PermissionField.product_Barcode);

        _userPermission = UserPermission(
            permissionProductPurchasePrice: permissionPurchasePrice,
            permissionProductPrice: permissionPrice,
            permissionProductCode: permissionCode,
            permissionProductName: permissionName,
            permissionProductEAN13: permissionEAN13,
            permissionProductBarcode: permissionBarcode);
        _productId = event.productId;
        _product = await _productApi.getById(_productId,
            expand: 'UOM,Categ,UOMPO,POSCateg,AttributeValues');
        _product.imageUrl =
            '${_secureConfig.shopUrl}/web/image?model=product.product&id=${_product.id}&field=image_medium&time=${DateTime.now().toIso8601String()}';

        yield ProductVariantDetailsStartSuccess(
            product: _product, userPermission: _userPermission);
      } catch (e, stack) {
        _logger.e('ProductVariantDetailsLoadFailure', e, stack);
        yield ProductVariantDetailsLoadFailure(error: e.toString());
      }
    } else if (event is ProductVariantDetailsActiveSet) {
      try {
        yield ProductVariantDetailsBusy();
        await _productApi.setActive(!_product.active, [_product?.id]);

        _product.active = !_product.active;
        yield ProductVariantDetailsSetActiveSuccess(
            product: _product,
            active: _product.active,
            userPermission: _userPermission);
      } catch (e, stack) {
        _logger.e('ProductVariantDetailsSetActiveFailure', e, stack);
        yield ProductVariantDetailsSetActiveFailure(error: e.toString());
      }
    } else if (event is ProductVariantDetailsDelete) {
      try {
        yield ProductVariantDetailsBusy();

        await _productApi.delete(_product?.id);

        yield ProductVariantDetailsDeleteSuccess(
            product: _product, userPermission: _userPermission);
      } catch (e, stack) {
        _logger.e('ProductVariantDetailsDeleteFailure', e, stack);
        yield ProductVariantDetailsDeleteFailure(error: e.toString());
      }
    }
  }
}
