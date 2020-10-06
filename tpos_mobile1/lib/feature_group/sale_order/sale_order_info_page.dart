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
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class SaleOrderInfoPage extends StatefulWidget {
  SaleOrderInfoPage(this.saleOrder, {this.onEditCompleted});
  final Function(SaleOrder) onEditCompleted;
  final SaleOrder saleOrder;

  @override
  _SaleOrderInfoPageState createState() => _SaleOrderInfoPageState();
}

class _SaleOrderInfoPageState extends State<SaleOrderInfoPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  SaleOrderInfoViewModel viewModel = SaleOrderInfoViewModel();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<SaleOrderInfoViewModel>(
      model: viewModel,
      child: ScopedModelDescendant<SaleOrderInfoViewModel>(
          builder: (context, child, model) {
        return WillPopScope(
          onWillPop: () {
            return Future(() {
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
              /// Thông tin đơn đặt hàng
              title: Text(S.current.purchaseOrder_orderInfo),
              actions: <Widget>[
                if (viewModel.saleOrder.state == "draft" ||
                    viewModel.saleOrder.state == "sale")
                  FlatButton.icon(
                    textColor: Colors.white,
                    icon: const Icon(Icons.edit),
                    label: Text(S.current.edit),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SaleOrderAddEditPage(
                            editOrder: widget.saleOrder,
                            isCopy: false,
                          ),
                        ),
                      );
                      viewModel.initCommand();
                    },
                  ),
                IconButton(
                  icon: const Icon(Icons.more_horiz),
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
            /// Đơn đặt hàng này đã hủy"
            child: Text(
              S.current.purchaseOrder_cancelPurchase,
              style: const TextStyle(color: Colors.red),
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
            S.current.draft,
            textAlign: TextAlign.center,
          ),
          icon: const Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
          lineColor: Colors.red,
          isCompleted: viewModel.saleOrder?.isStepDraft ?? false,
        ),
        MyStepItem(
          title: Text(
            S.current.confirm,
            textAlign: TextAlign.center,
          ),
          icon: const Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
          lineColor: Colors.red,
          isCompleted: viewModel.saleOrder?.isStepConfirm ?? false,
        ),
        MyStepItem(
            title: Text(
              S.current.purchaseOrder_createInvoice,
              textAlign: TextAlign.center,
            ),
            icon: const Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
            lineColor: Colors.red,
            isCompleted: viewModel.saleOrder?.isStepCompleted ?? false),
      ],
    );
  }

  Widget _buildMainActionButton() {
    final theme = Theme.of(context);
    if (viewModel.saleOrder.state == "draft")
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        height: 45,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                padding: const EdgeInsets.all(0),
                color: theme.primaryColor,
                disabledColor: Colors.grey.shade300,
                textColor: Colors.white,
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                onPressed: () async {
                  /// Bạn muốn xác nhận đơn đặt hàng này
                  final String message = S.current.purchaseOrder_confirmOrder;
                  final dialogResult = await showQuestion(
                      context: context,
                      title: S.current.confirm,
                      message: message);
                  if (dialogResult == OldDialogResult.Yes) {
                    viewModel.confirmCommand.action();
                  }
                },
                child: Text(S.current.confirm.toUpperCase()),
              ),
            ),
          ],
        ),
      );
    return const SizedBox();
  }

  Widget _buildBottomAction() {
    const dividerMin = Divider(
      height: 2,
    );
    return Container(
      color: const Color(0xFF737373),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
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
                  leading: const Icon(Icons.cancel, color: Colors.red),

                  /// Hủy đơn đặt hàng
                  title: Text(S.current.purchaseOrder_cancel),
                  onTap: () async {
                    if (await showQuestion(
                            context: context,
                            title: S.current.purchaseOrder_cancel,
                            message: S.current.purchaseOrder_confirmCancel) !=
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
                  leading: const Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
                  title: Text(S.current.purchaseOrder_order),
                  onTap: () async {
                    if (await showQuestion(
                            context: context,
                            title: S.current.confirm,
                            message: S.current.purchaseOrder_confirmOrder) !=
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
              leading: const Icon(Icons.content_copy, color: Colors.green),
              title: const Text("Copy"),
              onTap: () async {
                final dialogResult = await showQuestion(
                    context: context,
                    title: S.current.confirm,

                    /// Bạn có muốn tạo đơn đặt hàng khác từ đơn đặt hàng này không?
                    message: S.current.purchaseOrder_confirmCopy);
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
                    padding: const EdgeInsets.only(
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
    const dividerMin = Divider(
      height: 2,
    );

    const TextStyle _contentTextStyle = TextStyle(color: Colors.green);
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
              titleString: "${S.current.purchaseOrder_name}: ",
              content: Text(
                viewModel.saleOrder.name ?? "",
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            dividerMin,
            InfoRow(
              titleString: "${S.current.dateCreated}: ",
              content: Text(
                viewModel.saleOrder?.dateOrder != null
                    ? DateFormat("dd/MM/yyyy HH:mm", "en_US")
                        .format(viewModel.saleOrder?.dateOrder)
                    : "",
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            dividerMin,
            InfoRow(
              titleString: "${S.current.purchaseOrder_dateWarning}: ",
              content: viewModel.saleOrder?.dateExpected == null
                  ? const SizedBox()
                  : Text(
                      viewModel.saleOrder?.dateOrder != null
                          ? DateFormat("dd/MM/yyyy HH:mm", "en_US")
                              .format(viewModel.saleOrder?.dateExpected)
                          : "",
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right,
                    ),
            ),
            dividerMin,

            /// Khách hàng
            InfoRow(
              titleString: "${S.current.partner}: ",
              content: Text(
                viewModel.saleOrder.partnerDisplayName ?? "",
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.right,
                maxLines: null,
              ),
            ),
            dividerMin,

            /// Bảng giá
            InfoRow(
              titleString: S.current.priceList,
              content: Text(
                viewModel.saleOrder?.priceListName ?? "",
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            dividerMin,

            /// Người bán
            InfoRow(
              titleString: "${S.current.purchaseOrder_employee}: ",
              content: Text(
                viewModel.saleOrder.userName ?? "",
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            dividerMin,

            /// Tổng tiền
            InfoRow(
              titleString: "${S.current.totalAmount}:",
              content: Text(
                vietnameseCurrencyFormat(viewModel.saleOrder?.amountTotal) ??
                    "",
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            dividerMin,

            /// Trạng thái
            InfoRow(
              titleString: "${S.current.status}: ",
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
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: ExpansionTile(
        title: Text(
          S.current.products,
          style: const TextStyle(color: Colors.blue),
        ),
        initiallyExpanded: true,
        children: <Widget>[
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (ctx, index) {
              return SizedBox(
                width: double.infinity,
                child: ListTile(
                  contentPadding: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 0, top: 0),
                  dense: true,
                  title: Text(
                    items[index].productNameGet ?? "",
                    style: const TextStyle(color: Colors.black),
                  ),
                  subtitle: Row(
                    children: <Widget>[
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                              text:
                                  "${items[index].productUOMQty} (${items[index].productUOMName})",
                              style: const TextStyle(color: Colors.black),
                              children: [
                                const TextSpan(text: "  x   "),
                                TextSpan(
                                    text: vietnameseCurrencyFormat(
                                        items[index].priceUnit ?? 0),
                                    style: const TextStyle(color: Colors.blue)),
                              ]),
                        ),
                      ),
                      Text(
                        vietnameseCurrencyFormat(items[index].priceTotal ?? 0),
                        style: const TextStyle(color: Colors.red, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (ctx, index) {
              return const Divider(
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
