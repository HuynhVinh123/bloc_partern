import 'package:tpos_api_client/src/models/entities/report_delivery/delivery_order_report.dart';
import 'package:tpos_api_client/src/models/entities/report_delivery/report_delivery_customer.dart';
import 'package:tpos_api_client/src/models/entities/report_delivery/report_delivery_order_detail.dart';
import 'package:tpos_api_client/src/models/entities/report_delivery/sum_delivery_report_fast_sale_order.dart';

abstract class ReportDeliveryOrderApi {
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
  });

  Future<SumDeliveryReportFastSaleOrder> getSumReportDeliveryFastSaleOrder({
    DateTime dateFrom,
    DateTime dateTo,
    String shipState,
    int partnerId,
    int carrierId,
    String companyId,
    String deliveryType,
    String forControl,
  });

  Future<List<ReportDeliveryCustomer>> getDeliveryReportCustomer(
      {int take,
      int skip,
      DateTime dateFrom,
      DateTime dateTo,
      String shipState,
      int partnerId,
      int carrierId,
      String companyId,
      String deliveryType});

  Future<List<ReportDeliveryCustomer>> getDeliveryReportStaff(
      {int take,
      int skip,
      DateTime dateFrom,
      DateTime dateTo,
      String shipState,
      int partnerId,
      int carrierId,
      String companyId,
      String deliveryType});

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
      String userId});

  Future<List<ReportDeliveryOrderDetail>> getInvoicesDeliveryReportCustomer(
      {int take,
      int skip,
      DateTime dateFrom,
      DateTime dateTo,
      String shipState,
      int partnerId,
      int carrierId,
      String companyId,
      String deliveryType,
      String userId});
}
