import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:tpos_mobile/feature_group/sale_order/sale_order.dart';
import 'package:tpos_mobile/feature_group/sale_order/sale_order_add_edit_page.dart';
import 'package:tpos_mobile/feature_group/sale_order/sale_order_info_viewmodel.dart';
import 'package:tpos_mobile/feature_group/sale_order/sale_order_line.dart';
import 'package:tpos_mobile/helpers/app_helper.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';

import 'package:tpos_mobile/app_core/ui_base/ui_vm_base.dart';

import 'package:tpos_mobile/widgets/custom_bottom_sheet.dart';
import 'package:tpos_mobile/widgets/info_row.dart';
import 'package:tpos_mobile/widgets/my_step_view.dart';

class SaleOrderInfoPage extends StatefulWidget {
  final Function(SaleOrder) onEditCompleted;
  final SaleOrder saleOrder;
  SaleOrderInfoPage(this.saleOrder, {this.onEditCompleted});
  @override
  _SaleOrderInfoPageState createState() => _SaleOrderInfoPageState();
}

class _SaleOrderInfoPageState extends State<SaleOrderInfoPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  SaleOrderInfoViewModel viewModel = new SaleOrderInfoViewModel();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<SaleOrderInfoViewModel>(
      model: viewModel,
      child: ScopedModelDescendant<SaleOrderInfoViewModel>(
          builder: (context, child, model) {
        return WillPopScope(
          onWillPop: () {
            return new Future(() {
              if (widget.onEditCompleted != null) {
                widget.onEditCompleted(viewModel.saleOrder);
              }
              Navigator.pop(context);
              return false;
            });
          },
          child: Scaffold(
            backgroundColor: Colors.grey.shade200,
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text("Thông tin đơn đặt hàng"),
              actions: <Widget>[
                if (viewModel.saleOrder.state == "draft" ||
                    viewModel.saleOrder.state == "sale")
                  FlatButton.icon(
                    textColor: Colors.white,
                    icon: Icon(Icons.edit),
                    label: Text("Sửa"),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SaleOrderAddEditPage(
                            editOrder: this.widget.saleOrder,
                            isCopy: false,
                          ),
                        ),
                      );
                      viewModel.initCommand();
                    },
                  ),
                IconButton(
                  icon: Icon(Icons.more_horiz),
                  onPressed: () {
                    showModalBottomSheetFullPage(
                      context: context,
                      builder: (context) {
                        return _buildBottomAction();
                      },
                    );
                  },
                ),
              ],
            ),
            body: SafeArea(child: _buildDetail()),
          ),
        );
      }),
    );
  }

  Widget _buildStatusView() {
    if (viewModel.saleOrder.state == "cancel") {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.orange),
              color: Colors.orange.shade100),
          padding: EdgeInsets.all(12),
          child: Center(
            child: Text(
              "Đơn đặt hàng này đã hủy",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
      );
    }
    return MyStepView(
      currentIndex: 2,
      items: [
        MyStepItem(
          title: Text(
            "Nháp",
            textAlign: TextAlign.center,
          ),
          icon: Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
          lineColor: Colors.red,
          isCompleted: viewModel.saleOrder?.isStepDraft ?? false,
        ),
        MyStepItem(
          title: Text(
            "Xác nhận",
            textAlign: TextAlign.center,
          ),
          icon: Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
          lineColor: Colors.red,
          isCompleted: viewModel.saleOrder?.isStepConfirm ?? false,
        ),
        MyStepItem(
            title: Text(
              "Tạo hóa đơn",
              textAlign: TextAlign.center,
            ),
            icon: Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
            lineColor: Colors.red,
            isCompleted: viewModel.saleOrder?.isStepCompleted ?? false),
      ],
    );
  }

  Widget _buildMainActionButton() {
    var theme = Theme.of(context);
    if (viewModel.saleOrder.state == "draft")
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        height: 45,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                padding: EdgeInsets.all(0),
                color: theme.primaryColor,
                disabledColor: Colors.grey.shade300,
                textColor: Colors.white,
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                onPressed: () async {
                  String message = "Bạn muốn xác nhận đơn đặt hàng này?";
                  var dialogResult = await showQuestion(
                      context: context, title: "Xác nhận!", message: message);
                  if (dialogResult == OldDialogResult.Yes) {
                    viewModel.confirmCommand.action();
                  }
                },
                child: Text("XÁC NHẬN"),
              ),
            ),
          ],
        ),
      );
    return SizedBox();
  }

  Widget _buildBottomAction() {
    var dividerMin = new Divider(
      height: 2,
    );
    return Container(
      color: Color(0xFF737373),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            if (viewModel.saleOrder.state != "cancel") ...[
/*              if (viewModel.createInvoiceCommand.isEnable) ...[
                ListTile(
                  leading: Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
                  title: Text("Tạo hóa đơn"),
                  onTap: () async {
                    if (await showQuestion(
                        context: context,
                        title: "Xác nhận!",
                        message: "Bạn muốn tạo hóa đơn này?") !=
                        DialogResult.Yes) {
                      return;
                    }
                    Navigator.pop(context);
                  },
                ),
              ],*/
              if (viewModel.cancelOrderCommand.isEnable) ...[
                dividerMin,
                ListTile(
                  leading: Icon(Icons.cancel, color: Colors.red),
                  title: Text("Hủy đơn đặt hàng"),
                  onTap: () async {
                    if (await showQuestion(
                            context: context,
                            title: "Xác nhận hủy",
                            message:
                                "Bạn có muốn hủy đơn đặt hàng này không?") !=
                        OldDialogResult.Yes) {
                      return;
                    }
                    Navigator.pop(context);
                    viewModel.cancelOrderCommand.action();
                  },
                ),
              ],
              dividerMin,
              if (viewModel.confirmCommand.isEnable) ...[
                ListTile(
                  leading: Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
                  title: Text("Xác nhận đơn đặt hàng"),
                  onTap: () async {
                    if (await showQuestion(
                            context: context,
                            title: "Xác nhận!",
                            message: "Bạn muốn xác nhận hóa đơn này?") !=
                        OldDialogResult.Yes) {
                      return;
                    }
                    Navigator.pop(context);
                    viewModel.confirmCommand.action();
                  },
                ),
              ],
            ],
            ListTile(
              leading: Icon(Icons.content_copy, color: Colors.green),
              title: Text("Copy đơn đặt hàng"),
              onTap: () async {
                var dialogResult = await showQuestion(
                    context: context,
                    title: "Xác nhận",
                    message:
                        "Bạn có muốn tạo đơn đặt hàng khác từ đơn đặt hàng này không?");
                if (dialogResult == OldDialogResult.Yes) {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SaleOrderAddEditPage(
                        editOrder: viewModel.saleOrder,
                        onEditCompleted: (order) {
                          viewModel.init(editOrder: order);
                        },
                        isCopy: true,
                      ),
                    ),
                  );

                  viewModel.initCommand();
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetail() {
    return UIViewModelBase(
      viewModel: viewModel,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: RefreshIndicator(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                        left: 10, top: 10, right: 10, bottom: 10),
                    child: Column(
                      children: <Widget>[
                        _buildStatusView(),
                        _showPrimaryInfo(),
                        _showOrderLines(viewModel.saleOrderLine),
                      ],
                    ),
                  ),
                ),
                onRefresh: () async {}),
          ),
          _buildMainActionButton(),
        ],
      ),
    );
  }

  Widget _showPrimaryInfo() {
    var dividerMin = new Divider(
      height: 2,
    );

    TextStyle _contentTextStyle = new TextStyle(color: Colors.green);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            InfoRow(
              titleString: "Tham chiếu: ",
              content: Text(
                "${viewModel.saleOrder.name ?? ""}",
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            dividerMin,
            InfoRow(
              titleString: "Ngày đơn hàng: ",
              content: Text(
                "${viewModel.saleOrder?.dateOrder != null ? DateFormat("dd/MM/yyyy HH:mm", "en_US").format(viewModel.saleOrder?.dateOrder) : ""}",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            dividerMin,
            InfoRow(
              titleString: "Ngày cảnh báo: ",
              content: viewModel.saleOrder?.dateExpected == null
                  ? SizedBox()
                  : Text(
                      "${viewModel.saleOrder?.dateOrder != null ? DateFormat("dd/MM/yyyy HH:mm", "en_US").format(viewModel.saleOrder?.dateExpected) : ""}",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right,
                    ),
            ),
            dividerMin,
            InfoRow(
              titleString: "Khách hàng: ",
              content: Text(
                "${viewModel.saleOrder.partnerDisplayName ?? ""}",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.right,
                maxLines: null,
              ),
            ),
            dividerMin,
            InfoRow(
              titleString: "Bảng giá",
              content: Text(
                "${viewModel.saleOrder?.priceListName ?? ""}",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            dividerMin,
            InfoRow(
              titleString: "Người bán: ",
              content: Text(
                "${viewModel.saleOrder.userName ?? ""}",
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            dividerMin,
            InfoRow(
              titleString: "Tổng tiền:",
              content: Text(
                "${vietnameseCurrencyFormat(viewModel.saleOrder?.amountTotal) ?? ""}",
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            dividerMin,
            InfoRow(
              titleString: "Trạng thái: ",
              contentString: viewModel.saleOrder?.showFastState,
              contentTextStyle: _contentTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  color: getFastSaleOrderStateOption(
                          state: viewModel.saleOrder.showFastState)
                      .textColor),
            )
          ],
        ),
      ),
    );
  }

  Widget _showOrderLines(List<SaleOrderLine> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: ExpansionTile(
        title: Text(
          "Danh sách sản phẩm",
          style: TextStyle(color: Colors.blue),
        ),
        initiallyExpanded: true,
        children: <Widget>[
          ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (ctx, index) {
              return SizedBox(
                width: double.infinity,
                child: ListTile(
                  contentPadding:
                      EdgeInsets.only(left: 20, right: 20, bottom: 0, top: 0),
                  dense: true,
                  title: Text(
                    items[index].productNameGet ?? "",
                    style: TextStyle(color: Colors.black),
                  ),
                  subtitle: Row(
                    children: <Widget>[
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                              text:
                                  "${items[index].productUOMQty} (${items[index].productUOMName})",
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(text: "  x   "),
                                TextSpan(
                                    text: vietnameseCurrencyFormat(
                                        items[index].priceUnit ?? 0),
                                    style: TextStyle(color: Colors.blue)),
                              ]),
                        ),
                      ),
                      Text(
                        vietnameseCurrencyFormat(items[index].priceTotal ?? 0),
                        style: TextStyle(color: Colors.red, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (ctx, index) {
              return Divider(
                height: 0,
              );
            },
            itemCount: items?.length ?? 0,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    viewModel.init(editOrder: widget.saleOrder);
    viewModel.initCommand();
    viewModel.dialogMessageController.listen((f) {
      registerDialogToView(context, f, scaffState: _scaffoldKey.currentState);
    });

    super.initState();
  }
}
