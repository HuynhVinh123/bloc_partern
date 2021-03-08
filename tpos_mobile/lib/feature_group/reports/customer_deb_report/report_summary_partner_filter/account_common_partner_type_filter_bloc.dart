import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/app_filter_helper.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';
import 'package:tpos_mobile/feature_group/reports/customer_deb_report/report_summary_partner_filter/account_common_partner_type_filter_event.dart';
import 'package:tpos_mobile/feature_group/reports/customer_deb_report/report_summary_partner_filter/account_common_partner_type_filter_state.dart';

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
          isConfirm: false);
    } else if (event is FilterChanged) {
      /// update lại dữ liệu mỗi lần thay đổi filter
      yield FilterLoadSuccess(
          filterFromDate: event.filterFromDate,
          filterToDate: event.filterToDate,
          filterDateRange: event.filterDateRange,
          isFilterByDate: event.isFilterByDate,
          partner: event.partner,
          companyOfUser: event.companyOfUser,
          isFilterByStaff: event.isFilterByStaff,
          isFilterByPartner: event.isFilterByPartner,
          isFilterByCompany: event.isFilterByCompany,
          isFilterByGroupPartner: event.isFilterByGroupPartner,
          isConfirm: event.isConfirm,
          userReportStaffOrder: event.userReportStaffOrder,
          partnerCategory: event.partnerCategory);
    }
  }
}
