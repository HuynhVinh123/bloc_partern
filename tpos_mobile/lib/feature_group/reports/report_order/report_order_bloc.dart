import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/app_filter_helper.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/company_of_user.dart';
import 'package:tpos_mobile/src/tpos_apis/models/user_report_staff.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import '../../../locator.dart';
import 'report_order_event.dart';
import 'report_order_state.dart';

class ReportOrderBloc extends Bloc<ReportOrderEvent, ReportOrderState> {
  ReportOrderBloc(
      {ReportOrderApi reportSaleOrderApi, DialogService dialogService})
      : super(ReportSaleGeneralLoading()) {
    _apiClient = reportSaleOrderApi ?? GetIt.instance<ReportOrderApi>();
    _dialog = dialogService ?? locator<DialogService>();

    _dateTo = _filterDateRange.toDate;
    _dateFrom = _filterDateRange.fromDate;
  }

  ReportOrderApi _apiClient;
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
      /// Lấy thông tin trang tổng quan
      yield ReportSaleGeneralLoading();
      yield* _getReportSaleGeneral(event);
    } else if (event is ReportOrderDetailLoaded) {
      /// Lấy thoogn tin trang chi tiết
      yield ReportOrderDetailLoading();
      yield* _getReportOrderDetail(event);
    } else if (event is ReportOrderPartnerLoaded) {
      /// Lấy thông tin danh sách khác hàng
      yield ReportOrderPartnerLoading();
      yield* _getReportOrderPartners(event);
    } else if (event is ReportOrderStaffLoaded) {
      /// Lấy thoogn tin danh sách nhân viên
      yield ReportOrderStaffLoading();
      yield* _getReportOrderStaffs(event);
    } else if (event is ReportOrderFilterSaved) {
      /// Thực hiện lưu các thoogn tin đã được filter
      yield* getReportOrderFilterSaved(event);
    } else if (event is ReportSaleGeneralLoadMoreLoaded) {
      /// Thực hiện load more danh sách ở trang tông quan
      yield ReportSaleGeneralLoadMoreLoading();
      yield* _getReportSaleGeneralLoadMore(event);
    } else if (event is ReportOrderDetailLoadMoreLoaded) {
      /// Thực hiện load more danh sách hóa đơn ở trang chi tiết
      yield ReportOrderDetailLoadMoreLoading();
      yield* _getReportOrderDetailLoadMore(event);
    } else if (event is ReportOrderPartnerLoadMoreLoaded) {
      /// Thực hiện load more danh sách khách hàng
      yield ReportOrderPartnerLoadMoreLoading();
      yield* _getReportOrderPartnerLoadMores(event);
    } else if (event is ReportOrderStaffLoadMoreLoaded) {
      /// Thực hiện load more danh sách nhân viên
      yield ReportOrderStaffLoadMoreLoading();
      yield* _getReportOrderStaffLoadMores(event);
    } else if (event is ReportOrderDetailFromLocalLoaded) {
      /// Thực hiện lấy thông tin dữ liệu từ local cho danh sách hóa đơn trang chi tiết
      yield* _getReportOrderDetailLoadFromLocalMore(event);
    } else if (event is DetailReportCustomerTypeSaleLoaded) {
      /// Thực hiện lấy thông tin dữ liệu cho chi tiết hóa đơn trang tổng quan
      yield DetailReportCustomerTypeSaleLoading();
      yield* _getDetailReportCustomerTypeSales(event);
    } else if (event is DetailReportCustomerTypeSaleLoadMoreLoaded) {
      /// Thực hiện lấy thông tin dữ liệu cho chi tiết hóa đơn trang tổng quan
      yield DetailReportCustomerTypeSaleLoadMoreLoading();
      yield* _getDetailReportCustomerTypeSaleLoadMores(event);
    } else if (event is DetailReportCustomerInvoicesLoaded) {
      yield ReportOrderPartnerInvoiceLoading();
      yield* _getInvoicesReportCustomer(event);
    }else if(event is DetailReportCustomerInvoicesLoadMoreLoaded){
      yield ReportOrderPartnerInvoiceLoadMoreLoading();
      yield* _getInvoicesReportCustomerLoadMore(event);
    }
    else if (event is ReportEmployeeInvoicesLoaded) {
      yield ReportOrderPartnerInvoiceLoading();
      yield* _getInvoicesReportEmployee(event);
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
      yield ReportOrderLoadFailure(
          title: S.current.notification, content: e.toString());
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
      yield ReportOrderLoadFailure(
          title: S.current.notification, content: e.toString());
    }
  }

  Stream<ReportOrderState> _getReportOrderDetail(
      ReportOrderDetailLoaded event) async* {
    try {
      final ReportOrderDetailOverview _reportOrderDetailOverview =
          await _apiClient.getReportOrderDetail(
              top: event.limit,
              skip: event.skip,
              dateFrom: _dateFrom,
              dateTo: _dateTo,
              orderType: _isFilterByInvoiceType ? _orderType : null,
              companyId: _isFilterByCompany ? _companyOfUser.value : null,
              partnerId: _isFilterByPartner ? _partner.id : null,
              staffId: _isFilterByStaff ? _userReportStaffOrder.value : null);
      final List<ReportOrderDetail> _reportOrderDetails =
          _reportOrderDetailOverview.reportOrderDetails;
      final SumDataSale _sumReportOrderDetail =
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
          sumReportGeneral: _sumReportGeneral,
          countInvoies: _reportOrderDetailOverview.odataCount);
    } catch (e, s) {
      yield ReportOrderLoadFailure(
          title: S.current.notification, content: e.toString());
    }
  }

  Stream<ReportOrderState> _getReportOrderDetailLoadMore(
      ReportOrderDetailLoadMoreLoaded event) async* {
    try {
      event.reportOrderDetails
          .removeWhere((element) => element.name == tempReportOrderDetail.name);

      final ReportOrderDetailOverview _reportOrderDetailOverviewLoadMore =
          await _apiClient.getReportOrderDetail(
              top: event.limit,
              skip: event.skip,
              dateFrom: _dateFrom,
              dateTo: _dateTo,
              orderType: _isFilterByInvoiceType ? _orderType : null,
              companyId: _isFilterByCompany ? _companyOfUser.value : null,
              partnerId: _isFilterByPartner ? _partner.id : null,
              staffId: _isFilterByStaff ? _userReportStaffOrder.value : null);
      final List<ReportOrderDetail> _reportOrderDetailMores =
          _reportOrderDetailOverviewLoadMore.reportOrderDetails;
      if (_reportOrderDetailMores.length == event.limit) {
        _reportOrderDetailMores.add(tempReportOrderDetail);
      }

      event.reportOrderDetails.addAll(_reportOrderDetailMores);

      yield ReportOrderDetailLoadSuccess(
          reportOrderDetails: event.reportOrderDetails,
          sumReportOrderDetail: event.sumReportOrderDetail,
          sumReportGeneral: event.sumReportGeneral,
          countInvoies: _reportOrderDetailOverviewLoadMore.odataCount);
    } catch (e, s) {
      yield ReportOrderLoadFailure(
          title: S.current.notification, content: e.toString());
    }
  }

  Stream<ReportOrderState> _getReportOrderDetailLoadFromLocalMore(
      ReportOrderDetailFromLocalLoaded event) async* {
    yield ReportOrderDetailLoadSuccess(
        reportOrderDetails: event.reportOrderDetails,
        sumReportOrderDetail: event.sumReportOrderDetail,
        sumReportGeneral: event.sumReportGeneral,
        countInvoies: event.countInvoices);
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
      yield ReportOrderLoadFailure(
          title: S.current.notification, content: e.toString());
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
      yield ReportOrderLoadFailure(
          title: S.current.notification, content: e.toString());
    }
  }

  Stream<ReportOrderState> _getReportOrderStaffs(
      ReportOrderStaffLoaded event) async* {
    try {
      final List<PartnerSaleReport> _staffSaleReports =
          await _apiClient.getReportOrderStaffs(
              top: event.limit,
              skip: event.skip,
              dateFrom: _dateFrom,
              dateTo: _dateTo,
              orderType: _isFilterByInvoiceType ? _orderType : null,
              companyId: _isFilterByCompany ? _companyOfUser.value : null,
              partnerId: _isFilterByPartner ? _partner.id : null,
              staffId: _isFilterByStaff ? _userReportStaffOrder.value : null);

      if (_staffSaleReports.length == event.limit) {
        _staffSaleReports.add(tempStaffSaleReport);
      }

      yield ReportOrderStaffLoadSuccess(staffSaleReports: _staffSaleReports);
    } catch (e, s) {
      yield ReportOrderLoadFailure(
          title: S.current.notification, content: e.toString());
    }
  }

  Stream<ReportOrderState> _getReportOrderStaffLoadMores(
      ReportOrderStaffLoadMoreLoaded event) async* {
    try {
      event.staffSaleReports.removeWhere(
          (element) => element.staffName == tempStaffSaleReport.staffName);
      final List<PartnerSaleReport> _staffSaleReportLoadMores =
          await _apiClient.getReportOrderStaffs(
              top: event.limit,
              skip: event.skip,
              dateFrom: _dateFrom,
              dateTo: _dateTo,
              orderType: _isFilterByInvoiceType ? _orderType : null,
              companyId: _isFilterByCompany ? _companyOfUser.value : null,
              partnerId: _isFilterByPartner ? _partner.id : null,
              staffId: _isFilterByStaff ? _userReportStaffOrder.value : null);

      if (_staffSaleReportLoadMores.length == event.limit) {
        _staffSaleReportLoadMores.add(tempStaffSaleReport);
      }

      event.staffSaleReports.addAll(_staffSaleReportLoadMores);

      yield ReportOrderStaffLoadSuccess(
          staffSaleReports: event.staffSaleReports);
    } catch (e, s) {
      yield ReportOrderLoadFailure(
          title: S.current.notification, content: e.toString());
    }
  }

  Stream<ReportOrderState> _getDetailReportCustomerTypeSales(
      DetailReportCustomerTypeSaleLoaded event) async* {
    try {
      final List<DetailReportCustomerTypeSale> _detailReportCustomerTypeSales =
          await _apiClient.getDetailReportCustomerTypeSale(
              top: event.limit,
              skip: event.skip,
              dateFrom: _dateFrom,
              dateTo: _dateTo,
              date: event.date,
              orderType: _isFilterByInvoiceType ? _orderType : null,
              partnerId: _isFilterByPartner ? _partner.id : null,
              staffId: _isFilterByStaff ? _userReportStaffOrder.value : null);
      if (_detailReportCustomerTypeSales.length == event.limit) {
        _detailReportCustomerTypeSales.add(tempDetailReportCustomerTypeSale);
      }

      yield DetailReportCustomerTypeSaleLoadSuccess(
          detailReportCustomerTypeSales: _detailReportCustomerTypeSales);
    } catch (e) {
      yield ReportOrderLoadFailure(
          title: S.current.notification, content: e.toString());
    }
  }

  Stream<ReportOrderState> _getDetailReportCustomerTypeSaleLoadMores(
      DetailReportCustomerTypeSaleLoadMoreLoaded event) async* {
    try {
      event.detailReportCustomerTypeSales.removeWhere(
          (element) => element.name == tempDetailReportCustomerTypeSale.name);
      final List<DetailReportCustomerTypeSale>
          _detailReportCustomerTypeSaleLoadMores =
          await _apiClient.getDetailReportCustomerTypeSale(
              top: event.limit,
              skip: event.skip,
              dateFrom: _dateFrom,
              dateTo: _dateTo,
              date: event.date,
              orderType: _isFilterByInvoiceType ? _orderType : null,
              partnerId: _isFilterByPartner ? _partner.id : null,
              staffId: _isFilterByStaff ? _userReportStaffOrder.value : null);
      if (_detailReportCustomerTypeSaleLoadMores.length == event.limit) {
        _detailReportCustomerTypeSaleLoadMores
            .add(tempDetailReportCustomerTypeSale);
      }

      event.detailReportCustomerTypeSales
          .addAll(_detailReportCustomerTypeSaleLoadMores);

      yield DetailReportCustomerTypeSaleLoadSuccess(
          detailReportCustomerTypeSales: event.detailReportCustomerTypeSales);
    } catch (e) {
      yield ReportOrderLoadFailure(
          title: S.current.notification, content: e.toString());
    }
  }

  Stream<ReportOrderState> _getInvoicesReportCustomer(
      DetailReportCustomerInvoicesLoaded event) async* {
    try {
      final List<DetailReportCustomerTypeSale> invoices =
          await _apiClient.getInvoicesDetailReportCustomer(
              top: event.limit,
              skip: event.skip,
              dateFrom: _dateFrom,
              dateTo: _dateTo,
              isNoCustomer: false,
              partnerId: event.partnerId);
      if (invoices.length == event.limit) {
        invoices.add(tempDetailReportCustomerTypeSale);
      }
      yield InvoiceReportCustomerTypeSaleLoadSuccess(
          invoiceReportCustomers: invoices);
    } catch (e) {
      yield ReportOrderLoadFailure(
          title: S.current.notification, content: e.toString());
    }
  }

  Stream<ReportOrderState> _getInvoicesReportCustomerLoadMore(
      DetailReportCustomerInvoicesLoadMoreLoaded event) async* {
    try {
      event.invoices.removeWhere(
              (element) => element.name == tempDetailReportCustomerTypeSale.name);

       List<DetailReportCustomerTypeSale> invoiceMores;
      if(event.partnerId != null){
        invoiceMores    =
        await _apiClient.getInvoicesDetailReportCustomer(
            top: event.limit,
            skip: event.skip,
            dateFrom: _dateFrom,
            dateTo: _dateTo,
            isNoCustomer: false,
            partnerId: event.partnerId);
      }else{
        invoiceMores =  await _apiClient.getInvoicesReportStaff(
            top: event.limit,
            skip: event.skip,
            dateFrom: _dateFrom,
            dateTo: _dateTo,
            staffId: event.staffId);
      }

      if (invoiceMores.length == event.limit) {
        invoiceMores
            .add(tempDetailReportCustomerTypeSale);
      }
      event.invoices.addAll(invoiceMores);
      if(event.partnerId != null){
        yield InvoiceReportCustomerTypeSaleLoadSuccess(
            invoiceReportCustomers: event.invoices);
      }else{
        yield InvoiceReportEmployeeTypeSaleLoadSuccess(
            invoiceReportEmployees: event.invoices);
      }

    } catch (e) {
      yield ReportOrderLoadFailure(
          title: S.current.notification, content: e.toString());
    }
  }

  Stream<ReportOrderState> _getInvoicesReportEmployee(
      ReportEmployeeInvoicesLoaded event) async* {
    try {
      final List<DetailReportCustomerTypeSale> invoices =
          await _apiClient.getInvoicesReportStaff(
              top: event.limit,
              skip: event.skip,
              dateFrom: _dateFrom,
              dateTo: _dateTo,
              staffId: event.staffId);
      if (invoices.length == event.limit) {
        invoices.add(tempDetailReportCustomerTypeSale);
      }
      yield InvoiceReportEmployeeTypeSaleLoadSuccess(
          invoiceReportEmployees: invoices);
    } catch (e) {
      yield ReportOrderLoadFailure(
          title: S.current.notification, content: e.toString());
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

var tempPartnerSaleReport = PartnerSaleReport(staffName: "partnerTemp");

var tempStaffSaleReport = PartnerSaleReport(staffName: "staffTemp");

var tempDetailReportCustomerTypeSale =
    DetailReportCustomerTypeSale(name: "detailTemp");
