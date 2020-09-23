import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/app_filter_helper.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/report_delivery_fast_sale_order_event.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/report_delivery_fast_sale_order_state.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/company_of_user.dart';
import 'package:tpos_mobile/src/tpos_apis/models/delivery_carrier.dart';
import 'package:tpos_mobile/src/tpos_apis/models/filter_report_delivery.dart';
import 'package:tpos_mobile/src/tpos_apis/models/partner.dart';

import '../../../../locator.dart';

class ReportDeliveryFastSaleOrderBloc extends Bloc<
    ReportDeliveryFastSaleOrderEvent, ReportDeliveryFastSaleOrderState> {
  ReportDeliveryFastSaleOrderBloc(
      {ReportDeliveryFastSaleOrderApi reportDeliveryFastSaleOrderApi,
      DialogService dialogService})
      : super(ReportDeliveryFastSaleOrderLoading()) {
    _apiClient = reportDeliveryFastSaleOrderApi ??
        GetIt.instance<ReportDeliveryFastSaleOrderApi>();
    _dialog = dialogService ?? locator<DialogService>();

    _filterReportDelivery.filterDateRange = getTodayDateFilter();
    _filterReportDelivery.dateTo = _filterReportDelivery.filterDateRange.toDate;
    _filterReportDelivery.dateFrom =
        _filterReportDelivery.filterDateRange.fromDate;
    _filterReportDelivery.deliveryCarrier = DeliveryCarrier();
    _filterReportDelivery.partner = Partner();
    _filterReportDelivery.companyOfUser = CompanyOfUser();
  }

  ReportDeliveryFastSaleOrderApi _apiClient;
  DialogService _dialog;

  FilterReportDelivery _filterReportDelivery = FilterReportDelivery(
      isFilterDeliveryCarrierType: false,
      isFilterDeliveryCarrier: false,
      isFilterShipState: false,
      isFilterControlState: false,
      isFilterByPartner: false,
      isFilterByCompany: false);

  @override
  Stream<ReportDeliveryFastSaleOrderState> mapEventToState(
      ReportDeliveryFastSaleOrderEvent event) async* {
    if (event is ReportDeliveryFastSaleOrderLoaded) {
      yield ReportDeliveryFastSaleOrderLoading();
      yield* _getReportDeliveryFastSaleOrder(event);
    } else if (event is ReportDeliveryFastSaleOrderFilterSaved) {
      yield* reportDeliveryFastSaleOrderFilterSave(event);
    } else if (event is DeliveryReportCustomerLoaded) {
      yield DeliveryReportCustomerLoading();
      yield* _getDeliveryReportCustomer(event);
    } else if (event is DeliveryReportCustomerLoadMoreLoaded) {
      yield DeliveryReportCustomerLoadMoreLoading();
      yield* _getDeliveryReportCustomerLoadMore(event);
    }else if(event is ReportDeliveryFastSaleOrderInvoiceFromLocalLoaded){
     yield* _getReportDeliveryFastSaleOrderInvoiceFromLocal(event);
    }
  }

  Stream<ReportDeliveryFastSaleOrderState> _getReportDeliveryFastSaleOrder(
      ReportDeliveryFastSaleOrderLoaded event) async* {
    try {
      final ReportDeliveryFastSaleOrder reportDelivery =
          await _apiClient.getReportDeliveryFastSaleOrder(
              take: 50,
              skip: 0,
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

      yield ReportDeliveryFastSaleOrderLoadSuccess(
          reportDeliveryFastSaleOrder: reportDelivery,
          sumDeliveryReportFastSaleOrder: sumDeliveryReport);
    } catch (e) {
      yield ReportDeliveryFastSaleOrderLoadFailure(
          title: "Thông báo", content: e.toString());
    }
  }

  Stream<ReportDeliveryFastSaleOrderState> _getDeliveryReportCustomer(
      DeliveryReportCustomerLoaded event) async* {
    try {
      final List<DeliveryReportCustomer> deliveryReportCustomers =
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
          title: "Thông báo", content: e.toString());
    }
  }

  Stream<ReportDeliveryFastSaleOrderState> _getDeliveryReportCustomerLoadMore(
      DeliveryReportCustomerLoadMoreLoaded event) async* {
    try {
      event.
         deliveryReportCustomers.removeWhere((element) => element.userName == tempDeliveryReportCustomer.userName);

      final List<DeliveryReportCustomer> deliveryReportCustomerLoadMores =
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
          title: "Thông báo", content: e.toString());
    }
  }

  Stream<ReportDeliveryFastSaleOrderState> _getReportDeliveryFastSaleOrderInvoiceFromLocal(
      ReportDeliveryFastSaleOrderInvoiceFromLocalLoaded event) async* {
    yield ReportDeliveryFastSaleOrderLoadSuccess(
        reportDeliveryFastSaleOrder: event.reportDeliveryFastSaleOrder,
        sumDeliveryReportFastSaleOrder: event.sumDeliveryReportFastSaleOrder);
  }

  Stream<ReportDeliveryFastSaleOrderState>
      reportDeliveryFastSaleOrderFilterSave(
          ReportDeliveryFastSaleOrderFilterSaved event) async* {
    _filterReportDelivery = event.filterReportDelivery;
  }
}

var tempDeliveryReportCustomer = DeliveryReportCustomer(userName: "customerTemp");