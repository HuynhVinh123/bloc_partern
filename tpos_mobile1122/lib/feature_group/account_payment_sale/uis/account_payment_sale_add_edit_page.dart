import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/account_payment/uis/partner_search_contact_page.dart';
import 'package:tpos_mobile/feature_group/account_payment/uis/account_payment_type_list_page.dart';
import 'package:tpos_mobile/feature_group/account_payment_sale/viewmodel/account_payment_sale_add_edit_viewmodel.dart';
import 'package:tpos_mobile/feature_group/category/partner_list_page.dart';
import 'package:tpos_mobile/helpers/app_helper.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
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

  final Widget _dividerSpace = const Padding(
    padding: EdgeInsets.symmetric(horizontal: 12),
    child: Divider(
      height: 1,
    ),
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
                        ? Text(S.current.paymentReceipt_edit)
                        : Text(S.current.paymentReceipt_add),
                    actions: <Widget>[
                      Visibility(
                        visible: _vm.accountPayment.state == "draft",
                        child: InkWell(
                          onTap: () {
                            if (_vm.accountPayment.state == "draft") {
                              if (_vm.account != null &&
                                  _vm.selectTypePayment != -1) {
                                updateInfoAccountPayment(context);
                              } else {
                                _vm.showNotify(
                                    S.current.paymentReceipt_notifyAddEdit);
                              }
                            }
                          },
                          child: Row(
                            children: <Widget>[
                              Text(
                                S.current.save,
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              const Icon(Icons.save),
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
                    child: Container(
                      color: Colors.white,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 0,
                            bottom: 60,
                            left: 0,
                            right: 0,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  _buildHeader(),
//                                  _buildStatusView(),
                                  InkWell(
                                    onTap: () {
                                      if (_vm.accountPayment.state == "draft") {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AccountPaymentTypeListPage(
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
                                          Text(
                                            S.current
                                                .paymentReceipt_paymentReceiptType,
                                            style: const TextStyle(
                                                color: Color(0xFF2C333A),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Expanded(
                                              child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              _vm.account != null
                                                  ? _vm.account.nameGet
                                                  : S.current
                                                      .paymentReceipt_paymentReceiptType,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: _vm.account != null
                                                      ? const Color(0xFF5A6271)
                                                      : const Color(
                                                          0xFF929DAA)),
                                            ),
                                          )),
                                          Visibility(
                                            visible: _vm.account != null,
                                            child: InkWell(
                                              onTap: () {
                                                if (_vm.accountPayment.state ==
                                                    "draft") {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          FocusNode());
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
                                                width: 28,
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.close,
                                                    color: Colors.red,
                                                    size: 18,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const Icon(
                                            Icons.keyboard_arrow_right,
                                            color: Color(0xFF929DAA),
                                            size: 15,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  _dividerSpace,
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 18),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            S.current.date,
                                            style: const TextStyle(
                                                color: Color(0xFF2C333A),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Expanded(
                                              child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              " ${_vm.selectTime != null ? DateFormat("dd-MM-yyyy").format(_vm.selectTime) : S.current.chooseDate}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: _vm.selectTime != null
                                                      ? const Color(0xFF5A6271)
                                                      : const Color(
                                                          0xFF929DAA)),
                                            ),
                                          )),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          const Icon(
                                            Icons.date_range,
                                            size: 20,
                                            color: Color(0xFF5A6271),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                    child: Container(
                                      color: Colors.grey[100],
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12,
                                        right: 12,
                                        top: 16,
                                        bottom: 6),
                                    child: Text(
                                      S.current.quotation_information
                                          .toUpperCase(),
                                      style: const TextStyle(
                                          color: Color(0xFF28A745)),
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
                                                const PartnerListPage(
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
                                          vertical: 18),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            S.current.paymentReceipt_receiver,
                                            style: const TextStyle(
                                                color: Color(0xFF2C333A),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Expanded(
                                              child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              _vm.partner != null &&
                                                      !_vm.isShowReceiver
                                                  ? _vm.partner.name
                                                  : _vm.accountPayment
                                                          .senderReceiver ??
                                                      S.current
                                                          .paymentReceipt_receiver,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: _vm.partner != null
                                                      ? const Color(0xFF5A6271)
                                                      : const Color(
                                                          0xFF929DAA)),
                                            ),
                                          )),
                                          Visibility(
                                            visible: _vm.partner != null,
                                            child: InkWell(
                                              onTap: () {
                                                if (_vm.accountPayment.state ==
                                                    "draft") {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          FocusNode());
                                                  _vm.partner = null;
                                                }
                                              },
                                              child: Container(
                                                width: 28,
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.close,
                                                    color: Colors.red,
                                                    size: 18,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const Icon(
                                            Icons.keyboard_arrow_right,
                                            color: Color(0xFF929DAA),
                                            size: 15,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  _dividerSpace,

                                  _buildInfoContent(
                                      S.current.phoneNumber, _controllerPhone,
                                      isPhone: true),

                                  _dividerSpace,

                                  /// địa chỉ
                                  _buildInfoContent(
                                      S.current.address, _controllerAddress),
                                  _dividerSpace,
                                  InkWell(
                                    onTap: () {
                                      if (_vm.accountPayment.state == "draft") {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PartnerSearchContactPage()),
                                        ).then((value) {
                                          if (value != null) {
                                            _vm.partnerContact = value;
                                          }
                                        });
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 18),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            S.current.contact,
                                            style: const TextStyle(
                                                color: Color(0xFF2C333A),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Expanded(
                                              child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              _vm.partnerContact != null
                                                  ? _vm.partnerContact
                                                      .displayName
                                                  : S.current.contact,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: _vm.partnerContact !=
                                                          null
                                                      ? const Color(0xFF5A6271)
                                                      : const Color(
                                                          0xFF929DAA)),
                                            ),
                                          )),
                                          Visibility(
                                            visible: _vm.partnerContact != null,
                                            child: InkWell(
                                              onTap: () {
                                                if (_vm.accountPayment.state ==
                                                    "draft") {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          FocusNode());
                                                  _vm.partnerContact = null;
                                                }
                                              },
                                              child: Container(
                                                width: 28,
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.close,
                                                    color: Colors.red,
                                                    size: 18,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const Icon(
                                            Icons.keyboard_arrow_right,
                                            color: Color(0xFF929DAA),
                                            size: 15,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    child: Divider(
                                      height: 1,
                                    ),
                                  ),

                                  /// Nộ dung
                                  _buildInfoContent(
                                      S.current.content, _controllerContent),
                                  _dividerSpace,
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            left: 12,
                            right: 12,
                            child: Visibility(
                              visible: _vm.accountPayment.state == "draft",
                              child: Container(
                                  width: 130,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: const Color(0xFF28A745)),
                                  child: FlatButton.icon(
                                      icon: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 18,
                                      ),

                                      /// Xác nhận
                                      label: Text(
                                        S.current.confirm,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 17),
                                      ),
                                      onPressed: () async {
                                        final dialogResult = await showQuestion(
                                            context: context,
                                            title: S.current.confirm,
                                            message: S.current
                                                .paymentReceipt_doYouWantToAddToTheBook);
                                        if (dialogResult ==
                                            DialogResultType.YES) {
                                          if (widget.accountPayment == null) {
                                            if (_vm.account != null &&
                                                _vm.selectTypePayment != -1) {
                                              updateInfoAccountPayment(context,
                                                  isConfirm: true);
                                            } else {
                                              ///Bạn phải chọn đầy đủ \"Loại chi\" và \"Phương thức\"
                                              _vm.showNotify(S.current
                                                  .paymentReceipt_notifyAddEdit);
                                            }
                                          } else {
                                            updateInfoAccountPayment(context,
                                                isConfirm: true);
                                          }
                                        }
                                      })),
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            left: 12,
                            right: 12,
                            child: Visibility(
                              visible: _vm.accountPayment.state == "posted",
                              child: Container(
                                  width: 130,
                                  decoration: BoxDecoration(
                                      color: Colors.red[500],
                                      borderRadius: BorderRadius.circular(8)),
                                  child: FlatButton.icon(
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      label: Text(S.current.cancel,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 17)),
                                      onPressed: () async {
                                        final dialogResult = await showQuestion(
                                            context: context,
                                            title: S.current.cancel,
                                            message: S.current
                                                .paymentReceipt_doYouWantToCancel);
                                        if (dialogResult ==
                                            DialogResultType.YES) {
                                          await _vm
                                              .cancelAccountPayment(context);
                                        }
                                      })),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ));
          }),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: const Color(0xFFF8F9FB),
      height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [_buildTypePayment(), _buildFormMoney()],
      ),
    );
  }

  Widget _buildStatusView() {
    return MyStepView(currentIndex: 2, items: [
      MyStepItem(
        title: Text(
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
        title: Text(
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
          hint: Text(S.current.paymentReceipt_paymentReceiptType),
          items: [
            ..._vm.accountJournals
                .map(
                  (value) => DropdownMenuItem(
                    value: "${value.id}",
                    child: Row(
                      children: [
                        if (value.name == "Ngân hàng")
                          SvgPicture.asset(
                            "assets/icon/card.svg",
                            fit: BoxFit.fill,
                            width: 15,
                            height: 15,
                          )
                        else
                          SvgPicture.asset(
                            "assets/icon/money.svg",
                            fit: BoxFit.fill,
                            width: 15,
                            height: 15,
                          ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          value.name ?? "",
                        ),
                      ],
                    ),
                  ),
                )
                .toList()
          ],
          onChanged: (value) {
            if (_vm.accountJournal.id.toString() != value) {
              _vm.removeAccountJournal();
            }
            _vm.selectTypePayment = int.parse(value);
          },
          value: "${_vm.selectTypePayment}",
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
        decoration: InputDecoration(
            hintText: S.current.amount,
            hintStyle: const TextStyle(fontSize: 16),
            border: InputBorder.none),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly,
          NumberInputFormat.vietnameDong(),
        ],
        enabled: _vm.accountPayment.state == "draft",
        style: const TextStyle(
            fontSize: 21,
            color: Color(0xFFA7B2BF),
            fontWeight: FontWeight.w600),
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
                  labelStyle:
                      const TextStyle(fontSize: 15, color: Color(0xFF929DAA)),
                  border: InputBorder.none),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              enabled: _vm.accountPayment.state == "draft",
            ),
          )
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                  labelText: hintText ?? "",
                  border: InputBorder.none,
                  labelStyle:
                      const TextStyle(fontSize: 15, color: Color(0xFF929DAA))),
              enabled: _vm.accountPayment.state == "draft",
            ),
          );
  }

  void updateInfoAccountPayment(BuildContext context,
      {bool isConfirm = false}) {
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
