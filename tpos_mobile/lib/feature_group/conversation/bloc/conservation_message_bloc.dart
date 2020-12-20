import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';

abstract class ConversationMessageEvent {}

class ConversationMessageInitialized extends ConversationMessageEvent {}

class ConversationMessageLoaded extends ConversationMessageEvent {
  ConversationMessageLoaded(
      {this.page,
      this.limit,
      this.type,
      this.pageId,
      this.id,
      this.facebookId});
  int page;
  int limit;
  String type;
  String pageId;
  int id;
  String facebookId;
}

class ConversationMessageAdded extends ConversationMessageEvent {
  ConversationMessageAdded(
      {this.message, this.facebookId, this.toId, this.from, this.attachment});
  String message;
  String facebookId;
  String toId;
  TPosFacebookUser from;
  Attachment attachment;
}

class ConversationTagAdded extends ConversationMessageEvent {
  ConversationTagAdded({this.tagId, this.pageId, this.action, this.facebookId});
  String tagId;
  String pageId;
  String action;
  String facebookId;
}

class ConversationImageAdded extends ConversationMessageEvent {
  ConversationImageAdded({this.file});
  File file;
}

abstract class ConversationMessageState {}

class ConversationMessageWaiting extends ConversationMessageState {}

class ConversationMessageLoading extends ConversationMessageState {
  ConversationMessageLoading(
      {this.crmTags,
      this.conversationRefetch,
      this.getMessageConversationResult});
  GetMessageConversationResult getMessageConversationResult;
  OdataListResult<CRMTag> crmTags;
  ConversationRefetch conversationRefetch;
}

class ConversationMessageFailure extends ConversationMessageState {
  ConversationMessageFailure({this.error});
  String error;
}

class ConversationMessageAddSuccess extends ConversationMessageState {
  ConversationMessageAddSuccess({this.messageConversation});
  MessageConversation messageConversation;
}

class ConversationTagAddSuccess extends ConversationMessageState {
  ConversationTagAddSuccess({this.crmTag});
  CRMTag crmTag;
}

class ConversationMessageAddFailure extends ConversationMessageState {
  ConversationMessageAddFailure({this.message});
  String message;
}

class ConversationImageAddSuccess extends ConversationMessageState {
  ConversationImageAddSuccess({this.urlImage});
  String urlImage;
}

class ConversationMessageBloc
    extends Bloc<ConversationMessageEvent, ConversationMessageState> {
  ConversationMessageBloc(
      {DialogService dialogService, ConversationApi conservationApi})
      : super(ConversationMessageWaiting()) {
    _dialog = dialogService ?? locator<DialogService>();
    _apiClient = conservationApi ?? GetIt.instance<ConversationApi>();
  }

  DialogService _dialog;
  ConversationApi _apiClient;
  final Logger _logger = Logger();
  @override
  Stream<ConversationMessageState> mapEventToState(
      ConversationMessageEvent event) async* {
    if (event is ConversationMessageLoaded) {
      yield ConversationMessageWaiting();
      try {
        final GetMessageConversationResult getMessageConversationResult =
            await _apiClient.getConversationMessageList(
                type: event.type,
                limit: event.limit,
                page: event.page,
                pageId: event.pageId,
                facebookId: event.facebookId);
        final OdataListResult<CRMTag> crmTags =
            await _apiClient.getCRMTag(isDeleted: false);
        final ConversationRefetch conversationRefetch =
            await _apiClient.refetchConversation(
                facebookId: event.facebookId, pageId: event.pageId);
        yield ConversationMessageLoading(
            conversationRefetch: conversationRefetch,
            crmTags: crmTags,
            getMessageConversationResult: getMessageConversationResult);
      } catch (e, stack) {
        _logger.e('ConversationMessageFailure', e, stack);
        yield ConversationMessageFailure(error: e.toString());
      }
    }
    if (event is ConversationMessageAdded) {
      yield ConversationMessageWaiting();
      try {
        final MessageConversation messageConversation =
            await _apiClient.addMessage(
                message: event.message,
                toId: event.toId,
                from: event.from,
                facebookId: event.facebookId,
                attachment: event.attachment);
        yield ConversationMessageAddSuccess(
            messageConversation: messageConversation);
      } catch (e) {
        print(e.toString());
        yield ConversationMessageAddFailure(message: e.toString());
      }
    }
    if (event is ConversationTagAdded) {
      yield ConversationMessageWaiting();
      try {
        final CRMTag crmTag = await _apiClient.activeCRMTag(
            action: event.action,
            tagId: event.tagId,
            pageId: event.pageId,
            facebookId: event.facebookId);
        yield ConversationTagAddSuccess(crmTag: crmTag);
      } catch (e) {
        yield ConversationMessageAddFailure(message: e.toString());
      }
    }
  }
}
