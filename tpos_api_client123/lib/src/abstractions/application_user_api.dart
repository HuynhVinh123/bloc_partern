import 'package:tpos_api_client/src/models/results/change_current_company_get_result.dart';

import '../../tpos_api_client.dart';

abstract class ApplicationUserApi {
  Future<ChangeCurrentCompanyGetResult> changeCurrentCompanyGet();
  Future<ApplicationUser> getCurrentUser();
  Future<void> switchCompany(int companyId);
}
