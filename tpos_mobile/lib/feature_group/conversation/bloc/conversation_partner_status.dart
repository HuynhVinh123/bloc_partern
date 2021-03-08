import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ConversationPartnerStatusEvent {}

///Tải trạng thái
class ConversationPartnerStatusLoaded extends ConversationPartnerStatusEvent {
  ConversationPartnerStatusLoaded();
}

abstract class ConversationPartnerStatusState {
  ConversationPartnerStatusState({this.listPartnerStatus});
  List<PartnerStatus> listPartnerStatus;
}

///Chờ
class ConversationPartnerStatusWating extends ConversationPartnerStatusState {}

///Trống
class ConversationPartnerStatusEmpty extends ConversationPartnerStatusState {}

///Tải
class ConversationPartnerStatusLoading extends ConversationPartnerStatusState {
  ConversationPartnerStatusLoading({List<PartnerStatus> listPartnerStatus})
      : super(listPartnerStatus: listPartnerStatus);
}

///Lỗi
class ConversationPartnerStatusFailure extends ConversationPartnerStatusState {
  ConversationPartnerStatusFailure({this.error});
  String error;
}

class ConversationPartnerStatusBloc extends Bloc<ConversationPartnerStatusEvent,
    ConversationPartnerStatusState> {
  ConversationPartnerStatusBloc({CommonApi commonApi})
      : super(ConversationPartnerStatusWating()) {
    _apiClient = commonApi ?? GetIt.instance<CommonApi>();
  }
  CommonApi _apiClient;
  final Logger _logger = Logger();
  @override
  Stream<ConversationPartnerStatusState> mapEventToState(
      ConversationPartnerStatusEvent event) async* {
    if (event is ConversationPartnerStatusLoaded) {
      yield ConversationPartnerStatusWating();
      try {
        final List<PartnerStatus> listPartnerStatus =
            await _apiClient.getPartnerStatus();
        if (listPartnerStatus.isEmpty) {
          yield ConversationPartnerStatusEmpty();
        } else {
          yield ConversationPartnerStatusLoading(
              listPartnerStatus: listPartnerStatus);
        }
      } catch (e, stack) {
        _logger.e('GetPartnerStatusFailure', e, stack);
        yield ConversationPartnerStatusFailure(error: e.toString());
      }
    }
  }
}
