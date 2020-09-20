import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/report_order_bloc.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/report_order_event.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/report_order_state.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';

class ReportOrderPartnerPage extends StatefulWidget {
  const ReportOrderPartnerPage({this.bloc});
  final ReportOrderBloc bloc;
  @override
  _ReportOrderPartnerPageState createState() => _ReportOrderPartnerPageState();
}

class _ReportOrderPartnerPageState extends State<ReportOrderPartnerPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.bloc.add(ReportOrderPartnerLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildFilter(),
        Expanded(
          child: _buildPartnerList(),
        )
      ],
    );
  }

  Widget _buildFilter() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      height: 40,
      child: Row(
        children:const <Widget>[
           Icon(
            Icons.date_range,
            size: 18,color: Color(0xFF6B7280)
          ),
           SizedBox(
            width: 6,
          ),
           Text("7 ngày gần nhất",style: TextStyle(color: Color(0xFF6B7280)),),
           SizedBox(
            width: 6,
          ),
           Icon(Icons.arrow_drop_down,color:  Color(0xFF6B7280))
        ],
      ),
    );
  }

  Widget _buildPartnerList() {
    return BlocLoadingScreen<ReportOrderBloc>(
      busyStates: const [ReportOrderLoading],
      child: BlocBuilder<ReportOrderBloc, ReportOrderState>(
          builder: (context, state) {
        if (state is ReportOrderPartnerLoadSuccess) {
          return ListView.builder(
              itemCount: state.partnerSaleReports.length,
              itemBuilder: (context, index) =>
                  _buildItem(state.partnerSaleReports[index]));
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
                item.customerName ?? "",
                style: const TextStyle(
                    color: Color(0xFF28A745),
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(
              width: 4,
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
                const Text("  |  "), SvgPicture.asset(
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
