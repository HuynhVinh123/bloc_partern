import 'package:auto_size_text/auto_size_text.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:tpos_mobile/locator.dart';

import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/feature_group/category/product_search_page.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/data_helper.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/screen_helper.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/widget_helper.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/view_model/fast_purchase_order_addedit_viewmodel.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/view_model/fast_purchase_order_viewmodel.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';

import 'package:tpos_mobile/services/log_services/log_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_purchase_order.dart';
import 'package:tpos_mobile/src/tpos_apis/models/product.dart';
import 'package:tpos_mobile/widgets/number_input_left_right_widget.dart';

import 'fast_purchase_info_payment_page.dart';
import 'fast_purchase_order_details.dart';
import 'fast_purchase_order_line_edit_page.dart';
import 'fast_purchase_order_pick_partner.dart';
import 'fast_purchase_order_pick_product.dart';

class FastPurchaseOrderAddEditPage extends StatefulWidget {
  final bool isEdit;

  @override
  _FastPurchaseOrderAddEditPageState createState() =>
      _FastPurchaseOrderAddEditPageState();

  final FastPurchaseOrderViewModel vm;

  FastPurchaseOrderAddEditPage({this.isEdit = false, @required this.vm});
}

class _FastPurchaseOrderAddEditPageState
    extends State<FastPurchaseOrderAddEditPage> {
  FastPurchaseOrderAddEditViewModel _viewModel =
      locator<FastPurchaseOrderAddEditViewModel>();

  FastPurchaseOrderViewModel _orderViewModel;

  TextEditingController noteController = new TextEditingController();
  final _log = locator<LogService>();
  @override
  void initState() {
    _orderViewModel = widget.vm;

    turnOnLoadingScreen(text: "Đang tải dữ liệu");
    _viewModel.isRefund = locator<FastPurchaseOrderViewModel>().isRefund;

    if (!widget.isEdit) {
      _viewModel.getDefaultForm().then((value) {
        turnOffLoadingScreen();
        noteController.text =
            _viewModel.defaultFPO != null ? _viewModel.defaultFPO.note : "";
      });
    } else {
      _viewModel.setDefaultFPO(_orderViewModel.currentOrder);
      turnOffLoadingScreen();
      noteController.text = _viewModel.defaultFPO?.note ?? "";
    }

    _viewModel.getApplicationUser();
    super.initState();
  }

  bool isLoading = true;
  String loadingText;
  @override
  Widget build(BuildContext context) {
    return ScopedModel<FastPurchaseOrderAddEditViewModel>(
      model: _viewModel,
      child: WillPopScope(
        onWillPop: () async {
          var isClose = await myOnBackPress(context);
          if (isClose) {
            return true;
          } else {
            return false;
          }
        },
        child: Scaffold(
          appBar: _buildAppbar(),
          backgroundColor: Colors.grey.shade200,
          body: _buildBody(),
        ),
      ),
    );
  }

  Future myOnBackPress(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Xác nhận đóng"),
        content: Text(
            "Các thông tin chưa lưu sẽ bị xóa. Bạn có muốn đóng trang này?"),
        actions: <Widget>[
          MaterialButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text(
              "HỦY BỎ",
            ),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text(
              "XÁC NHẬN",
            ),
          ),
        ],
      ),
    );
  }

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

  Widget _buildAppbar() {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Text(
        "${widget.isEdit ? "Sửa" : "Tạo"} hóa đơn ${_viewModel.isRefund ? "trả hàng" : "nhập hàng"}",
        style: TextStyle(color: Colors.black),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.clear,
          color: Colors.grey,
        ),
        onPressed: () async {
          var isClose = await myOnBackPress(context);
          if (isClose) {
            Navigator.pop(context);
          }
        },
      ),
      actions: <Widget>[
        ScopedModelDescendant<FastPurchaseOrderAddEditViewModel>(
          builder: (context, child, model) {
            bool isValid = model.defaultFPO != null &&
                model.defaultFPO.partner != null &&
                (model.defaultFPO.orderLines != null ||
                    model.defaultFPO.orderLines.isNotEmpty);
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: InkWell(
                onTap: () async {
                  if (isValid) {
                    if (!widget.isEdit) {
                      turnOnLoadingScreen(text: "Đang lưu nháp");
                      model.actionDraftInvoice().then((value) {
                        locator<FastPurchaseOrderViewModel>().currentOrder =
                            value;
                        turnOffLoadingScreen();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FastPurchaseOrderDetails(
                              vm: _orderViewModel,
                            ),
                          ),
                        );
                      }).catchError((error) {
                        turnOffLoadingScreen();
                        myErrorDialog(
                          context: context,
                          content: error.toString(),
                        );
                      });
                    } else {
                      turnOnLoadingScreen(text: "Đang lưu nháp");
                      model.editActionDraftInvoice().then((value) {
                        locator<FastPurchaseOrderViewModel>().currentOrder =
                            value;
                        turnOffLoadingScreen();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FastPurchaseOrderDetails(
                              vm: _orderViewModel,
                            ),
                          ),
                        );
                      }).catchError((error) {
                        turnOffLoadingScreen();
                        myErrorDialog(
                          context: context,
                          content: error.toString(),
                        );
                      });
                    }
                  }
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.save,
                      color: isValid ? Colors.blue : Colors.grey,
                    ),
                    Text(
                      "Nháp",
                      style:
                          TextStyle(color: isValid ? Colors.blue : Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
        )
      ],
    );
  }

  Widget _buildBody() {
    return ScopedModelDescendant<FastPurchaseOrderAddEditViewModel>(
      builder: (context, child, model) {
        if ((!model.isLoadingDefaultForm &&
                model.applicationUsers.isNotEmpty) ||
            isLoading) {
          return SafeArea(
            child: Stack(
              children: <Widget>[
                model.defaultFPO == null
                    ? SizedBox()
                    : SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Visibility(
                              visible: false,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: stateBar(widget.isEdit
                                    ? model.defaultFPO?.state
                                    : null),
                              ),
                            ),
                            !isTablet(context)
                                ? Column(
                                    children: <Widget>[
                                      _showPickPartner(model),
                                      _showListLines(model),
                                      _showPaymentInfo(model),
                                      _showAnotherInfo(model),
                                    ],
                                  )
                                : Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          children: <Widget>[
                                            _showPickPartner(model),
                                            _showListLines(model),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: getHalfPortraitWidth(context),
                                        child: Column(
                                          children: <Widget>[
                                            _showPaymentInfo(model),
                                            _showAnotherInfo(model),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                            SizedBox(
                              height: 100,
                            )
                          ],
                        ),
                      ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: myBtn(),
                ),
                isLoading ? loadingScreen(text: loadingText) : SizedBox()
              ],
            ),
          );
        } else {
          return loadingScreen(text: "Đang tải");
        }
      },
    );
  }

  Widget _showPickPartner(FastPurchaseOrderAddEditViewModel model) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PagePickPartnerFPO(
              vm: _viewModel,
            ),
          ),
        );
      },
      child: showCustomContainer(
        child: ListTile(
          contentPadding: EdgeInsets.only(left: 10, right: 10),
          leading: Icon(
            Icons.people,
            color: Colors.green,
          ),
          title: Row(
            children: <Widget>[
              Text(
                "Nhà cung cấp",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Expanded(
                child: Text(
                  model.defaultFPO?.partner != null
                      ? model.defaultFPO.partner.name
                      : "Chọn NCC",
                  textAlign: TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_right,
                color: Colors.grey,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _showListLines(FastPurchaseOrderAddEditViewModel model) {
    List<OrderLine> lines = model.defaultFPO?.orderLines;
    return model.defaultFPO?.partner == null
        ? SizedBox()
        : showCustomContainer(
            child: StickyHeader(
              header: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      offset: Offset(0, 5),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        Icons.shopping_cart,
                        color: Colors.green,
                      ),
                      title: Text("Danh sách sản phẩm"),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          child: OutlineButton(
                            color: Colors.grey,
                            onPressed: null,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(
                                  Icons.home,
                                  color: Colors.green,
                                ),
                                Expanded(
                                  child: AutoSizeText(
                                    "${model.defaultFPO.company.name}",
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: OutlineButton(
                            color: Colors.grey,
                            onPressed: () async {
                              Product selectedProduct;
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductSearchPage(
                                    isPriceUnit: true,
                                    onSelected: (value) {
                                      if (value != null) {
                                        selectedProduct = value;
                                      }
                                    },
                                  ),
                                ),
                              );
                              if (selectedProduct != null) {
                                turnOnLoadingScreen(
                                    text:
                                        "Đang thêm ${selectedProduct.nameGet}");
                                _viewModel
                                    .addOrderLineCommand(selectedProduct)
                                    .then((_) {
                                  turnOffLoadingScreen();
                                }).catchError((error, s) {
                                  turnOffLoadingScreen();
                                  _log.error("", error, s);
                                  myErrorDialog(
                                      context: context,
                                      content: error.toString());
                                });
                              }
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(
                                  Icons.search,
                                  color: Colors.green,
                                ),
                                Expanded(child: AutoSizeText("Tìm sản phẩm")),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          child: OutlineButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () async {
                              try {
                                final barcode = await BarcodeScanner.scan();
                                if (barcode != null &&
                                    barcode.rawContent != null) {
                                  final Product selectedProduct =
                                      await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PickProductFPO(
                                        searchText: barcode.rawContent,
                                        vm: _viewModel,
                                      ),
                                    ),
                                  );
                                  if (selectedProduct != null) {
                                    turnOnLoadingScreen(
                                        text:
                                            "Đang thêm ${selectedProduct.nameGet}");
                                    _viewModel
                                        .addOrderLineCommand(selectedProduct)
                                        .then((_) {
                                      turnOffLoadingScreen();
                                    }).catchError((error) {
                                      turnOffLoadingScreen();
                                      myErrorDialog(
                                          context: context,
                                          content: error.toString());
                                    });
                                  }
                                }
                              } catch (e) {
                                turnOffLoadingScreen();
                                print(e);
                              }
                            },
                            child: Stack(
                              children: <Widget>[
                                SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Center(
                                    child: Icon(
                                      Icons.crop_free,
                                      size: 25,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Center(
                                    child: Icon(
                                      FontAwesomeIcons.barcode,
                                      size: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      lines.isNotEmpty
                          ? Column(
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                  child: Column(
                                    children: model.defaultFPO.orderLines
                                        .map(
                                            (item) => _showOrderLinesItem(item))
                                        .toList(),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text("Tổng:  "),
                                      Text(
                                        "${vietnameseCurrencyFormat(model.defaultFPO.amount ?? 0)}",
                                        style: TextStyle(color: Colors.red),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.yellowAccent.withOpacity(0.1),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            Icon(
                                              Icons.shopping_cart,
                                              size: 50,
                                              color: Colors.grey,
                                            ),
                                            Text(
                                              "Chưa có sản phẩm nào trong danh sách.",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                            Text(
                                              "Nhấn 'tìm sản phẩm' để thêm.",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                            OutlineButton(
                                              color: Colors.grey,
                                              onPressed: () async {
                                                Product selectedProduct;
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProductSearchPage(
                                                      isPriceUnit: true,
                                                      onSelected: (value) {
                                                        if (value != null) {
                                                          selectedProduct =
                                                              value;
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                );
                                                if (selectedProduct != null) {
                                                  turnOnLoadingScreen(
                                                      text:
                                                          "Đang thêm ${selectedProduct.nameGet}");
                                                  _viewModel
                                                      .addOrderLineCommand(
                                                          selectedProduct)
                                                      .then((_) {
                                                    turnOffLoadingScreen();
                                                  }).catchError((error) {
                                                    turnOffLoadingScreen();
                                                    myErrorDialog(
                                                        context: context,
                                                        content:
                                                            error.toString());
                                                  });
                                                }
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.search,
                                                    color: Colors.green,
                                                  ),
                                                  Text("Tìm sản phẩm"),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
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

  Widget _showAnotherInfo(FastPurchaseOrderAddEditViewModel model) {
    //FastPurchaseOrder item = model.defaultFPO;
    return showCustomContainer(
      child: ExpansionTile(
        title: Row(
          children: <Widget>[
            Icon(Icons.info_outline),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Text(
                "Thông tin khác",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        children: <Widget>[
          Divider(),
          _showSeller(model),
          Divider(),
          _showDateOrder(model),
          Divider(),
          _showNoteOrder(model)
        ],
      ),
    );
  }

  Widget _showSeller(FastPurchaseOrderAddEditViewModel model) {
    return Row(
      children: <Widget>[
        //Icon(Icons.people),
        Expanded(
          child: Text("Người bán"),
        ),
        Row(
          children: <Widget>[
            MaterialButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Người bán hàng"),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.cancel,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                    content: SingleChildScrollView(
                      child: Scrollbar(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: model.applicationUsers
                              .map((f) => Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                    child: RaisedButton(
                                      color: Colors.grey.shade100,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text("${f.name}"),
                                        ],
                                      ),
                                      onPressed: () {
                                        model.setApplicationUser(f);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: Text(model.defaultFPO.user.name),
            ),
            Icon(
              Icons.keyboard_arrow_right,
              color: Colors.grey,
            ),
          ],
        )
      ],
    );
  }

  Widget _showDateOrder(FastPurchaseOrderAddEditViewModel model) {
    return Row(
      children: <Widget>[
        //Icon(Icons.date_range),
        Expanded(
          child: Text("Ngày hóa đơn"),
        ),
        Row(
          children: <Widget>[
            OutlineButton(
              padding: EdgeInsets.all(0),
              child: Text(
                "${getDate(model.defaultFPO.dateInvoice)}",
              ),
              onPressed: () async {
                var selectedDate = await showDatePicker(
                  context: context,
                  initialDate: model.defaultFPO.dateInvoice,
                  firstDate: DateTime.now().add(new Duration(days: -365)),
                  lastDate: DateTime.now().add(
                    new Duration(days: 1),
                  ),
                );

                if (selectedDate != null) {
                  model.setInvoiceDate(selectedDate);
                }
              },
            ),
            OutlineButton(
              padding: EdgeInsets.all(0),
              child: Text(
                "${getTime(model.defaultFPO.dateInvoice)}",
              ),
              onPressed: () async {
                var selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(
                        hour: model.defaultFPO.dateInvoice.hour,
                        minute: model.defaultFPO.dateInvoice.minute));

                if (selectedTime != null) {
                  model.setInvoiceTime(selectedTime);
                }
              },
            )
          ],
        )
      ],
    );
  }

  Widget _showNoteOrder(FastPurchaseOrderAddEditViewModel model) {
    return Column(
      children: <Widget>[
        TextField(
          controller: noteController,
          decoration: InputDecoration(
            labelText: "Ghi chú đơn hàng",
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
            ),
          ),
          onChanged: (note) {
            _viewModel.setNote(note);
          },
        )
      ],
    );
  }

  Widget _showPaymentInfo(FastPurchaseOrderAddEditViewModel model) {
    FastPurchaseOrder item = model.defaultFPO;
    return showCustomContainer(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text("Thông tin thanh toán"),
            leading: Icon(
              Icons.monetization_on,
              color: Colors.green,
            ),
            trailing: InkWell(
              onTap: () {
//                showDialog(
//                  context: context,
//                  builder: (context) => PaymentInfoFPO(
//                    vm: _viewModel,
//                  ),
//                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FastPurchaseInfoPaymentPage(
                      viewModel: _viewModel,
                    ),
                  ),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                  Text(
                    "Sửa",
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
          ),
          Divider(),
          Row(
            children: <Widget>[
              Expanded(child: Text("Tổng")),
              Text(
                "${vietnameseCurrencyFormat(item.amount ?? 0)}",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
          Divider(),
          Row(
            children: <Widget>[
              Expanded(child: Text("CK-Giảm tiền")),
              Text(
                "-${vietnameseCurrencyFormat(item.amount - item.amountUntaxed)}",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
          Divider(),
          Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                      "Thuế (${item.tax != null ? item.tax.name : "Không thuế" ?? ""})")),
              Text(
                "-${item.tax != null ? vietnameseCurrencyFormat(item.amountTax ?? 0) : 0 ?? 0}",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
          Divider(),
          Row(
            children: <Widget>[
              Expanded(child: Text("Tổng tiền")),
              Text(
                "${vietnameseCurrencyFormat(item.amountTotal ?? 0)}",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }

  Widget _showOrderLinesItem(OrderLine item) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.green,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                "Xóa dòng này?",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            Icon(
              Icons.delete_forever,
              color: Colors.red,
              size: 40,
            )
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        var dialogResult = await showQuestion(
            context: context,
            title: "Xác nhận xóa",
            message: "Bạn có muốn xóa sản phẩm ${item.name}?");

        if (dialogResult == OldDialogResult.Yes) {
          _viewModel.removeOrderLine(item);
          return false;
        } else {
          return false;
        }
      },
      key: UniqueKey(),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FastPurchaseOrderLineEditPage(
                  viewModel: _viewModel,
                  orderLine: item,
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(2),
              ),
              border: Border.all(color: Colors.grey.shade400),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  offset: Offset(0, 0),
                  blurRadius: 10,
                ),
              ],
            ),
            child:
//          child: ExpansionTile(
                Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "${item.name ?? "<chưa có tên>"}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              OrderLine newOrderLine =
                                  OrderLine.fromJson(item.toJson());
                              _viewModel.duplicateOrderLine(newOrderLine);
                            },
                            child: Container(
                              height: 35,
                              width: 35,
                              child: Icon(
                                FontAwesomeIcons.copy,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
//              Row(
//                children: <Widget>[
//                  Text(
//                    "${item.productQty}",
//                    style: TextStyle(
//                      color: Colors.grey,
//                      fontWeight: FontWeight.w400,
//                    ),
//                  ),
//                  Text(
//                    " (${item.productUom.name}) ",
//                    style: TextStyle(
//                      color: Colors.grey,
//                      fontWeight: FontWeight.w400,
//                    ),
//                  ),
////                  Text(
////                    "| Tổng : ${vietnameseCurrencyFormat(item.priceSubTotal)}đ ",
////                    style: TextStyle(
////                      color: Colors.grey,
////                      fontWeight: FontWeight.w400,
////                    ),
////                  ),
//                ],
//              ),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: <Widget>[
                            Text(
                                "${vietnameseCurrencyFormat(item.priceUnit)} "),
                            Text(
                              "(-${item.discount.toInt()}%)",
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        "x",
                        style: TextStyle(color: Colors.green),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: NumberInputLeftRightWidget(
                              value: item.productQty,
                              seedValue: 1,
                              numberFormat: "###,###,###",
                              fontWeight: FontWeight.bold,
                              onChanged: (value) {
                                _viewModel.setValueQty(item, value);
//                                if (_viewModel.oldQty <= value) {
//                                  _viewModel.increaseQty(item);
//                                } else {
//                                  _viewModel.decreaseQty(item);
//                                }
//                                _viewModel.oldQty = value;
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
//              Divider(),
//              Padding(
//                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.end,
//                  mainAxisSize: MainAxisSize.max,
//                  children: <Widget>[
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.end,
//                      mainAxisSize: MainAxisSize.max,
//                      children: <Widget>[
//                        Container(
//                          height: 40,
//                          width: 60,
//                          decoration: BoxDecoration(
//                            border: Border.all(color: Colors.green),
//                            borderRadius: BorderRadius.all(
//                              Radius.circular(30),
//                            ),
//                          ),
//                          child: InkWell(
//                            onTap: () {
//                              _viewModel.isExpand = true;
//                              _viewModel.decreaseQty(item);
//                            },
//                            child: Icon(
//                              Icons.remove,
//                              color: Colors.green,
//                            ),
//                          ),
//                        ),
//                        SizedBox(
//                          width: 10,
//                        ),
//                        Container(
//                          height: 40,
//                          width: 60,
//                          decoration: BoxDecoration(
//                            border: Border.all(color: Colors.green),
//                            borderRadius: BorderRadius.only(
//                              topLeft: Radius.circular(30),
//                              bottomLeft: Radius.circular(30),
//                            ),
//                          ),
//                          child: Center(
//                            child: Text(
//                              "${item.productQty} ",
//                              style: TextStyle(color: Colors.green),
//                            ),
//                          ),
//                        ),
//                        Container(
//                          height: 40,
//                          width: 60,
//                          decoration: BoxDecoration(
//                            border: Border.all(color: Colors.green),
//                            borderRadius: BorderRadius.only(
//                              topRight: Radius.circular(30),
//                              bottomRight: Radius.circular(30),
//                            ),
//                          ),
//                          child: InkWell(
//                            onTap: () {
//                              _viewModel.isExpand = true;
//                              _viewModel.increaseQty(item);
//                            },
//                            child: Icon(
//                              Icons.add,
//                              color: Colors.green,
//                            ),
//                          ),
//                        ),
//                      ],
//                    ),
////                    Divider(),
////                    Row(
////                      mainAxisAlignment: MainAxisAlignment.end,
////                      children: <Widget>[
//////                        IconButton(
//////                          onPressed: () {
//////                            _viewModel.removeOrderLine(item);
//////                          },
//////                          icon: Icon(
//////                            FontAwesomeIcons.trashAlt,
//////                            color: Colors.red,
//////                          ),
//////                        ),
//////                        Row(
//////                          children: <Widget>[
//////                            IconButton(
//////                              onPressed: () {
//////                                OrderLine newOrderLine =
//////                                    OrderLine.fromJson(item.toJson());
//////                                _viewModel.duplicateOrderLine(newOrderLine);
//////                              },
//////                              icon: Icon(
//////                                FontAwesomeIcons.copy,
//////                                color: Colors.blue,
//////                              ),
//////                            ),
//////                            IconButton(
//////                              onPressed: () {
////////                                showEditOrderLineDialog(item);
//////                                Navigator.push(
//////                                  context,
//////                                  MaterialPageRoute(
//////                                    builder: (context) =>
//////                                        FastPurchaseOrderLineEditPage(
//////                                      viewModel: _viewModel,
//////                                      orderLine: item,
//////                                    ),
//////                                  ),
//////                                );
//////                              },
//////                              icon: Icon(
//////                                FontAwesomeIcons.edit,
//////                                color: Colors.green,
//////                              ),
//////                            ),
//////                          ],
//////                        )
////                      ],
////                    ),
//                  ],
//                ),
//              ),
              ],
            ),
//            children: <Widget>[
//              Padding(
//                padding: const EdgeInsets.symmetric(horizontal: 18),
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: <Widget>[
//                    Text("Đơn giá"),
//                    Row(
//                      children: <Widget>[
//                        Text(
//                            "${vietnameseCurrencyFormat(item.priceUnit * (100 - item.discount) / 100)} "),
//                        Text(
//                          "(-${item.discount.toInt()}%)",
//                          style: TextStyle(color: Colors.grey),
//                        )
//                      ],
//                    ),
//                    SizedBox(),
//                  ],
//                ),
//              ),
//              Divider(),
//              Padding(
//                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.end,
//                  mainAxisSize: MainAxisSize.max,
//                  children: <Widget>[
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.end,
//                      mainAxisSize: MainAxisSize.max,
//                      children: <Widget>[
//                        Container(
//                          height: 40,
//                          width: 60,
//                          decoration: BoxDecoration(
//                            border: Border.all(color: Colors.green),
//                            borderRadius: BorderRadius.all(
//                              Radius.circular(30),
//                            ),
//                          ),
//                          child: InkWell(
//                            onTap: () {
//                              _viewModel.isExpand = true;
//                              _viewModel.decreaseQty(item);
//                            },
//                            child: Icon(
//                              Icons.remove,
//                              color: Colors.green,
//                            ),
//                          ),
//                        ),
//                        SizedBox(
//                          width: 10,
//                        ),
//                        Container(
//                          height: 40,
//                          width: 60,
//                          decoration: BoxDecoration(
//                            border: Border.all(color: Colors.green),
//                            borderRadius: BorderRadius.only(
//                              topLeft: Radius.circular(30),
//                              bottomLeft: Radius.circular(30),
//                            ),
//                          ),
//                          child: Center(
//                            child: Text(
//                              "${item.productQty} ",
//                              style: TextStyle(color: Colors.green),
//                            ),
//                          ),
//                        ),
//                        Container(
//                          height: 40,
//                          width: 60,
//                          decoration: BoxDecoration(
//                            border: Border.all(color: Colors.green),
//                            borderRadius: BorderRadius.only(
//                              topRight: Radius.circular(30),
//                              bottomRight: Radius.circular(30),
//                            ),
//                          ),
//                          child: InkWell(
//                            onTap: () {
//                              _viewModel.isExpand = true;
//                              _viewModel.increaseQty(item);
//                            },
//                            child: Icon(
//                              Icons.add,
//                              color: Colors.green,
//                            ),
//                          ),
//                        ),
//                      ],
//                    ),
////                    Divider(),
////                    Row(
////                      mainAxisAlignment: MainAxisAlignment.end,
////                      children: <Widget>[
//////                        IconButton(
//////                          onPressed: () {
//////                            _viewModel.removeOrderLine(item);
//////                          },
//////                          icon: Icon(
//////                            FontAwesomeIcons.trashAlt,
//////                            color: Colors.red,
//////                          ),
//////                        ),
//////                        Row(
//////                          children: <Widget>[
//////                            IconButton(
//////                              onPressed: () {
//////                                OrderLine newOrderLine =
//////                                    OrderLine.fromJson(item.toJson());
//////                                _viewModel.duplicateOrderLine(newOrderLine);
//////                              },
//////                              icon: Icon(
//////                                FontAwesomeIcons.copy,
//////                                color: Colors.blue,
//////                              ),
//////                            ),
//////                            IconButton(
//////                              onPressed: () {
////////                                showEditOrderLineDialog(item);
//////                                Navigator.push(
//////                                  context,
//////                                  MaterialPageRoute(
//////                                    builder: (context) =>
//////                                        FastPurchaseOrderLineEditPage(
//////                                      viewModel: _viewModel,
//////                                      orderLine: item,
//////                                    ),
//////                                  ),
//////                                );
//////                              },
//////                              icon: Icon(
//////                                FontAwesomeIcons.edit,
//////                                color: Colors.green,
//////                              ),
//////                            ),
//////                          ],
//////                        )
////                      ],
////                    ),
//                  ],
//                ),
//              ),
//            ],
//            initiallyExpanded: true,
//          ),
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> showEditOrderLineDialog(
    OrderLine item, {
    bool isProductQtyInvalid = false,
    bool isPriceUnitInvalid = false,
    bool isDiscountInvalid = false,
    String productQty,
    String priceUnit,
    String discount,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        TextEditingController productQtyAD = MoneyMaskedTextController(
            initialValue: item.productQty.toDouble(),
            decimalSeparator: "",
            precision: 0);
        TextEditingController priceUnitAD = MoneyMaskedTextController(
            initialValue: item.priceUnit, decimalSeparator: "", precision: 0);
        TextEditingController discountAD = MoneyMaskedTextController(
            initialValue: item.discount, decimalSeparator: "", precision: 0);
        String productQtyErrorText = "Số lượng không thể bỏ trống";
        String isPriceUnitErrorText = "Đơn giá không thể bỏ trống";
        String discountErrorText = "giảm giá không thể bỏ trống & lớn hơn 100";
        if (productQty != null) productQtyAD.text = productQty.toString();
        if (priceUnit != null) priceUnitAD.text = priceUnit.toString();
        if (discount != null) discountAD.text = discount.toString();
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  "${item.product.nameGet ?? item.productName}",
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
          content: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    autofocus: (!isProductQtyInvalid &&
                            !isPriceUnitInvalid &&
                            !isDiscountInvalid)
                        ? true
                        : isProductQtyInvalid ? true : false,
                    controller: productQtyAD,
                    decoration: InputDecoration(
                        labelText: "Số lượng",
                        errorText:
                            isProductQtyInvalid ? productQtyErrorText : null),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    autofocus: isPriceUnitInvalid ? true : false,
                    controller: priceUnitAD,
                    decoration: InputDecoration(
                        labelText: "Đơn giá",
                        errorText:
                            isPriceUnitInvalid ? isPriceUnitErrorText : null),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    autofocus: isDiscountInvalid ? true : false,
                    controller: discountAD,
                    decoration: InputDecoration(
                      labelText: "CK(%)",
                      errorText: isDiscountInvalid ? discountErrorText : null,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              onPressed: () {
                /*isProductQtyInvalid = productQtyAD.text.isEmpty;
                isPriceUnitInvalid = priceUnitAD.text.isEmpty;
                isDiscountInvalid = discountAD.text.isEmpty;*/

                if (productQtyAD.text.isEmpty ||
                    priceUnitAD.text.isEmpty ||
                    discountAD.text.isEmpty ||
                    int.parse(discountAD.text.replaceAll(".", "")) > 100) {
                  print(
                      "dữ liệu dialog không hợp lệ , mở dialog khác kèm error Text");

                  Navigator.pop(context);
                  showEditOrderLineDialog(
                    item,
                    isProductQtyInvalid: productQtyAD.text.isEmpty,
                    isPriceUnitInvalid: priceUnitAD.text.isEmpty,
                    isDiscountInvalid: discountAD.text.isEmpty ||
                        int.parse(discountAD.text.replaceAll(".", "")) > 100,
                    productQty: productQtyAD.text.isEmpty
                        ? ""
                        : double.parse(productQtyAD.text.replaceAll(".", ""))
                            .toString(),
                    priceUnit: priceUnitAD.text.isEmpty
                        ? ""
                        : int.parse(priceUnitAD.text.replaceAll(".", ""))
                            .toString(),
                    discount: discountAD.text.isEmpty
                        ? ""
                        : int.parse(discountAD.text.replaceAll(".", ""))
                            .toString(),
                  );
                } else {
                  _viewModel.updateOrderLinesInfo({
                    "productQty":
                        int.parse(productQtyAD.text.replaceAll(".", "")),
                    "priceUnit":
                        double.parse(priceUnitAD.text.replaceAll(".", "")),
                    "discount":
                        double.parse(discountAD.text.replaceAll(".", "")),
                  }, item);
                  Navigator.pop(context);
                }
              },
              child: Text("Lưu"),
            )
          ],
        );
      },
    );
  }

  Widget myBtn() {
    return ScopedModelDescendant<FastPurchaseOrderAddEditViewModel>(
      builder: (context, child, model) {
        bool isValid = (model.defaultFPO?.orderLines != null &&
                model.defaultFPO.orderLines.isNotEmpty) &&
            model.defaultFPO?.partner != null;
        return Container(
          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              isTablet(context) ? Expanded(child: SizedBox()) : SizedBox(),
              Expanded(
                child: Container(
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(3),
                        bottomLeft: Radius.circular(3),
                      ),
                    ),
                    onPressed: !isValid
                        ? null
                        : () {
                            turnOnLoadingScreen(text: "Đang xác nhận");
                            _viewModel.actionOpenInvoice().then(
                              (value) async {
                                turnOffLoadingScreen();
                                _orderViewModel.currentOrder = value;
                                if (!isTablet(context)) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FastPurchaseOrderDetails(
                                        vm: _orderViewModel,
                                      ),
                                    ),
                                  );
                                } else {
                                  await _orderViewModel
                                      .getDetailsFastPurchaseOrder();
                                  Navigator.pop(context);
                                }
                              },
                            ).catchError(
                              (error) {
                                turnOffLoadingScreen();
                                myErrorDialog(
                                  context: context,
                                  content: error.toString(),
                                );
                              },
                            );
                          },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "XÁC NHẬN",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(3),
                    bottomRight: Radius.circular(3),
                  ),
                ),
                child: Icon(
                  Icons.more_horiz,
                  color: Colors.black,
                ),
                onPressed: () {},
                color: Colors.white,
              ),
              isTablet(context) ? Expanded(child: SizedBox()) : SizedBox(),
            ],
          ),
        );
      },
    );
  }
}
