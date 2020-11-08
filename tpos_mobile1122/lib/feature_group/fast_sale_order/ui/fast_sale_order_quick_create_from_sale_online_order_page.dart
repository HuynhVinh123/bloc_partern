import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/app_core/ui_base/ui_vm_base.dart';
import 'package:tpos_mobile/feature_group/category/partner/partner_page.dart';
import 'package:tpos_mobile/feature_group/fast_sale_order/viewmodels/fast_sale_order_quick_create_from_sale_online_order_viewmodel.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/delivery_carrier_search_page.dart';


import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/helpers/tmt.dart';
import 'package:tpos_mobile/helpers/ui_help.dart';

import 'fast_sale_order_info_page.dart';

class FastSaleOrderQuickCreateFromSaleOnlineOrderPage extends StatefulWidget {
  const FastSaleOrderQuickCreateFromSaleOnlineOrderPage(
      {@required this.saleOnlineIds});
  final List<String> saleOnlineIds;

  @override
  _FastSaleOrderQuickCreateFromSaleOnlineOrderPageState createState() =>
      _FastSaleOrderQuickCreateFromSaleOnlineOrderPageState();
}

class _FastSaleOrderQuickCreateFromSaleOnlineOrderPageState
    extends State<FastSaleOrderQuickCreateFromSaleOnlineOrderPage> {
  final _vm = FastSaleOrderQuickCreateFromSaleOnlineOrderViewModel();

  @override
  void initState() {
    _vm.init(saleOnlineOrderIds: widget.saleOnlineIds);
    _vm.initData();

    _vm.eventController.listen((event) {
      if (event.eventName == "GO_BACK") {
        if (mounted) {
          Navigator.pop(context);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<FastSaleOrderQuickCreateFromSaleOnlineOrderViewModel>(
      model: _vm,
      child: UIViewModelBase(
        viewModel: _vm,
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            title: const Text("Tạo HĐ với sản phẩm mặc định"),
          ),
          body: _buildBody(),
          bottomNavigationBar: ScopedModelDescendant<
              FastSaleOrderQuickCreateFromSaleOnlineOrderViewModel>(
            builder: (context, _, __) => _vm.canSaveAll
                ? _buildBottomMenu()
                : _buildBottomCompleteMenu(),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomMenu() {
    final theme = Theme.of(context);
    return Container(
      height: 60,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border:
              Border(top: BorderSide(width: 1, color: Colors.grey.shade400))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: RaisedButton(
                padding: const EdgeInsets.all(0),
                shape: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.primaryColor, width: 0.5),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                ),
                color: theme.primaryColor,
                disabledColor: Colors.grey.shade300,
                textColor: Colors.white,
                child: const Text("XÁC NHẬN"),
                onPressed: () {
                  _vm.save().then((value) {
//                    if (value) Navigator.pop(context);
                  });
                }),
          ),
          const SizedBox(
            width: 0,
          ),
          RaisedButton(
            padding: const EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: theme.primaryColor, width: 0.5),
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
            ),
            color: Colors.grey.shade100,
            disabledColor: Colors.grey.shade300,
            child: Icon(Icons.more_horiz),
            onPressed: !true
                ? null
                : () {
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) => BottomSheet(
                        shape: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade200),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            )),
                        onClosing: () {},
                        builder: (context) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(
                                Icons.print,
                                color: Colors.blue,
                              ),
                              title: const Text("LƯU & IN VẬN ĐƠN"),
                              onTap: () {
                                // Navigator.pop(context);
                                _vm.save(printShip: true).then((value) {
                                  if (value) {
                                    Navigator.pop(this.context);
                                  }
                                });
                              },
                            ),
                            const Divider(),
                            ListTile(
                              leading: Icon(
                                Icons.print,
                                color: Colors.blue,
                              ),
                              title: const Text("LƯU & IN HÓA ĐƠN"),
                              onTap: () {
                                Navigator.pop(context);
                                _vm.save(printOrder: true).then((value) {
                                  if (value) {
                                    Navigator.pop(context);
                                  }
                                });
                              },
                            ),
                            const Divider(),
                            ListTile(
                              leading: Icon(
                                Icons.print,
                                color: Colors.blue,
                              ),
                              title: const Text("LƯU & IN VẬN ĐƠN + HÓA ĐƠN"),
                              onTap: () {
                                Navigator.pop(context);
                                _vm
                                    .save(printShip: true, printOrder: true)
                                    .then((value) {
                                  if (value) {
                                    Navigator.pop(context);
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomCompleteMenu() {
    return Container(
      height: 60,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border:
              Border(top: BorderSide(width: 1, color: Colors.grey.shade400))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: RaisedButton(
                padding: const EdgeInsets.all(0),
                shape: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.grey.shade400, width: 0.5),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                ),
                color: Colors.deepPurple,
                disabledColor: Colors.grey.shade300,
                textColor: Colors.green,
                child: const Text("ĐÓNG"),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          const SizedBox(
            width: 0,
          ),
          RaisedButton(
            padding: const EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.deepPurple.shade400, width: 0.5),
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
            ),
            color: Colors.grey.shade100,
            disabledColor: Colors.grey.shade300,
            child: Icon(Icons.more_horiz),
            onPressed: !true
                ? null
                : () {
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) => BottomSheet(
                        shape: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade200),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            )),
                        onClosing: () {},
                        builder: (context) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(
                                Icons.print,
                                color: Colors.blue,
                              ),
                              title: const Text("IN TOÀN BỘ PHIẾU SHIP"),
                              onTap: () {
                                Navigator.pop(context);
                                _vm.printShips(_vm.resultLineModels);
                              },
                            ),
                            const Divider(),
                            ListTile(
                              leading: Icon(
                                Icons.print,
                                color: Colors.blue,
                              ),
                              title: const Text("IN TOÀN BỘ HÓA ĐƠN"),
                              onTap: () {
                                Navigator.pop(context);
                                _vm.printOrders(_vm.resultLineModels);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
          ),
        ],
      ),
    );
  }

  Future _selectDeliveryCarrier(BuildContext context) async {
    final selectedCarrier = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeliveryCarrierSearchPage(
          closeWhenDone: true,
          isSearch: true,
          selectedDeliveryCarrier: _vm.carrier,
        ),
      ),
    );

    if (selectedCarrier != null) {
      _vm.carrier = selectedCarrier;
    }
  }

  Widget _buildBody() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context)?.requestFocus(FocusNode());
      },
      child: SingleChildScrollView(
        padding:
            const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        child: ScopedModelDescendant<
            FastSaleOrderQuickCreateFromSaleOnlineOrderViewModel>(
          builder: (context, child, model) => Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.directions_car,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text("Đối tác giao hàng:")
                        ],
                      ),
                      title: Text(
                        _vm.carrier?.name ?? "Nhấp để chọn",
                        textAlign: TextAlign.end,
                        style: Theme.of(context)
                            .textTheme
                            .body1
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () async {
                        if (_vm.carrier != null) {
                          // Thong bao chon lai
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              title: Text(_vm.carrier?.name ?? ''),
                              actions: <Widget>[
                                OutlineButton.icon(
                                  label: const Text("Bỏ chọn"),
                                  icon: Icon(Icons.remove_circle),
                                  textColor: Colors.red,
                                  color: Colors.white,
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _vm.carrier = null;
                                  },
                                ),
                                RaisedButton.icon(
                                  label: const Text("Thay đổi"),
                                  icon: Icon(Icons.cached),
                                  textColor: Colors.white,
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _selectDeliveryCarrier(context);
                                  },
                                ),
                              ],
                            ),
                          );

                          return;
                        }

                        _selectDeliveryCarrier(context);
                      },
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 10),
                          child: Icon(
                            Icons.info,
                            color: Colors.blue,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Phần mềm sẽ tự động chọn dịch vụ với phí giao hàng thấp nhất",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (_vm.lines?.length != null && _vm.lines.isEmpty)
                _buildOneDetail(),
              if (_vm.lines?.length != null && _vm.lines.isNotEmpty) ...[
                const SizedBox(
                  height: 10,
                ),
                _buildListDetail(),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOneDetail() {
    return Container();
  }

  Widget _buildListDetail() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) =>
              _buildDetailWithResult(_vm.resultLineModels[index]),
          separatorBuilder: (context, index) => SizedBox(
                height: 8,
                child: Container(
                  color: Colors.grey.shade200,
                ),
              ),
          itemCount: _vm.resultLineModels?.length ?? 0),
    );
  }

  /// Nếu kết quả thành công thì hiện thông tin giao hàng và mã vận đơn
  /// Lỗi thì hiện nhập lại thông tin kèm lỗi
  /// Nếu chưa tạo thì hiện chưa tạo
  Widget _buildDetailWithResult(ResultLineModel model) {
    if (model.status == "Chỉnh sửa") {
      return _buildDetailItem(model);
    } else if (model.status == "Thành công") {
      return _buildSuccessItem(model);
    } else if (model.status == "Lỗi") {
      return _buildErrorItem(model);
    } else {
      return const SizedBox();
    }
  }

  Widget _buildSuccessItem(ResultLineModel model) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              model.createdOrder?.number ?? '',
              style: const TextStyle(color: Colors.blue, fontSize: 18),
            ),
          ),
          IconButton(
            icon: Icon(Icons.more_horiz),
            onPressed: () {
              _showItemSuccessMenu(model: model);
            },
          ),
        ],
      ),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
//              Icon(
//                Icons.location_on,
//                color: Colors.deepPurple,
//              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                      style: TextStyle(
                          color: Colors.black87, fontWeight: FontWeight.bold),
                      text: "ĐC Giao: ",
                      children: [
                        TextSpan(text: "${model.line.partner.name} - "),
                        TextSpan(
                          text:
                              "${model.line.partner?.phone != null && model.line.partner?.phone != "" ? model.line.partner?.phone : "<Vui lòng cập nhật SĐT>"} | ",
                          style: TextStyle(
                              color: model.line.partner?.phone != null &&
                                      model.line.partner?.phone != ""
                                  ? Colors.black87
                                  : Colors.orangeAccent),
                        ),
                        TextSpan(
                          text: model.line.partner?.addressFull != null &&
                                  model.line.partner?.addressFull != ""
                              ? model.line.partner?.addressFull
                              : "Vui lòng cập nhật địa chỉ Phường Xã, Quận Huyện, Tỉnh- Thành phố cho khách hàng",
                          style: TextStyle(
                              color: model.line.partner?.addressFull == null ||
                                      model.line.partner?.addressFull == ""
                                  ? Colors.red
                                  : Colors.grey,
                              fontWeight: FontWeight.normal,
                              fontSize: 13),
                        ),
                      ]),
                ),
              ),
            ],
          ),

          // Mã vận đơn

          const SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Icon(Icons.card_giftcard),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: AutoSizeText(
                  model.createdOrder?.trackingRef ??
                      "Hóa đơn chưa có mã vận đơn",
                  style: TextStyle(color: Colors.orange, fontSize: 40),
                  maxLines: 1,
                  maxFontSize: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorItem(ResultLineModel model) {
    return Column(
      children: <Widget>[
        _buildDetailItem(model),
        Text(model.message),
      ],
    );
  }

  Widget _buildDetailItem(ResultLineModel model) {
    final codController = TextEditingController(
        text: vietnameseCurrencyFormat(model.line.totalAmount ?? 0));

    final shipController = TextEditingController(
      text: vietnameseCurrencyFormat(model.line.shipAmount ?? 0),
    );

    final weightController =
        TextEditingController(text: model.line.shipWeight.toString() ?? 0);
    return ExpansionTile(
      initiallyExpanded: true,
      title: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              model.line.facebookName ?? '',
              style: const TextStyle(color: Colors.blue),
            ),
          ),
          OutlineButton(
            child: const Text(
              "Sửa KH",
              style: TextStyle(color: Colors.blue),
            ),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PartnerAddEditPage(
                    partnerId: model.line.partnerId,
                    onEditPartner: (partner) {
                      setState(() {
                        model.line.partner.phone = partner.phone;
                        model.line.partner.city = partner.city;
                        model.line.partner.district = partner.district;
                        model.line.partner.ward = partner.ward;
                        model.line.partner.street = partner.street;
                      });
                    },
                  ),
                ),
              );
            },
          ),
          const SizedBox(
            width: 10,
          ),
          InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.more_horiz),
            ),
            onTap: () {
              _showItemMenu(model: model);
            },
          ),
        ],
      ),
      children: <Widget>[
        Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                //Icon(Icons.location_on),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(
                            color: Colors.black87, fontWeight: FontWeight.bold),
                        text: "ĐC Giao: ",
                        children: [
                          TextSpan(
                            text:
                                "${model.line.partner?.phone != null && model.line.partner?.phone != "" ? model.line.partner?.phone : "<Vui lòng cập nhật SĐT>"} | ",
                            style: TextStyle(
                                color: model.line.partner?.phone != null &&
                                        model.line.partner?.phone != ""
                                    ? Colors.black87
                                    : Colors.orangeAccent),
                          ),
                          TextSpan(
                            text: model.line.partner?.addressFull != null &&
                                    model.line.partner?.addressFull != ""
                                ? model.line.partner?.addressFull
                                : "Vui lòng cập nhật địa chỉ Phường Xã, Quận Huyện, Tỉnh- Thành phố cho khách hàng",
                            style: TextStyle(
                                color: model.line.partner?.addressFull ==
                                            null ||
                                        model.line.partner?.addressFull == ""
                                    ? Colors.red
                                    : Colors.grey),
                          ),
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: TextField(
                  decoration: const InputDecoration(
                      hintText: "Tiền hàng:",
                      labelText: "Tiền hàng: ",
                      alignLabelWithHint: true),
                  controller: codController,
                  onChanged: (text) {
                    final value = App.convertToDouble(text, "vi_VN");
                    model.line.totalAmount = value;
                  },
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    CurrencyInputFormatter(),
                  ],
                  onTap: () {
                    codController.selection = TextSelection(
                        baseOffset: 0, extentOffset: codController.text.length);
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 3,
                child: TextField(
                  decoration: const InputDecoration(
                      hintText: "Phí ship:", labelText: "Phí ship :"),
                  controller: shipController,
                  onChanged: (text) {
                    final value = App.convertToDouble(text, "vi_VN");
                    model.line.shipAmount = value;
                  },
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CurrencyInputFormatter(),
                  ],
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  onTap: () {
                    shipController.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: shipController.text.length);
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 2,
                child: TextField(
                  decoration: const InputDecoration(
                      hintText: "KL:", labelText: "KL (g) :"),
                  controller: weightController,
                  onChanged: (text) {
                    final value = App.convertToDouble(text, "vi_VN");
                    model.line.shipWeight = value;
                  },
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    CurrencyInputFormatter(),
                  ],
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  onTap: () {
                    weightController.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: weightController.text.length);
                  },
                ),
              ),
              const Text("T Toán:"),
              Checkbox(
                value: model.line.isPayment,
                onChanged: (value) {
                  setState(() {
                    model.line.isPayment = value;
                  });
                },
              ),
            ],
          ),
        ),
        //Ghi chú sản phẩm
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey, width: 0.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    model.line.productNote ?? "Ghi chú sản phẩm",
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              onTap: () async {
                final result = await showTextInputDialog(
                    context, model.line.productNote, true);
                if (result != null)
                  setState(() {
                    model.line.productNote = result;
                  });
              },
            ),
          ),
        ),
        //Ghi chú
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey, width: 0.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Ghi chú: ${model.line.comment}",
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              onTap: () async {
                final result = await showTextInputDialog(
                    context, model.line.comment, true);
                if (result != null)
                  setState(() {
                    model.line.comment = result;
                  });
              },
            ),
          ),
        )
      ],
    );
  }

  void _showItemMenu({ResultLineModel model}) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => BottomSheet(
              shape: const OutlineInputBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              onClosing: () {},
              builder: (context) => Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text(
                      "${model?.line?.partner?.name} | ${model?.line?.partner?.phone ?? "[ Chưa có SĐT ]"}",
                      style: const TextStyle(color: Colors.blue),
                    ),
                    subtitle: Text(
                        model.line?.partner?.street ?? "[ Chưa có địa chỉ ]"),
                  ),
                  const Divider(height: 2),
                  ListTile(
                    leading: Icon(
                      Icons.print,
                      color: Colors.green,
                    ),
                    title: const Text("Xác nhận"),
                    onTap: () {
                      Navigator.pop(context);
                      _vm.saveSelected(model);
                    },
                  ),
                  const Divider(height: 2),
                  ListTile(
                    leading: Icon(
                      Icons.print,
                      color: Colors.green,
                    ),
                    title: const Text("Xác nhận & In vận đơn"),
                    onTap: () {
                      Navigator.pop(context);
                      _vm.saveSelected(model, printShip: true);
                    },
                  ),
                  const Divider(height: 2),
                  ListTile(
                    leading: Icon(
                      Icons.print,
                      color: Colors.green,
                    ),
                    title: const Text("Xác nhận & In hóa đơn"),
                    onTap: () {
                      _vm.saveSelected(model, printOrder: true);
                    },
                  ),
                  const Divider(height: 2),
                  ListTile(
                    leading: Icon(
                      Icons.print,
                      color: Colors.green,
                    ),
                    title: const Text("Xác nhận & In HĐ + Vận đơn"),
                    onTap: () {
                      Navigator.pop(context);
                      _vm.saveSelected(model,
                          printShip: true, printOrder: true);
                    },
                  ),
                  const Divider(height: 2),
                  ListTile(
                    title: const Text(
                      "Xóa",
                      style: TextStyle(color: Colors.red),
                    ),
                    leading: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _vm.deleteSelected(model);
                    },
                  ),
                ],
              ),
            ));
  }

  void _showItemSuccessMenu({ResultLineModel model}) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => BottomSheet(
              shape: const OutlineInputBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              onClosing: () {},
              builder: (context) => Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text(
                      "${model?.line?.partner?.name} | ${model?.line?.partner?.phone ?? "[ Chưa có SĐT ]"}",
                      style: const TextStyle(color: Colors.blue),
                    ),
                    subtitle: Text(
                        model.line?.partner?.street ?? "[ Chưa có địa chỉ ]"),
                  ),
                  const Divider(height: 2),
                  ListTile(
                    leading: Icon(
                      Icons.print,
                      color: Colors.green,
                    ),
                    title: const Text("Xem thông tin hóa đơn"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FastSaleOrderInfoPage(
                            order: model.createdOrder,
                          ),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 2),
                  ListTile(
                    leading: Icon(
                      Icons.print,
                      color: Colors.green,
                    ),
                    title: const Text("In vận đơn"),
                    onTap: () {
                      Navigator.pop(context);
                      _vm.printShip(model);
                    },
                  ),
                  const Divider(height: 2),
                  ListTile(
                    leading: Icon(
                      Icons.print,
                      color: Colors.green,
                    ),
                    title: const Text("In hóa đơn"),
                    onTap: () {
                      Navigator.pop(context);
                      _vm.printOrder(model);
                    },
                  ),
                  const Divider(height: 2),
                  ListTile(
                    title: const Text(
                      "Xóa khởi danh sách",
                      style: TextStyle(color: Colors.red),
                    ),
                    leading: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _vm.deleteSelected(model);
                    },
                  ),
                ],
              ),
            ));
  }
}
