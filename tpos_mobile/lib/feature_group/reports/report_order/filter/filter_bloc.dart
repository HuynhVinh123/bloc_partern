import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/app_filter_helper.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import 'filter_event.dart';
import 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc() : super(FilterLoading()) {
    _filterToDate = _filterDateRange.toDate;
    _filterFromDate = _filterDateRange.fromDate;
  }

  Partner partner = Partner();
  final bool _isFilterByDate = false;
  DateTime _filterFromDate;
  DateTime _filterToDate;
  final AppFilterDateModel _filterDateRange = getTodayDateFilter();
  final List<Map<String, dynamic>> _orderTypes = [
    /// Tất cả
    {"name": S.current.reportOrder_All, "value": null},

    /// Điểm bán hàng
    {"name": S.current.menu_posOfSale, "value": "PostOrder"},

    /// Bán hàng
    {"name": S.current.reportOrder_Sell, "value": "FastSaleOrder"},
  ];

  @override
  Stream<FilterState> mapEventToState(FilterEvent event) async* {
    if (event is FilterLoaded) {
      ///  Load dữ liệu khi load page lần đầu
      yield FilterLoadSuccess(
          filterFromDate: _filterFromDate,
          filterToDate: _filterToDate,
          filterDateRange: _filterDateRange,
          isFilterByDate: _isFilterByDate,
          partner: partner,
          orderTypes: _orderTypes,
          isConfirm: false);
    } else if (event is FilterChanged) {
      /// update lại dữ liệu mỗi lần thay đổi filter
      yield FilterLoadSuccess(
          filterFromDate: event.filterFromDate,
          filterToDate: event.filterToDate,
          filterDateRange: event.filterDateRange,
          isFilterByDate: event.isFilterByDate,
          partner: event.partner,
          orderTypes: _orderTypes,
          companyOfUser: event.companyOfUser,
          isFilterByStaff: event.isFilterByStaff,
          isFilterByPartner: event.isFilterByPartner,
          isFilterByCompany: event.isFilterByCompany,
          isFilterByInvoiceType: event.isFilterByInvoiceType,
          orderType: event.orderType,
          isConfirm: event.isConfirm);
    }
  }
}
