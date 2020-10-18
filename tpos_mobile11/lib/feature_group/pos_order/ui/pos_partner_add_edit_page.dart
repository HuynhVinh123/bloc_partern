import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/partners.dart';
import 'package:tpos_mobile/feature_group/pos_order/viewmodels/pos_partner_add_edit_viewmodel.dart';
import 'package:tpos_mobile/helpers/app_helper.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class PosPartnerAddEditPage extends StatefulWidget {
  const PosPartnerAddEditPage(this.partner);
  final Partners partner;

  @override
  _PosPartnerAddEditPageState createState() => _PosPartnerAddEditPageState();
}

class _PosPartnerAddEditPageState extends State<PosPartnerAddEditPage> {
  final _vm = locator<PosPartnerAddEditViewModel>();

  final TextEditingController _ctrlName = TextEditingController();
  final TextEditingController _ctrlAddress = TextEditingController();
  final TextEditingController _ctrlPhone = TextEditingController();
  final TextEditingController _ctrlBarcode = TextEditingController();
  final TextEditingController _ctrlEmail = TextEditingController();
  final TextEditingController _ctrlTaxCode = TextEditingController();

  Widget header(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 4, bottom: 4),
      child: Text(
        "$title: ",
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _formThongTin(
      {TextEditingController controller, bool isPhone, int maxLine}) {
    //controller.text = value;
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
      child: Container(
        height: 45,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(3.0),
          ),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
                child: isPhone
                    ? TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          hintText: "",
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                         
                        ],
                      )
                    : TextField(
                        maxLines: maxLine,
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: "",
                        ),
                      ))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewBase<PosPartnerAddEditViewModel>(
        model: _vm,
        builder: (context, modle, _) {
          return WillPopScope(
            onWillPop: () async {
              /// Các thông tin chưa lưu sẽ bị xóa. Bạn có muốn đóng trang này?
              return await confirmClosePage(context,
                  title: S.current.close,
                  message: S.current.posOfSale_confirmBackProduct);
            },
            child: Scaffold(
              backgroundColor: const Color(0xFFEBEDEF),
              appBar: AppBar(
                title: widget.partner == null

                    ///   Thêm khách hàng      Sửa khách hàng
                    ? Text(S.current.posOfSale_addPartner)
                    : Text(S.current.editPartner),
              ),
              body: Container(
                child: Material(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4.0),
                      topRight: Radius.circular(4.0)),
                  shadowColor: const Color(0xFFF0F1F3),
                  elevation: 1.0,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
//                        Padding(
//                          padding: const EdgeInsets.all(8.0),
//                          child: Text(
//                            "Thông tin khách hàng",
//                            style: const TextStyle(
//                                fontSize: 16, color: Colors.blue),
//                          ),
//                        ),
//                            header("Tên khách hàng"),
                        const SizedBox(
                          height: 36,
                        ),
                        showImage(),
                        const SizedBox(
                          height: 32,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(flex: 1, child: header(S.current.phone)),
                            Expanded(
                              flex: 3,
                              child: _formThongTin(
                                  controller: _ctrlName,
                                  isPhone: false,
                                  maxLine: 1),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(flex: 1, child: header(S.current.phone)),
                            Expanded(
                              flex: 3,
                              child: _formThongTin(
                                  controller: _ctrlPhone, isPhone: true),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            /// Mã vạch
                            Expanded(
                                flex: 1,
                                child: header(S.current.posOfSale_barCode)),
                            Expanded(
                              flex: 3,
                              child: _formThongTin(
                                  controller: _ctrlBarcode,
                                  isPhone: false,
                                  maxLine: 1),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(flex: 1, child: header("Email")),
                            Expanded(
                              flex: 3,
                              child: _formThongTin(
                                  controller: _ctrlEmail,
                                  isPhone: false,
                                  maxLine: 1),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            ///Mã số thuế
                            Expanded(
                                flex: 1,
                                child: header(S.current.posOfSale_taxCode)),
                            Expanded(
                              flex: 3,
                              child: _formThongTin(
                                  controller: _ctrlTaxCode,
                                  isPhone: false,
                                  maxLine: 1),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            /// Địa chỉ
                            Expanded(
                                flex: 1,
                                child: header(S.current.posOfSale_address)),
                            Expanded(
                              flex: 3,
                              child: _formThongTin(
                                  controller: _ctrlAddress,
                                  isPhone: false,
                                  maxLine: 1),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        _buildBtnXacNhan(),
                        const SizedBox(
                          height: 18,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget _buildBtnXacNhan() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: const EdgeInsets.only(top: 8),
      child: Center(
        child: Container(
          margin: EdgeInsets.only(
              right: MediaQuery.of(context).size.width / 5,
              left: MediaQuery.of(context).size.width / 5),
          height: 45,
          decoration: const BoxDecoration(
            color: Color(0xFF28A745),
            borderRadius: BorderRadius.all(Radius.circular(3.0)),
          ),
          child: FlatButton(
            onPressed: () {
              updateInfo(context);
            },
            child: Center(
              child: Text(
                S.current.confirm,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget showImage() {
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 12),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      title: const Text("Menu"),
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(Icons.camera),
                          title: Text(S.current.posOfSale_chooseFromCamera),
                          onTap: () {
                            _vm.getImageFromCamera();
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.image),
                          title: Text(S.current.posOfSale_chooseFromGallery),
                          onTap: () {
                            _vm.getImageFromGallery();
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  });
            },
            child: Container(
              child: Builder(builder: (context) {
                return Stack(
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey[400],
                            )),
                        height: 92,
                        width: 92,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: _vm.image == null
                              ? const AssetImage("images/no_image.png")
                              : FileImage(_vm.image),
                        )),
                    Positioned(
                      bottom: 2,
                      right: 6,
                      child: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xFF28A745),
                              borderRadius: BorderRadius.circular(12)),
                          width: 24,
                          height: 24,
                          child: const Icon(
                            Icons.camera_alt,
                            size: 14,
                            color: Colors.white,
                          )),
                    )
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> updateInfo(BuildContext context) async {
    if (_vm.image != null) {
      final List<int> imageBytes = _vm.image.readAsBytesSync();
      final String base64Image = base64Encode(imageBytes);
      _vm.partner.image = "data:image/png;base64," + base64Image;
    }
    _vm.partner.name = _ctrlName.text;
    _vm.partner.phone = _ctrlPhone.text;
    _vm.partner.barcode = _ctrlBarcode.text;
    _vm.partner.email = _ctrlEmail.text;
    _vm.partner.street = _ctrlAddress.text;
    _vm.partner.taxCode = _ctrlTaxCode.text;

    if (_ctrlName.text != "") {
      if (widget.partner == null) {
        await _vm.updatePartner(false);
      } else {
        await _vm.updatePartner(true);
      }
      Navigator.pop(context, _vm.isUpdateData);
    } else {
      /// Tên khách hàng không được để trống
      _vm.showNotifyUpdate(S.current.posOfSale_partnerNameNotEmpty);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.partner != null) {
      _vm.partner = widget.partner;
      _ctrlName.text = _vm.partner.name;
      _ctrlAddress.text = _vm.partner.street;
      _ctrlPhone.text = _vm.partner.phone;
      _ctrlBarcode.text = _vm.partner.barcode;
      _ctrlEmail.text = _vm.partner.email;
      _ctrlTaxCode.text = "";
    }
  }
}
