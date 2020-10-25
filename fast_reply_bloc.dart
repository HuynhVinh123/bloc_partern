import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/tpage/settings/blocs/fast_reply/fast_reply_event.dart';
import 'package:tpos_mobile/feature_group/tpage/settings/blocs/fast_reply/fast_reply_state.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';

class FastReplyBloc extends Bloc<FastReplyEvent, FastReplyState> {
  FastReplyBloc({SettingTPageApi settingTPageApi, DialogService dialogService})
      : super(FastReplyLoading()) {
    _apiClient = settingTPageApi ?? GetIt.instance<SettingTPageApi>();
    _dialog = dialogService ?? locator<DialogService>();
  }

  SettingTPageApi _apiClient;
  DialogService _dialog;

  @override
  Stream<FastReplyState> mapEventToState(FastReplyEvent event) async* {
    if (event is FastReplyLoaded) {
      yield FastReplyLoading();
      yield* getFastReply(event);
    } else if (event is FastReplyAdded) {
      yield FastReplyLoading();
      yield* addFastReply(event);
    } else if (event is FastReplyStatusUpdated) {
      yield FastReplyLoading();
      yield* updateStatusFastReply(event);
    } else if (event is FastReplyDeleted) {
      yield FastReplyLoading();
      yield* deleteFastReply(event);
    }
  }

  Stream<FastReplyState> getFastReply(FastReplyLoaded event) async* {
    try {
      final List<MailTemplateTPage> mailTemplates =
          await _apiClient.getMailTemplateTPage();
      yield FastReplyLoadSuccess(mailTemplates: mailTemplates);
    } catch (e) {
      yield FastReplyLoadFailure(title: "Lỗi", content: e.toString());
    }
  }

  Stream<FastReplyState> addFastReply(FastReplyAdded event) async* {
    try {
      final MailTemplateTPage mailTemplates =
          await _apiClient.insertMailTemplateTPage(event.mailTemplateTPage);
      if (mailTemplates != null) {
        yield ActionSuccess(title: "Thông báo", content: "Thêm thành công!");
      }
    } catch (e) {
      yield FastReplyLoadFailure(title: "Lỗi", content: e.toString());
    }
  }

  Stream<FastReplyState> updateStatusFastReply(
      FastReplyStatusUpdated event) async* {
    try {
      await _apiClient.updateStatusMailTemplateTPage(event.id);
      final List<MailTemplateTPage> mailTemplates =
          await _apiClient.getMailTemplateTPage();
      yield FastReplyLoadSuccess(mailTemplates: mailTemplates);
    } catch (e) {
      yield FastReplyLoadFailure(title: "Lỗi", content: e.toString());
    }
  }

  Stream<FastReplyState> deleteFastReply(FastReplyDeleted event) async* {
    try {
      await _apiClient.deleteMailTemplateTPage(event.id);
      final List<MailTemplateTPage> mailTemplates =
          await _apiClient.getMailTemplateTPage();
      yield FastReplyLoadSuccess(mailTemplates: mailTemplates);
    } catch (e) {
      yield ActionFailed(title: "Lỗi", content: e.toString());
    }
  }
}
