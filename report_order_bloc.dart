import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/app_filter_helper.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/report_order_event.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/report_order_state.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/company_of_user.dart';
import 'package:tpos_mobile/src/tpos_apis/models/partner.dart';
import 'package:tpos_mobile/src/tpos_apis/models/report_order.dart';
import 'package:tpos_mobile/src/tpos_apis/models/user_report_staff.dart';

import '../../../locator.dart';

class ReportOrderBloc extends Bloc<ReportOrderEvent, ReportOrderState> {
  ReportOrderBloc(
      {ReportSaleOrderApi reportSaleOrderApi, DialogService dialogService})
      : super(ReportSaleGeneralLoading()) {
    _apiClient = reportSaleOrderApi ?? GetIt.instance<ReportSaleOrderApi>();
    _dialog = dialogService ?? locator<DialogService>();

    _dateTo = _filterDateRange.toDate;
    _dateFrom = _filterDateRange.fromDate;
  }

  ReportSaleOrderApi _apiClient;
  DialogService _dialog;

  DateTime _dateFrom;
  DateTime _dateTo;
  bool _isFilterByDate = false,
      _isFilterByCompany = false,
      _isFilterByStaff = false,
      _isFilterByPartner = false,
      _isFilterByInvoiceType = false;
  final AppFilterDateModel _filterDateRange = getTodayDateFilter();

  Partner _partner = Partner();
  CompanyOfUser _companyOfUser = CompanyOfUser();
  UserReportStaff _userReportStaffOrder = UserReportStaff();
  String _orderType;

  @override
  Stream<ReportOrderState> mapEventToState(ReportOrderEvent event) async* {
    if (event is ReportSaleGeneralLoaded) {
      yield ReportSaleGeneralLoading();
      yield* _getReportSaleGeneral(event);
    } else if (event is ReportOrderDetailLoaded) {
      yield ReportOrderDetailLoading();
      yield* _getReportOrderDetail(event);
    } else if (event is ReportOrderPartnerLoaded) {
      yield ReportOrderPartnerLoading();
      yield* _getReportOrderPartners(event);
    } else if (event is ReportOrderStaffLoaded) {
      yield ReportOrderStaffLoading();
      yield* _getReportOrderStaffs();
    } else if (event is ReportOrderFilterSaved) {
      yield* getReportOrderFilterSaved(event);
    } else if (event is ReportSaleGeneralLoadMoreLoaded) {
      yield ReportSaleGeneralLoadMoreLoading();
      yield* _getReportSaleGeneralLoadMore(event);
    } else if (event is ReportOrderDetailLoadMoreLoaded) {
      yield ReportOrderDetailLoadMoreLoading();
      yield* _getReportOrderDetailLoadMore(event);
    } else if (event is ReportOrderPartnerLoadMoreLoaded) {
      yield ReportOrderPartnerLoadMoreLoading();
      yield* _getReportOrderPartnerLoadMores(event);
    }
  }

  Stream<ReportOrderState> _getReportSaleGeneral(
      ReportSaleGeneralLoaded event) async* {
    try {
      final List<ReportOrder> _reportOrders =
          await _apiClient.getReportSaleGeneral(
              top: event.limit,
              skip: event.skip,
              dateFrom: _dateFrom,
              dateTo: _dateTo,
              orderType: _isFilterByInvoiceType ? _orderType : null,
              companyId: _isFilterByCompany ? _companyOfUser.value : null,
              partnerId: _isFilterByPartner ? _partner.id : null,
              staffId: _isFilterByStaff ? _userReportStaffOrder.value : null);
      final SumReportGeneral _sumReportGeneral =
          await _apiClient.getSumReportSaleGeneral(
              dateFrom: _dateFrom,
              dateTo: _dateTo,
              orderType: _isFilterByInvoiceType ? _orderType : null,
              companyId: _isFilterByCompany ? _companyOfUser.value : null,
              partnerId: _isFilterByPartner ? _partner.id : null,
              staffId: _isFilterByStaff ? _userReportStaffOrder.value : null);
      if (_reportOrders.length == event.limit) {
        _reportOrders.add(tempReportOrder);
      }

      yield ReportSaleGeneralLoadSuccess(
          reportOrders: _reportOrders, sumReportGeneral: _sumReportGeneral);
    } catch (e, s) {
      yield ReportOrderLoadFailure(title: "Thông báo", content: e.toString());
    }
  }

  Stream<ReportOrderState> _getReportSaleGeneralLoadMore(
      ReportSaleGeneralLoadMoreLoaded event) async* {
    try {
      event.reportOrders.removeWhere((element) => element.countOrder == -1);
      final List<ReportOrder> _reportOrderLoadMores =
          await _apiClient.getReportSaleGeneral(
              top: event.limit,
              skip: event.skip,
              dateFrom: _dateFrom,
              dateTo: _dateTo,
              orderType: _isFilterByInvoiceType ? _orderType : null,
              companyId: _isFilterByCompany ? _companyOfUser.value : null,
              partnerId: _isFilterByPartner ? _partner.id : null,
              staffId: _isFilterByStaff ? _userReportStaffOrder.value : null);
      if (_reportOrderLoadMores.length == event.limit) {
        _reportOrderLoadMores.add(tempReportOrder);
      }

      event.reportOrders.addAll(_reportOrderLoadMores);

      yield ReportSaleGeneralLoadSuccess(
          reportOrders: event.reportOrders,
          sumReportGeneral: event.sumReportGeneral);
    } catch (e, s) {
      yield ReportOrderLoadFailure(title: "Thông báo", content: e.toString());
    }
  }

  Stream<ReportOrderState> _getReportOrderDetail(
      ReportOrderDetailLoaded event) async* {
    try {
      final List<ReportOrderDetail> _reportOrderDetails =
          await _apiClient.getReportOrderDetail(
              top: event.limit,
              skip: event.skip,
              dateFrom: _dateFrom,
              dateTo: _dateTo,
              orderType: _isFilterByInvoiceType ? _orderType : null,
              companyId: _isFilterByCompany ? _companyOfUser.value : null,
              partnerId: _isFilterByPartner ? _partner.id : null,
              staffId: _isFilterByStaff ? _userReportStaffOrder.value : null);
      final SumReportOrderDetail _sumReportOrderDetail =
          await _apiClient.getSumReportOrderDetail(
              dateFrom: _dateFrom,
              dateTo: _dateTo,
              orderType: _isFilterByInvoiceType ? _orderType : null,
              companyId: _isFilterByCompany ? _companyOfUser.value : null,
              partnerId: _isFilterByPartner ? _partner.id : null,
              staffId: _isFilterByStaff ? _userReportStaffOrder.value : null);

      final SumReportGeneral _sumReportGeneral =
          await _apiClient.getSumReportSaleGeneral(
              dateFrom: _dateFrom,
              dateTo: _dateTo,
              orderType: _isFilterByInvoiceType ? _orderType : null,
              companyId: _isFilterByCompany ? _companyOfUser.value : null,
              partnerId: _isFilterByPartner ? _partner.id : null,
              staffId: _isFilterByStaff ? _userReportStaffOrder.value : null);

      if (_reportOrderDetails.length == event.limit) {
        _reportOrderDetails.add(tempReportOrderDetail);
      }

      yield ReportOrderDetailLoadSuccess(
          reportOrderDetails: _reportOrderDetails,
          sumReportOrderDetail: _sumReportOrderDetail,
          sumReportGeneral: _sumReportGeneral);
    } catch (e, s) {
      yield ReportOrderLoadFailure(title: "Thông báo", content: e.toString());
    }
  }

  Stream<ReportOrderState> _getReportOrderDetailLoadMore(
      ReportOrderDetailLoadMoreLoaded event) async* {
    try {
      event.reportOrderDetails
          .removeWhere((element) => element.name == tempReportOrderDetail.name);
      final List<ReportOrderDetail> _reportOrderDetailMores =
          await _apiClient.getReportOrderDetail(
              top: event.limit,
              skip: event.skip,
              dateFrom: _dateFrom,
              dateTo: _dateTo,
              orderType: _isFilterByInvoiceType ? _orderType : null,
              companyId: _isFilterByCompany ? _companyOfUser.value : null,
              partnerId: _isFilterByPartner ? _partner.id : null,
              staffId: _isFilterByStaff ? _userReportStaffOrder.value : null);

      if (_reportOrderDetailMores.length == event.limit) {
        _reportOrderDetailMores.add(tempReportOrderDetail);
      }

      event.reportOrderDetails.addAll(_reportOrderDetailMores);

      yield ReportOrderDetailLoadSuccess(
          reportOrderDetails: event.reportOrderDetails,
          sumReportOrderDetail: event.sumReportOrderDetail,
          sumReportGeneral: event.sumReportGeneral);
    } catch (e, s) {
      yield ReportOrderLoadFailure(title: "Thông báo", content: e.toString());
    }
  }

  Stream<ReportOrderState> _getReportOrderPartners(
      ReportOrderPartnerLoaded event) async* {
    try {
      final List<PartnerSaleReport> _partnerSaleReports =
          await _apiClient.getReportOrderPartners(
              top: event.limit,
              skip: event.skip,
              dateFrom: _dateFrom,
              dateTo: _dateTo,
              orderType: _isFilterByInvoiceType ? _orderType : null,
              companyId: _isFilterByCompany ? _companyOfUser.value : null,
              partnerId: _isFilterByPartner ? _partner.id : null,
              staffId: _isFilterByStaff ? _userReportStaffOrder.value : null);

      if (_partnerSaleReports.length == event.limit) {
        _partnerSaleReports.add(tempPartnerSaleReport);
      }

      yield ReportOrderPartnerLoadSuccess(
          partnerSaleReports: _partnerSaleReports);
    } catch (e, s) {
      yield ReportOrderLoadFailure(title: "Thông báo", content: e.toString());
    }
  }

  Stream<ReportOrderState> _getReportOrderPartnerLoadMores(
      ReportOrderPartnerLoadMoreLoaded event) async* {
    try {
      event.partnerSaleReports.removeWhere(
          (element) => element.staffName == tempPartnerSaleReport.staffName);

      final List<PartnerSaleReport> _partnerSaleReportLoadMores =
          await _apiClient.getReportOrderPartners(
              top: event.limit,
              skip: event.skip,
              dateFrom: _dateFrom,
              dateTo: _dateTo,
              orderType: _isFilterByInvoiceType ? _orderType : null,
              companyId: _isFilterByCompany ? _companyOfUser.value : null,
              partnerId: _isFilterByPartner ? _partner.id : null,
              staffId: _isFilterByStaff ? _userReportStaffOrder.value : null);

      if (_partnerSaleReportLoadMores.length == event.limit) {
        _partnerSaleReportLoadMores.add(tempPartnerSaleReport);
      }

      event.partnerSaleReports.addAll(_partnerSaleReportLoadMores);

      yield ReportOrderPartnerLoadSuccess(
          partnerSaleReports: event.partnerSaleReports);
    } catch (e, s) {
      yield ReportOrderLoadFailure(title: "Thông báo", content: e.toString());
    }
  }

  Stream<ReportOrderState> _getReportOrderStaffs() async* {
    try {
      final List<PartnerSaleReport> _staffSaleReports =
          await _apiClient.getReportOrderStaffs(
              top: 20,
              skip: 0,
              dateFrom: _dateFrom,
              dateTo: _dateTo,
              orderType: _isFilterByInvoiceType ? _orderType : null,
              companyId: _isFilterByCompany ? _companyOfUser.value : null,
              partnerId: _isFilterByPartner ? _partner.id : null,
              staffId: _isFilterByStaff ? _userReportStaffOrder.value : null);

      yield ReportOrderStaffLoadSuccess(staffSaleReports: _staffSaleReports);
    } catch (e, s) {
      yield ReportOrderLoadFailure(title: "Thông báo", content: e.toString());
    }
  }

  Stream<ReportOrderState> getReportOrderFilterSaved(
      ReportOrderFilterSaved event) async* {
    _dateFrom = event.filterFromDate;
    _dateTo = event.filterToDate;
    _isFilterByDate = event.isFilterByDate;
    _isFilterByCompany = event.isFilterByCompany;
    _isFilterByStaff = event.isFilterByStaff;
    _isFilterByPartner = event.isFilterByPartner;
    _isFilterByInvoiceType = event.isFilterByInvoiceType;
    _partner = event.partner;
    _companyOfUser = event.companyOfUser;
    _userReportStaffOrder = event.userReportStaffOrder;
    _orderType = event.orderType;
  }
}

var tempReportOrderDetail = ReportOrderDetail(name: "temp");

var tempReportOrder = ReportOrder(countOrder: -1);

var tempPartnerSaleReport = PartnerSaleReport(staffName: "staffTemp");
