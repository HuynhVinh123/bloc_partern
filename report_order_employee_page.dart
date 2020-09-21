import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/filter/filter_bloc.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/filter/filter_state.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/report_order_bloc.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/report_order_event.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/report_order_state.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';

class ReportOrderEmployeePage extends StatefulWidget {
  const ReportOrderEmployeePage({this.bloc, this.filterBloc, this.scaffoldKey});
  final ReportOrderBloc bloc;
  final FilterBloc filterBloc;
  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  _ReportOrderEmployeePageState createState() =>
      _ReportOrderEmployeePageState();
}

class _ReportOrderEmployeePageState extends State<ReportOrderEmployeePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.bloc.add(ReportOrderStaffLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildFilter(),
        Expanded(
          child: _buildEmployeeList(),
        )
      ],
    );
  }

  Widget _buildFilter() {
    return BlocBuilder<FilterBloc, FilterState>(
        cubit: widget.filterBloc,
        builder: (context, state) {
          if (state is FilterLoadSuccess) {
            return InkWell(
              onTap: () {
                widget.scaffoldKey.currentState.openEndDrawer();
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                height: 40,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.date_range,
                        size: 18, color: const Color(0xFF6B7280)),
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
                    const SizedBox(
                      width: 6,
                    ),
                    Icon(Icons.arrow_drop_down, color: const Color(0xFF6B7280))
                  ],
                ),
              ),
            );
          }
          return const SizedBox();
        });
  }

  Widget _buildEmployeeList() {
    return BlocLoadingScreen<ReportOrderBloc>(
      busyStates: const [ReportOrderStaffLoading],
      child: BlocBuilder<ReportOrderBloc, ReportOrderState>(
          buildWhen: (prevState, currState) {
        if (currState is ReportOrderStaffLoadSuccess) {
          return true;
        }
        return false;
      }, builder: (context, state) {
        if (state is ReportOrderStaffLoadSuccess) {
          return ListView.builder(
              itemCount: state.staffSaleReports.length,
              itemBuilder: (context, index) =>
                  _buildItem(state.staffSaleReports[index]));
        }
        return const SizedBox();
      }),
    );
  }

  Widget _buildItem(PartnerSaleReport item) {
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
                item.staffName ?? "",
                style: TextStyle(
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
                  width: 6,
                ),
                Text(
                  item.countOrder.floor().toString() ?? "0",
                  style: const TextStyle(color: Color(0xFF2C333A)),
                ),
                const Text("  |  "),
                SvgPicture.asset(
                  "assets/icon/ic_count.svg",
                  alignment: Alignment.center,
                ),
                const SizedBox(
                  width: 6,
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
