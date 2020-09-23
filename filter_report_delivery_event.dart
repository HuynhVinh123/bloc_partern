import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';
import 'package:tpos_mobile/src/tpos_apis/models/company_of_user.dart';
import 'package:tpos_mobile/src/tpos_apis/models/delivery_carrier.dart';
import 'package:tpos_mobile/src/tpos_apis/models/partner.dart';

import '../../../../../src/tpos_apis/models/filter_report_delivery.dart';

class FilterReportDeliveryEvent {}

/// Load dữ liêu filter khi mới vào page
class FilterReportDeliveryLoaded extends FilterReportDeliveryEvent {}

/// Thực hiện thay đổi filter
class FilterReportDeliveryChanged extends FilterReportDeliveryEvent {
  FilterReportDeliveryChanged(
      {this.filterReportDelivery,
      this.isConfirm = false,
   });

  FilterReportDelivery filterReportDelivery;
  final bool isConfirm;


}
