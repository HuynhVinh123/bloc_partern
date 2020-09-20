import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/report_order_bloc.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/report_order_event.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/report_order_state.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/report_order_page.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';

class ReportOrderOverViewPage extends StatefulWidget {
  const ReportOrderOverViewPage({this.bloc});
  final ReportOrderBloc bloc;

  @override
  _ReportOrderOverViewPageState createState() =>
      _ReportOrderOverViewPageState();
}

class _ReportOrderOverViewPageState extends State<ReportOrderOverViewPage> {
  @override
  void initState() {
    super.initState();
    widget.bloc.add(ReportSaleGeneralLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return BlocLoadingScreen<ReportOrderBloc>(
      busyStates: const [ReportOrderLoading],
      child: BlocBuilder<ReportOrderBloc, ReportOrderState>(
          buildWhen: (prevState, currState) {
        if (currState is ReportSaleGeneralLoadSuccess) {
          return true;
        }
        return false;
      }, builder: (context, state) {
        if (state is ReportSaleGeneralLoadSuccess) {
          return Column(
            children: <Widget>[
              const SizedBox(
                height: 8,
              ),
              Stack(
                children: <Widget>[
                  Container(
                    padding:
                        const EdgeInsets.only(left: 12, right: 12, top: 32),
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
                          title: "Số lượng HĐ",
                          amount:
                              state.sumReportGeneral.totalOrder.toString() ?? 0,
                          textColor: const Color(0xFF7AC461),
                        ),
                        ItemReportGeneral(
                          color: const Color(0xff4eaaff),
                          icon: SvgPicture.asset(
                            "assets/icon/ic_cart.svg",
                            alignment: Alignment.center,
                          ),
                          title: "Bán hàng",
                          amount: vietnameseCurrencyFormat(
                                  state.sumReportGeneral.totalSale) ??
                              0,
                          textColor: const Color(0xff4eaaff),
                        ),
                        ItemReportGeneral(
                          color: const Color(0xffFC7F47),
                          icon: SvgPicture.asset(
                            "assets/icon/ic_tag.svg",
                            alignment: Alignment.center,
                          ),
                          title: "Khuyến mãi + Chiết khấu",
                          amount: vietnameseCurrencyFormat(
                                  state.sumReportGeneral.totalCk) ??
                              0,
                          textColor: const Color(0xffFC7F47),
                        ),
                        ItemReportGeneral(
                          color: const Color(0xFF929DAA),
                          icon: SvgPicture.asset(
                            "assets/icon/ic_save_money.svg",
                            alignment: Alignment.center,
                          ),
                          title: "Tổng tiền",
                          amount: vietnameseCurrencyFormat(
                                  state.sumReportGeneral.totalAmount) ??
                              0,
                          textColor: const Color(0xFF2C333A),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 2,
                    left: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {},
                      child: Center(
                          child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            color: const Color(0xFfEBEDEF),
                            borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const <Widget>[
                            Icon(Icons.date_range,
                                size: 17, color: Color(0xFF6B7280)),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              "7 ngày gần nhất",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Color(0xFF6B7280)),
                            ),
                            Icon(Icons.arrow_drop_down,
                                color: Color(0xFF6B7280))
                          ],
                        ),
                      )),
                    ),
                  )
                ],
              ),
              Expanded(
                child: _buildListItemReport(state.reportOrders),
              )
            ],
          );
        }
        return const SizedBox();
      }),
    );
  }

  Widget _buildListItemReport(List<ReportOrder> reportOrders) {
    return ListView.builder(
        itemCount: reportOrders.length,
        itemBuilder: (context, index) {
          return _buildItemReport(reportOrders[index]);
        });
  }

  Widget _buildItemReport(ReportOrder item) {
    return Container(
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
                    color: const Color(0xFF28A745),
                    fontSize: 17,
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
                const Text(
                  "Chiết khấu: ",
                  style: TextStyle(color: Color(0xFF929DAA)),
                ),
                Text(vietnameseCurrencyFormat(item.totalCK),
                    style: const TextStyle(color: Color(0xFF2C333A))),
                const Text(" | "),
                const SizedBox(
                  width: 6,
                ),
                const Text("Khuyến mãi: ",
                    style: TextStyle(color: Color(0xFF929DAA))),
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
    );
  }
}
