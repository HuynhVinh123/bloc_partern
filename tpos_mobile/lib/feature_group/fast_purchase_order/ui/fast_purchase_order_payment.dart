import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/data_helper.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/view_model/fast_purchase_order_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_purchase_order_payment.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class FastPurchasePayment extends StatefulWidget {
  const FastPurchasePayment({@required this.vm});
  final FastPurchaseOrderViewModel vm;

  @override
  _FastPurchasePaymentState createState() => _FastPurchasePaymentState();
}

class _FastPurchasePaymentState extends State<FastPurchasePayment> {
  final TposApiService _tPosApi = locator<ITposApiService>();
  FastPurchaseOrderViewModel _viewModel;
  final TextEditingController _moneyController =
      MoneyMaskedTextController(decimalSeparator: "", precision: 0);
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String dropDownValue;
  List<JournalFPO> listPayment = <JournalFPO>[];

  FastPurchaseOrderPayment currentFPOP;
  List<JournalFPO> journalList = <JournalFPO>[];
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
              title: Text(S.current.failed),
              content: Text("$error"),
              actions: <Widget>[
                MaterialButton(
                  child: Text(S.current.back),
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
      //Thanh toán
      title: Text(S.current.payment),
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
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _showJournalPayment(),
                        const Divider(),
                        _showEnterMoney(),
                        const Divider(),
                        _showDatePayment(),
                        const Divider(),
                        _showNotePayment(),
                      ],
                    ),
                  ),
                )
              : Container(
                  child: Row(
                    children: <Widget>[
                      const CircularProgressIndicator(),
                      //Đang tải
                      Text("${S.current.loading} ...")
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
        // Phương thức
        Expanded(child: Text(S.current.paymentMethod)),
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
                      hint: Text(S.current.paymentMethod),
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
                  if (!isJournalInvalid)
                    const SizedBox()
                  else
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Text(
                        S.current.fastPurchase_cannotBeEmpty,
                        style: const TextStyle(color: Colors.red),
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
        // Số tiền
        Expanded(child: Text(S.current.amount)),
        Expanded(
          child: TextField(
            controller: _moneyController,
            textDirection: TextDirection.rtl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (text) {
              currentFPOP.amount = double.parse(text.replaceAll(".", ""));
            },
            decoration: InputDecoration(
                errorText: !isMoneyInvalid
                    ? null
                    : S.current.fastPurchase_invalidAmount),
          ),
        ),
      ],
    );
  }

  Widget _showDatePayment() {
    return Row(
      children: <Widget>[
        //Ngày thanh toá
        Expanded(child: Text(S.current.paymentDate)),
        Expanded(
          child: InkWell(
            child: TextField(
              controller: _dateController,
              textDirection: TextDirection.rtl,
              enabled: false,
              decoration: const InputDecoration(
                disabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            onTap: () async {
              final selectedDate = await showDatePicker(
                  context: context,
                  initialDate:
                      getDateTime2(currentFPOP.paymentDate) ?? DateTime.now(),
                  firstDate: DateTime.now().add(const Duration(days: -3650)),
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
        // Nội dung
        TextField(
          controller: _noteController,
          decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(),
              labelText: S.current.content),
          onChanged: (text) {
            currentFPOP.communication = text;
          },
        )
      ],
    );
  }

  RaisedButton _showBottomSheet() {
    return RaisedButton(
      color: Colors.deepPurple,
      //Thanh toá
      child: Text(
        S.current.payment,
        style: const TextStyle(color: Colors.white),
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
                        // Thành công
                        Expanded(
                          child: Text(S.current.success),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.cancel),
                        ),
                      ],
                    ),
                    // Đã thanh toán  thành công
                    content: Text(
                        "${S.current.paid}${_viewModel.currentOrder.number}, ${S.current.success.toLowerCase()} !"),
                  );
                },
              );
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(result ?? ""),
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
