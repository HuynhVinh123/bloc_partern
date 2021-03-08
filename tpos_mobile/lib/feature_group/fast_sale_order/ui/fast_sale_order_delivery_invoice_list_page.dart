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
import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';
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
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import '../../../resources/app_route.dart';
import 'fast_sale_order_info_page.dart';

class FastSaleDeliveryInvoicePage extends StatefulWidget {
  @override
  _FastSaleDeliveryInvoicePageState createState() =>
      _FastSaleDeliveryInvoicePageState();
}

class _FastSaleDeliveryInvoicePageState
    extends State<FastSaleDeliveryInvoicePage> {
  Key refreshIndicatorKey = const Key("refreshIndicator");
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  FastSaleDeliveryInvoiceViewModel viewModel =
      FastSaleDeliveryInvoiceViewModel();

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
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        key: _scaffoldKey,
        endDrawer: _showDrawerRight(context),
        appBar: AppBar(
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
                // HĐ giao hàng
                : Text(S.current.fastSaleOrder_DeliveryInvoices),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _isEnableSearch = !_isEnableSearch;
                });
              },
            ),
            IconButton(
              icon: const Icon(
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
            PopupMenuButton(
              itemBuilder: (context) => [
                // Cập nhật trạng thái GH tất cả
                PopupMenuItem(
                  child: Text(S.current.fastSaleOrder_UpdateDeliveryStatusAll),
                  value: "update_delivery_state",
                ),
                // Cấu hình
                PopupMenuItem(
                  child: Text(S.current.configuration),
                  value: "option",
                ),
                //Xuất Excel
                PopupMenuItem(
                  child: Text(S.current.export_excel),
                  value: "exportExcel",
                ),
                //Xuất Excel chi tiết
                PopupMenuItem(
                  child:
                      Text("${S.current.export_excel} (${S.current.detail})"),
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
              Expanded(
                child: Scrollbar(
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
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: <Widget>[
          Checkbox(
            value: viewModel.isSelectAll,
            onChanged: (value) => viewModel.isSelectAll = value,
          ),
          Text("${viewModel.selectedCount}"),
          const Spacer(),
          PopupMenuButton(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Row(children: <Widget>[
                  // Chọn thao tác
                  Text(S.current.fastSaleOrder_ChooseAction),
                  const Icon(Icons.arrow_drop_down),
                ]),
              ),
            ),
            itemBuilder: (context) => [
              //In hóa đơn
              PopupMenuItem(
                child: Text(S.current.printInvoice),
                value: "PRINT_INVOICE",
              ),
              // In phiếu ship
              PopupMenuItem(
                child: Text(S.current.saleOrder_printShipSlip),
                value: "PRINT_SHIP",
              ),
              // Tải phiếu ship PDF
              PopupMenuItem(
                child: Text("${S.current.saleOrder_downloadShipSlip} PDF"),
                value: "PRINT_SHIP_PDF",
              ),
              //Cập nhật trạng thái giao hàn
              PopupMenuItem(
                child: Text(S.current.fastSaleOrder_UpdateDeliveryStatus),
                value: "REFRESH_DELIVERY_STATUS",
              ),
              //Hủy vận đơn
              PopupMenuItem(
                child: Text(S.current.cancelBillOfLading),
                value: "CANCEL_SHIP",
              ),
              // Hủy hóa đơn
              PopupMenuItem(
                child: Text(S.current.saleOrder_cancel),
                value: "CANCEL_INVOICE",
              ),
              // Xuất Excel
              PopupMenuItem(
                child: Text(S.current.export_excel),
                value: "exportExcelSelected",
              ),
              //Xuất Excel chi tiết
              PopupMenuItem(
                child: Text("${S.current.export_excel} (${S.current.detail})"),
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
                  final dialogResult = await showQuestion(
                      context: context,
                      // Vui lòng xác nhận
                      title: S.current.pleaseConfirm,
                      // Bạn có muốn cập nhật trạng thái giao hàng các hóa đơn đang chọn?
                      message:
                          S.current.fastSaleOrder_InfoRefreshDeliveryStatus);

                  if (dialogResult == OldDialogResult.Yes) {
                    viewModel.updateDeliveryInfo(null);
                  }
                  break;
                case "CANCEL_SHIP":
                  final dialogResult = await showQuestion(
                      context: context,
                      // Vui lòng xác nhận
                      title: S.current.pleaseConfirm,
                      // Phiếu ship sẽ bị hủy. Bạn có đồng ý không?
                      message: S.current.fastSaleOrder_InfoCancelShip);

                  if (dialogResult == OldDialogResult.Yes) {
                    viewModel.cancelShips(null);
                  }

                  break;
                case "CANCEL_INVOICE":
                  final dialogResult = await showQuestion(
                      context: context,
                      title: S.current.pleaseConfirm,
                      // Các hóa đơn được chọn sẽ bị hủy? Bạn có đồng ý không?
                      message: S.current.fastSaleOrder_InfoCancelInvoice);

                  if (dialogResult == OldDialogResult.Yes) {
                    viewModel.canncelInvoices(null);
                  }

                  break;
                case "exportExcelSelected":
                  viewModel.exportExcel(context);
                  break;
                case "exportExcelDetailSelected":
                  viewModel.exportExcelDetail(context);
                  break;
              }
            },
          ),
          const SizedBox(
            width: 10,
          ),
          OutlineButton(
            textColor: Colors.red,
            child: Text(S.current.close),
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
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [
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
              child: DropdownButton<String>(
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
                        // Ngày lập
                        Text(S.current.fastSaleOrder_DateCreated),
                        if (viewModel.fastSaleDeliveryInvoiceSort.value ==
                                "asc" &&
                            viewModel.fastSaleDeliveryInvoiceSort.orderBy ==
                                "DateInvoice")
                          const Icon(Icons.arrow_upward)
                        else
                          const Icon(Icons.arrow_downward)
                      ])),
                  DropdownMenuItem<String>(
                      value: "AmountTotal",
                      child: Row(children: <Widget>[
                        //Tổng tiền
                        Text(S.current.fastSaleOrder_AmountTotal),
                        if (viewModel.fastSaleDeliveryInvoiceSort.value ==
                                "asc" &&
                            viewModel.fastSaleDeliveryInvoiceSort.orderBy ==
                                "AmountTotal")
                          const Icon(Icons.arrow_upward)
                        else
                          const Icon(Icons.arrow_downward)
                      ])),
                  DropdownMenuItem<String>(
                      value: "Number",
                      child: Row(children: <Widget>[
                        // Mã hóa đơn
                        Text(S.current.fastSaleOrder_InvoiceCode),
                        if (viewModel.fastSaleDeliveryInvoiceSort.value ==
                                "asc" &&
                            viewModel.fastSaleDeliveryInvoiceSort.orderBy ==
                                "Number")
                          const Icon(Icons.arrow_upward)
                        else
                          const Icon(Icons.arrow_downward)
                      ])),
                ],
              ),
            ),
          ),
          Expanded(
            child: Text(
              "Σ: ${NumberFormat("###,###,###,###").format(viewModel.totalAmount)}",
              style: const TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: GestureDetector(
              onTap: () {
                _scaffoldKey.currentState.openEndDrawer();
              },
              child: Badge(
                badgeColor: Colors.redAccent,
                badgeContent: Text(
                  "${viewModel.filterCount ?? 0}",
                  style: const TextStyle(color: Colors.white),
                ),
                child: Row(
                  children: <Widget>[
                    Text(S.current.filter),
                    const Icon(
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
      padding: const EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
      itemCount: viewModel.orderCount + 1,
      separatorBuilder: (ctx, index) {
        if ((index + 1) % viewModel.take == 0) {
          return Container(
            margin: const EdgeInsets.only(top: 8, bottom: 8),
            padding: const EdgeInsets.all(8),
            color: Colors.blue.shade100,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "${S.current.page} ${(index + 1) ~/ viewModel.take + 1}",
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

        return const SizedBox(
          height: 8,
        );
      },
      itemBuilder: (context, index) {
        if (index == viewModel.orderCount) if (viewModel.canLoadMore)
          //Tải thêm
          return AppLoadMoreButton(
            label: "${S.current.loadMore}...",
            onPressed: viewModel.loadMoreItem,
            onLongPressed: viewModel.loadAllMoreItem,
            isLoading: viewModel.isLoadingMore,
          );
        else
          return const SizedBox();

        return _showItem(viewModel.fastSaleDeliveryInvoices[index]);
      },
    );
  }

  Widget _buildListItemNull() {
    if (viewModel.isBusy) return const SizedBox();
    return AppListEmptyNotify(
      title: Text(
        S.current.noData,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      message: Text(viewModel.dataNotifyString),
      actions: <Widget>[
        if (viewModel.filterCount > 0)
          OutlineButton(
            child: Text(S.current.filter),
            onPressed: () {
              _scaffoldKey.currentState.openEndDrawer();
            },
          ),
        OutlineButton.icon(
          icon: const Icon(Icons.refresh),
          label: Text(S.current.retry),
          onPressed: () {
            viewModel.initData();
          },
        ),
      ],
    );
  }

  Widget _showItem(FastSaleOrder item) {
    final statusTextColor =
        getFastSaleOrderStateOption(state: item.state).textColor;
    final statusPointColor = statusTextColor.withOpacity(0.3);
    const contentTextStyle = TextStyle(fontSize: 13, color: Colors.black54);
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            gradient: LinearGradient(
              stops: const [0.015, 0.015],
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
          padding: const EdgeInsets.only(left: 16, right: 0, bottom: 8),
          child: ListTile(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  final FastSaleOrderInfoPage orderDetailPage =
                      FastSaleOrderInfoPage(
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
            contentPadding: const EdgeInsets.only(right: 12),
            title: Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      item.number ?? "",
                      style: TextStyle(
                        color: getFastSaleOrderStateOption(state: item.state)
                            .textColor,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Text(
                    vietnameseCurrencyFormat(item.cashOnDelivery ?? 0) ?? "",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: getFastSaleOrderStateOption(state: item.state)
                          .textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                ],
              ),
            ),
            subtitle: Column(
              children: <Widget>[
                Text(
                  item.partnerDisplayName ?? "",
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(
                  height: 5,
                ),
                // Mã vận đơn
                RichText(
                  text: TextSpan(
                      text:
                          "${item.carrierName} ${item.trackingRef != null ? "${S.current.saleOrder_billOfLadingCode}: ${item.trackingRef}" : ""}",
                      style: contentTextStyle,
                      children: [
                        TextSpan(
                          text: " (${item.shipPaymentStatus ?? "n/a"})",
                          style: contentTextStyle.copyWith(color: Colors.blue),
                        )
                      ]),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    DecoratedBox(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: statusTextColor.withOpacity(0.8),
                            blurRadius: 8,
                            offset: const Offset(0, 0),
                          )
                        ],
                        color: statusTextColor,
                        shape: BoxShape.circle,
                      ),
                      child: const SizedBox(
                        height: 8,
                        width: 8,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      item.showState ?? "",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: getFastSaleOrderStateOption(state: item.state)
                              .textColor),
                      textAlign: TextAlign.left,
                    ),
                    Expanded(
                      child: Text(
                        DateFormat("dd/MM/yyyy HH:mm").format(item.dateInvoice),
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
            icon: const Icon(Icons.more_horiz),
            onPressed: () {
              _showBottomMenu(context, item);
            },
          ),
        ),
      ],
    );
  }

  Widget _showDrawerRight(BuildContext context) {
    return ScopedModelDescendant<FastSaleDeliveryInvoiceViewModel>(
        builder: (_, __, model) => AppFilterDrawerContainer(
              closeWhenConfirm: false,
              countFilter: model.filterCount,
              onApply: () {
                if (model.validateFilter()) {
                  model.applyFilter();
                  Navigator.pop(context);
                }
              },
              onRefresh: () {
                model.resetFilter();
                Navigator.pop(context);
              },
              onClosed: () {
                model.undoFilter();
              },
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          AppFilterDateTime(
                            fromDate: model.filterFromDate,
                            toDate: model.filterToDate,
                            isSelected: model.isFilterByDateTemp,
                            initDateRange: model.filterDateRange,
                            onSelectChange: (value) =>
                                model.isFilterByDateTemp = value,
                            onFromDateChanged: (value) =>
                                model.fromDate = value,
                            onToDateChanged: (value) => model.toDate = value,
                            dateRangeChanged: (value) {
                              model.filterDateRange = value;
                            },
                          ),
                          // Lọc theo trạng thái
                          AppFilterPanel(
                            isSelected: model.isFilterByStatusTemp,
                            title: Text(S.current.filterByStatus),
                            onSelectedChange: (value) =>
                                model.isFilterByStatusTemp = value,
                            children: <Widget>[
                              ListView.builder(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                  ),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 0,
                                            right: 8,
                                            top: 8,
                                            bottom: 8),
                                        child: Row(
                                          children: <Widget>[
                                            Icon(model.filterStatus?.name ==
                                                    model.deliveryStatus[index]
                                                        .name
                                                ? Icons.check_circle
                                                : Icons.radio_button_unchecked),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Text(
                                                "${model.deliveryStatus[index].name} (${viewModel.deliveryStatus[index].count})",
                                              ),
                                            ),
                                            Text(
                                              vietnameseCurrencyFormat(model
                                                      .deliveryStatus[index]
                                                      ?.totalAmount
                                                      ?.toDouble() ??
                                                  0),
                                              style: const TextStyle(
                                                  color: Colors.red),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        model.status =
                                            model.deliveryStatus[index];
                                      },
                                    );
                                  },
                                  itemCount: model.deliveryStatus?.length ?? 0),
                            ],
                          ),
//                    AppFilterPanel(
//                      title: Text("Lọc theo khách hàng"),
//                    ),
                          // Theo đối tác giao hàng
                          AppFilterPanel(
                            isSelected: viewModel.isFilterByDeliveryCarrierTemp,
                            title: Text(S.current.filterByDeliveryPartner),
                            onSelectedChange: (value) =>
                                viewModel.isFilterByDeliveryCarrierTemp = value,
                            children: <Widget>[
                              InkWell(
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (ctx) =>
                                          const DeliveryCarrierSearchPage(
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
                                          viewModel.deliveryCarrier == null
                                              ? "<${S.current.fastSaleOrder_ChoosePartner}>"
                                              : viewModel.deliveryCarrier.name,
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible:
                                          viewModel.deliveryCarrier != null,
                                      child: InkWell(
                                        onTap: () {
                                          viewModel.deliveryCarrier = null;
                                        },
                                        child: Container(
                                          width: 35,
                                          height: 25,
                                          child: Icon(Icons.close,
                                              color: Colors.grey[600],
                                              size: 18),
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
                              const SizedBox(
                                height: 12,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                              "${viewModel.fastSaleDeliveryInvoices?.length ?? 0} / ${viewModel.totalCount} HĐ"),
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
            ));
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
              // Hóa đon GH
              title: Text(
                "${S.current.fastSaleOrder_DeliveryInvoice}: ${order.number}",
                style: const TextStyle(color: Colors.blue),
              ),
              subtitle: Column(
                children: <Widget>[
                  // Đơn vị giao
                  InfoRow(
                    titleString:
                        '${S.current.fastSaleOrder_DeliveryCarrier}:  ',
                    contentString: order.carrierName ?? "N/A",
                  ),
                  //Mã vận đơn
                  InfoRow(
                    titleString: '${S.current.saleOrder_billOfLadingCode}:  ',
                    contentString: order.trackingRef ?? "N/A",
                  ),
                  InfoRow(
                    titleString: '${S.current.saleOrder_amountTotal} ',
                    contentString: NumberFormat('###,###,###')
                        .format(order.amountTotal ?? 0),
                  ),
                  //Phí giao hàng (Đối tác)
                  InfoRow(
                    titleString: '${S.current.deliveryCarrierFee}: ',
                    contentString: NumberFormat('###,###,###')
                        .format(order.customerDeliveryPrice ?? 0),
                  ),
                  //Phí giao hàng (Shop)
                  InfoRow(
                    titleString: '${S.current.shippingFee} (Shop): ',
                    contentString: NumberFormat('###,###,###')
                        .format(order.deliveryPrice ?? 0),
                  ),
                  InfoRow(
                    titleString: '${S.current.cashOnDelivery}: ',
                    contentString: NumberFormat('###,###,###')
                        .format(order.cashOnDelivery ?? 0),
                  ),
                  Row(
                    children: <Widget>[
                      const Spacer(),
                      FlatButton(
                        child: Text(
                          '${S.current.loadMore}...',
                          style: const TextStyle(color: Colors.blue),
                          textAlign: TextAlign.right,
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              final FastSaleOrderInfoPage orderDetailPage =
                                  FastSaleOrderInfoPage(
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
              leading: const Icon(Icons.print),
              // In phiếu ship
              title: Text(S.current.saleOrder_printShipSlip),
              onTap: () {
                Navigator.pop(context);
                viewModel.printShipOrderCommand(order);
              },
            ),
            if (order?.carrierDeliveryType == "OkieLa") ...[
              const Divider(
                height: 1,
              ),
              // Tải về phiếu ship
              ListTile(
                leading: const Icon(Icons.print),
                title: Text("${S.current.saleOrder_downloadShipSlip} PDF"),
                onTap: () {
                  Navigator.pop(context);
                  viewModel.printShipOrderCommand(
                    order,
                    isDownloadOkiela: true,
                  );
                },
              ),
            ],
            const Divider(
              height: 1,
            ),
            ListTile(
              leading: const Icon(Icons.print),
              // In hóa đơn
              title: Text(S.current.printInvoice),
              onTap: () {
                Navigator.pop(context);
                viewModel.printInvoiceCommand(order);
              },
            ),
          ],
        );
      },
    );
  }
}
