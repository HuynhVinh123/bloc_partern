import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/filter_report_delivery/filter_report_delivery_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/filter_report_delivery/filter_report_delivery_state.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/report_delivery_fast_sale_order_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/report_delivery_fast_sale_order_event.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/report_delivery_fast_sale_order_state.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/uis/report_delivery_fast_sale_order_invoice_list_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/uis/report_delivery_fast_sale_order_page.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';

class ReportDeliveryFastSaleOrderOverViewPage extends StatefulWidget {
  const ReportDeliveryFastSaleOrderOverViewPage(
      {this.filterBloc, this.scaffoldKey, this.bloc});

  final ReportDeliveryFastSaleOrderBloc bloc;
  final FilterReportDeliveryBloc filterBloc;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  _ReportDeliveryFastSaleOrderOverViewPageState createState() =>
      _ReportDeliveryFastSaleOrderOverViewPageState();
}

class _ReportDeliveryFastSaleOrderOverViewPageState
    extends State<ReportDeliveryFastSaleOrderOverViewPage> {
  @override
  void initState() {
    super.initState();
    widget.bloc.add(ReportDeliveryFastSaleOrderLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return BlocLoadingScreen<ReportDeliveryFastSaleOrderBloc>(
      busyStates: const [ReportDeliveryFastSaleOrderLoading],
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    return BlocBuilder<ReportDeliveryFastSaleOrderBloc,
        ReportDeliveryFastSaleOrderState>(buildWhen: (prevState, currState) {
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
                _buildListInvoice(state.reportDeliveryFastSaleOrder)
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
          margin: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ItemReportDeliveryGeneral(
                color: const Color(0xFF7AC461),
                icon: SvgPicture.asset(
                  "assets/icon/ic_save_money.svg",
                  alignment: Alignment.center,
                ),
                title: "Tiền thu hộ",
                amount: vietnameseCurrencyFormat(
                    sumDeliveryReport?.sumCollectionAmount ?? 0),
                textColor: const Color(0xFF7AC461),
                totalInvoice:
                    sumDeliveryReport?.sumQuantityCollectionOrder ?? 0,
              ),
              ItemReportDeliveryGeneralDot(
                color: const Color(0xff28A745),
                title: "Đã thanh toán",
                amount: vietnameseCurrencyFormat(
                    sumDeliveryReport?.sumPaymentAmount ?? 0),
                totalInvoice: sumDeliveryReport?.sumQuantityPaymentOrder ?? 0,
              ),
              ItemReportDeliveryGeneralDot(
                color: const Color(0xff2395FF),
                title: "Đang giao",
                amount: vietnameseCurrencyFormat(
                    sumDeliveryReport?.sumDeliveringAmount ?? 0),
                totalInvoice: sumDeliveryReport?.sumQuantityDelivering ?? 0,
              ),
              ItemReportDeliveryGeneralDot(
                color: const Color(0xffF3A72E),
                title: "Trả hàng",
                amount: vietnameseCurrencyFormat(
                    sumDeliveryReport?.sumRefundedAmount ?? 0),
                totalInvoice: sumDeliveryReport?.sumQuantityRefundedOrder ?? 0,
              ),
              ItemReportDeliveryGeneralDot(
                color: const Color(0xffEB3B5B),
                title: "Đối soát không thành công",
                amount: vietnameseCurrencyFormat(
                    sumDeliveryReport?.sumOtherAmount ?? 0),
                totalInvoice: sumDeliveryReport?.sumQuantityOther ?? 0,
              ),
              ItemReportDeliveryGeneral(
                color: const Color(0xFF4EAAFF),
                icon: SvgPicture.asset(
                  "assets/icon/ic_invoice.svg",
                  alignment: Alignment.center,
                ),
                title: "Tổng tiền cọc",
                amount: vietnameseCurrencyFormat(
                    sumDeliveryReport?.sumAmountDeposit ?? 0),
                totalInvoice: sumDeliveryReport?.sumQuantityDeposit ?? 0,
                textColor: const Color(0xFF4EAAFF),
              ),
            ],
          ),
        ),
        Positioned(
            top: 2,
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
                        child: InkWell(
                      onTap: () {
                        widget.scaffoldKey.currentState.openEndDrawer();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            color: const Color(0xFfEBEDEF),
                            borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(Icons.date_range,
                                size: 17, color: const Color(0xFF6B7280)),
                            const SizedBox(
                              width: 6,
                            ),
                            Text(
                              state.filterDateRange != null
                                  ? state.filterDateRange.name == "Tùy chỉnh"
                                      ? "${DateFormat("dd/MM/yyyy").format(state.filterFromDate)} - ${DateFormat("dd/MM/yyyy").format(state.filterToDate)}"
                                      : state.filterDateRange.name
                                  : "Thời gian",
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Color(0xFF6B7280)),
                            ),
                            Icon(Icons.arrow_drop_down,
                                color: const Color(0xFF6B7280))
                          ],
                        ),
                      ),
                    ));
                  }
                  return const SizedBox();
                }))
      ],
    );
  }

  Widget _buildListInvoice(ReportDeliveryFastSaleOrder reportDeliveryFastSaleOrder) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ReportDeliveryFastSaleOrderInvoiceListPage(
                      bloc: widget.bloc,
                      filterBloc: widget.filterBloc,
                    )));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: <Widget>[
            const Expanded(
                child: Text(
              "Danh sách hóa đơn giao hàng",
              style: TextStyle(color: Color(0xFF2C333A), fontSize: 16),
            )),
            Container(
              margin: const EdgeInsets.only(right: 6),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFF28A745)),
              child: Center(
                child: Text(
                  reportDeliveryFastSaleOrder.data != null ? reportDeliveryFastSaleOrder.data.length.toString() : "0",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
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
