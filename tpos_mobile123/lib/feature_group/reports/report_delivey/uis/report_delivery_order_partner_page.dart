import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/filter_report_delivery/filter_report_delivery_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/report_delivery_order_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/report_delivery_order_event.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/report_delivery_order_state.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/empty_data_page.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import '../blocs/filter_report_delivery/filter_report_delivery_state.dart';

class ReportDeliveryOrderPartnerPage extends StatefulWidget {
  const ReportDeliveryOrderPartnerPage(
      {this.filterBloc, this.scaffoldKey, this.bloc});

  final ReportDeliveryOrderBloc bloc;
  final FilterReportDeliveryBloc filterBloc;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  _ReportDeliveryOrderPartnerPageState createState() =>
      _ReportDeliveryOrderPartnerPageState();
}

class _ReportDeliveryOrderPartnerPageState
    extends State<ReportDeliveryOrderPartnerPage> {
  final int _limit = 50;
  int _skip = 0;

  @override
  void initState() {
    super.initState();
    widget.bloc.add(DeliveryReportCustomerLoaded(skip: _skip, limit: _limit));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            _buildFilter(),
            Expanded(child: _buildBody()),
          ],
        ),
      ],
    );
  }

  Widget _buildBody() {
    return BlocLoadingScreen<ReportDeliveryOrderBloc>(
      busyStates: const [DeliveryReportCustomerLoading],
      child: BlocBuilder<ReportDeliveryOrderBloc, ReportDeliveryOrderState>(
          buildWhen: (prevState, currState) {
        if (currState is DeliveryReportCustomerLoadSuccess) {
          return true;
        }
        return false;
      }, builder: (context, state) {
        if (state is DeliveryReportCustomerLoadSuccess) {
          return state.deliveryReportCustomers.isEmpty ? EmptyDataPage() : ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemCount: state.deliveryReportCustomers.length,
              itemBuilder: (context, index) => _buildItem(
                  state.deliveryReportCustomers[index],
                  state.deliveryReportCustomers,
                  index));
        }
        return const SizedBox();
      }),
    );
  }

  Widget _buildItem(ReportDeliveryCustomer item,
      List<ReportDeliveryCustomer> deliveryReportCustomers, int index) {
    return item.userName == "temp"
        ? _buildButtonLoadMore(index, deliveryReportCustomers)
        : InkWell(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
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
                            "${S.current.phone}: ${item.phone ?? ""}",
                            style: const TextStyle(
                                color: Color(0xFF929DAA), fontSize: 14),
                          ),
                        ),
                        const Text("  |  "),
                        Flexible(
                          child: Text(
                            "FB: ${item.partnerFacebookId ?? ""}",
                            style: const TextStyle(
                                color: Color(0xFF929DAA), fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: <Widget>[
                        SvgPicture.asset(
                          "assets/icon/ic_revenue.svg",
                          alignment: Alignment.center,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Flexible(
                          child: Text(
                            item.totalBill != null
                                ? item.totalBill.toString()
                                : "0",
                            style: const TextStyle(color: Color(0xFF2C333A)),
                          ),
                        ),
                        const Text("  |  "),
                        SvgPicture.asset(
                          "assets/icon/ic_count.svg",
                          alignment: Alignment.center,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Flexible(
                          child: Text(
                            vietnameseCurrencyFormat(item.cashOnDelivery ?? 0),
                            style: const TextStyle(color: Color(0xFF2C333A)),
                          ),
                        ),
                        const Text("  |  "),
                        const Icon(
                          FontAwesomeIcons.truck,
                          color: const Color(0xFF929daa),
                          size: 13,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Text(
                              vietnameseCurrencyFormat(item.deliveryPrice ?? 0),
                              style: const TextStyle(color: Color(0xFF2C333A))),
                        ),
                      ],
                    ),
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
                widget.scaffoldKey.currentState.openEndDrawer();
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                height: 40,
                child: Row(
                  children: <Widget>[
                    const Icon(Icons.date_range,
                        size: 18, color: Color(0xFF6B7280)),
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
                    const Icon(Icons.arrow_drop_down, color: Color(0xFF6B7280))
                  ],
                ),
              ),
            );
          }
          return const SizedBox();
        });
  }

  Widget _buildButtonLoadMore(
      int index, List<ReportDeliveryCustomer> deliveryReportCustomers) {
    return BlocBuilder<ReportDeliveryOrderBloc, ReportDeliveryOrderState>(
        builder: (context, state) {
      if (state is DeliveryReportCustomerLoadMoreLoading) {
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
                widget.bloc.add(DeliveryReportCustomerLoadMoreLoaded(
                    limit: _limit,
                    skip: _skip,
                    deliveryReportCustomers: deliveryReportCustomers));
              },
              color: Colors.blueGrey,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
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
