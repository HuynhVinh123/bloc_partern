import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/account_payment/uis/account_payment_info_page.dart';
import 'package:tpos_mobile/feature_group/account_payment_sale/viewmodel/account_payment_sale_info_viewmodel.dart';
import 'package:tpos_mobile/helpers/svg_icon.dart';
import 'package:tpos_mobile/resources/app_colors.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/widgets/button/action_button.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import '../../../locator.dart';
import 'account_payment_sale_add_edit_page.dart';

class AccountPaymentSaleInfoPage extends StatefulWidget {
  const AccountPaymentSaleInfoPage({this.id, this.callback});
  final int id;
  final Function callback;
  @override
  _AccountPaymentInfoPageState createState() => _AccountPaymentInfoPageState();
}

class _AccountPaymentInfoPageState extends State<AccountPaymentSaleInfoPage> {
  final _vm = locator<AccountPaymentSaleInfoViewModel>();

  TextStyle detailFontStyle;
  TextStyle titleFontStyle;

  @override
  void initState() {
    super.initState();
    _vm.getAccountPayment(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    detailFontStyle = const TextStyle(color: Color(0xFF5A6271));
    return ViewBase<AccountPaymentSaleInfoViewModel>(
        model: _vm,
        builder: (context, model, sizingInformation) {
          return WillPopScope(
              onWillPop: () async {
                if (_vm.accountPayment?.name != null) {
                  widget.callback(_vm.accountPayment);
                }

                return true;
              },
              child: Scaffold(
                backgroundColor: const Color(0xFFEBEDEF),
                appBar: AppBar(
                  /// Thông tin phiếu chi
                  title:
                      Text(S.current.paymentReceipt_paymentReceiptInformation),
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AccountPaymentSaleAddEditPage(
                                      accountPayment: _vm.accountPayment,
                                    ))).then((value) async {
                          if (value != null) {
                            await _vm.getAccountPayment(widget.id);
                            // if (value == 'confirm') {
                            //   await _vm.confirmAccountPayment(widget.id);
                            // } else if (value == 'cancel') {
                            //   await _vm.cancelAccountPayment(widget.id);
                            // }
                          }
                        });
                      },
                    ),
                    IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          _showBottomSheet();
                        })
                  ],
                ),
                body: SafeArea(child: _buildInfoAccountPayment()),
              ));
        });
  }

  Widget _buildInfoAccountPayment() {
    return Stack(
      children: [
        Container(
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
//                  Visibility(
//                    visible: _vm.accountPayment.state != "draft",
//                    child: Padding(
//                      padding: const EdgeInsets.symmetric(
//                          horizontal: 12, vertical: 8),
//                      child: Text(
//                        _vm.accountPayment?.name ?? "",
//                        style: detailFontStyle.copyWith(
//                            fontSize: 18, fontWeight: FontWeight.w700),
//                      ),
//                    ),
//                  ),
                  _buildHeader(_vm.accountPayment),
                  _buildInfoGeneral(_vm.accountPayment),
                ],
              ),
            )),
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
                      style: const TextStyle(color: Colors.white, fontSize: 17),
                    ),
                    onPressed: () async {
                      await App.showDefaultDialog(
                          title: S.current.confirm,
                          context: context,
                          content:
                              S.current.paymentReceipt_doYouWantToAddToTheBook,
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
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  _vm.confirmAccountPayment(widget.id);
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
                        style:
                            const TextStyle(color: Colors.white, fontSize: 17)),
                    onPressed: () async {
                      await App.showDefaultDialog(
                          title: S.current.receipts_cancel,
                          context: context,
                          content: S.current.paymentReceipt_doYouWantToCancel,
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
                                  _vm.cancelAccountPayment(widget.id);
                                }),
                          ]);
                    })),
          ),
        )
      ],
    );
  }

  Widget _buildHeader(AccountPayment item) {
    return Container(
      padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Visibility(
                        visible: _vm.accountPayment.state != "draft",
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8, bottom: 8, right: 10),
                          child: Text(
                            _vm.accountPayment?.name ?? "---",
                            style: detailFontStyle.copyWith(
                                fontSize: 14, color: const Color(0xFF929DAA)),
                          ),
                        ),
                      ),
                    ),
                    const Icon(Icons.person,
                        size: 18, color: Color(0xFF929DAA)),
                    const SizedBox(
                      width: 6,
                    ),
                    Text(
                      item.senderReceiver ?? "---",
                      style: const TextStyle(
                          color: Color(0xFF929DAA), fontSize: 14),
                    )
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(
                        "${item.amount != null ? vietnameseCurrencyFormat(item.amount) : 0}",
                        style: const TextStyle(
                          color: Color(0xFF2C333A),
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    const Text(
                      "đ",
                      style: TextStyle(color: Color(0xFF929DAA)),
                    )
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    if (item.journalName == "Ngân hàng")
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
                      width: 6,
                    ),
                    Flexible(
                        child: Text(
                      item.journalName ?? "",
                      style: const TextStyle(color: Color(0xFF6B7280)),
                    )),
                    const SizedBox(
                      width: 12,
                    ),
                    if (_vm.accountPayment.state == "draft")
                      const SvgIcon(
                        SvgIcon.stateDraft,
                        size: 16,
                      )
                    else
                      const SvgIcon(
                        SvgIcon.state,
                        size: 16,
                      ),
                    const SizedBox(
                      width: 6,
                    ),
                    Flexible(
                        child: Text(
                      _vm.accountPayment.state == "draft"
                          ? S.current.draft
                          : S.current.hasEnteredTheBook,
                      style: const TextStyle(color: Color(0xFF6B7280)),
                    )),
                  ],
                )
              ],
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: SvgIcon(
              SvgIcon.paymentBackGroundMoney,
              size: 110,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoGeneral(AccountPayment item) {
    const dividerMin = Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        height: 1,
        color: Color(0xFFEBEDEF),
      ),
    );
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          ItemRow(
            contentTextStyle: titleFontStyle,
            titleString: "${S.current.paymentReceipt_paymentReceiptType}:",
            content: Text(item.account?.nameGet ?? "---",
                textAlign: TextAlign.right, style: detailFontStyle),
          ),
          dividerMin,
          ItemRow(
            contentTextStyle: titleFontStyle,
            titleString: "${S.current.date}:",
            content: Text(
                item.paymentDate != null && item.paymentDate.toString() != ""
                    ? DateFormat("dd-MM-yyyy")
                        .format(item.paymentDate.toLocal())
                    : "---",
                textAlign: TextAlign.right,
                style: detailFontStyle),
          ),
          SizedBox(
            height: 12,
            child: Container(
              color: const Color(0xFFEBEDEF),
            ),
          ),
          _buildContent(item, dividerMin),
          const SizedBox(
            height: 6,
          )
        ],
      ),
    );
  }

  Widget _buildContent(AccountPayment item, dynamic dividerMin) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 6,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Text(
              S.current.quotation_information.toUpperCase(),
              style: const TextStyle(color: Color(0xFF28A745)),
            ),
          ),

//          /// Phương thức
//          ItemRow(
//            contentTextStyle: titleFontStyle,
//            titleString: "${S.current.paymentMethod}: ",
//            content: Text(item.journalName ?? "",
//                textAlign: TextAlign.right, style: detailFontStyle),
//          ),

          /// "Người nộp
          ItemRow(
            contentTextStyle: titleFontStyle,
            titleString: "${S.current.paymentReceipt_receiver}:",
            content: Text(item.senderReceiver ?? "---",
                textAlign: TextAlign.right, style: detailFontStyle),
          ),
          dividerMin,
          ItemRow(
            contentTextStyle: titleFontStyle,
            titleString: "${S.current.phoneNumber}:",
            content: Text(item.phone ?? "---",
                textAlign: TextAlign.right, style: detailFontStyle),
          ),
          dividerMin,

          /// Địa chỉ
          ItemRow(
            contentTextStyle: titleFontStyle,
            titleString: "${S.current.address}:",
            content: Text(item.address ?? "---",
                textAlign: TextAlign.right, style: detailFontStyle),
          ),
          dividerMin,

          ///Người liên hệ
          ItemRow(
            contentTextStyle: titleFontStyle,
            titleString: "${S.current.contact}:",
            content: Text(item.contact?.name ?? "---",
                textAlign: TextAlign.right, style: detailFontStyle),
          ),
          dividerMin,

          /// Nội dung
          ItemRow(
            contentTextStyle: titleFontStyle,
            titleString: "${S.current.content}:",
            content: Text(item.communication ?? "---",
                textAlign: TextAlign.right, style: detailFontStyle),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      topLeft: Radius.circular(12))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Visibility(
                    visible: false,
                    child: ListTile(
                      title: Text(S.current.print),
                      leading: const Icon(
                        Icons.print,
                        color: Color(0xFF929DAA),
                      ),
                      onTap: () {},
                    ),
                  ),
                  Visibility(
                    visible: _vm.accountPayment.state == "draft",
                    child: ListTile(
                      onTap: () async {
                        Navigator.pop(context);
                        await App.showDefaultDialog(
                            title: S.current.confirm,
                            context: context,
                            content: S
                                .current.paymentReceipt_doYouWantToAddToTheBook,
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
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    _vm.confirmAccountPayment(widget.id);
                                  }),
                            ]);
                      },
                      leading: const Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                      title: Text(
                        S.current.confirm,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _vm.accountPayment.state != "draft",
                    child: ListTile(
                      onTap: () async {
                        Navigator.pop(context);

                        await App.showDefaultDialog(
                            title: S.current.receipts_cancel,
                            context: context,
                            content: S.current.paymentReceipt_doYouWantToCancel,
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
                                    _vm.cancelAccountPayment(widget.id);
                                  }),
                            ]);
                      },
                      subtitle: Row(
                        children: [
                          const Icon(
                            FontAwesomeIcons.exclamationCircle,
                            size: 14,
                            color: Color(0xFFA7B2BF),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Flexible(
                            child: Text(
                              S.current.paymentReceipt_cancelInfo,
                              style: const TextStyle(
                                  color: Color(0xFF929DAA), fontSize: 13),
                            ),
                          )
                        ],
                      ),
                      leading: const Icon(
                        Icons.close,
                      ),
                      title: Text(
                        S.current.cancel,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(S.current.delete),
                    leading: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onTap: () async {
                      Navigator.pop(context);

                      final DialogResultType dialogResult = await showQuestion(
                          context: context,
                          title: S.current.delete,
                          message:
                              "${S.current.receiptType_doYouWantDeleteReceipt} ${_vm.accountPayment.name ?? ""}");
                      if (dialogResult == DialogResultType.YES) {
                        if (_vm.accountPayment.state == "posted") {
                          _vm.showError(S.current.receipts_cannotDeleteReceipt);
                        } else {
                          final bool result =
                              await _vm.deleteAccountPayment(widget.id);
                          if (result) {
                            Navigator.pop(context, _vm.accountPayment);
                          }
                        }
                      }
                    },
                  )
                ],
              ));
        });
  }
}
