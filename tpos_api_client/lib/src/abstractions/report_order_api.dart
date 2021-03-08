import 'package:tpos_api_client/src/model.dart';

abstract class ReportOrderApi {
  Future<List<ReportOrder>> getReportSaleGeneral(
      {int top,
      int skip,
      DateTime dateFrom,
      DateTime dateTo,
      String orderType,
      String companyId,
      int partnerId,
      String staffId});

  Future<SumReportGeneral> getSumReportSaleGeneral(
      {DateTime dateFrom,
      DateTime dateTo,
      String orderType,
      String companyId,
      int partnerId,
      String staffId});

  Future<ReportOrderDetailOverview> getReportOrderDetail(
      {int top,
      int skip,
      DateTime dateFrom,
      DateTime dateTo,
      String orderType,
      String companyId,
      int partnerId,
      String staffId});

  Future<SumDataSale> getSumReportOrderDetail(
      {DateTime dateFrom,
      DateTime dateTo,
      String orderType,
      String companyId,
      int partnerId,
      String staffId});

  Future<List<PartnerSaleReport>> getReportOrderPartners(
      {int top,
      int skip,
      DateTime dateFrom,
      DateTime dateTo,
      String orderType,
      String companyId,
      int partnerId,
      String staffId});

  Future<List<PartnerSaleReport>> getReportOrderStaffs(
      {int top,
      int skip,
      DateTime dateFrom,
      DateTime dateTo,
      String orderType,
      String companyId,
      int partnerId,
      String staffId});

  Future<List<DetailReportCustomerTypeSale>> getDetailReportCustomerTypeSale(
      {int top,
      int skip,
      DateTime dateFrom,
      DateTime dateTo,
      DateTime date,
      String orderType,
      int partnerId,
      String staffId});

  Future<List<DetailReportCustomerTypeSale>> getInvoicesDetailReportCustomer(
      {int top,
      int skip,
      DateTime dateFrom,
      DateTime dateTo,
      DateTime date,
      String orderType,
      int partnerId,
      bool isNoCustomer});

  Future<List<DetailReportCustomerTypeSale>> getInvoicesReportStaff(
      {int top, int skip, DateTime dateFrom, DateTime dateTo, String staffId});
}
