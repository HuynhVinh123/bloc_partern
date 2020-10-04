import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/account_payment/viewmodel/account_payment_add_contact_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';

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
              appBar: AppBar(
                title: const Text("Thêm liên hệ"),
                actions: <Widget>[
                  InkWell(
                    onTap: () async {
                      if (_controllerNameContact.text != "") {
                        await updateInfoContactPartner(context);
                      } else {
                        _vm.showNotify("Tên liên hệ còn trống");
                      }
                    },
                    child: Row(
                      children: const <Widget>[
                        Icon(Icons.check),
                        Text("Lưu"),
                        SizedBox(
                          width: 12,
                        )
                      ],
                    ),
                  )
                ],
              ),
              body: SafeArea(
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      left: 12,
                      right: 12,
                      bottom: 65,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _buildInfoContent(
                                "Tên liên hệ", _controllerNameContact,
                                icon: const Icon(Icons.person)),
                            const Divider(
                              height: 4,
                            ),
                            _buildInfoContent(
                                "Số nhà, đường,...", _controllerAddress,
                                icon: const Icon(Icons.home)),
                            const Divider(
                              height: 4,
                            ),
                            _buildInfoContent("Email", _controllerEmail,
                                icon: const Icon(Icons.email)),
                            const Divider(
                              height: 4,
                            ),
                            _buildInfoContent("Điện thoại", _controllerPhone,
                                isPhone: true,
                                icon: const Icon(Icons.phone_iphone)),
                            const Divider(
                              height: 4,
                            ),
                            _buildInfoContent("Zalo", _controllerZalo,
                                icon: Image.asset(
                                  "images/ic_zalo.png",
                                  width: 24,
                                  height: 24,
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
                            _buildInfoContent("Ghi chú", _controllerNote,
                                icon: const Icon(Icons.note)),
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
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(5)),
                          child: FlatButton(
                            onPressed: () async {
                              if (_controllerNameContact.text != "") {
                                await updateInfoContactPartner(context);
                              } else {
                                _vm.showNotify("Tên liên hệ còn trống");
                              }
                            },
                            child: const Text(
                              "LƯU",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
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
                  border: InputBorder.none),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly,
              ],
            ),
          )
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3), color: Colors.white),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                  icon: icon ?? Icon(iconData),
                  labelText: hintText ?? "",
                  border: InputBorder.none),
            ),
          );
  }
}
