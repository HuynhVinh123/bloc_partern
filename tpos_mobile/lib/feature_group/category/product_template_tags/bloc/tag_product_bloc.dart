import 'package:diacritic/diacritic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/product_template_tags/bloc/tag_product_event.dart';
import 'package:tpos_mobile/feature_group/category/product_template_tags/bloc/tag_product_state.dart';

///TODO: có thể thêm chức năng lấy danh sách tag từ server khi cần thiết,
///kiểm tra xem event [TagProductStarted] có truyền vào danh sách tag không
class TagProductBloc extends Bloc<TagProductEvent, TagProductState> {
  TagProductBloc({TagProductTemplateApi tagProductTemplateApi}) : super(TagProductLoading(tags: [])) {
    _tagProductTemplateApi = tagProductTemplateApi ?? GetIt.I<TagProductTemplateApi>();
  }

  List<Tag> _tags = [];
  TagProductTemplateApi _tagProductTemplateApi;
  final Logger _logger = Logger();
  String _search = '';

  @override
  Stream<TagProductState> mapEventToState(TagProductEvent event) async* {
    if (event is TagProductStarted) {
      yield TagProductLoading(tags: _tags);
      try {
        _tags = event.tags;

        if (_tags == null) {
          final OdataListResult<Tag> odataListResult = await _tagProductTemplateApi.getTagsByType('producttemplate');
          _tags = odataListResult.value;
        }

        yield TagProductLoadSuccess(tags: _tags);
      } catch (e, stack) {
        _logger.e('TagProductLoadFailure', e, stack);
        yield TagProductLoadFailure(error: e.toString(), tags: _tags);
      }
    } else if (event is TagProductSearched) {
      yield TagProductBusy(tags: _tags);
      _search = event.keyword.toLowerCase().trim();
      List<Tag> searchTags;

      if (_search != '') {
        searchTags = _tags
            .where((Tag tag) =>
                tag.name.toLowerCase().contains(_search) ||
                tag.nameNosign.toLowerCase().contains(removeDiacritics(_search)))
            .toList();
      }

      yield TagProductLoadSuccess(tags: searchTags ?? _tags);
    } else if (event is TagProductAdded) {
      yield TagProductBusy(tags: _tags);
      try {
        final List<Tag> addTags = [];
        addTags.addAll(_tags);
        addTags.add(event.tag);
        await _tagProductTemplateApi.insertTag(event.tag);
        _tags.add(event.tag);
        List<Tag> searchTags;

        if (_search != '') {
          searchTags = _tags
              .where((Tag tag) =>
                  tag.name.toLowerCase().contains(_search) ||
                  tag.nameNosign.toLowerCase().contains(removeDiacritics(_search)))
              .toList();
        }

        yield TagProductAddTagSuccess(tags: searchTags ?? _tags);
      } catch (e, stack) {
        _logger.e('TagProductAddTagFailure', e, stack);
        yield TagProductAddTagFailure(error: e.toString(), tags: _tags);
      }
    }
  }
}
