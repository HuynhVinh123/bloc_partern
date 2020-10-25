import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_panel.dart';

import 'package:tpos_mobile/feature_group/sale_order/sale_order.dart';
import 'package:tpos_mobile/feature_group/sale_order/sale_order_add_edit_page.dart';
import 'package:tpos_mobile/feature_group/sale_order/sale_order_info_page.dart';
import 'package:tpos_mobile/feature_group/sale_order/sale_order_list_viewmodel.dart';
import 'package:tpos_mobile/helpers/app_helper.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/ui_base/ui_vm_base.dart';

import 'package:tpos_mobile/widgets/appbar_search_widget.dart';
import 'package:tpos_mobile/widgets/custom_bottom_sheet.dart';
import 'package:tmt_flutter_untils/tmt_flutter_utils.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class SaleOrderListPage extends StatefulWidget {
  @override
  _SaleOrderListPageState createState() => _SaleOrderListPageState();
}

class _SaleOrderListPageState extends State<SaleOrderListPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SaleOrderListViewModel viewModel = SaleOrderListViewModel();
  final ScrollController _scrollController = ScrollController();
  bool _isSearchEnable = false;

  bool isTablet = false;
  double deviceWidth;
  double columnWidth;

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    columnWidth = (deviceWidth - 40) / 10;
    if (deviceWidth > 700)
      isTablet = true;
    else
      isTablet = false;
    return ScopedModel<SaleOrderListViewModel>(
      model: viewModel,
      child: ScopedModelDescendant<SaleOrderListViewModel>(
          rebuildOnChange: true,
          builder: (context, child, model) {
            return Scaffold(
              backgroundColor: Colors.grey.shade200,
              key: _scaffoldKey,
              appBar: AppBar(
                title: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: _isSearchEnable
                      ? AppbarSearchWidget(
                          autoFocus: true,
                          keyword: viewModel.keyword,
                          onTextChange: (value) {
                            viewModel.onSearchingOrderHandled(value);
                          },
                        )
                      : Text(S.current.menu_purchaseOrder),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        _isSearchEnable = !_isSearchEnable;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SaleOrderAddEditPage(
                            onEditCompleted: (order) {
                              viewModel.init();
                            },
                            isCopy: true,
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: GestureDetector(
                      onTap: () {
                        _scaffoldKey.currentState.openEndDrawer();
                      },
                      child: Badge(
                        position: const BadgePosition(top: 4, end: -8),
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
                  )
                ],
              ),
              body: _buildDetail(),
              endDrawer: _showDrawerRight(context),
            );
          }),
    );
  }

  Widget _buildDetail() {
    return UIViewModelBase(
      viewModel: viewModel,
      child: RefreshIndicator(
          child: Scrollbar(
              child: (viewModel.saleOrders?.isEmpty ?? true)
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          S.current.noData,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.orangeAccent),
                        ),
                      ),
                    )
                  : _showMobileSaleOrders()),
          onRefresh: () async {
            await viewModel.filter();
            return true;
          }),
    );
  }

  Widget _showMobileSaleOrders() {
    return ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 15, top: 5),
        shrinkWrap: false,
        itemCount: viewModel.saleOrders?.length ?? 0,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(left: 12, right: 12, top: 8),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white70,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: <Widget>[
                Dismissible(
                  direction: DismissDirection.endToStart,
                  key: Key("${viewModel.saleOrders[index].id}"),
                  background: Container(
                    color: Colors.green,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            S.current.deleteALine,
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                          size: 40,
                        )
                      ],
                    ),
                  ),
                  confirmDismiss: (direction) async {
                    final dialogResult = await showQuestion(
                        context: context,
                        title: S.current.delete,
                        message:
                            "${S.current.purchaseOrder_deleteOrder} ${viewModel.saleOrders[index].name}?");

                    if (dialogResult == OldDialogResult.Yes) {
                      final result = await viewModel
                          .deleteSaleOrder(viewModel.saleOrders[index].id);
                      if (result) {
                        viewModel.saleOrders.removeAt(index);
                      }
                      return result;
                    } else {
                      return false;
                    }
                  },
                  onDismissed: (direction) async {},
                  child: ListTile(
                    onTap: () async {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return SaleOrderInfoPage(
                          viewModel.saleOrders[index],
                          onEditCompleted: (order) {
                            viewModel.init();
                          },
                        );
                      }));
                    },
                    contentPadding:
                        const EdgeInsets.only(left: 15.0, right: 15.0),
                    subtitle: Column(
                      children: <Widget>[
                        // title
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                  viewModel.saleOrders[index]?.name ?? "",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: getSaleOrderColor(
                                          viewModel.saleOrders[index].state),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                            ),
                            Text(
                              vietnameseCurrencyFormat(
                                      viewModel.saleOrders[index].amountTotal ??
                                          0) ??
                                  "",
                              style: TextStyle(
                                  color: getSaleOrderColor(
                                      viewModel.saleOrders[index].state),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            InkWell(
                              child: Container(
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Icon(
                                    Icons.more_horiz,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              onTap: () {
                                showModalBottomSheetFullPage(
                                  context: context,
                                  builder: (context) {
                                    return _buildBottomAction(index);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                        Text(
                          viewModel.saleOrders[index].partnerDisplayName ?? "",
                          style: const TextStyle(color: Colors.blue),
                        ),
                        Text(
                          DateFormat("dd/MM/yyyy HH:mm")
                              .format(viewModel.saleOrders[index]?.dateOrder),
                          style: const TextStyle(color: Colors.green),
                        ),

                        Row(
                          children: <Widget>[
                            Text(
                              viewModel.saleOrders[index]?.showFastState ?? "",
                              style: TextStyle(
                                  color: getSaleOrderColor(
                                      viewModel.saleOrders[index].state)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                viewModel
                                        .saleOrders[index]?.showInvoiceStatus ??
                                    "",
                                style: TextStyle(
                                    color: getSaleOrderStateOption(
                                            state: viewModel.saleOrders[index]
                                                ?.invoiceStatus)
                                        .textColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _buildBottomAction(index) {
    return Container(
      color: const Color(0xFF737373),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            ListTile(
              leading: const Icon(
                Icons.check,
                color: Colors.green,
              ),
              title: const Text("Copy"),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SaleOrderAddEditPage(
                      editOrder: viewModel.saleOrders[index],
                      onEditCompleted: (order) {
                        viewModel.init();
                      },
                      isCopy: true,
                    ),
                  ),
                );

                Navigator.pop(context);
              },
            ),
            const ListTile(),
          ],
        ),
      ),
    );
  }

  // build tablet
//  Widget _showTabletSaleOrders() {
//    return SingleChildScrollView(
//      scrollDirection: Axis.horizontal,
//      child: DataTable(
//        horizontalMargin: 20,
//        sortColumnIndex: viewModel.sortColumnIndex,
//        sortAscending: viewModel.sortAscending,
//        columns: <DataColumn>[
//          DataColumn(
//            label: Container(
//              width: columnWidth,
//              child: const Text(
//                'Số đơn hàng',
//                textAlign: TextAlign.center,
//              ),
//            ),
//            onSort: (int columnIndex, bool ascending) =>
//                viewModel.sortSaleOrders<String>(
//              (SaleOrder d) => d.name,
//              ascending,
//              columnIndex,
//            ),
//          ),
//          DataColumn(
//            label: Container(
//              width: columnWidth,
//              child: const Text(
//                'Ngày',
//                textAlign: TextAlign.center,
//              ),
//            ),
//            onSort: (int columnIndex, bool ascending) =>
//                viewModel.sortSaleOrders<DateTime>(
//              (SaleOrder d) => d.dateOrder,
//              ascending,
//              columnIndex,
//            ),
//          ),
//          DataColumn(
//            label: Container(
//                width: columnWidth,
//                child: const Text(
//                  'Khách hàng',
//                  textAlign: TextAlign.center,
//                )),
//            onSort: (int columnIndex, bool ascending) =>
//                viewModel.sortSaleOrders<String>(
//              (SaleOrder d) => d.partnerDisplayName,
//              ascending,
//              columnIndex,
//            ),
//          ),
//          DataColumn(
//            label:
//                Container(width: columnWidth, child: const Text('Người bán')),
//            onSort: (int columnIndex, bool ascending) =>
//                viewModel.sortSaleOrders<String>(
//              (SaleOrder d) => d.userName,
//              ascending,
//              columnIndex,
//            ),
//          ),
//          DataColumn(
//            label:
//                Container(width: columnWidth, child: const Text('Tổng tiền')),
//            numeric: true,
//            onSort: (int columnIndex, bool ascending) =>
//                viewModel.sortSaleOrders<num>(
//              (SaleOrder d) => d.amountTotal,
//              ascending,
//              columnIndex,
//            ),
//          ),
//          DataColumn(
//            label:
//                Container(width: columnWidth, child: const Text('Trạng thái')),
//            onSort: (int columnIndex, bool ascending) =>
//                viewModel.sortSaleOrders<String>(
//              (SaleOrder d) => d.showState,
//              ascending,
//              columnIndex,
//            ),
//          ),
//          DataColumn(
//            label: Container(
//                width: columnWidth, child: const Text('Tình trạng HĐ')),
//            onSort: (int columnIndex, bool ascending) =>
//                viewModel.sortSaleOrders<String>(
//              (SaleOrder d) => d.showInvoiceStatus,
//              ascending,
//              columnIndex,
//            ),
//          ),
//        ],
//        rows: viewModel.saleOrders
//                ?.map(
//                  (itemRow) => DataRow(
//                    cells: [
//                      DataCell(Text('${itemRow.name ?? ''}'),
//                          onTap: () => navigatorDetail(itemRow)),
//                      DataCell(
//                          Text(
//                              '${DateFormat("dd/MM/yyyy").format(itemRow.dateOrder) ?? ''}'),
//                          onTap: () => navigatorDetail(itemRow)),
//                      DataCell(Text('${itemRow.partnerDisplayName ?? ''}'),
//                          onTap: () => navigatorDetail(itemRow)),
//                      DataCell(Text('${itemRow.userName}'),
//                          onTap: () => navigatorDetail(itemRow)),
//                      DataCell(
//                          Text(
//                              '${vietnameseCurrencyFormat(itemRow.amountTotal) ?? ''}'),
//                          onTap: () => navigatorDetail(itemRow)),
//                      DataCell(Text('${itemRow.showState}'),
//                          onTap: () => navigatorDetail(itemRow)),
//                      DataCell(Text('${itemRow.showInvoiceStatus}'),
//                          onTap: () => navigatorDetail(itemRow)),
//                    ],
//                  ),
//                )
//                ?.toList() ??
//            [],
//      ),
//    );
//  }

  /// Lọc
  Widget _showDrawerRight(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        S.current.filterCondition.toUpperCase(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.redAccent,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                )),
            Expanded(
              child: ListView(
                children: <Widget>[
                  // Ngày tháng
                  AppFilterPanel(
                    isEnable: true,
                    isSelected: viewModel.isFilterByDate,
                    onSelectedChange: (bool value) =>
                        viewModel.isFilterByDate = value,
                    title: Text(S.current.filterByTime),
                    children: <Widget>[
                      ListView.builder(
                        itemExtent: 40,
                        padding: const EdgeInsets.only(
                            top: 0, bottom: 0, left: 0, right: 0),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: viewModel.filterByDates?.length ?? 0,
                        itemBuilder: (_, index) {
                          return ListTile(
                            selected: viewModel.selectedFilterByDate ==
                                viewModel.filterByDates[index],
                            title: Text(viewModel.filterByDates[index].name),
                            onTap: () {
                              viewModel.selectFilterByDateCommand(
                                  viewModel.filterByDates[index]);
                            },
                          );
                        },
                      ),
                      const Divider(),
                      ListTile(
                        contentPadding:
                            const EdgeInsets.only(left: 10, right: 5),
                        leading: Text("${S.current.from}: "),
                        title: OutlineButton(
                          textColor: Colors.green,
                          child: Text(
                            viewModel.fromDate != null
                                ? DateFormat("dd/MM/yyyy")
                                    .format(viewModel.fromDate)
                                : "",
                          ),
                          onPressed: () async {
                            final selectedDate = await showDatePicker(
                                context: context,
                                initialDate:
                                    viewModel.fromDate ?? DateTime.now(),
                                firstDate: DateTime.now()
                                    .add(const Duration(days: -3650)),
                                lastDate: DateTime.now());
                            if (selectedDate != null) {
                              viewModel.updateFromDateCommand(selectedDate);
                            }
                          },
                        ),
                        trailing: SizedBox(
                          width: 75,
                          child: OutlineButton(
                            padding: const EdgeInsets.all(0),
                            child: Text(
                              viewModel.fromDate != null
                                  ? DateFormat("HH:mm")
                                      .format(viewModel.fromDate)
                                  : "",
                            ),
                            onPressed: () async {
                              final selectedTime = await showTimePicker(
                                  context: context,
                                  initialTime:
                                      const TimeOfDay(hour: 0, minute: 0));

                              if (selectedTime != null) {
                                viewModel
                                    .updateFromDateTimeCommand(selectedTime);
                              }
                            },
                          ),
                        ),
                      ),
                      ListTile(
                        contentPadding:
                            const EdgeInsets.only(left: 10, right: 5),
                        leading: Text("${S.current.to}: "),
                        title: OutlineButton(
                          padding: const EdgeInsets.all(0),
                          textColor: Colors.green,
                          child: Text(
                            viewModel.toDate != null
                                ? DateFormat("dd/MM/yyyy")
                                    .format(viewModel.toDate)
                                : "",
                          ),
                          onPressed: () async {
                            final selectedDate = await showDatePicker(
                                context: context,
                                initialDate:
                                    viewModel.fromDate ?? DateTime.now(),
                                firstDate: DateTime.now()
                                    .add(const Duration(days: -60)),
                                lastDate: DateTime.now());
                            if (selectedDate != null) {
                              viewModel.updateToDateCommand(selectedDate);
                            }
                          },
                        ),
                        trailing: SizedBox(
                          width: 75,
                          child: OutlineButton(
                            padding: const EdgeInsets.all(0),
                            child: Text(
                              viewModel.toDate != null
                                  ? DateFormat("HH:mm").format(viewModel.toDate)
                                  : "",
                            ),
                            onPressed: () async {
                              final selectedTime = await showTimePicker(
                                  context: context,
                                  initialTime:
                                      const TimeOfDay(hour: 0, minute: 0));

                              if (selectedTime != null) {
                                viewModel.updateToDateTimeCommand(selectedTime);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: RaisedButton.icon(
                        shape: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: Colors.green),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: Colors.white,
                        textColor: Theme.of(context).primaryColor,
                        icon: const Icon(Icons.refresh),
                        label: Text(
                          S.current.reset,
                        ),
                        onPressed: () {
                          viewModel.removeFilter();
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: RaisedButton.icon(
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        icon: const Icon(Icons.check),
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                              width: 1, color: Theme.of(context).primaryColor),
                        ),
                        label: Text(
                          S.current.apply,
                        ),
                        onPressed: () {
                          viewModel.filter();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigatorDetail(SaleOrder value) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (ctx) => SaleOrderInfoPage(
                value,
                onEditCompleted: (order) {
                  viewModel.init();
                },
              )),
    );
  }

  @override
  void initState() {
    viewModel.dialogMessageController.listen((f) {
      registerDialogToView(context, f, scaffState: _scaffoldKey.currentState);
    });
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          if (viewModel.canLoadMore) {
            viewModel.loadMoreSaleOrder();
          }
        }
      }
    });
    super.initState();
    viewModel.initCommand();
  }
}