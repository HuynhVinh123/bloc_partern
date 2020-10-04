import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/account_bank.dart';
import 'package:tpos_mobile/feature_group/pos_order/ui/pos_cart_page.dart';
import 'package:tpos_mobile/feature_group/pos_order/ui/pos_close_point_sale_list_invoice_page.dart';
import 'package:tpos_mobile/feature_group/pos_order/viewmodels/dialog_update_info_viewmodel.dart';
import 'package:tpos_mobile/feature_group/pos_order/viewmodels/pos_close_point_sale_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';

import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/widgets/custom_widget.dart';

class PosClosePointSalePage extends StatefulWidget {
  const PosClosePointSalePage(
      {this.id, this.pointSaleId, this.companyId, this.userId});
  final int id; // id session
  final int pointSaleId; // configId
  final int companyId;
  final String userId;
  @override
  _PosClosePointSalePageState createState() => _PosClosePointSalePageState();
}

class _PosClosePointSalePageState extends State<PosClosePointSalePage> {
  final _vm = locator<PosClosePointSaleViewModel>();
  final _vmDialog = locator<DialogUpdateInfoViewModel>();

  TextStyle detailFontStyle;
  TextStyle titleFontStyle;

  @override
  Widget build(BuildContext context) {
    titleFontStyle = TextStyle(color: Colors.green);
    detailFontStyle = TextStyle(color: Colors.green);

    return ViewBase<PosClosePointSaleViewModel>(
        model: _vm,
        builder: (context, model, _) {
          return Scaffold(
            backgroundColor: const Color(0xFFEBEDEF),
            appBar: AppBar(
              title: const Text("Phiên bán hàng"),
            ),
            body: SafeArea(
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 60),
                    child: Container(
//              height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: _buildInfoPointSale(),
                    ),
                  ),
                  Positioned(
                    bottom: 6,
                    child: _buildButtonClosePointSale(),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget _buildButtonClosePointSale() {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 2),
                        blurRadius: 2,
                        color: Colors.grey[400])
                  ],
                  color: const Color(0xFF89919A),
                  borderRadius: BorderRadius.circular(6)),
              child: RaisedButton(
                color: const Color(0xFF89919A),
                onPressed: () async {
                  final dialogResult = await showQuestion(
                      context: context,
                      title: "Xác nhận đóng",
                      message: "Bạn có muốn đóng phiên bán hàng");

                  if (dialogResult == DialogResultType.YES) {
                    await _vm.handleClosePosSession(context, widget.id);
                  }
                },
                child: Center(
                  child: Text("Kết thúc phiên",
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 18,
          ),
          Expanded(
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 2),
                        blurRadius: 2,
                        color: Colors.grey[400])
                  ],
                  color: Colors.green[400],
                  borderRadius: BorderRadius.circular(6)),
              child: RaisedButton(
                onPressed: () async {
                  if (_vmDialog.isFirstAccess) {
                    _vmDialog.isNoQuestion = true;
                  }
                  if (!_vmDialog.isNoQuestion) {
                    _vm.showNotifyUpdateData(context, _vmDialog,
                        pointSaleId: widget.pointSaleId,
                        companyId: widget.companyId,
                        userId: widget.userId,
                        id: widget.id);
                  } else {
                    if (_vmDialog.isFirstAccess) {
                      _vmDialog.isFirstAccess = false;
                      _vmDialog.isNoQuestion = false;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PosCartPage(
                              widget.pointSaleId,
                              widget.companyId,
                              widget.userId,
                              _vmDialog.isLoadingData)),
                    ).then((value) async {
                      await _vm.getAccountBank(widget.id);
                      await _vm.getPosSessionById(widget.id);
                    });
                  }
                },
                child: Center(
                  child: Text("Tiếp tục",
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPointSale() {
    const Widget spaceHeight = SizedBox(
      height: 10,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildInfoGeneral(),
              spaceHeight,
              SizedBox(
                height: 12,
                child: Container(
                  color: const Color(0xFFEBEDEF),
                ),
              ),
              spaceHeight,
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  "PHƯƠNG THỨC THANH TOÁN",
                  style: titleFontStyle.copyWith(
                      fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ),
              spaceHeight,
              Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(3)),
                  child: Container(
                    child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (ctx, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: _showItemAccountBank(_vm.accountBanks[index]),
                        );
                      },
                      separatorBuilder: (ctx, index) {
                        return Divider(
                          height: 4,
                          color: Colors.white,
                        );
                      },
                      itemCount: _vm.accountBanks.length,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showItemAccountBank(AccountBank item) {
    final Container space = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      color: Colors.white,
      child: Center(
        child: Container(
          color: const Color(0xFFF0F1F3),
          height: 1,
        ),
      ),
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F1F3),
        borderRadius: BorderRadius.circular(3),
      ),
      child: ExpansionTile(
//        backgroundColor: Color(0xFFEBEDEF),
        title: Container(
          child: Text(
            item.journal?.name ?? "",
            style: TextStyle(color: Colors.black),
          ),
        ),
        initiallyExpanded: true,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            color: Colors.white,
          ),
          InfoRow(
            contentTextStyle: titleFontStyle,
            title: Text(
              "Số dư bắt đầu:",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            content: Text(vietnameseCurrencyFormat(item.balanceStart),
                textAlign: TextAlign.right,
                style: detailFontStyle.copyWith(
                    color: const Color(0xFF484D54),
                    fontWeight: FontWeight.w700)),
          ),
          space,
          InfoRow(
            contentTextStyle: titleFontStyle,
            title: const Text(
              "Tổng giao dịch:",
            ),
            content: Text(vietnameseCurrencyFormat(item.totalEntryEncoding),
                textAlign: TextAlign.right,
                style:
                    detailFontStyle.copyWith(color: const Color(0xFF484D54))),
          ),
          space,
          InfoRow(
            contentTextStyle: titleFontStyle,
            title: Text(
              "Số dư kết thúc:",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            content: Text(vietnameseCurrencyFormat(item.balanceEnd),
                textAlign: TextAlign.right,
                style:
                    detailFontStyle.copyWith(color: const Color(0xFF484D54))),
          ),
          space,
          InfoRow(
            contentTextStyle: titleFontStyle,
            title: Text(
              "Chênh lệch:",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            content: Text(vietnameseCurrencyFormat(item.difference),
                textAlign: TextAlign.right,
                style: detailFontStyle.copyWith(
                    color: const Color(0xFF484D54),
                    fontWeight: FontWeight.w700)),
          ),
          InfoRow(
            content: Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PosClosePointSaleListInvoicePage(
                              accountBank: item,
                            )),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFFF0F1F3),
                      borderRadius: BorderRadius.circular(3)),
                  width: 75,
                  height: 30,
                  child: const Center(
                    child: Text("Chi tiết"),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

//  Widget _showItem(AccountBank item) {
//    const Widget spaceHeight = SizedBox(
//      height: 4,
//    );
//    return Container(
//      decoration: BoxDecoration(
//        border: Border(
//          left: BorderSide(
//            color: Colors.green.withOpacity(0.5),
//            width: 5,
//          ),
//        ),
//      ),
//      child: Container(
//        decoration: BoxDecoration(
//            borderRadius: const BorderRadius.all(Radius.circular(3.0)),
//            color: Colors.white,
//            boxShadow: [
//              BoxShadow(
//                  color: Colors.grey[300],
//                  offset: const Offset(0, 2),
//                  blurRadius: 3)
//            ]),
//        child: Column(
//          children: <Widget>[
//            ListTile(
//              onTap: () {},
//              title: Padding(
//                padding: const EdgeInsets.only(top: 0, bottom: 10),
//                child: Row(
//                  children: <Widget>[
//                    Expanded(
//                      child: Text(
//                        "${item.name ?? ""}",
//                        textAlign: TextAlign.start,
//                        style: TextStyle(fontWeight: FontWeight.bold),
//                      ),
//                    ),
//                    Expanded(
//                      child: Text("${item.journal?.name ?? ""}",
//                          textAlign: TextAlign.end,
//                          style: TextStyle(
//                            fontWeight: FontWeight.bold,
//                          )),
//                    ),
//                  ],
//                ),
//              ),
//              subtitle: Column(
//                children: <Widget>[
//                  Text(
//                    "Số dư bắt đầu: ${vietnameseCurrencyFormat(item.balanceStart)}",
//                    style: TextStyle(color: Colors.grey[800]),
//                  ),
//                  spaceHeight,
//                  Text(
//                    "Tổng giao dịch: ${vietnameseCurrencyFormat(item.totalEntryEncoding)}",
//                    textAlign: TextAlign.left,
//                    style: TextStyle(color: Colors.grey[800]),
//                  ),
//                  spaceHeight,
//                  Text(
//                    "Số dư kết thúc: ${vietnameseCurrencyFormat(item.balanceEnd)}",
//                    textAlign: TextAlign.left,
//                    style: TextStyle(color: Colors.grey[800]),
//                  ),
//                  Divider(
//                    color: Colors.grey.shade100,
//                  ),
//                  Row(
//                    children: <Widget>[
//                      Text(
//                        "Chênh lệch: ${vietnameseCurrencyFormat(item.difference)}",
//                        textAlign: TextAlign.left,
//                        style: TextStyle(color: Colors.grey[800]),
//                      ),
//                      Expanded(
//                        child: Text(
//                          "Trạng thái: ${item.showState ?? ""}",
//                          textAlign: TextAlign.right,
//                          style: TextStyle(color: Colors.grey[700]),
//                        ),
//                      ),
//                    ],
//                  ),
//                  const SizedBox(
//                    height: 6,
//                  )
//                ],
//                crossAxisAlignment: CrossAxisAlignment.start,
//              ),
//            )
//          ],
//        ),
//      ),
//    );
//  }

  Widget _buildInfoGeneral() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
//          boxShadow: [
//            BoxShadow(
//                color: Colors.grey[400], offset: Offset(0, 1), blurRadius: 1)
//          ]
      ),
      child: Column(
        children: <Widget>[
          InfoRow(
            title: Text(
              "TỔNG QUAN",
              style: TextStyle(
                  color: const Color(0xFF28A745),
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),
          ),
          InfoRow(
            contentTextStyle: titleFontStyle,
            title: Text(
              "Phiên bán hàng: ",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            content: Text(_vm.session?.name ?? "",
                style: detailFontStyle.copyWith(
                    color: const Color(0xFF484D54), fontSize: 16)),
          ),
          InfoRow(
            contentTextStyle: titleFontStyle,
            title: Text(
              "Chịu trách nhiệm: ",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            content: Text(_vm.session?.user?.name ?? "",
                style:
                    detailFontStyle.copyWith(color: const Color(0xFF484D54))),
          ),
          //dividerMin,
          InfoRow(
            contentTextStyle: titleFontStyle,
            title: Text(
              "Điểm bán hàng: ",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
//            titleString: "Điểm bán hàng: ",
            content: Text(_vm.session?.config?.nameGet ?? "",
                style:
                    detailFontStyle.copyWith(color: const Color(0xFF484D54))),
          ),
          //dividerMin,
          InfoRow(
            contentTextStyle: titleFontStyle,
            title: Text(
              "Ngày bắt đầu: ",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
//            titleString: "Ngày bắt đầu:",
            content: Text(
                _vm.session?.startAt == null
                    ? ""
                    : DateFormat('dd/MM/yyyy HH:mm')
                        .format(DateTime.parse(_vm.session.startAt).toLocal()),
                style:
                    detailFontStyle.copyWith(color: const Color(0xFF484D54))),
          ),
          //dividerMin,
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _vm.getAccountBank(widget.id);
    _vm.getPosSessionById(widget.id);
  }
}
