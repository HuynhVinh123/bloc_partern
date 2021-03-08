import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ConversationFsOrderEvent {}

///Tải đơn hàng
class ConversationFsOrderLoaded extends ConversationFsOrderEvent {
  ConversationFsOrderLoaded({this.partnerId});
  int partnerId;
}

abstract class ConversationFsOrderState {
  ConversationFsOrderState({this.fastSaleOrders});
  OdataListResult<FastSaleOrder> fastSaleOrders;
}

///Chờ
class ConversationFsOrderWating extends ConversationFsOrderState {}

///Trống
class ConversationFsOrderEmpty extends ConversationFsOrderState {}

///Tải
class ConversationFsOrderLoading extends ConversationFsOrderState {
  ConversationFsOrderLoading({OdataListResult<FastSaleOrder> fastSaleOrders})
      : super(fastSaleOrders: fastSaleOrders);
}

///Lỗi
class ConversationFsOrderFailure extends ConversationFsOrderState {
  ConversationFsOrderFailure({this.error});
  String error;
}

class ConversationFsOrderBloc
    extends Bloc<ConversationFsOrderEvent, ConversationFsOrderState> {
  ConversationFsOrderBloc({ConversationApi conversationApi})
      : super(ConversationFsOrderWating()) {
    _apiClient = conversationApi ?? GetIt.instance<ConversationApi>();
  }
  ConversationApi _apiClient;
  final Logger _logger = Logger();
  @override
  Stream<ConversationFsOrderState> mapEventToState(
      ConversationFsOrderEvent event) async* {
    if (event is ConversationFsOrderLoaded) {
      yield ConversationFsOrderWating();
      try {
        final OdataListResult<FastSaleOrder> fastSaleOrders =
            await _apiClient.getFastSaleOrders(partnerId: event.partnerId);
        if (fastSaleOrders.value.isEmpty) {
          yield ConversationFsOrderEmpty();
        } else {
          yield ConversationFsOrderLoading(fastSaleOrders: fastSaleOrders);
        }
      } catch (e, stack) {
        _logger.e('GetFsOrderFailure', e, stack);
        yield ConversationFsOrderFailure(error: e.toString());
      }
    }
  }
}
