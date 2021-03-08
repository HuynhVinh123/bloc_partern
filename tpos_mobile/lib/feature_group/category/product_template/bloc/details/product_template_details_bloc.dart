import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/details/product_template_details_event.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/details/product_template_details_state.dart';
import 'package:tpos_mobile/resources/permission.dart';
import 'package:tpos_mobile/services/cache_service/cache_service.dart';

class ProductTemplateDetailsBloc
    extends Bloc<ProductTemplateDetailsEvent, ProductTemplateDetailsState> {
  ProductTemplateDetailsBloc({
    ProductTemplateApi productTemplateApi,
    CacheService cacheService,
    TagProductTemplateApi tagProductTemplateApi,
  }) : super(ProductTemplateDetailsLoading()) {
    _productTemplateApi = productTemplateApi ?? GetIt.I<ProductTemplateApi>();
    _cacheService = cacheService ?? GetIt.instance<CacheService>();
    _tagProductTemplateApi =
        tagProductTemplateApi ?? GetIt.I<TagProductTemplateApi>();
  }

  ProductTemplateApi _productTemplateApi;

  ProductTemplate _productTemplate;

  CacheService _cacheService;
  final Logger _logger = Logger();
  UserPermission _userPermission;

  TagProductTemplateApi _tagProductTemplateApi;
  List _tags = [];

  @override
  Stream<ProductTemplateDetailsState> mapEventToState(
      ProductTemplateDetailsEvent event) async* {
    if (event is ProductTemplateDetailsStarted) {
      try {
        yield ProductTemplateDetailsLoading();
        final bool permissionStandardPrice = _cacheService.fields.any(
            (element) =>
                element == PermissionField.productTemplate_standardPrice);

        final bool permissionPurchasePrice = _cacheService.fields.any(
            (element) =>
                element == PermissionField.productTemplate_purchasePrice);
        final bool permissionPrice = _cacheService.fields
            .any((element) => element == PermissionField.productTemplate_Price);
        final bool permissionCode = _cacheService.fields
            .any((element) => element == PermissionField.productTemplate_Code);
        final bool permissionName = _cacheService.fields
            .any((element) => element == PermissionField.productTemplate_Name);
        final bool permissionEAN13 = _cacheService.fields
            .any((element) => element == PermissionField.productTemplate_EAN13);
        final bool permissionBarcode = _cacheService.fields.any(
            (element) => element == PermissionField.productTemplate_Barcode);
        _userPermission = UserPermission(
            permissionProductTemplateStandardPrice: permissionStandardPrice,
            permissionProductTemplatePurchasePrice: permissionPurchasePrice,
            permissionProductTemplatePrice: permissionPrice,
            permissionProductTemplateCode: permissionCode,
            permissionProductTemplateName: permissionName,
            permissionProductTemplateEAN13: permissionEAN13,
            productProductTemplateBarcode: permissionBarcode);

        _productTemplate = event.productTemplate;
        _productTemplate = await _productTemplateApi.getById(
            event.productTemplate.id,
            'Importer,Distributor,Producer,OriginCountry');
        _tags = event.productTemplate.tags;
        _productTemplate.tags = _tags;
        yield ProductTemplateDetailsStartSuccess(
            productTemplate: _productTemplate, userRight: _userPermission);
      } catch (e, stack) {
        _logger.e('ProductTemplateDetailsLoadFailure', e, stack);
        yield ProductTemplateDetailsLoadFailure(error: e.toString());
      }
    } else if (event is ProductTemplateDetailsRefresh) {
      try {
        yield ProductTemplateDetailsLoading();

        _productTemplate = await _productTemplateApi.getByDetails(
            _productTemplate.id, 'Importer,Distributor,Producer,OriginCountry');
        _productTemplate.tags = _tags;
        yield ProductTemplateDetailsLoadSuccess(
            productTemplate: _productTemplate, userPermission: _userPermission);
      } catch (e, stack) {
        _logger.e('ProductTemplateDetailsLoadFailure', e, stack);
        yield ProductTemplateDetailsLoadFailure(error: e.toString());
      }
    } else if (event is ProductTemplateDetailsActiveSet) {
      try {
        yield ProductTemplateDetailsBusy();

        await _productTemplateApi
            .setActive(event.active, [_productTemplate.id]);

        _productTemplate = await _productTemplateApi.getByDetails(
            _productTemplate.id, 'Importer,Distributor,Producer,OriginCountry');
        _productTemplate.tags = _tags;
        yield ProductTemplateDetailsActiveSetSuccess(
            productTemplate: _productTemplate,
            userRight: _userPermission,
            active: event.active);
      } catch (e, stack) {
        _logger.e('ProductTemplateDetailsActiveSetFailure', e, stack);
        yield ProductTemplateDetailsActiveSetFailure(error: e.toString());
      }
    } else if (event is ProductTemplateDetailsDelete) {
      try {
        yield ProductTemplateDetailsBusy();

        await _productTemplateApi.delete(_productTemplate.id);

        yield ProductTemplateDetailsDeleteSuccess();
      } catch (e, stack) {
        _logger.e('ProductTemplateDetailsDeleteFailure', e, stack);
        yield ProductTemplateDetailsDeleteFailure(error: e.toString());
      }
    } else if (event is ProductTemplateDetailsAssignTag) {
      try {
        yield ProductTemplateDetailsBusy();
        await _tagProductTemplateApi.assignTagProductTemplate(
            assignModel: AssignTagProductTemplateModel(
                productTmplId: event.productTemplate?.id, tags: event.tags));
        _tags = event.tags;
        _productTemplate = event.productTemplate;
        _productTemplate.tags = _tags;
        yield ProductTemplateDetailsAssignTagSuccess(
            productTemplate: _productTemplate);
      } catch (e, stack) {
        _logger.e('ProductTemplateDetailsAssignTagFailure', e, stack);
        yield ProductTemplateDetailsAssignTagFailure(error: e.toString());
      }
    }
  }
}
