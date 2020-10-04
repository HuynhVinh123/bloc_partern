import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/account_payment/viewmodel/account_payment_info_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/account_payment.dart';
import 'package:tpos_mobile/widgets/info_row.dart';

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
    titleFontStyle = const TextStyle(color: Colors.green);
    detailFontStyle = const TextStyle(color: Colors.green);
    return ViewBase<AccountPaymentInfoViewModel>(
        model: _vm,
        builder: (context, model, sizingInformation) {
          return WillPopScope(
              onWillPop: () async {
                widget.callback(_vm.accountpayment);
                return true;
              },
              child: Scaffold(
                appBar: AppBar(
                  title: const Text("Thông tin phiếu thu"),
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
                    )
                  ],
                ),
                body: SafeArea(child: _buildInfoPointSale()),
              ));
        });
  }

  Widget _buildInfoPointSale() {
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
                    visible: _vm.accountpayment.state != "draft",
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Text(
                        _vm.accountpayment?.name ?? "",
                        style: detailFontStyle.copyWith(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  spaceHeight,
                  _buildInfoGeneral(_vm.accountpayment),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 24,
            right: 24,
            child: Visibility(
              visible: _vm.accountpayment.state == "draft",
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4)),
                child: FlatButton(
                  child: const Text(
                    "Xác nhận",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                  onPressed: () async {
                    final dialogResult = await showQuestion(
                        context: context,
                        title: "Xác nhận xóa",
                        message: "Bạn có muốn thêm phiếu này vào sổ?");
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
              visible: _vm.accountpayment.state != "draft",
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.red[500],
                    borderRadius: BorderRadius.circular(4)),
                child: FlatButton(
                  child: const Text(
                    "Hủy phiếu",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () async {
                    final dialogResult = await showQuestion(
                        context: context,
                        title: "Xác nhận xóa",
                        message: "Bạn có chắc muốn hủy phiếu?");
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
          titleString: "Loại thu:",
          content: Text(item.account?.nameGet ?? "",
              textAlign: TextAlign.right, style: detailFontStyle),
        ),
        dividerMin,
        InfoRow(
          contentTextStyle: titleFontStyle,
          titleString: "Phương thức: ",
          content: Text(item.journalName ?? "",
              textAlign: TextAlign.right, style: detailFontStyle),
        ),
        dividerMin,
        InfoRow(
          contentTextStyle: titleFontStyle,
          titleString: "Số tiền:",
          content: Text(vietnameseCurrencyFormat(item.amount ?? 0),
              textAlign: TextAlign.right, style: detailFontStyle),
        ),
        dividerMin,
        InfoRow(
          contentTextStyle: titleFontStyle,
          titleString: "Nội dung:",
          content: Text(item.communication ?? "",
              textAlign: TextAlign.right, style: detailFontStyle),
        ),
        dividerMin,
        InfoRow(
            contentTextStyle: titleFontStyle,
            titleString: "Ngày:",
            content: Text(
                " ${item.paymentDate != null && item.paymentDate.toString() != "" ? DateFormat("dd-MM-yyyy").format(item.paymentDate.toLocal()) : ""}",
                textAlign: TextAlign.right,
                style: detailFontStyle)),
        dividerMin,
        InfoRow(
          contentTextStyle: titleFontStyle,
          titleString: "Người nộp:",
          content: Text(item.senderReceiver ?? "",
              textAlign: TextAlign.right, style: detailFontStyle),
        ),
        dividerMin,
        InfoRow(
          contentTextStyle: titleFontStyle,
          titleString: "Điện thoại:",
          content: Text(item.phone ?? "",
              textAlign: TextAlign.right, style: detailFontStyle),
        ),
        dividerMin,
        InfoRow(
          contentTextStyle: titleFontStyle,
          titleString: "Địa chỉ:",
          content: Text(item.address ?? "",
              textAlign: TextAlign.right, style: detailFontStyle),
        ),
        dividerMin,
        InfoRow(
          contentTextStyle: titleFontStyle,
          titleString: "Người liên hệ:",
          content: Text(item.contact?.name ?? "",
              textAlign: TextAlign.right, style: detailFontStyle),
        ),
        dividerMin,
        InfoRow(
          contentTextStyle: titleFontStyle,
          titleString: "Trạng thái:",
          content: Text(item.state == "draft" ? "Nháp" : "Đã vào sổ",
              textAlign: TextAlign.right, style: detailFontStyle),
        ),
      ],
    );
  }
}
