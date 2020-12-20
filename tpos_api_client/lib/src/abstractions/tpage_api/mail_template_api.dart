import 'package:tpos_api_client/src/models/entities/mail_template.dart';
import 'package:tpos_api_client/src/models/entities/product/product.dart';
import 'package:tpos_api_client/src/models/entities/tpage/crm_tag.dart';

abstract class MailTemplateApi {
  Future<List<MailTemplate>> getMailTemplateTPage();

  Future<MailTemplate> insertMailTemplateTPage(MailTemplate mailTemplateTPage);

  Future<void> deleteMailTemplateTPage(int mailId);

  Future<void> updateStatusMailTemplateTPage(int mailId);
}
