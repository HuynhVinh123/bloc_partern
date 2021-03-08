import 'package:tpos_api_client/src/models/entities/report_delivery/report_delivery_aggregates.dart';
import 'package:tpos_api_client/src/models/entities/report_delivery/report_delivery_order_detail.dart';

import '../../../../tpos_api_client.dart';

class DeliveryOrderReport {
  DeliveryOrderReport({this.data, this.total, this.aggregates});

  DeliveryOrderReport.fromJson(Map<String, dynamic> json) {
    if (json['Data'] != null) {
      data = <ReportDeliveryOrderDetail>[];
      json['Data'].forEach((v) {
        data.add(ReportDeliveryOrderDetail.fromJson(v));
      });
    }
    total = json['Total'];
    aggregates = json['Aggregates'] != null
        ? ReportDeliveryAggregates.fromJson(json['Aggregates'])
        : null;
  }
  List<ReportDeliveryOrderDetail> data;
  int total;
  ReportDeliveryAggregates aggregates;
}
