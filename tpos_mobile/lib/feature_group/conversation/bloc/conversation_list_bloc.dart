import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ConversationListEvent {}

///Tải danh sách hội thoại
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

///Tìm kiếm hội thoại
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

///Chờ
class ConversationWaiting extends ConversationListState {}

///Tải danh sách
class ConversationLoading extends ConversationListState {
  ConversationLoading({this.getListConservationResult, this.unread});
  GetListConversationResult getListConservationResult;
  Unread unread;
}

///Lỗi
class ConversationFailure extends ConversationListState {
  ConversationFailure(this.error);
  String error;
}

class ConversationListBloc
    extends Bloc<ConversationListEvent, ConversationListState> {
  ConversationListBloc({ConversationApi conservationApi})
      : super(ConversationWaiting()) {
    _apiClient = conservationApi ?? GetIt.instance<ConversationApi>();
  }
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
      } catch (e, stack) {
        _logger.e('ConservationSearchFailure', e, stack);
        yield ConversationFailure(e.toString());
      }
    }
  }
}
