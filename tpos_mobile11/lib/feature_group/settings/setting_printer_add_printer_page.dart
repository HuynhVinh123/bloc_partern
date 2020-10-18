import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/app_models/printer_type.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/setting_printer_add_printer_viewmodel.dart';

import 'package:tpos_mobile/services/print_service/printer_device.dart';
import 'package:tpos_mobile/src/static_data/support_printer_type.dart';

class SettingPrinterAddPrinter extends StatefulWidget {
  @override
  _SettingPrinterAddPrinterState createState() =>
      _SettingPrinterAddPrinterState();
}

class _SettingPrinterAddPrinterState extends State<SettingPrinterAddPrinter> {
  final _vm = SettingPrinterAddPrinterViewModel();

  final _nameController = new TextEditingController();
  final _ipController = new TextEditingController();
  final _portController = new TextEditingController();
  final _noteController = new TextEditingController();

  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _nameController.addListener(() {
      _vm.newDevice?.name = _nameController.text.trim();
    });
    _ipController.addListener(() {
      _vm.newDevice?.ip = _ipController.text.trim();
    });
    _portController.addListener(() {
      _vm.newDevice?.port = int.parse(_portController.text.trim());
    });
    _noteController.addListener(() {
      _vm.newDevice?.note = _noteController.text.trim();
    });

    _vm.addListener(() {
      if (_nameController.text != _vm.newDevice?.name) {
        _nameController.text = _vm.newDevice?.name;
      }

      if (_ipController.text != _vm.newDevice?.ip) {
        _ipController.text = _vm.newDevice?.ip;
      }
      if (_portController.text != _vm.newDevice?.port.toString()) {
        _portController.text = _vm.newDevice?.port.toString();
      }
      if (_noteController.text != _vm.newDevice?.note) {
        _noteController.text = _vm.newDevice?.note;
      }
    });
    super.initState();
  }

  void _save() {
    if (_formKey.currentState.validate()) {
      var printer = new PrinterDevice(
          name: _nameController.text.trim(),
          ip: _ipController.text.trim(),
          port: int.parse(_portController.text.trim()),
          type: _vm.selectedPrinterType.code,
          note: _noteController.text.trim());

      //_vm.selectedPrinterDevice.name = _nameController.text.trim();
      //_vm.selectedPrinterDevice.note = _noteController.text.trim();

      // Lưu setting;ssssssssssssss

      Navigator.pop(context, printer);
    } else {
      _scaffoldKey.currentState.showSnackBar(
          new SnackBar(content: Text("Vui lòng nhập các trường còn thiếu")));
    }
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: _vm,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          title: Text("Thêm máy in"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                _save();
              },
            )
          ],
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    var _textStyle = new TextStyle(fontWeight: FontWeight.bold);
    return SingleChildScrollView(
      child: ScopedModelDescendant<SettingPrinterAddPrinterViewModel>(
        builder: (context, child, model) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "LOẠI MÁY IN",
                        style: _textStyle.copyWith(
                            fontSize: 12, color: Colors.grey),
                      ),
                      Divider(),
                      DropdownButton<PrinterType>(
                        isExpanded: true,
                        value: _vm.selectedPrinterType,
                        onChanged: (selectedType) {
                          setState(() {
                            _vm.selectedPrinterType = selectedType;
                          });
                        },
                        hint: Text("Chọn loại máy in"),
                        items: appSupportPrinterType
                            .map((f) => DropdownMenuItem<PrinterType>(
                                  child: Text(f.name),
                                  value: f,
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
              if (_vm.selectedPrinterType != null &&
                  (_vm.selectedPrinterType.code == "esc_pos" ||
                      _vm.selectedPrinterType.code == "tpos_printer")) ...[
                SizedBox(
                  height: 10,
                ),
                _buildSelectListLanprinterLayout(),
              ],
              if (_vm.selectedPrinterDevice != null || _vm.isManual) ...[
                SizedBox(
                  height: 10,
                ),
                _buildPrinterInfo(),
              ],
              if (_vm.selectedPrinterDevice != null || _vm.isManual) ...[
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  color: Colors.white,
                  child: RaisedButton(
                    textColor: Colors.white,
                    onPressed: () {
                      _save();
                    },
                    child: Text("LƯU & ĐÓNG"),
                  ),
                )
              ],
            ],
          );
        },
      ),
    );
  }

  /// Chọn máy in lan được tìm tự động
  Widget _buildSelectListLanprinterLayout() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 8),
            child: Row(children: <Widget>[
              Expanded(
                  child: Text(
                "MÁY IN ESC/POS ĐÃ TÌM THẤY:",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              )),
              if (_vm.isDiscovering)
                SizedBox(
                  child: CircularProgressIndicator(),
                  height: 20,
                  width: 20,
                ),
              if (!_vm.isDiscovering)
                FlatButton.icon(
                  onPressed: () {
                    _vm.discoveryPrinterCommand();
                  },
                  icon: Icon(Icons.refresh),
                  label: Text("Làm mới"),
                )
            ]),
          ),
          Divider(),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: (_vm.printers?.length ?? 0),
              itemBuilder: (context, index) {
                return ListTile(
                  selected: _vm.selectedPrinterDevice == _vm.printers[index],
                  leading: Checkbox(
                      value: _vm.selectedPrinterDevice == _vm.printers[index],
                      onChanged: (value) {
                        _vm.setSelectedPrinterDeviceCommand(
                            _vm.printers[index]);
                      }),
                  title: Text("${_vm.printers[index].ip}"),
                  onTap: () {
                    _vm.setSelectedPrinterDeviceCommand(_vm.printers[index]);
                  },
                );
              }),
          Divider(),
          ListTile(
            leading: Checkbox(
                value: _vm.isManual,
                onChanged: (value) {
                  _vm.setIsManual(value);
                }),
            title: Text("Thêm thủ công"),
            subtitle: Text("Nếu máy in của bạn không có trong danh sách trên"),
          )
        ],
      ),
    );
  }

  Widget _buildPrinterInfo() {
    var _textStyle = new TextStyle(fontWeight: FontWeight.bold);
    return Container(
      padding: EdgeInsets.only(left: 12, right: 12, top: 8),
      color: Colors.white,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "THÔNG TIN MÁY IN",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Divider(),
            TextFormField(
              controller: _nameController,
              style: _textStyle,
              decoration: InputDecoration(
                  labelText: "Đặt tên cho máy in", hintText: "VD: Máy in bill"),
              validator: (value) {
                if (value.isEmpty) {
                  return "Vui lòng đặt tên cho máy in";
                }
                return null;
              },
            ),
            TextFormField(
              controller: _ipController,
              style: _textStyle,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                WhitelistingTextInputFormatter(RegExp("[\\d|\.]")),
              ],
              decoration: InputDecoration(
                  labelText: "IP:", hintText: "VD: 192.168.1.100"),
              enabled: _vm.isManual,
              validator: (value) {
                if (value.isEmpty) {
                  return "Vui lòng nhập địa chỉ IP";
                }
                return null;
              },
            ),
            TextFormField(
              controller: _portController,
              style: _textStyle,
              enabled: _vm.isManual,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
              ],
              decoration:
                  InputDecoration(labelText: "Port:", hintText: "VD: 9100"),
              validator: (value) {
                if (value.isEmpty) {
                  return "Vui lòng nhập PORT";
                }
                return null;
              },
            ),
            TextFormField(
              controller: _noteController,
              decoration: InputDecoration(labelText: "Ghi chú:", hintText: ""),
            ),
          ],
        ),
      ),
    );
  }
}
