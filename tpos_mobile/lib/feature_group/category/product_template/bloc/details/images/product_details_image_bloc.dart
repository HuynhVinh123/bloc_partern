import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/details/images/product_details_image_event.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/details/images/product_details_image_state.dart';

class ProductDetailsImageBloc extends Bloc<ProductDetailsImageEvent, ProductDetailsImageState> {
  ProductDetailsImageBloc({ProductTemplateApi productTemplateApi}) : super(ProductDetailsImageLoading()) {
    _productTemplateApi = productTemplateApi ?? GetIt.I<ProductTemplateApi>();
  }

  ProductTemplateApi _productTemplateApi;
  final Logger _logger = Logger();
  List<ProductImage> _productImages = [];
  int _productTemplateId;

  @override
  Stream<ProductDetailsImageState> mapEventToState(ProductDetailsImageEvent event) async* {
    if (event is ProductDetailsImageStarted) {
      try {
        yield ProductDetailsImageLoading();
        _productTemplateId = event.productTemplateId;
        final ProductTemplate productTemplate = await _productTemplateApi.getById(_productTemplateId, 'Images');

        _productImages = productTemplate.images;

        yield ProductDetailsImageLoadSuccess(productImages: _productImages);
      } catch (e, stack) {
        _logger.e('ProductDetailsImageLoadFailure', e, stack);
        yield ProductDetailsImageLoadFailure(error: e.toString());
      }
    } else if (event is ProductDetailsImageRefreshed) {
      try {
        yield ProductDetailsImageLoading();

        final ProductTemplate productTemplate = await _productTemplateApi.getById(_productTemplateId, 'Images');

        _productImages = productTemplate.images;

        yield ProductDetailsImageLoadSuccess(productImages: _productImages);
      } catch (e, stack) {
        _logger.e('ProductDetailsImageLoadFailure', e, stack);
        yield ProductDetailsImageLoadFailure(error: e.toString());
      }
    }
  }
}
