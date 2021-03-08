import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/product_category/ui/product_category_list_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/empty_data_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/report_stock_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/report_stock_event.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/report_stock_state.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/stock_filter/stock_filter_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/stock_filter/stock_filter_state.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/uis/report_stock_overview_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/uis/stock_move_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/uis/ware_house_stock_page.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/src/tpos_apis/models/filter_stock.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';
import 'package:tpos_mobile/widgets/loading_indicator.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class ReportStockPage extends StatefulWidget {
  const ReportStockPage(
      {this.bloc,
      this.limit,
      this.skip,
      this.filterBloc,
      this.scaffoldKey,
      this.onChangeFilter,
      this.onChangeWarehouse,
      this.onChangeProductCategory});
  final ReportStockBloc bloc;
  final StockFilterBloc filterBloc;
  final int limit;
  final int skip;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function onChangeFilter;
  final Function onChangeWarehouse;
  final Function onChangeProductCategory;
  @override
  _ReportStockPageState createState() => _ReportStockPageState();
}

class _ReportStockPageState extends State<ReportStockPage> {
  ReportStockBloc _bloc;
  StockFilterBloc _filterBloc = StockFilterBloc();
  StockFilter _stockFiter = StockFilter();
  final int _limit = 20;
  int _skip = 0;

  @override
  void initState() {
    super.initState();
    _bloc = ReportStockBloc();
    _bloc = widget.bloc;
    _filterBloc = widget.filterBloc;
    _bloc.add(ReportStockLoaded(limit: _limit, skip: _skip));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: _bloc,
        child: BlocConsumer<ReportStockBloc, ReportStockState>(
            buildWhen: (context, state) {
          if (state is ReportStockLoading || state is ReportStockLoadSuccess) {
            return true;
          }
          return false;
        }, listener: (context, state) {
          if (state is ReportStockLoadFailure) {
            showError(
                title: state.title, message: state.content, context: context);
          }
        }, builder: (context, state) {
          if (state is ReportStockLoading) {
            return const LoadingIndicator();
          }
          return BlocLoadingScreen<ReportStockBloc>(
            busyStates: const [ReportStockLoading],
            child: BlocBuilder<ReportStockBloc, ReportStockState>(
                buildWhen: (prevState, currState) {
              if (currState is ReportStockLoadSuccess) {
                return true;
              }
              return false;
            }, builder: (context, state) {
              if (state is ReportStockLoadSuccess) {
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
                        _bloc
                            .add(ReportStockLoaded(limit: _limit, skip: _skip));
                      },
                    ),
                    Expanded(child: _buildBody(state))
                  ],
                );
              }
              return const SizedBox();
            }),
          );
        }));
  }

  Widget _buildBody(ReportStockLoadSuccess state) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Header(reportStock: state.reportStock),
          _buildListItem(state.reportStock),
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
    assert(
        reportStock != null && item != null, "ReportStock or Item not null ");
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
                              : "0",
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Color(0xFFF25D27)))),
                  const SizedBox(width: 5),
                  Expanded(
                      child: Text(
                          item.export != null
                              ? NumberFormat("###,###,###.###", "vi_VN")
                                  .format(item.export)
                              : "0",
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Color(0xFF2395FF)))),
                  const SizedBox(width: 5),
                  Expanded(
                      child: Text(
                          item.end != null
                              ? NumberFormat("###,###,###.###", "vi_VN")
                                  .format(item.end)
                              : "0",
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Color(0xFF28A745)))),
                ],
              ),
            ),
          );
  }

  /// Hiển thị button để loadmore
  Widget _buildButtonLoadMore(ReportStock reportStock) {
    assert(reportStock != null, "ReportStock not null");
    return BlocBuilder<ReportStockBloc, ReportStockState>(
        builder: (context, state) {
      if (state is ReportStockLoadMoreLoading) {
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
                _bloc.add(ReportStockLoadMoreLoaded(
                    skip: _skip, limit: _limit, reportStock: reportStock));
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

/// Hiển thị dateTime filter, kho hàng,nhóm SP
class HeaderFilter extends StatelessWidget {
  const HeaderFilter(
      {this.filterBloc,
      this.scaffoldKey,
      this.onChangeFilter,
      this.onChangeWarehouse,
      this.onChangeProductCategory,
      this.onUpdateStock});
  final StockFilterBloc filterBloc;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function onChangeFilter;
  final Function onChangeWarehouse;
  final Function onChangeProductCategory;
  final Function onUpdateStock;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StockFilterBloc, StockFilterState>(
        cubit: filterBloc,
        builder: (context, state) {
          if (state is StockFilterLoadSuccess) {
            return Container(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  const SizedBox(
                    width: 12,
                  ),
                  FilterDateInventory(
                    state: state,
                    onChangeFilter: onChangeFilter,
                  ),
                  InkWell(
                    onTap: () async {
                      final WareHouseStock wareHouseStock =
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WareHouseStockPage(),
                              ));
                      if (wareHouseStock != null) {
                        onChangeWarehouse(wareHouseStock);
                        // state.stockFilter.wareHouseStock =
                        //     wareHousestock;
                        // _handleFilter(state.stockFilter);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      height: 40,
                      child: Row(
                        children: <Widget>[
                          // Kho hàng
                          Text(
                            state.stockFilter.filterByWarehouseStock
                                ? state.stockFilter.wareHouseStockCache?.name !=
                                        null
                                    ? state.stockFilter.wareHouseStockCache.name
                                                .length >
                                            20
                                        ? "${state.stockFilter.wareHouseStockCache.name.substring(0, 19)}..."
                                        : state.stockFilter.wareHouseStockCache
                                            .name
                                    : S.current.impExpInv_warehouse
                                : S.current.impExpInv_warehouse,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Color(0xFF6B7280)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Icon(Icons.arrow_drop_down,
                              color: Color(0xFF6B7280))
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      // scaffoldKey.currentState.openEndDrawer();
                      final productCategory = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProductCategoriesPage(
                                  searchModel: true,
                                )),
                      );
                      if (productCategory != null) {
                        onChangeProductCategory(productCategory);

                        // state.stockFilter.productCategory =
                        //     productCategory;
                        // _handleFilter(state.stockFilter);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      height: 40,
                      child: Row(
                        children: <Widget>[
                          // Nhóm SP
                          Text(
                            state.stockFilter.filterByProductCategory
                                ? state.stockFilter.productCategoryCache
                                            ?.name !=
                                        null
                                    ? state.stockFilter.productCategoryCache
                                                .name.length >
                                            20
                                        ? "${state.stockFilter.productCategoryCache.name.substring(0, 19)}..."
                                        : state.stockFilter.productCategoryCache
                                            ?.name
                                    : S.current.impExpInv_productGroup
                                : S.current.impExpInv_productGroup,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Color(0xFF6B7280)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          const Icon(Icons.arrow_drop_down,
                              color: Color(0xFF6B7280))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        });
  }
}

/// Hiển thị header cho page
class Header extends StatelessWidget {
  const Header({@required this.reportStock})
      : assert(reportStock != null, "ReportStock not null ");
  final ReportStock reportStock;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8F9FB),
      padding: const EdgeInsets.only(left: 12, top: 5, right: 12, bottom: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 60,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: ItemView(
                    title: S.current.impExpInv_begin,
                    value: reportStock.aggregates.begin.sum != null
                        ? NumberFormat("###,###,###.###", "vi_VN")
                            .format(reportStock.aggregates.begin.sum)
                        : "0",
                    textColor: const Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(width: 5),
                // Nhập trong kỳ
                Expanded(
                  child: ItemView(
                    title: S.current.impExpInv_importBegin,
                    value: reportStock.aggregates.import.sum != null
                        ? NumberFormat("###,###,###.###", "vi_VN")
                            .format(reportStock.aggregates.import.sum)
                        : "0",
                    textColor: const Color(0xFFF25D27),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 60,
            child: Row(
              children: <Widget>[
                // Xuất trong kỳ
                Expanded(
                  child: ItemView(
                    title: S.current.impExpInv_exportBegin,
                    value: reportStock.aggregates.export.sum != null
                        ? NumberFormat("###,###,###.###", "vi_VN")
                            .format(reportStock.aggregates.export.sum)
                        : "0",
                    textColor: const Color(0xFF2395FF),
                  ),
                ),
                const SizedBox(width: 5),
                // Cuối kỳ
                Expanded(
                  child: ItemView(
                    title: S.current.impExpInv_end,
                    value: reportStock.aggregates.end.sum != null
                        ? NumberFormat("###,###,###.###", "vi_VN")
                            .format(reportStock.aggregates.end.sum)
                        : "0",
                    textColor: const Color(0xFF28A745),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Item header
class ItemView extends StatelessWidget {
  const ItemView(
      {this.title,
      this.value,
      this.align = TextAlign.center,
      this.textColor,
      this.isContent = true});
  final String title;
  final String value;
  final bool isContent;

  final TextAlign align;
  final Color textColor;

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: <Widget>[
          Visibility(
            visible: isContent,
            child: AutoSizeText(
              title ?? "",
              style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13),
              textAlign: TextAlign.center,
              maxFontSize: 17,
              minFontSize: 10,
              maxLines: 1,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          AutoSizeText(
            value,
            textAlign: align,
            maxFontSize: 17,
            minFontSize: 10,
            style: TextStyle(
                color: textColor, fontSize: 22, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
