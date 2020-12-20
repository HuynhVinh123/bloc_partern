import 'package:tpos_api_client/tpos_api_client.dart';

abstract class CRMTagApi {
  Future<List<CRMTag>> getCRMTag();

  Future<CRMTag> insertCRMTagTPage(CRMTag tagTPage);

  Future<void> deleteCRMTagTPage(String tagId);

  Future<void> updateCRMTagTPage(CRMTag tagTPage);

  Future<void> updateStatusCRMTagTPage(String tagId);
}
