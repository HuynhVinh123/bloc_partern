import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/src/abstractions/tag_product_template_api.dart';
import 'package:tpos_api_client/src/models/requests/assign_tag_product_template_model.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

class TagProductTemplateApiImpl implements TagProductTemplateApi {
  TagProductTemplateApiImpl({TPosApi apiClient}) {
    _apiClient = apiClient ?? GetIt.I<TPosApi>();
  }

  static const String assignProductTemplatePath = '/odata/TagProductTemplate/ODataService.AssignTagProductTemplate';
  TPosApi _apiClient;

  @override
  Future<AssignTagProductTemplateModel> assignTagProductTemplate({AssignTagProductTemplateModel assignModel}) async {
    final json = await _apiClient.httpPost(assignProductTemplatePath, data: assignModel.toJson(true));
    return AssignTagProductTemplateModel.fromJson(json);
  }

  @override
  Future<Tag> insertTag(Tag tag) async {
    final response = await _apiClient.httpPost("/odata/Tag", data: tag.toJson(true));
    return Tag.fromJson(response);
  }

  @override
  Future<OdataListResult<Tag>> getTagsByType(String type) async {
    final Map<String, dynamic> param = <String, dynamic>{};

    if (type != null) {
      param['type'] = type;
    }

    final json = await _apiClient.httpGet('/odata/Tag/ODataService.GetByType',
        parameters: param);
    return OdataListResult<Tag>.fromJson(json);
  }
}
