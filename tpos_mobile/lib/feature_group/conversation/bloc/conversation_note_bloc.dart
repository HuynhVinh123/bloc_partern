import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

/// Sự kiện
class ConversationNoteEvent {}

/// Hiển thị danh sách note
class ConversationNoteLoaded extends ConversationNoteEvent {
  ConversationNoteLoaded({this.pageId, this.facebookId});
  String pageId;
  String facebookId;
}

/// Thêm tag
class ConversationNoteAdded extends ConversationNoteEvent {
  ConversationNoteAdded({this.pageId, this.facebookId, this.message});
  String pageId;
  String facebookId;
  String message;
}

class ConversationNoteDeleted extends ConversationNoteEvent {
  ConversationNoteDeleted({this.id, this.pageId, this.facebookId});
  String id;
  String pageId;
  String facebookId;
}

///Trạng thái
abstract class ConversationNoteState {}

///Chờ
class ConversationNoteWaiting extends ConversationNoteState {}

///Danh sách tag
class ConversationNoteLoading extends ConversationNoteState {
  ConversationNoteLoading({this.getListConversationResult});
  GetListConversationResult getListConversationResult;
}

///Tải thất bại
class ConversationNoteLoadFailure extends ConversationNoteState {
  ConversationNoteLoadFailure({this.message});
  String message;
}

///Thêm thành công
class ConversationNoteAddSuccess extends ConversationNoteState {
  ConversationNoteAddSuccess({this.conversation});
  Conversation conversation;
}

///Thêm thất bại
class ConversationNoteAddFailure extends ConversationNoteState {
  ConversationNoteAddFailure({this.message});
  String message;
}

///Xóa thành công
class ConversationNoteDeleteSuccess extends ConversationNoteState {
  ConversationNoteDeleteSuccess();
}

///Xóa thất bại
class ConversationNoteDeleteFailure extends ConversationNoteState {
  ConversationNoteDeleteFailure(this.error);
  String error;
}

class ConversationNoteBloc
    extends Bloc<ConversationNoteEvent, ConversationNoteState> {
  ConversationNoteBloc({ConversationApi conservationApi})
      : super(ConversationNoteWaiting()) {
    _apiClient = conservationApi ?? GetIt.instance<ConversationApi>();
  }
  ConversationApi _apiClient;
  @override
  Stream<ConversationNoteState> mapEventToState(
      ConversationNoteEvent event) async* {
    if (event is ConversationNoteLoaded) {
      yield ConversationNoteWaiting();
      try {
        final GetListConversationResult getListConversationResult =
            await _apiClient.getNotes(
                pageId: event.pageId, facebookId: event.facebookId);
        yield ConversationNoteLoading(
            getListConversationResult: getListConversationResult);
      } catch (e) {
        yield ConversationNoteLoadFailure(message: e.toString());
      }
    } else if (event is ConversationNoteAdded) {
      yield ConversationNoteWaiting();
      try {
        final Conversation conversation = await _apiClient.insertNote(
            event.message, event.pageId, event.facebookId);
        yield ConversationNoteAddSuccess(conversation: conversation);
      } catch (e) {
        yield ConversationNoteAddFailure(message: e.toString());
      }
    } else if (event is ConversationNoteDeleted) {
      try {
        await _apiClient.deleteNote(event.id);
        final GetListConversationResult getListConversationResult =
            await _apiClient.getNotes(
                pageId: event.pageId, facebookId: event.facebookId);
        yield ConversationNoteLoading(
            getListConversationResult: getListConversationResult);
      } catch (e) {
        yield ConversationNoteDeleteFailure(e.toString());
      }
    }
  }
}
