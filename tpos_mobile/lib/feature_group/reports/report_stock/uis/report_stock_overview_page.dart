import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/app_core/helper/app_filter_helper.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_datetime.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_drawer.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_panel.dart';
import 'package:tpos_mobile/feature_group/category/product_category/ui/product_category_list_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/inventory_max/inventory_max_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/inventory_max/inventory_max_event.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/inventory_min/inventory_min_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/inventory_min/inventory_min_event.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/report_stock_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/report_stock_event.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/report_stock_incurred/report_stock_incurred_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/report_stock_incurred/report_stock_incurred_event.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/stock_filter/stock_filter_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/stock_filter/stock_filter_event.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/stock_filter/stock_filter_state.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/uis/report_stock_incurred_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/uis/report_stock_inventory_max_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/uis/report_stock_inventory_min_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/uis/report_stock_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/uis/ware_house_stock_page.dart';
import 'package:tpos_mobile/src/tpos_apis/models/filter_stock.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class ReportStockOverviewPage extends StatefulWidget {
  const ReportStockOverviewPage({this.indexPage});
  final int indexPage;
  @override
  _ReportStockOverviewPageState createState() =>
      _ReportStockOverviewPageState();
}

class _ReportStockOverviewPageState extends State<ReportStockOverviewPage>
    with TickerProviderStateMixin {
  final _filterBloc = StockFilterBloc();
  final ReportStockBloc _bloc = ReportStockBloc();
  final ReportStockIncurredBloc _incurredBloc = ReportStockIncurredBloc();
  final InventoryMinBloc _inventoryMinBloc = InventoryMinBloc();
  final InventoryMaxBloc _inventoryMaxBloc = InventoryMaxBloc();
  final int _limit = 20;
  final int _skip = 0;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final _keyController = TextEditingController();
  TabController _tabController;
  StockFilter _stockFilter = StockFilter();
  bool _isFirstLoadFilter = true;

  /// Các biến dùng để lưu tạm giá trị của filter. Sau khi thực hiện xác nhận sẽ cập nhật giá trị
  bool _includeCancelled = false;
  bool _includeReturned = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _filterBloc.add(StockFilterLoaded());
    if (widget.indexPage != null) {
      _tabController.index = widget.indexPage;
    }
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

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF008E30),

      /// Xuất nhập tồn
      title: Text(S.current.impExpInv_importExport),
      actions: <Widget>[
        BlocBuilder<StockFilterBloc, StockFilterState>(
            cubit: _filterBloc,
            builder: (context, state) {
              if (state is StockFilterLoadSuccess) {
                if (_isFirstLoadFilter) {
                  _stockFilter = state.stockFilter;
                }
                return InkWell(
                  onTap: () {
                    if (!_isFirstLoadFilter) {
                      _stockFilter.isFilterByKeyWord =
                          _stockFilter.filterByKeyWord;
                      _stockFilter.isFilterByWarehouseStock =
                          _stockFilter.filterByWarehouseStock;
                      _stockFilter.isFilterByProductCategory =
                          _stockFilter.filterByProductCategory;
                      _stockFilter.includeReturned = _includeReturned;
                      _stockFilter.includeCancelled = _includeCancelled;
                      _stockFilter.productCategory =
                          _stockFilter.productCategoryCache;
                      _stockFilter.wareHouseStock =
                          _stockFilter.wareHouseStockCache;
                      _stockFilter.dateFrom = _stockFilter.dateFromCache;
                      _stockFilter.dateTo = _stockFilter.dateToCache;
                      _stockFilter.filterDateRange =
                          _stockFilter.filterDateRangeCache;
                    }
                    _handleFilter(_stockFilter);
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
            }),
        const SizedBox(
          width: 18,
        )
      ],
    );
  }

  Widget _buildBody() {
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
              tabs: <Widget>[
                // Xuất-Nhập-Tồn
                Tab(
                  child: AutoSizeText(
                    S.current.impExpInv_importExport,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    minFontSize: 12,
                  ),
                ),
                //"X-N-T phát sinh",
                Tab(
                  child: AutoSizeText(
                    S.current.impExpInv_importExportInvIncurred,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    minFontSize: 12,
                  ),
                ),
                Tab(
                  child: AutoSizeText(
                    S.current.theProductIsAlmostOutSummary,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    minFontSize: 8,
                  ),
                ),
                Tab(
                  child: AutoSizeText(
                    S.current.productsBeyondMaximumRangeSummary,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    minFontSize: 12,
                  ),
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
              onChangeFilter: (AppFilterDateModel value) {
                _stockFilter.filterDateRange = value;
                _stockFilter.dateFrom = value.fromDate;
                _stockFilter.dateTo = value.toDate;
                onUpdateFilter(_stockFilter);
              },
              onChangeWarehouse: (WareHouseStock warehouse) {
                _stockFilter.wareHouseStock = warehouse;
                _stockFilter.isFilterByWarehouseStock = true;
                if (_stockFilter.filterDateRange == null) {
                  _stockFilter.filterDateRange = getTodayDateFilter();
                  _stockFilter.dateTo = _stockFilter.filterDateRange.toDate;
                  _stockFilter.dateFrom = _stockFilter.filterDateRange.fromDate;
                }
                onUpdateFilter(_stockFilter);
              },
              onChangeProductCategory: (ProductCategory productCategory) {
                _stockFilter.isFilterByProductCategory = true;
                _stockFilter.productCategory = productCategory;
                if (_stockFilter.filterDateRange == null) {
                  _stockFilter.filterDateRange = getTodayDateFilter();
                  _stockFilter.dateTo = _stockFilter.filterDateRange.toDate;
                  _stockFilter.dateFrom = _stockFilter.filterDateRange.fromDate;
                }
                onUpdateFilter(_stockFilter);
              },
            ),
            ReportStockIncurredPage(
              bloc: _incurredBloc,
              filterBloc: _filterBloc,
              scaffoldKey: scaffoldKey,
              onChangeFilter: (AppFilterDateModel value) {
                _stockFilter.filterDateRange = value;
                _stockFilter.dateFrom = value.fromDate;
                _stockFilter.dateTo = value.toDate;
                onUpdateFilter(_stockFilter);
              },
              onChangeWarehouse: (WareHouseStock warehouse) {
                _stockFilter.wareHouseStock = warehouse;
                _stockFilter.isFilterByWarehouseStock = true;
                if (_stockFilter.filterDateRange == null) {
                  _stockFilter.filterDateRange = getTodayDateFilter();
                  _stockFilter.dateTo = _stockFilter.filterDateRange.toDate;
                  _stockFilter.dateFrom = _stockFilter.filterDateRange.fromDate;
                }
                onUpdateFilter(_stockFilter);
              },
              onChangeProductCategory: (ProductCategory productCategory) {
                _stockFilter.isFilterByProductCategory = true;
                _stockFilter.productCategory = productCategory;
                if (_stockFilter.filterDateRange == null) {
                  _stockFilter.filterDateRange = getTodayDateFilter();
                  _stockFilter.dateTo = _stockFilter.filterDateRange.toDate;
                  _stockFilter.dateFrom = _stockFilter.filterDateRange.fromDate;
                }
                onUpdateFilter(_stockFilter);
              },
            ),
            ReportStockInventoryMinPage(
              bloc: _inventoryMinBloc,
              filterBloc: _filterBloc,
              scaffoldKey: scaffoldKey,
              onChangeFilter: (AppFilterDateModel value) {
                _stockFilter.filterDateRange = value;
                _stockFilter.dateFrom = value.fromDate;
                _stockFilter.dateTo = value.toDate;
                onUpdateFilter(_stockFilter);
              },
              onChangeWarehouse: (WareHouseStock warehouse) {
                _stockFilter.wareHouseStock = warehouse;
                _stockFilter.isFilterByWarehouseStock = true;
                if (_stockFilter.filterDateRange == null) {
                  _stockFilter.filterDateRange = getTodayDateFilter();
                  _stockFilter.dateTo = _stockFilter.filterDateRange.toDate;
                  _stockFilter.dateFrom = _stockFilter.filterDateRange.fromDate;
                }
                onUpdateFilter(_stockFilter);
              },
              onChangeProductCategory: (ProductCategory productCategory) {
                _stockFilter.isFilterByProductCategory = true;
                _stockFilter.productCategory = productCategory;
                if (_stockFilter.filterDateRange == null) {
                  _stockFilter.filterDateRange = getTodayDateFilter();
                  _stockFilter.dateTo = _stockFilter.filterDateRange.toDate;
                  _stockFilter.dateFrom = _stockFilter.filterDateRange.fromDate;
                }
                onUpdateFilter(_stockFilter);
              },
            ),
            ReportStockInventoryMaxPage(
              bloc: _inventoryMaxBloc,
              filterBloc: _filterBloc,
              scaffoldKey: scaffoldKey,
              onChangeFilter: (AppFilterDateModel value) {
                _stockFilter.filterDateRange = value;
                _stockFilter.dateFrom = value.fromDate;
                _stockFilter.dateTo = value.toDate;
                onUpdateFilter(_stockFilter);
              },
              onChangeWarehouse: (WareHouseStock warehouse) {
                _stockFilter.wareHouseStock = warehouse;
                _stockFilter.isFilterByWarehouseStock = true;
                if (_stockFilter.filterDateRange == null) {
                  _stockFilter.filterDateRange = getTodayDateFilter();
                  _stockFilter.dateTo = _stockFilter.filterDateRange.toDate;
                  _stockFilter.dateFrom = _stockFilter.filterDateRange.fromDate;
                }
                onUpdateFilter(_stockFilter);
              },
              onChangeProductCategory: (ProductCategory productCategory) {
                _stockFilter.isFilterByProductCategory = true;
                _stockFilter.productCategory = productCategory;
                if (_stockFilter.filterDateRange == null) {
                  _stockFilter.filterDateRange = getTodayDateFilter();
                  _stockFilter.dateTo = _stockFilter.filterDateRange.toDate;
                  _stockFilter.dateFrom = _stockFilter.filterDateRange.fromDate;
                }
                onUpdateFilter(_stockFilter);
              },
            )
          ],
        )),
      ],
    );
  }

  /// Thực hiện lưu sau filter
  void _handleFilter(StockFilter stockFilter, {bool isConfirm = false}) {
    _stockFilter = stockFilter;
    _filterBloc.add(
        StockFilterChanged(stockFilter: stockFilter, isConfirm: isConfirm));
  }

  /// Thực hiện reset filter
  void _resetFilter(StockFilter stockFilter) {
    stockFilter.isFilterByProductCategory = false;
    stockFilter.isFilterByWarehouseStock = false;
    stockFilter.includeReturned = false;
    stockFilter.includeCancelled = false;
    _stockFilter.isFilterByKeyWord = false;
    onUpdateFilter(stockFilter);
    _handleFilter(stockFilter);
  }

  void onUpdateFilter(StockFilter stockFilter) {
    /// cập nhật các giá trị cho biến tạm
    stockFilter.filterByProductCategory = stockFilter.isFilterByProductCategory;
    stockFilter.filterByWarehouseStock = stockFilter.isFilterByWarehouseStock;
    stockFilter.isFilterByKeyWord = stockFilter.isFilterByKeyWord;
    _includeCancelled = stockFilter.includeCancelled;
    _includeReturned = stockFilter.includeReturned;
    stockFilter.wareHouseStockCache = stockFilter.wareHouseStock;
    stockFilter.productCategoryCache = stockFilter.productCategory;
    stockFilter.dateFromCache = stockFilter.dateFrom;
    stockFilter.dateToCache = stockFilter.dateTo;
    stockFilter.filterDateRangeCache = stockFilter.filterDateRange;

    stockFilter.keyWord = _keyController.text;
    _handleFilter(stockFilter, isConfirm: true);
    if (_tabController.index == 0) {
      _incurredBloc
          .add(ReportStockIncurredLocalFilterSaved(stockFilter: stockFilter));
      _inventoryMinBloc
          .add(InventoryMinLocalFilterSaved(stockFilter: stockFilter));
      _inventoryMaxBloc
          .add(InventoryMaxLocalFilterSaved(stockFilter: stockFilter));

      _bloc.add(ReportStockFilterSaved(
          stockFilter: stockFilter,
          limit: _limit,
          skip: _skip,
          isFilter: true));
    } else if (_tabController.index == 1) {
      _bloc.add(ReportStockLocalFilterSaved(stockFilter: stockFilter));
      _inventoryMinBloc
          .add(InventoryMinLocalFilterSaved(stockFilter: stockFilter));
      _inventoryMaxBloc
          .add(InventoryMaxLocalFilterSaved(stockFilter: stockFilter));

      _incurredBloc.add(ReportStockIncurredFilterSaved(
          stockFilter: stockFilter,
          limit: _limit,
          skip: _skip,
          isFilter: true));
    } else if (_tabController.index == 2) {
      _bloc.add(ReportStockLocalFilterSaved(stockFilter: stockFilter));
      _incurredBloc
          .add(ReportStockIncurredLocalFilterSaved(stockFilter: stockFilter));
      _inventoryMaxBloc
          .add(InventoryMaxLocalFilterSaved(stockFilter: stockFilter));
      _inventoryMinBloc.add(InventoryMinFilterSaved(
          stockFilter: stockFilter,
          limit: _limit,
          skip: _skip,
          isFilter: true));
    } else if (_tabController.index == 3) {
      _bloc.add(ReportStockLocalFilterSaved(stockFilter: stockFilter));
      _incurredBloc
          .add(ReportStockIncurredLocalFilterSaved(stockFilter: stockFilter));
      _inventoryMinBloc
          .add(InventoryMinLocalFilterSaved(stockFilter: stockFilter));
      _inventoryMaxBloc.add(InventoryMaxFilterSaved(
          stockFilter: stockFilter,
          limit: _limit,
          skip: _skip,
          isFilter: true));
    }
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
            _isFirstLoadFilter = false;
            _stockFilter = state.stockFilter;

            return AppFilterDrawerContainer(
              countFilter: state.count,
              onRefresh: () {
                Navigator.pop(context);
                final AppFilterDateModel filterModel = getDateFilterThisMonth();
                state.stockFilter.dateFrom = filterModel.fromDate;
                state.stockFilter.dateTo = filterModel.toDate;
                state.stockFilter.filterDateRange = filterModel;

                _resetFilter(state.stockFilter);
              }, // Thiết lập lại
              closeWhenConfirm: false,
              onApply: () {
                final compareDateTime = state.stockFilter.dateTo
                    .compareTo(state.stockFilter.dateFrom);
                if (compareDateTime == 1) {
                  if (state.stockFilter.wareHouseStock.name == null &&
                      state.stockFilter.isFilterByWarehouseStock) {
                    // Lỗi khi chọn filter kho hàng mà không chọn đối tượng kho hàng
                    showErrorFilter(S.current.filter_ErrorSelectWareHouse);
                  } else {
                    if (state.stockFilter.productCategory.name == null &&
                        state.stockFilter.isFilterByProductCategory) {
                      // Lỗi khi chọn filter nhóm sản phẩm mà ko chọn đối tượng nhóm sản phẩm
                      showErrorFilter(
                          S.current.filter_ErrorSelectProductCategory);
                    } else {
                      if (_keyController.text == '' &&
                          state.stockFilter.isFilterByKeyWord) {
                        showErrorFilter(S.current.filter_ErrorSelectKeyWord);
                      } else {
                        onUpdateFilter(state.stockFilter);
                        Navigator.pop(context);
                      }
                    }
                  }
                } else {
                  // Lỗi khi chọn  ngày bắt đầu sau ngày kêt stthucs
                  showErrorFilter(S.current.filter_ErrorSelectDate);
                }
              }, //Áp dụng
              child: Container(
                margin: MediaQuery.of(context).viewInsets,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
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
                        title: Text(S.current.filterWarehouse),
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
                              child: InkWell(
                                onTap: () async {
                                  final WareHouseStock wareHousestock =
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                WareHouseStockPage(),
                                          ));
                                  if (wareHousestock != null) {
                                    state.stockFilter.wareHouseStock =
                                        wareHousestock;
                                    _handleFilter(state.stockFilter);
                                  }
                                },
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      // Kho hàng
                                      child: Text(
                                          state.stockFilter.wareHouseStock
                                                  ?.name ??
                                              S.current.impExpInv_warehouse,
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 15)),
                                    ),
                                    Visibility(
                                      visible: state.stockFilter.wareHouseStock
                                              ?.name !=
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
                              ))
                        ],
                      ),
                      // Lọc theo nhóm sản phẩm
                      AppFilterPanel(
                        title: Text(S.current.filterProductGroup),
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
                            child: InkWell(
                              onTap: () async {
                                final productCategory = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ProductCategoriesPage(
                                      searchModel: true,
                                    ),
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
                                        state.stockFilter.productCategory
                                                ?.name ??
                                            S.current.menu_productGroup,
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 15)),
                                  ),
                                  Visibility(
                                    visible: state.stockFilter.productCategory
                                            ?.name !=
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
                      //Bao gồm cả phiếu hủy
                      FilterBool(
                        title: Text(S.current.impExpInv_includeCancelled),
                        value: state.stockFilter.includeCancelled,
                        onSelectedChange: (value) {
                          state.stockFilter.includeCancelled = value;
                          _handleFilter(state.stockFilter);
                        },
                      ),

                      const SizedBox(
                        height: 6,
                      ),
                      //Bao gồm cả trả hàng
                      FilterBool(
                        title: Text(S.current.impExpInv_includeReturned),
                        value: state.stockFilter.includeReturned,
                        onSelectedChange: (value) {
                          state.stockFilter.includeReturned = value;
                          _handleFilter(state.stockFilter);
                        },
                      ),
                      AppFilterPanel(
                        title: Text(S.current.impExpInv_key),
                        isSelected: state.stockFilter.isFilterByKeyWord,
                        isEnable: true,
                        onSelectedChange: (value) {
                          state.stockFilter.isFilterByKeyWord = value;
                          _handleFilter(state.stockFilter);
                        },
                        children: [
                          Container(
                            height: 45,
                            width: MediaQuery.of(context).size.width,
                            child: TextField(
                              controller: _keyController,
                              decoration: InputDecoration(
                                  hintText: S.current.impExpInv_nameCode),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const SizedBox();
        });
  }

  void showErrorFilter([String message = '']) {
    App.showDefaultDialog(
        title: S.current.warning,
        content: message,
        context: context,
        type: AlertDialogType.warning);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
    _filterBloc.close();
    _incurredBloc.close();
  }
}

class FilterBool extends StatelessWidget {
  const FilterBool({this.title, this.value = false, this.onSelectedChange});

  final Widget title;
  final bool value;
  final ValueChanged<bool> onSelectedChange;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        children: <Widget>[
          Checkbox(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            value: value,
            onChanged: onSelectedChange,
          ),
          const SizedBox(
            width: 22,
          ),
          Expanded(child: title)
        ],
      ),
      onTap: onSelectedChange != null
          ? () {
              onSelectedChange(!value);
            }
          : null,
    );
  }
}

/// Hàm change filter nhanh ngày tháng này
// ignore: must_be_immutable
class FilterDateInventory extends StatelessWidget {
  FilterDateInventory({this.state, this.onChangeFilter});
  final StockFilterLoadSuccess state;
  final Function onChangeFilter;
  List<AppFilterDateModel> dateRanges = getFilterDateTemplateSimple();

  @override
  Widget build(BuildContext context) {
    dateRanges.removeAt(dateRanges.length - 1);
    return PopupMenuButton(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.date_range, size: 17, color: Color(0xFF6B7280)),
            const SizedBox(
              width: 6,
            ),
            Text(
              state.stockFilter.filterDateRangeCache != null
                  ? state.stockFilter.filterDateRangeCache.name == "Tùy chỉnh"
                      ? "${DateFormat("dd/MM/yyyy").format(state.stockFilter.dateFromCache)} - ${DateFormat("dd/MM/yyyy").format(state.stockFilter.dateToCache)}"
                      : state.stockFilter.filterDateRangeCache.name
                  : "Thời gian",
              style: const TextStyle(color: Color(0xFF6B7280)),
            ),
            const Icon(Icons.arrow_drop_down, color: Color(0xFF6B7280))
          ],
        ),
        // ignore: unnecessary_parenthesis
        itemBuilder: (context) => (dateRanges)
            .map(
              (f) => PopupMenuItem<AppFilterDateModel>(
                child: Text(f.name),
                value: f,
              ),
            )
            .toList(),
        onSelected: (AppFilterDateModel value) {
          onChangeFilter(value);
        });
  }
}
