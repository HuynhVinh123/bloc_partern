/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 7/5/19 4:54 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 7/5/19 8:32 AM
 *
 */

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

import 'package:intl/intl.dart';
import 'package:tpos_mobile/app_core/ui_base/ui_vm_base.dart';
import 'package:tpos_mobile/feature_group/fast_sale_order/ui/fast_sale_order_add_edit_full_page.dart';
import 'package:tpos_mobile/feature_group/fast_sale_order/viewmodels/fast_sale_order_info_viewmodel.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/partner_info_page.dart';

import 'package:tpos_mobile/helpers/app_helper.dart';
import 'package:tpos_mobile/helpers/helpers.dart';

import 'package:tpos_mobile/src/tpos_apis/models/fast_sale_order.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_sale_order_line.dart';
import 'package:tpos_mobile/src/tpos_apis/models/payment_info_content.dart';
import 'package:tpos_mobile/widgets/custom_bottom_sheet.dart';
import 'package:tpos_mobile/widgets/custom_widget.dart';

import 'fast_sale_order_payment_page.dart';

class FastSaleOrderInfoPage extends StatefulWidget {
  final FastSaleOrder order;

  FastSaleOrderInfoPage({@required this.order});

  @override
  _FastSaleOrderInfoPageState createState() =>
      _FastSaleOrderInfoPageState(order: this.order);
}

class _FastSaleOrderInfoPageState extends State<FastSaleOrderInfoPage> {
  FastSaleOrder order;
  _FastSaleOrderInfoPageState({this.order});
  FastSaleOrderInfoViewModel viewModel = new FastSaleOrderInfoViewModel();

  final GlobalKey<ScaffoldState> _scafffoldKey = new GlobalKey<ScaffoldState>();

  Future actionMakePayment() async {
    var paymentPrepaid = await viewModel.makePaymentCommand.action();
    if (paymentPrepaid != null) {
      bool result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FastSaleOrderPaymentPage(
            payment: paymentPrepaid,
            amount: viewModel.editOrder.residual,
          ),
        ),
      );

      if (result != null && result == true) {
        viewModel.initCommand();
      }
    }
  }

  Widget _buildStatusView() {
    if (viewModel.editOrder.state == "cancel") {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange),
            color: Colors.orange.shade100),
        padding: EdgeInsets.all(12),
        child: Center(
          child: Text(
            "Hóa đơn này đã bị hủy",
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }
    print(viewModel.editOrder.state);
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
          isCompleted: viewModel.editOrder?.isStepDraft ?? false,
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
          isCompleted: viewModel.editOrder?.isStepConfirm ?? false,
        ),
        MyStepItem(
          title: Text(
            "Thanh toán",
            textAlign: TextAlign.center,
          ),
          icon: Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
          lineColor: Colors.red,
          isCompleted: viewModel.editOrder?.isStepPay ?? false,
        ),
        MyStepItem(
            title: Text(
              "Hoàn thành",
              textAlign: TextAlign.center,
            ),
            icon: Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
            lineColor: Colors.red,
            isCompleted: viewModel.editOrder?.isStepCompleted ?? false),
      ],
    );
  }

  Widget _buildShipNoticationView() {
    if (viewModel.editOrder.carrier != null) {
      if (viewModel.editOrder.trackingRef == null &&
          (viewModel.editOrder.state == "open" ||
              viewModel.editOrder.state == "paid")) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.orangeAccent.shade50,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey),
          ),
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.warning,
                  color: Colors.orangeAccent,
                  size: 40,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Hóa đơn chưa có mã vận đơn"),
                  RaisedButton(
                    color: Colors.orange,
                    textColor: Colors.white,
                    child: Text("Gửi lại mã"),
                    onPressed: () async {
                      if (await showQuestion(
                              context: context,
                              title: "Xác nhận gủi lại!",
                              message:
                                  "Bạn có muốn gửi lại vận đơn của hóa đơn có mã ${viewModel.editOrder.number ?? "N/A"}") !=
                          OldDialogResult.Yes) {
                        return;
                      }

                      await viewModel.sendToShipperCommand.action();
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      }
    }

    return SizedBox();
  }

  /// Gọi xác nhận hóa đơn
  Future _confirmOrder(
      {bool printShip = false, bool printOrder = false}) async {
    if (await showQuestion(
            context: context,
            title: "Xác nhận!",
            message: "Bạn muốn xác nhận hóa đơn này?") !=
        OldDialogResult.Yes) {
      return;
    }
    Navigator.pop(context);
    viewModel.isConfirmAndPrintShip = printShip;
    viewModel.isConfirmAndPrintOrder = printOrder;
    viewModel.confirmCommand.action();
  }

  @override
  void initState() {
    viewModel.init(editOrder: order);

    viewModel.initCommand();
    viewModel.dialogMessageController.listen((f) {
      registerDialogToView(context, f, scaffState: _scafffoldKey.currentState);
    });

    viewModel.notifyPropertyChangedController.listen((f) {
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  void _showInitFail() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Đã xảy ra lỗi"),
            content: Text(
                "Không thể khởi tạo dữ liệu. Vui lòng thử lại hoặc trờ về trang trước"),
            actions: <Widget>[
              RaisedButton.icon(
                textColor: Colors.white,
                icon: Icon(Icons.arrow_back),
                label: Text("Quay lại"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
              RaisedButton.icon(
                textColor: Colors.white,
                icon: Icon(Icons.refresh),
                label: Text("Thử lại"),
                onPressed: () {
                  Navigator.pop(context);
                  viewModel.initCommand();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var sizeBoxMin = SizedBox(
      height: 10,
    );
    return Scaffold(
      key: _scafffoldKey,
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: StreamBuilder<FastSaleOrder>(
            stream: viewModel.editOrderStream,
            initialData: viewModel.editOrder,
            builder: (context, snapshot) {
              return Text("${viewModel.editOrder.number ?? "Nháp"}");
            }),
        actions: <Widget>[
          FlatButton.icon(
            textColor: Colors.white,
            icon: Icon(Icons.edit),
            label: Text("Sửa"),
            onPressed: () async {
              //Check condition to edit this invoice

              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          FastSaleOrderAddEditFullPage(editOrder: this.order)));

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
      body: UIViewModelBase(
        viewModel: viewModel,
        backgroundColor: Colors.green.shade100,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await viewModel.initCommand();
                    return true;
                  },
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      padding:
                          EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 8),
                      child: Column(
                        children: <Widget>[
                          // Trạng thái hóa đơn
                          _buildStatusView(),
                          const SizedBox(height: 10),

                          if (viewModel.editOrder?.carrier != null)
                            _showShipInfo(),
                          const SizedBox(height: 10),
                          _buildShipNoticationView(),
                          const SizedBox(height: 10),
                          _showPrimaryInfo(),
                          sizeBoxMin,
                          _showShippingInfo(),
                          sizeBoxMin,
                          _showReceiverInfo(),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: EdgeInsets.all(3),
                            child: ExpansionTile(
                              title: Text(
                                "Danh sách sản phẩm",
                                style: TextStyle(color: Colors.black),
                              ),
                              initiallyExpanded: true,
                              children: <Widget>[
                                StreamBuilder<List<FastSaleOrderLine>>(
                                    stream: viewModel.orderLinesStream,
                                    initialData: viewModel.orderLines,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return SizedBox();
                                      }

                                      if (!snapshot.hasData) {
                                        return SizedBox();
                                      }

                                      return _showOrderLines(snapshot.data);
                                    })
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: EdgeInsets.all(3),
                            child: _showSummary(),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              _buildMainActionButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showOrderLines(List<FastSaleOrderLine> items) {
    return Container(
      color: Colors.white,
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (ctx, index) {
          return _showOrderLineItem(items[index]);
        },
        separatorBuilder: (ctx, index) {
          return Divider(
            height: 0,
          );
        },
        itemCount: items?.length ?? 0,
      ),
    );
  }

  Widget _showOrderLineItem(FastSaleOrderLine item) {
    return SizedBox(
      width: double.infinity,
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 20, right: 20, bottom: 0, top: 0),
        dense: true,
        title: Text(
          item.productNameGet ?? "",
          style: TextStyle(color: Colors.black),
        ),
        subtitle: Row(
          children: <Widget>[
            Expanded(
              child: RichText(
                text: TextSpan(
                    text: "${item.productUOMQty} (${item.productUomName})",
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(text: "  x   "),
                      TextSpan(
                          text: vietnameseCurrencyFormat(item.priceUnit ?? 0),
                          style: TextStyle(color: Colors.blue)),
                      item.discount > 0
                          ? TextSpan(text: " (giảm ${item.discount})%")
                          : item.discountFixed > 0
                              ? TextSpan(
                                  text:
                                      " (giảm ${vietnameseCurrencyFormat(item.discountFixed)})")
                              : TextSpan(),
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
//            InfoRow(
//              titleString: "Số HĐ: ",
//              content: Text(
//                "${viewModel.editOrder.number ?? ""}",
//                textAlign: TextAlign.right,
//                style: TextStyle(
//                  color: Colors.green,
//                  fontWeight: FontWeight.bold,
//                ),
//              ),
//            ),

            InfoRow(
              titleString: "Ngày hóa đơn: ",
              content: Text(
                "${viewModel.editOrder?.dateInvoice != null ? DateFormat("dd/MM/yyyy HH:mm", "en_US").format(viewModel.editOrder?.dateInvoice?.toLocal()) : ""} (${viewModel.timeAgo}) ",
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            dividerMin,
            InfoRow(
              titleString: "Khách hàng: ",
              content: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PartnerInfoPage(
                        partnerId: viewModel.editOrder.partnerId,
                        onEditPartner: (partner) {
                          // Update view
                        },
                      ),
                    ),
                  );
                },
                child: Text(
                  "${viewModel.editOrder.partnerDisplayName ?? ""}",
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
                  textAlign: TextAlign.right,
                  maxLines: null,
                ),
              ),
            ),
            dividerMin,
            InfoRow(
              titleString: "Điện thoại",
              content: InkWell(
                onTap: () async {
                  viewModel
                      .callPhone(viewModel.editOrder?.partnerPhone?.trim());
                },
                child: Text(
                  "${viewModel.editOrder?.partnerPhone ?? ""}",
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            dividerMin,
            InfoRow(
              titleString: "Người bán hàng: ",
              content: Text(
                "${viewModel.editOrder.userName ?? ""}",
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            dividerMin,
            InfoRow(
              titleString: "Ghi chú:",
              content: Text(
                "${viewModel.editOrder?.comment ?? ""}",
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
              contentString: viewModel.editOrder?.showState,
              contentTextStyle: _contentTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  color: getFastSaleOrderStateOption(
                          state: viewModel.editOrder.state)
                      .textColor),
            )
          ],
        ),
      ),
    );
  }

  Widget _showShippingInfo() {
//    var dividerMin = new Divider(
//      height: 2,
//    );

    TextStyle _contentTextStyle = new TextStyle(color: Colors.green);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.all(3),
      child: ExpansionTile(
        initiallyExpanded: viewModel.editOrder?.carrierId != null,
        title: SizedBox(
          child: Text("Thông tin vận chuyển"),
        ),
        children: ListTile.divideTiles(context: context, tiles: [
          // Địa chỉ giao hàng
          // Mã vận đơn

          InfoRow(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Địa chỉ giao hàng:"),
                SizedBox(
                  height: 6,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "${viewModel.shipAddress}",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        viewModel.openGoogleMap(viewModel.getAddress);
                      },
                      child: Container(
                        width: 48,
                        height: 38,
                        child: Center(
                          child: Image.asset(
                            "images/ic_map.png",
                            width: 28,
                            height: 28,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),

          // Tên đối tác
          InfoRow(
            titleString: "Đối tác giao hàng: ",
            content: Text(
              "${viewModel.editOrder?.carrierName ?? "N/A"}",
              style: _contentTextStyle,
              textAlign: TextAlign.right,
            ),
          ),

          InfoRow(
            titleString: "Dịch vụ: ",
            content: Text(
              "${viewModel.editOrder?.shipServiceName ?? "N/A"}",
              style: _contentTextStyle,
              textAlign: TextAlign.right,
            ),
          ),

          // Mã vận đơn
          InfoRow(
            titleString: "Mã vận đơn",
            contentString:
                "${viewModel.editOrder?.trackingRef ?? "<Chưa có mã vận đơn>"}",
            contentColor: viewModel.editOrder?.trackingRef != null
                ? Colors.green
                : Colors.red,
          ),
          if (viewModel.editOrder?.trackingRefSort != null)
            InfoRow(
              titleString: "Mã theo dõi sắp xếp/ phân vùng",
              contentString:
                  "${viewModel.editOrder?.trackingRefSort ?? "<Không có>"}",
              contentColor: viewModel.editOrder?.trackingRefSort != null
                  ? Colors.green
                  : Colors.red,
            ),
          // Khối luộng
          InfoRow(
            titleString: "Khối lượng:",
            content: Text(
              "${NumberFormat("###,####,###").format(viewModel.editOrder?.shipWeight ?? 0)} g",
              style: _contentTextStyle.copyWith(
                  color: Colors.black, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
          ),
          // Tiền cọc
          InfoRow(
            titleString: "Tiền cọc:",
            content: Text(
              "${NumberFormat("###,####,###").format(viewModel.editOrder?.amountDeposit ?? 0)}",
              style: _contentTextStyle.copyWith(
                  color: Colors.black, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
          ),
          InfoRow(
            titleString:
                "Phí giao hàng (${viewModel.editOrder?.carrier?.deliveryType}):",
            content: Text(
              "${NumberFormat("###,###,###,###", "en_US").format(viewModel.editOrder?.customerDeliveryPrice ?? 0)}",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          // Phí giao hàng
          InfoRow(
            titleString: "Phí giao hàng (Shop):",
            content: Text(
              "${NumberFormat("###,###,###,###", "en_US").format(viewModel.editOrder?.deliveryPrice ?? 0)}",
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          // Tiền thu hộ

          InfoRow(
            titleString: "Tiền thu hộ:",
            content: Text(
              "${NumberFormat("###,###,###,###", "en_US").format(viewModel.editOrder?.cashOnDelivery ?? 0)}",
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Trạng thái vận đơn
          InfoRow(
            titleString: "Trạng thái giao hàng:",
            contentString: "${viewModel.editOrder?.shipPaymentStatus ?? "N/A"}",
          ),
          // Trạng thái đối soát
          InfoRow(
            titleString: "Trạng thái đối soát:",
            contentString:
                "${convertShipStatusToVietnamese(viewModel.editOrder?.shipStatus ?? "")}",
          ),

          // Ghi chú giao hàng
          InfoRow(
            titleString: "Ghi chú GH: ",
            contentString: viewModel.editOrder?.deliveryNote ?? "",
          )
        ]).toList(),
      ),
    );
  }

  Widget _showShipInfo() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.location_on,
                color: Colors.deepPurple,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AutoSizeText(
                  "${viewModel.editOrder?.trackingRef ?? "N/A"}",
                  style: const TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.left,
                  maxFontSize: 30,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              SvgPicture.asset(
                "images/delivery-truck.svg",
                color: Colors.green,
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "${viewModel.editOrder.carrierName}",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(width: 20),
              Text(
                " [${viewModel.editOrder?.shipPaymentStatus ?? "Chưa có trạng thái"}]",
                maxLines: null,
                softWrap: true,
                style: const TextStyle(fontSize: 15),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _showReceiverInfo() {
    var dividerMin = new Divider(
      height: 2,
    );

    var boxDecorate = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5),
    );
    return Container(
      decoration: boxDecorate,
      padding: EdgeInsets.all(3),
      child: Builder(
        builder: (ctx) {
          if (viewModel.editOrder?.shipReceiver != null) {
            return ExpansionTile(
                title: Text("Thông tin người nhận"),
                children: ListTile.divideTiles(context: context, tiles: [
                  InfoRow(
                    titleString: "Tên người nhận: ",
                    contentString: viewModel.editOrder.shipReceiver.name,
                  ),
                  InfoRow(
                    titleString: "Số điện thoại: ",
                    contentString: viewModel.editOrder.shipReceiver.phone,
                  ),
                  InfoRow(
                    titleString: "Địa chỉ giao hàng: ",
                    contentString: viewModel.editOrder.shipReceiver.street,
                  ),
                ]).toList());
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }

//  Widget _showShipReceiver() {}

  Widget _showSummary() {
    return StreamBuilder<FastSaleOrder>(
      stream: viewModel.editOrderStream,
      initialData: viewModel.editOrder,
      builder: (ctx, snapshot) {
        return ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: ListTile.divideTiles(context: context, tiles: [
            InfoRow(
              titleString: "Số lượng sản phẩm:",
              content: Text(
                vietnameseCurrencyFormat(
                  viewModel.totalProductQuantity ?? 0,
                ),
                textAlign: TextAlign.right,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            InfoRow(
              titleString: "Cộng tiền:",
              content: Text(
                vietnameseCurrencyFormat(
                  viewModel.subTotal ?? 0,
                ),
                textAlign: TextAlign.right,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            InfoRow(
              titleString: "Chiết khấu (${viewModel.editOrder.discount}%):",
              content: Text(
                vietnameseCurrencyFormat(
                    viewModel.editOrder.discountAmount ?? 0),
                textAlign: TextAlign.right,
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
            InfoRow(
              titleString: "Giảm tiền :",
              content: Text(
                vietnameseCurrencyFormat(
                    viewModel.editOrder.decreaseAmount ?? 0),
                textAlign: TextAlign.right,
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
            InfoRow(
              titleString: "Tổng tiền :",
              content: Text(
                vietnameseCurrencyFormat(viewModel.editOrder.amountTotal ?? 0),
                textAlign: TextAlign.right,
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
            StreamBuilder<List<PaymentInfoContent>>(
                stream: viewModel.paymentInfoContentStream,
                initialData: viewModel.paymentInfoContent,
                builder: (context, snapshot) {
                  if (viewModel.paymentInfoContent == null) {
                    return SizedBox();
                  }
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 100, bottom: 8, top: 8),
                    child: _showPaymentInfoList(viewModel.paymentInfoContent),
                  );
                }),
            InfoRow(
              titleString: "Còn nợ:",
              content: Text(
                vietnameseCurrencyFormat(viewModel.editOrder.residual ?? 0),
                textAlign: TextAlign.right,
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          ]).toList(),
        );
      },
    );
  }

  Widget _showPaymentInfoList(List<PaymentInfoContent> items) {
    if (items == null || items.isEmpty)
      return InfoRow(
        titleString: "Thanh toán: ",
        contentString: "0",
      );
    return ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 10, bottom: 10),
        shrinkWrap: true,
        itemBuilder: (ctx, index) {
          return _showPaymentInfoItem(items[index]);
        },
        separatorBuilder: (ctx, index) => Divider(),
        itemCount: items.length);
  }

  Widget _showPaymentInfoItem(PaymentInfoContent item) {
    return InfoRow(
      titleString:
          "Trả lúc ${DateFormat("dd/MM/yyyy").format(item.date ?? null)}",
      contentString: vietnameseCurrencyFormat(item.amount),
    );
  }

  Widget _buildBottomAction() {
    var dividerMin = new Divider(
      height: 2,
      indent: 50,
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
            if (viewModel.makePaymentCommand.isEnable) ...[
              dividerMin,
              ListTile(
                leading: Icon(
                  Icons.payment,
                  color: Colors.green,
                ),
                title: Text("Thanh toán hóa đơn"),
                onTap: () async {
                  Navigator.pop(context);
                  actionMakePayment();
                },
              ),
            ],
            if (viewModel.confirmCommand.isEnable) ...[
              dividerMin,
              ListTile(
                  leading: Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
                  title: Text("Xác nhận hóa đơn"),
                  onTap: () async {}),
            ],
            dividerMin,
            ListTile(
              leading: Icon(Icons.print),
              title: Text("In phiếu ship"),
              onTap: () {
                Navigator.pop(context);
                viewModel.printShipCommand.actionBusy();
              },
            ),
            if (viewModel.editOrder?.carrierDeliveryType == "OkieLa") ...[
              dividerMin,
              ListTile(
                leading: Icon(Icons.print),
                title: Text("Tải về phiếu ship"),
                onTap: () {
                  Navigator.pop(context);
                  viewModel.printShipOkiela();
                },
              ),
            ],
            dividerMin,
            ListTile(
              leading: Icon(Icons.print),
              title: Text("In hóa đơn"),
              onTap: () {
                Navigator.pop(context);
                viewModel.printInvoiceCommand.actionBusy();
              },
            ),
//            dividerMin,
//            ListTile(
//              leading: Icon(Icons.print),
//              title: Text("In phiếu giao hàng"),
//            ),

            if (viewModel.sendToShipperCommand.isEnable) ...[
              dividerMin,
              ListTile(
                leading: Icon(
                  Icons.send,
                  color: Colors.blue,
                ),
                title: Text("Gửi lại vận đơn"),
                onTap: () async {
                  if (await showQuestion(
                          context: context,
                          title: "Xác nhận gủi lại!",
                          message:
                              "Bạn có muốn gửi lại vận đơn của hóa đơn có mã ${viewModel.editOrder.number ?? "N/A"}") !=
                      OldDialogResult.Yes) {
                    return;
                  }
                  Navigator.pop(context);
                  await viewModel.sendToShipperCommand.action();
                },
              )
            ],
            if (viewModel.cancelShipCommand.isEnable) ...[
              dividerMin,
              ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
                title: Text("Hủy vận đơn"),
                onTap: () async {
                  if (await showQuestion(
                          context: context,
                          title: "Xác nhận hủy",
                          message:
                              "Bạn có muốn hủy vận đơn có mã ${viewModel.editOrder.trackingRef ?? "N/A"}") !=
                      OldDialogResult.Yes) {
                    return;
                  }
                  Navigator.pop(context);
                  await viewModel.cancelShipCommand.action();
                },
              )
            ],
            if (viewModel.cancelInvoiceCommand.isEnable) ...[
              dividerMin,
              ListTile(
                leading: Icon(Icons.cancel, color: Colors.red),
                title: Text("Hủy hóa đơn"),
                onTap: () async {
                  if (await showQuestion(
                          context: context,
                          title: "Xác nhận hủy",
                          message: "Bạn có muốn hủy hóa đơn này không?") !=
                      OldDialogResult.Yes) {
                    return;
                  }
                  Navigator.pop(context);
                  viewModel.cancelInvoiceCommand.action();
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Select "Xac nhan" | "Xac nhan va in hoa don" | "Xac nhan va in phieu ship"
  Widget _buildMainActionButton() {
    var theme = Theme.of(context);
    if (viewModel.editOrder.state == "paid" ||
        viewModel.editOrder.state == "cancel") {
      return Container();
    }
    RaisedButton confirmButton = new RaisedButton(
      shape: OutlineInputBorder(
        borderSide: BorderSide(color: theme.primaryColor, width: 0.5),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          bottomLeft: Radius.circular(5),
        ),
      ),
      color: theme.primaryColor,
      disabledColor: Colors.grey.shade300,
      textColor: Colors.white,
      onPressed: () async {
        String message = "Bạn muốn xác nhận hóa đơn này?";

        var dialogResult = await showQuestion(
            context: context,
            title: "Xác nhận!",
            message: "Bạn muốn xác nhận hóa đơn này?");
        if (dialogResult == OldDialogResult.Yes) {
          viewModel.confirmCommand.action();
        }
      },
      child: Text("XÁC NHẬN"),
    );
    RaisedButton addPaymentButton = new RaisedButton(
      shape: OutlineInputBorder(
        borderSide: BorderSide(color: theme.primaryColor, width: 0.5),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          bottomLeft: Radius.circular(5),
        ),
      ),
      color: theme.primaryColor,
      disabledColor: Colors.grey.shade300,
      textColor: Colors.white,
      onPressed: () {
        actionMakePayment();
      },
      child: Text("THANH TOÁN"),
    );

    Widget selectActionButton() {
      if (viewModel.editOrder.state == "draft")
        return confirmButton;
      else if (viewModel.editOrder.state == "open")
        return addPaymentButton;
      else if (viewModel.editOrder.state == "pair")
        return Container();
      else
        return Container();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.grey.shade300),
      ),
      height: 60,
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 8, top: 8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: selectActionButton(),
          ),
          RaisedButton(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: theme.primaryColor, width: 0.5),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
            ),
            textColor: theme.primaryColor,
            color: Colors.grey.shade100,
            disabledColor: Colors.grey.shade300,
            onPressed: () {
              _showMainActionMenu();
            },
            child: Icon(Icons.more_horiz),
          ),
        ],
      ),
    );
  }

  void _showMainActionMenu() {
    var dividerMin = Divider(
      height: 2,
    );
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => BottomSheet(
        backgroundColor: Colors.transparent,
        onClosing: () {},
        builder: (context) => Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              if (viewModel.editOrder.state == "draft") ...[
                ListTile(
                  leading: Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
                  title: Text("Xác nhận & In phiếu ship"),
                  onTap: () {
                    _confirmOrder(printShip: true);
                  },
                ),
                dividerMin,
                ListTile(
                  leading: Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
                  title: Text("Xác nhận & In hóa đơn"),
                  onTap: () {
                    _confirmOrder(printOrder: true);
                  },
                ),
              ],
            ],
          ),
        ),
      ),
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
