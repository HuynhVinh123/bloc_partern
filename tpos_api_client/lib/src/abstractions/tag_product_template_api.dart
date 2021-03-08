import 'package:tpos_api_client/src/models/requests/assign_tag_product_template_model.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

abstract class TagProductTemplateApi {
  Future<AssignTagProductTemplateModel> assignTagProductTemplate({AssignTagProductTemplateModel assignModel});
  Future<Tag> insertTag(Tag tag);
  Future<OdataListResult<Tag>> getTagsByType(String type);
}
