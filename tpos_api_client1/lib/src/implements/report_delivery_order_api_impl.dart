import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/src/abstractions/report_delivery_order_api.dart';
import 'package:tpos_api_client/src/models/entities/report_delivery/report_delivery_customer.dart';
import 'package:tpos_api_client/src/models/entities/report_delivery/delivery_order_report.dart';
import 'package:tpos_api_client/src/models/entities/report_delivery/sum_delivery_report_fast_sale_order.dart';

import '../../tpos_api_client.dart';

class ReportDeliveryOrderApiImpl implements ReportDeliveryOrderApi {
  ReportDeliveryOrderApiImpl({TPosApiClient apiClient}) {
    _apiClient = apiClient ?? GetIt.instance<TPosApi>();
  }
  TPosApiClient _apiClient;

  @override
  Future<DeliveryOrderReport> getReportDeliveryFastSaleOrder({
    int take,
    int skip,
    DateTime dateFrom,
    DateTime dateTo,
    String shipState,
    int partnerId,
    int carrierId,
    String companyId,
    String deliveryType,
    String forControl,
  }) async {
    var map = {
      "FromDate": dateFrom != null ? dateFrom.toIso8601String() : null,
      "ToDate": dateTo != null ? dateTo.toIso8601String() : null,
      "take": take,
      "skip": skip,
      "sort": [
        {"field": "DateInvoice", "dir": "desc"},
        {"field": "Number", "dir": "desc"},
        {"field": "Id", "dir": "desc"},
      ],
      "aggregate": [
        {"field": "PartnerDisplayName", "aggregate": "count"},
        {"field": "AmountTotal", "aggregate": "sum"},
        {"field": "CashOnDelivery", "aggregate": "sum"},
        {"field": "DeliveryPrice", "aggregate": "sum"},
        {"field": "AmountDeposit", "aggregate": "sum"},
        {"field": "CustomerDeliveryPrice", "aggregate": "sum"},
        {"field": "WeightTotal", "aggregate": "sum"}
      ]
    };

    if (carrierId != null) {
      map["CarrierId"] = carrierId;
    }

    if (companyId != null) {
      map["CompanyId"] = companyId;
    }

    if (deliveryType != null) {
      map["DeliveryType"] = deliveryType;
    }

    if (forControl != null) {
      map["ForControl"] = forControl;
    }

    if (partnerId != null) {
      map["PartnerId"] = partnerId;
    }

    if (shipState != null) {
      map["ShipState"] = shipState;
    }

    String body = json.encode(map);

    var response =
        await _apiClient.httpPost("/FastSaleOrder/DeliveryReport", data: body);
    return DeliveryOrderReport.fromJson(response);
  }

  @override
  Future<SumDeliveryReportFastSaleOrder> getSumReportDeliveryFastSaleOrder(
      {DateTime dateFrom,
      DateTime dateTo,
      String shipState,
      int partnerId,
      int carrierId,
      String companyId,
      String deliveryType,
      String forControl}) async {
    var map = {
      "FromDate": dateFrom != null ? dateFrom.toIso8601String() : null,
      "ToDate": dateTo != null ? dateTo.toIso8601String() : null,
    };

    if (carrierId != null) {
      map["CarrierId"] = carrierId.toString();
    }

    if (companyId != null) {
      map["CompanyId"] = companyId;
    }

    if (deliveryType != null) {
      map["DeliveryType"] = deliveryType;
    }

    if (forControl != null) {
      map["ForControl"] = forControl;
    }

    if (partnerId != null) {
      map["PartnerId"] = partnerId.toString();
    }

    if (shipState != null) {
      map["ShipState"] = shipState;
    }

    var response = await _apiClient.httpPost("/FastSaleOrder/SumDeliveryReport",
        data: json.encode(map));
    return SumDeliveryReportFastSaleOrder.fromJson(response);
  }

  @override
  Future<List<ReportDeliveryCustomer>> getDeliveryReportCustomer(
      {int take,
      int skip,
      DateTime dateFrom,
      DateTime dateTo,
      String shipState,
      int partnerId,
      int carrierId,
      String companyId,
      String deliveryType}) async {
    var map = {
      "FromDate": dateFrom != null ? dateFrom.toIso8601String() : null,
      "ToDate": dateTo != null ? dateTo.toIso8601String() : null,
      "take": take,
      "skip": skip,
      "sort": [
        {"field": "TotalBill", "dir": "desc"},
        {"field": "AmountTotal", "dir": "desc"},
      ],
      "aggregate": [
        {"field": "PartnerDisplayName", "aggregate": "count"},
        {"field": "AmountTotal", "aggregate": "sum"},
        {"field": "CashOnDelivery", "aggregate": "sum"},
        {"field": "DeliveryPrice", "aggregate": "sum"},
        {"field": "TotalBill", "aggregate": "sum"},
        {"field": "AmountDeposit", "aggregate": "sum"},
        {"field": "CustomerDeliveryPrice", "aggregate": "sum"},
        {"field": "WeightTotal", "aggregate": "sum"}
      ]
    };

    if (carrierId != null) {
      map["CarrierId"] = carrierId;
    }

    if (companyId != null) {
      map["CompanyId"] = companyId;
    }

    if (deliveryType != null) {
      map["DeliveryType"] = deliveryType;
    }

    if (partnerId != null) {
      map["PartnerId"] = partnerId;
    }

    if (shipState != null) {
      map["ShipState"] = shipState;
    }

    String body = json.encode(map);

    var response = await _apiClient
        .httpPost("/FastSaleOrder/DeliveryReportCustomer", data: body);

    List<ReportDeliveryCustomer> deliveryReportCustomers = [];
    deliveryReportCustomers = (response["Data"] as List)
        .map((value) => ReportDeliveryCustomer.fromJson(value))
        .toList();
    return deliveryReportCustomers;
  }

  @override
  Future<List<ReportDeliveryCustomer>> getDeliveryReportStaff(
      {int take,
      int skip,
      DateTime dateFrom,
      DateTime dateTo,
      String shipState,
      int partnerId,
      int carrierId,
      String companyId,
      String deliveryType}) async {
    var map = {
      "FromDate": dateFrom != null ? dateFrom.toIso8601String() : null,
      "ToDate": dateTo != null ? dateTo.toIso8601String() : null,
      "take": take,
      "skip": skip,
      "sort": [
        {"field": "DateInvoice", "dir": "desc"},
      ],
      "aggregate": [
        {"field": "PartnerDisplayName", "aggregate": "count"},
        {"field": "AmountTotal", "aggregate": "sum"},
        {"field": "CashOnDelivery", "aggregate": "sum"},
        {"field": "DeliveryPrice", "aggregate": "sum"},
        {"field": "TotalBill", "aggregate": "sum"},
        {"field": "AmountDeposit", "aggregate": "sum"},
        {"field": "CustomerDeliveryPrice", "aggregate": "sum"},
        {"field": "WeightTotal", "aggregate": "sum"}
      ]
    };

    if (carrierId != null) {
      map["CarrierId"] = carrierId;
    }

    if (companyId != null) {
      map["CompanyId"] = companyId;
    }

    if (deliveryType != null) {
      map["DeliveryType"] = deliveryType;
    }

    if (partnerId != null) {
      map["PartnerId"] = partnerId;
    }

    if (shipState != null) {
      map["ShipState"] = shipState;
    }

    String body = json.encode(map);

    var response = await _apiClient
        .httpPost("/FastSaleOrder/DeliveryReportStaff", data: body);

    List<ReportDeliveryCustomer> deliveryReportStaffs = [];
    deliveryReportStaffs = (response["Data"] as List)
        .map((value) => ReportDeliveryCustomer.fromJson(value))
        .toList();
    return deliveryReportStaffs;
  }

  @override
  Future<List<ReportDeliveryOrderDetail>> getDetailDeliveryReportStaff(
      {int take,
      int skip,
      DateTime dateFrom,
      DateTime dateTo,
      String shipState,
      int partnerId,
      int carrierId,
      String companyId,
      String deliveryType,
      String userId}) async {
    var map = {
      "FromDate": dateFrom != null ? dateFrom.toIso8601String() : null,
      "ToDate": dateTo != null ? dateTo.toIso8601String() : null,
      "UserId": userId,
      "\$top": take,
      "\$skip": skip,
      "format": "json",
      "count": true,
    };

    if (carrierId != null) {
      map["CarrierId"] = carrierId;
    }

    if (companyId != null) {
      map["CompanyId"] = companyId;
    }

    if (deliveryType != null) {
      map["DeliveryType"] = deliveryType;
    }

    if (partnerId != null) {
      map["PartnerId"] = partnerId;
    }

    if (shipState != null) {
      map["ShipState"] = shipState;
    }

    var response = await _apiClient.httpGet(
        "/odata/FastSaleOrder/ODataService.GetDetailDeliveryReportStaff",
        parameters: map);

    List<ReportDeliveryOrderDetail> deliveryReportStaffDetails = [];
    deliveryReportStaffDetails = (response["value"] as List)
        .map((value) => ReportDeliveryOrderDetail.fromJson(value))
        .toList();
    return deliveryReportStaffDetails;
  }
}
