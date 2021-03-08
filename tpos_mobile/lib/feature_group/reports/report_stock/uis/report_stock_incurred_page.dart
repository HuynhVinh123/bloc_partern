import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/empty_data_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/report_stock_incurred/report_stock_incurred_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/report_stock_incurred/report_stock_incurred_event.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/report_stock_incurred/report_stock_incurred_state.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/stock_filter/stock_filter_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/uis/report_stock_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/uis/stock_move_page.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/src/tpos_apis/models/filter_stock.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';
import 'package:tpos_mobile/widgets/loading_indicator.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class ReportStockIncurredPage extends StatefulWidget {
  const ReportStockIncurredPage(
      {this.bloc,
      this.limit,
      this.skip,
      this.filterBloc,
      this.scaffoldKey,
      this.onChangeProductCategory,
      this.onChangeWarehouse,
      this.onChangeFilter});
  final ReportStockIncurredBloc bloc;
  final StockFilterBloc filterBloc;
  final int limit;
  final int skip;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function onChangeFilter;
  final Function onChangeWarehouse;
  final Function onChangeProductCategory;

  @override
  _ReportStockIncurredPageState createState() =>
      _ReportStockIncurredPageState();
}

class _ReportStockIncurredPageState extends State<ReportStockIncurredPage> {
  ReportStockIncurredBloc _bloc = ReportStockIncurredBloc();
  StockFilterBloc _filterBloc = StockFilterBloc();
  final int _limit = 20;
  StockFilter _stockFiter = StockFilter();
  int _skip = 0;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc;
    _filterBloc = widget.filterBloc;
    _bloc.add(ReportStockIncurredLoaded(limit: _limit, skip: _skip));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<ReportStockIncurredBloc, ReportStockIncurredState>(
        buildWhen: (context, state) {
          if (state is ReportStockIncurredLoading ||
              state is ReportStockIncurredLoadSuccess) {
            return true;
          }
          return false;
        },
        listener: (context, state) {
          if (state is ReportStockIncurredLoadFailure) {
            showError(
                title: state.title, message: state.content, context: context);
          }
        },
        builder: (context, state) {
          if (state is ReportStockIncurredLoading) {
            return const LoadingIndicator();
          }
          return BlocLoadingScreen<ReportStockIncurredBloc>(
            busyStates: const [ReportStockIncurredLoading],
            child:
                BlocBuilder<ReportStockIncurredBloc, ReportStockIncurredState>(
                    buildWhen: (prevState, currState) {
              if (currState is ReportStockIncurredLoadSuccess) {
                return true;
              }
              return false;
            }, builder: (context, state) {
              if (state is ReportStockIncurredLoadSuccess) {
                _stockFiter = state.stockFilter;
                if (state.isFilter) {
                  _skip = 0;
                }
                return Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 8,
                    ),
                    HeaderFilter(
                      filterBloc: _filterBloc,
                      scaffoldKey: widget.scaffoldKey,
                      onChangeFilter: widget.onChangeFilter,
                      onChangeWarehouse: widget.onChangeWarehouse,
                      onChangeProductCategory: widget.onChangeProductCategory,
                      onUpdateStock: () {
                        _bloc.add(ReportStockIncurredLoaded(
                            limit: _limit, skip: _skip));
                      },
                    ),
                    Expanded(child: _buildBody(state))
                  ],
                );
              }
              return const SizedBox();
            }),
          );
        },
      ),
    );
  }

  Widget _buildBody(ReportStockIncurredLoadSuccess state) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Header(reportStock: state.reportStockIncurred),
          _buildListItem(state.reportStockIncurred)
        ],
      ),
    );
  }

  /// Hiển thị danh sách sản phẩm
  Widget _buildListItem(ReportStock reportStock) {
    assert(reportStock != null, "ReportStock not null ");
    return reportStock.data != null
        ? reportStock.data.isEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 100),
                child: EmptyDataPage(),
              )
            : Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                          height: 1,
                        ),
                    itemCount: reportStock.data?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildItemProduct(
                          item: reportStock.data[index],
                          reportStock: reportStock);
                    }),
              )
        : Padding(
            padding: const EdgeInsets.only(top: 100),
            child: EmptyDataPage(),
          );
  }

  /// Hiển thị sản phẩm
  Widget _buildItemProduct(
      {@required ReportStockData item, @required ReportStock reportStock}) {
    assert(reportStock != null && item != null,
        "ReportStock or ReportStockData not null ");
    return item.productName == "temp"
        ? _buildButtonLoadMore(reportStock)
        : ListTile(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return StockMovePage(
                      stockFilter: _stockFiter,
                      productTmplId: item.productTmplId,
                    );
                  },
                ),
              );
            },
            contentPadding: const EdgeInsets.all(0),
            title: Text(item.productName ?? ''),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Text(
                    item.begin != null
                        ? NumberFormat("###,###,###.###", "vi_VN")
                            .format(item.begin)
                        : "0",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color(0xFF6B7280)),
                  )),
                  const SizedBox(width: 5),
                  Expanded(
                      child: Text(
                          item.import != null
                              ? NumberFormat("###,###,###.###", "vi_VN")
                                  .format(item.import)
                              : 0,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Color(0xFFF25D27)))),
                  const SizedBox(width: 5),
                  Expanded(
                      child: Text(
                          item.export != null
                              ? NumberFormat("###,###,###.###", "vi_VN")
                                  .format(item.export)
                              : 0,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Color(0xFF2395FF)))),
                  const SizedBox(width: 5),
                  Expanded(
                      child: Text(
                          item.end != null
                              ? NumberFormat("###,###,###.###", "vi_VN")
                                  .format(item.end)
                              : 0,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Color(0xFF28A745)))),
                ],
              ),
            ),
          );
  }

  /// Hiển thị button để loadmore
  Widget _buildButtonLoadMore(ReportStock reportStockIncurred) {
    assert(reportStockIncurred != null, "ReportStock not null");
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
            margin:
                const EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 8),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(3)),
            height: 45,
            child: FlatButton(
              onPressed: () {
                _skip += _limit;
                _bloc.add(ReportStockIncurredLoadMoreLoaded(
                    skip: _skip,
                    limit: _limit,
                    reportStockIncurred: reportStockIncurred));
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
