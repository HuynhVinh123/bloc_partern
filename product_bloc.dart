import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/tpage/settings/blocs/product/product_event.dart';
import 'package:tpos_mobile/feature_group/tpage/settings/blocs/product/product_state.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc({SettingTPageApi settingTPageApi, DialogService dialogService})
      : super(ProductLoading()) {
    _apiClient = settingTPageApi ?? GetIt.instance<SettingTPageApi>();
    _dialog = dialogService ?? locator<DialogService>();
  }

  SettingTPageApi _apiClient;
  DialogService _dialog;

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is ProductLoaded) {
      yield ProductLoading();
      yield* getProducts(event);
    }else if(event is ProductLoadMoreLoaded){
      yield ProductLoadMoreLoading();
      yield* getProductLoadMores(event);
    }else if(event is StatusProductUpdated){
      yield ProductLoading();
      yield* updateStatusProduct(event);
    }
  }

  Stream<ProductState> getProducts(ProductLoaded event) async* {
    // try {
      final ProductTPage product =
          await _apiClient.getProductTPage(skip: event.skip, top: event.top);
      if (product.values.length == event.top) {
        product.values.add(tempProduct);
      }
      yield ProductLoadSuccess(product: product);
    // } catch (e) {
    //   yield ProductLoadFailure(title: "Lỗi", content: e.toString());
    // }
  }

  Stream<ProductState> getProductLoadMores(ProductLoadMoreLoaded event) async* {
    try {
      event.productTPage.values
          .removeWhere((element) => element.uOMName == tempProduct.uOMName);
      final ProductTPage productLoadMore =
          await _apiClient.getProductTPage(skip: event.skip, top: event.top);
      if (productLoadMore.values.length == event.top) {
        productLoadMore.values.add(tempProduct);
      }
      event.productTPage.values.addAll(productLoadMore.values);
      yield ProductLoadSuccess(product: event.productTPage);
    } catch (e) {
      yield ProductLoadFailure(title: "Lỗi", content: e.toString());
    }
  }

  Stream<ProductState> updateStatusProduct(StatusProductUpdated event) async* {
    try {
      await _apiClient.updateStatusProductTPage(event.productId.toString());
      yield ActionSuccess(title: "Thông báo",content: "Đã cập nhật trạng thái");
    } catch (e) {
      yield ProductLoadFailure(title: "Lỗi", content: e.toString());
    }
  }

}

var tempProduct = ProductTPageInfo(uOMName: "temp");
