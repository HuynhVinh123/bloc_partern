import 'package:tpos_api_client/tpos_api_client.dart';

abstract class AccountCommonPartnerReportApi {
  Future<AccountCommonPartnerReportResult> getPartnerReports({
    String display,
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
    int type,
  });
  Future<AccountCommonPartnerReportResult> getReportStaffDetail({
    DateTime dateFrom,
    DateTime dateTo,
    int take,
    int skip,
    int page,
    int pageSize,
    String resultSelection,
    String partnerId,
  });
}
