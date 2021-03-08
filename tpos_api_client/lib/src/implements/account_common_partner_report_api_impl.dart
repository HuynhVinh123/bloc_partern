import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/src/abstractions/account_common_partner_report_api.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

class AccountCommonPartnerReportApiImpl
    implements AccountCommonPartnerReportApi {
  AccountCommonPartnerReportApiImpl({TPosApiClient apiClient}) {
    _apiClient = apiClient ?? GetIt.instance<TPosApi>();
  }
  TPosApiClient _apiClient;
  @override
  Future<AccountCommonPartnerReportResult> getPartnerReports(
      {String display,
      DateTime dateFrom,
      DateTime dateTo,
      int take,
      int skip,
      int page,
      int pageSize,
      String resultSelection,
      String companyId,
      String partnerId,
      String userId,
      String categId,
      int type}) async {
    final Map<String, dynamic> mapBody = {
      "DateFrom": dateFrom.toIso8601String(),
      "DateTo": dateTo.toIso8601String(),
      "Display": display,
      "page": page,
      "pageSize": pageSize,
      "PartnerId": partnerId,
      "ResultSelection": resultSelection,
      "skip": skip,
      "take": take,
      "UserId": userId,
      "CategId": categId,
      "CompanyId": companyId,
    }..removeWhere((key, value) => value == null);
    final response = await _apiClient.httpPost(
        type == 0
            ? "/AccountCommonPartnerReport/ReportSummary"
            : '/AccountCommonPartnerReport/ReportStaffSummary',
        data: mapBody);
    return AccountCommonPartnerReportResult.fromJson(response);
  }

  @override
  Future<AccountCommonPartnerReportResult> getReportStaffDetail(
      {DateTime dateFrom,
      DateTime dateTo,
      int take,
      int skip,
      int page,
      int pageSize,
      String resultSelection,
      String partnerId,
      int type}) async {
    final Map<String, dynamic> mapBody = {
      "DateFrom": dateFrom?.toIso8601String(),
      "DateTo": dateTo?.toIso8601String(),
      "page": page,
      "pageSize": pageSize,
      "PartnerId": partnerId,
      "ResultSelection": resultSelection,
      "skip": skip,
      "take": take,
    }..removeWhere((key, value) => value == null);
    final response = await _apiClient.httpPost(
        type == 0
            ? "/AccountCommonPartnerReport/ReportDetail"
            : '/AccountCommonPartnerReport/ReportStaffDetail',
        data: mapBody);
    return AccountCommonPartnerReportResult.fromJson(response);
  }
}
