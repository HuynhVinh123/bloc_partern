import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';
import '../tpos_api.dart';

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
      this.partner,
      this.partnerCategory,
      this.isFilterByGroupPartner,
      this.display,
      this.isFilterByDate});

  DateTime dateFrom;
  DateTime dateTo;
  bool isFilterByCompany,
      isFilterByDate,
      isFilterByStaff,
      isFilterByPartner,
      isFilterByInvoiceType,
      isFilterByGroupPartner;

  AppFilterDateModel filterDateRange;
  Partner partner;
  CompanyOfUser companyOfUser;
  UserReportStaff userReportStaffOrder;
  PartnerCategory partnerCategory;
  String orderType;
  String display;
}
