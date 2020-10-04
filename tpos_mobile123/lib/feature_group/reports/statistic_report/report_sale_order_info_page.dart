import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/app_core/ui_base/ui_vm_base.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/report_sale_order_info_viewmodel.dart';
import 'package:tpos_mobile/helpers/app_helper.dart';
import 'package:tpos_mobile/helpers/helpers.dart';

import 'package:tpos_mobile/src/tpos_apis/models/report_order.dart';
import 'package:tpos_mobile/widgets/custom_widget.dart';

class ReportSaleOrderInfoPage extends StatefulWidget {
  const ReportSaleOrderInfoPage({@required this.order});
  final ReportSaleOrderInfo order;

  @override
  _ReportSaleOrderInfoPageState createState() =>
      _ReportSaleOrderInfoPageState();
}

class _ReportSaleOrderInfoPageState extends State<ReportSaleOrderInfoPage> {
  ReportSaleOrderInfoViewModel viewModel = ReportSaleOrderInfoViewModel();

  final _scafffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    viewModel.reportSaleOrderInfo = widget.order;
    viewModel.initCommand(viewModel.reportSaleOrderInfo.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ReportSaleOrderInfoViewModel>(
      model: viewModel,
      child: UIViewModelBase(
        viewModel: viewModel,
        child: RefreshIndicator(
            child: ScopedModelDescendant<ReportSaleOrderInfoViewModel>(
                builder: (context, child, model) {
              return Scaffold(
                key: _scafffoldKey,
                backgroundColor: Colors.grey.shade300,
                appBar: AppBar(
                  title: Text(viewModel.reportSaleOrderInfo?.name ?? ""),
                ),
                body: Column(
                  children: <Widget>[
                    Expanded(
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              _showPaymentInfo(),
                              Container(
                                color: Colors.white,
                                child: ExpansionTile(
                                  title: Text(
                                    "Danh sách sản phẩm",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  initiallyExpanded: true,
                                  children: <Widget>[
                                    _showOrderLines(
                                        viewModel.fastSaleOrderLines),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                color: Colors.white,
                                child: _showSummary(),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            onRefresh: () async {}),
      ),
    );
  }

  Widget _showOrderLines(List<ReportSaleOrderLine> items) {
    return Container(
      color: Colors.white,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (ctx, index) {
          return _showOrderLineItem(items[index]);
        },
        separatorBuilder: (ctx, index) {
          return const Divider(
            height: 0,
          );
        },
        itemCount: items?.length ?? 0,
      ),
    );
  }

  Widget _showOrderLineItem(ReportSaleOrderLine item) {
    return SizedBox(
      width: double.infinity,
      child: ListTile(
        contentPadding:
            const EdgeInsets.only(left: 20, right: 20, bottom: 0, top: 0),
        dense: true,
        title: Text(
          item.name ?? "",
          style: TextStyle(color: Colors.black),
        ),
        subtitle: Row(
          children: <Widget>[
            Expanded(
              child: RichText(
                text: TextSpan(
                    text: "${item.qtyInvoiced} (${item.productUOMName})",
                    style: TextStyle(color: Colors.black),
                    children: [
                      const TextSpan(text: "  x   "),
                      TextSpan(
                          text: vietnameseCurrencyFormat(item.priceUnit ?? 0),
                          style: TextStyle(color: Colors.blue)),
                      if (item.discount > 0)
                        TextSpan(text: " (giảm ${item.discount})%")
                      else
                        item.discountFixed > 0
                            ? TextSpan(
                                text:
                                    " (giảm ${vietnameseCurrencyFormat(item.discountFixed.toDouble())})")
                            : const TextSpan(),
                    ]),
              ),
            ),
            Text(
              vietnameseCurrencyFormat(item.priceTotal ?? 0),
              style: TextStyle(color: Colors.red, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _showPaymentInfo() {
    final TextStyle _contentTextStyle = TextStyle(color: Colors.green);
    return Container(
      child: Column(
        children: [
          // Thông tin chung
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text("Số HĐ: "),
                      Text(
                        "${viewModel.reportSaleOrderInfo?.id ?? ""}",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text("Ngày đơn hàng: "),
                      Text(
                        viewModel.reportSaleOrderInfo?.dateOrder != null
                            ? DateFormat("dd/MM/yyyy HH:mm", "en_US").format(
                                viewModel.reportSaleOrderInfo?.dateOrder
                                    ?.toLocal())
                            : "",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text("Khách hàng: "),
                      Expanded(
                        child: Text(
                          viewModel.reportSaleOrderInfo?.partnerDisplayName ??
                              "",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                          maxLines: null,
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text("Điện thoại: "),
                      Text(
                        "${viewModel.reportSaleOrderInfo?.phoneNumber ?? ""}",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text("Người bán: "),
                      Text(
                        viewModel.reportSaleOrderInfo?.userName ?? "",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text("Ghi chú: "),
                      Text(
                        viewModel.reportSaleOrderInfo?.comment ?? "",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 20,
                  ),
                  InfoRow(
                    titleString: "Trạng thái: ",
                    contentString: viewModel.reportSaleOrderInfo?.showState,
                    contentTextStyle: _contentTextStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: getFastSaleOrderStateOption(
                                state: viewModel.reportSaleOrderInfo?.state)
                            .textColor),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _showSummary() {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: ListTile.divideTiles(context: context, tiles: [
        InfoRow(
          titleString: "Cộng tiền:",
          content: Text(
            vietnameseCurrencyFormat(
              viewModel.reportSaleOrderInfo.totalAmountBeforeDiscount ?? 0,
            ),
            textAlign: TextAlign.right,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        InfoRow(
          titleString:
              "Chiết khấu (${viewModel.reportSaleOrderInfo.discount}%):",
          content: Text(
            vietnameseCurrencyFormat(
                viewModel.reportSaleOrderInfo.discountAmount ?? 0),
            textAlign: TextAlign.right,
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ),
        InfoRow(
          titleString: "Giảm tiền :",
          content: Text(
            vietnameseCurrencyFormat(
                viewModel.reportSaleOrderInfo.decreaseAmount ?? 0),
            textAlign: TextAlign.right,
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ),
        InfoRow(
          titleString: "Tổng tiền :",
          content: Text(
            vietnameseCurrencyFormat(
                viewModel.reportSaleOrderInfo.amountTotal ?? 0),
            textAlign: TextAlign.right,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
        InfoRow(
          titleString: "Còn nợ:",
          content: Text(
            vietnameseCurrencyFormat(
                viewModel.reportSaleOrderInfo.residual ?? 0),
            textAlign: TextAlign.right,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
      ]).toList(),
    );
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
