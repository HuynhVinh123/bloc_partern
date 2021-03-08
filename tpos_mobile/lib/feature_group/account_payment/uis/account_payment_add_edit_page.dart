import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/account_payment/uis/account_payment_type_list_page.dart';
import 'package:tpos_mobile/feature_group/account_payment/uis/partner_search_contact_page.dart';
import 'package:tpos_mobile/feature_group/account_payment/viewmodel/account_payment_add_edit_viewmodel.dart';
import 'package:tpos_mobile/feature_group/category/partner/partner_search_page.dart';
import 'package:tpos_mobile/helpers/svg_icon.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/resources/app_colors.dart';
import 'package:tpos_mobile/widgets/button/action_button.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class AccountPaymentAddEditPage extends StatefulWidget {
  const AccountPaymentAddEditPage({this.accountPayment});

  final AccountPayment accountPayment;

  @override
  _AccountPaymentAddEditPageState createState() =>
      _AccountPaymentAddEditPageState();
}

class _AccountPaymentAddEditPageState extends State<AccountPaymentAddEditPage> {
  final _vm = locator<AccountPaymentAddEditViewModel>();

  final FocusNode _focusNodeMoney = FocusNode();
  final TextEditingController _controllerMoney = TextEditingController();
  final TextEditingController _controllerContent = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerAddress = TextEditingController();
  final TextEditingController _receiverController = TextEditingController();

  final Widget _spaceHeight = const SizedBox(
    height: 8,
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_vm.accountPayment != null && _vm.accountPayment.state == "draft") {
          if (_vm.isEdit && !_vm.isConfirmFailed) {
            return await App.showDefaultDialog(
                title: S.current.confirm + ' ' + S.current.close.toLowerCase(),
                context: context,

                /// Dữ liệu chưa được lưu bạn có muốn đóng?
                content: S.current.confirmClose,
                type: AlertDialogType.error,
                actions: [
                  ActionButton(
                      child: Text(S.current.cancel.toUpperCase()),
                      color: Colors.grey.shade200,
                      textColor: AppColors.brand3,
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      }),
                  ActionButton(
                    child: Text(S.current.dialogActionOk.toUpperCase()),
                    color: Colors.grey.shade200,
                    textColor: AppColors.brand3,
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                      Navigator.pop(context);
                    },
                  ),
                ]);
          } else if (_vm.isConfirmFailed) {
            Navigator.pop(context, '');
          }
        }
        return true;
      },
      child: ViewBase<AccountPaymentAddEditViewModel>(
          model: _vm,
          builder: (context, model, sizingInformation) {
            return GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Scaffold(

                    ///  Sửa phiếu thu    Thêm phiếu thu
                    appBar: AppBar(
                      title: widget.accountPayment != null
                          ? Text(S.current.receipts_editReceipt)
                          : Text(S.current.receipts_addReceipt),
                      actions: <Widget>[
                        Visibility(
                          visible: _vm.accountPayment.state == "draft",
                          child: InkWell(
                            onTap: () async {
                              if (_vm.accountPayment.state == "draft") {
                                if (_vm.account != null &&
                                    _vm.selectTypePayment != -1) {
                                  await updateInfoAccountPayment();
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
                    body: _buildBody()));
          }),
    );
  }

  Widget _buildBody() {
    const dividerSpace = Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Divider(
        height: 1,
      ),
    );
    return SafeArea(
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
//                    _buildStatusView(),
                    InkWell(
                      onTap: () {
                        if (_vm.accountPayment.state == "draft") {
                          FocusScope.of(context).requestFocus(FocusNode());
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AccountPaymentTypeListPage(true)),
                          ).then((value) {
                            if (value != null) {
                              _vm.isEdit = true;
                              _vm.account = value;
                            }
                          });
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 12, right: 12),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    S.current.receipts_receiptsType,
                                    style: const TextStyle(
                                      color: Color(0xFF2C333A),
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    _vm.account != null
                                        ? _vm.account.nameGet ?? ""
                                        : S.current.receipts_receiptsType,
                                    style: const TextStyle(
                                        fontSize: 15, color: Color(0xFF929DAA)),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 6,
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
                    dividerSpace,
                    InkWell(
                      onTap: () async {
                        if (_vm.accountPayment.state == "draft") {
                          FocusScope.of(context).requestFocus(FocusNode());
                          final date = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: _vm.selectTime,
                            lastDate: DateTime(2100),
                          );
                          if (date != null) {
                            _vm.isEdit = true;
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
                                  color: Color(0xFF2C333A), fontSize: 15),
                            ),
                            const SizedBox(
                              width: 10,
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
                                        : const Color(0xFF929DAA)),
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
                    _buildContent()
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
                        label: Text(
                          S.current.confirm,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 17),
                        ),
                        onPressed: () async {
                          await App.showDefaultDialog(
                              title: S.current.confirm,
                              context: context,
                              content: S.current
                                  .paymentReceipt_doYouWantToAddToTheBook,
                              type: AlertDialogType.info,
                              actions: [
                                ActionButton(
                                    child: Text(S.current.cancel.toUpperCase()),
                                    color: Colors.grey.shade200,
                                    textColor: AppColors.brand3,
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    }),
                                ActionButton(
                                    child: Text(
                                        S.current.dialogActionOk.toUpperCase()),
                                    color: Colors.grey.shade200,
                                    textColor: AppColors.brand3,
                                    onPressed: () async {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                      if (widget.accountPayment == null) {
                                        if (_vm.account != null &&
                                            _vm.selectTypePayment != -1) {
                                          await updateInfoAccountPayment(
                                              isConfirm: true);
                                        } else {
                                          _vm.showNotify(S.current
                                              .paymentReceipt_notifyAddEdit);
                                        }
                                      } else {
                                        await updateInfoAccountPayment(
                                            isConfirm: true);
                                      }
                                    }),
                              ]);
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
                        borderRadius: BorderRadius.circular(4)),
                    child: FlatButton.icon(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 18,
                        ),
                        label: Text(S.current.cancel,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 17)),
                        onPressed: () async {
                          await App.showDefaultDialog(
                              title: S.current.receipts_cancel,
                              context: context,
                              content:
                                  S.current.paymentReceipt_doYouWantToCancel,
                              type: AlertDialogType.error,
                              actions: [
                                ActionButton(
                                    child: Text(S.current.cancel.toUpperCase()),
                                    color: Colors.grey.shade200,
                                    textColor: AppColors.brand3,
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    }),
                                ActionButton(
                                    child: Text(
                                        S.current.dialogActionOk.toUpperCase()),
                                    color: Colors.grey.shade200,
                                    textColor: AppColors.brand3,
                                    onPressed: () async {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                      await _vm.cancelAccountPayment(context);
                                    }),
                              ]);
                        })),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    const Widget dividerSpace = Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Divider(
        height: 1,
      ),
    );
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 6),
            child: Text(
              S.current.quotation_information.toUpperCase(),
              style: const TextStyle(color: Color(0xFF28A745)),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 12, right: 12),
            child: Row(
              children: <Widget>[
                Flexible(
                    child: TextField(
                  enabled: _vm.accountPayment.state == "draft",
                  controller: _receiverController,
                  decoration: InputDecoration(
                    labelText: S.current.receipts_sender,
                    border: InputBorder.none,
                    labelStyle:
                        const TextStyle(fontSize: 15, color: Color(0xFF929DAA)),

                    hintText: S.current.receipts_sender,
                    hintStyle:
                        const TextStyle(fontSize: 15, color: Color(0xFF929DAA)),
                    // enabledBorder: UnderlineInputBorder(
                    //     borderSide: BorderSide(color: Colors.grey[200])),
                  ),
                )),
                const SizedBox(
                  width: 10,
                ),
                // const Text('Chọn người gửi'),
                // Icon(
                //   Icons.keyboard_arrow_right,
                //   color: Color(0xFF929DAA),
                //   size: 15,
                // )
                InkWell(
                  onTap: () {
                    if (_vm.accountPayment.state == "draft") {
                      FocusScope.of(context).requestFocus(FocusNode());
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PartnerSearchPage(
                                  isCustomer: true,
                                )),
                      ).then((value) {
                        if (value != null) {
                          _vm.isEdit = true;
                          _vm.isShowReceiver = false;
                          _vm.partner = value;
                          _controllerPhone.text = _vm.partner.phone ?? "";
                          _controllerAddress.text = _vm.partner.street ?? "";
                          _receiverController.text = _vm.partner.name;
                        }
                      });
                    }
                  },
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        FontAwesomeIcons.user,
                        color: Color(0xFF929DAA),
                        size: 16,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          dividerSpace,
          _buildInfoContent(S.current.phoneNumber, _controllerPhone,
              isPhone: true),
          // dividerSpace,

          /// địa chỉ
          _buildInfoContent(S.current.address, _controllerAddress),

          InkWell(
            onTap: () {
              if (_vm.accountPayment.state == "draft") {
                FocusScope.of(context).requestFocus(FocusNode());
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PartnerSearchContactPage()),
                ).then((value) {
                  if (value != null) {
                    _vm.isEdit = true;
                    _vm.partnerContact = value;
                  }
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.current.contact,
                          style: const TextStyle(
                              color: Color(0xFF2C333A), fontSize: 15),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                _vm.partnerContact != null
                                    ? _vm.partnerContact?.name ?? ""
                                    : S.current.contact,
                                style: const TextStyle(
                                    fontSize: 15, color: Color(0xFF929DAA)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Visibility(
                              visible: _vm.partnerContact != null,
                              child: InkWell(
                                onTap: () {
                                  if (_vm.accountPayment.state == "draft") {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    _vm.partnerContact = null;
                                  }
                                },
                                child: Container(
                                  width: 28,
                                  height: 24,
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
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 6,
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
          dividerSpace,

          /// Nội dung
          _buildInfoContent(S.current.content, _controllerContent),
          _spaceHeight,
        ],
      ),
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

  Widget _buildTypePayment() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: IgnorePointer(
          ignoring: _vm.accountPayment.state != "draft",
          child: DropdownButton<String>(
            hint: Text(S.current.receipts_receiptsType),
            items: [
              ..._vm.accountJournals
                  .map(
                    (value) => DropdownMenuItem(
                      value: "${value.id}",
                      child: Row(
                        children: [
                          if (value.name == "Ngân hàng")
                            const SvgIcon(
                              SvgIcon.card,
                              size: 15,
                            )
                          else
                            const SvgIcon(
                              SvgIcon.money,
                              size: 15,
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
              _vm.isEdit = true;
              if (_vm.accountJournal.id.toString() != value) {
                _vm.removeAccountJournal();
              }
              _vm.selectTypePayment = int.parse(value);
            },
            value: "${_vm.selectTypePayment}",
            underline: const SizedBox(),
          ),
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
        decoration: InputDecoration(
            hintText: S.current.amount,
            border: InputBorder.none,
            hintStyle: const TextStyle(fontSize: 16, color: Color(0xFF5A6271)),
            isDense: true),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.right,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
          NumberInputFormat.vietnameDong(),
        ],
        enabled: _vm.accountPayment.state == "draft",
        style: const TextStyle(
            fontSize: 21,
            color: Color(0xFF5A6271),
            fontWeight: FontWeight.w600),
        onChanged: (value) {
          _vm.isEdit = true;
        },
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
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF28A745))),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[100])),
                  labelStyle:
                      const TextStyle(fontSize: 15, color: Color(0xFF929DAA))),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              enabled: _vm.accountPayment.state == "draft",
              onChanged: (value) {
                _vm.isEdit = true;
              },
            ))
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                  labelText: hintText ?? '',
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF28A745))),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[100])),
                  labelStyle:
                      const TextStyle(fontSize: 15, color: Color(0xFF929DAA))),
              enabled: _vm.accountPayment.state == "draft",
              maxLines: null,
              onChanged: (value) {
                _vm.isEdit = true;
              },
            ),
          );
  }

  Future<void> updateInfoAccountPayment({bool isConfirm = false}) async {
    _vm.isConfirmFailed = true;
    _vm.isEdit = false;
    _vm.accountPayment.amount =
        double.parse(_controllerMoney.text.replaceAll(".", ""));
    _vm.accountPayment.phone = _controllerPhone.text;
    _vm.accountPayment.communication = _controllerContent.text;
    _vm.accountPayment.address = _controllerAddress.text;
    _vm.accountPayment.senderReceiver = _receiverController.text;

    await _vm.updateInfoAccountPayment(widget.accountPayment, context,
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
      _receiverController.text = widget.accountPayment.senderReceiver;
      _vm.setInfoAccountPayment(widget.accountPayment);
      await _vm.getAccountJournals();
      await _vm.changeAccountJournal();
    } else {
      _controllerMoney.text = "0";
      await _vm.getDefaultAccountPayment();
      await _vm.getAccountJournals();
    }
  }
}
