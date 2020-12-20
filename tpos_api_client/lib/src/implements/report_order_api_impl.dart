import 'package:get_it/get_it.dart';

import 'package:tpos_api_client/src/abstractions/report_order_api.dart';

import '../../tpos_api_client.dart';

class ReportOrderApiImpl implements ReportOrderApi {
  ReportOrderApiImpl({TPosApiClient apiClient}) {
    _apiClient = apiClient ?? GetIt.instance<TPosApi>();
  }

  TPosApiClient _apiClient;

  @override
  Future<List<ReportOrder>> getReportSaleGeneral(
      {int top,
      int skip,
      DateTime dateFrom,
      DateTime dateTo,
      String orderType,
      String companyId,
      int partnerId,
      String staffId}) async {
    List<ReportOrder> _reportSaleOrders = <ReportOrder>[];

    var response = await _apiClient.httpGet(
        "/odata/SaleOrder/ODataService.GetReportSaleGeneral",
        parameters: {
          "BeginDate": dateFrom.toIso8601String(),
          "EndDate": dateTo.toIso8601String(),
          "TypeReport": 1,
          "OrderType": orderType ?? "",
          "CompanyId": companyId ?? "",
          "PartnerId": partnerId ?? "",
          "StaffId": staffId ?? "",
          "\$top": top,
          "\$skip": skip,
          "\$count": true,
          "\$format": "json"
        });

    _reportSaleOrders = (response["value"] as List)
        .map((e) => ReportOrder.fromJson(e))
        .toList();

    return _reportSaleOrders;
  }

  @override
  Future<SumReportGeneral> getSumReportSaleGeneral(
      {DateTime dateFrom,
      DateTime dateTo,
      String orderType,
      String companyId,
      int partnerId,
      String staffId}) async {
    var response = await _apiClient.httpGet(
        "/odata/SaleOrder/ODataService.GetSumReportSaleGeneral",
        parameters: {
          "BeginDate": dateFrom.toIso8601String(),
          "EndDate": dateTo.toIso8601String(),
          "TypeReport": 1,
          "OrderType": orderType ?? "",
          "CompanyId": companyId ?? "",
          "PartnerId": partnerId ?? "",
          "StaffId": staffId ?? "",
        });
    return SumReportGeneral.fromJson(response);
  }

  @override
  Future<ReportOrderDetailOverview> getReportOrderDetail(
      {int top,
      int skip,
      DateTime dateFrom,
      DateTime dateTo,
      String orderType,
      String companyId,
      int partnerId,
      String staffId}) async {
    List<ReportOrderDetail> _reportSaleOrderDetails = <ReportOrderDetail>[];

    final response = await _apiClient.httpGet(
        "/odata/SaleOrder/ODataService.GetReport3TypeSale",
        parameters: {
          "BeginDate": dateFrom.toIso8601String(),
          "EndDate": dateTo.toIso8601String(),
          "TypeReport": 1,
          "OrderType": orderType ?? "",
          "CompanyId": companyId ?? "",
          "PartnerId": partnerId ?? "",
          "StaffId": staffId ?? "",
          "\$top": top,
          "\$skip": skip,
          "\$format": "json",
          "\$orderby": "DateOrder desc",
          "\$count": true,
        });

    return ReportOrderDetailOverview.fromJson(response);

    // _reportSaleOrderDetails = (response["value"] as List)
    //     .map((e) => ReportOrderDetail.fromJson(e))
    //     .toList();
    // return _reportSaleOrderDetails;
  }

  @override
  Future<SumDataSale> getSumReportOrderDetail(
      {DateTime dateFrom,
      DateTime dateTo,
      String orderType,
      String companyId,
      int partnerId,
      String staffId}) async {
    var response = await _apiClient.httpGet(
        "/odata/SaleOrder/ODataService.SumAmountReport3TypeSale",
        parameters: {
          "BeginDate": dateFrom.toIso8601String(),
          "EndDate": dateTo.toIso8601String(),
          "TypeReport": 1,
          "CompanyId": companyId ?? "",
          "OrderType": orderType ?? "",
          "PartnerId": partnerId ?? "",
          "StaffId": staffId ?? "",
        });

    return SumDataSale.fromJson(response);
  }

  @override
  Future<List<PartnerSaleReport>> getReportOrderPartners(
      {int top,
      int skip,
      DateTime dateFrom,
      DateTime dateTo,
      String orderType,
      String companyId,
      int partnerId,
      String staffId}) async {
    List<PartnerSaleReport> _partnerSaleReports = [];

    var response = await _apiClient.httpGet(
        "/odata/SaleOrder/ODataService.GetReportSaleCustomer",
        parameters: {
          "BeginDate": dateFrom.toIso8601String(),
          "EndDate": dateTo.toIso8601String(),
          "TypeReport": 1,
          "OrderType": orderType ?? "",
          "CompanyId": companyId ?? "",
          "PartnerId": partnerId ?? "",
          "StaffId": staffId ?? "",
          "\$top": top,
          "\$skip": skip,
          "\$format": "json",
          "\$count": true,
        });

    _partnerSaleReports = (response["value"] as List)
        .map((e) => PartnerSaleReport.fromJson(e))
        .toList();
    return _partnerSaleReports;
  }

  @override
  Future<List<PartnerSaleReport>> getReportOrderStaffs(
      {int top,
      int skip,
      DateTime dateFrom,
      DateTime dateTo,
      String orderType,
      String companyId,
      int partnerId,
      String staffId}) async {
    List<PartnerSaleReport> _staffSaleReports = [];

    var response = await _apiClient.httpGet(
        "/odata/SaleOrder/ODataService.GetReportSaleStaff",
        parameters: {
          "BeginDate": dateFrom.toIso8601String(),
          "EndDate": dateTo.toIso8601String(),
          "TypeReport": 1,
          "OrderType": orderType ?? "",
          "CompanyId": companyId ?? "",
          "PartnerId": partnerId ?? "",
          "StaffId": staffId ?? "",
          "\$top": top,
          "\$skip": skip,
          "\$format": "json",
          "\$count": true,
        });

    _staffSaleReports = (response["value"] as List)
        .map((e) => PartnerSaleReport.fromJson(e))
        .toList();
    return _staffSaleReports;
  }

  @override
  Future<List<DetailReportCustomerTypeSale>> getDetailReportCustomerTypeSale(
      {int top,
      int skip,
      DateTime dateFrom,
      DateTime dateTo,
      DateTime date,
      String orderType,
      int partnerId,
      String staffId}) async {
    List<DetailReportCustomerTypeSale> _detailReportCustomerTypeSales = [];

    var response = await _apiClient.httpGet(
        "/odata/SaleOrder/ODataService.GetDetailReportCustomerTypeSale",
        parameters: {
          "BeginDate": dateFrom.toIso8601String(),
          "EndDate": dateTo.toIso8601String(),
          "Date": date.toIso8601String(),
          "TypeReport": 1,
          "PartnerId": partnerId ?? "",
          "StaffId": staffId ?? "",
          "\$top": top,
          "\$skip": skip,
          "\$format": "json",
          "\$count": true,
        });

    _detailReportCustomerTypeSales = (response["value"] as List)
        .map((e) => DetailReportCustomerTypeSale.fromJson(e))
        .toList();
    return _detailReportCustomerTypeSales;
  }

  @override
  Future<List<DetailReportCustomerTypeSale>> getInvoicesDetailReportCustomer(
      {int top,
      int skip,
      DateTime dateFrom,
      DateTime dateTo,
      DateTime date,
      String orderType,
      int partnerId,
      bool isNoCustomer = false}) async {
    List<DetailReportCustomerTypeSale> _detailReportCustomerTypeSales = [];
    var response = await _apiClient.httpGet(
        "/odata/SaleOrder/ODataService.GetDetailReportCustomerTypeSale",
        parameters: {
          "BeginDate": dateFrom.toIso8601String(),
          "EndDate": dateTo.toIso8601String(),
          "PartnerId": partnerId ?? "",
          "TypeReport": 1,
          "OrderType": '',
          "IsNoCustomer": isNoCustomer,
          "\$top": top,
          "\$skip": skip,
          "\$format": "json",
          "\$count": true,
        });

    _detailReportCustomerTypeSales = (response["value"] as List)
        .map((e) => DetailReportCustomerTypeSale.fromJson(e))
        .toList();
    return _detailReportCustomerTypeSales;
  }

  @override
  Future<List<DetailReportCustomerTypeSale>> getInvoicesReportStaff(
      {int top,
      int skip,
      DateTime dateFrom,
      DateTime dateTo,
      String staffId,int cityCode}) async {
    List<DetailReportCustomerTypeSale> _invoicesStaff = [];
    var response = await _apiClient.httpGet(
        "/odata/SaleOrder/ODataService.GetDetailReportCustomerTypeSale",
        parameters: {
          "BeginDate": dateFrom.toIso8601String(),
          "EndDate": dateTo.toIso8601String(),
          "StaffId": staffId ?? "",
          "TypeReport": 1,
          "CityCode": '',
          "\$top": top,
          "\$skip": skip,
          "\$format": "json",
          "\$count": true,
        });

    _invoicesStaff = (response["value"] as List)
        .map((e) => DetailReportCustomerTypeSale.fromJson(e))
        .toList();
    return _invoicesStaff;
  }
}
