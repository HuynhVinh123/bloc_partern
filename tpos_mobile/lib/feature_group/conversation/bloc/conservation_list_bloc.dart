import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';

abstract class ConversationListEvent {}

class ConversationInitialized extends ConversationListEvent {}

class ConversationLoaded extends ConversationListEvent {
  ConversationLoaded(
      {this.page,
      this.limit,
      this.type,
      this.pageId,
      this.id,
      this.keyword,
      this.tagIds,
      this.userIds,
      this.start,
      this.end,
      this.hasPhone,
      this.hasAddress,
      this.hasOrder,
      this.hasUnread});
  int page;
  int limit;
  String type;
  String pageId;
  int id;
  String keyword;
  String tagIds;
  String userIds;
  DateTime start;
  DateTime end;
  bool hasPhone;
  bool hasAddress;
  bool hasOrder;
  bool hasUnread;
}

class ConversationSearchLoaded extends ConversationListEvent {
  ConversationSearchLoaded(
      {this.page,
      this.limit,
      this.type,
      this.pageId,
      this.id,
      this.keyword,
      this.nameStart});
  int page;
  int limit;
  String type;
  String pageId;
  int id;
  String keyword;
  String nameStart;
}

abstract class ConversationListState {}

class ConversationWaiting extends ConversationListState {}

class ConversationLoading extends ConversationListState {
  ConversationLoading({this.getListConservationResult, this.unread});
  GetListConversationResult getListConservationResult;
  Unread unread;
}

class ConversationFailure extends ConversationListState {
  ConversationFailure(this.error);
  String error;
}

class ConversationListBloc
    extends Bloc<ConversationListEvent, ConversationListState> {
  ConversationListBloc(
      {DialogService dialogService, ConversationApi conservationApi})
      : super(ConversationWaiting()) {
    _dialog = dialogService ?? locator<DialogService>();
    _apiClient = conservationApi ?? GetIt.instance<ConversationApi>();
  }

  DialogService _dialog;
  ConversationApi _apiClient;
  final Logger _logger = Logger();
  @override
  Stream<ConversationListState> mapEventToState(
      ConversationListEvent event) async* {
    if (event is ConversationLoaded) {
      yield ConversationWaiting();
      try {
        Unread unread;
        final GetListConversationResult getListConservationResult =
            await _apiClient.getListConversationResult(
                type: event.type,
                page: event.page,
                limit: event.limit,
                pageId: event.pageId,
                end: event.end,
                start: event.start,
                hasAddress: event.hasAddress,
                hasOrder: event.hasOrder,
                hasPhone: event.hasPhone,
                hasUnread: event.hasUnread,
                tagIds: event.tagIds,
                userIds: event.userIds);
        if (event?.id != null) {
          unread = await _apiClient.getUnread(id: event?.id.toString());
        }
        yield ConversationLoading(
            getListConservationResult: getListConservationResult,
            unread: unread);
      } catch (e, stack) {
        _logger.e('ConservationLoadFailure', e, stack);
        yield ConversationFailure(e.toString());
      }
    }
    if (event is ConversationSearchLoaded) {
      yield ConversationWaiting();
      try {
        Unread unread;
        final GetListConversationResult getListConservationResult =
            await _apiClient.getListConversationResultBySearch(
                type: event.type,
                page: event.page,
                limit: event.limit,
                pageId: event.pageId,
                search: event.keyword,
                nameStart: event.nameStart);

        if (event.id != null) {
          unread = await _apiClient.getUnread(id: event.id.toString());
        }
        yield ConversationLoading(
            getListConservationResult: getListConservationResult,
            unread: unread);
      } catch (e) {
        yield ConversationFailure(e.toString());
      }
    }
  }
}
