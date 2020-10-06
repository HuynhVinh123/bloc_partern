import 'package:flutter/material.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/account/uis/search_company_list_page.dart';

import 'package:tpos_mobile/feature_group/account/viewmodels/type_account_sale_add_edit_viewmodel.dart';

import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class TypeAccountSaleAddEditPage extends StatefulWidget {
  const TypeAccountSaleAddEditPage({this.id, this.callback});
  final int id;
  final Function callback;

  @override
  _TypeAccountSaleAddEditPageState createState() =>
      _TypeAccountSaleAddEditPageState();
}

class _TypeAccountSaleAddEditPageState
    extends State<TypeAccountSaleAddEditPage> {
  final TextEditingController _controllerCode = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerNote = TextEditingController();

  final TypeAccountSaleAddEditViewModel _vm =
      locator<TypeAccountSaleAddEditViewModel>();
  Color colorCode;
  Color colorName;
  Color colorCompany = Colors.grey[700];

  @override
  void initState() {
    super.initState();
    initData();
  }

  ///Xử lý cập nhật thông tin cho phiếu chi khi sửa và get dữ liệu default khi thêm loại phiếu chi.
  Future<void> initData() async {
    if (widget.id != null) {
      await _vm.getDetailAccount(widget.id);
      _controllerCode.text = _vm.account?.code ?? "";
      _controllerName.text = _vm.account?.name ?? "";
      _controllerNote.text = _vm.account?.note ?? "";
      _vm.company = _vm.account.company;
    } else {
      await _vm.getDefaultAccount();
    }
  }

  @override
  Widget build(BuildContext context) {
    const Widget _spaceHeight = SizedBox(
      height: 4,
    );

    return ViewBase<TypeAccountSaleAddEditViewModel>(
        model: _vm,
        builder: (context, model, _) {
          return GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Scaffold(
                appBar: AppBar(
                  /// Sửa loại phiếu chi'    Thêm loại phiếu chi
                  title: Text(widget.id != null
                      ? S.current.paymentType_editPaymentType
                      : S.current.paymentType_addPaymentType),
                ),
                body: SafeArea(
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: 8,
                        bottom: 60,
                        left: 0,
                        right: 0,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _spaceHeight,
                              _spaceHeight,
                              _buildInfoContent(S.current.receiptType_enterCode,
                                  _controllerCode, colorCode),
                              const Divider(
                                height: 1,
                              ),
                              _buildInfoContent(S.current.receiptType_enterName,
                                  _controllerName, colorName),
                              const Divider(
                                height: 1,
                              ),
                              _buildInfoContent(S.current.receiptType_enterNote,
                                  _controllerNote, null),
                              const Divider(
                                height: 1,
                              ),
                              _spaceHeight,
                              _spaceHeight,
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    child: Text(S.current.receiptType_company,
                                        style: const TextStyle(
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15)),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SearchCompanyListPage()))
                                            .then((value) {
                                          if (value != null) {
                                            _vm.company = value;
                                            colorCompany = Colors.grey[700];
                                          }
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                              child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 4),
                                            child: Text(
                                              " ${_vm.company != null ? _vm.company.name : S.current.receiptType_chooseCompany}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: colorCompany),
                                              textAlign: TextAlign.right,
                                            ),
                                          )),
                                          Visibility(
                                            visible: _vm.company != null,
                                            child: InkWell(
                                              onTap: () {
                                                _vm.company = null;
                                              },
                                              child: Container(
                                                width: 35,
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors.grey[500],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.grey[500],
                                            size: 16,
                                          ),
                                          const SizedBox(
                                            width: 12,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 24,
                        right: 24,
                        child: Container(
                            width: 130,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.green),
                            child: FlatButton(

                                /// Xác nhận
                                child: Text(
                                  S.current.confirm,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 17),
                                ),
                                onPressed: () async {
                                  if (_controllerCode.text != "" &&
                                      _controllerName.text != "" &&
                                      _vm.company != null) {
                                    setState(() {
                                      colorCode = null;
                                      colorName = null;
                                      colorCompany = Colors.grey[700];
                                    });
                                    updateInfoAccount();
                                  } else {
                                    setState(() {
                                      if (_controllerCode.text == "")
                                        colorCode = Colors.red;
                                      else
                                        colorCode = null;
                                      if (_controllerName.text == "")
                                        colorName = Colors.red;
                                      else
                                        colorName = null;
                                      if (_vm.company == null)
                                        colorCompany = Colors.red;
                                      else
                                        colorCompany = Colors.grey[700];
                                    });
                                  }
                                })),
                      ),
                    ],
                  ),
                ),
              ));
        });
  }

  /// set thông tin dữ liệu phiếu chi đã điền để thực hiện thêm hoắc sửa loại phếu chi.
  Future<void> updateInfoAccount() async {
    _vm.account.code = _controllerCode.text;
    _vm.account.note = _controllerNote.text;
    _vm.account.name = _controllerName.text;
    await _vm.updateInfoAccount(context, widget.id, widget.callback);
  }

  /// Tạo form điền thông tin để người dùng nhập thông tin cho loại phiếu chi.
  Widget _buildInfoContent(
      String hintText, TextEditingController controller, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            labelText: hintText ?? "",
            border: InputBorder.none,
            labelStyle: TextStyle(fontWeight: FontWeight.w600, color: color)),
      ),
    );
  }
}
