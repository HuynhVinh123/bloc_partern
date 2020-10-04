/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 7/4/19 6:25 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 7/4/19 10:58 AM
 *
 */

import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:barcode_scan/barcode_scan.dart';

///Trang hiển thị Danh sách đơn hàng
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_datetime.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_drawer.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_object.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_panel.dart';
import 'package:tpos_mobile/app_core/template_ui/app_list_empty_notify.dart';

import 'package:tpos_mobile/feature_group/fast_sale_order/ui/fast_sale_order_add_edit_full_page.dart';
import 'package:tpos_mobile/feature_group/fast_sale_order/ui/fast_sale_order_quick_create_from_sale_online_order_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/partner_search_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/sale_online_channel_list_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/sale_online_edit_order_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/sale_online_live_campaign_select_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/sale_online_order_info_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/sale_online_order_pending_list_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/sale_online_order_status_list_page.dart';

import 'package:tpos_mobile/feature_group/sale_online/viewmodels/sale_online_order_list_viewmodel.dart';
import 'package:tpos_mobile/helpers/app_helper.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/helpers/ui_help.dart';
import 'package:tpos_mobile/src/tpos_apis/models/status_extra.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_api.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_models.dart';
import 'package:tpos_mobile/widgets/custom_widget.dart';
import 'package:tpos_mobile/widgets/listview_data_error_info_widget.dart';
import 'package:tpos_mobile_localization/generated/l10n.dart';

class SaleOnlineOrderListPage extends StatefulWidget {
  const SaleOnlineOrderListPage({this.postId, this.partner});
  static const routeName = "home/sale_online_order/list";
  final String postId;
  final Partner partner;

  @override
  _SaleOnlineOrderListPageState createState() =>
      _SaleOnlineOrderListPageState();
}

class _SaleOnlineOrderListPageState extends State<SaleOnlineOrderListPage> {
  final TextEditingController _searchController = TextEditingController();
  final orderViewModel = SaleOnlineOrderListViewModel();
  Key refreshIndicatorKey = const Key("refreshIndicator");
  bool _isSearchEnable = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    orderViewModel.init(filterPartner: widget.partner, postId: widget.postId);
    super.initState();
    orderViewModel.initCommand();

    orderViewModel.notifyPropertyChangedController.listen((value) {
      if (mounted) {
        setState(() {});
      }
    });
    orderViewModel.filterViewModel.notifyPropertyChangedController
        .listen((value) {
      if (mounted) {
        setState(() {});
      }
    });

    orderViewModel.dialogMessageController.listen((value) {
      registerDialogToView(context, value,
          scaffState: _scaffoldKey.currentState);
    });

    orderViewModel.filterViewModel.dialogMessageController.listen((value) {
      registerDialogToView(context, value,
          scaffState: _scaffoldKey.currentState);
    });

    orderViewModel.eventController.listen((event) {
      if (event.eventName == SaleOnlineOrderListViewModel.EVENT_GOBACK) {
        Navigator.pop(context);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    orderViewModel.dispose();
    super.dispose();
  }

  Widget _buildSearch() {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(24)),
      height: 40,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          const SizedBox(
            width: 12,
          ),
          Icon(
            Icons.search,
            color: const Color(0xFF28A745),
          ),
          Expanded(
            child: Center(
              child: Container(
                  height: 35,
                  margin: const EdgeInsets.only(left: 4),
                  child: Center(
                    child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          if (value == "" || value.length == 1) {
                            setState(() {});
                          }
                          orderViewModel.searchOrderCommand(value);
                        },
                        autofocus: true,
                        decoration: const InputDecoration(
                            contentPadding: const EdgeInsets.all(0),
                            isDense: true,
                            hintText: "Tìm kiếm",
                            border: InputBorder.none)),
                  )),
            ),
          ),
          Visibility(
            visible: _searchController.text != "",
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.grey,
                size: 18,
              ),
              onPressed: () {
                setState(() {
                  _searchController.text = "";
                });
                orderViewModel.searchOrderCommand("");
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<SaleOnlineOrderListViewModel>(
      model: orderViewModel,
      child: ViewBaseWidget(
        isBusyStream: orderViewModel.isBusyController,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.grey.shade200,
          endDrawer: _buildFilterPanel(),
          appBar: widget.partner == null
              ? AppBar(
                  title: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: _isSearchEnable
                        ? _buildSearch()
                        : Text(S.current.menu_SaleOnlineOrder),
                  ),
                  actions: <Widget>[
                    InkWell(
                        onTap: () async {
                          final barcode = await BarcodeScanner.scan();
                          if (barcode != null) {
                            setState(() {
                              _isSearchEnable = true;
                              _searchController.text = barcode.rawContent;
                            });
                            orderViewModel
                                .searchOrderCommand(barcode.rawContent);
                          }
                        },
                        child: Image.asset("images/scan_barcode.png",
                            width: 24, height: 18, color: Colors.white)),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          _isSearchEnable = !_isSearchEnable;
                        });
                      },
                    ),
                    _childPopup()
//                    PopupMenuButton(
//                      itemBuilder: (context) => [
//                        PopupMenuItem(
//                          child: Text("Xuất file excel"),
//                          value: "export_excel",
//                        ),
//                      ],
//                      onSelected: (value) {
//                        switch (value) {
//                          case "export_excel":
//                            orderViewModel.exportExcel();
//                            break;
//                        }
//                      },
//                    ),
                  ],
                )
              : null,
          body: ScopedModelDescendant<SaleOnlineOrderListViewModel>(
            builder: (context, child, index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _showFilterPanel(),
                _showSelectedPanel(),
                Expanded(
                  child: _showListOrder(),
                ),
                if (orderViewModel.isFetchingOrder &&
                    orderViewModel.isBusy == false)
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: <Widget>[
                        const CircularProgressIndicator(),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(orderViewModel.tempOrders.length.toString()),
                        const SizedBox(
                          width: 20,
                        ),
                        const Text("Vẫn đang tải thêm..."),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          floatingActionButton: _showBasketButton(),
        ),
      ),
    );
  }

  Widget _buildFilterPanel() {
    return ScopedModelDescendant<SaleOnlineOrderListViewModel>(
      builder: (_, __, ___) => AppFilterDrawerContainer(
        closeWhenConfirm: true,
        onApply: orderViewModel.initCommand,
        onRefresh: widget.partner != null || widget.postId != null
            ? null
            : orderViewModel.resetFilter,
        child: Container(
          margin: MediaQuery.of(context).viewInsets,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                AppFilterDateTime(
                  isSelected: orderViewModel.isFilterByDate,
                  initDateRange: orderViewModel.filterDateRange,
                  onSelectChange: (value) {
                    orderViewModel.isFilterByDate = value;
                  },
                  fromDate: orderViewModel.filterFromDate,
                  toDate: orderViewModel.filterToDate,
                  dateRangeChanged: (value) {
                    orderViewModel.filterDateRange = value;
                  },
                  onFromDateChanged: (value) {
                    orderViewModel.filterFromDate = value;
                  },
                  onToDateChanged: (value) {
                    orderViewModel.filterToDate = value;
                  },
                ),
                AppFilterPanel(
                    title: const Text("Lọc theo trạng thái"),
                    isSelected: orderViewModel.isFilterByStatus,
                    onSelectedChange: (bool value) =>
                        orderViewModel.isFilterByStatus = value,
                    children: <Widget>[
                      Builder(
                        builder: (context) {
                          if (orderViewModel.filterStatusList == null) {
                            {
                              orderViewModel.loadFilterStatusList();
                            }
                          }

                          return Wrap(
                            runSpacing: 0,
                            runAlignment: WrapAlignment.start,
                            spacing: 1,
                            children: orderViewModel.filterStatusList
                                    ?.map(
                                      (f) => FilterChip(
                                        label: Text(
                                          f.text,
                                          style: TextStyle(
                                              color: f.selected
                                                  ? Colors.white
                                                  : Colors.grey),
                                        ),
                                        selected: f.selected,
                                        selectedColor: Colors.green,
                                        onSelected: (bool value) {
                                          setState(() {
                                            f.selected = value;
                                          });
                                        },
                                      ),
                                    )
                                    ?.toList() ??
                                <Widget>[],
                          );
                        },
                      )
                    ]),
                AppFilterObject(
                  title: const Text("Lọc theo chiến dịch live"),
                  isSelected: orderViewModel.isFilterByLiveCampaign,
                  onSelectChange: (bool value) =>
                      orderViewModel.isFilterByLiveCampaign = value,
                  hint: "Chọn chiến dịch",
                  content: orderViewModel.filterLiveCampaign?.name,
                  onSelect: () async {
                    final campaign = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SaleOnlineLiveCampaignSelectPage(),
                      ),
                    );

                    if (campaign != null) {
                      orderViewModel.filterLiveCampaign = campaign;
                    }
                  },
                ),
                AppFilterObject(
                  title: const Text("Lọc theo kênh"),
                  isSelected: orderViewModel.isFilterByCrmTeam,
                  hint: "Chọn kênh bán",
                  content: orderViewModel.filterCrmTeam?.name,
                  onSelectChange: (bool value) =>
                      orderViewModel.isFilterByCrmTeam = value,
                  onSelect: () async {
                    final crmTeam = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SaleOnlineChannelListPage(
                          isSearchMode: true,
                        ),
                      ),
                    );

                    if (crmTeam != null) {
                      orderViewModel.filterCrmTeam = crmTeam;
                    }
                  },
                ),
                AppFilterObject(
                  title: const Text("Lọc theo khách hàng"),
                  isSelected: orderViewModel.isFilterByPartner,
                  hint: "Chọn khách hàng",
                  content: orderViewModel.filterPartner?.name,
                  isEnable: widget.partner == null,
                  onSelectChange: (bool value) {
                    orderViewModel.isFilterByPartner = value;
                  },
                  onSelect: () async {
                    final partner = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PartnerSearchPage()));

                    if (partner != null) {
                      orderViewModel.filterPartner = partner;
                    }
                  },
                ),
                AppFilterPanel(
                  title: const Text("Lọc theo id bài LIVE"),
                  isSelected: orderViewModel.isFilterByPostId,
                  onSelectedChange: (bool value) =>
                      orderViewModel.isFilterByPostId = value,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: const InputDecoration(),
                        controller:
                            TextEditingController(text: orderViewModel.postId),
                        onChanged: (text) {
                          orderViewModel.filterPostId = text;
                        },
                      ),
                    ),
                  ],
                  isEnable: widget.postId == null,
                ),
              ],
            ),
          ),
        ),
        bottomContent: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Expanded(child: Text("${orderViewModel.itemCount} ĐH")),
              Text(
                  "Tổng: ${vietnameseCurrencyFormat(orderViewModel.amountTotal)}")
            ],
          ),
        ),
      ),
    );
  }

  /// Filter date, Filter ...
  Widget _showFilterPanel() {
    return Container(
      height: 50,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(Icons.sort),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              hint: const Text("Sắp xếp"),
              value:
                  "${orderViewModel.filterViewModel.sort?.field ?? "DateCreated"}_${orderViewModel.filterViewModel.sort?.dir ?? "desc"}",
              onChanged: (String value) async {
                await orderViewModel.filterViewModel.setSortCommand(value);
                await orderViewModel.amplyFilterCommand();
              },
              items: const [
                DropdownMenuItem<String>(
                  value: "DateCreated_desc",
                  child: Text("Ngày (Mới đến cũ)"),
                ),
                DropdownMenuItem<String>(
                  value: "DateCreated_asc",
                  child: Text("Ngày (Cũ  tới mới)"),
                ),
                DropdownMenuItem<String>(
                  value: "SessionIndex_asc",
                  child: Text("STT (thấp đến cao)"),
                ),
                DropdownMenuItem<String>(
                  value: "SessionIndex_desc",
                  child: Text("STT (Cao xuống thấp)"),
                )
              ],
            ),
          ),
          const Expanded(
            child: Text(""),
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
                  "${orderViewModel.filterCount ?? 0}",
                  style: TextStyle(color: Colors.white),
                ),
                child: Row(
                  children: <Widget>[
                    const Text("Lọc"),
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

  /// Biểu tượng hiển thị số lượng mục đang chọn để xử lý
  Widget _showBasketButton() {
    return ScopedModelDescendant<SaleOnlineOrderListViewModel>(
      builder: (context, _, __) {
        if (orderViewModel.selectedManyOrders.isEmpty) {
          return const SizedBox();
        }
        final TextStyle basketTextStyle = TextStyle(color: Colors.white);
        return RaisedButton(
          color: Colors.purple,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
              width: 0,
              color: Colors.purple,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Icon(
                  FontAwesomeIcons.shoppingBasket,
                  color: Colors.white,
                ),
              ),
              Text(
                "${orderViewModel.countBasketItem()}",
                style: basketTextStyle.copyWith(fontSize: 22),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: Text(
                  "Đang chờ xử lý",
                  style: basketTextStyle,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
              ),
              const SizedBox(
                width: 10,
              )
            ],
          ),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SaleOnlineOrderPendingListPage(
                  saleOnlineOrderListViewModel: orderViewModel,
                ),
              ),
            );

            orderViewModel.updateAfterCreateInvoiceCommand();
          },
        );
      },
    );
  }

  Widget _showListOrder() {
    return RefreshIndicator(
      key: refreshIndicatorKey,
      onRefresh: () async {
        return await orderViewModel.refreshOrdersCommand();
      },
      child: StreamBuilder<List<SaleOnlineOrder>>(
          stream: orderViewModel.ordersObservable,
          initialData: orderViewModel.orders,
          builder: (context, ordersSnapshot) {
            if (ordersSnapshot.hasError) {
              return ListViewDataErrorInfoWidget(
                errorMessage:
                    "Đã xảy ra lỗi! \n" + ordersSnapshot.error.toString(),
              );
            }

            if (ordersSnapshot.hasData == false) {
              return const SizedBox();
            }

            if ((orderViewModel.orders?.length ?? 0) == 0 &&
                orderViewModel.isBusy == false) {
              return AppListEmptyNotifyDefault(
                message:
                    'Không có dữ liệu. Vui lòng kiểm tra lại điều kiện lọc và tải lại',
                onRefresh: orderViewModel.initCommand,
              );
            }

            return Scrollbar(
              child: ListView.separated(
                padding: const EdgeInsets.only(
                  left: 8,
                  top: 8,
                  right: 8,
                  bottom: 8,
                ),
                itemCount: ordersSnapshot.data?.length ?? 0,
                separatorBuilder: (context, position) {
                  return const SizedBox(
                    height: 8,
                  );
                },
                itemBuilder: (context, position) {
                  return SaleOnlineOrderItemView(
                    item: ordersSnapshot.data[position],
                    isCheck: ordersSnapshot.data[position].checked ?? false,
                    onBasketPress: () {
                      orderViewModel
                          .addBasketItem(ordersSnapshot.data[position]);
                    },
                    onSelect: (value) {
                      orderViewModel
                          .changeCheckItem(ordersSnapshot.data[position]);
                    },
                    onLongPress: () {
                      orderViewModel
                          .enableSelectedCommand(ordersSnapshot.data[position]);
                    },
                    onMenuPress: () {
                      _showItemMenu(context, ordersSnapshot.data[position]);
                    },
                  );
                },
              ),
            );
          }),
    );
  }

  // Panel include Check all button, and function button
  Widget _showSelectedPanel() {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Checkbox(
            onChanged: (bool value) {
              orderViewModel.selectAllItemCommand();
            },
            value: orderViewModel.isCheckAll,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "(${orderViewModel.selectedItemCount})",
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: SizedBox(
              width: 45,
              child: OutlineButton(
                textColor: Colors.blue,
                child: const Text(
                  "In",
                ),
                onPressed: () async {
                  final showConfirmResult = await showQuestion(
                      context: context,
                      title: "Xác nhận",
                      message: "In toàn bộ phiếu đã chọn");

                  if (showConfirmResult == OldDialogResult.Yes) {
                    orderViewModel.printAllSelect();
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: RaisedButton(
              textColor: Colors.white,
              child: const AutoSizeText(
                "Tạo HĐ\nSP mặc định",
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FastSaleOrderQuickCreateFromSaleOnlineOrderPage(
                      saleOnlineIds: orderViewModel.selectedIds,
                    ),
                  ),
                );

                orderViewModel.updateAfterCreateInvoiceCommand();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: SizedBox(
              width: 70,
              child: RaisedButton(
                padding: const EdgeInsets.all(5),
                child: Text(
                  "Tạo HĐ",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (orderViewModel.selectedIds == null ||
                      orderViewModel.selectedIds.isEmpty) {
                    showWarning(
                        context: context,
                        title: "Chưa chọn đơn hàng nào!",
                        message:
                            "Vui lòng chọn 1 hoặc nhiều đơn hàng có cùng tên facebook để tiếp tục");
                    return;
                  }

                  if (orderViewModel.selectedOrders.any((f) =>
                      f.facebookAsuid !=
                      orderViewModel.selectedOrders.first.facebookAsuid)) {
                    showWarning(
                        context: context,
                        title: "Các đơn đã chọn không cùng 1 facebook",
                        message:
                            "Vui lòng chọn các đơn hàng có cùng tên facebook");
                    return;
                  }

                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FastSaleOrderAddEditFullPage(
                                saleOnlineIds: orderViewModel.selectedIds,
                                partnerId: orderViewModel
                                    .selectedOrders?.first?.partnerId,
                                onEditCompleted: (order) {
                                  if (order != null) {
                                    orderViewModel
                                        .updateAfterCreateInvoiceCommand();
                                  }
                                },
                              )));

                  orderViewModel.unSelectAllCommand();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showDialogProducts(
      List<SaleOnlineOrderDetail> items, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            title: const Text("Sản phẩm trong đơn hàng"),
            content: Container(
              width: 1000,
              padding: const EdgeInsets.all(12),
              child: Scrollbar(
                child: ListView.separated(
                    shrinkWrap: false,
                    itemCount: items?.length ?? 0,
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                items[index].productName ?? '',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                  "${NumberFormat("###,###,###,###", "en_US").format(items[index].quantity ?? "")} (${items[index].uomName})"),
                              Text(
                                " x ${NumberFormat("###,###,###,###", "en_US").format(items[index].price ?? "")}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  NumberFormat("###,###,###,###", "en_US")
                                      .format((items[index].price ?? 0) *
                                              (items[index].quantity ?? 0) ??
                                          ""),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(color: Colors.redAccent),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: const Text("ĐÓNG"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  void _showItemMenu(BuildContext context, SaleOnlineOrder item) {
    final vm = ScopedModel.of<SaleOnlineOrderListViewModel>(context);
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (ctx) {
        return BottomSheet(
          shape: const OutlineInputBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            borderSide: BorderSide(width: 0),
          ),
          onClosing: () {},
          builder: (context) => ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.shopping_basket),
                title: const Text("Thêm vào hàng đợi"),
                onTap: () {
                  Navigator.pop(context);
                  vm.addBasketItem(item);
                },
              ),
              const Divider(height: 2),
              ListTile(
                leading: Icon(Icons.print),
                title: const Text("In phiếu"),
                onTap: () {
                  Navigator.pop(context);
                  vm.printSaleOnlineTag(item);
                },
              ),
              const Divider(height: 2),
              ListTile(
                leading: Icon(Icons.remove_red_eye),
                title: const Text("Xem thông tin đơn hàng"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => SaleOnlineOrderInfoPage(
                                orderId: item.id,
                              )));
                },
              ),
              const Divider(height: 2),
              ListTile(
                leading: Icon(Icons.add),
                title: const Text("Tạo hóa đơn giao hàng"),
                onTap: () {
                  Navigator.pop(context);
                  vm.enableSelectedCommand(item);
                },
              ),
              if (item.telephone != null && item.telephone != "")
                ListTile(
                  title: Row(
                    children: <Widget>[
                      Tooltip(
                        message: "Mở trình gọi điện",
                        child: OutlineButton.icon(
                          //textColor: Colors.white,
                          icon: Icon(
                            FontAwesomeIcons.phone,
                            size: 20,
                          ),
                          label: Text(item.telephone ?? ""),
                          onPressed: () {
                            Navigator.pop(context);
                            urlLauch(
                              "tel: ${item.telephone}",
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (item.facebookUserId != null)
                        Tooltip(
                          message: "Mở facebook",
                          child: OutlineButton.icon(
                            //textColor: Colors.white,
                            icon: Icon(
                              FontAwesomeIcons.facebookF,
                              color: Colors.indigo,
                              size: 20,
                            ),

                            label: Text(item.facebookUserId ?? ''),
                            onPressed: () {
                              Navigator.pop(context);
                              urlLauch("fb://profile/${item.facebookUserId}");
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ListTile(
                leading: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                title: Text(
                  "Xóa",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () async {
                  final dialogResult = await showQuestion(
                      context: context,
                      title: "Xác nhận",
                      message: "Bạn muốn xóa đơn hàng ${item.code}");

                  if (dialogResult == OldDialogResult.Yes) {
                    vm.deleteOrder(item);

                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _childPopup() => PopupMenuButton<String>(
        padding: const EdgeInsets.all(0),
        itemBuilder: (context) => [
          PopupMenuItem<String>(
            value: "exportExcel",
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.explicit,
                  color: Colors.green,
                ),
                const SizedBox(
                  width: 12,
                ),
                const Text(
                  "Xuất Excel",
                ),
              ],
            ),
          ),
        ],
        icon: Icon(Icons.more_vert),
        onSelected: (value) async {
          if (value == "exportExcel") {
            orderViewModel.exportExcel(context);
          }
        },
      );
}

class SaleOnlineOrderListPageArgument {
  SaleOnlineOrderListPageArgument({this.postId});
  String postId;
}

class SaleOnlineOrderItemView extends StatelessWidget {
  const SaleOnlineOrderItemView(
      {@required this.item,
      Key key,
      this.onLongPress,
      this.onPress,
      this.onMenuPress,
      this.onSelect,
      this.onBasketPress,
      this.isCheck})
      : super(key: key);
  final bool isCheck;
  final SaleOnlineOrder item;
  final VoidCallback onLongPress;
  final VoidCallback onPress;
  final VoidCallback onMenuPress;
  final ValueChanged<bool> onSelect;
  final VoidCallback onBasketPress;

  void _showDialogProducts(
      List<SaleOnlineOrderDetail> items, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            title: const Text("Sản phẩm trong đơn hàng"),
            content: Container(
              width: 1000,
              padding: const EdgeInsets.all(12),
              child: Scrollbar(
                child: ListView.separated(
                    shrinkWrap: false,
                    itemCount: items?.length ?? 0,
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                items[index].productName ?? '',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                  "${NumberFormat("###,###,###,###", "en_US").format(items[index].quantity ?? "")} (${items[index].uomName})"),
                              Text(
                                " x ${NumberFormat("###,###,###,###", "en_US").format(items[index].price ?? "")}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  NumberFormat("###,###,###,###", "en_US")
                                      .format((items[index].price ?? 0) *
                                              (items[index].quantity ?? 0) ??
                                          ""),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(color: Colors.redAccent),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: const Text("ĐÓNG"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final statusTextColor = getSaleOnlineOrderColor(item.statusText);
    final statusPointColor = statusTextColor.withOpacity(0.4);
    const contentStyle = TextStyle(fontSize: 12);
    return InkWell(
        splashColor: Colors.grey,
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                stops: const [0.015, 0.015],
                colors: [
                  statusPointColor,
                  Colors.white,
                ],
              ),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                width: 0.3,
                color: statusPointColor,
              ),
              color: Colors.white),
          padding: const EdgeInsets.only(bottom: 8, top: 8, right: 5, left: 0),
          child: ScopedModelDescendant<SaleOnlineOrderListViewModel>(
            builder: (context, child, vm) => Stack(
              children: <Widget>[
                if (onSelect != null)
                  Positioned(
                    child: InkWell(
                      child: Container(
                        padding: const EdgeInsets.only(left: 7),
                        child: Checkbox(value: isCheck, onChanged: onSelect),
                      ),
                      onTap: () {},
                    ),
                    top: 0,
                    left: 0,
                  ),
                if (onBasketPress != null)
                  Positioned(
                    child: InkWell(
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 20, right: 10, top: 10, bottom: 10),
                        child: Icon(
                          FontAwesomeIcons.shoppingCart,
                          color: vm.checkBasketItem(item)
                              ? Colors.purple
                              : Colors.grey.shade300,
                          size: 20,
                        ),
                      ),
                      onTap: onBasketPress,
                    ),
                    bottom: 3,
                    left: 0,
                  ),
                const SizedBox(),
                Padding(
                  padding: const EdgeInsets.only(left: 60),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      // Tên
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  "${item.sessionIndex != null && item.sessionIndex != 0 ? "#${item.sessionIndex}. " : ""}${item.code}",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: getSaleOnlineOrderColor(
                                        item.statusText),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                item.name ?? '',
                                style: TextStyle(
                                  color:
                                      getSaleOnlineOrderColor(item.statusText),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (onMenuPress != null)
                                SizedBox(
                                  height: 30,
                                  child: IconButton(
                                      padding: const EdgeInsets.only(
                                          left: 0, top: 0, bottom: 0),
                                      icon: Icon(Icons.more_horiz),
                                      onPressed: onMenuPress),
                                )
                            ],
                          ),
                          // Địa chỉ, số điện thoại
                          RichText(
                            maxLines: 2,
                            text: TextSpan(
                              text: item.telephone ?? "  Chưa có SĐT  ",
                              style:
                                  contentStyle.copyWith(color: Colors.black87),
                              children: [
                                TextSpan(
                                  text:
                                      " | ${item.address ?? "  Chưa có địa chỉ "}",
                                  style:
                                      contentStyle.copyWith(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            DateFormat("dd/MM/yyyy HH:mm")
                                .format(item.dateCreated.toLocal()),
                          ),

                          Divider(
                            color: Colors.grey.shade200,
                            height: 1,
                          ),
                        ],
                      ),
                      //Trạng thái đơn hàng
                      Row(
                        children: <Widget>[
                          InkWell(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, top: 8, right: 8),
                              child: Row(
                                children: <Widget>[
                                  DecoratedBox(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: getSaleOnlineOrderColor(
                                                  item.statusText)
                                              .withOpacity(0.8),
                                          blurRadius: 8,
                                          offset: const Offset(0, 0),
                                        )
                                      ],
                                      color: getSaleOnlineOrderColor(
                                          item.statusText),
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
                                    item.statusText,
                                    style: TextStyle(
                                        color: getSaleOnlineOrderColor(
                                            item.statusText)),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () async {
                              final StatusExtra status = await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  contentPadding: const EdgeInsets.all(0),
                                  content: SaleOnlineOrderStatusListPage(
                                    isSearchMode: true,
                                    isCloseWhenSelect: true,
                                    isDialogMode: true,
                                    selectedValue: item.statusText,
                                  ),
                                ),
                              );

                              if (status != null) {
                                vm.changeStatus(item, status.name);
                              }

//                              Navigator.push(
//                                context,
//                                MaterialPageRoute(
//                                  builder: (context) =>
//                                      _SaleOnlineOrderStatusListPage(),
//                                ),
//                              );
                            },
                          ),
                          InkWell(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, top: 8, right: 8),
                              child: Text(
                                "${NumberFormat("###,###,###").format(item.totalQuantity ?? 0)} Sản phẩm",
                                style: const TextStyle(color: Colors.blue),
                              ),
                            ),
                            onTap: () async {
                              vm.onIsBusyAdd(true);
                              //try {
                              final products = await vm.getProductById(item);
                              _showDialogProducts(products, context);
                              //} catch (e, s) {
                              //print(s);
                              //}
                              vm.onIsBusyAdd(false);
                            },
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text(
                                vietnameseCurrencyFormat(item.totalAmount),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: () async {
          // show Edit
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              final SaleOnlineEditOrderPage orderDetailPage =
                  SaleOnlineEditOrderPage(
                orderId: item.id,
              );
              return orderDetailPage;
            }),
          );
        },
        onLongPress: onLongPress);
  }
}
