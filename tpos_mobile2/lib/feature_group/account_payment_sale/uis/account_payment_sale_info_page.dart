import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/account_payment_sale/viewmodel/account_payment_sale_info_viewmodel.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/account_payment.dart';
import 'package:tpos_mobile/widgets/info_row.dart';
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
    titleFontStyle = const TextStyle(color: Colors.green);
    detailFontStyle = const TextStyle(color: Colors.green);
    return ViewBase<AccountPaymentSaleInfoViewModel>(
        model: _vm,
        builder: (context, model, sizingInformation) {
          return WillPopScope(
              onWillPop: () async {
                widget.callback(_vm.accountPayment);
                return true;
              },
              child: Scaffold(
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
                                    ))).then((value) {
                          if (value != null) {
                            _vm.getAccountPayment(widget.id);
                          }
                        });
                      },
                    )
                  ],
                ),
                body: SafeArea(child: _buildInfoAccountPayment()),
              ));
        });
  }

  Widget _buildInfoAccountPayment() {
    const Widget spaceHeight = SizedBox(
      height: 10,
    );
    return Container(
      margin: const EdgeInsets.all(8.0),
      height: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey[400],
                offset: const Offset(0, 2),
                blurRadius: 2)
          ]),
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 100,
            top: 0,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Visibility(
                    visible: _vm.accountPayment.state != "draft",
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Text(
                        _vm.accountPayment?.name ?? "",
                        style: detailFontStyle.copyWith(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  spaceHeight,
                  _buildInfoGeneral(_vm.accountPayment),
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
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4)),
                child: FlatButton(
                  child: Text(
                    S.current.confirm,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                  onPressed: () async {
                    final dialogResult = await showQuestion(
                        context: context,
                        title: S.current.confirm,
                        message:
                            S.current.paymentReceipt_doYouWantToAddToTheBook);
                    if (dialogResult == DialogResultType.YES) {
                      _vm.confirmAccountPayment(widget.id);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 24,
            right: 24,
            child: Visibility(
              visible: _vm.accountPayment.state != "draft",
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.red[500],
                    borderRadius: BorderRadius.circular(4)),
                child: FlatButton(
                  child: Text(
                    S.current.cancel,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () async {
                    final dialogResult = await showQuestion(
                        context: context,
                        title: S.current.cancel,
                        message: S.current.paymentReceipt_doYouWantToCancel);
                    if (dialogResult == DialogResultType.YES) {
                      _vm.cancelAccountPayment(widget.id);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoGeneral(AccountPayment item) {
    const dividerMin = Divider(
      height: 2,
    );
    return Column(
      children: <Widget>[
        InfoRow(
          contentTextStyle: titleFontStyle,
          titleString: "${S.current.paymentReceipt_paymentReceiptType}:",
          content: Text(item.account?.nameGet ?? "",
              textAlign: TextAlign.right, style: detailFontStyle),
        ),
        dividerMin,
        InfoRow(
          contentTextStyle: titleFontStyle,
          titleString: "${S.current.paymentMethod}: ",
          content: Text(item.journalName ?? "",
              textAlign: TextAlign.right, style: detailFontStyle),
        ),
        dividerMin,
        InfoRow(
          contentTextStyle: titleFontStyle,
          titleString: "${S.current.totalAmount}:",
          content: Text(
              " ${item.amount == null ? "" : vietnameseCurrencyFormat(item.amount)}",
              textAlign: TextAlign.right,
              style: detailFontStyle),
        ),
        dividerMin,
        InfoRow(
          contentTextStyle: titleFontStyle,
          titleString: "${S.current.content}:",
          content: Text(item.communication ?? "",
              textAlign: TextAlign.right, style: detailFontStyle),
        ),
        dividerMin,
        InfoRow(
          contentTextStyle: titleFontStyle,
          titleString: "${S.current.date}:",
          content: Text(
              item.paymentDate != null && item.paymentDate.toString() != ""
                  ? DateFormat("dd-MM-yyyy").format(item.paymentDate.toLocal())
                  : "",
              textAlign: TextAlign.right,
              style: detailFontStyle),
        ),
        dividerMin,
        InfoRow(
          contentTextStyle: titleFontStyle,
          titleString: "${S.current.paymentReceipt_receiver}:",
          content: Text(item.senderReceiver ?? "",
              textAlign: TextAlign.right, style: detailFontStyle),
        ),
        dividerMin,
        InfoRow(
          contentTextStyle: titleFontStyle,
          titleString: "${S.current.phoneNumber}:",
          content: Text(item.phone ?? "",
              textAlign: TextAlign.right, style: detailFontStyle),
        ),
        dividerMin,
        InfoRow(
          contentTextStyle: titleFontStyle,
          titleString: "${S.current.address}:",
          content: Text(item.address ?? "",
              textAlign: TextAlign.right, style: detailFontStyle),
        ),
        dividerMin,
        InfoRow(
          contentTextStyle: titleFontStyle,
          titleString: "${S.current.contact}:",
          content: Text(item.contact?.name ?? "",
              textAlign: TextAlign.right, style: detailFontStyle),
        ),
        dividerMin,
        InfoRow(
          contentTextStyle: titleFontStyle,
          titleString: "${S.current.status}:",
          content: Text(
              item.state == "draft"
                  ? S.current.draft
                  : S.current.hasEnteredTheBook,
              textAlign: TextAlign.right,
              style: detailFontStyle),
        ),
      ],
    );
  }
}
