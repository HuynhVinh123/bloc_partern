import 'package:tpos_api_client/src/model.dart';
import 'package:tpos_api_client/src/models/requests/odata_list_query.dart';
import 'package:tpos_api_client/src/models/requests/odata_query.dart';

abstract class PartnerCategoryApi {
  Future<List<PartnerCategory>> getList({OdataListQuery odataListQuery});

  Future<PartnerCategory> getById(int id, {OdataObjectQuery query});

  Future<void> update(PartnerCategory partnerCategory);

  Future<void> delete(int categoryId);

  Future<PartnerCategory> insert(PartnerCategory partnerCategory);
}
