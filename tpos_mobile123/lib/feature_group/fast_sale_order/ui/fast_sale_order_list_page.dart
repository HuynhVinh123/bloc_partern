/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 7/4/19 6:25 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 7/4/19 5:51 PM
 *
 */

import 'package:badges/badges.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_datetime.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_drawer.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_panel.dart';
import 'package:tpos_mobile/app_core/ui_base/ui_base.dart';

import 'package:tpos_mobile/feature_group/fast_sale_order/ui/fast_sale_order_add_edit_full_page.dart';
import 'package:tpos_mobile/feature_group/fast_sale_order/viewmodels/fast_sale_order_list_viewmodel.dart';

import 'package:tpos_mobile/helpers/helpers.dart';

import 'package:tpos_mobile/src/tpos_apis/models/fast_sale_order.dart';
import 'package:tpos_mobile/widgets/appbar_search_widget.dart';
import 'package:tpos_mobile/widgets/custom_widget.dart';

import 'fast_sale_order_info_page.dart';
import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';

class FastSaleOrderListPage extends StatefulWidget {
  final int partnerId;
  FastSaleOrderListPage({this.partnerId});
  @override
  _FastSaleOrderListPageState createState() => _FastSaleOrderListPageState();
}

class _FastSaleOrderListPageState extends State<FastSaleOrderListPage> {
  Key refreshIndicatorKey = new Key("refreshIndicator");
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  FastSaleOrderListViewModel viewModel = new FastSaleOrderListViewModel();

  final TextEditingController _dateFromTextController =
      new TextEditingController();
  final TextEditingController _dateToTextController =
      new TextEditingController();

  @override
  void initState() {
    viewModel.init(partnerId: widget.partnerId);
    viewModel.initData();
    viewModel.dialogMessageController.listen((data) {
      registerDialogToView(context, data,
          scaffState: _scaffoldKey.currentState);
    });
    super.initState();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UIViewModelBase<FastSaleOrderListViewModel>(
      viewModel: viewModel,
      child: new Scaffold(
        key: _scaffoldKey,
        endDrawer: _buildFilterDrawer(context),
        appBar: widget.partnerId == null
            ? new AppBar(
                title: Builder(builder: (ctx) {
                  if (viewModel.isSearchEnable) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: new AppbarSearchWidget(
                        autoFocus: true,
                        keyword: viewModel.keyword,
                        onTextChange: (value) {
                          viewModel.searchOrderCommand(value);
                        },
                      ),
                    );
                  } else {
                    return Text("Hóa đơn");
                  }
                }),
                actions: <Widget>[
                  AppbarIconButton(
                    icon: Icon(Icons.search),
                    isEnable: true,
                    onPressed: () {
                      setState(() {
                        viewModel.isSearchEnable = !viewModel.isSearchEnable;
                        if (viewModel.isSearchEnable == false) {
                          viewModel.onKeywordAdd("");
                        }
                      });
                    },
                  ),
                  new AppbarIconButton(
                    icon: Icon(
                      Icons.add,
                    ),
                    isEnable: viewModel.permissionAdd,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FastSaleOrderAddEditFullPage(
                            onEditCompleted: (value) {
                              viewModel.init();
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              )
            : null,
        body: Column(children: <Widget>[
          _showSearchResult(),
          Expanded(
            child: Scrollbar(
              child: _showListFastSaleOrder(),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _showFilterPanel() {
    return ScopedModelDescendant<FastSaleOrderListViewModel>(
      builder: (context, child, model) {
        return new Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 2,
                color: Colors.grey,
                spreadRadius: 2,
                offset: Offset(1, 1),
              ),
            ],
          ),
          child: Wrap(
            alignment: WrapAlignment.start,
            runSpacing: 10,
            spacing: 10,
            children: <Widget>[
              FilterButton(
                child: Text("${viewModel.filterByDateString}"),
                backgroundColor: Colors.green,
                isSelected: viewModel.filterByDateString != null,
                onTap: () {
                  _scaffoldKey.currentState.openEndDrawer();
                },
              ),
              FilterButton(
                child:
                    Text("${viewModel.filterByStatusString ?? "Tình trạng"}"),
                isSelected: viewModel.filterByStatusString != null,
                onTap: () {
                  _scaffoldKey.currentState.openEndDrawer();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _showSearchResult() {
    return new Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            color: Colors.grey,
            spreadRadius: 2,
            offset: Offset(1, 1),
          ),
        ],
      ),
      child: ScopedModelDescendant<FastSaleOrderListViewModel>(
        builder: (context, child, model) => Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: DropdownButtonHideUnderline(
                child: new DropdownButton<String>(
                  value: viewModel.fastSaleOrderSort.orderBy,
                  onChanged: (String newValue) {
                    setState(() {
                      switch (newValue) {
                        case "DateInvoice":
                          viewModel.selectSoftCommand("DateInvoice");
                          break;
                        case "AmountTotal":
                          viewModel.selectSoftCommand("AmountTotal");
                          break;
                        case "Number":
                          viewModel.selectSoftCommand("Number");
                          break;
                      }
                    });
                  },
                  items: [
                    DropdownMenuItem<String>(
                        value: "DateInvoice",
                        child: Row(children: <Widget>[
                          Text("Ngày lập"),
                          viewModel.fastSaleOrderSort.value == "asc" &&
                                  viewModel.fastSaleOrderSort.orderBy ==
                                      "DateInvoice"
                              ? Icon(Icons.arrow_upward)
                              : Icon(Icons.arrow_downward)
                        ])),
                    DropdownMenuItem<String>(
                        value: "AmountTotal",
                        child: Row(children: <Widget>[
                          Text("Tổng tiền"),
                          viewModel.fastSaleOrderSort.value == "asc" &&
                                  viewModel.fastSaleOrderSort.orderBy ==
                                      "AmountTotal"
                              ? Icon(Icons.arrow_upward)
                              : Icon(Icons.arrow_downward)
                        ])),
                    DropdownMenuItem<String>(
                        value: "Number",
                        child: Row(children: <Widget>[
                          Text("Mã hóa đơn"),
                          viewModel.fastSaleOrderSort.value == "asc" &&
                                  viewModel.fastSaleOrderSort.orderBy ==
                                      "Number"
                              ? Icon(Icons.arrow_upward)
                              : Icon(Icons.arrow_downward)
                        ])),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Text(
                "Σ: ${NumberFormat("###,###,###,###").format(viewModel.invoiceTotal)}",
                style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: new GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState.openEndDrawer();
                },
                child: Badge(
                  badgeColor: Colors.redAccent,
                  badgeContent: Text(
                    "${viewModel.filterCount ?? 0}",
                    style: TextStyle(color: Colors.white),
                  ),
                  child: Row(
                    children: <Widget>[
                      Text("Lọc"),
                      Icon(
                        Icons.filter_list,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _showListFastSaleOrder() {
    return Container(
        color: Colors.grey.shade200,
        child: ScopedModelDescendant<FastSaleOrderListViewModel>(
          builder: (context, child, model) {
            return RefreshIndicator(
              key: refreshIndicatorKey,
              onRefresh: () async {
                return await viewModel.initData();
              },
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        //_showFilterPanel(),
                      ],
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: false,
                    floating: true,
                    delegate: FixedHeader(
                      child: _showFilterPanel(),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (context, index) => Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 8),
                              child: _showItem(viewModel.fastSaleOrders[index]),
                            ),
                        childCount: viewModel.fastSaleOrders?.length ?? 0),
                  ),
                ],
              ),
            );
          },
        ));
  }

  Widget _buildFilterDrawer(BuildContext context) {
    var theme = Theme.of(context);
    var disableTextStyle = TextStyle(color: Colors.grey.shade500);
    var enableTextStyle =
        TextStyle(color: Colors.black87, fontWeight: FontWeight.bold);
    return AppFilterDrawerContainer(
      onApply: viewModel.applyFilter,
      onRefresh: viewModel.resetFilter,
      child: ScopedModelDescendant<FastSaleOrderListViewModel>(
        builder: (context, _, __) => Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    AppFilterDateTime(
                      fromDate: viewModel.filterFromDate,
                      toDate: viewModel.filterToDate,
                      isSelected: viewModel.isFilterByDate,
                      initDateRange: viewModel.initFilterDate,
                      onSelectChange: (value) =>
                          viewModel.isFilterByDate = value,
                      onFromDateChanged: (value) =>
                          viewModel.filterFromDate = value,
                      onToDateChanged: (value) =>
                          viewModel.filterToDate = value,
                      dateRangeChanged: (value) {
                        viewModel.filterDateRange = value;
                      },
                    ),
                    AppFilterPanel(
                      isSelected: viewModel.isFilterByStatus,
                      title: Text("Lọc theo trạng thái"),
                      onSelectedChange: (value) =>
                          viewModel.isFilterByStatus = value,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: SizedBox(
                            child: Text(
                              "Chọn một trong nhiều trạng thái",
                              textAlign: TextAlign.left,
                              style: const TextStyle(color: Colors.blue),
                            ),
                            width: double.infinity,
                          ),
                        ),
                        ListView.builder(
                            padding: EdgeInsets.only(
                              left: 10,
                              right: 10,
                            ),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 0, right: 8, top: 8, bottom: 8),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(viewModel.filterStatus.any((f) =>
                                              f ==
                                              viewModel
                                                  .statusReports[index].value)
                                          ? Icons.check_circle
                                          : Icons.radio_button_unchecked),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${viewModel.statusReports[index].name} (${viewModel.statusReports[index].count})",
                                        ),
                                      ),
                                      Text(
                                        vietnameseCurrencyFormat(viewModel
                                                .statusReports[index]
                                                ?.totalAmount
                                                ?.toDouble() ??
                                            0),
                                        style:
                                            const TextStyle(color: Colors.red),
                                      )
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  viewModel.addFilterStatus(
                                      viewModel.statusReports[index].value);
                                },
                              );
                            },
                            itemCount: viewModel.statusReports?.length ?? 0),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                        "${viewModel.invoiceCount} / ${viewModel.listCount} HĐ"),
                  ),
                  Text(
                    viewModel.invoiceTotal.toStringFormat('###,###,###,###'),
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _showItem(FastSaleOrder item) {
    final statusTextColor =
        getFastSaleOrderStateOption(state: item.state).textColor;
    final statusPointColor = statusTextColor.withOpacity(0.3);
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5, left: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        gradient: new LinearGradient(
          stops: [0.015, 0.015],
          colors: [
            statusPointColor,
            Colors.white,
          ],
        ),
        border: Border.all(
          width: 0.3,
          color: statusPointColor,
        ),
      ),
      child: new Column(
        children: <Widget>[
          new ListTile(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  FastSaleOrderInfoPage orderDetailPage =
                      new FastSaleOrderInfoPage(
                    order: item,
                  );
                  return orderDetailPage;
                }),
              );
            },
            title: Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 10),
              child: Row(
                children: <Widget>[
                  new Expanded(
                    child: new Text(item.number ?? "HĐ NHÁP",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: getFastSaleOrderStateOption(state: item.state)
                              .textColor,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  new Expanded(
                    child: new Text(
                        "${vietnameseCurrencyFormat(item.amountTotal ?? 0) ?? ""}",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: getFastSaleOrderStateOption(state: item.state)
                              .textColor,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  InkWell(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Icon(
                          Icons.more_horiz,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    onTap: () {
                      _showBottomMenu(context, item);
                    },
                  ),
                ],
              ),
            ),
            subtitle: Column(
              children: <Widget>[
                new Text(
                  "${item.partnerDisplayName}",
                  style: TextStyle(color: Colors.black),
                ),
                new Divider(
                  color: Colors.grey.shade100,
                ),
                new Row(
                  children: <Widget>[
                    DecoratedBox(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: statusPointColor.withOpacity(0.5),
                            blurRadius: 8,
                            offset: Offset(0, 0),
                          )
                        ],
                        color: statusPointColor,
                        shape: BoxShape.circle,
                      ),
                      child: SizedBox(
                        height: 8,
                        width: 8,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "${item.showState ?? ""}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: getFastSaleOrderStateOption(state: item.state)
                              .textColor),
                      textAlign: TextAlign.left,
                    ),
                    Expanded(
                      child: Text(
                        "${DateFormat("dd/MM/yyyy  HH:mm").format(item.dateInvoice ?? DateTime.now())}",
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
            onLongPress: () {},
          )
        ],
      ),
    );
  }

  /// Danh sách tình trạng hóa đơn
  Widget _buildStatusFilter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 3.0, right: 3.0),
      child: Wrap(
        spacing: 1.0,
        runSpacing: 1.0,
        children: <Widget>[
          if (viewModel.statusReports != null)
            ...viewModel.statusReports
                ?.map(
                  (f) => FilterChip(
                    label: Text(
                        "${f.name} (${NumberFormat("###,###,###,###").format(f.totalAmount)})"),
                    onSelected: (isSelected) {
                      setState(() {
                        f.isChecked = isSelected;
                      });
                    },
                    selected: f.isChecked,
                    backgroundColor: Colors.grey,
                    selectedColor: Colors.green,
                    selectedShadowColor: Colors.green,
                  ),
                )
                ?.toList(),
        ],
      ),
    );
  }

  void _showBottomMenu(BuildContext context, FastSaleOrder order) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return BottomSheet(
            shape: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            onClosing: () {},
            builder: (context) => ListView(
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.print),
                  title: Text("In phiếu ship"),
                  onTap: () {
                    Navigator.pop(context);
                    viewModel.printShipOrderCommand(order.id);
                  },
                ),
                Divider(
                  height: 1,
                ),
                ListTile(
                  leading: Icon(Icons.print),
                  title: Text("In hóa đơn"),
                  onTap: () {
                    Navigator.pop(context);
                    viewModel.printInvoiceCommand(order.id);
                  },
                ),
                Divider(
                  height: 1,
                ),
                ListTile(
                  leading: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  title: Text(
                    "Xóa hóa đơn",
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    viewModel.deleteOrder(order);
                  },
                ),
                Divider(
                  height: 1,
                ),
              ],
            ),
          );
        });
  }
}

class FilterButton extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Color selectedColor;
  final VoidCallback onTap;
  final bool isSelected;
  FilterButton(
      {this.selectedColor,
      this.backgroundColor = Colors.white,
      this.child,
      this.onTap,
      this.isSelected = false});
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isSelected ? Colors.green : Colors.grey.shade200,
        border: isSelected
            ? Border.all(color: Colors.green, width: 2)
            : Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(3),
      ),
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              child,
              Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

class FixedHeader extends SliverPersistentHeaderDelegate {
  final Widget child;
  FixedHeader({this.child});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.indigo,
      height: 100,
      child: child,
    );
  }

  @override
  double get maxExtent => 45;

  @override
  double get minExtent => 45;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
