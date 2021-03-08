import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ConversationDetailEvent {}

///Tải danh sách chi tiết hội thoại
class ConversationDetailLoaded extends ConversationDetailEvent {
  ConversationDetailLoaded(
      {this.page,
      this.limit,
      this.type,
      this.pageId,
      this.id,
      this.facebookId,
      this.messageConversation});
  int page;
  int limit;
  String type;
  String pageId;
  int id;
  String facebookId;
  MessageConversation messageConversation;
}

class ConversationDetailAdded extends ConversationDetailEvent {
  ConversationDetailAdded(
      {this.message,
      this.facebookId,
      this.toId,
      this.from,
      this.attachments,
      this.page,
      this.type,
      this.id,
      this.pageId,
      this.limit});
  String message;
  String facebookId;
  String toId;
  TPosFacebookUser from;
  Attachment attachments;
  int page;
  int limit;
  String type;
  String pageId;
  int id;
}

class ConversationProductAdded extends ConversationDetailEvent {
  ConversationProductAdded(
      {this.toId,
      this.facebookId,
      this.product,
      this.pageId,
      this.page,
      this.limit,
      this.type,
      this.fsOrder});
  String pageId;
  String facebookId;
  Product product;
  FastSaleOrder fsOrder;
  String toId;
  int page;
  int limit;
  String type;
}

class ConversationImageAdded extends ConversationDetailEvent {
  ConversationImageAdded({this.file});
  File file;
}

abstract class ConversationDetailState {
  ConversationDetailState({this.error});
  String error;
}

class ConversationDetailWaiting extends ConversationDetailState {}

class ConversationDetailLoading extends ConversationDetailState {
  ConversationDetailLoading(
      {this.crmTags,
      this.messageConversation,
      this.getMessageConversationResult});
  GetMessageConversationResult getMessageConversationResult;
  OdataListResult<CRMTag> crmTags;
  MessageConversation messageConversation;
}

class ConversationDetailFailure extends ConversationDetailState {
  ConversationDetailFailure({String error}) : super(error: error);
}

class ConversationDetailAddSuccess extends ConversationDetailState {
  ConversationDetailAddSuccess({this.messageConversation});
  MessageConversation messageConversation;
}

class ConversationDetailAddFailure extends ConversationDetailState {
  ConversationDetailAddFailure({String error}) : super(error: error);
}

class ConversationImageAddSuccess extends ConversationDetailState {
  ConversationImageAddSuccess({this.urlImage});
  String urlImage;
}

/// Thêm sản phẩm nhanh
class ConversationProductAddSuccess extends ConversationDetailState {
  ConversationProductAddSuccess({this.messageConversation});
  MessageConversation messageConversation;
}

class ConversationProductAddFailure extends ConversationDetailState {
  ConversationProductAddFailure({String error}) : super(error: error);
}

class ConversationDetailBloc
    extends Bloc<ConversationDetailEvent, ConversationDetailState> {
  ConversationDetailBloc({ConversationApi conservationApi})
      : super(ConversationDetailWaiting()) {
    _apiClient = conservationApi ?? GetIt.instance<ConversationApi>();
  }
  ConversationApi _apiClient;
  final Logger _logger = Logger();
  @override
  Stream<ConversationDetailState> mapEventToState(
      ConversationDetailEvent event) async* {
    if (event is ConversationDetailLoaded) {
      yield ConversationDetailWaiting();
      try {
        final GetMessageConversationResult getMessageConversationResult =
            await _apiClient.getConversationMessageList(
                type: event.type,
                limit: event.limit,
                page: event.page,
                pageId: event.pageId,
                facebookId: event.facebookId);
        yield ConversationDetailLoading(
            getMessageConversationResult: getMessageConversationResult,
            messageConversation: event.messageConversation);
      } catch (e, stack) {
        _logger.e('ConversationMessageFailure', e, stack);
        yield ConversationDetailFailure(error: e.toString());
      }
    }
    if (event is ConversationDetailAdded) {
      try {
        await _apiClient.addMessage(
            message: event.message,
            toId: event.toId,
            from: event.from,
            facebookId: event.facebookId,
            attachment: event.attachments);
        final GetMessageConversationResult getMessageConversationResult =
            await _apiClient.getConversationMessageList(
                type: event.type,
                limit: event.limit,
                page: event.page,
                pageId: event.pageId,
                facebookId: event.facebookId);
        yield ConversationDetailLoading(
          getMessageConversationResult: getMessageConversationResult,
        );
      } catch (e) {
        yield ConversationDetailAddFailure(error: e.toString());
      }
    } else if (event is ConversationProductAdded) {
      try {
        await _apiClient.addTemplateMessage(
            facebookId: event.facebookId,
            pageId: event.pageId,
            product: event.product,
            toId: event.toId,
            fastSaleOrder: event.fsOrder);
        final GetMessageConversationResult getMessageConversationResult =
            await _apiClient.getConversationMessageList(
                type: event.type,
                limit: event.limit,
                page: event.page,
                pageId: event.pageId,
                facebookId: event.facebookId);
        yield ConversationDetailLoading(
          getMessageConversationResult: getMessageConversationResult,
        );
      } catch (e) {
        yield ConversationDetailAddFailure(error: e.toString());
      }
    }
  }
}
