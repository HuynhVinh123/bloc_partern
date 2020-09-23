import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/filter_report_delivery/filter_report_delivery_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/filter_report_delivery/filter_report_delivery_state.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/report_delivery_fast_sale_order_bloc.dart';

import '../blocs/report_delivery_fast_sale_order_state.dart';

class ReportDeliveryFastSaleOrderInvoiceListPage extends StatefulWidget {
  const ReportDeliveryFastSaleOrderInvoiceListPage(
      {this.bloc, this.filterBloc,this.reportDeliveryFastSaleOrder,this.sumDeliveryReportFastSaleOrder});

  final ReportDeliveryFastSaleOrderBloc bloc;
  final FilterReportDeliveryBloc filterBloc;
  final ReportDeliveryFastSaleOrder reportDeliveryFastSaleOrder;
  final SumDeliveryReportFastSaleOrder sumDeliveryReportFastSaleOrder;
  @override
  _ReportDeliveryFastSaleOrderInvoiceListPageState createState() =>
      _ReportDeliveryFastSaleOrderInvoiceListPageState();
}

class _ReportDeliveryFastSaleOrderInvoiceListPageState
    extends State<ReportDeliveryFastSaleOrderInvoiceListPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                _buildFilter(),
                Expanded(child: _buildBody()),
              ],
            ),
          ],
        ));
  }

  Widget _buildAppBar() {
    return AppBar(
      title: const Text("Danh sách hóa đơn"),
      actions: <Widget>[

      ],
    );
  }

  Widget _buildBody() {
    return BlocBuilder<ReportDeliveryFastSaleOrderBloc,
        ReportDeliveryFastSaleOrderState>(
      cubit: widget.bloc,
        buildWhen: (prevState, currState) {
          if (currState is ReportDeliveryFastSaleOrderLoadSuccess) {
            return true;
          }
          return false;
        },
      builder: (context, state) {
        if(state is ReportDeliveryFastSaleOrderLoadSuccess){
          return ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemCount: state.reportDeliveryFastSaleOrder.data.length ?? 0,
              itemBuilder: (context, index) => _buildItem(state.reportDeliveryFastSaleOrder.data[index]));
        }
        return const SizedBox();
      }
    );
  }

  Widget _buildItem(ReportDeliveryFastSaleOrderDetail item) {
    return InkWell(
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
                  item.partnerDisplayName ?? "",
                  style: const TextStyle(
                      color: Color(0xFF28A745),
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                vietnameseCurrencyFormat(item.amountTotal ?? 0),
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
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                     item.number ?? "",
                      style: const TextStyle(
                          color: Color(0xFF929DAA), fontSize: 16),
                    ),
                  ),
                  const Text("  |  "),
                  Text(
                    DateFormat("dd/MM/yyyy").format(DateTime.now()),
                    style: const TextStyle(color: Color(0xFF929DAA)),
                  )
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: <Widget>[
                  SvgPicture.asset(
                    "assets/icon/ic_count.svg",
                    alignment: Alignment.center,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  const Flexible(
                    child: Text(
                      "<Chưa có>",
                      style: const TextStyle(color: Color(0xFF2C333A)),
                    ),
                  ),
                  const Text("  |  "),
                  Icon(
                    FontAwesomeIcons.truck,
                    color: Color(0xFF929daa),
                    size: 13,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Text(vietnameseCurrencyFormat(item.customerDeliveryPrice ?? 0),
                        style: const TextStyle(color: const Color(0xFF2C333A))),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: <Widget>[
                  Image.asset(
                    "images/giaohangnhanh_logo.png",
                    alignment: Alignment.center,
                    width: 15,
                    height: 35,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  const Flexible(child: Text("EN347940653VN")),
                  const Text(" / "),
                  const Text("Vào điều tin")
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: const <Widget>[
                  Text("Đối soát giao hàng: "),
                  Text("Đã thu tiền",
                      style: TextStyle(color: Color(0xFF28A745)))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilter() {
    return BlocBuilder<FilterReportDeliveryBloc, FilterReportDeliveryState>(
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
            return InkWell(
              onTap: () {
                scaffoldKey.currentState.openEndDrawer();
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
}
