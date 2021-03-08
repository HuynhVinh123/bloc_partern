import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';

class ConversationPartnerEditEvent {}

class ConversationPartnerEditLoaded extends ConversationPartnerEditEvent {
  ConversationPartnerEditLoaded({this.partnerId, this.pageId, this.userId});
  int partnerId;
  String userId;
  String pageId;
}

class ConversationPartnerEditUpdated extends ConversationPartnerEditEvent {
  ConversationPartnerEditUpdated({this.partner, this.crmTeamId});
  Partner partner;
  int crmTeamId;
}

class ConversationPartnerEditState {}

class ConversationPartnerEditLoad extends ConversationPartnerEditState {
  ConversationPartnerEditLoad({this.partner});
  Partner partner;
}

class ConversationPartnerEditSuccess extends ConversationPartnerEditState {
  ConversationPartnerEditSuccess({this.partner});
  Partner partner;
}

class ConversationPartnerLoadFailure extends ConversationPartnerEditState {
  ConversationPartnerLoadFailure({this.error});
  String error;
}

class ConversationPartnerEditFailure extends ConversationPartnerEditState {
  ConversationPartnerEditFailure({this.error});
  String error;
}

class ConversationPartnerEditWaiting extends ConversationPartnerEditState {}

class ConversationPartnerEditBloc
    extends Bloc<ConversationPartnerEditEvent, ConversationPartnerEditState> {
  ConversationPartnerEditBloc(
      {DialogService dialogService, PartnerApi partnerApi})
      : super(ConversationPartnerEditWaiting()) {
    _dialog = dialogService ?? locator<DialogService>();
    _apiClient = partnerApi ?? GetIt.instance<PartnerApi>();
  }
  DialogService _dialog;
  PartnerApi _apiClient;
  @override
  Stream<ConversationPartnerEditState> mapEventToState(
      ConversationPartnerEditEvent event) async* {
    if (event is ConversationPartnerEditLoaded) {
      yield ConversationPartnerEditWaiting();
      try {
        final Partner partner = await _apiClient.getById(event.partnerId);
        yield ConversationPartnerEditLoad(partner: partner);
      } catch (e) {
        yield ConversationPartnerLoadFailure(error: e.toString());
      }
    } else if (event is ConversationPartnerEditUpdated) {
      yield ConversationPartnerEditWaiting();
      try {
        final Partner partner = await _apiClient.createOrUpdate(event.partner,
            crmTeamId: event.crmTeamId);
        yield ConversationPartnerEditSuccess(partner: partner);
      } catch (e) {
        yield ConversationPartnerEditFailure(error: e.toString());
      }
    }
  }
}
