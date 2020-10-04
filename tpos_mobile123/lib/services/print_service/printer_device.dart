import 'package:nam_esc_pos_printer/nam_esc_pos_printer.dart';

class PrinterDevice {
  String name;
  String ip;
  int port;
  String type;
  String note;
  bool isDefault = false;
  String profileName = "default";
  bool _isImageRasterPrint = false;
  bool get isImageRasterPrint => _isImageRasterPrint ?? false;
  set isImageRasterPrint(bool value) {
    _isImageRasterPrint = value;
  }

  int packetSize = 64000;
  int delayTimeMs = 999;
  int delayBeforeDisconnectMs = 0;
  int pc1258CodePage = 27;
  bool overideSetting = false;

  Future<void> printTestFont() async {
    Printer printer = new Printer();
    try {
      await printer.connect(host: this.ip, port: this.port);
      printer.printAllCodeTable();
      printer.cut();
    } catch (e, s) {} finally {
      printer.disconnect();
    }
  }

  PrinterDevice(
      {this.name,
      this.ip,
      this.port,
      this.type,
      this.note,
      this.isDefault = false,
      this.profileName = "default",
      bool isImageRasterImage = false,
      this.packetSize = 64000,
      this.delayTimeMs = 999,
      this.delayBeforeDisconnectMs = 0,
      this.pc1258CodePage = 27,
      this.overideSetting}) {
    this._isImageRasterPrint = isImageRasterImage;
  }

  PrinterDevice.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    ip = json["ip"];
    port = json["port"];
    type = json["type"];
    note = json["note"];
    isDefault = json["isDefault"];
    profileName = json["profileName"];
    isImageRasterPrint = json["isImageRasterPrint"];
    packetSize = json['packetSize']?.toInt();
    delayTimeMs = json['delayTimeMs']?.toInt();
    delayBeforeDisconnectMs = json['delayBeforeDisconnectMs']?.toInt();
    overideSetting = json['overideSetting'] ?? false;
    pc1258CodePage = json['pc1258CodePage']?.toInt();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data["name"] = this.name;
    data["ip"] = this.ip;
    data["port"] = this.port;
    data["type"] = this.type;
    data["note"] = this.note;
    data["isDefault"] = this.isDefault;
    data["profileName"] = this.profileName;
    data["isImageRasterPrint"] = this.isImageRasterPrint;
    data['packetSize'] = this.packetSize;
    data['delayTimeMs'] = this.delayTimeMs;
    data['delayBeforeDisconnectMs'] = this.delayBeforeDisconnectMs;
    data['overideSeting'] = this.overideSetting;
    data['pc1258CodePage'] = this.pc1258CodePage;
    return data;
  }
}
