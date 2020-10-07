import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/locator.dart';

import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/data_helper.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/screen_helper.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/widget_helper.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/view_model/fast_purchase_order_viewmodel.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_purchase_order.dart';

import 'fast_purchase_order_addedit.dart';
import 'fast_purchase_order_list.dart';
import 'fast_purchase_order_payment.dart';

// ignore: must_be_immutable
class FastPurchaseOrderDetails extends StatefulWidget {
  final bool isRefundFPO;
  final FastPurchaseOrderViewModel vm;

  @override
  _FastPurchaseOrderDetailsState createState() =>
      _FastPurchaseOrderDetailsState();

  FastPurchaseOrderDetails({this.isRefundFPO = false, @required this.vm});
}

class _FastPurchaseOrderDetailsState extends State<FastPurchaseOrderDetails> {
  FastPurchaseOrderViewModel _viewModel;

  BuildContext myContext;
  bool isLoading = false;
  @override
  void initState() {
    _viewModel = widget.vm;
    if (!widget.isRefundFPO) {
      turnOnLoadingScreen(text: "Đang tải dữ liệu");
      _viewModel.getDetailsFastPurchaseOrder().then((value) {
        turnOffLoadingScreen();
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    myContext = context;
    return ScopedModel<FastPurchaseOrderViewModel>(
      model: _viewModel,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          title: ScopedModelDescendant<FastPurchaseOrderViewModel>(
            builder: (context, child, model) {
              return Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "${model.currentOrder?.number ?? ""} ",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            },
          ),
          automaticallyImplyLeading: !isTablet(context),
        ),
        body: SafeArea(
          child: ScopedModelDescendant<FastPurchaseOrderViewModel>(
            builder: (context, child, model) {
              if (!model.isLoadingGetDetailsFastPurchaseOrder &&
                  model.currentOrder != null) {
                FastPurchaseOrder item = model.currentOrder;
                return Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: stateBar(model.currentOrder.state),
                            ),
                            _showCancelAlert(item),
                            _showCancelButton(item),
                            _showOrderInfo(item),
                            _showListItem(item),
                            _showInfoPrice(item),
                            _showMoreInfo(item),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        _showBottomSheet(item),
                      ],
                    ),
                    isLoading ? loadingScreen(text: loadingText) : SizedBox()
                  ],
                );
              } else if (model.currentOrder == null) {
                return Container(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.boxOpen,
                          color: Colors.grey,
                        ),
                        Text(
                          "Hãy chọn hóa đơn",
                          style: TextStyle(color: Colors.grey, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return loadingScreen(text: loadingText);
              }
            },
          ),
        ),
      ),
    );
  }

  bool isShowMenu = false;
  String loadingText;
  void turnOnLoadingScreen({String text}) {
    setState(() {
      isLoading = true;
      loadingText = text;
    });
  }

  void turnOffLoadingScreen() {
    setState(() {
      isLoading = false;
    });
  }

  Widget _showOneRowOrderInfo({String title, String value, Color color}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(flex: 4, child: Text(title ?? "")),
            Expanded(
              flex: 8,
              child: Text(
                "${value ?? "0"}",
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: color ?? Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Divider(),
      ],
    );
  }

  _showOrderInfo(FastPurchaseOrder item) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _showOneRowOrderInfo(
              title: "Nhà cung cấp", value: item.partner.displayName),
          _showOneRowOrderInfo(
              title: "Ngày đơn hàng",
              value: DateFormat("dd/MM/yyyy").format(item.dateInvoice)),
          _showOneRowOrderInfo(
              title: "Loại hoạt động", value: item.pickingType.nameGet),
          _showOneRowOrderInfo(
              title: "Phương thức TT", value: item.paymentJournal.name),
        ],
      ),
    );
  }

  _showListItem(FastPurchaseOrder item) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: ExpansionTile(
          initiallyExpanded: true,
          title: Text("Danh sách sản phẳm"),
          children: item.orderLines.map((lines) {
            return _showOneRowItem(lines);
          }).toList(),
        ),
      ),
    );
  }

  Widget _showOneRowItem(OrderLine lines) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          title: Text(lines.productNameGet),
          subtitle: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: RichText(
                  text: TextSpan(
                      text: "${lines.productQty} (${lines.productUom.name})",
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(text: "  x   "),
                        TextSpan(
                            text:
                                vietnameseCurrencyFormat(lines.priceUnit ?? 0),
                            style: TextStyle(color: Colors.blue)),
                        lines.discount > 0
                            ? TextSpan(text: " (giảm ${lines.discount})%")
                            : lines.discount > 0
                                ? TextSpan(
                                    text:
                                        " (giảm ${vietnameseCurrencyFormat(lines.discount)})")
                                : TextSpan(),
                      ]),
                ),
              ),
              Text(
                "${vietnameseCurrencyFormat(lines.priceSubTotal)}",
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
        ),
        Divider()
      ],
    );
  }

  Widget _showInfoPrice(FastPurchaseOrder item) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _showOneRowOrderInfo(
              title: "Cộng tiền",
              value: vietnameseCurrencyFormat(
                  _viewModel.getTotalCal(item.orderLines) ?? 0.0),
              color: Colors.black,
            ),
            item.discount != 0
                ? _showOneRowOrderInfo(
                    title: "Chiết khấu (${item.discount}%)",
                    value: vietnameseCurrencyFormat(item.discountAmount ?? 0.0),
                    color: Colors.black,
                  )
                : SizedBox(),
            item.decreaseAmount != 0
                ? _showOneRowOrderInfo(
                    title: "Giảm tiền",
                    value: vietnameseCurrencyFormat(item.decreaseAmount ?? 0.0),
                    color: Colors.black,
                  )
                : SizedBox(),
            _showOneRowOrderInfo(
              title: "Tổng tiền",
              value: vietnameseCurrencyFormat(item.amountTotal ?? 0.0),
              color: Colors.black,
            ),
            _showOneRowOrderInfo(
              title:
                  "Thanh toán ${item.paymentInfo.isNotEmpty ? "(lúc ${getDate(item.paymentInfo[0].date)})" : ""}",
              value: "${vietnameseCurrencyFormat((item.paymentAmount ?? 0))}",
            ),
            _showOneRowOrderInfo(
                title: "Còn nợ",
                value:
                    "${vietnameseCurrencyFormat(((item.paymentAmount ?? 0) - (item.amountTotal ?? 0)).abs())}",
                color: ((item.paymentAmount ?? 0) - (item.amountTotal ?? 0)) > 0
                    ? Colors.green
                    : Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _showCancelAlert(FastPurchaseOrder item) {
    return item.state != "cancel"
        ? SizedBox()
        : Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: MyCustomerAlerCard(text: "Hóa đơn này đã bị hủy bỏ"),
          );
  }

  Widget _showMoreInfo(FastPurchaseOrder item) {
    return Padding(
      padding: EdgeInsets.only(top: 8, bottom: 70),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: ExpansionTile(
          title: Text("Thông tin khác"),
          children: <Widget>[
            _showOneRowOrderInfo(
              title: "Trạng thái",
              value: getStateVietnamese(item.state),
            ),
            _showOneRowOrderInfo(
              title: "Chịu trách nhiệm",
              value: item.userName,
            ),
            _showOneRowOrderInfo(
              title: "Ghi chú",
              value: item.note ?? "",
            ),
          ],
        ),
      ),
    );
  }

  _showBottomSheet(FastPurchaseOrder item) {
    return Container(
      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
      color: Colors.grey.shade200,
      child: item.state != "open" && item.state != "draft"
          ? SizedBox()
          : Container(
              height: 50,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(3),
                                bottomLeft: Radius.circular(3),
                              ),
                            ),
                            onPressed: () {
                              if (item.state == "open") {
                                showDialog(
                                  context: context,
                                  builder: (context) => FastPurchasePayment(
                                    vm: _viewModel,
                                  ),
                                );
                              } else {
                                turnOnLoadingScreen(text: "Đang xác nhận");
                                _viewModel.actionOpenInvoice().then(
                                  (value) {
                                    locator<FastPurchaseOrderViewModel>()
                                        .currentOrder = value;
                                    turnOffLoadingScreen();
                                    if (!isTablet(context)) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              FastPurchaseOrderDetails(
                                            vm: _viewModel,
                                          ),
                                        ),
                                      );
                                    } else {
                                      _viewModel.getDetailsFastPurchaseOrder();
                                      _viewModel.loadData();
                                    }
                                  },
                                ).catchError(
                                  (error) {
                                    turnOffLoadingScreen();
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text("Thất bại"),
                                        content: Text(
                                          "${error.toString().replaceAll("Exception:", "")}",
                                        ),
                                        actions: <Widget>[
                                          MaterialButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("Đóng"),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  item.state == "open"
                                      ? "THANH TOÁN "
                                      : "XÁC NHẬN",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "${vietnameseCurrencyFormat(((item.paymentAmount ?? 0) - (item.amountTotal ?? 0)).abs())}",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(3),
                              bottomRight: Radius.circular(3),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              isShowMenu = !isShowMenu;
                            });
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => BottomSheet(
                                builder: (BuildContext context) {
                                  return ListTile(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    leading: Icon(Icons.print),
                                    title: Text("in"),
                                  );
                                },
                                onClosing: () {
                                  print("Haha");
                                },
                              ),
                            );
                          },
                          color: Colors.white,
                          child: Icon(Icons.more_horiz),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _showCancelButton(FastPurchaseOrder item) {
    if (item.state == "draft") {
      return showEditDraftOrder();
    } else if (item.state == "paid") {
      return Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          showCancelPaidOrder(item),
          showEditPaidOpenOrder(item),
          showRefundOrder(),
        ],
      );
    } else if (item.state == "open") {
      return Row(
        children: <Widget>[
          showCancelPaidOrder(item),
          showEditPaidOpenOrder(item),
          showRefundOrder(),
        ],
      );
    } else {
      return SizedBox();
    }
  }

  Widget showEditPaidOpenOrder(FastPurchaseOrder item) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: RaisedButton(
          color: Colors.deepPurple,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                TextEditingController noteController = TextEditingController();
                noteController.text = item.note;
                return AlertDialog(
                  title: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "Sửa",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.cancel,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: TextField(
                            controller: noteController,
                            autofocus: true,
                            decoration: InputDecoration(
                              labelText: "Ghi chú",
                              enabledBorder: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    MaterialButton(
                      child: Text("Lưu"),
                      onPressed: () {
                        _viewModel
                            .editNoteInvoice(noteController.text)
                            .then((result) {
                          if (result) {
                            Navigator.pop(context);
                          }
                        }).catchError((error) {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                "Thất bại",
                                style: TextStyle(color: Colors.red),
                              ),
                              content: Text("$error"),
                              actions: <Widget>[
                                MaterialButton(
                                  child: Text("Đóng"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ),
                          );
                        });
                      },
                    )
                  ],
                );
              },
            );
          },
          child: Text(
            "Sửa hóa đơn",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget showEditDraftOrder() {
    return RaisedButton(
      color: Colors.deepPurple,
      onPressed: () {
        if (!isTablet(context)) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => FastPurchaseOrderAddEditPage(
                isEdit: true,
                vm: _viewModel,
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FastPurchaseOrderAddEditPage(
                isEdit: true,
                vm: _viewModel,
              ),
            ),
          );
        }
      },
      child: Text(
        "Sửa",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget showCancelPaidOrder(FastPurchaseOrder item) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: RaisedButton(
          color: Colors.redAccent,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Yêu cầu xác nhận"),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.cancel,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
                content: Text("Bạn có muốn hủy đơn: ${item.number}"),
                actions: <Widget>[
                  RaisedButton(
                    color: Colors.redAccent,
                    child: Text(
                      "Hủy hóa đơn",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      turnOnLoadingScreen(text: "Đang hủy hóa đơn");
                      Navigator.pop(context);
                      _viewModel.cancelOrder(item.id).then(
                        (result) {
                          turnOffLoadingScreen();
                          if (result == "Success") {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Thành công"),
                                content: Text("Đã hủy ${item.number}"),
                              ),
                            );
                          }
                        },
                      );
                    },
                  )
                ],
              ),
            );
          },
          child: Text(
            "Hủy hóa đơn",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget showRefundOrder() {
    if (_viewModel.currentOrder.type == "refund") {
      return SizedBox();
    }
    return Expanded(
      child: RaisedButton(
        color: Colors.white,
        onPressed: () {
          turnOnLoadingScreen(text: "Đang tạo trả hàng");
          _viewModel.createRefundOrder().then(
            (value) {
              turnOffLoadingScreen();
              if (value != null) {
                if (!isTablet(context)) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FastPurchaseOrderDetails(
                        vm: _viewModel,
                      ),
                    ),
                  );
                } else {
                  _viewModel.getDetailsFastPurchaseOrder();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FastPurchaseOrderListPage(
                        vm: _viewModel,
                        isRefund: true,
                      ),
                    ),
                  );
                }
              }
            },
          ).catchError(
            (error) {
              turnOffLoadingScreen();
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Thất bại"),
                  content: Text("$error"),
                ),
              );
            },
          );
        },
        child: Text("Tạo trả hàng"),
      ),
    );
  }
}
