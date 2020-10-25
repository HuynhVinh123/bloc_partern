import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/account_payment/viewmodel/account_payment_info_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/account_payment.dart';
import 'package:tpos_mobile/widgets/info_row.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import 'account_payment_add_edit_page.dart';

class AccountPaymentInfoPage extends StatefulWidget {
  const AccountPaymentInfoPage({this.id, this.callback});
  final int id;
  final Function callback;

  @override
  _AccountPaymentInfoPageState createState() => _AccountPaymentInfoPageState();
}

class _AccountPaymentInfoPageState extends State<AccountPaymentInfoPage> {
  final _vm = locator<AccountPaymentInfoViewModel>();

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
    return ViewBase<AccountPaymentInfoViewModel>(
        model: _vm,
        builder: (context, model, sizingInformation) {
          return WillPopScope(
              onWillPop: () async {
                widget.callback(_vm.accountpayment);
                return true;
              },
              child: Scaffold(
                backgroundColor: const Color(0xFFEBEDEF),
                appBar: _buildAppBar(),
                body: SafeArea(child: _buildInfoPointSale()),
              ));
        });
  }

  Widget _buildAppBar() {
    return AppBar(
      /// Thông tin phiếu thu
      title: Text(S.current.receipts_receiptInformation),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AccountPaymentAddEditPage(
                          accountPayment: _vm.accountpayment,
                        ))).then((value) {
              if (value != null) {
                _vm.getAccountPayment(widget.id);
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
    );
  }

  Widget _buildInfoPointSale() {
    const Widget spaceHeight = SizedBox(
      height: 10,
    );
    return Container(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHeader(_vm.accountpayment),
            _buildInfoGeneral(_vm.accountpayment),
          ],
        ),
      ),
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
                        visible: _vm.accountpayment.state != "draft",
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8, bottom: 8, right: 10),
                          child: Text(
                            _vm.accountpayment?.name ?? "...",
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
                      item.senderReceiver ?? "...",
                      style: const TextStyle(
                          color: Color(0xFF929DAA), fontSize: 14),
                    )
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  "${item.amount != null ? vietnameseCurrencyFormat(item.amount) : 0}",
                  style: const TextStyle(
                    color: Color(0xFF2C333A),
                    fontSize: 17,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icon/money.svg",
                      fit: BoxFit.fill,
                      width: 16,
                      height: 16,
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
                    SvgPicture.asset(
                      "assets/icon/ic_state.svg",
                      fit: BoxFit.fill,
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Flexible(
                        child: Text(
                      _vm.accountpayment.state == "draft"
                          ? S.current.draft
                          : S.current.hasEnteredTheBook,
                      style: const TextStyle(color: Color(0xFF6B7280)),
                    )),
                  ],
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SvgPicture.asset(
              "assets/icon/background_money.svg",
              fit: BoxFit.fill,
              width: 100,
              height: 100,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ItemRow(
            contentTextStyle: titleFontStyle,

            /// Loại thu
            titleString: "${S.current.receipts_receiptsType}:",
            content: Text(item.account?.nameGet ?? "...",
                textAlign: TextAlign.right, style: detailFontStyle),
          ),
          dividerMin,
          ItemRow(
              contentTextStyle: titleFontStyle,
              titleString: "${S.current.date}:",
              content: Text(
                  " ${item.paymentDate != null && item.paymentDate.toString() != "" ? DateFormat("dd-MM-yyyy").format(item.paymentDate.toLocal()) : "..."}",
                  textAlign: TextAlign.right,
                  style: detailFontStyle)),
          SizedBox(
            height: 12,
            child: Container(color: const Color(0xFFEBEDEF),),
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

          /// Số tiền
          ItemRow(
            contentTextStyle: titleFontStyle,
            titleString: "${S.current.totalAmount}:",
            content: Text(vietnameseCurrencyFormat(item.amount ?? 0),
                textAlign: TextAlign.right, style: detailFontStyle),
          ),
          dividerMin,

          /// Nội dung
          ItemRow(
            contentTextStyle: titleFontStyle,
            titleString: "${S.current.content}:",
            content: Text(item.communication ?? "...",
                textAlign: TextAlign.right, style: detailFontStyle),
          ),
          dividerMin,

          /// "Người nộp
          ItemRow(
            contentTextStyle: titleFontStyle,
            titleString: "${S.current.receipts_sender}:",
            content: Text(item.senderReceiver ?? "...",
                textAlign: TextAlign.right, style: detailFontStyle),
          ),
          dividerMin,
          ItemRow(
            contentTextStyle: titleFontStyle,
            titleString: "${S.current.phoneNumber}:",
            content: Text(item.phone ?? "",
                textAlign: TextAlign.right, style: detailFontStyle),
          ),
          dividerMin,

          /// Địa chỉ
          ItemRow(
            contentTextStyle: titleFontStyle,
            titleString: "${S.current.address}:",
            content: Text(item.address ?? "..",
                textAlign: TextAlign.right, style: detailFontStyle),
          ),
          dividerMin,

          ///Người liên hệ
          ItemRow(
            contentTextStyle: titleFontStyle,
            titleString: "${S.current.contact}:",
            content: Text(item.contact?.name ?? "...",
                textAlign: TextAlign.right, style: detailFontStyle),
          ),
          dividerMin,

          /// Trạng thái
          ItemRow(
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
                    visible: _vm.accountpayment.state == "draft",
                    child: ListTile(
                      onTap: () async {
                        Navigator.pop(context);
                        final dialogResult = await showQuestion(
                            context: context,
                            title: S.current.confirm,
                            message: S.current
                                .paymentReceipt_doYouWantToAddToTheBook);
                        if (dialogResult == DialogResultType.YES) {
                          _vm.confirmAccountPayment(widget.id);
                        } else {
                          Navigator.pop(context);
                        }
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
                    visible: _vm.accountpayment.state != "draft",
                    child: ListTile(
                      onTap: () async {
                        Navigator.pop(context);
                        final dialogResult = await showQuestion(
                            context: context,
                            title: S.current.cancel,
                            message:
                                S.current.paymentReceipt_doYouWantToCancel);
                        if (dialogResult == DialogResultType.YES) {
                          _vm.cancelAccountPayment(widget.id);
                        } else {
                          Navigator.pop(context);
                        }
                      },
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
                              "${S.current.receiptType_doYouWantDeleteReceipt} ${_vm.accountpayment.name ?? ""}");
                      if (dialogResult == DialogResultType.YES) {
                        if (_vm.accountpayment.state == "posted") {
                          _vm.showError(S.current.receipts_cannotDeleteReceipt);
                        } else {
                          final bool result =
                              await _vm.deleteAccountPayment(widget.id);
                          if (result) {
                            Navigator.pop(context, _vm.accountpayment);
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

class ItemRow extends StatelessWidget {
  const ItemRow({this.content, this.contentTextStyle, this.titleString});
  final TextStyle contentTextStyle;
  final String titleString;
  final Widget content;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InfoRow(
          contentTextStyle: contentTextStyle,
          titleString: titleString,
          content: content),
    );
  }
}