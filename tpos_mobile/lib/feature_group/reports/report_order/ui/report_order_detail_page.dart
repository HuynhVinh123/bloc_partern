import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/filter/filter_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/filter/filter_state.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/report_order_detail_invoice_list_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/report_order_page.dart';
import 'package:tpos_mobile/helpers/svg_icon.dart';
import 'package:tpos_mobile/resources/tpos_mobile_icons.dart';
import 'package:tpos_mobile/src/tpos_apis/models/filter.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import '../report_order_bloc.dart';
import '../report_order_event.dart';
import '../report_order_state.dart';

class ReportOrderDetailPage extends StatefulWidget {
  const ReportOrderDetailPage(
      {this.bloc,
      this.filterBloc,
      this.scaffoldKey,
      this.filter,
      this.onChangeFirstLoad,
      this.onUpdate,
      this.onChangeFilter});
  final ReportOrderBloc bloc;
  final FilterBloc filterBloc;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Filter filter;
  final Function onChangeFirstLoad;
  final Function onUpdate;
  final Function onChangeFilter;

  @override
  _ReportOrderDetailState createState() => _ReportOrderDetailState();
}

class _ReportOrderDetailState extends State<ReportOrderDetailPage> {
  final int _limit = 20;
  final int _skip = 0;

  @override
  void initState() {
    super.initState();
    widget.bloc.add(ReportOrderDetailLoaded(limit: _limit, skip: _skip));
  }

  @override
  Widget build(BuildContext context) {
    return BlocLoadingScreen<ReportOrderBloc>(
      busyStates: const [ReportOrderDetailLoading],
      child: BlocBuilder<ReportOrderBloc, ReportOrderState>(
          buildWhen: (prevState, currState) {
        if (currState is ReportOrderDetailLoadSuccess) {
          return true;
        }
        return false;
      }, builder: (context, state) {
        if (state is ReportOrderDetailLoadSuccess) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 8,
                ),
                _buildGeneral(state),
                _buildListInvoice(state),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      }),
    );
  }

  Widget _buildGeneral(ReportOrderDetailLoadSuccess state) {
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
              ItemReportGeneral(
                color: const Color(0xff4eaaff),
                icon: const SvgIcon(
                  SvgIcon.cart,
                ),

                /// Bán hàng
                title: S.current.reportOrder_Sell,
                amount: vietnameseCurrencyFormat(state
                        .sumReportOrderDetail.sumAmountBeforeDiscountFastOrder +
                    state
                        .sumReportOrderDetail.sumAmountBeforeDiscountPostOrder),
                amountPosOrder:
                    state.sumReportOrderDetail.sumAmountBeforeDiscountPostOrder,
                amountFastSaleOrder:
                    state.sumReportOrderDetail.sumAmountBeforeDiscountFastOrder,
                isOverView: false,
                textColor: const Color(0xFF7AC461),
              ),
              ItemReportGeneral(
                // color: const Color(0xff4eaaff),
                color: const Color(0xffFC7F47),
                icon: const Icon(
                  TPosIcons.tag,
                  color: Colors.white,
                ),

                /// Khuyến mãi + Chiết khấu
                title: S.current.reportOrder_promotionDiscount,
                amount: vietnameseCurrencyFormat(
                    state.sumReportOrderDetail.sumDecreateAmountFastOrder +
                        state.sumReportOrderDetail.sumDiscountAmountFastOrder +
                        state.sumReportOrderDetail.sumDecreateAmountPostOrder +
                        state.sumReportOrderDetail.sumDiscountAmountPostOrder),
                amountPosOrder: state.sumReportOrderDetail.sumPaidtSaleOrder,
                amountFastSaleOrder: state.sumReportGeneral.totalKM +
                    state.sumReportGeneral.totalCk,
                isOverView: false,
                textColor: const Color(0xff4eaaff),
              ),
              ItemReportGeneral(
                color: const Color(0xFF7AC461),
                icon: const SvgIcon(
                  SvgIcon.saveMoney,
                  size: 15,
                ),

                /// Tổng tiền
                title: S.current.totalAmount,
                amount: vietnameseCurrencyFormat(
                    state.sumReportOrderDetail.sumAmountFastOrder +
                        state.sumReportOrderDetail.sumAmountPostOrder),
                amountPosOrder: state.sumReportOrderDetail.sumAmountPostOrder,
                amountFastSaleOrder:
                    state.sumReportOrderDetail.sumAmountFastOrder,
                isOverView: false,
                textColor: const Color(0xffFC7F47),
              ),
              ItemReportGeneral(
                color: const Color(0xFF929DAA),
                icon: const Icon(
                  TPosIcons.revenue_fill,
                  color: Colors.white,
                ),

                /// Nợ
                title: S.current.reportOrder_Debt,
                amount: vietnameseCurrencyFormat(
                    state.sumReportOrderDetail.sumPaidFastOrder),
                amountPosOrder: state.sumReportOrderDetail.sumPaidPostOrder,
                amountFastSaleOrder:
                    state.sumReportOrderDetail.sumPaidFastOrder,
                isOverView: false,
                textColor: const Color(0xFF2C333A),
              ),
            ],
          ),
        ),
        Positioned(
          top: 2,
          left: 0,
          right: 0,
          child: BlocBuilder<FilterBloc, FilterState>(
              buildWhen: (prevState, curState) {
                if (curState is FilterLoadSuccess && curState.isConfirm) {
                  return true;
                }
                return false;
              },
              cubit: widget.filterBloc,
              builder: (context, state) {
                if (state is FilterLoadSuccess) {
                  return Center(
                      child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                              color: const Color(0xFfEBEDEF),
                              borderRadius: BorderRadius.circular(12)),
                          child: FilterDate(
                            state: state,
                            onChangeFilter: widget.onChangeFilter,
                          )));
                }
                return const SizedBox();
              }),
        )
      ],
    );
  }

  Widget _buildListInvoice(ReportOrderDetailLoadSuccess state) {
    return InkWell(
      onTap: () {
        widget.onUpdate();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ReportOrderDetailInvoiceListPage(
                      reportOrderDetails: state.reportOrderDetails,
                      bloc: widget.bloc,
                      filterBloc: widget.filterBloc,
                      sumReportGeneral: state.sumReportGeneral,
                      sumReportOrderDetail: state.sumReportOrderDetail,
                      filter: widget.filter,
                      countInvoices: state.countInvoies,
                      onChangeFilter: widget.onChangeFilter,
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

                /// Danh sách hóa đơn
                child: Text(S.current.reportOrder_Invoices,
                    style: const TextStyle(
                        color: Color(0xFF2C333A), fontSize: 16))),
            Container(
              margin: const EdgeInsets.only(right: 6),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFF28A745)),
              child: Center(
                child: Text(
                  state.reportOrderDetails != null
                      ? state.countInvoies.toString()
                      : "0",
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
