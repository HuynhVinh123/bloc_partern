import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpos_mobile/app_core/helper/app_filter_helper.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';

import 'package:tpos_mobile/feature_group/sale_online/blocs/filter/filter_event.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/filter/filter_state.dart';
import 'package:tpos_mobile/src/tpos_apis/models/partner.dart';

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
    {"name": "Tất cả", "value": null},
    {"name": "Điểm bán hàng", "value": "PostOrder"},
    {"name": "Bán hàng", "value": "FastSaleOrder"},
  ];

  @override
  Stream<FilterState> mapEventToState(FilterEvent event) async* {
    if (event is FilterLoaded) {
      yield FilterLoadSuccess(
          filterFromDate: _filterFromDate,
          filterToDate: _filterToDate,
          filterDateRange: _filterDateRange,
          isFilterByDate: _isFilterByDate,
          partner: partner,
          orderTypes: _orderTypes);
    } else if (event is FilterChanged) {
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
          isFilterByInvoiceType: event.isFilterByInvoiceType,orderType: event.orderType);
    }
  }
}
