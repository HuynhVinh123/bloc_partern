import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/account_bank.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/accountbank_line.dart';
import 'package:tpos_mobile/feature_group/pos_order/viewmodels/pos_close_point_sale_list_invoice_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/widgets/info_row.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class PosClosePointSaleListInvoicePage extends StatefulWidget {
  const PosClosePointSaleListInvoicePage({this.accountBank});
  final AccountBank accountBank;
  @override
  _PosClosePointSaleListInvoicePageState createState() =>
      _PosClosePointSaleListInvoicePageState();
}

class _PosClosePointSaleListInvoicePageState
    extends State<PosClosePointSaleListInvoicePage> {
  final _vm = locator<PosClosePointSaleListInvoiceViewModel>();
  TextStyle detailFontStyle;
  TextStyle titleFontStyle;

  @override
  Widget build(BuildContext context) {
    titleFontStyle = const TextStyle(color: Colors.green);
    detailFontStyle = const TextStyle(color: Colors.green);
    return ViewBase<PosClosePointSaleListInvoiceViewModel>(
        model: _vm,
        builder: (context, model, _) {
          return Scaffold(
              appBar: AppBar(
                /// Chi tiết thanh toán
                title: Text(S.current.posSession_paymentDetail),
              ),
              body: _buildInfoPointSale());
        });
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
                  S.current.posSession_invoices.toUpperCase(),
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
                        return item(_vm.accountBankLines[index]);
                      },
                      separatorBuilder: (ctx, index) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Divider(
                            height: 1,
                            color: Color(0xFFEBEDEF),
                          ),
                        );
                      },
                      itemCount: _vm.accountBankLines.length,
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget item(AccountBankLine item) {
    const Widget spaceHeight = SizedBox(
      height: 4,
    );
    return Container(
      child: Column(
        children: <Widget>[
          ListTile(
            onTap: () {},
            title: Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      item.name ?? "",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            subtitle: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          const Icon(
                            Icons.calendar_today,
                            size: 15,
                            color: const Color(0xFF9CA2AA),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy')
                                .format(DateTime.parse(item.date).toLocal()),
                            style: const TextStyle(color: Color(0xFF9CA2AA)),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          SizedBox(
                            width: 1,
                            height: 8,
                            child: Container(color: const Color(0xFF9CA2AA)),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          const Icon(
                            Icons.person,
                            size: 16,
                            color: Color(0xFF9CA2AA),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Expanded(
                            child: Text(
                              item.partnerName ?? "",
                              style: const TextStyle(color: Color(0xFF9CA2AA)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      vietnameseCurrencyFormat(item.amount),
                      style: const TextStyle(color: Color(0xFF9CA2AA)),
                    ),
                  ],
                ),
                spaceHeight,
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          )
        ],
      ),
    );
  }

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
              S.current.info.toUpperCase(),
              style: const TextStyle(
                  color: Color(0xFF28A745),
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),
          ),
          InfoRow(
            contentTextStyle: titleFontStyle,

            /// Nhật ký
            title: Text(
              "${S.current.posSession_paymentType}: ",
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            content: Text(_vm.accountBank?.journal?.name ?? "",
                style: detailFontStyle.copyWith(
                    color: const Color(0xFF484D54), fontSize: 16)),
          ),
          InfoRow(
            contentTextStyle: titleFontStyle,
            title: Text(
              "${S.current.posSession_date}: ",
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            content: Text(
                _vm.accountBank?.date == null
                    ? ""
                    : DateFormat('dd/MM/yyyy').format(
                        DateTime.parse(_vm.accountBank?.date).toLocal()),
                style:
                    detailFontStyle.copyWith(color: const Color(0xFF484D54))),
          ),
          //dividerMin,
          InfoRow(
            contentTextStyle: titleFontStyle,
            title: Text(
              "${S.current.posSession_balanceStart}: ",
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
//            titleString: "Điểm bán hàng: ",
            content: Text(
                vietnameseCurrencyFormat(_vm.accountBank?.balanceStart ?? 0),
                style:
                    detailFontStyle.copyWith(color: const Color(0xFF484D54))),
          ),
          //dividerMin,
          InfoRow(
            contentTextStyle: titleFontStyle,
            title: Text(
              "${S.current.posSession_balanceEnd}: ",
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
//            titleString: "Ngày bắt đầu:",
            content: Text(
                vietnameseCurrencyFormat(_vm.accountBank?.balanceEnd ?? 0),
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
    getDataInvoicePointSale();
  }

  Future<void> getDataInvoicePointSale() async {
    await _vm.getAccountBankLines(widget.accountBank.id);
    await _vm.getAccountBank(widget.accountBank.id);
  }
}
