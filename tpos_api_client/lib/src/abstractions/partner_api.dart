import 'package:flutter/foundation.dart';
import 'package:tpos_api_client/src/model.dart';
import 'package:tpos_api_client/src/models/requests/get_partner_by_id_query.dart';
import 'package:tpos_api_client/src/models/requests/get_partner_for_search_query.dart';
import 'package:tpos_api_client/src/models/results/get_partner_revenue_result.dart';

abstract class PartnerApi {
  Future<OdataListResult<Partner>> getView(GetViewPartnerQuery query);

  Future<Partner> getById(int partnerId, [GetPartnerByIdQuery query]);

  Future<bool> updateStatus(int partnerId, {String status});

  Future<GetPartnerRevenueResult> getRevenueById(int partnerId);

  Future<OdataListResult<Partner>> getForSearch(GetPartnerForSearchQuery query);

  Future<Partner> insert(Partner partner);

  Future<void> update(Partner partner);

  Future<void> delete(int partnerId);

  Future<Partner> createOrUpdate(Partner partner, {int crmTeamId});
  Future<OdataListResult<Partner>> checkPartner(
      {String asuid, @required int crmTeamId});

  Future<List<CreditDebitCustomerDetail>> getCreditDebitCustomerDetail(
      {int id, int top, int skip});
  Future<Partner> checkInfo({String userId, String pageId});
}
