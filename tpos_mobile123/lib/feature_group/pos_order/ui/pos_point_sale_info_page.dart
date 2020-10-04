import 'package:flutter/material.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/pos_order/ui/pos_point_sale_edit_page.dart';
import 'package:tpos_mobile/feature_group/pos_order/viewmodels/pos_point_sale_info_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';

import 'package:tpos_mobile/widgets/info_row.dart';

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
    titleFontStyle = TextStyle(color: Colors.green);
    detailFontStyle = TextStyle(color: Colors.green);
    return ViewBase<PosPointSaleInfoViewModel>(
        model: _vm,
        builder: (context, model, _) {
          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              title: const Text("Điểm bán hàng"),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
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
              "Tên điểm bán hàng: ${_vm.pointSale.name ?? ""}",
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
                  "Tính năng",
                  style: TextStyle(color: Colors.black),
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
                  "Chiết khấu & thuế VAT",
                  style: TextStyle(color: Colors.black),
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
                title: Text(
                  "Hóa đơn và phiếu thu",
                  style: TextStyle(color: Colors.black),
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
          InfoRow(
            contentTextStyle: titleFontStyle,
            titleString: "Loại hoạt động: ",
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
            titleString: "Địa điểm kho:",
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
            titleString: "Bảng giá:",
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
            titleString: "Hiệu lực:",
            content: Text(
                _vm.pointSale?.active == null
                    ? "Không"
                    : _vm.pointSale.active ? "Có" : "Không",
                textAlign: TextAlign.right,
                style: detailFontStyle),
          ),
          //  dividerMin,
          InfoRow(
            contentTextStyle: titleFontStyle,
            titleString: "Phương thức thanh toán khả dụng:",
            content: Text(_vm.showNamePayment(),
                textAlign: TextAlign.right, style: detailFontStyle),
          ),
          InfoRow(
            contentTextStyle: titleFontStyle,
            titleString: "Cấu hình máy in bill:",
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
            titleString: "Tự động in:",
            content: Text(
                _vm.pointSale?.ifacePrintAuto == null
                    ? "Không"
                    : _vm.pointSale.ifacePrintAuto ? "Có" : "Không",
                textAlign: TextAlign.right,
                style: detailFontStyle),
          ),
          //dividerMin,
          _buildInfoRow(
            contentTextStyle: titleFontStyle,
            titleString: "Tự động chyển sang đơn hàng kế tiếp:",
            content: Text(
                _vm.pointSale?.ifacePrintSkipScreen == null
                    ? "Không"
                    : _vm.pointSale.ifacePrintSkipScreen ? "Có" : "Không",
                textAlign: TextAlign.right,
                style: detailFontStyle),
          ),
          //dividerMin,
          _buildInfoRow(
            contentTextStyle: titleFontStyle,
            titleString:
                "Tự động điền số tiền thanh toán đúng với số tiền còn lại:",
            content: Text(
                _vm.pointSale?.ifacePaymentAuto == null
                    ? "Không"
                    : _vm.pointSale.ifacePaymentAuto ? "Có" : "Không",
                textAlign: TextAlign.right,
                style: detailFontStyle),
          ),
          //dividerMin,
          _buildInfoRow(
            contentTextStyle: titleFontStyle,
            titleString: "Ghi chú trên chi tiết bán hàng:",
            content: Text(
                _vm.pointSale?.ifaceOrderlineNotes == null
                    ? "Không"
                    : _vm.pointSale.ifaceOrderlineNotes ? "Có" : "Không",
                textAlign: TextAlign.right,
                style: detailFontStyle),
          ),
          //  dividerMin,
          _buildInfoRow(
            contentTextStyle: titleFontStyle,
            titleString:
                "Giúp tải nhanh danh sách sản phẩm khi mở một phiên bán hàng:",
            content: Text(
                _vm.pointSale?.useCache == null
                    ? "Không"
                    : _vm.pointSale.useCache ? "Có" : "Không",
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
            titleString: "Cho phép chiết khấu đơn hàng trên toàn bộ đơn hàng: ",
            content: Text(
                _vm.pointSale?.ifaceDiscount == null
                    ? "Không"
                    : _vm.pointSale.ifaceDiscount ? "Có" : "Không",
                textAlign: TextAlign.right,
                style: detailFontStyle),
          ),
          Visibility(
            visible: _vm.pointSale.ifaceDiscount ?? false,
            child: _buildInfoRow(
              contentTextStyle: titleFontStyle,
              titleString: "Chiết khấu mặc định ",
              content: Text(
                  "${vietnameseCurrencyFormat(_vm.pointSale.discountPc)}%",
                  textAlign: TextAlign.right,
                  style: detailFontStyle),
            ),
          ),
          //dividerMin,
          _buildInfoRow(
            contentTextStyle: titleFontStyle,
            titleString: "Cho phép giảm tiền trên toàn bộ đơn hàng:",
            content: Text(
                _vm.pointSale?.ifaceDiscountFixed == null
                    ? "Không"
                    : _vm.pointSale.ifaceDiscountFixed ? "Có" : "Không",
                textAlign: TextAlign.right,
                style: detailFontStyle),
          ),
          //dividerMin,
          _buildInfoRow(
            contentTextStyle: titleFontStyle,
            titleString: "Áp dụng thuế trên toàn bộ đơn hàng:",
            content: Text(
                _vm.pointSale?.ifaceTax == null
                    ? "Không"
                    : _vm.pointSale.ifaceTax
                        ? "Có (${_vm.pointSale.tax?.name ?? ""})"
                        : "Không",
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
            titleString: "Thêm thông điệp vào đầu chân trang: ",
            content: Text(
                _vm.pointSale?.isHeaderOrFooter == null
                    ? "Không"
                    : _vm.pointSale.isHeaderOrFooter ? "Có" : "Không",
                textAlign: TextAlign.right,
                style: detailFontStyle),
          ),
          //dividerMin,
          _buildInfoRow(
            contentTextStyle: titleFontStyle,
            titleString: "Hiện Logo:",
            content: Text(
                _vm.pointSale?.ifaceLogo == null
                    ? "Không"
                    : _vm.pointSale.ifaceLogo ? "Có" : "Không",
                textAlign: TextAlign.right,
                style: detailFontStyle),
          ),
          //dividerMin,
          _buildInfoRow(
            contentTextStyle: titleFontStyle,
            titleString: "Kiểm soát tiền mặt:",
            content: Text(
                _vm.pointSale?.cashControl == null
                    ? "Không"
                    : _vm.pointSale.cashControl ? "Có" : "Không",
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
