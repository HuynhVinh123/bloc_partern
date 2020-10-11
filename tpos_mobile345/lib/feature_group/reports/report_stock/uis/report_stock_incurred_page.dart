import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/empty_data_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/report_stock_incurred/report_stock_incurred_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/report_stock_incurred/report_stock_incurred_event.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/report_stock_incurred/report_stock_incurred_state.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/stock_filter/stock_filter_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/stock_filter/stock_filter_state.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/uis/report_stock_page.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class ReportStockIncurredPage extends StatefulWidget {
  const ReportStockIncurredPage({this.bloc,this.limit,this.skip,this.filterBloc,this.scaffoldKey});
  final ReportStockIncurredBloc bloc;
  final StockFilterBloc filterBloc ;
  final int limit;
  final int skip;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  _ReportStockIncurredPageState createState() => _ReportStockIncurredPageState();
}

class _ReportStockIncurredPageState extends State<ReportStockIncurredPage> {
  ReportStockIncurredBloc _bloc = ReportStockIncurredBloc();
  StockFilterBloc _filterBloc = StockFilterBloc();
  final int _limit = 20;
  int _skip = 0;

  @override
  void initState() {
    super.initState();
    _bloc= widget.bloc;
    _filterBloc = widget.filterBloc;
    _bloc.add(ReportStockIncurredLoaded(limit: _limit, skip: _skip));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocLoadingScreen<ReportStockIncurredBloc>(
          busyStates: const [ReportStockIncurredLoading],
          child: BlocBuilder<ReportStockIncurredBloc, ReportStockIncurredState>(
              buildWhen: (prevState, currState) {
                if (currState is ReportStockIncurredLoadSuccess) {
                  return true;
                }
                return false;
              },
              builder: (context, state) {
                if (state is ReportStockIncurredLoadSuccess) {
                  return Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 8,
                      ),
                      _buildFilter(),
                      _buildHeader(state.reportStockIncurred),
                      Expanded(child: _buildListItem(state.reportStockIncurred)),
//          _buildListItemReport(state.reportOrders, state.sumReportGeneral),
                    ],
                  );
                }
                return const SizedBox();
              }),

      ),
    );
  }

  Widget _buildFilter() {
    return BlocBuilder<StockFilterBloc, StockFilterState>(
        cubit: _filterBloc,
        builder: (context, state) {
          if (state is StockFilterLoadSuccess) {
            return Row(
              children: [
                Flexible(
                  child: InkWell(
                    onTap: (){
                      widget.scaffoldKey.currentState.openEndDrawer();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children:  <Widget>[
                          const Icon(Icons.date_range, size: 18, color: Color(0xFF6B7280)),
                          const SizedBox(
                            width: 6,
                          ),
                          Flexible(
                            child: Text(
                              state.stockFilter.filterDateRange != null
                                  ? state.stockFilter.filterDateRange.name == "Tùy chỉnh"
                                  ? "${DateFormat("dd/MM/yyyy").format(state.stockFilter.dateFrom)} - ${DateFormat("dd/MM/yyyy").format(state.stockFilter.dateTo)}"
                                  : state.stockFilter.filterDateRange.name
                                  : "Thời gian",
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Color(0xFF6B7280)),
                            ),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          const Icon(Icons.arrow_drop_down, color: Color(0xFF6B7280))
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: InkWell(
                    onTap: () async{
                      widget.scaffoldKey.currentState.openEndDrawer();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      height: 40,
                      child: Row(
                        children:  <Widget>[
                          Flexible(
                            child: Text(
                              state.stockFilter.wareHouseStock?.name ?? "Kho hàng",
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Color(0xFF6B7280)),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down, color: Color(0xFF6B7280))
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: InkWell(
                    onTap: (){
                      widget.scaffoldKey.currentState.openEndDrawer();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      height: 40,
                      child: Row(
                        children:  <Widget>[
                          Flexible(
                            child: Text(
                              state.stockFilter.isFilterByProductCategory ? state.stockFilter.productCategory?.name ?? "Nhóm SP" : "Nhóm SP",
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Color(0xFF6B7280)),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          const Icon(Icons.arrow_drop_down, color: Color(0xFF6B7280))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        }
    );
  }

  Widget _buildHeader(ReportStock reportStockIncurred) {
    return Container(
      color: const Color(0xFFF8F9FB),
      padding: const EdgeInsets.only(left: 12, top: 5, right: 12, bottom: 5),
      child: Container(
        height: 70,
        child: Row(
          children:  <Widget>[
            Expanded(
              child: ItemView(
                title: "Đầu kỳ",
                value: vietnameseCurrencyFormat(reportStockIncurred.aggregates.begin.sum * 1000),
                textColor: const Color(0xFF6B7280),
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: ItemView(
                title: "Nhập trong kỳ",
                value: vietnameseCurrencyFormat(reportStockIncurred.aggregates.import.sum * 1000),
                textColor: const Color(0xFFF25D27),
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: ItemView(
                title: "Xuất trong kỳ",
                value: vietnameseCurrencyFormat(reportStockIncurred.aggregates.export.sum * 1000),
                textColor: const Color(0xFF2395FF),
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: ItemView(
                title: "Cuối kỳ",
                value: vietnameseCurrencyFormat(reportStockIncurred.aggregates.end.sum * 1000),
                textColor: const Color(0xFF28A745),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(ReportStock reportStock) {
    return reportStock.data != null ? reportStock.data.isEmpty ? EmptyDataPage() : Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ListView.separated(
          separatorBuilder: (BuildContext context, int index) => const Divider(
            height: 1,
          ),
          itemCount: reportStock.data?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            return _buildItemProduct(item: reportStock.data[index],reportStock: reportStock);
          }),
    ) : EmptyDataPage();
  }

  Widget _buildItemProduct({ReportStockData item,ReportStock reportStock}){
    return item.productName == "temp" ?  _buildButtonLoadMore(reportStock):  ListTile(
      contentPadding: const EdgeInsets.all(0),
      title: Text(item.productName ?? ''),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Row(
          children: <Widget>[
            Expanded(
                child: Text(
                  vietnameseCurrencyFormat(item.begin*1000 ?? 0),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFF6B7280)),
                )),
            const SizedBox(width: 5),
            Expanded(
                child: Text(vietnameseCurrencyFormat(item.import*1000 ?? 0),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color(0xFFF25D27)))),
            const SizedBox(width: 5),
            Expanded(
                child: Text(vietnameseCurrencyFormat(item.export*1000 ?? 0),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color(0xFF2395FF)))),
            const SizedBox(width: 5),
            Expanded(
                child: Text(vietnameseCurrencyFormat(item.end*1000 ?? 0),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color(0xFF28A745)))),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonLoadMore( ReportStock reportStockIncurred) {
    return BlocBuilder<ReportStockIncurredBloc, ReportStockIncurredState>(
        builder: (context, state) {
          if (state is ReportStockIncurredLoadMoreLoading) {
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
                    _bloc.add(ReportStockIncurredLoadMoreLoaded(
                        skip: _skip,
                        limit: _limit,reportStockIncurred: reportStockIncurred));
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

}
