import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_datetime.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_drawer.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_panel.dart';
import 'package:tpos_mobile/app_core/template_ui/empty_data_widget.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/account_payment/uis/search_type_account_payment_list_page.dart';
import 'package:tpos_mobile/feature_group/account_payment/viewmodel/account_payment_list_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import 'account_payment_add_edit_page.dart';
import 'account_payment_info_page.dart';

class AccountPaymentListPage extends StatefulWidget {
  @override
  _AccountPaymentListPageState createState() => _AccountPaymentListPageState();
}

class _AccountPaymentListPageState extends State<AccountPaymentListPage> {
  final AccountPaymentListViewmodel _vm =
      locator<AccountPaymentListViewmodel>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initData();
  }

  /// Lấy danh sách phiếu thu
  Future<void> initData() async {
    await _vm.getAccountPayments();
  }

  /// Hiển thị giao diện form search
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
          const Icon(
            Icons.search,
            color: Color(0xFF28A745),
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
                          _vm.searchOrderCommand(value);
                        },
                        autofocus: true,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(0),
                            isDense: true,
                            hintText: S.current.search,
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
                _vm.searchOrderCommand("");
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewBase<AccountPaymentListViewmodel>(
        model: _vm,
        builder: (context, model, sizingInformation) {
          return Scaffold(
            backgroundColor: Colors.grey[100],
            key: scaffoldKey,
            appBar: AppBar(
              title: _vm.isSearch
                  ? _buildSearch()

                  /// Danh sách phiếu thu
                  : Text(S.current.receipts_receipts),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _vm.isSearch = !_vm.isSearch;
                    _searchController.text = "";
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AccountPaymentAddEditPage()))
                        .then((value) async {
                      if (value != null) {
                        await _vm.getAccountPayments();
                      }
                    });
                  },
                ),
                _childPopup()
              ],
            ),
            body: SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  await _vm.getAccountPayments();
                },
                child: Column(
                  children: <Widget>[
                    _buildFilter(),
                    Expanded(
                      child: _vm.accountPayments.isEmpty
                          ? EmptyData(
                              onPressed: () {
                                _vm.getAccountPayments();
                              },
                            )
                          : ListView.builder(
                              itemCount: _vm.accountPayments.length,
                              itemBuilder: (BuildContext context, int index) {
                                return _showItem(
                                    _vm.accountPayments[index], index);
                              }),
                    )
                  ],
                ),
              ),
            ),
            endDrawer: buildFilterPanel(),
          );
        });
  }

  Widget _childPopup() => PopupMenuButton<String>(
        itemBuilder: (context) => [
          PopupMenuItem<String>(
            value: "exportExcel",
            child: Row(
              children: <Widget>[
                const Icon(
                  Icons.explicit,
                  color: Colors.green,
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  S.current.export_excel,
                ),
              ],
            ),
          ),
        ],
        icon: const Icon(Icons.more_vert),
        onSelected: (value) async {
          if (value == "exportExcel") {
            _vm.exportExcel(context);
          }
        },
      );

  /// Giao diện filter phiếu thu.
  Widget buildFilterPanel() {
    return AppFilterDrawerContainer(
      onRefresh: () {
        _vm.resetFilter();
      },
      closeWhenConfirm: true,
      onApply: () {
        _vm.handleFilter();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppFilterDateTime(
            isSelected: _vm.isFilterByDate,
            initDateRange: _vm.filterDateRange,
            onSelectChange: (value) {
              _vm.isFilterByDate = value;
            },
            toDate: _vm.filterToDate,
            fromDate: _vm.filterFromDate,
            dateRangeChanged: (value) {
              _vm.filterDateRange = value;
            },
            onFromDateChanged: (value) {
              _vm.filterFromDate = value;
            },
            onToDateChanged: (value) {
              _vm.filterToDate = value;
            },
          ),
          AppFilterPanel(
            isEnable: true,
            isSelected: _vm.isFilterByStatus,
            onSelectedChange: (bool value) => _vm.isFilterByStatus = value,

            /// Lọc theo trạng thái
            title: Text(S.current.filterByStatus),
            children: <Widget>[
              Builder(
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Wrap(
                      runSpacing: 0,
                      runAlignment: WrapAlignment.start,
                      spacing: 5,
                      children: _vm.filterStatusList
                              ?.map(
                                (f) => FilterChip(
                                  label: Text(
                                    f.description,
                                    style: TextStyle(
                                        color: f.isSelected
                                            ? Colors.white
                                            : Colors.grey),
                                  ),
                                  onSelected: (value) {
                                    setState(() {
                                      f.isSelected = value;
                                    });
                                  },
                                  selected: f.isSelected,
                                  selectedColor: f.textColor,
                                ),
                              )
                              ?.toList() ??
                          <Widget>[],
                    ),
                  );
                },
              ),
            ],
          ),
          AppFilterPanel(
            isEnable: true,
            isSelected: _vm.isFilterByTypeAccountPayment,
            onSelectedChange: (bool value) =>
                _vm.isFilterByTypeAccountPayment = value,

            /// "Lọc theo loại phiếu thu
            title: Text(S.current.receipts_filterByReceipts),
            children: <Widget>[
              Container(
                height: 45,
                margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: Colors.grey[400]))),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const SearchTypeAccountPaymentListPage(true)),
                    ).then((value) {
                      if (value != null) {
                        _vm.account = value;
                      }
                    });
                  },
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          _vm.account?.name != null
                              ? _vm.account.name
                              : S.current.receipts_receiptsType,
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 16),
                        ),
                      ),
                      Visibility(
                        visible: _vm.account.name != null,
                        child: IconButton(
                          icon: Icon(
                            Icons.highlight_off,
                            color: Colors.grey[600],
                            size: 20,
                          ),
                          onPressed: () {
                            _vm.account = Account();
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
//          Padding(
//            padding: const EdgeInsets.only(left: 12),
//            child: Text("Loại phiếu thu",
//                style: TextStyle(
//                    color: Colors.blueAccent,
//                    fontWeight: FontWeight.w600,
//                    fontSize: 15)),
//          ),
        ],
      ),
    );
  }

  /// Hiển thị Loại phiếu thu để filter. Icon Filter để open Drawer(Giao diện để filter phiếu thu)
  Widget _buildFilter() {
    return Container(
      height: 45,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            blurRadius: 1, offset: const Offset(0, 1), color: Colors.grey[300])
      ]),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const SearchTypeAccountPaymentListPage(true)),
          ).then((value) {
            if (value != null) {
              _vm.isFilterByTypeAccountPayment = true;
              _vm.account = value;
              _vm.getAccountPayments();
            }
          });
        },
        child: Row(
          children: <Widget>[
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                _vm.account?.name != null && _vm.isFilterByTypeAccountPayment
                    ? _vm.account?.name
                    : S.current.receipts_receiptsType,
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            )),
            Visibility(
              visible:
                  _vm.account.name != null && _vm.isFilterByTypeAccountPayment,
              child: IconButton(
                icon: Icon(
                  Icons.highlight_off,
                  color: Colors.grey[600],
                  size: 20,
                ),
                onPressed: () {
                  _vm.isFilterByTypeAccountPayment = false;
                  _vm.account = Account();
                  _vm.getAccountPayments();
                },
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.grey[600],
            ),
            const SizedBox(
              width: 24,
            ),
            InkWell(
              onTap: () {
                scaffoldKey.currentState.openEndDrawer();
              },
              child: Badge(
                padding: const EdgeInsets.all(4),
                badgeColor: Colors.redAccent,
                badgeContent: Text(
                  "${_vm.countFilter()}",
                  style: const TextStyle(color: Colors.white),
                ),
                child: Icon(
                  Icons.filter_list,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(
              width: 18,
            )
          ],
        ),
      ),
    );
  }

  /// Hiển thị thông tin từng phiếu thu(Mã,số tiền, trạng thái,...)
  Widget _showItem(AccountPayment item, int index) {
    return Dismissible(
        background: Container(
          margin: const EdgeInsets.only(top: 10),
          color: Colors.green,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(
                  S.current.deleteALine,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.delete_forever,
                    color: Colors.white,
                    size: 30,
                  ),
                  Text(
                    S.current.delete,
                    style: const TextStyle(color: Colors.white),
                  )
                ],
              ),
              const SizedBox(
                width: 36,
              )
            ],
          ),
        ),
        onDismissed: (direction) {
          setState(() {});
          _vm.showNotify(S.current.receipts_deleteSuccessful);
        },
        direction: DismissDirection.endToStart,
        key: UniqueKey(),
        confirmDismiss: (direction) async {
          final dialogResult = await showQuestion(
              context: context,
              title: S.current.delete,
              message:
                  "${S.current.receiptType_doYouWantDeleteReceipt} ${item.name ?? ""}");
          if (dialogResult == DialogResultType.YES) {
            if (item.state == "posted") {
              _vm.showError(S.current.receipts_cannotDeleteReceipt);
              return false;
            }
            await _vm.deleteAccountPayment(item.id, item);
            return true;
          } else {
            return false;
          }
        },
        child: item == tempAccountPayment
            ? _vm.isLoadMore
                ? Center(
                    child: SpinKitCircle(
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                : Center(
                    child: Container(
                        margin: const EdgeInsets.only(
                            top: 12, left: 12, right: 12, bottom: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3)),
                        height: 45,
                        child: FlatButton(
                          onPressed: () {
                            setState(() {
                              _vm.isLoadMore = true;
                            });
                            _vm.handleItemCreated(index);
                          },
                          color: Colors.blueGrey,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(S.current.loadMore,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 16)),
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
                        )))
            : Padding(
                padding: const EdgeInsets.only(top: 10, left: 12, right: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: item.state == "draft"
                              ? Colors.grey[400].withOpacity(0.5)
                              : Colors.green.withOpacity(0.5),
                          width: 5,
                        ),
                      ),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AccountPaymentInfoPage(
                                        id: item.id,
                                        callback: (value) {
                                          print(index);
                                          if (value != null) {
                                            setState(() {
                                              _vm.accountPayments[index] =
                                                  value;
                                            });
                                          }
                                        },
                                      )),
                            ).then((value) {
                              if (value != null) {
                                setState(() {
                                  _vm.accountPayments.removeAt(index);
                                });
                              }
                            });
                          },
                          title: Row(
                            children: <Widget>[
                              Expanded(
                                child: AutoSizeText(
                                  item.name ?? "",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: item.state == "draft"
                                          ? Colors.grey[600]
                                          : Colors.green),
                                  maxLines: 1,
                                ),
                              ),
                              Text(
                                  "${item.amount != null ? vietnameseCurrencyFormat(item.amount) : 0}",
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                          subtitle: Column(
                            children: <Widget>[
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      item.accountName ?? "",
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                  ),
                                  Text(
                                    " (${item.journalName ?? ""})",
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    Icons.person,
                                    size: 19,
                                    color: item.state == "draft"
                                        ? Colors.grey[400]
                                        : Colors.green.withOpacity(0.6),
                                  ),
                                  Expanded(
                                    child: Text(
                                      item.senderReceiver ?? "",
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(),
                              Row(
                                children: <Widget>[
                                  Container(
                                    width: 10,
                                    height: 10,
                                    margin: const EdgeInsets.only(right: 6),
                                    decoration: BoxDecoration(
                                        color: item.state == "draft"
                                            ? Colors.grey[400]
                                            : Colors.green.withOpacity(0.8),
                                        shape: BoxShape.circle),
                                  ),
                                  Text(
                                    item.state == "draft"
                                        ? S.current.draft
                                        : S.current.hasEnteredTheBook,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: item.state == "draft"
                                          ? Colors.grey[600]
                                          : Colors.green,
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Icon(
                                          Icons.date_range,
                                          size: 16,
                                          color: Colors.grey.withOpacity(0.7),
                                        ),
                                        Text(
                                          item.paymentDate != null
                                              ? DateFormat("dd-MM-yyyy HH:mm")
                                                  .format(item.paymentDate
                                                      .toLocal())
                                              : "",
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey[700],
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ));
  }
}
