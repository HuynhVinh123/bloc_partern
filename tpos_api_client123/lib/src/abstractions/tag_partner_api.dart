import 'package:tpos_api_client/src/model.dart';

abstract class TagPartnerApi {
  Future<AssignTagPartnerModel> assignTag(AssignTagPartnerModel model);
  Future<OdataListResult<Tag>> getTagsByType (String type);
}
