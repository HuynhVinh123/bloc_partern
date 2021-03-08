import 'package:tpos_api_client/src/model.dart';

abstract class TagPartnerApi {
  Future<AssignTagPartnerModel> assignTag(AssignTagPartnerModel model);
  Future<OdataListResult<Tag>> getTagsByType(String type);
  Future<OdataListResult<Tag>> getTags(
      {int top, int skip, String keyWord, List<String> typeTags});
  Future<void> deleteTag(int tagId);
  Future<Tag> getTagById(int tagId);
  Future<void> updateTag(Tag tag);
  Future<Tag> insertTag(Tag tag);
}
