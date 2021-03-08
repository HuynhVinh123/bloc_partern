import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ConversationProductEvent {}

class ConversationProductLoaded extends ConversationProductEvent {
  ConversationProductLoaded(
      {this.keyword, this.facebookId, this.limit, this.skip});
  String keyword;
  String facebookId;
  int limit;
  int skip;
}

class ConversationProductLoadedMore extends ConversationProductEvent {
  ConversationProductLoadedMore(
      {this.keyword, this.facebookId, this.limit, this.skip});
  String keyword;
  String facebookId;
  int limit;
  int skip;
}

abstract class ConversationProductState {
  ConversationProductState({this.products});
  List<Product> products;
}

class ConversationProductWating extends ConversationProductState {}

class ConversationProductEmpty extends ConversationProductState {}

class ConversationProductLoadNoMore extends ConversationProductState {
  ConversationProductLoadNoMore({List<Product> products})
      : super(products: products);
}

class ConversationProductLoading extends ConversationProductState {
  ConversationProductLoading({List<Product> products})
      : super(products: products);
}

class ConversationProductFailure extends ConversationProductState {
  ConversationProductFailure({this.error});
  String error;
}

class ConversationProductBloc
    extends Bloc<ConversationProductEvent, ConversationProductState> {
  ConversationProductBloc({ConversationApi conservationApi})
      : super(ConversationProductWating()) {
    _apiClient = conservationApi ?? GetIt.instance<ConversationApi>();
  }
  List<Product> products;
  ConversationApi _apiClient;
  final Logger _logger = Logger();
  @override
  Stream<ConversationProductState> mapEventToState(
      ConversationProductEvent event) async* {
    if (event is ConversationProductLoaded) {
      yield ConversationProductWating();
      try {
        products = await _apiClient.getProductsByPageFacebook(
            facebookId: event.facebookId,
            keyword: event.keyword,
            limit: event.limit,
            skip: event.skip);
        if (products.isEmpty) {
          yield ConversationProductEmpty();
        } else {
          yield ConversationProductLoading(products: products);
        }
      } catch (e, stack) {
        _logger.e('GetProductsFailure', e, stack);
        yield ConversationProductFailure(error: e.toString());
      }
    } else if (event is ConversationProductLoadedMore) {
      try {
        if (products.length <= event.skip) {
          final List<Product> newProducts =
              await _apiClient.getProductsByPageFacebook(
                  facebookId: event.facebookId,
                  keyword: event.keyword,
                  limit: event.limit,
                  skip: event.skip);
          products += newProducts;
        }
        if (products.isEmpty) {
          yield ConversationProductEmpty();
        } else {
          yield ConversationProductLoading(products: products);
        }
      } catch (e, stack) {
        _logger.e('GetProductsFailure', e, stack);
        yield ConversationProductFailure(error: e.toString());
      }
    }
  }
}
