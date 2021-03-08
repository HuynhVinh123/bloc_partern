import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';
import 'package:tpos_mobile/src/tpos_apis/models/company_of_user.dart';
import 'package:tpos_mobile/src/tpos_apis/models/user_report_staff.dart';

class ReportOrderEvent {}

/// Event lấy thông tin trang tổng quan
class ReportSaleGeneralLoaded extends ReportOrderEvent {
  ReportSaleGeneralLoaded({this.skip, this.limit});
  final int limit;
  final int skip;
}

/// Event load more danh sách trên trang tổng quan
class ReportSaleGeneralLoadMoreLoaded extends ReportOrderEvent {
  ReportSaleGeneralLoadMoreLoaded(
      {this.skip, this.limit, this.reportOrders, this.sumReportGeneral});
  final int limit;
  final int skip;
  List<ReportOrder> reportOrders;
  SumReportGeneral sumReportGeneral;
}

/// Event lấy thông tin trang chi tiết
class ReportOrderDetailLoaded extends ReportOrderEvent {
  ReportOrderDetailLoaded({this.skip, this.limit});
  final int limit;
  final int skip;
}

/// Event lấy thông tin dữ liệu từ local cho danh sách hóa đơn
class ReportOrderDetailFromLocalLoaded extends ReportOrderEvent {
  ReportOrderDetailFromLocalLoaded(
      {this.reportOrderDetails,
      this.sumReportGeneral,
      this.sumReportOrderDetail,
      this.countInvoices});
  final List<ReportOrderDetail> reportOrderDetails;
  final SumDataSale sumReportOrderDetail;
  final SumReportGeneral sumReportGeneral;
  final int countInvoices;
}

/// Event load more danh sách hóa đơn trang chi tiết
class ReportOrderDetailLoadMoreLoaded extends ReportOrderEvent {
  ReportOrderDetailLoadMoreLoaded(
      {this.skip,
      this.limit,
      this.reportOrderDetails,
      this.sumReportGeneral,
      this.sumReportOrderDetail,
      this.countInvoices});
  final int limit;
  final int skip;
  final List<ReportOrderDetail> reportOrderDetails;
  final SumDataSale sumReportOrderDetail;
  final SumReportGeneral sumReportGeneral;
  final int countInvoices;
}

/// Event load  danh sách trang khách hàng
class ReportOrderPartnerLoaded extends ReportOrderEvent {
  ReportOrderPartnerLoaded({this.skip, this.limit});
  final int limit;
  final int skip;
}

/// Event lad more danh sách trang khách hàng
class ReportOrderPartnerLoadMoreLoaded extends ReportOrderEvent {
  ReportOrderPartnerLoadMoreLoaded(
      {this.partnerSaleReports, this.skip, this.limit});
  final List<PartnerSaleReport> partnerSaleReports;
  final int limit;
  final int skip;
}

/// Event load danh sách nhân viên
class ReportOrderStaffLoaded extends ReportOrderEvent {
  ReportOrderStaffLoaded({this.skip, this.limit});
  final int limit;
  final int skip;
}

/// Event load danh sách hóa đơn cho nhân viên
class InvoiceReportStaffLoaded extends ReportOrderEvent {
  InvoiceReportStaffLoaded({this.skip, this.limit, this.staffId});
  final int limit;
  final int skip;
  final String staffId;
}

/// Event load more danh sách nhân viên
class ReportOrderStaffLoadMoreLoaded extends ReportOrderEvent {
  ReportOrderStaffLoadMoreLoaded(
      {this.skip, this.limit, this.staffSaleReports});
  final int limit;
  final int skip;
  final List<PartnerSaleReport> staffSaleReports;
}

/// Lấy danh sách chi tiết hóa đơn trang tổng quan
class DetailReportCustomerTypeSaleLoaded extends ReportOrderEvent {
  DetailReportCustomerTypeSaleLoaded({this.skip, this.limit, this.date});
  final int limit;
  final int skip;
  final DateTime date;
}

/// Event load more danh sách chi tiết hóa đơn trang tổng quan
class DetailReportCustomerTypeSaleLoadMoreLoaded extends ReportOrderEvent {
  DetailReportCustomerTypeSaleLoadMoreLoaded(
      {this.skip, this.limit, this.date, this.detailReportCustomerTypeSales});
  final int limit;
  final int skip;
  final DateTime date;
  List<DetailReportCustomerTypeSale> detailReportCustomerTypeSales;
}

/// Lấy danh sách hóa đơn cho của khách hàng
/// getInvoicesDetailReportCustomer
class DetailReportCustomerInvoicesLoaded extends ReportOrderEvent {
  DetailReportCustomerInvoicesLoaded({this.skip, this.limit, this.partnerId});
  final int limit;
  final int skip;
  final int partnerId;

}

// Thực hiện load more cho hóa đơn của khách hàng
class DetailReportCustomerInvoicesLoadMoreLoaded extends ReportOrderEvent {
  DetailReportCustomerInvoicesLoadMoreLoaded({this.skip, this.limit, this.partnerId,this.invoices,this.staffId});
  final int limit;
  final int skip;
  final int partnerId;
  final String staffId;
  final   List<DetailReportCustomerTypeSale> invoices;
}

/// Lấy danh sách hóa đơn cho của khách hàng
/// getInvoicesDetailReportCustomer
class ReportEmployeeInvoicesLoaded extends ReportOrderEvent {
  ReportEmployeeInvoicesLoaded({this.skip, this.limit, this.staffId});
  final int limit;
  final int skip;
  final String staffId;
}

/// Lưu trữ filter sau khi đc lưu
class ReportOrderFilterSaved extends ReportOrderEvent {
  ReportOrderFilterSaved(
      {this.filterFromDate,
      this.filterToDate,
      this.isFilterByDate = false,
      this.filterDateRange,
      this.partner,
      this.companyOfUser,
      this.userReportStaffOrder,
      this.isFilterByStaff = false,
      this.isFilterByCompany = false,
      this.isFilterByPartner = false,
      this.isFilterByInvoiceType = false,
      this.orderType});

  final DateTime filterFromDate;
  final DateTime filterToDate;
  final bool isFilterByDate;
  final bool isFilterByStaff;
  final bool isFilterByCompany;
  final bool isFilterByPartner;
  final bool isFilterByInvoiceType;
  final AppFilterDateModel filterDateRange;
  final Partner partner;
  final CompanyOfUser companyOfUser;
  final UserReportStaff userReportStaffOrder;
  final String orderType;
}
