import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/app_filter_helper.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/report_delivery_order_event.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/report_delivery_order_state.dart';
import 'package:tpos_mobile/feature_group/reports/thong_ke_giao_hang/report_delivery.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/company_of_user.dart';
import 'package:tpos_mobile/src/tpos_apis/models/delivery_carrier.dart';

import 'package:tpos_mobile/src/tpos_apis/models/filter_report_delivery.dart';

import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import '../../../../locator.dart';

class ReportDeliveryOrderBloc
    extends Bloc<ReportDeliveryOrderEvent, ReportDeliveryOrderState> {
  ReportDeliveryOrderBloc(
      {ReportDeliveryOrderApi reportDeliveryFastSaleOrderApi,
      ITposApiService tposApi,
      DialogService dialogService})
      : super(ReportDeliveryFastSaleOrderLoading()) {
    _apiClient = reportDeliveryFastSaleOrderApi ??
        GetIt.instance<ReportDeliveryOrderApi>();
    _dialog = dialogService ?? locator<DialogService>();
    _tposApi = tposApi ?? locator<ITposApiService>();

    _filterReportDelivery.filterDateRange = getTodayDateFilter();
    _filterReportDelivery.dateTo = _filterReportDelivery.filterDateRange.toDate;
    _filterReportDelivery.dateFrom =
        _filterReportDelivery.filterDateRange.fromDate;
    _filterReportDelivery.deliveryCarrier = DeliveryCarrier();
    _filterReportDelivery.partner = Partner();
    _filterReportDelivery.companyOfUser = CompanyOfUser();
  }

  ReportDeliveryOrderApi _apiClient;
  ITposApiService _tposApi;
  DialogService _dialog;

  FilterReportDelivery _filterReportDelivery = FilterReportDelivery(
      isFilterDeliveryCarrierType: false,
      isFilterDeliveryCarrier: false,
      isFilterShipState: false,
      isFilterControlState: false,
      isFilterByPartner: false,
      isFilterByCompany: false);

  @override
  Stream<ReportDeliveryOrderState> mapEventToState(
      ReportDeliveryOrderEvent event) async* {
    if (event is ReportDeliveryFastSaleOrderLoaded) {
      /// Lây thông tin tổng quan thống kê giao hàng
      yield ReportDeliveryFastSaleOrderLoading();
      yield* _getReportDeliveryFastSaleOrder(event);
    } else if (event is ReportDeliveryFastSaleOrderFilterSaved) {
      /// Lưu thông tin filter cho thống kê giao hàng
      yield* reportDeliveryFastSaleOrderFilterSave(event);
    } else if (event is DeliveryReportCustomerLoaded) {
      /// Lây thông tin danh sách khách hàng
      yield DeliveryReportCustomerLoading();
      yield* _getDeliveryReportCustomer(event);
    } else if (event is DeliveryReportStaffLoaded) {
      /// Lấy thông tin danh sách nhân viên
      yield DeliveryReportStaffLoading();
      yield* _getDeliveryReportStaff(event);
    } else if (event is DeliveryReportCustomerLoadMoreLoaded) {
      /// Thực hiện load more danh sách khách hàng
      yield DeliveryReportCustomerLoadMoreLoading();
      yield* _getDeliveryReportCustomerLoadMore(event);
    } else if (event is DeliveryReportStaffLoadMoreLoaded) {
      /// Thực hiện laod more danh sách nhân viên
      yield DeliveryReportStaffLoadMoreLoading();
      yield* _getDeliveryReportStaffLoadMore(event);
    } else if (event is ReportDeliveryFastSaleOrderInvoiceFromLocalLoaded) {
      /// Thục hiện lấy cập nhật danh sách hóa đơn từ local cho danh trang tổng quan khi chuyển qua page khác
      yield* _getReportDeliveryFastSaleOrderInvoiceFromLocal(event);
    } else if (event is ReportDeliveryFastSaleOrderLoadMoreLoaded) {
      /// Thực hiện load more cho trang tổng quan
      yield ReportDeliveryFastSaleOrderLoadMoreLoading();
      yield* _getReportDeliveryFastSaleOrderLoadMore(event);
    } else if (event is DeliveryReportOrderLinesLoaded) {
      /// Thực hiện lấy thoogn tin chi tiêt cho hóa đơn
      yield ReportDeliveryFastSaleOrderLoading();
      yield* _getDeliveryReportOrderLines(event);
    } else if (event is DetailDeliveryReportStaffLoaded) {
      /// Lấy thông tin chi tiế cho nhân viên
      yield DeliveryReportStaffLoading();
      yield* _getDetailDeliveryReportStaff(event);
    } else if (event is DetailDeliveryReportStaffLoadMoreLoaded) {
      yield DeliveryReportStaffLoadMoreLoading();
      yield* _getDetailDeliveryReportStaffLoadMore(event);
    }
  }

  Stream<ReportDeliveryOrderState> _getReportDeliveryFastSaleOrder(
      ReportDeliveryFastSaleOrderLoaded event) async* {
    try {
      final DeliveryOrderReport reportDelivery =
          await _apiClient.getReportDeliveryFastSaleOrder(
              take: event.limit,
              skip: event.skip,
              dateFrom: _filterReportDelivery.dateFrom,
              dateTo: _filterReportDelivery.dateTo,
              shipState: _filterReportDelivery.isFilterShipState
                  ? _filterReportDelivery.shipState
                  : null,
              partnerId: _filterReportDelivery.isFilterByPartner
                  ? _filterReportDelivery.partner.id
                  : null,
              carrierId: _filterReportDelivery.isFilterDeliveryCarrier
                  ? _filterReportDelivery.deliveryCarrier.id
                  : null,
              companyId: _filterReportDelivery.isFilterByCompany
                  ? _filterReportDelivery.companyOfUser.value
                  : null,
              deliveryType: _filterReportDelivery.isFilterDeliveryCarrierType
                  ? _filterReportDelivery.deliveryCarrierType
                  : null,
              forControl: _filterReportDelivery.isFilterControlState
                  ? _filterReportDelivery.stateControl
                  : null);

      final SumDeliveryReportFastSaleOrder sumDeliveryReport =
          await _apiClient.getSumReportDeliveryFastSaleOrder(
              dateFrom: _filterReportDelivery.dateFrom,
              dateTo: _filterReportDelivery.dateTo,
              shipState: _filterReportDelivery.isFilterShipState
                  ? _filterReportDelivery.shipState
                  : null,
              partnerId: _filterReportDelivery.isFilterByPartner
                  ? _filterReportDelivery.partner.id
                  : null,
              carrierId: _filterReportDelivery.isFilterDeliveryCarrier
                  ? _filterReportDelivery.deliveryCarrier.id
                  : null,
              companyId: _filterReportDelivery.isFilterByCompany
                  ? _filterReportDelivery.companyOfUser.value
                  : null,
              deliveryType: _filterReportDelivery.isFilterDeliveryCarrierType
                  ? _filterReportDelivery.deliveryCarrierType
                  : null,
              forControl: _filterReportDelivery.isFilterControlState
                  ? _filterReportDelivery.stateControl
                  : null);

      if (reportDelivery.data.length == event.limit) {
        reportDelivery.data.add(tempReportDelivery);
      }

      yield ReportDeliveryFastSaleOrderLoadSuccess(
          reportDeliveryFastSaleOrder: reportDelivery,
          sumDeliveryReportFastSaleOrder: sumDeliveryReport);
    } catch (e) {
      yield ReportDeliveryFastSaleOrderLoadFailure(
          title: S.current.notification, content: e.toString());
    }
  }

  Stream<ReportDeliveryOrderState> _getReportDeliveryFastSaleOrderLoadMore(
      ReportDeliveryFastSaleOrderLoadMoreLoaded event) async* {
    try {
      event.reportDeliveryFastSaleOrder.data.removeWhere(
          (element) => element.userName == tempReportDelivery.userName);
      final DeliveryOrderReport reportDeliveryLoadMore =
          await _apiClient.getReportDeliveryFastSaleOrder(
              take: event.limit,
              skip: event.skip,
              dateFrom: _filterReportDelivery.dateFrom,
              dateTo: _filterReportDelivery.dateTo,
              shipState: _filterReportDelivery.isFilterShipState
                  ? _filterReportDelivery.shipState
                  : null,
              partnerId: _filterReportDelivery.isFilterByPartner
                  ? _filterReportDelivery.partner.id
                  : null,
              carrierId: _filterReportDelivery.isFilterDeliveryCarrier
                  ? _filterReportDelivery.deliveryCarrier.id
                  : null,
              companyId: _filterReportDelivery.isFilterByCompany
                  ? _filterReportDelivery.companyOfUser.value
                  : null,
              deliveryType: _filterReportDelivery.isFilterDeliveryCarrierType
                  ? _filterReportDelivery.deliveryCarrierType
                  : null,
              forControl: _filterReportDelivery.isFilterControlState
                  ? _filterReportDelivery.stateControl
                  : null);

      if (reportDeliveryLoadMore.data.length == event.limit) {
        reportDeliveryLoadMore.data.add(tempReportDelivery);
      }

      event.reportDeliveryFastSaleOrder.data
          .addAll(reportDeliveryLoadMore.data);
      yield ReportDeliveryFastSaleOrderLoadSuccess(
          reportDeliveryFastSaleOrder: event.reportDeliveryFastSaleOrder,
          sumDeliveryReportFastSaleOrder: event.sumDeliveryReportFastSaleOrder);
    } catch (e) {
      yield ReportDeliveryFastSaleOrderLoadFailure(
          title: S.current.notification, content: e.toString());
    }
  }

  Stream<ReportDeliveryOrderState> _getDeliveryReportCustomer(
      DeliveryReportCustomerLoaded event) async* {
    try {
      final List<ReportDeliveryCustomer> deliveryReportCustomers =
          await _apiClient.getDeliveryReportCustomer(
        take: event.limit,
        skip: event.skip,
        dateFrom: _filterReportDelivery.dateFrom,
        dateTo: _filterReportDelivery.dateTo,
        shipState: _filterReportDelivery.isFilterShipState
            ? _filterReportDelivery.shipState
            : null,
        partnerId: _filterReportDelivery.isFilterByPartner
            ? _filterReportDelivery.partner.id
            : null,
        carrierId: _filterReportDelivery.isFilterDeliveryCarrier
            ? _filterReportDelivery.deliveryCarrier.id
            : null,
        companyId: _filterReportDelivery.isFilterByCompany
            ? _filterReportDelivery.companyOfUser.value
            : null,
        deliveryType: _filterReportDelivery.isFilterDeliveryCarrierType
            ? _filterReportDelivery.deliveryCarrierType
            : null,
      );

      if (deliveryReportCustomers.length == event.limit) {
        deliveryReportCustomers.add(tempDeliveryReportCustomer);
      }

      yield DeliveryReportCustomerLoadSuccess(
          deliveryReportCustomers: deliveryReportCustomers);
    } catch (e) {
      yield ReportDeliveryFastSaleOrderLoadFailure(
          title: S.current.notification, content: e.toString());
    }
  }

  Stream<ReportDeliveryOrderState> _getDeliveryReportCustomerLoadMore(
      DeliveryReportCustomerLoadMoreLoaded event) async* {
    try {
      event.deliveryReportCustomers.removeWhere(
          (element) => element.userName == tempDeliveryReportCustomer.userName);

      final List<ReportDeliveryCustomer> deliveryReportCustomerLoadMores =
          await _apiClient.getDeliveryReportCustomer(
        take: event.limit,
        skip: event.skip,
        dateFrom: _filterReportDelivery.dateFrom,
        dateTo: _filterReportDelivery.dateTo,
        shipState: _filterReportDelivery.isFilterShipState
            ? _filterReportDelivery.shipState
            : null,
        partnerId: _filterReportDelivery.isFilterByPartner
            ? _filterReportDelivery.partner.id
            : null,
        carrierId: _filterReportDelivery.isFilterDeliveryCarrier
            ? _filterReportDelivery.deliveryCarrier.id
            : null,
        companyId: _filterReportDelivery.isFilterByCompany
            ? _filterReportDelivery.companyOfUser.value
            : null,
        deliveryType: _filterReportDelivery.isFilterDeliveryCarrierType
            ? _filterReportDelivery.deliveryCarrierType
            : null,
      );

      if (deliveryReportCustomerLoadMores.length == event.limit) {
        deliveryReportCustomerLoadMores.add(tempDeliveryReportCustomer);
      }

      event.deliveryReportCustomers.addAll(deliveryReportCustomerLoadMores);

      yield DeliveryReportCustomerLoadSuccess(
          deliveryReportCustomers: event.deliveryReportCustomers);
    } catch (e) {
      yield ReportDeliveryFastSaleOrderLoadFailure(
          title: S.current.notification, content: e.toString());
    }
  }

  Stream<ReportDeliveryOrderState> _getDeliveryReportStaff(
      DeliveryReportStaffLoaded event) async* {
    try {
      final List<ReportDeliveryCustomer> deliveryReportStaffs =
          await _apiClient.getDeliveryReportStaff(
        take: event.limit,
        skip: event.skip,
        dateFrom: _filterReportDelivery.dateFrom,
        dateTo: _filterReportDelivery.dateTo,
        shipState: _filterReportDelivery.isFilterShipState
            ? _filterReportDelivery.shipState
            : null,
        partnerId: _filterReportDelivery.isFilterByPartner
            ? _filterReportDelivery.partner.id
            : null,
        carrierId: _filterReportDelivery.isFilterDeliveryCarrier
            ? _filterReportDelivery.deliveryCarrier.id
            : null,
        companyId: _filterReportDelivery.isFilterByCompany
            ? _filterReportDelivery.companyOfUser.value
            : null,
        deliveryType: _filterReportDelivery.isFilterDeliveryCarrierType
            ? _filterReportDelivery.deliveryCarrierType
            : null,
      );

      if (deliveryReportStaffs.length == event.limit) {
        deliveryReportStaffs.add(tempDeliveryReportStaff);
      }

      yield DeliveryReportStaffLoadSuccess(
          deliveryReportStaffs: deliveryReportStaffs);
    } catch (e) {
      yield ReportDeliveryFastSaleOrderLoadFailure(
          title: S.current.notification, content: e.toString());
    }
  }

  Stream<ReportDeliveryOrderState> _getDeliveryReportStaffLoadMore(
      DeliveryReportStaffLoadMoreLoaded event) async* {
    try {
      event.deliveryReportStaffs.removeWhere(
          (element) => element.userName == tempDeliveryReportStaff.userName);

      final List<ReportDeliveryCustomer> deliveryReportStaffLoadMores =
          await _apiClient.getDeliveryReportStaff(
        take: event.limit,
        skip: event.skip,
        dateFrom: _filterReportDelivery.dateFrom,
        dateTo: _filterReportDelivery.dateTo,
        shipState: _filterReportDelivery.isFilterShipState
            ? _filterReportDelivery.shipState
            : null,
        partnerId: _filterReportDelivery.isFilterByPartner
            ? _filterReportDelivery.partner.id
            : null,
        carrierId: _filterReportDelivery.isFilterDeliveryCarrier
            ? _filterReportDelivery.deliveryCarrier.id
            : null,
        companyId: _filterReportDelivery.isFilterByCompany
            ? _filterReportDelivery.companyOfUser.value
            : null,
        deliveryType: _filterReportDelivery.isFilterDeliveryCarrierType
            ? _filterReportDelivery.deliveryCarrierType
            : null,
      );

      if (deliveryReportStaffLoadMores.length == event.limit) {
        deliveryReportStaffLoadMores.add(tempDeliveryReportCustomer);
      }

      event.deliveryReportStaffs.addAll(deliveryReportStaffLoadMores);

      yield DeliveryReportStaffLoadSuccess(
          deliveryReportStaffs: event.deliveryReportStaffs);
    } catch (e) {
      yield ReportDeliveryFastSaleOrderLoadFailure(
          title: S.current.notification, content: e.toString());
    }
  }

  Stream<ReportDeliveryOrderState> _getDeliveryReportOrderLines(
      DeliveryReportOrderLinesLoaded event) async* {
    try {
      final List<ReportDeliveryOrderLine> reportDeliveryOrderLines =
          await _tposApi.getReportDeliveryOrderDetail(event.id);
      yield DeliveryReportOrderLinesLoadSuccess(
          orderLines: reportDeliveryOrderLines);
    } catch (e) {
      yield ReportDeliveryFastSaleOrderLoadFailure(
          title: S.current.notification, content: e.toString());
    }
  }

  Stream<ReportDeliveryOrderState>
      _getReportDeliveryFastSaleOrderInvoiceFromLocal(
          ReportDeliveryFastSaleOrderInvoiceFromLocalLoaded event) async* {
    yield ReportDeliveryFastSaleOrderLoadSuccess(
        reportDeliveryFastSaleOrder: event.reportDeliveryFastSaleOrder,
        sumDeliveryReportFastSaleOrder: event.sumDeliveryReportFastSaleOrder);
  }

  Stream<ReportDeliveryOrderState> _getDetailDeliveryReportStaff(
      DetailDeliveryReportStaffLoaded event) async* {
    try {
      final List<ReportDeliveryOrderDetail> detailDeliveryReports =
          await _apiClient.getDetailDeliveryReportStaff(
              take: event.limit,
              skip: event.skip,
              dateFrom: _filterReportDelivery.dateFrom,
              dateTo: _filterReportDelivery.dateTo,
              shipState: _filterReportDelivery.isFilterShipState
                  ? _filterReportDelivery.shipState
                  : null,
              partnerId: _filterReportDelivery.isFilterByPartner
                  ? _filterReportDelivery.partner.id
                  : null,
              carrierId: _filterReportDelivery.isFilterDeliveryCarrier
                  ? _filterReportDelivery.deliveryCarrier.id
                  : null,
              companyId: _filterReportDelivery.isFilterByCompany
                  ? _filterReportDelivery.companyOfUser.value
                  : null,
              deliveryType: _filterReportDelivery.isFilterDeliveryCarrierType
                  ? _filterReportDelivery.deliveryCarrierType
                  : null,
              userId: event.userId);

      if (detailDeliveryReports.length == event.limit) {
        detailDeliveryReports.add(tempDetailReportDeliveryStaff);
      }

      yield DetailDeliveryReportStaffLoadSuccess(
          detailReportStaffs: detailDeliveryReports);
    } catch (e) {
      yield ReportDeliveryFastSaleOrderLoadFailure(
          title: S.current.notification, content: e.toString());
    }
  }

  Stream<ReportDeliveryOrderState> _getDetailDeliveryReportStaffLoadMore(
      DetailDeliveryReportStaffLoadMoreLoaded event) async* {
    try {
      event.detailReportStaffs.removeWhere((element) =>
          element.userName == tempDetailReportDeliveryStaff.userName);

      final List<ReportDeliveryOrderDetail> detailDeliveryReportLoadMores =
          await _apiClient.getDetailDeliveryReportStaff(
              take: event.limit,
              skip: event.skip,
              dateFrom: _filterReportDelivery.dateFrom,
              dateTo: _filterReportDelivery.dateTo,
              shipState: _filterReportDelivery.isFilterShipState
                  ? _filterReportDelivery.shipState
                  : null,
              partnerId: _filterReportDelivery.isFilterByPartner
                  ? _filterReportDelivery.partner.id
                  : null,
              carrierId: _filterReportDelivery.isFilterDeliveryCarrier
                  ? _filterReportDelivery.deliveryCarrier.id
                  : null,
              companyId: _filterReportDelivery.isFilterByCompany
                  ? _filterReportDelivery.companyOfUser.value
                  : null,
              deliveryType: _filterReportDelivery.isFilterDeliveryCarrierType
                  ? _filterReportDelivery.deliveryCarrierType
                  : null,
              userId: event.userId);

      if (detailDeliveryReportLoadMores.length == event.limit) {
        detailDeliveryReportLoadMores.add(tempDetailReportDeliveryStaff);
      }

      event.detailReportStaffs.addAll(detailDeliveryReportLoadMores);

      yield DetailDeliveryReportStaffLoadSuccess(
          detailReportStaffs: event.detailReportStaffs);
    } catch (e) {
      yield ReportDeliveryFastSaleOrderLoadFailure(
          title: S.current.notification, content: e.toString());
    }
  }

  Stream<ReportDeliveryOrderState> reportDeliveryFastSaleOrderFilterSave(
      ReportDeliveryFastSaleOrderFilterSaved event) async* {
    _filterReportDelivery = event.filterReportDelivery;
  }
}

var tempDeliveryReportCustomer = ReportDeliveryCustomer(userName: "temp");

var tempDeliveryReportStaff = ReportDeliveryCustomer(userName: "staffTemp");

var tempReportDelivery = ReportDeliveryOrderDetail(userName: "invoiceTemp");
var tempDetailReportDeliveryStaff =
    ReportDeliveryOrderDetail(userName: "detailTemp");
