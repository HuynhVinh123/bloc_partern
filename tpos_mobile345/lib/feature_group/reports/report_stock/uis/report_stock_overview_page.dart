import 'package:badges/badges.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_bool.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_datetime.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_drawer.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_panel.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/report_stock_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/report_stock_event.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/report_stock_incurred/report_stock_incurred_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/report_stock_incurred/report_stock_incurred_event.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/report_stock_incurred/report_stock_incurred_state.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/report_stock_state.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/stock_filter/stock_filter_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/stock_filter/stock_filter_event.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/stock_filter/stock_filter_state.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/ware_house_stock/ware_house_stock_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/uis/report_stock_incurred_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/uis/report_stock_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/uis/ware_house_stock_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/product_category_page.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/src/tpos_apis/models/filter_stock.dart';
import 'package:tpos_mobile/src/tpos_apis/models/product_category.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';

class ReportStockOverviewPage extends StatefulWidget {
  @override
  _ReportStockOverviewPageState createState() =>
      _ReportStockOverviewPageState();
}

class _ReportStockOverviewPageState extends State<ReportStockOverviewPage>
    with TickerProviderStateMixin {
  final _filterBloc = StockFilterBloc();
  ReportStockBloc _bloc = ReportStockBloc();
  ReportStockIncurredBloc _incurredBloc = ReportStockIncurredBloc();
  final int _limit = 20;
  final int _skip = 0;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TabController _tabController;
  StockFilter _stockFilter = StockFilter();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _filterBloc.add(StockFilterLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFfEBEDEF),
      endDrawer: _buildFilterDrawer(),
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildAppBar(){
    return AppBar(
      backgroundColor: const Color(0xFF008E30),
      title: const Text("Xuất nhập tồn"),
      actions: <Widget>[
        BlocBuilder<StockFilterBloc, StockFilterState>(
            cubit: _filterBloc,
            builder: (context, state) {
              if(state is StockFilterLoadSuccess){
                return InkWell(
                  onTap: () {
                    scaffoldKey.currentState.openEndDrawer();
                  },
                  child: Badge(
                    position: const BadgePosition(top: 4, end: -4),
                    padding: const EdgeInsets.all(4),
                    badgeColor: Colors.redAccent,
                    badgeContent: Text(
                      state.countFilter.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    child: const Icon(
                      Icons.filter_list,
                      color: Colors.white,
                    ),
                  ),
                );
              }
              return const SizedBox();
            }

        ),
        const SizedBox(
          width: 18,
        )
      ],
    );
  }

  Widget _buildBody(){
    return Column(
      children: <Widget>[
        Material(
          color: Colors.white,
          child: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFF28A745),
              labelColor: const Color(0xFF28A745),
              unselectedLabelColor: Colors.black54,
              dragStartBehavior: DragStartBehavior.down,
              tabs: const <Widget>[
                // Xuất-Nhập-Tồn
                Tab(
                  text: "Xuất-Nhập-Tồn",
                ),
                // Xuất-Nhập-Tồn phát sinh
                Tab(
                  text: "Xuất-Nhập-Tồn phát sinh",
                ),

                ///SP sắp hết
                Tab(
                  text: "SP sắp hết",
                ),

                ///Sản phẩm vượt tồn tối đa
                Tab(
                  text: "Sản phẩm vượt tồn tối đa",
                ),
              ]),
        ),
        Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                ReportStockPage(
                  bloc: _bloc,
                  filterBloc: _filterBloc,
                  scaffoldKey: scaffoldKey,
                ),
                ReportStockIncurredPage(
                    bloc: _incurredBloc,
                    filterBloc: _filterBloc,
                    scaffoldKey: scaffoldKey),
                ReportStockPage(
                    bloc: _bloc,
                    filterBloc: _filterBloc,
                    scaffoldKey: scaffoldKey),
                ReportStockPage(
                    bloc: _bloc,
                    filterBloc: _filterBloc,
                    scaffoldKey: scaffoldKey)
              ],
            )),
      ],
    );
  }

  void _handleFilter(StockFilter stockFilter) {
    _stockFilter = stockFilter;
    _filterBloc.add(StockFilterChanged(stockFilter: stockFilter));
  }

  void _resetFilter(StockFilter stockFilter) {
    stockFilter.isFilterByProductCategory = false;
    stockFilter.isFilterByWarehouseStock = false;
    stockFilter.includeReturned = false;
    stockFilter.includeCancelled = false;
    _handleFilter(stockFilter);
  }

  /// Build widget điều kiện lọc
  Widget _buildFilterDrawer() {
    return BlocBuilder<StockFilterBloc, StockFilterState>(
        buildWhen: (prevState, curState) {
          if (curState is StockFilterLoadSuccess) {
            return true;
          }
          return false;
        },
        cubit: _filterBloc,
        builder: (context, state) {
          if (state is StockFilterLoadSuccess) {
            _stockFilter = state.stockFilter;
            return AppFilterDrawerContainer(
              onRefresh: () {
                _resetFilter(state.stockFilter);
              }, // Thiết lập lại
              closeWhenConfirm: true,
              onApply: () {
                _handleFilter(state.stockFilter);
                if (_tabController.index == 0) {
                  _incurredBloc.add(ReportStockIncurredLocalFilterSaved(stockFilter: state.stockFilter));
                  _bloc.add(ReportStockFilterSaved(
                      stockFilter: state.stockFilter,
                      limit: _limit,
                      skip: _skip));

                } else if (_tabController.index == 1) {
                  _bloc.add(ReportStockLocalFilterSaved(stockFilter: state.stockFilter));
                  _incurredBloc.add(ReportStockIncurredFilterSaved(
                      stockFilter: state.stockFilter,
                      limit: _limit,
                      skip: _skip));
                }
              }, //Áp dụng
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    // Lọc theo thời gian
                    // Lọc theo thời gian
                    AppFilterDateTime(
                      isSelected: true,
                      fromDate: state.stockFilter.dateFrom,
                      toDate: state.stockFilter.dateTo,
                      initDateRange: state.stockFilter.filterDateRange,
                      onFromDateChanged: (value) {
                        state.stockFilter.dateFrom = value;
                        _handleFilter(state.stockFilter);
                      },
                      onToDateChanged: (value) {
                        state.stockFilter.dateTo = value;
                        _handleFilter(state.stockFilter);
                      },
                      onSelectChange: (value) {},
                      dateRangeChanged: (value) {
                        state.stockFilter.filterDateRange = value;
                        _handleFilter(state.stockFilter);
                      },
                    ),
                    // Lọc theo kho hàng
                    AppFilterPanel(
                      title: const Text("Lọc theo kho"),
                      isSelected: state.stockFilter.isFilterByWarehouseStock,
                      isEnable: true,
                      onSelectedChange: (value) {
                        state.stockFilter.isFilterByWarehouseStock = value;
                        _handleFilter(state.stockFilter);
                      },
                      children: [
                        Container(
                          height: 45,
                          margin: const EdgeInsets.only(
                              left: 32, right: 8, bottom: 12),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey[400]))),
                          child: InkWell(
                            onTap: () async {
                              final WareHouseStock wareHousestock =
                                  await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WareHouseStockPage(),
                                ),
                              );
                              if (wareHousestock != null) {
                                state.stockFilter.wareHouseStock =
                                    wareHousestock;
                                _handleFilter(state.stockFilter);
                              }
                            },
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                      state.stockFilter.wareHouseStock?.name ??
                                          "Kho hàng",
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15)),
                                ),
                                Visibility(
                                  visible:
                                      state.stockFilter.wareHouseStock?.name !=
                                          null,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      state.stockFilter.wareHouseStock =
                                          WareHouseStock();
                                      _handleFilter(state.stockFilter);
                                    },
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.grey[600],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    // Lọc theo nhóm sản phẩm
                    AppFilterPanel(
                      title: const Text("Lọc theo nhóm sản phẩm"),
                      isSelected: state.stockFilter.isFilterByProductCategory,
                      isEnable: true,
                      onSelectedChange: (value) {
                        state.stockFilter.isFilterByProductCategory = value;
                        _handleFilter(state.stockFilter);
                      },
                      children: [
                        Container(
                          height: 45,
                          margin: const EdgeInsets.only(
                              left: 32, right: 8, bottom: 12),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey[400]))),
                          child: InkWell(
                            onTap: () async {
                              final productCategory = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ProductCategoryPage(),
                                ),
                              );
                              if (productCategory != null) {
                                state.stockFilter.productCategory =
                                    productCategory;
                                _handleFilter(state.stockFilter);
                              }
                            },
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                      state.stockFilter.productCategory?.name ??
                                          "Nhóm sản phẩm",
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15)),
                                ),
                                Visibility(
                                  visible:
                                      state.stockFilter.productCategory?.name !=
                                          null,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      state.stockFilter.productCategory =
                                          ProductCategory();
                                      _handleFilter(state.stockFilter);
                                    },
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.grey[600],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    AppFilterBool(
                      title: const Text("Bao gồm cả phiếu hủy"),
                      value: state.stockFilter.includeCancelled,
                      onSelectedChange: (value) {
                        state.stockFilter.includeCancelled = value;
                        _handleFilter(state.stockFilter);
                      },
                    ),
                    AppFilterBool(
                      title: const Text("Bao gồm cả trả hàng"),
                      value: state.stockFilter.includeReturned,
                      onSelectedChange: (value) {
                        state.stockFilter.includeReturned = value;
                        _handleFilter(state.stockFilter);
                      },
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox();
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bloc.close();
    _filterBloc.close();
    _incurredBloc.close();
  }

}
