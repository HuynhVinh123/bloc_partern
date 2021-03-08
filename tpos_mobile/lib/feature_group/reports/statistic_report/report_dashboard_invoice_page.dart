import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/empty_data_page.dart';
import 'package:tpos_mobile/feature_group/reports/statistic_report/bloc/report_dashboard_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/statistic_report/bloc/report_dashboard_event.dart';
import 'package:tpos_mobile/feature_group/reports/statistic_report/bloc/report_dashboard_state.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/helpers/svg_icon.dart';
import 'package:tpos_mobile/src/tpos_apis/models/DashboardReport.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class ReportDashboardInvoicePage extends StatefulWidget {
  const ReportDashboardInvoicePage({this.data, this.isRefund = false});
  final DashboardReportDataOverviewOption data;
  final bool isRefund;

  @override
  _ReportDashboardInvoicePageState createState() =>
      _ReportDashboardInvoicePageState();
}

class _ReportDashboardInvoicePageState
    extends State<ReportDashboardInvoicePage> {
  final _limit = 100;
  int _skip = 0;

  ReportDashboardBloc bloc = ReportDashboardBloc();

  @override
  void initState() {
    super.initState();
    bloc.add(OrderFinancialLoaded(
        limit: _limit,
        skip: _skip,
        data: widget.data,
        isRefund: widget.isRefund));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEDEF),
      appBar: _buildAppBar(),
      body: BlocUiProvider<ReportDashboardBloc>(
        bloc: bloc,
        listen: (state) {
          if (state is OrderFinancialLoadFailure) {
            showError(
                title: state.title, message: state.content, context: context);
          }
        },
        child: BlocLoadingScreen<ReportDashboardBloc>(
          busyStates: const [OrderFinancialLoading],
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _buildFilter(),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilter() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      height: 40,
      child: Row(
        children: <Widget>[
          const Icon(Icons.date_range, size: 18, color: Color(0xFF6B7280)),
          const SizedBox(
            width: 6,
          ),
          Text(
            widget.data.text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF6B7280)),
          ),
          const SizedBox(
            width: 6,
          ),
          const Icon(Icons.arrow_drop_down, color: Color(0xFF6B7280))
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(S.current.reportOrder_Invoices),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<ReportDashboardBloc, ReportDashboardState>(
        buildWhen: (prevState, currState) {
      if (currState is OrderFinancialLoadSuccess ||
          currState is OrderFinancialLoadFailure) {
        return true;
      }
      return false;
    }, builder: (context, state) {
      if (state is OrderFinancialLoadSuccess) {
        if (state.invoices.isEmpty) {
          return Container(
              width: MediaQuery.of(context).size.width, child: EmptyDataPage());
        } else {
          return ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemCount: state.invoices.length,
              itemBuilder: (context, index) =>
                  _buildItem(state.invoices[index], index, state.invoices));
        }
      } else if (state is OrderFinancialLoadFailure) {
        return Container(
            width: MediaQuery.of(context).size.width, child: EmptyDataPage());
      }
      return const SizedBox();
    });
  }

  Widget _buildItem(
      OrderFinancial item, int index, List<OrderFinancial> items) {
    return item.orderCode == "temp"
        ? _buildButtonLoadMore(index, items)
        : InkWell(
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
                        item.orderCode ?? "",
                        style: const TextStyle(
                            color: Color(0xFF28A745),
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Text(
                      vietnameseCurrencyFormat(widget.isRefund
                          ? item.refundSale ?? 0
                          : item.amountTotalByOrder ?? 0),
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            item.userName ?? "",
                            style: const TextStyle(
                                color: Color(0xFF929DAA), fontSize: 17),
                          ),
                        ),
                        const Text("  |  "),
                        Text(
                          item.date != null
                              ? DateFormat("dd/MM/yyyy HH:ss").format(item.date)
                              : "",
                          style: const TextStyle(color: Color(0xFF929DAA)),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.person,
                          size: 17,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Flexible(
                          child: Text(
                            item.customerName ?? "",
                            style: const TextStyle(color: Color(0xFF2C333A)),
                          ),
                        ),
                        const Text("  |  "),
                        const SvgIcon(SvgIcon.count),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                            widget.isRefund
                                ? item.quantityRefund.floor().toString()
                                : item.quantitySale.floor().toString(),
                            style: const TextStyle(color: Color(0xFF2C333A))),
                      ],
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ),
          );
  }

  Widget _buildButtonLoadMore(int index, List<OrderFinancial> items) {
    return BlocBuilder<ReportDashboardBloc, ReportDashboardState>(
        builder: (context, state) {
      if (state is OrderFinancialLoadMoreLoading) {
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
                bloc.add(OrderFinancialLoadMoreLoaded(
                    skip: _skip,
                    limit: _limit,
                    invoices: items,
                    data: widget.data,
                    isRefund: widget.isRefund));
              },
              color: Colors.blueGrey,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // ignore: prefer_const_literals_to_create_immutables
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
