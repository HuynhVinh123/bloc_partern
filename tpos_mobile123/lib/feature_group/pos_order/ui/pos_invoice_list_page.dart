import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/template_ui/empty_data_widget.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/invoice.dart';
import 'package:tpos_mobile/feature_group/pos_order/ui/pos_order_info_page.dart';
import 'package:tpos_mobile/feature_group/pos_order/viewmodels/pos_cart_viewmodel.dart';
import 'package:tpos_mobile/feature_group/pos_order/viewmodels/pos_invoice_list_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';

import 'package:tpos_mobile/services/dialog_service.dart';

class PosInvoiceListPage extends StatefulWidget {
  const PosInvoiceListPage({this.id, this.positon, this.viewModel});
  final int id;
  final String positon;
  final PosCartViewModel viewModel;
  @override
  _PosInvoiceListPageState createState() => _PosInvoiceListPageState();
}

class _PosInvoiceListPageState extends State<PosInvoiceListPage> {
  final _vm = locator<PosInvoiceListViewModel>();

  @override
  void initState() {
    super.initState();
    _vm.getInvoices(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return ViewBase<PosInvoiceListViewModel>(
        model: _vm,
        builder: (context, model, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Danh sách hóa đơn"),
            ),
            body: _vm.invoices.isEmpty
                ? EmptyData(
                    onPressed: () {
                      _vm.getInvoices(widget.id);
                    },
                  )
                : RefreshIndicator(
                    onRefresh: () {
                      return _vm.getInvoices(widget.id);
                    },
                    child: ListView.builder(
                        itemCount: _vm.invoices.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 8, top: 6),
                            child: _showItem(_vm.invoices[index], index),
                          );
                        }),
                  ),
          );
        });
  }

  Widget _showItem(Invoice item, int index) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Colors.green.withOpacity(0.5),
            width: 5,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(3.0)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[300],
                  offset: const Offset(0, 2),
                  blurRadius: 3)
            ]),
        child: Column(
          children: <Widget>[
            ListTile(
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PosOrderInfoPage(
                            posOrderId: item.id,
                          )),
                );
              },
              title: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: AutoSizeText(
                        item.pOSReference ?? "",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                        maxLines: 1,
                      ),
                    ),
                    Text(vietnameseCurrencyFormat(item.amountTotal ?? 0) ?? "",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green)),
                    _childPopup(item),
//                    InkWell(
//                      onTap: () async {
//                        await _vm.deleteProductPosition(widget.positon);
//                        await _vm.getDetailInvoice(
//                            item.id, widget.positon, false);
//                        await _vm.insertProductForCart(widget.positon);
//                      },
//                      child: Icon(
//                        Icons.content_copy,
//                        color: Colors.grey[700],
//                      ),
//                    ),
//                    SizedBox(
//                      width: 4,
//                    ),
//                    SizedBox(
//                      width: 1,
//                      height: 12,
//                      child: Container(
//                        color: Colors.grey[600],
//                      ),
//                    ),
//                    SizedBox(
//                      width: 4,
//                    ),
//                    InkWell(
//                      onTap: () {
//                        _vm.getDetailInvoice(item.id, widget.positon, true);
//                      },
//                      child: Icon(
//                        Icons.print,
//                        color: Colors.grey[700],
//                      ),
//                    )
                  ],
                ),
              ),
              subtitle: Column(
                children: <Widget>[
                  Text(
                    "Khách hàng: ${item.partnerName ?? ""}",
                    style: TextStyle(color: Colors.black),
                  ),
                  Divider(
                    color: Colors.grey.shade100,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "Người bán: ${item.userName ?? ""}",
                        textAlign: TextAlign.left,
                      ),
                      Expanded(
                        child: Text(
                          DateFormat("dd/MM/yyyy HH:mm:ss").format(
                              DateTime.parse(item.dateOrder + "+07:00")
                                  .toLocal()),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
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

  Widget _childPopup(Invoice item) => PopupMenuButton<int>(
        padding: const EdgeInsets.all(0),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.content_copy,
                  color: Colors.grey[700],
                ),
                const SizedBox(
                  width: 12,
                ),
                const Text(
                  "Copy",
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: 2,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.print,
                  color: Colors.grey[700],
                ),
                const SizedBox(
                  width: 12,
                ),
                const Text(
                  "In",
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: 3,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.keyboard_return,
                  color: Colors.grey[700],
                ),
                const SizedBox(
                  width: 12,
                ),
                const Text(
                  "Trả hàng",
                ),
              ],
            ),
          ),
        ],
        icon: Icon(
          Icons.more_vert,
          color: Colors.grey[700],
        ),
        onSelected: (value) async {
          if (value == 2) {
            _vm.getDetailInvoice(item.id, widget.positon, true, false);
          } else if (value == 3) {
            final dialogResult = await showQuestion(
                context: context,
                title: "Xác nhận trả hàng",
                message: "Bạn muốn chắc chắn trả hàng?");
            if (dialogResult == DialogResultType.YES) {
              await _vm.deleteProductPosition(widget.positon);
              await _vm.getDetailInvoice(item.id, widget.positon, false, true);
              await _vm.insertProductForCart(widget.positon, widget.viewModel);
            }
          } else {
            final dialogResult = await showQuestion(
                context: context,
                title: "Xác nhận sao chép",
                message: "Bạn muốn sao chép tất cả sản phẩm cho giỏ hàng mới");
            if (dialogResult == DialogResultType.YES) {
              await _vm.deleteProductPosition(widget.positon);
              await _vm.getDetailInvoice(item.id, widget.positon, false, false);
              await _vm.insertProductForCart(widget.positon, widget.viewModel);
            }
          }
        },
      );
}
