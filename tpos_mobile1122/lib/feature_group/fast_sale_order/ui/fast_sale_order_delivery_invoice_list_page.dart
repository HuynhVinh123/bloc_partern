/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 7/5/19 4:54 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 7/5/19 8:45 AM
 *
 */

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

import 'package:tpos_mobile/app_core/template_ui/app_filter_datetime.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_drawer.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_panel.dart';
import 'package:tpos_mobile/app_core/template_ui/app_list_empty_notify.dart';
import 'package:tpos_mobile/app_core/template_ui/app_load_more_button.dart';
import 'package:tpos_mobile/app_core/ui_base/ui_base.dart';

import 'package:tpos_mobile/feature_group/fast_sale_order/viewmodels/fast_sale_order_delivery_invoice_list_viewmodel.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/delivery_carrier_search_page.dart';

import 'package:tpos_mobile/helpers/helpers.dart';


import 'package:tpos_mobile/widgets/appbar_search_widget.dart';
import 'package:tpos_mobile/widgets/custom_widget.dart';

import '../../../resources/app_route.dart';
import 'fast_sale_order_info_page.dart';
import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';

class FastSaleDeliveryInvoicePage extends StatefulWidget {
  @override
  _FastSaleDeliveryInvoicePageState createState() =>
      _FastSaleDeliveryInvoicePageState();
}

class _FastSaleDeliveryInvoicePageState
    extends State<FastSaleDeliveryInvoicePage> {
  Key refreshIndicatorKey = new Key("refreshIndicator");
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  FastSaleDeliveryInvoiceViewModel viewModel =
      new FastSaleDeliveryInvoiceViewModel();

  bool _isEnableSearch = false;

  @override
  void initState() {
    viewModel.init();
    viewModel.initData();
    super.initState();
    viewModel.dialogMessageController.listen((data) {
      registerDialogToView(context, data,
          scaffState: _scaffoldKey.currentState);
    });
    viewModel.notifyPropertyChangedController.listen((notify) {
      if (mounted) setState(() {});
    });

    viewModel.eventController.listen((event) {
      if (event.eventName == "GO_BACK") {
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UIViewModelBase<FastSaleDeliveryInvoiceViewModel>(
      viewModel: viewModel,
      child: new Scaffold(
        backgroundColor: Colors.grey.shade300,
        key: _scaffoldKey,
        endDrawer: _showDrawerRight(context),
        appBar: new AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: _isEnableSearch
                ? AppbarSearchWidget(
                    autoFocus: true,
                    keyword: viewModel.keyword,
                    onTextChange: (value) {
                      viewModel.searchOrderCommand(value);
                    },
                  )
                : Text("HĐ giao hàng"),
          ),
          actions: <Widget>[
            new IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _isEnableSearch = !_isEnableSearch;
                });
              },
            ),
            new IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoute.addFastSaleOrder,
                );
              },
            ),
            new PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text("Cập nhật trạng thái GH tất cả"),
                  value: "update_delivery_state",
                ),
                PopupMenuItem(
                  child: Text("Cấu hình"),
                  value: "option",
                ),
                PopupMenuItem(
                  child: Text("Xuất Excel"),
                  value: "exportExcel",
                ),
                PopupMenuItem(
                  child: Text("Xuất Excel chi tiết"),
                  value: "exportExcelDetail",
                ),
              ],
              onSelected: (selected) {
                print(selected);
                switch (selected) {
                  case "update_delivery_state":
                    viewModel.updateDeliveryState();
                    break;
                  case "option":
                    Navigator.pushNamed(
                      context,
                      AppRoute.setting,
                      arguments: {},
                    );
                    break;
                  case "exportExcel":
                    viewModel.exportExcel(this.context);
                    break;
                  case "exportExcelDetail":
                    viewModel.exportExcelDetail(this.context);
                    break;
                }
              },
            ),
          ],
        ),
        body: ScopedModelDescendant<FastSaleDeliveryInvoiceViewModel>(
          builder: (_, __, ___) => Column(
            children: <Widget>[
              _showSearchResult(),
              if (viewModel.isSelectEnable) _showSelectMenu(),
              new Expanded(
                child: new Scrollbar(
                  child: _showListFastSaleOrder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Menu khi chọn nhiều item
  Widget _showSelectMenu() {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: <Widget>[
          Checkbox(
            value: viewModel.isSelectAll,
            onChanged: (value) => viewModel.isSelectAll = value,
          ),
          Text("${viewModel.selectedCount}"),
          Spacer(),
          PopupMenuButton(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Row(children: <Widget>[
                  Text("Chọn thao tác"),
                  Icon(Icons.arrow_drop_down),
                ]),
              ),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("In hóa đơn"),
                value: "PRINT_INVOICE",
              ),
              PopupMenuItem(
                child: Text("In phiếu ship"),
                value: "PRINT_SHIP",
              ),
              PopupMenuItem(
                child: Text("Tải phiếu ship PDF"),
                value: "PRINT_SHIP_PDF",
              ),
              PopupMenuItem(
                child: Text("Cập nhật trạng thái giao hàng"),
                value: "REFRESH_DELIVERY_STATUS",
              ),
              PopupMenuItem(
                child: Text("Hủy vận đơn"),
                value: "CANCEL_SHIP",
              ),
              PopupMenuItem(
                child: Text("Hủy hóa đơn"),
                value: "CANCEL_INVOICE",
              ),
              PopupMenuItem(
                child: Text("Xuất Excel"),
                value: "exportExcelSelected",
              ),
              PopupMenuItem(
                child: Text("Xuất Excel chi tiết"),
                value: "exportExcelDetailSelected",
              ),
            ],
            onSelected: (value) async {
              switch (value) {
                case "PRINT_INVOICE":
                  viewModel.printOrders();
                  break;
                case "PRINT_SHIP":
                  viewModel.printShips();
                  break;
                case "PRINT_SHIP_PDF":
                  viewModel.printShips(isDownloadOkiela: true);
                  break;
                case "REFRESH_DELIVERY_STATUS":
                  var dialogResult = await showQuestion(
                      context: context,
                      title: "Vui lòng xác nhận",
                      message:
                          "Bạn có muốn cập nhật trạng thái giao hàng các hóa đơn đang chọn?");

                  if (dialogResult == OldDialogResult.Yes) {
                    viewModel.updateDeliveryInfo(null);
                  }
                  break;
                case "CANCEL_SHIP":
                  var dialogResult = await showQuestion(
                      context: context,
                      title: "Vui lòng xác nhận",
                      message: "Phiếu ship sẽ bị hủy. Bạn có đồng ý không?");

                  if (dialogResult == OldDialogResult.Yes) {
                    viewModel.cancelShips(null);
                  }

                  break;
                case "CANCEL_INVOICE":
                  var dialogResult = await showQuestion(
                      context: context,
                      title: "Vui lòng xác nhận",
                      message:
                          "Các hóa đơn được chọn sẽ bị hủy? Bạn có đồng ý không?");

                  if (dialogResult == OldDialogResult.Yes) {
                    viewModel.canncelInvoices(null);
                  }

                  break;
                case "exportExcelSelected":
                  viewModel.exportExcel(this.context);
                  break;
                case "exportExcelDetailSelected":
                  viewModel.exportExcelDetail(this.context);
                  break;
              }
            },
          ),
          const SizedBox(
            width: 10,
          ),
          OutlineButton(
            textColor: Colors.red,
            child: Text("Đóng"),
            onPressed: () {
              viewModel.isSelectEnable = false;
            },
          ),
        ],
      ),
    );
  }

  Widget _showSearchResult() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.grey,
          blurRadius: 1,
        ),
      ]),
      height: 50,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: DropdownButtonHideUnderline(
              child: new DropdownButton<String>(
                value: viewModel.fastSaleDeliveryInvoiceSort.orderBy,
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
                        viewModel.fastSaleDeliveryInvoiceSort.value == "asc" &&
                                viewModel.fastSaleDeliveryInvoiceSort.orderBy ==
                                    "DateInvoice"
                            ? Icon(Icons.arrow_upward)
                            : Icon(Icons.arrow_downward)
                      ])),
                  DropdownMenuItem<String>(
                      value: "AmountTotal",
                      child: Row(children: <Widget>[
                        Text("Tổng tiền"),
                        viewModel.fastSaleDeliveryInvoiceSort.value == "asc" &&
                                viewModel.fastSaleDeliveryInvoiceSort.orderBy ==
                                    "AmountTotal"
                            ? Icon(Icons.arrow_upward)
                            : Icon(Icons.arrow_downward)
                      ])),
                  DropdownMenuItem<String>(
                      value: "Number",
                      child: Row(children: <Widget>[
                        Text("Mã hóa đơn"),
                        viewModel.fastSaleDeliveryInvoiceSort.value == "asc" &&
                                viewModel.fastSaleDeliveryInvoiceSort.orderBy ==
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
              "Σ: ${NumberFormat("###,###,###,###").format(viewModel.totalAmount)}",
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
          ),
        ],
      ),
    );
  }

  Widget _showListFastSaleOrder() {
    return ScopedModelDescendant<FastSaleDeliveryInvoiceViewModel>(
      builder: (context, _, __) => RefreshIndicator(
          key: refreshIndicatorKey,
          onRefresh: () async {
            return await viewModel.initData();
          },
          child: viewModel.orderCount > 0
              ? _buildListItem()
              : _buildListItemNull()),
    );
  }

  Widget _buildListItem() {
    return ListView.separated(
      padding: EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
      itemCount: viewModel.orderCount + 1,
      separatorBuilder: (ctx, index) {
        if ((index + 1) % viewModel.take == 0) {
          return Container(
            margin: EdgeInsets.only(top: 8, bottom: 8),
            padding: EdgeInsets.all(8),
            color: Colors.blue.shade100,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Trang ${(index + 1) ~/ viewModel.take + 1}",
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
                Text(
                  "${index + 2} -> ${index + 1 + viewModel.take}]",
                  style: const TextStyle(color: Colors.blue),
                ),
              ],
            ),
          );
        }

        return SizedBox(
          height: 8,
        );
      },
      itemBuilder: (context, index) {
        if (index == viewModel.orderCount) if (viewModel.canLoadMore)
          return AppLoadMoreButton(
            label: "Tải thêm...",
            onPressed: viewModel.loadMoreItem,
            onLongPressed: viewModel.loadAllMoreItem,
            isLoading: viewModel.isLoadingMore,
          );
        else
          return SizedBox();

        return _showItem(viewModel.fastSaleDeliveryInvoices[index]);
      },
    );
  }

  Widget _buildListItemNull() {
    if (viewModel.isBusy) return SizedBox();
    return AppListEmptyNotify(
      title: Text(
        "Không có dữ liệu",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      message: Text(viewModel.dataNotifyString),
      actions: <Widget>[
        if (viewModel.filterCount > 0)
          OutlineButton(
            child: Text("Tùy chọn lọc"),
            onPressed: () {
              _scaffoldKey.currentState.openEndDrawer();
            },
          ),
        OutlineButton.icon(
          icon: Icon(Icons.refresh),
          label: Text("Thử lại"),
          onPressed: () {
            viewModel.initData();
          },
        ),
      ],
    );
  }

  Widget _showItem(FastSaleOrder item) {
    final theme = Theme.of(context);
    final statusTextColor =
        getFastSaleOrderStateOption(state: item.state).textColor;
    final statusPointColor = statusTextColor.withOpacity(0.3);
    final contentTextStyle =
        const TextStyle(fontSize: 13, color: Colors.black54);
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
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
          padding: EdgeInsets.only(left: 16, right: 0, bottom: 8),
          child: new ListTile(
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
            leading: viewModel.isSelectEnable
                ? Checkbox(
                    value: item.isSelected,
                    onChanged: (value) {
                      setState(() {
                        item.isSelected = value;
                      });
                    },
                  )
                : null,
            contentPadding: EdgeInsets.only(right: 12),
            title: Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 10),
              child: Row(
                children: <Widget>[
                  new Expanded(
                    child: Text(
                      "${item.number}",
                      style: TextStyle(
                        color: getFastSaleOrderStateOption(state: item.state)
                            .textColor,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  new Text(
                    "${vietnameseCurrencyFormat(item.cashOnDelivery ?? 0) ?? ""}",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: getFastSaleOrderStateOption(state: item.state)
                          .textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 30,
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
                SizedBox(
                  height: 5,
                ),
                new RichText(
                  text: TextSpan(
                      text:
                          "${item.carrierName} ${item.trackingRef != null ? "Mã vận đơn: ${item.trackingRef}" : ""}",
                      style: contentTextStyle,
                      children: [
                        TextSpan(
                          text: " (${item.shipPaymentStatus ?? "n/a"})",
                          style: contentTextStyle.copyWith(color: Colors.blue),
                        )
                      ]),
                ),
                new SizedBox(
                  height: 10,
                ),
                new Row(
                  children: <Widget>[
                    DecoratedBox(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: statusTextColor.withOpacity(0.8),
                            blurRadius: 8,
                            offset: Offset(0, 0),
                          )
                        ],
                        color: statusTextColor,
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
                          fontWeight: FontWeight.normal,
                          color: getFastSaleOrderStateOption(state: item.state)
                              .textColor),
                      textAlign: TextAlign.left,
                    ),
                    Expanded(
                      child: Text(
                        "${DateFormat("dd/MM/yyyy HH:mm").format(item.dateInvoice)}",
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
            onLongPress: () {
              if (viewModel.isSelectEnable == false) {
                viewModel.isSelectEnable = true;
              }
              setState(() {
                item.isSelected = true;
              });
            },
          ),
        ),
        Positioned(
          right: 0,
          top: -7,
          child: IconButton(
            icon: Icon(Icons.more_horiz),
            onPressed: () {
              _showBottomMenu(context, item);
            },
          ),
        ),
      ],
    );
  }

  Widget _showDrawerRight(BuildContext context) {
    var theme = Theme.of(context);
    return AppFilterDrawerContainer(
      onApply: viewModel.applyFilter,
      onRefresh: viewModel.resetFilter,
      child: ScopedModelDescendant<FastSaleDeliveryInvoiceViewModel>(
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
                      initDateRange: viewModel.filterDateRange,
                      onSelectChange: (value) =>
                          viewModel.isFilterByDate = value,
                      onFromDateChanged: (value) => viewModel.fromDate = value,
                      onToDateChanged: (value) => viewModel.toDate = value,
                      dateRangeChanged: (value) {
                        viewModel.filterDateRange = value;
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 1,
                    ),
                    AppFilterPanel(
                      isSelected: viewModel.isFilterByStatus,
                      title: Text("Theo trạng thái"),
                      onSelectedChange: (value) =>
                          viewModel.isFilterByStatus = value,
                      children: <Widget>[
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
                                      Icon(viewModel.filterStatus?.name ==
                                              viewModel
                                                  .deliveryStatus[index].name
                                          ? Icons.check_circle
                                          : Icons.radio_button_unchecked),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${viewModel.deliveryStatus[index].name} (${viewModel.deliveryStatus[index].count})",
                                        ),
                                      ),
                                      Text(
                                        vietnameseCurrencyFormat(viewModel
                                                .deliveryStatus[index]
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
                                  viewModel.status =
                                      viewModel.deliveryStatus[index];
                                },
                              );
                            },
                            itemCount: viewModel.deliveryStatus?.length ?? 0),
                      ],
                    ),
//                    AppFilterPanel(
//                      title: Text("Lọc theo khách hàng"),
//                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 1,
                    ),

                    AppFilterPanel(
                      isSelected: viewModel.isFilterDeliveryCarrier,
                      title: Text("Theo đối tác giao hàng"),
                      onSelectedChange: (value) =>
                          viewModel.isFilterDeliveryCarrier = value,
                      children: <Widget>[
                        InkWell(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => DeliveryCarrierSearchPage(
                                  closeWhenDone: true,
                                  isSearch: true,
                                ),
                              ),
                            ).then((value) {
                              if (value != null) {
                                viewModel.deliveryCarrier = value;
                              }
                            });
                          },
                          child: Row(
                            children: <Widget>[
                              const SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(
                                    "${viewModel.deliveryCarrier == null ? "<Chọn đối tác>" : "${viewModel.deliveryCarrier.name}"}",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: viewModel.deliveryCarrier != null,
                                child: InkWell(
                                  onTap: () {
                                    viewModel.deliveryCarrier = null;
                                  },
                                  child: Container(
                                    width: 35,
                                    height: 25,
                                    child: Icon(Icons.close,
                                        color: Colors.grey[600], size: 18),
                                  ),
                                ),
                              ),
                              Icon(Icons.chevron_right,
                                  color: Colors.grey[700], size: 20),
                              const SizedBox(
                                width: 8,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        )
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
                        "${viewModel.fastSaleDeliveryInvoices?.length ?? 0} / ${viewModel.listCount} HĐ"),
                  ),
                  Text(
                    viewModel.totalAmount.toStringFormat("###,###,###"),
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

  void _showBottomMenu(BuildContext context, FastSaleOrder order) {
    showModalBottomSheet(
      context: context,
      shape: const OutlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        borderSide: BorderSide.none,
      ),
      builder: (context) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            ListTile(
              title: Text(
                "Hóa đon GH: ${order.number}",
                style: const TextStyle(color: Colors.blue),
              ),
              subtitle: Column(
                children: <Widget>[
                  InfoRow(
                    titleString: 'Đơn vị giao:  ',
                    contentString: '${order.carrierName ?? "N/A"}',
                  ),
                  InfoRow(
                    titleString: 'Mã vận đơn:  ',
                    contentString: '${order.trackingRef ?? "N/A"}',
                  ),
                  InfoRow(
                    titleString: 'Tổng tiền ',
                    contentString: NumberFormat('###,###,###')
                        .format(order.amountTotal ?? 0),
                  ),
                  InfoRow(
                    titleString: 'Phí giao hàng (Đối tác): ',
                    contentString: NumberFormat('###,###,###')
                        .format(order.customerDeliveryPrice ?? 0),
                  ),
                  InfoRow(
                    titleString: 'Phí giao hàng (Shop): ',
                    contentString: NumberFormat('###,###,###')
                        .format(order.deliveryPrice ?? 0),
                  ),
                  InfoRow(
                    titleString: 'Thu hộ): ',
                    contentString: NumberFormat('###,###,###')
                        .format(order.cashOnDelivery ?? 0),
                  ),
                  Row(
                    children: <Widget>[
                      Spacer(),
                      FlatButton(
                        child: Text(
                          'Xem thêm...',
                          style: const TextStyle(color: Colors.blue),
                          textAlign: TextAlign.right,
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              FastSaleOrderInfoPage orderDetailPage =
                                  new FastSaleOrderInfoPage(
                                order: order,
                              );
                              return orderDetailPage;
                            }),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              height: 1,
            ),
            ListTile(
              leading: Icon(Icons.print),
              title: Text("In phiếu ship"),
              onTap: () {
                Navigator.pop(context);
                viewModel.printShipOrderCommand(order.id);
              },
            ),
            if (order?.carrierDeliveryType == "OkieLa") ...[
              const Divider(
                height: 1,
              ),
              ListTile(
                leading: Icon(Icons.print),
                title: Text("Tải về phiếu ship PDF"),
                onTap: () {
                  Navigator.pop(context);
                  viewModel.printShipOrderCommand(
                    order.id,
                    isDownloadOkiela: true,
                  );
                },
              ),
            ],
            const Divider(
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
          ],
        );
      },
    );
  }
}
