import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/account_payment/viewmodel/account_payment_add_contact_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class AccountPaymentAddContactPage extends StatefulWidget {
  @override
  _AccountPaymentAddContactPageState createState() =>
      _AccountPaymentAddContactPageState();
}

class _AccountPaymentAddContactPageState
    extends State<AccountPaymentAddContactPage> {
  final _vm = locator<AccountPaymentAddContactViewmodel>();

  final TextEditingController _controllerNameContact = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerAddress = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerZalo = TextEditingController();
  final TextEditingController _controllerFaceBook = TextEditingController();
  final TextEditingController _controllerNote = TextEditingController();

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    await _vm.getContactDefault();
  }

  @override
  Widget build(BuildContext context) {
    const Widget _spaceHeight = SizedBox(
      height: 8,
    );

    return ViewBase<AccountPaymentAddContactViewmodel>(
        model: _vm,
        builder: (context, snapshot, _) {
          return WillPopScope(
            onWillPop: () async {
              Navigator.pop(context, false);
              return false;
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),

                /// Thêm liên hệ
                title: Text(S.current.addContact),
                actions: <Widget>[
                  InkWell(
                    onTap: () async {
                      if (_controllerNameContact.text != "") {
                        await updateInfoContactPartner(context);
                      } else {
                        /// Tên liên hệ còn trống
                        _vm.showNotify(S.current.receipts_contactIsEmpty);
                      }
                    },
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.check),
                        Text(S.current.save),
                        const SizedBox(
                          width: 12,
                        )
                      ],
                    ),
                  )
                ],
              ),
              body: SafeArea(
                  child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 16,
                    right: 16,
                    bottom: 65,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          /// Tên liên hệ
                          _buildInfoContent(
                              S.current.name, _controllerNameContact,
                              icon: const Icon(
                                Icons.person,
                                color: Color(0xFF929DAA),
                                size: 20,
                              )),
                          const Divider(
                            height: 4,
                          ),

                          ///  "Số nhà, đường,..."
                          _buildInfoContent(
                              S.current.address, _controllerAddress,
                              icon: const Icon(Icons.home,
                                  color: Color(0xFF929DAA), size: 20)),
                          const Divider(
                            height: 4,
                          ),
                          _buildInfoContent("Email", _controllerEmail,
                              icon: const Icon(Icons.email,
                                  color: Color(0xFF929DAA), size: 20)),
                          const Divider(
                            height: 4,
                          ),

                          /// Điện thoại
                          _buildInfoContent(
                              S.current.phoneNumber, _controllerPhone,
                              isPhone: true,
                              icon: const Icon(Icons.phone_iphone,
                                  color: Color(0xFF929DAA), size: 20)),
                          const Divider(
                            height: 4,
                          ),
                          _buildInfoContent("Zalo", _controllerZalo,
                              icon: Image.asset(
                                "images/ic_zalo.png",
                                width: 20,
                                height: 20,
                                color: Colors.grey[700],
                              )),
                          const Divider(
                            height: 4,
                          ),
                          _buildInfoContent("Facebook", _controllerFaceBook,
                              iconData: FontAwesomeIcons.facebook),
                          const Divider(
                            height: 4,
                          ),

                          /// Ghi chú
                          _buildInfoContent(S.current.note, _controllerNote,
                              icon: const Icon(Icons.note,
                                  color: Color(0xFF929DAA), size: 20)),
                          const Divider(
                            height: 4,
                          ),
                          _spaceHeight,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 12,
                    right: 12,
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: const Color(0xFF28A745),
                            borderRadius: BorderRadius.circular(12)),
                        child: FlatButton(
                          onPressed: () async {
                            if (_controllerNameContact.text != "") {
                              await updateInfoContactPartner(context);
                            } else {
                              /// Tên liên hệ còn trống
                              _vm.showNotify(S.current.receipts_contactIsEmpty);
                            }
                          },
                          child: Text(
                            S.current.save.toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 17),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )),
            ),
          );
        });
  }

  Future<void> updateInfoContactPartner(BuildContext context) async {
    _vm.partner.name = _controllerNameContact.text;
    _vm.partner.street = _controllerAddress.text;
    _vm.partner.email = _controllerEmail.text;
    _vm.partner.phone = _controllerPhone.text;
    _vm.partner.zalo = _controllerZalo.text;
    _vm.partner.facebook = _controllerFaceBook.text;
    _vm.partner.comment = _controllerNote.text;
    _vm.partner.customer = false;
    _vm.partner.isContact = true;
    await _vm.addContactPartner(context);
  }

  Widget _buildInfoContent(String hintText, TextEditingController controller,
      {bool isPhone = false, Widget icon, IconData iconData}) {
    return isPhone
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3), color: Colors.white),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                  icon: icon,
                  labelText: hintText ?? "",
                  border: InputBorder.none,
                  labelStyle: const TextStyle(color: Color(0xFF929DAA))),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[],
            ),
          )
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3), color: Colors.white),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                  icon: icon ??
                      Icon(
                        iconData,
                        color: const Color(0xFF929DAA),
                        size: 20,
                      ),
                  labelText: hintText ?? "",
                  border: InputBorder.none,
                  labelStyle: const TextStyle(color: Color(0xFF929DAA))),
            ),
          );
  }
}
