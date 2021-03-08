import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/tag/bloc/tag_category_add_edit/tag_category_add_edit_event.dart';
import 'package:tpos_mobile/feature_group/tag/bloc/tag_category_add_edit/tag_category_add_edit_state.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class TagCategoryAddEditBloc
    extends Bloc<TagCategoryAddEditEvent, TagCategoryAddEditState> {
  TagCategoryAddEditBloc({TagPartnerApi tagPartnerApi}) : super(InitLoading()) {
    _tagPartnerApi = tagPartnerApi ?? GetIt.I<TagPartnerApi>();
  }

  TagPartnerApi _tagPartnerApi;

  @override
  Stream<TagCategoryAddEditState> mapEventToState(
      TagCategoryAddEditEvent event) async* {
    yield TagCategoryAddEditLoading();
    if (event is TagCategoryUpdated) {
      /// Thực hiện cập nhật nhãn
      yield* updateTag(event);
    } else if (event is TagCategoryAdded) {
      /// Thực hiện thêm nhãn
      yield* addTag(event);
    }
  }

  Stream<TagCategoryAddEditState> updateTag(TagCategoryUpdated event) async* {
    try {
      await _tagPartnerApi.updateTag(event.tag);
      yield TagCategoryAddEditActionSuccess(
          title: S.current.notification, message: S.current.updateSuccessful);
    } catch (e) {
      yield TagCategoryAddEditActionFailure(
          title: S.current.error, message: e.toString());
    }
  }

  Stream<TagCategoryAddEditState> addTag(TagCategoryAdded event) async* {
    try {
      await _tagPartnerApi.insertTag(event.tag);
      yield TagCategoryAddEditActionSuccess(
          title: S.current.notification, message: S.current.addSuccessful);
    } catch (e) {
      yield TagCategoryAddEditActionFailure(
          title: S.current.error, message: e.toString());
    }
  }
}
