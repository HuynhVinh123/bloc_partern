import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/tpage/settings/blocs/tags/tag_event.dart';
import 'package:tpos_mobile/feature_group/tpage/settings/blocs/tags/tag_state.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class TagBloc extends Bloc<TagEvent, TagState> {
  TagBloc({SettingTPageApi settingTPageApi, DialogService dialogService})
      : super(TagLoading()) {
    _apiClient = settingTPageApi ?? GetIt.instance<SettingTPageApi>();
    _dialog = dialogService ?? locator<DialogService>();
  }

  SettingTPageApi _apiClient;
  DialogService _dialog;

  @override
  Stream<TagState> mapEventToState(TagEvent event) async* {
    if (event is TagLoaded) {
      yield TagLoading();
      yield* getTags(event);
    } else if (event is TagDeleted) {
      yield TagLoading();
      yield* deleteTag(event);
    } else if (event is TagUpdated) {
      yield TagLoading();
      yield* updateTag(event);
    } else if (event is TagUpdatedStatus) {
      yield TagLoading();
      yield* updateStatusTag(event);
    } else if (event is TagAdded) {
      yield TagLoading();
      yield* insertTag(event);
    }
  }

  Stream<TagState> getTags(TagLoaded event) async* {
    try {
      final List<TagTPage> tagTPages = await _apiClient.getCRMTag();
      yield TagLoadSuccess(tagTPages: tagTPages);
    } catch (e) {
      yield TagLoadFailure(title: S.current.error, content: e.toString());
    }
  }

  Stream<TagState> deleteTag(TagDeleted event) async* {
    try {
      await _apiClient.deleteTagTPage(event.id);
      yield ActionSuccess(title: "Thông báo", content: "Xóa thành công!");
    } catch (e) {
      yield TagLoadFailure(title: S.current.error, content: e.toString());
    }
  }

  Stream<TagState> updateTag(TagUpdated event) async* {
    try {
      await _apiClient.updateTagTPage(event.tag);
      yield ActionSuccess(title: "Thông báo", content: "Cập nhật thành công!");
    } catch (e) {
      yield TagLoadFailure(title: S.current.error, content: e.toString());
    }
  }

  Stream<TagState> updateStatusTag(TagUpdatedStatus event) async* {
    try {
      await _apiClient.updateStatusTagTPage(event.tagId);
      yield ActionSuccess(
          title: "Thông báo", content: "Cập nhật trạng thái thành công!");
    } catch (e) {
      yield TagLoadFailure(title: S.current.error, content: e.toString());
    }
  }

  Stream<TagState> insertTag(TagAdded event) async* {
    try {
      final TagTPage tagTPage = await _apiClient.insertTagTPage(event.tag);
      if (tagTPage != null) {
        final List<TagTPage> tagTPages = await _apiClient.getCRMTag();
        yield TagLoadSuccess(tagTPages: tagTPages);
      }
    } catch (e) {
      yield TagLoadFailure(title: S.current.error, content: e.toString());
    }
  }
}
