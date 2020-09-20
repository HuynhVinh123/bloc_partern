import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/report_order_bloc.dart';

import 'package:tpos_mobile/feature_group/sale_online/blocs/report_order_event.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/report_order_state.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/report_order_page.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';

class ReportOrderDetailPage extends StatefulWidget {
  const ReportOrderDetailPage({this.bloc});
  final ReportOrderBloc bloc;
  @override
  _ReportOrderDetailState createState() => _ReportOrderDetailState();
}

class _ReportOrderDetailState extends State<ReportOrderDetailPage> {
  @override
  void initState() {
    super.initState();
    widget.bloc.add(ReportOrderDetailLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return BlocLoadingScreen<ReportOrderBloc>(
      busyStates: const [ReportOrderLoading],
      child: BlocBuilder<ReportOrderBloc, ReportOrderState>(
          builder: (context, state) {
        if (state is ReportOrderDetailLoadSuccess) {
          return Column(
            children: <Widget>[
              const SizedBox(
                height: 8,
              ),
              _buildGeneral(state),
              _buildListInvoice()
            ],
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
                color: const Color(0xFF7AC461),
                icon: SvgPicture.asset(
                  "assets/icon/ic_invoice.svg",
                  alignment: Alignment.center,
                ),
                title: "Số lượng HĐ",
                amount: "22",
                isOverView: false,textColor:  const Color(0xFF7AC461),
              ),
              ItemReportGeneral(
                color: const Color(0xff4eaaff),
                icon: SvgPicture.asset(
                  "assets/icon/ic_cart.svg",
                  alignment: Alignment.center,
                ),
                title: "Bán hàng",
                amount: "22",
                isOverView: false,textColor: const Color(0xff4eaaff),
              ),
              ItemReportGeneral(
                color: const Color(0xffFC7F47),
                icon: SvgPicture.asset(
                  "assets/icon/ic_tag.svg",
                  alignment: Alignment.center,
                ),
                title: "Khuyến mãi + Chiết khấu",
                amount: "22",
                isOverView: false,textColor: const Color(0xffFC7F47),
              ),
              ItemReportGeneral(
                color: const Color(0xFF929DAA),
                icon: SvgPicture.asset(
                  "assets/icon/ic_save_money.svg",
                  alignment: Alignment.center,
                ),
                title: "Tổng tiền",
                amount: "22",
                isOverView: false,textColor: const Color(0xFF2C333A),
              ),
            ],
          ),
        ),
        Positioned(
          top: 2,
          left: 0,
          right: 0,
          child: Center(
              child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
                color: const Color(0xFfEBEDEF),
                borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                Icon(
                  Icons.date_range,
                  size: 17,color: Color(0xFF6B7280)
                ),
                 SizedBox(
                  width: 6,
                ),
                 Text(
                  "7 ngày gần nhất",
                  textAlign: TextAlign.center,style: TextStyle(color: Color(0xFF6B7280)),
                ),
                Icon(Icons.arrow_drop_down,color: Color(0xFF6B7280))
              ],
            ),
          )),
        )
      ],
    );
  }

  Widget _buildListInvoice() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: <Widget>[
          const Expanded(
              child: Text(
            "Danh sách hóa đơn",
            style: TextStyle(color: Color(0xFF2C333A), fontSize: 16),
          )),
          Container(
            margin: const EdgeInsets.only(right: 6),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFF28A745)),
            child: const Center(
              child: Text(
                "4",
                style: TextStyle(color: Colors.white),
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
    );
  }
}
