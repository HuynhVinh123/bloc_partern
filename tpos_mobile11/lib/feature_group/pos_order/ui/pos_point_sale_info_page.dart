import 'package:flutter/material.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/pos_order/ui/pos_point_sale_edit_page.dart';
import 'package:tpos_mobile/feature_group/pos_order/viewmodels/pos_point_sale_info_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';

import 'package:tpos_mobile/widgets/info_row.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class PosPointSaleInfoPage extends StatefulWidget {
  const PosPointSaleInfoPage(this.id);
  final int id;
  @override
  _PosPointSaleInfoPageState createState() => _PosPointSaleInfoPageState();
}

class _PosPointSaleInfoPageState extends State<PosPointSaleInfoPage> {
  final _vm = locator<PosPointSaleInfoViewModel>();
  TextStyle detailFontStyle;
  TextStyle titleFontStyle;

  @override
  void initState() {
    super.initState();
    _vm.getInfoPointSale(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    titleFontStyle = const TextStyle(color: Colors.green);
    detailFontStyle = const TextStyle(color: Colors.green);
    return ViewBase<PosPointSaleInfoViewModel>(
        model: _vm,
        builder: (context, model, _) {
          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              title: Text(S.current.menu_posOfSale),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PosPointSaleEditPage(
                                pointSale: _vm.pointSale,
                              )),
                    );
                  },
                )
              ],
            ),
            body: _buildInfoPointSale(),
          );
        });
  }

  Widget _buildInfoPointSale() {
    const Widget spaceHeight = SizedBox(
      height: 10,
    );
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 6,
            ),
            Text(
              "${S.current.name}: ${_vm.pointSale.name ?? ""}",
              style: titleFontStyle.copyWith(
                  fontSize: 18, fontWeight: FontWeight.w700),
            ),
            spaceHeight,
            _buildInfoGeneral(),
            spaceHeight,
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(3)),
              child: ExpansionTile(
                backgroundColor: Colors.white,
                title: Text(
                  S.current.posOfSale_feature,
                  style: const TextStyle(color: Colors.black),
                ),
                initiallyExpanded: true,
                children: <Widget>[
                  _buildInfoFunction(),
                ],
              ),
            ),
            spaceHeight,
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(3)),
              child: ExpansionTile(
                backgroundColor: Colors.white,
                title: Text(
                  "${S.current.posOfSale_discount} & ${S.current.posOfSale_tax.toLowerCase()} VAT",
                  style: const TextStyle(color: Colors.black),
                ),
                initiallyExpanded: true,
                children: <Widget>[
                  _buildTax(),
                ],
              ),
            ),
            spaceHeight,
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(3)),
              child: ExpansionTile(
                backgroundColor: Colors.white,

                /// Hóa đơn và phiếu thu
                title: Text(
                  S.current.posOfSale_invoiceAndReceipts,
                  style: const TextStyle(color: Colors.black),
                ),
                initiallyExpanded: true,
                children: <Widget>[
                  _buildInvoice(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoGeneral() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey[400],
                offset: const Offset(0, 2),
                blurRadius: 2)
          ]),
      child: Column(
        children: <Widget>[
          /// Loại hoạt động:
          InfoRow(
            contentTextStyle: titleFontStyle,
            titleString: "${S.current.posOfSale_activeType}: ",
            content: Text(
                _vm.pointSale?.pickingType == null
                    ? ""
                    : _vm.pointSale.pickingType.nameGet ?? "",
                textAlign: TextAlign.right,
                style: detailFontStyle),
          ),
          //dividerMin,
          InfoRow(
            contentTextStyle: titleFontStyle,

            /// Địa điểm kho
            titleString: "${S.current.posOfSale_stockLocation}:",
            content: Text(
                _vm.pointSale?.stockLocation == null
                    ? ""
                    : _vm.pointSale.stockLocation.nameGet ?? "",
                textAlign: TextAlign.right,
                style: detailFontStyle),
          ),
          //dividerMin,
          InfoRow(
            contentTextStyle: titleFontStyle,

            /// Bảng giá
            titleString: "${S.current.posOfSale_priceList}:",
            content: Text(
                _vm.pointSale?.priceList == null
                    ? ""
                    : _vm.pointSale.priceList.name ?? "",
                textAlign: TextAlign.right,
                style: detailFontStyle),
          ),
          //dividerMin,
          InfoRow(
            contentTextStyle: titleFontStyle,
            titleString: "${S.current.posOfSale_active}:",
            content: Text(
                _vm.pointSale?.active == null
                    ? S.current.no
                    : _vm.pointSale.active ? S.current.yes : S.current.no,
                textAlign: TextAlign.right,
                style: detailFontStyle),
          ),
          //  dividerMin,
          InfoRow(
            contentTextStyle: titleFontStyle,

            /// Phương thức thanh toán khả dụng
            titleString: "${S.current.posSession_paymentType}:",
            content: Text(_vm.showNamePayment(),
                textAlign: TextAlign.right, style: detailFontStyle),
          ),
          InfoRow(
            contentTextStyle: titleFontStyle,

            /// Cấu hình máy in bill
            titleString: "${S.current.posOfSale_printerConfiguration}:",
            content: Text("Bill ${_vm.pointSale.printer}",
                textAlign: TextAlign.right, style: detailFontStyle),
          )
        ],
      ),
    );
  }

  Widget _buildInfoFunction() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey[400],
                offset: const Offset(0, 3),
                blurRadius: 3)
          ]),
      child: Column(
        children: <Widget>[
          _buildInfoRow(
            contentTextStyle: titleFontStyle,

            /// Tự động in
            titleString: "${S.current.posOfSale_autoPrint}:",
            content: Text(
                _vm.pointSale?.ifacePrintAuto == null
                    ? S.current.no
                    : _vm.pointSale.ifacePrintAuto
                        ? S.current.yes
                        : S.current.no,
                textAlign: TextAlign.right,
                style: detailFontStyle),
          ),
          //dividerMin,
          _buildInfoRow(
            contentTextStyle: titleFontStyle,

            /// Tự động chyển sang đơn hàng kế tiếp
            titleString: "${S.current.posOfSale_autoMoveToTheNextOrder}:",
            content: Text(
                _vm.pointSale?.ifacePrintSkipScreen == null
                    ? S.current.no
                    : _vm.pointSale.ifacePrintSkipScreen
                        ? S.current.yes
                        : S.current.no,
                textAlign: TextAlign.right,
                style: detailFontStyle),
          ),
          //dividerMin,
          _buildInfoRow(
            contentTextStyle: titleFontStyle,

            /// Tự động điền số tiền thanh toán đúng với số tiền còn lại
            titleString: "${S.current.posOfSale_autoFillIn}:",
            content: Text(
                _vm.pointSale?.ifacePaymentAuto == null
                    ? S.current.no
                    : _vm.pointSale.ifacePaymentAuto
                        ? S.current.yes
                        : S.current.no,
                textAlign: TextAlign.right,
                style: detailFontStyle),
          ),
          //dividerMin,
          _buildInfoRow(
            contentTextStyle: titleFontStyle,

            /// Ghi chú trên chi tiết bán hàng
            titleString: "${S.current.posOfSale_allowNotes}:",
            content: Text(
                _vm.pointSale?.ifaceOrderlineNotes == null
                    ? S.current.no
                    : _vm.pointSale.ifaceOrderlineNotes
                        ? S.current.yes
                        : S.current.no,
                textAlign: TextAlign.right,
                style: detailFontStyle),
          ),
          //  dividerMin,
          _buildInfoRow(
            contentTextStyle: titleFontStyle,

            /// Giúp tải nhanh danh sách sản phẩm khi mở một phiên bán hàng
            titleString: "${S.current.posOfSale_quickDownload}:",
            content: Text(
                _vm.pointSale?.useCache == null
                    ? S.current.yes
                    : _vm.pointSale.useCache ? S.current.no : S.current.yes,
                textAlign: TextAlign.right,
                style: detailFontStyle),
          ),
        ],
      ),
    );
  }

  Widget _buildTax() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey[400],
                offset: const Offset(0, 3),
                blurRadius: 3)
          ]),
      child: Column(
        children: <Widget>[
          _buildInfoRow(
            contentTextStyle: titleFontStyle,

            /// Cho phép chiết khấu đơn hàng trên toàn bộ đơn hàng
            titleString: "${S.current.posOfSale_allowDiscount}: ",
            content: Text(
                _vm.pointSale?.ifaceDiscount == null
                    ? S.current.no
                    : _vm.pointSale.ifaceDiscount
                        ? S.current.yes
                        : S.current.no,
                textAlign: TextAlign.right,
                style: detailFontStyle),
          ),
          Visibility(
            visible: _vm.pointSale.ifaceDiscount ?? false,
            child: _buildInfoRow(
              contentTextStyle: titleFontStyle,

              /// Chiết khấu mặc định
              titleString: "${S.current.posOfSale_discountDefault}",
              content: Text(
                  "${vietnameseCurrencyFormat(_vm.pointSale.discountPc)}%",
                  textAlign: TextAlign.right,
                  style: detailFontStyle),
            ),
          ),
          //dividerMin,
          _buildInfoRow(
            contentTextStyle: titleFontStyle,

            ///Cho phép giảm tiền trên toàn bộ đơn hàng
            titleString: "${S.current.posOfSale_allowDiscountFixed}:",
            content: Text(
                _vm.pointSale?.ifaceDiscountFixed == null
                    ? S.current.no
                    : _vm.pointSale.ifaceDiscountFixed
                        ? S.current.yes
                        : S.current.no,
                textAlign: TextAlign.right,
                style: detailFontStyle),
          ),
          //dividerMin,
          _buildInfoRow(
            contentTextStyle: titleFontStyle,

            /// Áp dụng thuế trên toàn bộ đơn hàng
            titleString: "${S.current.posOfSale_applyToTax}:",
            content: Text(
                _vm.pointSale?.ifaceTax == null
                    ? S.current.no
                    : _vm.pointSale.ifaceTax
                        ? "${S.current.yes} (${_vm.pointSale.tax?.name ?? ""})"
                        : S.current.no,
                textAlign: TextAlign.right,
                style: detailFontStyle),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoice() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey[400],
                offset: const Offset(0, 3),
                blurRadius: 3)
          ]),
      child: Column(
        children: <Widget>[
          _buildInfoRow(
            contentTextStyle: titleFontStyle,

            /// Thêm thông điệp vào đầu chân trang
            titleString: "${S.current.posOfSale_addMessages}: ",
            content: Text(
                _vm.pointSale?.isHeaderOrFooter == null
                    ? S.current.no
                    : _vm.pointSale.isHeaderOrFooter
                        ? S.current.yes
                        : S.current.no,
                textAlign: TextAlign.right,
                style: detailFontStyle),
          ),
          //dividerMin,
          _buildInfoRow(
            contentTextStyle: titleFontStyle,
            titleString: "${S.current.posOfSale_showLogo}:",
            content: Text(
                _vm.pointSale?.ifaceLogo == null
                    ? S.current.no
                    : _vm.pointSale.ifaceLogo ? S.current.yes : S.current.no,
                textAlign: TextAlign.right,
                style: detailFontStyle),
          ),
          //dividerMin,
          _buildInfoRow(
            contentTextStyle: titleFontStyle,

            /// Kiểm soát tiền mặt
            titleString: "${S.current.posOfSale_cashControl}:",
            content: Text(
                _vm.pointSale?.cashControl == null
                    ? S.current.no
                    : _vm.pointSale.cashControl ? S.current.yes : S.current.no,
                textAlign: TextAlign.right,
                style: detailFontStyle),
          )
        ],
      ),
    );
  }

  Widget _buildInfoRow(
      {final TextStyle contentTextStyle, String titleString, Widget content}) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text(
              titleString ?? "",
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
          content
        ],
      ),
    );
  }
}
