import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';
import 'package:tpos_mobile/src/tpos_apis/models/company_of_user.dart';
import 'package:tpos_mobile/src/tpos_apis/models/delivery_carrier.dart';
import 'package:tpos_mobile/src/tpos_apis/models/partner.dart';

class FilterReportDeliveryState {}

class FilterReportDeliveryLoading extends FilterReportDeliveryState {}

/// Trả về dữ liệu khi thực hiện filter thành công
class FilterReportDeliveryLoadSuccess extends FilterReportDeliveryState {
  FilterReportDeliveryLoadSuccess(
      {this.filterFromDate,
      this.filterToDate,
      this.isFilterByDate,
      this.filterDateRange,
      this.partner,
      this.companyOfUser,
      this.isFilterByPartner,
      this.isFilterByCompany,
      this.isFilterShipState,
      this.isFilterControlState,
      this.isConfirm,
      this.shipStates,
      this.stateForControls,
      this.deliveryCarrier,
      this.isFilterDeliveryCarrier,
      this.isFilterDeliveryCarrierType,
      this.deliveryCarrierTypes,
      this.countFilter = 0});

  final DateTime filterFromDate;
  final DateTime filterToDate;
  final bool isFilterByDate;
  final bool isFilterByCompany;
  final bool isFilterByPartner;
  final bool isFilterShipState;
  final bool isFilterControlState;
  final bool isFilterDeliveryCarrier;
  final bool isFilterDeliveryCarrierType;
  final AppFilterDateModel filterDateRange;
  final Partner partner;
  final CompanyOfUser companyOfUser;
  final DeliveryCarrier deliveryCarrier;
  final List<Map<String, dynamic>> shipStates;
  final List<Map<String, dynamic>> stateForControls;
  final List<Map<String, dynamic>> deliveryCarrierTypes;
  final bool isConfirm;
  final int countFilter;
}
