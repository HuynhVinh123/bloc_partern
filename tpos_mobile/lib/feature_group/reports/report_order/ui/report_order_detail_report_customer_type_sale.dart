import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/feature_group/fast_sale_order/ui/fast_sale_order_info_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/filter/filter_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/filter/filter_state.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/empty_data_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/sale_online_edit_order_page.dart';
import 'package:tpos_mobile/helpers/svg_icon.dart';
import 'package:tpos_mobile/resources/tpos_mobile_icons.dart';

import 'package:tpos_mobile/widgets/loading_indicator.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import '../report_order_bloc.dart';
import '../report_order_event.dart';
import '../report_order_state.dart';

class ReporOrderDetaiReportCustomerTypeSale extends StatefulWidget {
  const ReporOrderDetaiReportCustomerTypeSale({this.bloc, this.date});
  final ReportOrderBloc bloc;
  final DateTime date;
  @override
  _ReporOrderDetaiReportCustomerTypeSaleState createState() =>
      _ReporOrderDetaiReportCustomerTypeSaleState();
}

class _ReporOrderDetaiReportCustomerTypeSaleState
    extends State<ReporOrderDetaiReportCustomerTypeSale> {
  final _limit = 100;
  int _skip = 0;

  @override
  void initState() {
    super.initState();
    widget.bloc.add(DetailReportCustomerTypeSaleLoaded(
        skip: _skip, limit: _limit, date: widget.date));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEDEF),
      appBar: AppBar(
        /// Danh sách hóa đơn
        title: Text(S.current.reportOrder_Invoices),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            _buildFilter(),
            Expanded(child: _buildList()),
          ],
        ),
        BlocBuilder<ReportOrderBloc, ReportOrderState>(
            cubit: widget.bloc,
            builder: (context, state) {
              if (state is DetailReportCustomerTypeSaleLoading) {
                return LoadingIndicator();
              }
              return const SizedBox();
            })
      ],
    );
  }

  Widget _buildList() {
    return BlocBuilder<ReportOrderBloc, ReportOrderState>(
        buildWhen: (prevState, currState) {
          if (currState is DetailReportCustomerTypeSaleLoadSuccess) {
            return true;
          }
          return false;
        },
        cubit: widget.bloc,
        builder: (context, state) {
          if (state is DetailReportCustomerTypeSaleLoadSuccess) {
            return state.detailReportCustomerTypeSales.isEmpty
                ? EmptyDataPage()
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    itemCount: state.detailReportCustomerTypeSales.length,
                    itemBuilder: (context, index) => _buildItem(
                        state.detailReportCustomerTypeSales[index],
                        index,
                        state.detailReportCustomerTypeSales));
          }
          return const SizedBox();
        });
  }

  Widget _buildItem(DetailReportCustomerTypeSale item, int index,
      List<DetailReportCustomerTypeSale> items) {
    return item.name == "detailTemp"
        ? _buildButtonLoadMore(index, items)
        : Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            margin: const EdgeInsets.only(right: 12, left: 12, bottom: 10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(6)),
            child: ListTile(
              onTap: () async {
                final FastSaleOrder order = FastSaleOrder(id: item.id);
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return FastSaleOrderInfoPage(order: order);
                  }),
                );
              },
              title: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      item.name ?? "",
                      style: const TextStyle(
                          color: Color(0xFF28A745),
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Text(
                    vietnameseCurrencyFormat(item.amountTotal),
                    style: const TextStyle(color: Color(0xFF6B7280)),
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
                        item.dateOrder != null
                            ? DateFormat("dd/MM/yyyy HH:ss")
                                .format(item.dateOrder.toLocal())
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
                          item.partnerDisplayName ?? "",
                          style: const TextStyle(color: Color(0xFF2C333A)),
                        ),
                      ),
                      const Text("  |  "),
                      const SvgIcon(
                        SvgIcon.count,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text("${S.current.reportOrder_Debt}: "),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(vietnameseCurrencyFormat(item.residual),
                          style: TextStyle(
                              color: item.residual == 0
                                  ? const Color(0xFF2C333A)
                                  : const Color(0xFFFF3636))),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.companyName ?? "",
                    style: const TextStyle(color: Color(0xFF929DAA)),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: <Widget>[
                      if (item.state != "done")
                        const Icon(
                          TPosIcons.pos_session_fill,
                          size: 15,
                        )
                      else
                        const SvgIcon(
                          SvgIcon.bag,
                          size: 15,
                        ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        item.showState ?? "",
                        style: const TextStyle(color: Color(0xFF28A745)),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
  }

  Widget _buildButtonLoadMore(
      int index, List<DetailReportCustomerTypeSale> items) {
    return BlocBuilder<ReportOrderBloc, ReportOrderState>(
        cubit: widget.bloc,
        builder: (context, state) {
          if (state is DetailReportCustomerTypeSaleLoadMoreLoading) {
            return Center(
              child: SpinKitCircle(
                color: Theme.of(context).primaryColor,
              ),
            );
          }
          return Center(
            child: Container(
                margin: const EdgeInsets.only(
                    top: 12, left: 12, right: 12, bottom: 8),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(3)),
                height: 45,
                child: FlatButton(
                  onPressed: () {
                    _skip += _limit;
                    widget.bloc.add(DetailReportCustomerTypeSaleLoadMoreLoaded(
                        skip: _skip,
                        limit: _limit,
                        date: widget.date,
                        detailReportCustomerTypeSales: items));
                  },
                  color: Colors.blueGrey,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: <Widget>[
                        /// Tải thêm
                        Text(S.current.loadMore,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16)),
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

  Widget _buildFilter() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      height: 40,
      child: Row(
        children: <Widget>[
          const Icon(Icons.date_range,
              size: 18, color: const Color(0xFF6B7280)),
          const SizedBox(
            width: 6,
          ),
          Text(
            DateFormat("dd/MM/yyyy").format(widget.date),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF6B7280)),
          ),
          const SizedBox(
            width: 6,
          ),
          Icon(Icons.arrow_drop_down, color: const Color(0xFF6B7280))
        ],
      ),
    );
  }
}
