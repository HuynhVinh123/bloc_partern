import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/filter/filter_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/filter/filter_state.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/empty_data_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/invoice_report_customer_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/report_order_page.dart';
import 'package:tpos_mobile/helpers/svg_icon.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import '../report_order_bloc.dart';
import '../report_order_event.dart';
import '../report_order_state.dart';

class ReportOrderPartnerPage extends StatefulWidget {
  const ReportOrderPartnerPage(
      {this.bloc, this.filterBloc, this.scaffoldKey, this.onChangeFilter});
  final ReportOrderBloc bloc;
  final FilterBloc filterBloc;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function onChangeFilter;
  @override
  _ReportOrderPartnerPageState createState() => _ReportOrderPartnerPageState();
}

class _ReportOrderPartnerPageState extends State<ReportOrderPartnerPage> {
  final int _limit = 20;
  int _skip = 0;
  DateTime filterFromDate;
  DateTime filterToDate;
  AppFilterDateModel filterDateRange;

  @override
  void initState() {
    super.initState();
    widget.bloc.add(ReportOrderPartnerLoaded(skip: _skip, limit: _limit));
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
    return BlocBuilder<FilterBloc, FilterState>(
        buildWhen: (prevState, curState) {
          if (curState is FilterLoadSuccess && curState.isConfirm) {
            return true;
          }
          return false;
        },
        cubit: widget.filterBloc,
        builder: (context, state) {
          if (state is FilterLoadSuccess) {
            filterFromDate = state.filterFromDate;
            filterToDate = state.filterToDate;
            filterDateRange = state.filterDateRange;

            return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                height: 40,
                alignment: Alignment.centerLeft,
                child: FilterDate(
                  state: state,
                  onChangeFilter: widget.onChangeFilter,
                ));
          }
          return const SizedBox();
        });
  }

  Widget _buildPartnerList() {
    return BlocLoadingScreen<ReportOrderBloc>(
      busyStates: const [ReportOrderPartnerLoading],
      child: BlocBuilder<ReportOrderBloc, ReportOrderState>(
          buildWhen: (prevState, currState) {
        if (currState is ReportOrderPartnerLoadSuccess) {
          return true;
        }
        return false;
      }, builder: (context, state) {
        if (state is ReportOrderPartnerLoadSuccess) {
          return state.partnerSaleReports.isEmpty
              ? EmptyDataPage()
              : ListView.builder(
                  itemCount: state.partnerSaleReports.length,
                  itemBuilder: (context, index) => _buildItem(
                      state.partnerSaleReports[index],
                      index,
                      state.partnerSaleReports));
        }
        return const SizedBox();
      }),
    );
  }

  Widget _buildItem(PartnerSaleReport item, int index,
      List<PartnerSaleReport> partnerReports) {
    return item.staffName == "partnerTemp"
        ? _buildButtonLoadMore(index, partnerReports)
        : Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            margin: const EdgeInsets.only(right: 12, left: 12, bottom: 10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(6)),
            child: ListTile(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return InvoiceReportCustomerPage(
                      bloc: widget.bloc,
                      dateFrom: filterFromDate,
                      dateTo: filterToDate,
                      filterDateRange: filterDateRange,
                      partnerId: item.customerId,
                    );
                  }),
                );
              },
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
                    style: const TextStyle(
                        color: Color(0xFF6B7280), fontWeight: FontWeight.bold),
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
                      const SvgIcon(
                        SvgIcon.revenue,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        item.countOrder.floor().toString() ?? "0",
                        style: const TextStyle(color: Color(0xFF2C333A)),
                      ),
                      const Text("  |  "),
                      const SvgIcon(
                        SvgIcon.count,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(vietnameseCurrencyFormat(item.totalAmountBeforeCK),
                          style: TextStyle(
                              color: item.totalAmountBeforeCK >= 0
                                  ? const Color(0xFF2C333A)
                                  : const Color(0xFFFF3636))),
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
          );
  }

  Widget _buildButtonLoadMore(
      int index, List<PartnerSaleReport> partnerReports) {
    return BlocBuilder<ReportOrderBloc, ReportOrderState>(
        builder: (context, state) {
      if (state is ReportOrderPartnerLoadMoreLoading) {
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
                widget.bloc.add(ReportOrderPartnerLoadMoreLoaded(
                    limit: _limit,
                    skip: _skip,
                    partnerSaleReports: partnerReports));
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
