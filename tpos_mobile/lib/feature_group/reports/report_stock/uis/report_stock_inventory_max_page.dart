import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/empty_data_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/inventory_max/inventory_max_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/inventory_max/inventory_max_event.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/inventory_max/inventory_max_state.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/stock_filter/stock_filter_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/uis/report_stock_page.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';
import 'package:tpos_mobile/widgets/loading_indicator.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class ReportStockInventoryMaxPage extends StatefulWidget {
  const ReportStockInventoryMaxPage(
      {this.bloc,
      this.limit,
      this.skip,
      this.filterBloc,
      this.scaffoldKey,
      this.onChangeFilter,
      this.onChangeWarehouse,
      this.onChangeProductCategory});
  final InventoryMaxBloc bloc;
  final StockFilterBloc filterBloc;
  final int limit;
  final int skip;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function onChangeFilter;
  final Function onChangeWarehouse;
  final Function onChangeProductCategory;

  @override
  _ReportStockInventoryMaxPageState createState() =>
      _ReportStockInventoryMaxPageState();
}

class _ReportStockInventoryMaxPageState
    extends State<ReportStockInventoryMaxPage> {
  InventoryMaxBloc _bloc;
  StockFilterBloc _filterBloc = StockFilterBloc();
  final int _limit = 20;
  int _skip = 0;

  @override
  void initState() {
    super.initState();
    _bloc = InventoryMaxBloc();
    _bloc = widget.bloc;
    _filterBloc = widget.filterBloc;
    _bloc.add(InventoryMaxLoaded(limit: _limit, skip: _skip));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<InventoryMaxBloc, InventoryMaxState>(
          buildWhen: (context, state) {
        if (state is InventoryMaxLoading || state is InventoryMaxLoadSuccess) {
          return true;
        }
        return false;
      }, listener: (context, state) {
        if (state is InventoryMaxLoadFailure) {
          showError(
              title: state.title, message: state.content, context: context);
        }
      }, builder: (context, state) {
        if (state is InventoryMaxLoading) {
          return const LoadingIndicator();
        }
        return BlocLoadingScreen<InventoryMaxBloc>(
          busyStates: const [InventoryMaxLoading],
          child: BlocBuilder<InventoryMaxBloc, InventoryMaxState>(
              buildWhen: (prevState, currState) {
            if (currState is InventoryMaxLoadSuccess) {
              return true;
            }
            return false;
          }, builder: (context, state) {
            if (state is InventoryMaxLoadSuccess) {
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
                      _bloc.add(InventoryMaxLoaded(limit: _limit, skip: _skip));
                    },
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Expanded(child: _buildListItem(state.products)),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              );
            }
            return const SizedBox();
          }),
        );
      }),
    );
  }

  /// Hiển thị danh sách sản phẩm
  Widget _buildListItem(List<StockWarehouseProduct> items) {
    assert(items != null, "List<StockWarehouseProduct> not null");
    return items != null
        ? items.isEmpty
            ? EmptyDataPage()
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                          height: 1,
                        ),
                    itemCount: items.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildItem(items[index], items);
                    }),
              )
        : EmptyDataPage();
  }

  /// Hiển thị từng sản phẩm
  Widget _buildItem(
      StockWarehouseProduct item, List<StockWarehouseProduct> products) {
    assert(products != null && item != null,
        "List<StockWarehouseProduct> && item not null");
    return item.uOMName == "temp"
        ? _buildButtonLoadMore(products)
        : Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              title: Row(
                children: [
                  Expanded(
                      child: Text(
                    item?.productTmplName ?? "",
                    style: const TextStyle(
                        color: Color(0xFF28A745), fontWeight: FontWeight.bold),
                  )),
                  Text(
                    item?.inventory != null
                        ? NumberFormat("###,###,###.###", "vi_VN")
                            .format(item.inventory)
                        : "0",
                    style: TextStyle(
                        color: item.inventory >= 0
                            ? const Color(0xFF6B7280)
                            : const Color(0xFFEB3B5B),
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  )
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    //Đơn vị tính
                    Text(
                      "${S.current.unit}: ",
                      style: const TextStyle(color: Color(0xFF929DAA)),
                    ),
                    Flexible(
                        child: Text(
                      item?.uOMName ?? "",
                      style: const TextStyle(color: Color(0xFF2C333A)),
                    )),
                    const Text("  |  "),
                    // Tồn tối thiểu
                    Text(
                      "${S.current.impExpInv_maxInventory}: ",
                      style: const TextStyle(color: Color(0xFF929DAA)),
                    ),
                    Text(
                      item?.inventoryMax != null
                          ? NumberFormat("###,###,###.###", "vi_VN")
                              .format(item.inventoryMax)
                          : "0",
                      style: const TextStyle(color: Color(0xFF2C333A)),
                    )
                  ],
                ),
              ),
            ));
  }

  /// Hiển thị button để thực hiện loadmore
  Widget _buildButtonLoadMore(List<StockWarehouseProduct> products) {
    assert(products != null, "Products not null");
    return BlocBuilder<InventoryMaxBloc, InventoryMaxState>(
        builder: (context, state) {
      if (state is InventoryMaxLoadMoreLoading) {
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
                _bloc.add(InventoryMaxLoadMoreLoaded(
                    skip: _skip, limit: _limit, products: products));
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
