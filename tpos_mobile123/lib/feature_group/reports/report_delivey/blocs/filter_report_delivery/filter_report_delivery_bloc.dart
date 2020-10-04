import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpos_mobile/app_core/helper/app_filter_helper.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/filter_report_delivery/filter_report_delivery_event.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/filter_report_delivery/filter_report_delivery_state.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class FilterReportDeliveryBloc
    extends Bloc<FilterReportDeliveryEvent, FilterReportDeliveryState> {
  FilterReportDeliveryBloc() : super(FilterReportDeliveryLoading()) {
    _filterToDate = _filterDateRange.toDate;
    _filterFromDate = _filterDateRange.fromDate;
  }

  final bool _isFilterByDate = false;
  DateTime _filterFromDate;
  DateTime _filterToDate;
  final AppFilterDateModel _filterDateRange = getTodayDateFilter();
  // Chọn loại hóa đơn
  List<Map<String, dynamic>> shipStates = [
    ///Tất cả
    {"name": S.current.reportOrder_All, "value": null},

    ///Đã tiếp nhận received
    {"name": S.current.reportOrder_Received, "value": "sent"},

    ///Đã thu tiền Collected money
    {"name": S.current.reportOrder_collectedMoney, "value": "done"},

    /// Hàng trả về
    {"name": S.current.reportOrder_refundedProduct, "value": "refund"},

    ///Đối soát không thành công
    {"name": S.current.reportOrder_controlFailed, "value": "other"},

    ///Chưa tiếp nhận
    {"name": S.current.reportOrder_hasNotReceived, "value": "none"},
  ];

  /// CHọn loại đối soát
  List<Map<String, dynamic>> stateForControls = [
    ///Tất cả
    {"name": S.current.reportOrder_All, "value": null},

    ///Đã đối soát
    {"name": S.current.reportOrder_checked, "value": "done"},

    ///Chưa đối soát
    {"name": S.current.reportOrder_unChecked, "value": "none"}
  ];

  /// CHọn loại đối tác giao hàng
  List<Map<String, dynamic>> deliveryCarrierTypes = [
    /// Giá cố định
    {"name": S.current.reportOrder_fixedPrice, "value": "fixed"},

    /// Base on rule
    /// Dựa trên quy tắc
    {"name": S.current.reportOrder_baseOnRule, "value": "base_on_rule"},

    /// My VNPost(Bưu điện VN)
    {"name": "My VNPost(Bưu điện VN)", "value": "MyVNPost"},
    {"name": "Viettel Post", "value": "ViettelPost"},

    /// Giao hàng nhanh
    {"name": S.current.reportOrder_FastDelivery, "value": "GHN"},
    {"name": "Super Ship", "value": "SuperShip"},
    {"name": "J&T Express", "value": "JNT"},
    {"name": "FlashShip", "value": "FlashShip"},
    {"name": "OkieLa", "value": "OkieLa"},
    {"name": "DHL Express", "value": "DHL"},
    {"name": "FullTime Ship", "value": "FulltimeShip"},
    {"name": "Best", "value": "BEST"}
  ];

  @override
  Stream<FilterReportDeliveryState> mapEventToState(
      FilterReportDeliveryEvent event) async* {
    if (event is FilterReportDeliveryLoaded) {
      yield FilterReportDeliveryLoadSuccess(
          filterFromDate: _filterFromDate,
          filterToDate: _filterToDate,
          filterDateRange: _filterDateRange,
          isFilterByDate: _isFilterByDate,
          isConfirm: false,
          shipStates: shipStates,
          stateForControls: stateForControls,
          deliveryCarrierTypes: deliveryCarrierTypes,
          countFilter: 1);
    } else if (event is FilterReportDeliveryChanged) {
      yield FilterReportDeliveryLoadSuccess(
          filterFromDate: event.filterReportDelivery.dateFrom,
          filterToDate: event.filterReportDelivery.dateTo,
          filterDateRange: event.filterReportDelivery.filterDateRange,
          partner: event.filterReportDelivery.partner,
          companyOfUser: event.filterReportDelivery.companyOfUser,
          isFilterByPartner: event.filterReportDelivery.isFilterByPartner,
          isFilterByCompany: event.filterReportDelivery.isFilterByCompany,
          isConfirm: event.isConfirm,
          shipStates: shipStates,
          stateForControls: stateForControls,
          isFilterControlState: event.filterReportDelivery.isFilterControlState,
          isFilterShipState: event.filterReportDelivery.isFilterShipState,
          deliveryCarrier: event.filterReportDelivery.deliveryCarrier,
          isFilterDeliveryCarrier:
              event.filterReportDelivery.isFilterDeliveryCarrier,
          isFilterDeliveryCarrierType:
              event.filterReportDelivery.isFilterDeliveryCarrierType,
          deliveryCarrierTypes: deliveryCarrierTypes);
    }
  }
}
