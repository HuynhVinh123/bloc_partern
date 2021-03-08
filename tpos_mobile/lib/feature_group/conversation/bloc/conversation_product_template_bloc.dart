import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ConversationProductTemplateUomEvent {}

class ConversationProductTemplateUomLoaded
    extends ConversationProductTemplateUomEvent {
  ConversationProductTemplateUomLoaded({this.getListQuery});
  OdataGetListQuery getListQuery;
}

class ConversationSaleOnlineOrderLoaded
    extends ConversationProductTemplateUomEvent {
  ConversationSaleOnlineOrderLoaded({this.id, this.partnerId});
  String id;
  int partnerId;
}

class ConversationProductTemplateUomLoadedMore
    extends ConversationProductTemplateUomEvent {
  ConversationProductTemplateUomLoadedMore({this.getListQuery});
  OdataGetListQuery getListQuery;
}

abstract class ConversationProductTemplateUomState {
  ConversationProductTemplateUomState({this.products});
  OdataListResult<Product> products;
}

class ConversationProductTemplateUomWating
    extends ConversationProductTemplateUomState {}

class ConversationProductTemplateUomEmpty
    extends ConversationProductTemplateUomState {}

class ConversationProductTemplateUomLoadNoMore
    extends ConversationProductTemplateUomState {
  ConversationProductTemplateUomLoadNoMore({OdataListResult<Product> products})
      : super(products: products);
}

class ConversationProductTemplateUomLoading
    extends ConversationProductTemplateUomState {
  ConversationProductTemplateUomLoading({OdataListResult<Product> products})
      : super(products: products);
}

class ConversationProductTemplateUomFailure
    extends ConversationProductTemplateUomState {
  ConversationProductTemplateUomFailure({this.error});
  String error;
}

class ConversationSaleOnlineOrderLoad
    extends ConversationProductTemplateUomState {
  ConversationSaleOnlineOrderLoad({this.saleOnlineOrder});
  SaleOnlineOrder saleOnlineOrder;
}

class ConversationProductTemplateUomBloc extends Bloc<
    ConversationProductTemplateUomEvent, ConversationProductTemplateUomState> {
  ConversationProductTemplateUomBloc(
      {ProductTemplateUOMLineApi productTemplateUOMLineApi,
      ConversationApi conversationApi,
      ProductTemplateUOMLineApi tApiClient})
      : super(ConversationProductTemplateUomWating()) {
    _apiClient = productTemplateUOMLineApi ??
        GetIt.instance<ProductTemplateUOMLineApi>();
    _conversationApi = conversationApi ?? GetIt.instance<ConversationApi>();
    _tApiClient = tApiClient ?? GetIt.instance<ProductTemplateUOMLineApi>();
  }
  OdataListResult<Product> products;
  ProductTemplateUOMLineApi _apiClient;
  ConversationApi _conversationApi;
  ProductTemplateUOMLineApi _tApiClient;
  final Logger _logger = Logger();
  @override
  Stream<ConversationProductTemplateUomState> mapEventToState(
      ConversationProductTemplateUomEvent event) async* {
    if (event is ConversationProductTemplateUomLoaded) {
      yield ConversationProductTemplateUomWating();
      try {
        products =
            await _apiClient.getProductTemplateUOMLines(event.getListQuery);
        if (products.value.isEmpty) {
          yield ConversationProductTemplateUomEmpty();
        } else {
          yield ConversationProductTemplateUomLoading(products: products);
        }
      } catch (e, stack) {
        _logger.e('GetProductsFailure', e, stack);
        yield ConversationProductTemplateUomFailure(error: e.toString());
      }
    } else if (event is ConversationProductTemplateUomLoadedMore) {
      try {
        if (products.value.length <= event.getListQuery.skip) {
          final OdataListResult<Product> newProducts =
              await _apiClient.getProductTemplateUOMLines(event.getListQuery);
          products.value += newProducts.value;
        }
        if (products.value.isEmpty) {
          yield ConversationProductTemplateUomEmpty();
        } else {
          yield ConversationProductTemplateUomLoading(products: products);
        }
      } catch (e, stack) {
        _logger.e('GetProductsFailure', e, stack);
        yield ConversationProductTemplateUomFailure(error: e.toString());
      }
    } else if (event is ConversationSaleOnlineOrderLoaded) {
      String id;
      yield ConversationProductTemplateUomWating();
      try {
        // final OdataListResult<FastSaleOrder> fastSaleOrders =
        //     await _tApiClient.getSaleOnlineOrders(partnerId: event.partnerId);
        final SaleOnlineOrder saleOnlineOrder = await _apiClient
            .getSaleOnlineOrderById(event.id, 'Details,User,Partner');
        yield ConversationSaleOnlineOrderLoad(saleOnlineOrder: saleOnlineOrder);
      } catch (e, stack) {
        _logger.e('GetProductsFailure', e, stack);
        yield ConversationProductTemplateUomFailure(error: e.toString());
      }
    }
  }
}
