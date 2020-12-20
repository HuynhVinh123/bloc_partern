import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/app_core/ui_base/app_bar_button.dart';
import 'package:tpos_mobile/locator.dart';

import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/data_helper.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/screen_helper.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/widget_helper.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/view_model/fast_purchase_order_viewmodel.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_purchase_order.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import 'fast_purchase_order_addedit.dart';
import 'fast_purchase_order_details.dart';

class FastPurchaseOrderListPage extends StatefulWidget {
  final bool isRefund;

  @override
  _FastPurchaseOrderListPageState createState() =>
      _FastPurchaseOrderListPageState();
  // ignore: sort_constructors_first
  const FastPurchaseOrderListPage({this.isRefund = false, this.vm});
  final FastPurchaseOrderViewModel vm;
}

class _FastPurchaseOrderListPageState extends State<FastPurchaseOrderListPage> {
  FastPurchaseOrderViewModel _viewModel;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String sortValue;
  double topBarHeight = 100;
  ScrollController _scrollController;
  bool isOpenPickState = false;
  bool isOpenPickTime = false;
  double screenWidth;

  bool isShowSearchField = false;

  TextEditingController searchController = TextEditingController();

  FocusNode searchFocusNode;

  @override
  void initState() {
    _viewModel = widget.vm ?? locator<FastPurchaseOrderViewModel>();
    //_viewModel.currentOrder = null;
    _viewModel.isRefund = widget.isRefund;

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _viewModel.init();
    _viewModel.loadData();

    super.initState();
  }

  // ignore: always_declare_return_types
  _scrollListener() {}

  @override
  Widget build(BuildContext context) {

    /*if (isShowSearchField) {
      FocusScope.of(context).requestFocus(searchFocusNode);
    }*/
    screenWidth ??= MediaQuery.of(context).size.width;

    return ScopedModel<FastPurchaseOrderViewModel>(
      model: _viewModel,
      child: Scaffold(
        body: !isTablet(context)
            ? _buildPage()
            : Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(
                    width: getHalfPortraitWidth(context),
                    child: _buildPage(),
                  ),
                  Container(
                    width: 1,
                    color: Colors.grey,
                  ),
                  ScopedModelDescendant<FastPurchaseOrderViewModel>(
                    builder: (context, child, model) {
                      return Expanded(
                        child: FastPurchaseOrderDetails(
                          vm: _viewModel,
                        ),
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildPage() {
    return ScopedModelDescendant<FastPurchaseOrderViewModel>(
      builder: (context, child, model) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.grey.shade200,
          appBar: _buildAppBar(model),
          body: _buildBody(),
        );
      },
    );
  }

  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        _showListFastPurchaseOrders(),
        _showToolBar(),
      ],
    );
  }

  Widget _buildAppBar(FastPurchaseOrderViewModel model) {
    return model.isPickToDeleteMode
        ? AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: Text(
              _viewModel.listPickedItem.length.toString(),
              style: const TextStyle(color: Colors.green),
            ),
            leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.green,
                ),
                onPressed: () {
                  setState(() {
                    model.isPickToDeleteMode = false;
                    _viewModel.turnOffEditMode();
                  });
                }),
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  model.deletePickedItem().then(
                    (result) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: Text("$result}"),
                          actions: <Widget>[
                            MaterialButton(
                              child: const Text("OK"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(
                  Icons.delete_forever,
                  color: Colors.green,
                ),
              ),
            ],
          )
        : AppBar(
            title: !isShowSearchField
                ? Text(
                    "${S.current.fastPurchase_invoice} ${widget.isRefund ? S.current.returned : S.current.purchase}",
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      decoration: const BoxDecoration(color: Colors.white),
                      child: TextField(
                        focusNode: searchFocusNode,
                        onTap: () {
                          setState(() {
                            isOpenPickState = false;
                            isOpenPickTime = false;
                          });
                        },
                        autofocus: true,
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: "${S.current.search}...",
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              searchController.text = "";
                              _viewModel.loadData();
                            },
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                        ),
                        onChanged: (text) {
                          _viewModel.onChangeSearchText(text);
                        },
                      ),
                    ),
                  ),
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  isShowSearchField = !isShowSearchField;
                  isOpenPickState = false;
                  isOpenPickTime = false;

                  setState(() {});
                },
                icon: const Icon(Icons.search),
              ),
              AppbarIconButton(
                isEnable: true,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FastPurchaseOrderAddEditPage(
                        vm: _viewModel,
                      ),
                    ),
                  );
                  setState(() {
                    isOpenPickState = false;
                    isOpenPickTime = false;
                  });
                },
                icon: const Icon(Icons.add),
              ),
            ],
          );
  }

  Widget _showToolBar() {
    return Column(
      mainAxisSize: isOpenPickState || isOpenPickTime
          ? MainAxisSize.max
          : MainAxisSize.min,
      children: <Widget>[
        _buildDropDown(),
        _showCustomDivider(),
        if (isOpenPickState) _showStateList() else const SizedBox(),
        if (isOpenPickTime) _showFilterDate() else const SizedBox(),
        if (isOpenPickState || isOpenPickTime)
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (isOpenPickTime) {
                    isOpenPickTime = false;
                    _viewModel.onCloseTimeDropDown();
                  } else if (isOpenPickState) {
                    isOpenPickState = false;
                    _viewModel.onCloseStateDropDown();
                  }
                });
              },
              child: Container(
                color: Colors.black45,
              ),
            ),
          )
        else
          const SizedBox()
      ],
    );
  }

  Widget _showCustomDivider() {
    return ScopedModelDescendant<FastPurchaseOrderViewModel>(
      builder: (context, child, model) {
        return SizedBox(
          height: 1.5,
          child: Stack(
            children: <Widget>[
              Container(
                height: 1.5,
                color: (model.isFilterByState() && isOpenPickState) ||
                        (model.isFilterByTime() && isOpenPickTime)
                    ? Colors.green
                    : Colors.grey.shade200,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(9.5, 0, 9.5, 0),
                      child: Container(
                        height: 1.5,
                        color: isOpenPickState
                            ? Colors.white
                            : (model.isFilterByTime() && isOpenPickTime)
                                ? Colors.green
                                : Colors.grey.shade200,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(9.5, 0, 9.5, 0),
                      child: Container(
                        height: 1.5,
                        color: isOpenPickTime
                            ? Colors.white
                            : (model.isFilterByState() && isOpenPickState)
                                ? Colors.green
                                : Colors.grey.shade200,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildDropDown() {
    return ScopedModelDescendant<FastPurchaseOrderViewModel>(
      builder: (context, child, model) {
        return Container(
          color: Colors.white,
          height: 50,
          child: Row(
            children: <Widget>[
              Expanded(
                child: _showStateListDropDown(model),
              ),
              Expanded(
                child: _showDateListDropDown(model),
              ),
            ],
          ),
        );
      },
    );
  }

  Padding _showStateListDropDown(FastPurchaseOrderViewModel model) {
    final BorderSide borderSide = BorderSide(
        color: model.isFilterByState() ? Colors.green : Colors.grey.shade200,
        width: 1.5);
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 8, 8, isOpenPickState ? 0 : 8),
      child: Container(
        padding: EdgeInsets.only(bottom: isOpenPickState ? 8 : 0),
        decoration: BoxDecoration(
          border: isOpenPickState
              ? Border(right: borderSide, top: borderSide, left: borderSide)
              : const Border(),
        ),
        child: Stack(
          children: <Widget>[
            MaterialButton(
              elevation: 0,
              onPressed: () {},
              color:
                  model.isFilterByState() ? Colors.green : Colors.grey.shade100,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Icon(
                Icons.check,
                size: 12,
                color: model.isFilterByState()
                    ? Colors.white
                    : Colors.grey.shade200,
              ),
            ),
            MaterialButton(
              elevation: 0,
              color: isOpenPickState || model.isFilterByState()
                  ? Colors.white
                  : Colors.grey.shade100,
              shape: BeveledRectangleBorder(
                side: BorderSide(
                    width: 0.5,
                    color: model.isFilterByState() && !isOpenPickState
                        ? Colors.green
                        : Colors.transparent),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isOpenPickState ? 0 : 18)),
              ),
              onPressed: () {
                setState(() {
                  isShowSearchField = false;
                  isOpenPickTime = false;
                  isOpenPickState = !isOpenPickState;
                  if (isOpenPickState == false) {
                    _viewModel.onCloseStateDropDown();
                  }
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  // Trạng thái được áp dụng
                  Expanded(
                    child: Text(
                      model.listFilterStateTemp.isEmpty || isOpenPickState
                          ? S.current.status
                          : model.countState == 1
                              ? model.tempStateFilterName
                              : model.countState == 0
                                  ? S.current.status
                                  : "${S.current.fastPurchase_has} ${model.countState} ${S.current.fastPurchase_statusApplied}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: model.isFilterByState()
                            ? Colors.green
                            : Colors.black,
                      ),
                    ),
                  ),
                  Icon(
                    isOpenPickState
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color:
                        model.isFilterByState() ? Colors.green : Colors.black,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _showDateListDropDown(FastPurchaseOrderViewModel model) {
    final BorderSide borderSide = BorderSide(
        color: model.isFilterByTime() ? Colors.green : Colors.grey.shade200,
        width: 1.5);
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 8, 8, isOpenPickTime ? 0 : 8),
      child: Container(
        padding: EdgeInsets.only(bottom: isOpenPickTime ? 8 : 0),
        decoration: BoxDecoration(
            border: isOpenPickTime
                ? Border(right: borderSide, top: borderSide, left: borderSide)
                : const Border()),
        child: Stack(
          children: <Widget>[
            MaterialButton(
              elevation: 0,
              onPressed: () {},
              color:
                  model.isFilterByTime() ? Colors.green : Colors.grey.shade100,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Icon(
                Icons.check,
                size: 12,
                color: model.isFilterByState()
                    ? Colors.white
                    : Colors.grey.shade200,
              ),
            ),
            MaterialButton(
              elevation: 0,
              color: isOpenPickTime || model.isFilterByTime()
                  ? Colors.white
                  : Colors.grey.shade100,
              shape: BeveledRectangleBorder(
                side: BorderSide(
                    width: 0.5,
                    color: model.isFilterByTime() && !isOpenPickTime
                        ? Colors.green
                        : Colors.transparent),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isOpenPickTime ? 0 : 18),
                ),
              ),
              onPressed: () {
                setState(() {
                  isShowSearchField = false;
                  isOpenPickState = false;
                  isOpenPickTime = !isOpenPickTime;
                  if (!isOpenPickTime) {
                    model.onCloseTimeDropDown();
                  }
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  // Chọn ngày
                  Expanded(
                    child: Text(
                      model.isFilterByTime() && !isOpenPickTime
                          ? model.tempTimeFilterName == S.current.chooseDate
                              ? "${model.tempFromDate.toString().substring(0, 5)} - ${model.tempToDate.toString().substring(0, 5)}"
                              : model.tempTimeFilterName
                          : S.current.time,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: model.isFilterByTime()
                              ? Colors.green
                              : Colors.black),
                    ),
                  ),
                  Icon(
                    isOpenPickTime
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: model.isFilterByTime() ? Colors.green : Colors.black,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _showListFastPurchaseOrders() {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Scrollbar(
        child: ScopedModelDescendant<FastPurchaseOrderViewModel>(
          builder: (context, child, model) {
            // Có dữ liệu
            if (model.result == S.current.hasData) {
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    _showToolbar(),
                    ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(top: 10),
                      shrinkWrap: true,
                      itemCount: model.listForDisplay.length,
                      itemBuilder: (context, index) {
                        final FastPurchaseOrder item =
                            model.listForDisplay[index];
                        return _showListItemFastPurchaseOrderItem(item);
                      },
                    ),
                  ],
                ),
              );
            } else if (model.result == S.current.loading) {
              return loadingScreen();
            } else {
              return Scaffold(
                backgroundColor: Colors.grey.shade100,
                body: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.sms,
                        size: 50,
                        color: Colors.grey.shade300,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          model.result,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ),
                      RaisedButton(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              model.isFilterByTime() && model.isFilterByState()
                                  ? S.current.reset
                                  : S.current.reload,
                              style: const TextStyle(color: Colors.white),
                            ),
                            const Icon(
                              Icons.refresh,
                              color: Colors.white,
                            )
                          ],
                        ),
                        onPressed: () {
                          model.resetFilter();
                        },
                      )
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _showListItemFastPurchaseOrderItem(FastPurchaseOrder item) {
    return ScopedModelDescendant<FastPurchaseOrderViewModel>(
      builder: (context, child, model) {
        return GestureDetector(
          onLongPress: () {
            setState(() {
              model.isPickToDeleteMode = true;
              model.onEditModeItemTap(item.id);
            });
          },
          onTap: () {
            if (model.isPickToDeleteMode) {
              model.onEditModeItemTap(item.id);
            } else {
              model.currentOrder = item;
              if (!isTablet(context)) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FastPurchaseOrderDetails(
                      vm: _viewModel,
                    ),
                  ),
                );
              } else {
                setState(() {
                  _viewModel.getDetailsFastPurchaseOrder();
                });
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: getStateColor(item.state).withOpacity(0.5),
                        width: 5,
                      ),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 1,
                          offset: const Offset(0, 2),
                        )
                      ],
                      border: Border.all(
                        width: model.isPickToDeleteMode &&
                                model.isExistInListEdit(item.id)
                            ? 2
                            : 1,
                        color: model.isPickToDeleteMode &&
                                model.isExistInListEdit(item.id)
                            ? Colors.green
                            : Colors.white,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        if (model.isPickToDeleteMode)
                          IconButton(
                            onPressed: () {
                              model.onEditModeItemTap(item.id);
                            },
                            icon: model.isExistInListEdit(item.id)
                                ? const Icon(Icons.check_circle)
                                : const Icon(Icons.radio_button_unchecked),
                          )
                        else
                          const SizedBox(),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 0, 4, 0),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(0),
                                  title: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          item.number ?? S.current.draft,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: getStateColor(item.state),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            vietnameseCurrencyFormat(
                                                    item.amountTotal ?? 0) ??
                                                "",
                                            style: const TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Icon(
                                              Icons.more_horiz,
                                              size: 18,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  subtitle: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          item.partnerDisplayName ?? "",
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      if (item.partnerPhone != null)
                                        Text(
                                          "${item.partnerPhone}",
                                          style: const TextStyle(
                                            color: Colors.black54,
                                          ),
                                        )
                                      else
                                        const SizedBox(),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                height: 1,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 6, 16, 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Container(
                                            height: 8,
                                            width: 8,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color:
                                                      getStateColor(item.state)
                                                          .withOpacity(0.8),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 0),
                                                )
                                              ],
                                              color: getStateColor(item.state),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          getStateVietnamese(item.state ?? ""),
                                          style: TextStyle(
                                            color: getStateColor(item.state),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      DateFormat("dd/MM/yyyy  HH:mm")
                                          .format(item.dateInvoice),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _showToolbar() {
    return ScopedModelDescendant<FastPurchaseOrderViewModel>(
      builder: (context, child, model) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              DropdownButtonHideUnderline(
                child: DropdownButton(
                  value: model.fastPurchaseOrderSort.field,
                  onChanged: (value) {
                    model.onSortChange(value);
                  },
                  items: [
                    _showDropDownMenuItem("DateInvoice"),
                    _showDropDownMenuItem("AmountTotal"),
                    _showDropDownMenuItem("Number"),
                  ],
                ),
              ),
              Expanded(
                child: Text(
                  "Σ: ${vietnameseCurrencyFormat(model.totalAmount)}",
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              /* InkWell(
                onTap: () {},
                child: Row(
                  children: <Widget>[
                    Text(
                      "Lọc",
                    ),
                    Badge(
                      badgeContent: Text(
                        "1",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      child: Icon(
                        Icons.filter_list,
                      ),
                    )
                  ],
                ),
              ),*/
            ],
          ),
        );
      },
    );
  }

  DropdownMenuItem _showDropDownMenuItem(String value) {
    return DropdownMenuItem<String>(
        value: value,
        child: Row(children: <Widget>[
          Text(getSortVietnamese(value)),
          if (_viewModel.fastPurchaseOrderSort.dir == "asc" &&
              _viewModel.fastPurchaseOrderSort.field == value)
            const Icon(Icons.arrow_upward)
          else
            const Icon(Icons.arrow_downward)
        ]));
  }

  Widget _showStateList() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                //Đã thanh toán
                Expanded(
                  child: _buildCustomBtn(
                      text: S.current.paid,
                      callBack: () {
                        _viewModel.onTapStateBtn(S.current.paid);
                      }),
                ),
                // Xác nhận
                Expanded(
                  child: _buildCustomBtn(
                      text: S.current.confirm,
                      callBack: () {
                        _viewModel.onTapStateBtn(S.current.confirm);
                      }),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                // Hủy bỏ
                Expanded(
                  child: _buildCustomBtn(
                      text: S.current.cancel,
                      callBack: () {
                        _viewModel.onTapStateBtn(S.current.cancel);
                      }),
                ),
                //nháp
                Expanded(
                  child: _buildCustomBtn(
                      text: S.current.draft,
                      callBack: () {
                        _viewModel.onTapStateBtn(S.current.draft);
                      }),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                    child: MaterialButton(
                      onPressed: () {
                        _viewModel.resetFilterState();
                      },
                      child: Text(
                        S.current.reset,
                        style: const TextStyle(color: Colors.green),
                      ),
                      color: Colors.white,
                      shape: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                    child: MaterialButton(
                      onPressed: () {
                        _viewModel.loadData();
                        setState(() {
                          isOpenPickState = false;
                        });
                      },
                      child: Text(
                        S.current.apply,
                        style: const TextStyle(color: Colors.white),
                      ),
                      color: Colors.green,
                      shape: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _showFilterDate() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                // Hôm nay
                Expanded(
                  child: _buildCustomBtn(
                      text: S.current.today,
                      callBack: () {
                        _viewModel.onFilterDateTap(S.current.today);
                      }),
                ),
                Expanded(
                  child: _buildCustomBtn(
                      text: S.current.yesterday,
                      callBack: () {
                        _viewModel.onFilterDateTap(S.current.yesterday);
                      }),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: _buildCustomBtn(
                      text: S.current.filter_30daysAgo,
                      callBack: () {
                        _viewModel.onFilterDateTap(S.current.filter_30daysAgo);
                      }),
                ),
                Expanded(
                  child: _buildCustomBtn(
                      text: S.current.filter_7daysAgo,
                      callBack: () {
                        _viewModel.onFilterDateTap(S.current.filter_7daysAgo);
                      }),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: ScopedModelDescendant<FastPurchaseOrderViewModel>(
                    builder: (context, child, model) {
                      // Chọn ngày
                      final bool active =
                          model.filterDateTemp.name == S.current.chooseDate;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Stack(
                          children: <Widget>[
                            MaterialButton(
                              onPressed: () {},
                              elevation: 0,
                              color: Colors.green,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 6.0),
                              child: Icon(
                                Icons.check,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                            MaterialButton(
                              elevation: 0,
                              color:
                                  active ? Colors.white : Colors.grey.shade100,
                              shape: BeveledRectangleBorder(
                                side: BorderSide(
                                    width: 0.5,
                                    color: active
                                        ? Colors.green
                                        : Colors.transparent),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(active ? 18 : 0)),
                              ),
                              child: active
                                  ? Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          getDate(
                                              model.filterDateTemp.fromDate),
                                          style: const TextStyle(
                                              color: Colors.green),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward,
                                          color: Colors.green,
                                        ),
                                        Text(
                                          getDate(model.filterDateTemp.toDate),
                                          style: const TextStyle(
                                              color: Colors.green),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(S.current.chooseDate)
                                      ],
                                    ),
                              onPressed: () async {
                                final List<DateTime> picked =
                                    await DateRagePicker.showDatePicker(
                                        context: context,
                                        initialFirstDate: _viewModel
                                                .filterDateTemp.fromDate ??
                                            DateTime.now(),
                                        initialLastDate: _viewModel
                                                .filterDateTemp.toDate ??
                                            DateTime.now()
                                                .add(const Duration(days: 7)),
                                        firstDate: DateTime(2015),
                                        lastDate: DateTime.now()
                                            .add(const Duration(days: 1500)));

                                if (picked != null /*&& picked.length == 2*/) {
                                  _viewModel.onPickDateFilter(
                                    fromDate: picked[0],
                                    toDate: picked.length == 2
                                        ? picked[1]
                                        : picked[0],
                                  );
                                  print(picked);
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
            Text(
              "${getDate(_viewModel.filterDateTemp.fromDate) ?? ""} - ${getDate(_viewModel.filterDateTemp.toDate) ?? ""}",
              style: const TextStyle(color: Colors.green),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                    child: MaterialButton(
                      onPressed: () {
                        _viewModel.resetFilterTime();
                      },
                      child: Text(
                        S.current.reset,
                        style: const TextStyle(color: Colors.green),
                      ),
                      color: Colors.white,
                      shape: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                    child: MaterialButton(
                      onPressed: () {
                        _viewModel.loadData();
                        setState(() {
                          isOpenPickTime = false;
                        });
                      },
                      child: Text(
                        S.current.apply,
                        style: const TextStyle(color: Colors.white),
                      ),
                      color: Colors.green,
                      shape: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomBtn({String text, VoidCallback callBack}) {
    return ScopedModelDescendant<FastPurchaseOrderViewModel>(
      builder: (context, child, model) {
        final bool active = model.isInExistInFilterStateList(text) ||
            model.isInExistInFilterDate(text);
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Stack(
            children: <Widget>[
              MaterialButton(
                elevation: 0,
                onPressed: () {},
                color: active ? Colors.green : Colors.grey.shade200,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Icon(
                  Icons.check,
                  size: 12,
                  color: active ? Colors.white : Colors.grey.shade200,
                ),
              ),
              MaterialButton(
                onPressed: () {
                  callBack();
                },
                elevation: 0,
                color: active ? Colors.white : Colors.grey.shade200,
                shape: BeveledRectangleBorder(
                  side: BorderSide(
                      width: 0.5,
                      color: active ? Colors.green : Colors.transparent),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(active ? 18 : 0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      text,
                      style: TextStyle(
                        color: active ? Colors.green : Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
