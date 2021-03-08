import 'package:tpos_api_client/src/models/entities/account_common_partner_report.dart';

class AccountCommonPartnerReportResult {
  AccountCommonPartnerReportResult.fromJson(Map<String, dynamic> json) {
    total = double.parse(json['Total']?.toString());
    data = (json['Data'] as List<dynamic>)
        .map((dynamic f) => AccountCommonPartnerReport.fromJson(f))
        .toList();
  }
  double total;
  List<AccountCommonPartnerReport> data;
}
