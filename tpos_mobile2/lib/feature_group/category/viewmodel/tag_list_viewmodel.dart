import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tmt_flutter_untils/sources/string_utils/string_utils.dart';

import '../../../locator.dart';

class TagListViewModel extends ViewModelBase {
  TagListViewModel();

  final Logger _logger = Logger();
  final DialogService _dialog = locator<DialogService>();

  final TagPartnerApi _tagPartnerApi = GetIt.I<TagPartnerApi>();
  List<Tag> tags = [];
  List<Tag> tagDefaults = [];
  bool isSearch = true;

  void addTag(String nameTag) {
    final Tag tag = Tag();
    tag.name = nameTag;
    tag.id = 0;
    tagDefaults.add(tag);
    searchTag(nameTag);
  }

  bool isCheckNameTag(String nameTag) {
    final bool isCheck = tagDefaults.any((element) => nameTag == element.name);
    return isCheck;
  }

  void showError() {
    _dialog.showError(
        title: "Thông báo", content: "Tên tag không được trùng nhau.");
  }

  void changeSearch() {
    isSearch = !isSearch;
    notifyListeners();
  }

  /// get Tag
  Future<void> getTags() async {
    try {
      final result = await _tagPartnerApi.getTagsByType('partner');
      if (result != null) {
        tags = result.value;
      }
    } catch (e, s) {
      _logger.e("", e, s);
      _dialog.showError(error: e);
    }
  }

  void searchTag(String keyWord) {
    final List<Tag> findTag = [];
    final List<Tag> searchTags = tagDefaults;
    setState(true);
    if (keyWord == "") {
      tags = tagDefaults;
    } else {
      for (var i = 0; i < searchTags.length; i++) {
        if (StringUtils.removeVietnameseMark(searchTags[i].name)
            .toLowerCase()
            .contains(
                StringUtils.removeVietnameseMark(keyWord.toLowerCase()))) {
          findTag.add(searchTags[i]);
        }
      }
      tags = findTag;
    }
    setState(false);
  }
}
