import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/report_order_detail/report_order_detail_event.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/report_order_detail/report_order_detail_state.dart';
import 'package:tpos_mobile/services/dialog_service.dart';

import '../../../../locator.dart';

class ReportOrderDetailBloc
    extends Bloc<ReportOrderDetailEvent, ReportOrderDetailState> {
  ReportOrderDetailBloc(
      {ReportSaleOrderApi reportSaleOrderApi, DialogService dialogService})
      : super(ReportOrderDetailLoading()) {
    _apiClient = reportSaleOrderApi ?? GetIt.instance<ReportSaleOrderApi>();
    _dialog = dialogService ?? locator<DialogService>();
  }

  ReportSaleOrderApi _apiClient;
  DialogService _dialog;

  @override
  Stream<ReportOrderDetailState> mapEventToState(
      ReportOrderDetailEvent event) async* {
    if (event is ReportOrderDetailLoaded) {
      yield* _getReportOrderDetail();
    }
  }

  Stream<ReportOrderDetailState> _getReportOrderDetail() async* {
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
          userCompanies: _userCompanies,userReportStaffOrders: _userReportStaffs);
    } catch (e, s) {
      _dialog.showError(title: "Thông báo", content: e.toString());
    }
  }
}
