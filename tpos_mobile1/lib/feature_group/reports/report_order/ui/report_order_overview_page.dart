import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/filter/filter_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/filter/filter_state.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/empty_data_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/report_order_detail_report_customer_type_sale.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/report_order_page.dart';

import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import '../report_order_bloc.dart';
import '../report_order_event.dart';
import '../report_order_state.dart';

class ReportOrderOverViewPage extends StatefulWidget {
  const ReportOrderOverViewPage({this.bloc, this.filterBloc, this.scaffoldKey});
  final ReportOrderBloc bloc;
  final FilterBloc filterBloc;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  _ReportOrderOverViewPageState createState() =>
      _ReportOrderOverViewPageState();
}

class _ReportOrderOverViewPageState extends State<ReportOrderOverViewPage> {
  final int _limit = 20;
  int _skip = 0;

  @override
  void initState() {
    super.initState();
    widget.bloc.add(ReportSaleGeneralLoaded(limit: _limit, skip: _skip));
  }

  @override
  Widget build(BuildContext context) {
    return BlocLoadingScreen<ReportOrderBloc>(
      busyStates: const [ReportSaleGeneralLoading],
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    return BlocBuilder<ReportOrderBloc, ReportOrderState>(
        buildWhen: (prevState, currState) {
      if (currState is ReportSaleGeneralLoadSuccess) {
        return true;
      }
      return false;
    }, builder: (context, state) {
      if (state is ReportSaleGeneralLoadSuccess) {
        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 8,
              ),
              Stack(
                children: <Widget>[_buildOverView(state), _buildFilterDay()],
              ),
              _buildListItemReport(state.reportOrders, state.sumReportGeneral),
            ],
          ),
        );
      }
      return const SizedBox();
    });
  }

  Widget _buildOverView(ReportSaleGeneralLoadSuccess state) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      margin: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ItemReportGeneral(
            color: const Color(0xFF7AC461),
            icon: SvgPicture.asset(
              "assets/icon/ic_invoice.svg",
              alignment: Alignment.center,
            ),

            /// Số lượng HĐ
            title: S.current.reportOrder_totalInvoices,
            amount: state.sumReportGeneral.totalOrder.toString() ?? 0,
            textColor: const Color(0xFF7AC461),
          ),
          ItemReportGeneral(
            color: const Color(0xff4eaaff),
            icon: SvgPicture.asset(
              "assets/icon/ic_cart.svg",
              alignment: Alignment.center,
            ),

            /// Bán hàng
            title: S.current.reportOrder_Sell,
            amount:
                vietnameseCurrencyFormat(state.sumReportGeneral.totalSale) ?? 0,
            textColor: const Color(0xff4eaaff),
          ),
          ItemReportGeneral(
            color: const Color(0xffFC7F47),
            icon: SvgPicture.asset(
              "assets/icon/ic_tag.svg",
              alignment: Alignment.center,
            ),

            /// Khuyến mãi + Chiết khấu
            title: S.current.reportOrder_promotionDiscount,
            amount:
                vietnameseCurrencyFormat(state.sumReportGeneral.totalCk) ?? 0,
            textColor: const Color(0xffFC7F47),
          ),
          ItemReportGeneral(
            color: const Color(0xFF929DAA),
            icon: SvgPicture.asset(
              "assets/icon/ic_save_money.svg",
              alignment: Alignment.center,
            ),

            /// Tổng tiền
            title: S.current.reportOrder_amountTotal,
            amount:
                vietnameseCurrencyFormat(state.sumReportGeneral.totalAmount) ??
                    0,
            textColor: const Color(0xFF2C333A),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDay() {
    return Positioned(
      top: 2,
      left: 0,
      right: 0,
      child: InkWell(
        onTap: () {
          widget.scaffoldKey.currentState.openEndDrawer();
        },
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(Icons.date_range,
                          size: 17, color: Color(0xFF6B7280)),
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
                      const Icon(Icons.arrow_drop_down,
                          color: const Color(0xFF6B7280))
                    ],
                  ),
                ));
              }
              return const SizedBox();
            }),
      ),
    );
  }

  Widget _buildListItemReport(
      List<ReportOrder> reportOrders, SumReportGeneral sumReportGeneral) {
    return reportOrders.isEmpty
        ? SizedBox(height: 150, child: EmptyDataPage())
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reportOrders.length,
            itemBuilder: (context, index) {
              return _buildItemReport(
                  reportOrders[index], index, reportOrders, sumReportGeneral);
            });
  }

  Widget _buildItemReport(ReportOrder item, int index,
      List<ReportOrder> reportOrders, SumReportGeneral sumReportGeneral) {
    return item.countOrder == -1
        ? _buildButtonLoadMore(index, reportOrders, sumReportGeneral)
        : InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ReporOrderDetaiReportCustomerTypeSale(
                              bloc: widget.bloc, date: item.date)));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              margin: const EdgeInsets.only(right: 12, left: 12, bottom: 10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(6)),
              child: ListTile(
                title: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        DateFormat("dd/MM/yyyy").format(item.date),
                        style: const TextStyle(
                            color: Color(0xFF28A745),
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Text(
                      vietnameseCurrencyFormat(item.totalAmount),
                      style: const TextStyle(color: Color(0xFFF25D27)),
                    )
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 8,
                    ),
                    Wrap(
                      children: <Widget>[
                        SvgPicture.asset(
                          "assets/icon/ic_revenue.svg",
                          alignment: Alignment.center,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          item.countOrder.floor().toString() ?? "0",
                          style: const TextStyle(color: Color(0xFF2C333A)),
                        ),
                        const Text(" |  "),
                        SvgPicture.asset(
                          "assets/icon/ic_count.svg",
                          alignment: Alignment.center,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(vietnameseCurrencyFormat(item.totalAmountBeforeCK),
                            style: const TextStyle(color: Color(0xFF2C333A))),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: <Widget>[
                        /// Chiết khấu
                        Text(
                          "${S.current.reportOrder_Discount}: ",
                          style: const TextStyle(color: Color(0xFF929DAA)),
                        ),
                        Text(vietnameseCurrencyFormat(item.totalCK),
                            style: const TextStyle(color: Color(0xFF2C333A))),
                        const Text(" | "),
                        const SizedBox(
                          width: 6,
                        ),

                        /// Khuyến mãi
                        Text("${S.current.reportOrder_Promotion}: ",
                            style: const TextStyle(color: Color(0xFF929DAA))),
                        Expanded(
                          child: Text(
                            vietnameseCurrencyFormat(item.totalKM),
                            style: const TextStyle(color: Color(0xFF2C333A)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
  }

  Widget _buildButtonLoadMore(int index, List<ReportOrder> reportOrders,
      SumReportGeneral sumReportGeneral) {
    return BlocBuilder<ReportOrderBloc, ReportOrderState>(
        builder: (context, state) {
      if (state is ReportSaleGeneralLoadMoreLoading) {
        return Center(
          child: SpinKitCircle(
            color: Theme.of(context).primaryColor,
          ),
        );
      }
      return Center(
        child: Container(
            margin:
                const EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 8),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(3)),
            height: 45,
            child: FlatButton(
              onPressed: () {
                _skip += _limit;
                widget.bloc.add(ReportSaleGeneralLoadMoreLoaded(
                    limit: _limit,
                    skip: _skip,
                    sumReportGeneral: sumReportGeneral,
                    reportOrders: reportOrders));
              },
              color: Colors.blueGrey,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // ignore: prefer_const_literals_to_create_immutables
                    /// Tải thêm
                    Text(S.current.loadMore,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16)),
                    const SizedBox(
                      width: 12,
                    ),
                    const Icon(
                      Icons.save_alt,
                      color: Colors.white,
                      size: 18,
                    )
                  ],
                ),
              ),
            )),
      );
    });
  }
}
