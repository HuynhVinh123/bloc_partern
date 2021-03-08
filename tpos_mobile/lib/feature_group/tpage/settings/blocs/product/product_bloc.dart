import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/tpage/settings/blocs/product/product_event.dart';
import 'package:tpos_mobile/feature_group/tpage/settings/blocs/product/product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc({ProductTPageApi settingTPageApi}) : super(ProductLoading()) {
    _apiClient = settingTPageApi ?? GetIt.instance<ProductTPageApi>();
  }

  ProductTPageApi _apiClient;

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is ProductLoaded) {
      /// Thực thi lây danh dách sản phẩm
      yield ProductLoading();
      yield* getProducts(event);
    } else if (event is ProductLoadMoreLoaded) {
      /// Thực thi loadmore danh sách sản phẩm
      yield ProductLoadMoreLoading();
      yield* getProductLoadMores(event);
    } else if (event is StatusProductUpdated) {
      /// Thực thi cập nhật trạnh thái của sản phẩm
      yield ProductLoading();
      yield* updateStatusProduct(event);
    }
  }

  Stream<ProductState> getProducts(ProductLoaded event) async* {
    try {
      final List<Product> products = await _apiClient.getProductTPage(
          skip: event.skip, top: event.top, keyWord: event.keySearch);
      if (products.length == event.top) {
        products.add(tempProduct);
      }
      yield ProductLoadSuccess(products: products);
    } catch (e) {
      yield ProductLoadFailure(title: "Lỗi", content: e.toString());
    }
  }

  Stream<ProductState> getProductLoadMores(ProductLoadMoreLoaded event) async* {
    try {
      event.productTPages
          .removeWhere((element) => element.uOMName == tempProduct.uOMName);
      final List<Product> productLoadMore = await _apiClient.getProductTPage(
          skip: event.skip, top: event.top, keyWord: event.keySearch);
      if (productLoadMore.length == event.top) {
        productLoadMore.add(tempProduct);
      }
      event.productTPages.addAll(productLoadMore);
      yield ProductLoadSuccess(products: event.productTPages);
    } catch (e) {
      yield ProductLoadFailure(title: "Lỗi", content: e.toString());
    }
  }

  Stream<ProductState> updateStatusProduct(StatusProductUpdated event) async* {
    try {
      await _apiClient.updateStatusProductTPage(event.productId.toString());
      yield ActionSuccess(
          title: "Thông báo",
          content: "Đã cập nhật trạng thái",
          countProduct: event.countProduct);
    } catch (e) {
      yield ActionFailed(title: "Lỗi", content: e.toString());
    }
  }
}

var tempProduct = Product(uOMName: "temp");
