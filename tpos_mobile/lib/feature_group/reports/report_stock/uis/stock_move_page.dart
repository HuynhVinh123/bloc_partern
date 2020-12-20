import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/empty_data_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/inventory_min/inventory_min_state.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/stock_filter/stock_filter_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/stock_move/stock_move_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/stock_move/stock_move_event.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/stock_move/stock_move_state.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/src/tpos_apis/models/filter_stock.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class StockMovePage extends StatefulWidget {
  const StockMovePage({this.stockFilter, this.productTmplId});
  final StockFilter stockFilter;
  final int productTmplId;
  @override
  _StockMovePageState createState() => _StockMovePageState();
}

class _StockMovePageState extends State<StockMovePage> {
  StockMoveBloc _bloc;
  final int _limit = 80;
  int _skip = 0;

  @override
  void initState() {
    super.initState();
    _bloc = StockMoveBloc();
    _bloc.add(StockMoveLoaded(
        limit: _limit,
        skip: _skip,
        stockFilter: widget.stockFilter,
        productTmplId: widget.productTmplId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEDEF),
      appBar: AppBar(
        title: Text(S.current.detail),
      ),
      body: BlocUiProvider<StockMoveBloc>(
        bloc: _bloc,
        listen: (state) {
          if (state is InventoryMinLoadFailure) {
            showError(
                title: state.title, message: state.content, context: context);
          }
        },
        child: BlocLoadingScreen<StockMoveBloc>(
          busyStates: const [StockMoveLoading],
          child: BlocBuilder<StockMoveBloc, StockMoveState>(
              buildWhen: (prevState, currState) {
            if (currState is StockMoveLoadSuccess) {
              return true;
            }
            return false;
          }, builder: (context, state) {
            if (state is StockMoveLoadSuccess) {
              return Column(
                children: <Widget>[
                  const SizedBox(
                    height: 8,
                  ),
                  _buildFilter(),
                  const SizedBox(
                    height: 6,
                  ),
                  Expanded(child: _buildListItem(state.stockMoveProduct)),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              );
            }
            return const SizedBox();
          }),
        ),
      ),
    );
  }

  /// Hiển thị thời gian filter
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
            widget.stockFilter.filterDateRange != null
                ? widget.stockFilter.filterDateRange.name == "Tùy chỉnh"
                    ? "${DateFormat("dd/MM/yyyy").format(widget.stockFilter.dateFrom)} - ${DateFormat("dd/MM/yyyy").format(widget.stockFilter.dateTo)}"
                    : widget.stockFilter.filterDateRange.name
                : S.current.time,
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

  /// Hiển thị danh sách sản phẩm
  Widget _buildListItem(StockMoveProduct data) {
    assert(data != null, "StockMoveProduct not null");
    return data.value != null
        ? data.value.isEmpty
            ? EmptyDataPage()
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ListView.builder(
                    itemCount: data.value.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildItem(data.value[index], data);
                    }),
              )
        : EmptyDataPage();
  }

  /// Hiển thị từng sản phẩm
  Widget _buildItem(
      StockMoveProductValue item, StockMoveProduct stockMoveProduct) {
    assert(item != null && stockMoveProduct != null,
        "StockWarehouseProduct && List<StockWarehouseProduct> not null");
    return item.name == "temp"
        ? _buildButtonLoadMore(stockMoveProduct)
        : Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              title: Row(
                children: [
                  Expanded(
                      child: Text(
                    item?.orderName ?? "",
                    style: const TextStyle(
                        color: Color(0xFF28A745), fontWeight: FontWeight.bold),
                  )),
                  Text(
                    item?.productQty?.toInt()?.toString(),
                    style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  )
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      children: [
                        const Icon(Icons.home,
                            color: Color(0xFF929DAA), size: 20),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          item.locationNameGet ?? "",
                          style: const TextStyle(color: Color(0xFF2C333A)),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_right_alt,
                          color: Color(0xFF28A745),
                        ),
                        Text(
                          item.locationDestNameGet ?? "",
                          style: const TextStyle(color: Color(0xFF2C333A)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        /// Đơn vị tính
                        Text(
                          "${S.current.unit}: ",
                          style: const TextStyle(color: Color(0xFF929DAA)),
                        ),

                        Flexible(
                            child: Text(
                          item?.productUOMName ?? "",
                          style: const TextStyle(color: Color(0xFF2C333A)),
                        )),
                        const Text("  |  "),
                        // Tồn tối thiểu
                        Text(
                          "${item.date != null ? DateFormat("dd/MM/yyyy HH:mm").format(DateTime.parse(item.date).toLocal()) : ""} ",
                          style: const TextStyle(color: Color(0xFF929DAA)),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(item.partnerName ?? ""),
                  ],
                ),
              ),
            ));
  }

  /// Hiển thị button để thực hiện loadmore
  Widget _buildButtonLoadMore(StockMoveProduct stockMoveProduct) {
    assert(stockMoveProduct != null, "List<StockWarehouseProduct> not null");
    return BlocBuilder<StockMoveBloc, StockMoveState>(
        builder: (context, state) {
      if (state is StockMoveLoadMoreLoading) {
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
                _bloc.add(StockMoveLoadMoreLoaded(
                    skip: _skip,
                    limit: _limit,
                    stockMoveProduct: stockMoveProduct,
                    productTmplId: widget.productTmplId));
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
