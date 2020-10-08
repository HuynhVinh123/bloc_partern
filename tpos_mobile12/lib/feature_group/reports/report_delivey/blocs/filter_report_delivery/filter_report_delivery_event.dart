import 'package:tpos_mobile/src/tpos_apis/models/filter_report_delivery.dart';

class FilterReportDeliveryEvent {}

/// Load dữ liêu filter khi mới vào page
class FilterReportDeliveryLoaded extends FilterReportDeliveryEvent {}

/// Thực hiện thay đổi filter
class FilterReportDeliveryChanged extends FilterReportDeliveryEvent {
  FilterReportDeliveryChanged(
      {this.filterReportDelivery,
      this.isFilterByDate,
      this.isConfirm = false,
      this.deliveryCarrierTypes});

  final FilterReportDelivery filterReportDelivery;
  final bool isFilterByDate;
  final bool isConfirm;
  final List<Map<String, dynamic>> deliveryCarrierTypes;
}
