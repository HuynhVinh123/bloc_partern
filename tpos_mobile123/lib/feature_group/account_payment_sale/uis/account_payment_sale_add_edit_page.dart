import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/account_payment/uis/search_contact_partner_page.dart';
import 'package:tpos_mobile/feature_group/account_payment/uis/type_account_payment_list_page.dart';
import 'package:tpos_mobile/feature_group/account_payment_sale/viewmodel/account_payment_sale_add_edit_viewmodel.dart';
import 'package:tpos_mobile/feature_group/category/partner_list_page.dart';
import 'package:tpos_mobile/helpers/app_helper.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/account_payment.dart';
import 'package:tpos_mobile/widgets/my_step_view.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import '../../../locator.dart';

// ignore: must_be_immutable
class AccountPaymentSaleAddEditPage extends StatefulWidget {
  AccountPaymentSaleAddEditPage({this.accountPayment});

  AccountPayment accountPayment;

  @override
  _AccountPaymentSaleAddEditPageState createState() =>
      _AccountPaymentSaleAddEditPageState();
}

class _AccountPaymentSaleAddEditPageState
    extends State<AccountPaymentSaleAddEditPage> {
  final _vm = locator<AccountPaymentSaleAddEditViewModel>();

  final FocusNode _focusNodeMoney = FocusNode();
  final TextEditingController _controllerMoney = TextEditingController();
  final TextEditingController _controllerContent = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerAddress = TextEditingController();

  final Widget _dividerSpace = const Divider(
    height: 4,
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.accountPayment != null) {
          if (widget.accountPayment.state == "draft") {
            return await confirmClosePage(context,
                title: S.current.close,
                /// Dữ liệu chưa được lưu bạn có muốn đóng?
                message: S.current.confirmClose);
          }
        }
        return true;
      },
      child: ViewBase<AccountPaymentSaleAddEditViewModel>(
          model: _vm,
          builder: (context, model, sizingInformation) {
            return GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Scaffold(
                  appBar: AppBar(
                    title: widget.accountPayment != null
                        ?  Text(S.current.paymentReceipt_edit)
                        :  Text(S.current.paymentReceipt_add),
                    actions: <Widget>[
                      Visibility(
                        visible: _vm.accountPayment.state == "draft",
                        child: InkWell(
                          onTap: () {
                            if (_vm.accountPayment.state == "draft") {
                              if (_vm.account != null &&
                                  _vm.selectTypePayment != -1) {
                                updateInfoAccountPayment();
                              } else {
                                _vm.showNotify(
                                    S.current.paymentReceipt_notifyAddEdit);
                              }
                            }
                          },
                          child: Row(
                            children:  <Widget>[
                              const Icon(Icons.save),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                S.current.save,
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  body: SafeArea(
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 8,
                          bottom: 60,
                          left: 0,
                          right: 0,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                _buildStatusView(),
                                InkWell(
                                  onTap: () {
                                    if (_vm.accountPayment.state == "draft") {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const TypeAccountPaymentListPage(
                                                    false)),
                                      ).then((value) {
                                        if (value != null) {
                                          _vm.account = value;
                                        }
                                      });
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 12, right: 12, top: 16),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 11),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                            child: Text(
                                          _vm.account != null
                                              ? _vm.account.nameGet
                                              : S.current.paymentReceipt_paymentReceiptType,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: _vm.account != null
                                                  ? Colors.grey[800]
                                                  : Colors.grey[600]),
                                        )),
                                        Visibility(
                                          visible: _vm.account != null,
                                          child: InkWell(
                                            onTap: () {
                                              if (_vm.accountPayment.state ==
                                                  "draft") {
                                                FocusScope.of(context)
                                                    .requestFocus(FocusNode());
                                                if (widget.accountPayment !=
                                                    null) {
                                                  _vm.account = widget
                                                      .accountPayment.account;
                                                } else {
                                                  _vm.account = null;
                                                }
                                              }
                                            },
                                            child: Container(
                                              width: 35,
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_right,
                                          color: Colors.grey[600],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                _dividerSpace,
                                InkWell(
                                  onTap: () {
                                    if (_vm.accountPayment.state == "draft") {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const PartnerListPage(
                                            isSupplier: true,
                                            isSearchMode: true,
                                          ),
                                        ),
                                      ).then((value) {
                                        if (value != null) {
                                          _vm.isShowReceiver = false;
                                          _vm.partner = value;
                                          _controllerPhone.text =
                                              _vm.partner.phone ?? "";
                                          _controllerAddress.text =
                                              _vm.partner.street ?? "";
                                        }
                                      });
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 12, right: 12),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 11),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                            child: Text(
                                          _vm.partner != null &&
                                                  !_vm.isShowReceiver
                                              ? _vm.partner.name
                                              : _vm.accountPayment
                                                      .senderReceiver ??
                                                  S.current.paymentReceipt_receiver,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: _vm.partner != null
                                                  ? Colors.grey[800]
                                                  : Colors.grey[600]),
                                        )),
                                        Visibility(
                                          visible: _vm.partner != null,
                                          child: InkWell(
                                            onTap: () {
                                              if (_vm.accountPayment.state ==
                                                  "draft") {
                                                FocusScope.of(context)
                                                    .requestFocus(FocusNode());
                                                _vm.partner = null;
                                              }
                                            },
                                            child: Container(
                                              width: 35,
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_right,
                                          color: Colors.grey[600],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                _dividerSpace,
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: _buildTypePayment()),
                                _dividerSpace,
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: _buildFormMoney(),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                      child: Divider(
                                        color: Colors.grey,
                                        thickness: 2,
                                      ),
                                    ),
                                    Expanded(
                                      child: _buildInfoContent(
                                          S.current.phoneNumber, _controllerPhone,
                                          isPhone: true),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                  child: Container(
                                    color: Colors.grey[100],
                                  ),
                                ),
                                _buildInfoContent(
                                    "Địa chỉ", _controllerAddress),
                                InkWell(
                                  onTap: () async {
                                    if (_vm.accountPayment.state == "draft") {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      final date = await showDatePicker(
                                        context: context,
                                        firstDate: DateTime(1900),
                                        initialDate: _vm.selectTime,
                                        lastDate: DateTime(2100),
                                      );
                                      if (date != null) {
                                        _vm.selectTime = date;
                                      }
//                                  DatePicker.showDatePicker(context,
//                                      showTitleActions: true,
//                                      minTime: DateTime(1997, 1, 1),
//                                      maxTime: DateTime.now(),
//                                      onConfirm: (date) {
//                                    _vm.selectTime = date;
//                                  },
//                                      currentTime: _vm.selectTime,
//                                      locale: LocaleType.vi);
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                            child: Text(
                                          " ${_vm.selectTime != null ? DateFormat("dd-MM-yyyy").format(_vm.selectTime) : S.current.chooseDate}",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: _vm.selectTime != null
                                                  ? Colors.grey[800]
                                                  : Colors.grey[600]),
                                        )),
                                        Icon(
                                          Icons.date_range,
                                          color: Colors.grey[600],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    if (_vm.accountPayment.state == "draft") {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SearchContactPartnerPage()),
                                      ).then((value) {
                                        if (value != null) {
                                          _vm.partnerContact = value;
                                        }
                                      });
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 13),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            top: BorderSide(
                                                color: Colors.grey[200]))),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                            child: Text(
                                          _vm.partnerContact != null
                                              ? _vm.partnerContact.displayName
                                              : S.current.contact,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: _vm.partnerContact != null
                                                  ? Colors.grey[800]
                                                  : Colors.grey[600]),
                                        )),
                                        Visibility(
                                          visible: _vm.partnerContact != null,
                                          child: InkWell(
                                            onTap: () {
                                              if (_vm.accountPayment.state ==
                                                  "draft") {
                                                FocusScope.of(context)
                                                    .requestFocus(FocusNode());
                                                _vm.partnerContact = null;
                                              }
                                            },
                                            child: Container(
                                              width: 35,
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_right,
                                          color: Colors.grey[600],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                /// Nộ dung
                                _buildInfoContent(
                                    S.current.content, _controllerContent),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          left: 24,
                          right: 24,
                          child: Visibility(
                            visible: _vm.accountPayment.state == "draft",
                            child: Container(
                                width: 130,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.green),
                                child: FlatButton(
                                  /// Xác nhận
                                    child:  Text(
                                     S.current.confirm,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 17),
                                    ),
                                    onPressed: () async {
                                      final dialogResult = await showQuestion(
                                          context: context,
                                          title:S.current.confirm,
                                          message:
                                          S.current.paymentReceipt_doYouWantToAddToTheBook);
                                      if (dialogResult ==
                                          DialogResultType.YES) {
                                        if (widget.accountPayment == null) {
                                          if (_vm.account != null &&
                                              _vm.selectTypePayment != -1) {
                                            updateInfoAccountPayment(
                                                isConfirm: true);
                                          } else {
                                            ///Bạn phải chọn đầy đủ \"Loại chi\" và \"Phương thức\"
                                            _vm.showNotify(
                                                S.current.paymentReceipt_notifyAddEdit);
                                          }
                                        } else {
                                          updateInfoAccountPayment(
                                              isConfirm: true);
                                        }
                                      } else {
                                        Navigator.pop(context);
                                      }
                                    })),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          left: 24,
                          right: 24,
                          child: Visibility(
                            visible: _vm.accountPayment.state == "posted",
                            child: Container(
                                width: 130,
                                decoration: BoxDecoration(
                                    color: Colors.red[500],
                                    borderRadius: BorderRadius.circular(4)),
                                child: FlatButton(
                                    child:  Text(S.current.cancel,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600)),
                                    onPressed: () async {
                                      final dialogResult = await showQuestion(
                                          context: context,
                                          title: S.current.cancel,
                                          message:
                                              S.current.paymentReceipt_doYouWantToCancel);
                                      if (dialogResult ==
                                          DialogResultType.YES) {
                                        await _vm.cancelAccountPayment(context);
                                      } else {
                                        Navigator.pop(context);
                                      }
                                    })),
                          ),
                        )
                      ],
                    ),
                  ),
                ));
          }),
    );
  }

  Widget _buildStatusView() {
    return MyStepView(currentIndex: 2, items: [
      MyStepItem(
        title:  Text(
          S.current.draft,
          textAlign: TextAlign.center,
        ),
        icon: const Icon(
          Icons.check_circle,
          color: Colors.green,
        ),
        lineColor: Colors.red,
        isCompleted: _vm.accountPayment.state == "draft",
      ),
      MyStepItem(
        title:  Text(
          S.current.hasEnteredTheBook,
          textAlign: TextAlign.center,
        ),
        icon: const Icon(
          Icons.check_circle,
          color: Colors.green,
        ),
        lineColor: Colors.red,
        isCompleted: _vm.accountPayment.state == "posted",
      )
    ]);
  }

  Widget _buildTypePayment() => IgnorePointer(
        ignoring: _vm.accountPayment.state != "draft",
        child: DropdownButton<String>(
          hint:  Text(S.current.paymentReceipt_paymentReceiptType),
          items: [
            ..._vm.accountJournals.map(
              (value) => DropdownMenuItem(
                value: "${value.id}",
                child: Text(
                  value.name ?? "",
                ),
              ),
            )
          ],
          onChanged: (value) {
            if (_vm.accountJournal.id.toString() != value) {
              _vm.removeAccountJournal();
            }
            _vm.selectTypePayment = int.parse(value);
          },
          value: "${_vm.selectTypePayment}",
          isExpanded: true,
          underline: const SizedBox(),
        ),
      );

  Widget _buildFormMoney() {
    _focusNodeMoney.addListener(() {
      if (_focusNodeMoney.hasFocus) {
        _controllerMoney.selection = TextSelection(
            baseOffset: 0, extentOffset: _controllerMoney.text.length);
      }
    });

    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: TextField(
        controller: _controllerMoney,
        focusNode: _focusNodeMoney,
        textAlign: TextAlign.right,
        decoration: const InputDecoration(
            labelText: "Số tiền",
            labelStyle: TextStyle(fontSize: 16),
            border: InputBorder.none),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly,
          NumberInputFormat.vietnameDong(),
        ],
        enabled: _vm.accountPayment.state == "draft",
      ),
    );
  }

  Widget _buildInfoContent(String hintText, TextEditingController controller,
      {bool isPhone = false}) {
    return isPhone
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                  labelText: hintText ?? "",
                  labelStyle: const TextStyle(fontSize: 16),
                  border: InputBorder.none),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly,
              ],
              enabled: _vm.accountPayment.state == "draft",
            ),
          )
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  top: BorderSide(color: Colors.grey[200]),
                  bottom: BorderSide(color: Colors.grey[200])),
            ),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                  labelText: hintText ?? "",
                  border: InputBorder.none,
                  labelStyle: const TextStyle(fontSize: 16)),
              enabled: _vm.accountPayment.state == "draft",
            ),
          );
  }

  void updateInfoAccountPayment({bool isConfirm = false}) {
    _vm.accountPayment.amount =
        double.parse(_controllerMoney.text.replaceAll(".", ""));
    _vm.accountPayment.phone = _controllerPhone.text;
    _vm.accountPayment.communication = _controllerContent.text;
    _vm.accountPayment.address = _controllerAddress.text;

    _vm.updateInfoAccountPayment(widget.accountPayment, context,
        isConfirm: isConfirm);
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    if (widget.accountPayment != null) {
      _vm.accountPayment = widget.accountPayment;
      _controllerMoney.text =
          vietnameseCurrencyFormat(widget.accountPayment.amount ?? 0);
      _controllerPhone.text = widget.accountPayment.phone ?? "";
      _controllerContent.text = widget.accountPayment.communication;
      _controllerAddress.text = widget.accountPayment.address ?? "";
      _vm.setInfoAccountPayment(widget.accountPayment);
      await _vm.getAccountJournals();
      await _vm.changeAccountJournal();
    } else {
      _controllerMoney.text = "0";
      await _vm.getDefaultAccountPaymentSale();
      await _vm.getAccountJournals();
    }
  }
}
