import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/details/product_template_details_event.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/details/product_template_details_state.dart';

class ProductTemplateDetailsBloc extends Bloc<ProductTemplateDetailsEvent, ProductTemplateDetailsState> {
  ProductTemplateDetailsBloc({ProductTemplateApi productTemplateApi}) : super(ProductTemplateDetailsLoading()) {
    _productTemplateApi = productTemplateApi ?? GetIt.I<ProductTemplateApi>();
  }

  ProductTemplateApi _productTemplateApi;

  ProductTemplate _productTemplate;

  final Logger _logger = Logger();

  @override
  Stream<ProductTemplateDetailsState> mapEventToState(ProductTemplateDetailsEvent event) async* {
    if (event is ProductTemplateDetailsStarted) {
      try {
        yield ProductTemplateDetailsLoading();
        _productTemplate = event.productTemplate;
        _productTemplate = await _productTemplateApi.getById(
            event.productTemplate.id, 'Importer,Distributor,Producer');

        yield ProductTemplateDetailsStartSuccess(
          productTemplate: _productTemplate,
        );
      } catch (e, stack) {
        _logger.e('ProductTemplateDetailsLoadFailure', e, stack);
        yield ProductTemplateDetailsLoadFailure(error: e.toString());
      }
    } else if (event is ProductTemplateDetailsRefresh) {
      try {
        yield ProductTemplateDetailsLoading();
        _productTemplate = await _productTemplateApi.getByDetails(
            _productTemplate.id, 'Importer,Distributor,Producer');

        yield ProductTemplateDetailsLoadSuccess(
          productTemplate: _productTemplate,
        );
      } catch (e, stack) {
        _logger.e('ProductTemplateDetailsLoadFailure', e, stack);
        yield ProductTemplateDetailsLoadFailure(error: e.toString());
      }
    } else if (event is ProductTemplateDetailsActiveSet) {
      try {
        yield ProductTemplateDetailsBusy();

        await _productTemplateApi.setActive(event.active, [_productTemplate.id]);

        _productTemplate = await _productTemplateApi.getByDetails(
            _productTemplate.id, 'Importer,Distributor,Producer');

        yield ProductTemplateDetailsActiveSetSuccess(productTemplate: _productTemplate, active: event.active);
      } catch (e, stack) {
        _logger.e('ProductTemplateDetailsActiveSetFailure', e, stack);
        yield ProductTemplateDetailsActiveSetFailure(error: e.toString());
        yield ProductTemplateDetailsLoadSuccess(
          productTemplate: _productTemplate,
        );
      }
    } else if (event is ProductTemplateDetailsDelete) {
      try {
        yield ProductTemplateDetailsBusy();

        await _productTemplateApi.delete(_productTemplate.id);

        yield ProductTemplateDetailsDeleteSuccess();
      } catch (e, stack) {
        _logger.e('ProductTemplateDetailsDeleteFailure', e, stack);
        yield ProductTemplateDetailsDeleteFailure(error: e.toString());
        yield ProductTemplateDetailsLoadSuccess(
          productTemplate: _productTemplate,
        );
      }
    }
  }
}
