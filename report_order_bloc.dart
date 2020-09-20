import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/app_filter_helper.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/report_order_event.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/report_order_state.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/report_order.dart';

import '../../../locator.dart';

class ReportOrderBloc extends Bloc<ReportOrderEvent, ReportOrderState> {
  ReportOrderBloc(
      {ReportSaleOrderApi reportSaleOrderApi, DialogService dialogService})
      : super(ReportOrderLoading()) {
    _apiClient = reportSaleOrderApi ?? GetIt.instance<ReportSaleOrderApi>();
    _dialog = dialogService ?? locator<DialogService>();
    _filterToDate = _filterDateRange.toDate;
    _filterFromDate = _filterDateRange.fromDate;
  }

  ReportSaleOrderApi _apiClient;
  DialogService _dialog;

  PartnerSaleReport _partnerSaleReport;
  PartnerSaleReport _staffSaleReport;
  bool _isFilterByDate = false;
  DateTime _filterFromDate;
  DateTime _filterToDate;
  final AppFilterDateModel _filterDateRange = getTodayDateFilter();


  @override
  Stream<ReportOrderState> mapEventToState(ReportOrderEvent event) async* {
    yield ReportOrderLoading();
    if (event is ReportSaleGeneralLoaded) {
      yield* _getReportSaleGeneral();
    } else if (event is ReportOrderDetailLoaded) {
      yield* _getReportOrderDetail();
    } else if (event is ReportOrderPartnerLoaded) {
      yield* _getReportOrderPartners();
    } else if (event is ReportOrderStaffLoaded) {
      yield* _getReportOrderStaffs();
    }else if(event is ReportOrderLoaded){
      yield* getReportOrderFilter();
    }
  }

  Stream<ReportOrderState> _getReportSaleGeneral() async* {
    try {
      final List<ReportOrder> _reportOrders =
          await _apiClient.getReportSaleGeneral(
              top: 20,
              skip: 0,
              dateFrom: DateTime.parse("2020-09-01T00:00:00"),
              dateTo: DateTime.parse("2020-09-18T08:58:42"));
      final SumReportGeneral _sumReportGeneral =
          await _apiClient.getSumReportSaleGeneral(
              dateFrom: DateTime.parse("2020-09-01T00:00:00"),
              dateTo: DateTime.parse("2020-09-18T08:58:42"));
      final List<UserCompany> _userCompanies =
          await _apiClient.getCompanyOffUserReportOrder();
      yield ReportSaleGeneralLoadSuccess(
          reportOrders: _reportOrders,
          sumReportGeneral: _sumReportGeneral,
          userCompanies: _userCompanies);
    } catch (e, s) {
      yield ReportOrderLoadFailure(title: "Thông báo",content: e.toString());
    }
  }

  Stream<ReportOrderState> _getReportOrderDetail() async* {
    try {
      final List<ReportOrderDetail> _reportOrderDetails =
          await _apiClient.getReportOrderDetail(
              top: 20,
              skip: 0,
              dateFrom: DateTime.parse("2020-09-01T00:00:00"),
              dateTo: DateTime.parse("2020-09-18T08:58:42"));
      final SumReportOrderDetail _sumReportOrderDetail =
          await _apiClient.getSumReportOrderDetail(
              dateFrom: DateTime.parse("2020-09-01T00:00:00"),
              dateTo: DateTime.parse("2020-09-18T08:58:42"));
      final List<UserCompany> _userCompanies =
          await _apiClient.getCompanyOffUserReportOrder();
      final List<UserReportStaffOrder> _userReportStaffs =
          await _apiClient.getUserReportStaff();
      yield ReportOrderDetailLoadSuccess(
          reportOrderDetails: _reportOrderDetails,
          sumReportOrderDetail: _sumReportOrderDetail,
          userCompanies: _userCompanies,
          userReportStaffOrders: _userReportStaffs);
    } catch (e, s) {
      yield ReportOrderLoadFailure(title: "Thông báo",content: e.toString());
    }
  }

  Stream<ReportOrderState> _getReportOrderPartners() async* {
    try {
      final List<PartnerSaleReport> _partnerSaleReports =
          await _apiClient.getReportOrderPartners(
              top: 20,
              skip: 0,
              dateFrom: DateTime.parse("2020-09-01T00:00:00"),
              dateTo: DateTime.parse("2020-09-19T10:16:41"));

      yield ReportOrderPartnerLoadSuccess(
          partnerSaleReports: _partnerSaleReports);
    } catch (e, s) {
      yield ReportOrderLoadFailure(title: "Thông báo",content: e.toString());
    }
  }

  Stream<ReportOrderState> _getReportOrderStaffs() async* {
    try {
      final List<PartnerSaleReport> _staffSaleReports =
          await _apiClient.getReportOrderStaffs(
              top: 20,
              skip: 0,
              dateFrom: DateTime.parse("2020-09-01T00:00:00"),
              dateTo: DateTime.parse("2020-09-18T08:58:42"));

      yield ReportOrderStaffLoadSuccess(staffSaleReports: _staffSaleReports);
    } catch (e, s) {
      yield ReportOrderLoadFailure(title: "Thông báo",content: e.toString());
    }
  }

  Stream<ReportOrderState> getReportOrderFilter() async* {
    try {
      yield ReportOrderLoadSuccess(
        filterFromDate: _filterFromDate,filterToDate: _filterToDate,filterDateRange: _filterDateRange,isFilterByDate: _isFilterByDate
      );
    } catch (e, s) {
      yield ReportOrderLoadFailure(title: "Thông báo",content: e.toString());
    }
  }

}
