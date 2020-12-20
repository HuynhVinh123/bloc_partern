import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/src/abstractions/tpage_api/mail_template_api.dart';
import 'package:tpos_api_client/src/abstractions/tpage_api/product_tpage_api.dart';
import 'package:tpos_api_client/src/models/entities/tpage/crm_tag.dart';

import '../../../tpos_api_client.dart';

class MailTemplateApiImpl implements MailTemplateApi {
  MailTemplateApiImpl({TPosApiClient apiClient}) {
    _apiClient = apiClient ?? GetIt.instance<TPosApi>();
  }
  TPosApiClient _apiClient;

  @override
  Future<List<MailTemplate>> getMailTemplateTPage() async {
    List<MailTemplate> mailTemplates = [];
    final response = await _apiClient.httpGet("/odata/MailTemplate");
    mailTemplates = (response["value"] as List)
        .map((e) => MailTemplate.fromJson(e))
        .toList();
    return mailTemplates;
  }

  @override
  Future<MailTemplate> insertMailTemplateTPage(
      MailTemplate mailTemplateTPage) async {
    final Map<String, dynamic> mapBody = mailTemplateTPage.toJson(true);
    final String body = json.encode(mapBody);
    final response =
        await _apiClient.httpPost("/odata/MailTemplate", data: body);
    return MailTemplate.fromJson(response);
  }

  @override
  Future<void> updateStatusMailTemplateTPage(int mailId) async {
    await _apiClient
        .httpPost("/odata/MailTemplate($mailId)/ODataService.UpdateStatus");
  }

  @override
  Future<void> deleteMailTemplateTPage(int mailId) async {
    await _apiClient.httpDelete("/odata/MailTemplate($mailId)");
  }
}
