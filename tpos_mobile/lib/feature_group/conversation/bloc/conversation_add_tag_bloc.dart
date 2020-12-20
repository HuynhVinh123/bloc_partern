import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';

class ConversationTagAddEvent {}

class ConversationTagMessageAdded extends ConversationTagAddEvent {
  ConversationTagMessageAdded(
      {this.tagId, this.pageId, this.action, this.facebookId});
  String tagId;
  String pageId;
  String action;
  String facebookId;
}

abstract class ConversationTagAddState {}

class ConversationTagWaiting extends ConversationTagAddState {}

class ConversationTagAddSuccess extends ConversationTagAddState {
  ConversationTagAddSuccess({this.crmTag});
  CRMTag crmTag;
}

class ConversationTagAddFailure extends ConversationTagAddState {
  ConversationTagAddFailure({this.message});
  String message;
}

class ConversationTagBloc
    extends Bloc<ConversationTagAddEvent, ConversationTagAddState> {
  ConversationTagBloc(
      {DialogService dialogService, ConversationApi conservationApi})
      : super(ConversationTagWaiting()) {
    _dialog = dialogService ?? locator<DialogService>();
    _apiClient = conservationApi ?? GetIt.instance<ConversationApi>();
  }

  DialogService _dialog;
  ConversationApi _apiClient;

  @override
  Stream<ConversationTagAddState> mapEventToState(
      ConversationTagAddEvent event) async* {
    if (event is ConversationTagMessageAdded) {
      yield ConversationTagWaiting();
      try {
        final CRMTag crmTag = await _apiClient.activeCRMTag(
            action: event.action,
            tagId: event.tagId,
            pageId: event.pageId,
            facebookId: event.facebookId);
        yield ConversationTagAddSuccess(crmTag: crmTag);
      } catch (e) {
        yield ConversationTagAddFailure(message: e.toString());
      }
    }
  }
}
