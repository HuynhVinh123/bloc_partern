import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/tag/bloc/tag_category_info/tag_category_info_event.dart';
import 'package:tpos_mobile/feature_group/tag/bloc/tag_category_info/tag_category_info_state.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class TagCategoryInfoBloc
    extends Bloc<TagCategoryInfoEvent, TagCategoryInfoState> {
  TagCategoryInfoBloc({TagPartnerApi tagPartnerApi})
      : super(TagCategoryInfoLoading()) {
    _tagPartnerApi = tagPartnerApi ?? GetIt.I<TagPartnerApi>();
  }

  TagPartnerApi _tagPartnerApi;

  @override
  Stream<TagCategoryInfoState> mapEventToState(
      TagCategoryInfoEvent event) async* {
    if (event is TagCategoryInfoDeleted) {
      /// Thực hiện xóa nhãn
      yield TagCategoryInfoLoading();
      yield* deleteTag(event);
    } else if (event is TagCategoryInfoLoaded) {
      /// Thực hiện lấy thông tin chi tiết nhãn
      yield TagCategoryInfoLoading();
      yield* getById(event);
    } else if (event is TagCategoryLoadLocal) {
      /// Thực hiện cập nhật dữ liệu được truyên qua từ list
      yield* _getDataFromLocal(event);
    }
  }

  Stream<TagCategoryInfoState> deleteTag(TagCategoryInfoDeleted event) async* {
    try {
      await _tagPartnerApi.deleteTag(event.tagId);
      yield TagCategoryInfoActionSuccess(
          title: S.current.notification, message: S.current.deleteSuccessful);
    } catch (e) {
      yield TagCategoryInfoActionFailure(
          title: S.current.error, message: e.toString());
    }
  }

  Stream<TagCategoryInfoState> getById(TagCategoryInfoLoaded event) async* {
    try {
      final result = await _tagPartnerApi.getTagById(event.id);
      yield TagCategoryInfoLoadSuccess(tag: result);
    } catch (e) {
      yield TagCategoryInfoActionFailure(
          title: S.current.error, message: e.toString());
    }
  }

  Stream<TagCategoryInfoState> _getDataFromLocal(
      TagCategoryLoadLocal event) async* {
    try {
      final Tag tag = event.tag;
      yield TagCategoryInfoLoadSuccess(tag: tag);
    } catch (e) {
      yield TagCategoryInfoActionFailure(
          title: S.current.error, message: e.toString());
    }
  }
}
