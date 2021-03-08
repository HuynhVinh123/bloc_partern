class PrinterDevice {
  PrinterDevice({this.name, this.id, this.type});
  String name;
  int id;
  String type;
}

class LanPrinterDevice extends PrinterDevice {
  LanPrinterDevice(
      {this.ip, this.port = 9100, String name, int id, String type = 'Lan'})
      : super(name: name, id: id, type: type);
  String ip;
  int port;
}

class EscPrinterDevice extends LanPrinterDevice {
  EscPrinterDevice({String ip, int port = 9100, String name, int id})
      : super(name: name, id: id, type: 'EscPrinter', ip: ip, port: port);
}

class TPosPrinterDevice extends LanPrinterDevice {
  TPosPrinterDevice({String ip, int port = 8123, String name, int id})
      : super(name: name, id: id, type: 'TPosPrinter', ip: ip, port: port);
}

class BluetoothPrinterDevice {}

/// TODO Create print manager
