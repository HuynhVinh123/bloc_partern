import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/app_models/printer_type.dart';
import 'package:tpos_mobile/services/print_service/network_address.dart';
import 'package:tpos_mobile/services/print_service/printer_device.dart';
import 'package:tpos_mobile/src/static_data/support_printer_type.dart';

class FindIpPrinterPage extends StatefulWidget {
  const FindIpPrinterPage({this.isTposPrinterType = true});
  final bool isTposPrinterType;

  @override
  _FindIpPrinterPageState createState() => _FindIpPrinterPageState();
}

class _FindIpPrinterPageState extends State<FindIpPrinterPage> {
  final _vm = FindIpPrinterViewModel();

  @override
  void initState() {
    if (widget.isTposPrinterType) {
      _vm.selectedPrinterType =
          appSupportPrinterType.firstWhere((f) => f.code == "tpos_printer");
    } else {
      _vm.selectedPrinterType =
          appSupportPrinterType.firstWhere((f) => f.code == "esc_pos");
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<FindIpPrinterViewModel>(
      model: _vm,
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    const _textStyle = TextStyle(fontWeight: FontWeight.bold);
    return SingleChildScrollView(
      child: ScopedModelDescendant<FindIpPrinterViewModel>(
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
                      const Divider(),
                      DropdownButton<PrinterType>(
                        isExpanded: true,
                        value: _vm.selectedPrinterType,
                        onChanged: (selectedType) {
                          setState(() {
                            _vm.selectedPrinterType = selectedType;
                          });
                        },
                        hint: const Text("Chọn loại máy in"),
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
                const SizedBox(
                  height: 10,
                ),
                _buildSelectListLanprinterLayout(),
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
              const Expanded(
                  child: Text(
                "MÁY IN ESC/POS ĐÃ TÌM THẤY:",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              )),
              if (_vm.isDiscovering)
                const SizedBox(
                  child: CircularProgressIndicator(),
                  height: 20,
                  width: 20,
                ),
              if (!_vm.isDiscovering)
                FlatButton.icon(
                  onPressed: () {
                    _vm.discoveryPrinterCommand();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text("Làm mới"),
                )
            ]),
          ),
          const Divider(),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _vm.printers?.length ?? 0,
            itemBuilder: (context, index) {
              return ListTile(
                selected: _vm.selectedPrinterDevice == _vm.printers[index],
                leading: Checkbox(
                    value: _vm.selectedPrinterDevice == _vm.printers[index],
                    onChanged: (value) {
                      _vm.setSelectedPrinterDeviceCommand(_vm.printers[index]);
                      Navigator.pop(context, _vm.selectedPrinterDevice);
                    }),
                title: Text(_vm.printers[index].ip ?? ''),
                onTap: () {
                  _vm.setSelectedPrinterDeviceCommand(_vm.printers[index]);
                  Navigator.pop(context, _vm.selectedPrinterDevice);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class FindIpPrinterViewModel extends ScopedViewModel {
  PrinterType _selectedPrinterType;
  bool isDiscovering = false;
  final List<PrinterDevice> _printers = <PrinterDevice>[];
  PrinterDevice _selectedPrinterDevice;
  PrinterDevice _newDevice;
  bool _isManual = false;

  List<PrinterDevice> get printers => _printers;
  PrinterType get selectedPrinterType => _selectedPrinterType;
  PrinterDevice get selectedPrinterDevice => _selectedPrinterDevice;
  PrinterDevice get newDevice => _selectedPrinterDevice;

  bool get isManual => _isManual;

  set selectedPrinterType(PrinterType value) {
    final oldValue = _selectedPrinterType;
    _selectedPrinterType = value;
    if (value?.code != oldValue?.code) {
      _selectedPrinterDevice = null;
      _newDevice = null;
      _printers.clear();
      discoveryPrinterCommand();
      notifyListeners();
    }
  }

  void discoveryPrinterCommand() {
    if (_selectedPrinterType == null) {
      return;
    }
    if (_selectedPrinterType.code == "esc_pos") {
      _findPrinter(9100);
    }

    if (_selectedPrinterType.code == "tpos_printer") {
      _findPrinter(8123);
    }
  }

  void setSelectedPrinterDeviceCommand(PrinterDevice value) {
    final oldValue = _selectedPrinterDevice;
    _selectedPrinterDevice = value;
    if (value != oldValue) {
      _newDevice ??= PrinterDevice();

      _newDevice.ip = value.ip;
      _newDevice.port = selectedPrinterType.port;
      _isManual = false;
      notifyListeners();
    }
  }

  void setIsManual(bool value) {
    if (value == true) {
      _isManual = value;
      _selectedPrinterDevice = null;
      notifyListeners();
    }
  }

  void _findPrinter(int port) {
    isDiscovering = true;
    _printers.clear();
    final stream = NetworkAnalyzer.discover("192.168.1", port);
    stream.listen((NetworkAddress addr) {
      if (addr.exists) {
        print('Found device: ${addr.ip}');
        _printers.add(PrinterDevice(ip: addr.ip, port: port));
        notifyListeners();
      }
    })
      ..onDone(() {
        // Add Default param
        isDiscovering = false;
        notifyListeners();
      })
      ..onError((dynamic e) {
//        final snackBar = SnackBar(
//            content: Text('Unexpected exception', textAlign: TextAlign.center));
      });
  }
}
