import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/tag/bloc/tag_event.dart';
import 'package:tpos_mobile/feature_group/tag/bloc/tag_state.dart';

class TagBloc extends Bloc<TagEvent, TagState> {
  TagBloc({TagPartnerApi tagPartnerApi}) : super(TagLoading()) {
    _tagPartnerApi = tagPartnerApi ?? GetIt.I<TagPartnerApi>();
  }
  TagPartnerApi _tagPartnerApi;

  @override
  Stream<TagState> mapEventToState(TagEvent event) async* {
    if (event is TagLoaded) {
      if(event.isReload){
        yield TagRefreshLoading();
      }else {
        yield TagLoading();
      }
      yield* _getTags(event);
    } else if (event is TagLoadMoreLoaded) {
      yield TagLoadMoreLoading();
      yield* _getTagLoadMores(event);
    } else if (event is TagDeleted) {
      yield TagLoading();
      yield* _deleteTag(event);
    } else if (event is TagUpdated) {
      yield TagLoading();
      yield* _updateTag(event);
    } else if (event is TagAdded) {
      yield TagLoading();
      yield* _insertTag(event);
    }else if(event is TagDeleteLocal){
      yield TagLoading();
      yield* _deleteLocalTag(event);
    }else if(event is TagLoadLocal){
      yield TagLoadSuccess(odataTag: event.odataTag);
    }
  }

  Stream<TagState> _getTags(TagLoaded event) async* {
    try {
      final result = await _tagPartnerApi.getTags(
          skip: event.skip, top: event.top, keyWord: event.keyWord,typeTags: event.tagTypes);
      if (result.value.length >= event.top) {
        result.value.add(tempTag);
      }
      yield TagLoadSuccess(odataTag: result);
    } catch (e) {
      yield TagLoadFailure(title: "Thông báo", message: e.toString());
    }
  }

  Stream<TagState> _getTagLoadMores(TagLoadMoreLoaded event) async* {
    try {
      event.odataTag.value
          .removeWhere((element) => element.name == tempTag.name);
      final resultLoadMore =
          await _tagPartnerApi.getTags(skip: event.skip, top: event.top, keyWord: event.keyWord,typeTags: event.tagTypes);
      if (resultLoadMore.value.length >= event.top) {
        resultLoadMore.value.add(tempTag);
      }
      event.odataTag.value.addAll(resultLoadMore.value);
      yield TagLoadSuccess(odataTag: event.odataTag);
    } catch (e) {
      yield TagLoadFailure(title: "Thông báo", message: e.toString());
    }
  }

  Stream<TagState> _deleteTag(TagDeleted event) async* {
    try {
      await _tagPartnerApi.deleteTag(event.tagId);
      yield ActionSuccess(title: "Thông báo", message: "Xóa thành công!");
    } catch (e) {
      yield ActionFailure(title: "Lỗi", message: e.toString());
    }
  }

  Stream<TagState> _deleteLocalTag(TagDeleteLocal event) async* {
    try {
      // ignore: list_remove_unrelated_type
      event.odataTag.value.remove(event.tag);
      yield TagLoadSuccess(odataTag: event.odataTag);
    } catch (e) {
      yield ActionFailure(title: "Lỗi", message: e.toString());
    }
  }

  Stream<TagState> _updateTag(TagUpdated event) async* {
    try {
      await _tagPartnerApi.updateTag(event.tag);
      yield ActionSuccess(title: "Thông báo", message: "Cập nhật thành công!");
    } catch (e) {
      yield ActionFailure(title: "Lỗi", message: e.toString());
    }
  }

  Stream<TagState> _insertTag(TagAdded event) async* {
    try {
      await _tagPartnerApi.insertTag(event.tag);
      yield ActionSuccess(title: "Thông báo", message: "Thêm thành công!");
    } catch (e) {
      yield ActionFailure(title: "Lỗi", message: e.toString());
    }
  }
}

var tempTag = Tag(name: "temp");
