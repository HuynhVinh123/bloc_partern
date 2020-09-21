import '../../app_core/template_models/app_filter_date_model.dart';
import '../../src/tpos_apis/models/company_of_user.dart';
import '../../src/tpos_apis/models/partner.dart';
import '../../src/tpos_apis/models/user_report_staff.dart';

class Filter {
  Filter(
      {this.dateFrom,
      this.dateTo,
      this.isFilterByInvoiceType,
      this.filterDateRange,
      this.orderType,
      this.isFilterByCompany,
      this.isFilterByPartner,
      this.isFilterByStaff,
      this.userReportStaffOrder,
      this.companyOfUser,
      this.partner});

  DateTime dateFrom;
  DateTime dateTo;
  bool isFilterByCompany,
      isFilterByStaff,
      isFilterByPartner,
      isFilterByInvoiceType;

  AppFilterDateModel filterDateRange;
  Partner partner;
  CompanyOfUser companyOfUser ;
  UserReportStaff userReportStaffOrder ;
  String orderType;
}
