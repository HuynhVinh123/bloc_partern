/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 7/5/19 4:54 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 7/5/19 3:49 PM
 *
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:nam_esc_pos_printer/nam_esc_pos_printer.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/feature_group/settings/setting_printer_add_printer_page.dart';

import 'package:tpos_mobile/services/app_setting_service.dart';

import 'package:tpos_mobile/services/print_service/printer_device.dart';

import 'package:tpos_mobile/helpers/helpers.dart' as help;
import 'package:tpos_mobile/widgets/form_field/input_number_field.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class SettingPrinterListPage extends StatefulWidget {
  final String selectedPrinterName;
  final bool isSelectPage;
  SettingPrinterListPage({this.selectedPrinterName, this.isSelectPage = false});
  @override
  _SettingPrinterListPageState createState() => _SettingPrinterListPageState();
}

class _SettingPrinterListPageState extends State<SettingPrinterListPage> {
  final _setting = locator<ISettingService>();

  List<PrinterDevice> _printers;
  @override
  void initState() {
    _printers = _setting.printers;

    super.initState();
  }

  Future _addPrinter() async {
    var printer = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => SettingPrinterAddPrinter()));

    if (printer != null) {
      _printers.add(printer);
      _setting.printers = _printers;
    }
  }

  PrinterProfile _selectedProfile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.config_printers),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              _addPrinter();
            },
          )
        ],
      ),
      body: GestureDetector(
        child: _buildBody(),
        onTap: () {
          FocusScope.of(context)?.requestFocus(FocusNode());
        },
      ),
    );
  }

  Widget _buildBody() {
    if (_printers.isEmpty) {
      return Container(
        padding: const EdgeInsets.only(left: 10, top: 30, right: 10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const Text(
                "Chưa có máy in nào trong danh sách",
                textAlign: TextAlign.center,
              ),
              FlatButton(
                textColor: Colors.blue,
                child: Text("Nhấp để thêm"),
                onPressed: () {
                  _addPrinter();
                },
              )
            ]),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (widget.isSelectPage)
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey.shade200,
            child: Text(
              "Vui lòng chọn một trong các máy in sau:",
              style: const TextStyle(
                color: Colors.green,
                fontSize: 17,
              ),
            ),
          ),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return Divider(
                height: 2,
              );
            },
            itemBuilder: (context, index) {
              return _buildItem(_printers[index]);
            },
            itemCount: _printers.length,
          ),
        ),
      ],
    );
  }

  Widget _buildItem(PrinterDevice item) {
    return ListTile(
      leading: Icon(
        Icons.local_printshop,
        color: Colors.blue,
      ),
      title: Text(item.name),
      subtitle: Text("${item.ip} (port: ${item.port})"),
      trailing: PopupMenuButton(
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              child: Text("Sửa"),
              value: "edit",
            ),
            PopupMenuItem(
              enabled: !item.isDefault,
              child: Text("Xóa"),
              value: "delete",
            ),
          ];
        },
        onSelected: (value) async {
          switch (value) {
            case "edit":
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingPrinterEditPrinter(device: item),
                ),
              );

              setState(() {
                _setting.printers = this._printers;
              });
              break;
            case "delete":
              setState(() {
                _printers.remove(item);
                _setting.printers = this._printers;
              });

              break;
          }
        },
      ),
      selected: item.name == widget.selectedPrinterName ?? "",
      onTap: () async {
        if (widget.isSelectPage) {
          Navigator.pop(context, item);
        } else {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SettingPrinterEditPrinter(device: item),
            ),
          );

          setState(() {
            _setting.printers = this._printers;
          });
        }
      },
    );
  }
}

class SettingPrinterEditPrinter extends StatefulWidget {
  final PrinterDevice device;
  SettingPrinterEditPrinter({this.device});

  @override
  _SettingPrinterEditPrinterState createState() =>
      _SettingPrinterEditPrinterState();
}

class _SettingPrinterEditPrinterState extends State<SettingPrinterEditPrinter> {
  final _nameController = new TextEditingController();
  final _ipController = new TextEditingController();
  final _portController = new TextEditingController();
  final _noteController = new TextEditingController();

  final _packetSizeController = MoneyMaskedTextController(
    thousandSeparator: '',
    precision: 0,
    decimalSeparator: '',
  );
  final _delayTimeMsController = MoneyMaskedTextController(
    thousandSeparator: '',
    precision: 0,
    decimalSeparator: '',
  );
  final _deleyBeforeDisconnectController = MoneyMaskedTextController(
    thousandSeparator: '',
    precision: 0,
    decimalSeparator: '',
  );
  final _pc1258CodePageController = MoneyMaskedTextController(
    thousandSeparator: '',
    precision: 0,
    decimalSeparator: '',
  );
  final _formKey = new GlobalKey<FormState>();

  List<PrinterProfile> profiles;
  bool isBusy = true;

  PrinterProfile _selectedProfile;
  @override
  void initState() {
    _nameController.text = widget.device.name;
    _ipController.text = widget.device.ip;
    _portController.text = widget.device.port.toString();
    _noteController.text = widget.device.note;

    _packetSizeController.text = widget.device.packetSize?.toString();
    _delayTimeMsController.text = widget.device.delayTimeMs?.toString();
    _deleyBeforeDisconnectController.text =
        widget.device.delayBeforeDisconnectMs?.toString();

    _pc1258CodePageController
        .updateValue(widget.device.pc1258CodePage?.toDouble() ?? 27);

    // load printer Profile
    ProfileManager().loadProfile(force: false).then((value) {
      profiles = ProfileManager().getProfiles();
      setState(() {
        isBusy = false;
        _selectedProfile = profiles?.firstWhere(
            (element) => element.name == widget.device.profileName,
            orElse: () => null);
      });
    });

    super.initState();
  }

  void _save() {
    widget.device.ip = _ipController.text.trim();
    widget.device.port = int.parse(_portController.text.trim());
    widget.device.name = _nameController.text.trim();
    widget.device.note = _noteController.text.trim();

    widget.device.packetSize = _packetSizeController.text.isNotEmpty
        ? int.parse(_packetSizeController.text)
        : null;
    widget.device.delayTimeMs = _delayTimeMsController.text.isNotEmpty
        ? int.parse(_delayTimeMsController.text)
        : null;
    widget.device.delayBeforeDisconnectMs =
        _deleyBeforeDisconnectController.text.isNotEmpty
            ? int.parse(_deleyBeforeDisconnectController.text)
            : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sửa thông tin máy in"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              _save();
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    var _textStyle = new TextStyle(fontWeight: FontWeight.bold);
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        color: Colors.white,
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                style: _textStyle,
                decoration: InputDecoration(
                    labelText: "Đặt tên cho máy in",
                    hintText: "VD: Máy in bill"),
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
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true, signed: true),
                inputFormatters: [
                  WhitelistingTextInputFormatter(RegExp("[\\d|\.]")),
                ],
                decoration: InputDecoration(
                    labelText: "IP:", hintText: "VD: 192.168.1.100"),
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
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  // FilteringTextInputFormatter.digitsOnly,
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
                decoration:
                    InputDecoration(labelText: "Ghi chú:", hintText: ""),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: Text(
                  'Profile: ',
                ),
              ),
              DropdownButton<PrinterProfile>(
                value: profiles?.firstWhere(
                    (element) => element.name == widget.device.profileName,
                    orElse: () => null),
                isExpanded: true,
                hint: Text("Chọn cấu hình"),
                items: profiles
                    ?.map(
                      (key) => DropdownMenuItem<PrinterProfile>(
                        value: key,
                        child: Text("${key.name}"),
                      ),
                    )
                    ?.toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedProfile = value;
                    widget.device.profileName = value.name;
//                    _packetSizeController.text =
//                        value.bufferSize?.toString() ?? "";
//                    _delayTimeMsController.text =
//                        value.delayBetweenPacket?.toString() ?? "";
//                    _deleyBeforeDisconnectController.text =
//                        value.delayBeforeDisconnect?.toString() ?? "";
                  });
                },
              ),
              Row(
                children: <Widget>[
                  Checkbox(
                    value: widget.device.isImageRasterPrint ?? false,
                    onChanged: (value) {
                      setState(() {
                        widget.device.isImageRasterPrint = value;
                      });
                    },
                  ),
                  Text("Chế độ in hình raster (Chọn nếu bill in ra bị trắng)")
                ],
              ),
              Divider(),
              ExpansionTile(
                title: Text("Cấu hình nâng cao"),
                initiallyExpanded: false,
                children: <Widget>[
                  SwitchListTile(
                    title: Text('Ghi đè các thông số  sau'),
                    value: widget.device.overideSetting ?? false,
                    onChanged: (value) {
                      setState(() {
                        widget.device.overideSetting = value;
                      });
                    },
                  ),
                  const Divider(),
                  _InputNumberField(
                    controller: _packetSizeController,
                    title: 'Package size',
                    defaultValue: 'Default: ${_selectedProfile?.bufferSize}',
                    onTextChanged: (value) {
                      setState(() {
                        widget.device.packetSize =
                            _packetSizeController.numberValue?.toInt();
                      });
                    },
                    onDefaultPressed: () {
                      _packetSizeController.updateValue(
                        _selectedProfile?.bufferSize?.toDouble() ?? 64000,
                      );
                    },
                  ),
                  const Divider(),
                  _InputNumberField(
                    controller: _delayTimeMsController,
                    title: 'Delay per packet ',
                    defaultValue:
                        'Default: ${_selectedProfile?.delayBetweenPacket}',
                    onTextChanged: (value) {
                      setState(() {
                        widget.device.delayTimeMs =
                            _delayTimeMsController.numberValue?.toInt();
                      });
                    },
                    onDefaultPressed: () {
                      _delayTimeMsController.updateValue(
                        _selectedProfile?.delayBetweenPacket?.toDouble() ?? 0,
                      );
                    },
                  ),
                  const Divider(),
                  _InputNumberField(
                    controller: _deleyBeforeDisconnectController,
                    title: 'Delay before disconnect',
                    defaultValue:
                        'Default: ${_selectedProfile?.delayBeforeDisconnect}',
                    onTextChanged: (value) {
                      setState(() {
                        widget.device.delayBeforeDisconnectMs =
                            _deleyBeforeDisconnectController.numberValue
                                ?.toInt();
                      });
                    },
                    onDefaultPressed: () {
                      _deleyBeforeDisconnectController.updateValue(
                        _selectedProfile.delayBeforeDisconnect?.toDouble() ?? 0,
                      );
                    },
                  ),
                  const Divider(),
                  _InputNumberField(
                    controller: _pc1258CodePageController,
                    title: 'PC1258 Code page ',
                    defaultValue:
                        'Default: ${_selectedProfile?.codePages?.firstWhere((element) => element.value == 'CP1258', orElse: () => null)?.key}',
                    onTextChanged: (value) {
                      setState(
                        () {
                          widget.device.pc1258CodePage =
                              _pc1258CodePageController.numberValue?.toInt();
                        },
                      );
                    },
                    onDefaultPressed: () {
                      _pc1258CodePageController.updateValue(_selectedProfile
                          ?.codePages
                          ?.firstWhere((element) => element.value == 'CP1258',
                              orElse: () => null)
                          ?.key
                          ?.toDouble());
                    },
                  ),
                ],
              ),
              FlatButton(
                child: Text("In test font"),
                onPressed: () async {
                  final OldDialogResult result = await help.showQuestion(
                      context: context,
                      title: "Xác nhận",
                      message:
                          "Bạn có muốn in toàn bộ bảng mã. Sẽ tốn khoảng 1 mét giấy :)");

                  if (result == OldDialogResult.Yes) {
                    widget.device.printTestFont();
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                child: RaisedButton(
                  textColor: Colors.white,
                  child: Text("LƯU & ĐÓNG"),
                  onPressed: () {
                    _save();
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _InputNumberField extends StatelessWidget {
  final MoneyMaskedTextController controller;
  final String title;
  final String defaultValue;
  final ValueChanged<String> onTextChanged;
  final VoidCallback onDefaultPressed;

  const _InputNumberField(
      {Key key,
      this.controller,
      this.title,
      this.defaultValue,
      this.onTextChanged,
      this.onDefaultPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InputNumberField(
      controller: controller,
      onTextChanged: onTextChanged,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('$title'),
          ButtonTheme(
            padding: EdgeInsets.only(left: 0, top: 4, bottom: 4),
            child: FlatButton(
              textColor: Colors.blue,
              child: Text('$defaultValue'),
              onPressed: onDefaultPressed,
            ),
          ),
        ],
      ),
    );
  }
}
