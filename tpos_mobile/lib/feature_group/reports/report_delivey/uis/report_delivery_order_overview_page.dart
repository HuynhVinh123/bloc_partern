import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/filter_report_delivery/filter_report_delivery_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/filter_report_delivery/filter_report_delivery_state.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/report_delivery_order_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/report_delivery_order_event.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/report_delivery_order_state.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/uis/report_delivery_order_invoice_list_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/uis/report_delivery_order_page.dart';
import 'package:tpos_mobile/helpers/svg_icon.dart';
import 'package:tpos_mobile/src/tpos_apis/models/filter_report_delivery.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class ReportDeliveryOrderOverViewPage extends StatefulWidget {
  const ReportDeliveryOrderOverViewPage(
      {this.filterBloc,
      this.scaffoldKey,
      this.bloc,
      this.filterReportDelivery,
      this.onChangeFirstLoad,
      this.onUpdate,
      this.onChangeFilter});

  final ReportDeliveryOrderBloc bloc;
  final FilterReportDeliveryBloc filterBloc;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final FilterReportDelivery filterReportDelivery;
  final Function onChangeFirstLoad;
  final Function onUpdate;
  final Function onChangeFilter;
  @override
  _ReportDeliveryOrderOverViewPageState createState() =>
      _ReportDeliveryOrderOverViewPageState();
}

class _ReportDeliveryOrderOverViewPageState
    extends State<ReportDeliveryOrderOverViewPage> {
  @override
  void initState() {
    super.initState();
    widget.bloc.add(ReportDeliveryFastSaleOrderLoaded(limit: 50, skip: 0));
  }

  @override
  Widget build(BuildContext context) {
    return BlocLoadingScreen<ReportDeliveryOrderBloc>(
      busyStates: const [ReportDeliveryFastSaleOrderLoading],
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    return BlocBuilder<ReportDeliveryOrderBloc, ReportDeliveryOrderState>(
        buildWhen: (prevState, currState) {
      if (currState is ReportDeliveryFastSaleOrderLoadSuccess) {
        return true;
      }
      return false;
    }, builder: (context, state) {
      if (state is ReportDeliveryFastSaleOrderLoadSuccess) {
        return Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _buildGeneral(state.sumDeliveryReportFastSaleOrder),
                _buildListInvoice(state)
              ],
            ),
          ),
        );
      }
      return const SizedBox();
    });
  }

  Widget _buildGeneral(SumDeliveryReportFastSaleOrder sumDeliveryReport) {
    return Stack(
      children: <Widget>[
        Container(
          padding:
              const EdgeInsets.only(left: 12, right: 12, bottom: 12, top: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          margin:
              const EdgeInsets.only(left: 12, right: 12, bottom: 12, top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ItemReportDeliveryGeneral(
                color: const Color(0xFF7AC461),
                icon: const SvgIcon(SvgIcon.saveMoney),

                /// Tiền thu hộ reportOrder_collectionAmount
                title: S.current.reportOrder_collectionAmount,
                amount: vietnameseCurrencyFormat(
                    sumDeliveryReport?.sumCollectionAmount ?? 0),
                textColor: const Color(0xFF7AC461),
                totalInvoice:
                    sumDeliveryReport?.sumQuantityCollectionOrder ?? 0,
              ),
              ItemReportDeliveryGeneralDot(
                color: const Color(0xff28A745),

                /// Đã thanh toán
                title: S.current.reportOrder_Paid,
                amount: vietnameseCurrencyFormat(
                    sumDeliveryReport?.sumPaymentAmount ?? 0),
                totalInvoice: sumDeliveryReport?.sumQuantityPaymentOrder ?? 0,
              ),
              ItemReportDeliveryGeneralDot(
                color: const Color(0xff2395FF),

                /// Đang giao
                title: S.current.reportOrder_Delivering,
                amount: vietnameseCurrencyFormat(
                    sumDeliveryReport?.sumDeliveringAmount ?? 0),
                totalInvoice: sumDeliveryReport?.sumQuantityDelivering ?? 0,
              ),
              ItemReportDeliveryGeneralDot(
                color: const Color(0xffF3A72E),

                /// Trả hàng
                title: S.current.reportOrder_refundedOrder,
                amount: vietnameseCurrencyFormat(
                    sumDeliveryReport?.sumRefundedAmount ?? 0),
                totalInvoice: sumDeliveryReport?.sumQuantityRefundedOrder ?? 0,
              ),
              ItemReportDeliveryGeneralDot(
                color: const Color(0xffEB3B5B),

                /// Đối soát không thành công
                title: S.current.reportOrder_controlFailed,
                amount: vietnameseCurrencyFormat(
                    sumDeliveryReport?.sumOtherAmount ?? 0),
                totalInvoice: sumDeliveryReport?.sumQuantityOther ?? 0,
              ),
              ItemReportDeliveryGeneral(
                color: const Color(0xFF4EAAFF),
                icon: const SvgIcon(SvgIcon.deposit),

                /// Tổng tiền cọc
                title: S.current.reportOrder_Deposit,
                amount: vietnameseCurrencyFormat(
                    sumDeliveryReport?.sumAmountDeposit ?? 0),
                totalInvoice: sumDeliveryReport?.sumQuantityDeposit ?? 0,
                textColor: const Color(0xFF4EAAFF),
              ),
            ],
          ),
        ),
        Positioned(
            top: 6,
            left: 0,
            right: 0,
            child: BlocBuilder<FilterReportDeliveryBloc,
                    FilterReportDeliveryState>(
                buildWhen: (prevState, curState) {
                  if (curState is FilterReportDeliveryLoadSuccess &&
                      curState.isConfirm) {
                    return true;
                  }
                  return false;
                },
                cubit: widget.filterBloc,
                builder: (context, state) {
                  if (state is FilterReportDeliveryLoadSuccess) {
                    return Center(
                        child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                                color: const Color(0xFfEBEDEF),
                                borderRadius: BorderRadius.circular(12)),
                            child: FilterDateByDelivery(
                              state: state,
                              onChangeFilter: widget.onChangeFilter,
                            )));
                  }
                  return const SizedBox();
                }))
      ],
    );
  }

  Widget _buildListInvoice(ReportDeliveryFastSaleOrderLoadSuccess state) {
    return InkWell(
      onTap: () {
        widget.onUpdate();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ReportDeliveryOrderInvoiceListPage(
                      bloc: widget.bloc,
                      filterBloc: widget.filterBloc,
                      sumDeliveryReportFastSaleOrder:
                          state.sumDeliveryReportFastSaleOrder,
                      reportDeliveryFastSaleOrder:
                          state.reportDeliveryFastSaleOrder,
                      filterReportDelivery: widget.filterReportDelivery,
                    ))).then((value) {
          widget.onChangeFirstLoad();
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: <Widget>[
            Expanded(
                child: Text(
              S.current.reportOrder_deliveryInvoices,
              style: const TextStyle(color: Color(0xFF2C333A), fontSize: 16),
            )),
            Container(
              margin: const EdgeInsets.only(right: 6),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFF28A745)),
              child: Center(
                  child: Text(
                state.reportDeliveryFastSaleOrder.data != null
                    ? state.reportDeliveryFastSaleOrder.total.toString()
                    : "0",
                style: const TextStyle(color: Colors.white),
              )),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFF929DAA),
            ),
          ],
        ),
      ),
    );
  }
}
