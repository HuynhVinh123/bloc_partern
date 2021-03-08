import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/app_core/ui_base/ui_base.dart';
import 'package:tpos_mobile/feature_group/category/partner_edit_address_page.dart';
import 'package:tpos_mobile/feature_group/fast_sale_order/viewmodels/fast_sale_order_add_edit_full_viewmodel.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';

import 'fast_sale_order_add_edit_full_ship_address_edit_page.dart';

class FastSaleOrderAddEditFullShipAddressPage extends StatefulWidget {
  const FastSaleOrderAddEditFullShipAddressPage({@required this.viewModel});
  final FastSaleOrderAddEditFullViewModel viewModel;

  @override
  _FastSaleOrderAddEditFullShipAddressPageState createState() =>
      _FastSaleOrderAddEditFullShipAddressPageState();
}

class _FastSaleOrderAddEditFullShipAddressPageState
    extends State<FastSaleOrderAddEditFullShipAddressPage> {
  Future<void> _onRemoveShipAddress() async {
    final result = await showQuestion(
        context: context,
        title: "Thay đổi địa chỉ",
        message:
            "Chọn lựa này sẽ xóa địa chỉ tùy chọn của bạn. Địa chỉ mặc định sẽ được sử dụng làm địa chỉ giao hàng");
    if (result == OldDialogResult.Yes) {
      widget.viewModel.order?.shipReceiver = null;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return UIViewModelBase<FastSaleOrderAddEditFullViewModel>(
      viewModel: widget.viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Địa chỉ giao hàng"),
        ),
        body: _buildBody(),
        backgroundColor: Colors.grey.shade200,
        bottomNavigationBar: Container(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: RaisedButton.icon(
            textColor: Colors.white,
            icon: const Icon(Icons.keyboard_return),
            label: const Text("QUAY LẠI HÓA ĐƠN"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: ScopedModelDescendant<FastSaleOrderAddEditFullViewModel>(
        builder: (context, _, __) => Column(
          children: <Widget>[
            _AddressView(
              name: widget.viewModel.partner?.name,
              phone: widget.viewModel.partner?.phone,
              address: widget.viewModel.partner?.addressFull,
              isSelected: widget.viewModel.isShipReceiverValid == false,
              note: "Địa chỉ khách hàng",
              editLabel: "Sửa khách hàng",
              actions: <Widget>[
                FlatButton.icon(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PartnerEditAddressPage(
                          partnerId: widget.viewModel.partner?.id,
                          onSaved: () {
                            widget.viewModel.refreshPartnerInfo();
                          },
                        ),
                      ),
                    );

                    setState(() {});
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text("Sửa "),
                  textColor: Colors.blue,
                ),
              ],
              onTap: () {
                if (widget.viewModel.isShipReceiverValid)
                  _onRemoveShipAddress();
              },
            ),
            if (!widget.viewModel.isShipReceiverValid)
              _AddressNullView(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FastSaleOrderAddEditFullShipAddressEditPage(
                        vm: widget.viewModel,
                      ),
                    ),
                  );
//
//                  if ((widget.viewModel.order.shipReceiver.name == null ||
//                          widget.viewModel.order.shipReceiver.name == "") &&
//                      (widget.viewModel.order.shipReceiver.phone == null ||
//                          widget.viewModel.order.shipReceiver.phone == "") &&
//                      (widget.viewModel.order.shipReceiver.street == null ||
//                          widget.viewModel.shipReceiver.street == "")) {
//                    widget.viewModel.order.shipReceiver = null;
//                  }
                  setState(() {});
                },
              ),
            if (widget.viewModel.isShipReceiverValid)
              _AddressView(
                isSelected: widget.viewModel.shipReceiver != null,
                name: widget.viewModel.shipReceiver?.name,
                phone: widget.viewModel.shipReceiver?.phone,
                address: widget.viewModel.shipReceiver?.street,
                note: "Địa chỉ chỉ áp dụng cho hóa đơn này",
                editLabel: "Sửa địa chỉ",
                actions: <Widget>[
                  FlatButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FastSaleOrderAddEditFullShipAddressEditPage(
                            vm: widget.viewModel,
                          ),
                        ),
                      ).then((value) {
                        setState(() {});
                      });
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text("Sửa"),
                    textColor: Colors.blue,
                  ),
                  FlatButton.icon(
                    onPressed: () async {
                      _onRemoveShipAddress();
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text("Xóa"),
                    textColor: Colors.red,
                  )
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _AddressView extends StatelessWidget {
  const _AddressView({
    this.name,
    this.phone,
    this.address,
    this.isSelected = false,
    this.note = "",
    this.onEditPressed,
    this.editLabel,
    this.onTap,
    this.actions,
  });
  final String name;
  final String phone;
  final String address;
  final bool isSelected;
  final String note;
  final VoidCallback onEditPressed;
  final VoidCallback onTap;
  final String editLabel;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Colors.white),
      child: ListTile(
        leading: isSelected
            ? const Icon(
                Icons.check_circle,
                color: Colors.blue,
              )
            : const Icon(Icons.radio_button_unchecked),
        title: RichText(
          text: TextSpan(
              text: name != null && name != "" ? "$name" : "N/A",
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
              children: [
                if (phone != "")
                  TextSpan(
                    text: " | $phone",
                  ),
              ]),
        ),
        subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (address != null && address != "")
                Text(address)
              else
                const Text(
                  "<Vui lòng nhập địa chỉ, tỉnh thành, quận huyện, phường xã>",
                  style: TextStyle(color: Colors.red),
                ),
              Row(
                children: <Widget>[
                  const Icon(
                    Icons.info,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Text(
                      note ?? '',
                      style: const TextStyle(color: Colors.orange),
                    ),
                  ),
                  ...actions,
                ],
              ),
            ]),
        onTap: onTap,
      ),
    );
  }
}

class _AddressNullView extends StatelessWidget {
  const _AddressNullView({this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Colors.white),
      child: ListTile(
        leading: const Icon(Icons.radio_button_unchecked),
        title: const Text("Giao hàng tới một địa chỉ khác?"),
        subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                  "Nếu bạn muốn đơn hàng này sẽ được giao tới một địa chỉ khác địa chỉ khách hàng. chọn để nhập địa chỉ"),
              Row(children: const <Widget>[
                Icon(
                  Icons.warning,
                  color: Colors.orange,
                ),
                Expanded(
                  child: Text(
                    "Chỉ áp dụng cho hóa đơn này",
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ]),
            ]),
        onTap: onTap,
      ),
    );
  }
}
