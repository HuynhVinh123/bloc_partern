import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';

import 'package:tpos_mobile/feature_group/sale_quotation/uis/sale_quotation_add_edit_page.dart';
import 'package:tpos_mobile/feature_group/sale_quotation/viewmodel/sale_quotation_info_viewmodel.dart';

import 'package:tpos_mobile/locator.dart';

import 'package:tpos_mobile/src/tpos_apis/models/order_line.dart';
import 'package:tpos_mobile/src/tpos_apis/models/sale_quotation.dart';
import 'package:tpos_mobile/src/tpos_apis/models/sale_quotation_detail.dart';
import 'package:tpos_mobile/widgets/info_row.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class SaleQuotationInfoPage extends StatefulWidget {
  const SaleQuotationInfoPage({this.id, this.callback, this.saleQuotation});
  final int id;
  final Function callback;
  final SaleQuotation saleQuotation;
  @override
  _SaleQuotationInfoPageState createState() => _SaleQuotationInfoPageState();
}

class _SaleQuotationInfoPageState extends State<SaleQuotationInfoPage> {
  final _vm = locator<SaleQuotationInfoViewModel>();
  TextStyle detailFontStyle;
  TextStyle titleFontStyle;
  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    await _vm.getInfoSaleQuotation(widget.id);
    await _vm.getOrderLines(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    titleFontStyle = const TextStyle(color: Colors.green);
    detailFontStyle = const TextStyle(color: Colors.green);
    return ViewBase<SaleQuotationInfoViewModel>(
        model: _vm,
        builder: (context, model, sizingInformation) {
          return WillPopScope(
            onWillPop: () async {
              widget.callback(_vm.setInfoSaleQuotation(widget.saleQuotation));
              return true;
            },
            child: Scaffold(
              backgroundColor: Colors.grey[200],
              appBar: AppBar(
                /// Thông tin báo giá
                title: Text(S.current.quotation_quotationInformation),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SaleQuotationAddEditPage(
                                    saleQuotationDetail:
                                        _vm.saleQuotationDetail,
                                    orderLines: _vm.orderLines,
                                  ))).then((value) {
                        if (value != null) {
                          if (value) {
                            initData();
                          }
                        }
                      });
                    },
                  )
                ],
              ),
              body: _buildInfoPointSale(),
            ),
          );
        });
  }

  Widget _buildInfoPointSale() {
    const Widget spaceHeight = SizedBox(
      height: 10,
    );
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            padding: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[400],
                      offset: const Offset(0, 0),
                      blurRadius: 1)
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    _vm.saleQuotationDetail?.name ?? "",
                    style: detailFontStyle.copyWith(
                        fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                spaceHeight,
                _buildInfoGeneral(_vm.saleQuotationDetail),
              ],
            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 12, right: 12, top: 6),
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildInfoSale(_vm.saleQuotationDetail))
        ],
      ),
    );
  }

  Widget _buildInfoGeneral(SaleQuotationDetail item) {
    const dividerMin = Divider(
      height: 2,
    );
    return Column(
      children: <Widget>[
        InfoRow(
          contentTextStyle: titleFontStyle,

          /// Khách hàng
          titleString: "${S.current.partner}:",
          content: Text(item.partner?.displayName ?? "",
              textAlign: TextAlign.right, style: detailFontStyle),
        ),
        dividerMin,
        InfoRow(
          contentTextStyle: titleFontStyle,

          /// Ngày báo giá
          titleString: "${S.current.dateCreated}: ",
          content: Text(
              item.dateQuotation == null
                  ? ""
                  : DateFormat("dd-MM-yyyy HH:mm")
                      .format(DateTime.parse(item.dateQuotation).toLocal()),
              textAlign: TextAlign.right,
              style: detailFontStyle),
        ),
        dividerMin,
        InfoRow(
          contentTextStyle: titleFontStyle,

          /// Ngày hết hạn
          titleString: "${S.current.quotation_endDate}:",
          content: Text(
              item.validityDate == null
                  ? ""
                  : DateFormat("dd-MM-yyyy HH:mm")
                      .format(DateTime.parse(item.validityDate).toLocal()),
              textAlign: TextAlign.right,
              style: detailFontStyle),
        ),
        dividerMin,
        InfoRow(
          contentTextStyle: titleFontStyle,

          /// Điều khoản thanh toán
          titleString: "${S.current.quotation_paymentTerms}:",
          content: Text(item.paymentTerm?.name ?? "",
              textAlign: TextAlign.right, style: detailFontStyle),
        ),
        dividerMin,
        InfoRow(
          contentTextStyle: titleFontStyle,

          /// Ghi chú
          titleString: "${S.current.quotation_note}:",
          content: Text(" ${item.note ?? ""}",
              textAlign: TextAlign.right, style: detailFontStyle),
        ),
      ],
    );
  }

  Widget _buildInfoSale(SaleQuotationDetail item) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[_buildInfoDetailSale(item), _buildListItem()]);
  }

  Widget _buildInfoDetailSale(SaleQuotationDetail item) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 16, bottom: 12),

            /// Thông tin bán hàng
            child: Text(
              S.current.quotation_saleInformation,
              style: detailFontStyle.copyWith(
                  fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          InfoRow(
            contentTextStyle: titleFontStyle,

            ///Người bán
            titleString: S.current.quotation_employee,
            content: Text(' ${item.user?.name ?? ""}',
                textAlign: TextAlign.right, style: detailFontStyle),
          ),
          InfoRow(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 2, bottom: 8),
            contentTextStyle: titleFontStyle,

            /// Trạng thái
            titleString: S.current.quotation_status,
            content: Text(
                ' ${item.state == "draft" ? S.current.quotation_quotation : S.current.quotation_quotationWasSent}',
                textAlign: TextAlign.right,
                style: detailFontStyle),
          ),
          InfoRow(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 2, bottom: 8),
            contentTextStyle: titleFontStyle,

            /// Tiền chiết khấu
            titleString: "${S.current.quotation_amountDiscount}:",
            content: Text(
                " ${vietnameseCurrencyFormat(_vm.moneyDiscount()) ?? "0"}",
                textAlign: TextAlign.right,
                style: detailFontStyle.copyWith(
                    color: Colors.blueAccent,
                    fontSize: 17,
                    fontWeight: FontWeight.w600)),
          ),
          InfoRow(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 2, bottom: 8),
            contentTextStyle: titleFontStyle,

            /// Tổng tiền
            titleString: "${S.current.quotation_amountTotal}:",
            content: Text(
                " ${vietnameseCurrencyFormat(item.amountTotal) ?? "0"}",
                textAlign: TextAlign.right,
                style: detailFontStyle.copyWith(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: ExpansionTile(
        initiallyExpanded: true,
        title: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                /// Danh sách sản phẩm
                text: S.current.quotation_Products,
                style: detailFontStyle.copyWith(
                    fontSize: 18, fontWeight: FontWeight.w600),
              ),
              TextSpan(
                  text: ' (${_vm.orderLines.length} sp)',
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.w600))
            ],
          ),
        ),
        children: <Widget>[
          Column(
            children:
                _vm.orderLines.map((value) => _showItem(item: value)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _showItem({OrderLines item, int index}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[300]))),
        child: Column(
          children: <Widget>[
            ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: Column(
                children: [
                  Row(
                    children: <Widget>[
                      Expanded(
                          flex: 3,
                          child: Text(item.product?.nameGet ?? "",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w600))),
                      Expanded(
                        flex: 2,
                        child: Text(
                            vietnameseCurrencyFormat(item.priceUnit ?? 0),
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                                fontWeight: FontWeight.w600)),
                      )
                    ],
                  ),
                ],
              ),
              subtitle: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                          "${S.current.quotation_quantity}: ${item.productUOMQty.floor()} ${item.productUOM?.name}"),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                  "${S.current.quotation_discount}: ${item.discount} %")))
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text:
                                  ' ${vietnameseCurrencyFormat(item.priceTotal)}',
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17)),
                        ],
                      ),
                    ),
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            )
          ],
        ),
      ),
    );
  }
}
