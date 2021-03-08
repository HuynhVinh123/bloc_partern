import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

/// Sự kiện
class ConversationTagEvent {}

/// Hiển thị danh sách tag
class ConversationTagLoaded extends ConversationTagEvent {}

/// Thêm tag
class ConversationTagAdded extends ConversationTagEvent {
  ConversationTagAdded({this.tagId, this.pageId, this.action, this.facebookId});
  String tagId;
  String pageId;
  String action;
  String facebookId;
}

///Trạng thái
abstract class ConversationTagState {}

///Chờ
class ConversationTagWaiting extends ConversationTagState {}

///Danh sách tag
class ConversationTagLoading extends ConversationTagState {
  ConversationTagLoading({
    this.crmTags,
    this.tagStatusFacebook,
  });
  OdataListResult<CRMTag> crmTags;
  TagStatusFacebook tagStatusFacebook;
}

///Tải thất bại
class ConversationLoadFailure extends ConversationTagState {
  ConversationLoadFailure({this.message});
  String message;
}

///Thêm thành công
class ConversationTagAddSuccess extends ConversationTagState {
  ConversationTagAddSuccess({this.crmTag});
  CRMTag crmTag;
}

///Thêm thất bại
class ConversationTagAddFailure extends ConversationTagState {
  ConversationTagAddFailure({this.message});
  String message;
}
class ConversationTagAddError extends ConversationTagState {
  ConversationTagAddError({this.message});
  String message;
}
class ConversationTagBloc
    extends Bloc<ConversationTagEvent, ConversationTagState> {
  ConversationTagBloc({ConversationApi conservationApi})
      : super(ConversationTagWaiting()) {
    _apiClient = conservationApi ?? GetIt.instance<ConversationApi>();
  }
  ConversationApi _apiClient;
  @override
  Stream<ConversationTagState> mapEventToState(
      ConversationTagEvent event) async* {
    yield ConversationTagWaiting();
    if (event is ConversationTagLoaded) {
      try {
        final OdataListResult<CRMTag> crmTags = await _apiClient.getCRMTag();
        yield ConversationTagLoading(
          crmTags: crmTags,
        );
      } catch (e) {
        yield ConversationTagAddFailure(message: e.toString());
      }
    }
    if (event is ConversationTagAdded) {
      yield ConversationTagWaiting();
      try {
        final TagStatusFacebook tagStatusFacebook =
            await _apiClient.activeCRMTag(
                action: event.action,
                tagId: event.tagId,
                pageId: event.pageId,
                facebookId: event.facebookId);
        final OdataListResult<CRMTag> crmTags = await _apiClient.getCRMTag();
        yield ConversationTagLoading(
          crmTags: crmTags,
          tagStatusFacebook: tagStatusFacebook,
        );
      } catch (e) {
        yield ConversationTagAddError(message: e.toString());
      }
    }
  }
}
