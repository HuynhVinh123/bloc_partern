import 'package:flutter/material.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/category/viewmodel/control_service_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/src/tpos_apis/models/service_custom.dart';

class ControlServicePage extends StatefulWidget {
  ControlServicePage({this.serviceCustoms, this.serviceCustom});
  final List<ServiceCustom> serviceCustoms;
  final ServiceCustom serviceCustom;

  @override
  _ControlServicePageState createState() => _ControlServicePageState();
}

class _ControlServicePageState extends State<ControlServicePage> {
  final _codeServiceController = TextEditingController();
  final _nameServiceController = TextEditingController();

  var _vm = locator<ControlServiceViewModel>();

  @override
  void initState() {
    super.initState();
    if (widget.serviceCustom != null) {
      _codeServiceController.text = widget.serviceCustom.serviceId;
      _nameServiceController.text = widget.serviceCustom.name;
      _vm.isDefault = widget.serviceCustom.isDefault;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Tùy chỉnh dịch vụ"),
      ),
      body: ViewBase<ControlServiceViewModel>(
          model: _vm,
          builder: (context, model, _) {
            return Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _codeServiceController,
                        decoration: InputDecoration(
                            labelText: "Nhập Id (mã) dịch vụ",
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _nameServiceController,
                        decoration: InputDecoration(
                            labelText: "Nhập tên dịch vụ",
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15)),
                      ),
                    ),
                    CheckboxListTile(
                      value: _vm.isDefault,
                      title: Text("Mặc định"),
                      onChanged: (value) {
                        _vm.isDefault = value;
                      },
                    ),
                    SizedBox(
                      height: 12,
                    )
                  ],
                ),
                Positioned(
                  bottom: 8,
                  right: 12,
                  left: 12,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(6)),
                    child: FlatButton(
                      child: Text(
                        "LƯU",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      onPressed: () {
                        if (_codeServiceController.text != "" &&
                            _nameServiceController.text != "") {
                          if (widget.serviceCustoms != null) {
                            _vm.updateInfoCustomService(context,
                                serviceId: _codeServiceController.text,
                                serviceName: _nameServiceController.text,
                                serviceCustoms: widget.serviceCustoms);
                          } else {
                            widget.serviceCustom.serviceId =
                                _codeServiceController.text;
                            widget.serviceCustom.name =
                                _nameServiceController.text;
                            widget.serviceCustom.isDefault = _vm.isDefault;
                            Navigator.pop(context, true);
                          }
                        } else {
                          _vm.showNotify(
                              "Tên dịch vụ hoặc Id dịch vụ không được để trống!");
                        }
                      },
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }
}
