import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/data_helper.dart';

import 'package:tpos_mobile/feature_group/fast_purchase_order/view_model/fast_purchase_order_viewmodel.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_purchase_order_payment.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class FastPurchasePayment extends StatefulWidget {
  final FastPurchaseOrderViewModel vm;

  FastPurchasePayment({@required this.vm});

  @override
  _FastPurchasePaymentState createState() => _FastPurchasePaymentState();
}

class _FastPurchasePaymentState extends State<FastPurchasePayment> {
  TposApiService _tPosApi = locator<ITposApiService>();
  FastPurchaseOrderViewModel _viewModel;
  TextEditingController _moneyController =
      MoneyMaskedTextController(decimalSeparator: "", precision: 0);
  TextEditingController _dateController = new TextEditingController();
  TextEditingController _noteController = new TextEditingController();
  String dropDownValue;
  List<JournalFPO> listPayment = new List<JournalFPO>();

  FastPurchaseOrderPayment currentFPOP;
  List<JournalFPO> journalList = new List<JournalFPO>();
  bool isJournalInvalid = false;
  bool isMoneyInvalid = false;
  @override
  void initState() {
    _viewModel = widget.vm;
    _tPosApi
        .getPaymentFastPurchaseOrderForm(_viewModel.currentOrder.id)
        .then((value) {
      setState(() {
        currentFPOP = value;
        _moneyController.text = currentFPOP.amount.toInt().toString();
        _dateController.text = getDate(DateTime.parse(currentFPOP.paymentDate));
        _noteController.text = _viewModel.currentOrder.number;
      });

      _tPosApi.getJournalOfFastPurchaseOrder().then((values) {
        setState(() {
          journalList = values;
          currentFPOP.paymentMethodId = 2;
          currentFPOP.journal = values[0];

          ///copy form
          currentFPOP.currencyId = 1;
          currentFPOP.currency.rounding = 1;
          currentFPOP.currency.position = "after";
          currentFPOP.journalId = values[0].id;
        });
      });
    }).catchError((error) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Thất bại"),
              content: Text("$error"),
              actions: <Widget>[
                MaterialButton(
                  child: Text("Quay lại"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });

      super.initState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Thanh toán"),
      content: _showBody(),
      actions: <Widget>[_showBottomSheet()],
    );
  }

  bool isHaveValue = false;
  Widget _showBody() {
    return ScopedModel<FastPurchaseOrderViewModel>(
      model: _viewModel,
      child: ScopedModelDescendant<FastPurchaseOrderViewModel>(
        builder: (context, child, model) {
          return currentFPOP != null && journalList != null
              ? SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _showJournalPayment(),
                        Divider(),
                        _showEnterMoney(),
                        Divider(),
                        _showDatePayment(),
                        Divider(),
                        _showNotePayment(),
                      ],
                    ),
                  ),
                )
              : Container(
                  child: Row(
                    children: <Widget>[
                      CircularProgressIndicator(),
                      Text("Đang tải ...")
                    ],
                  ),
                );
        },
      ),
    );
  }

  Widget _showJournalPayment() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(child: Text("Phương thức")),
        Expanded(
          child: ScopedModelDescendant<FastPurchaseOrderViewModel>(
            builder: (context, child, model) {
              return Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: !isJournalInvalid ? Colors.white : Colors.red,
                        width: 2,
                      ),
                    ),
                    child: DropdownButton(
                      hint: Text("Phương thức"),
                      isExpanded: true,
                      value: currentFPOP.journal,
                      items: journalList
                          .map(
                            (f) => DropdownMenuItem(
                              value: f,
                              child: Text(f.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(
                          () {
                            isJournalInvalid = false;
                            currentFPOP.paymentMethodId = 2;
                            currentFPOP.journal = value;

                            ///copy form
                            currentFPOP.currencyId = 1;
                            currentFPOP.currency.rounding = 1;
                            currentFPOP.currency.position = "after";
                            currentFPOP.journalId = value.id;
                          },
                        );
                      },
                    ),
                  ),
                  !isJournalInvalid
                      ? SizedBox()
                      : Positioned(
                          bottom: 0,
                          right: 0,
                          child: Text(
                            "Không thể để trống",
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _showEnterMoney() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(child: Text("Số tiền")),
        Expanded(
          child: TextField(
            controller: _moneyController,
            textDirection: TextDirection.rtl,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (text) {
              currentFPOP.amount = double.parse(text.replaceAll(".", ""));
            },
            decoration: InputDecoration(
                errorText: !isMoneyInvalid ? null : "Số tiền không hợp lệ"),
          ),
        ),
      ],
    );
  }

  Widget _showDatePayment() {
    return Row(
      children: <Widget>[
        Expanded(child: Text("Ngày thanh toán")),
        Expanded(
          child: InkWell(
            child: TextField(
              controller: _dateController,
              textDirection: TextDirection.rtl,
              enabled: false,
              decoration: InputDecoration(
                disabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            onTap: () async {
              var selectedDate = await showDatePicker(
                  context: context,
                  initialDate:
                      getDateTime2(currentFPOP.paymentDate) ?? DateTime.now(),
                  firstDate: DateTime.now().add(new Duration(days: -3650)),
                  lastDate: DateTime.now());
              if (selectedDate != null) {
                setState(() {
                  currentFPOP.paymentDate = getDate(selectedDate);
                  _dateController.text = currentFPOP.paymentDate;
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _showNotePayment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextField(
          controller: _noteController,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(),
              labelText: "Nội dung"),
          onChanged: (text) {
            currentFPOP.communication = text;
          },
        )
      ],
    );
  }

  _showBottomSheet() {
    return RaisedButton(
      color: Colors.deepPurple,
      child: Text(
        "Thanh toán",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        setState(() {
          isJournalInvalid = !journalValid();
          isMoneyInvalid = !moneyValid();
        });
        if (journalValid() && moneyValid()) {
          _viewModel.doPaymentFPO(currentFPOP).then((result) {
            if (result == "Success") {
              Navigator.pop(context, true);
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          child: Text("Thành công"),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.cancel),
                        ),
                      ],
                    ),
                    content: Text(
                        "Đã thanh toán ${_viewModel.currentOrder.number}, thành công !"),
                  );
                },
              );
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("$result"),
                    );
                  });
            }
          });
        }
      },
    );
  }

  bool moneyValid() {
    return double.parse(_moneyController.text.replaceAll(".", "")) >= 0;
  }

  bool journalValid() {
    return currentFPOP.journal != null;
  }
}
