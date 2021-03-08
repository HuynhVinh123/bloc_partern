import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/tpage/settings/blocs/tags/tag_event.dart';
import 'package:tpos_mobile/feature_group/tpage/settings/blocs/tags/tag_state.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class TagBloc extends Bloc<TagEvent, TagState> {
  TagBloc({CRMTagApi crmTagApi}) : super(TagLoading()) {
    _apiClient = crmTagApi ?? GetIt.instance<CRMTagApi>();
  }

  CRMTagApi _apiClient;

  @override
  Stream<TagState> mapEventToState(TagEvent event) async* {
    if (event is TagLoaded) {
      /// Thực thi lấy thông tin của tag
      yield TagLoading();
      yield* getTags(event);
    } else if (event is TagDeleted) {
      /// Thực thi xóa 1 tag
      yield TagLoading();
      yield* deleteTag(event);
    } else if (event is TagUpdated) {
      /// Thực thi cập nhật  1 tag
      yield TagLoading();
      yield* updateTag(event);
    } else if (event is TagUpdatedStatus) {
      /// Thực thi cập nhật trạng thái của 1 tag
      yield TagLoading();
      yield* updateStatusTag(event);
    } else if (event is TagAdded) {
      /// Thực thi thêm mới 1 tag
      yield TagLoading();
      yield* insertTag(event);
    }
  }

  Stream<TagState> getTags(TagLoaded event) async* {
    try {
      final List<CRMTag> tagTPages = await _apiClient.getCRMTag();
      yield TagLoadSuccess(tagTPages: tagTPages);
    } catch (e) {
      yield TagLoadFailure(title: S.current.error, content: e.toString());
    }
  }

  Stream<TagState> deleteTag(TagDeleted event) async* {
    try {
      await _apiClient.deleteCRMTagTPage(event.id);
      yield ActionSuccess(title: "Thông báo", content: "Xóa thành công!");
    } catch (e) {
      yield TagLoadFailure(title: S.current.error, content: e.toString());
    }
  }

  Stream<TagState> updateTag(TagUpdated event) async* {
    try {
      await _apiClient.updateCRMTagTPage(event.tag);
      yield ActionSuccess(title: "Thông báo", content: "Cập nhật thành công!");
    } catch (e) {
      yield TagLoadFailure(title: S.current.error, content: e.toString());
    }
  }

  Stream<TagState> updateStatusTag(TagUpdatedStatus event) async* {
    try {
      await _apiClient.updateStatusCRMTagTPage(event.tagId);
      yield ActionSuccess(
          title: "Thông báo", content: "Cập nhật trạng thái thành công!");
    } catch (e) {
      yield TagLoadFailure(title: S.current.error, content: e.toString());
    }
  }

  Stream<TagState> insertTag(TagAdded event) async* {
    try {
      final CRMTag tagTPage = await _apiClient.insertCRMTagTPage(event.tag);
      if (tagTPage != null) {
        final List<CRMTag> tagTPages = await _apiClient.getCRMTag();
        yield TagLoadSuccess(tagTPages: tagTPages);
      }
    } catch (e) {
      yield TagLoadFailure(title: S.current.error, content: e.toString());
    }
  }
}
