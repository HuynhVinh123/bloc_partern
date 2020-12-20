import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/src/abstractions/partner_api.dart';
import 'package:tpos_api_client/src/models/entities/credit_debit_customer_detail.dart';
import 'package:tpos_api_client/src/models/entities/partner.dart';
import 'package:tpos_api_client/src/models/requests/get_partner_by_id_query.dart';
import 'package:tpos_api_client/src/models/requests/get_partner_for_search_query.dart';
import 'package:tpos_api_client/src/models/requests/get_view_partner_query.dart';
import 'package:tpos_api_client/src/models/results/get_partner_revenue_result.dart';
import 'package:tpos_api_client/src/models/results/odata_list_result.dart';

import '../abstraction.dart';

class PartnerApiImpl implements PartnerApi {
  PartnerApiImpl({TPosApi tPosApi}) {
    _apiClient = tPosApi ?? GetIt.I<TPosApi>();
  }

  static const getViewPath = '/odata/Partner/ODataService.GetView';
  static const getByIdPath = '/odata/Partner({partnerId})';
  TPosApi _apiClient;
  @override
  Future<OdataListResult<Partner>> getView(GetViewPartnerQuery query) async {
    final json = await _apiClient.httpGet(
      getViewPath,
      parameters: query?.toJson(true),
    );

    return OdataListResult<Partner>.fromJson(json);
  }

  @override
  Future<Partner> getById(int partnerId, [GetPartnerByIdQuery query]) async {
    final json = await _apiClient.httpGet(
      '/odata/Partner($partnerId)',
      parameters:
          query?.toJson(true) ?? const GetPartnerByIdQuery().toJson(true),
    );
    return Partner.fromJson(json);
  }

  @override
  Future<bool> updateStatus(int partnerId, {String status}) async {
    final body = {"status": status};
    final result = await _apiClient.httpPost(
        '/odata/Partner($partnerId)/ODataService.UpdateStatus',
        data: body);

    return result['value'];
  }

  @override
  Future<GetPartnerRevenueResult> getRevenueById(int partnerId) async {
    final json = await _apiClient.httpGet('/partner/GetPartnerRevenueById',
        parameters: {'id': partnerId});

    return GetPartnerRevenueResult.fromJson(json);
  }

  @override
  Future<OdataListResult<Partner>> getForSearch(
      GetPartnerForSearchQuery query) async {
    final json = await _apiClient.httpGet('/odata/Partner',
        parameters: query?.toJson(true));
    return OdataListResult<Partner>.fromJson(json);
  }

  @override
  Future<Partner> insert(Partner partner) async {
    assert(partner.birthDay == null || partner.birthDay.isUtc,
        'Birthday field must be utc time');
    final json =
        await _apiClient.httpPost('/odata/Partner', data: partner.toJson(true));
    return Partner.fromJson(json);
  }

  @override
  Future<void> update(Partner partner) async {
    await _apiClient.httpPut(
      '/odata/Partner(${partner.id})',
      data: partner.toJson(true),
    );
  }

  @override
  Future<void> delete(int partnerId) async {
    await _apiClient.httpDelete('/odata/Partner($partnerId)');
  }

  @override
  Future<Partner> createOrUpdate(Partner partner, {int crmTeamId}) async {
    final json = await _apiClient.httpPost(
      '/odata/SaleOnline_Order/ODataService.CreateUpdatePartner',
      data: {
        'model': partner.toJson(true),
        'teamId': crmTeamId,
      }..removeWhere((key, value) => value == null),
    );
    return Partner.fromJson(json);
  }

  @override
  Future<OdataListResult<Partner>> checkPartner(
      {String asuid, int crmTeamId}) async {
    final json = await _apiClient.httpGet(
      '/odata/SaleOnline_Order/ODataService.CheckPartner',
      parameters: {
        'ASUId': asuid,
        'teamId': crmTeamId,
      }..removeWhere((key, value) => value == null),
    );

    return OdataListResult<Partner>.fromJson(json);
  }

  @override
  Future<List<CreditDebitCustomerDetail>> getCreditDebitCustomerDetail(
      {int id, int top, int skip}) async {
    final json = await _apiClient.httpGet(
        "/Partner/CreditDebitCustomerDetail?partnerId=$id&take=$top&skip=$skip&\$orderby=Date+desc");
    return (json['Data'] as List)
        .map((e) => CreditDebitCustomerDetail.fromJson(e))
        .toList();
  }
}
