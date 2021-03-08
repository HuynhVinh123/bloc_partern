import 'package:nam_esc_pos_printer/nam_esc_pos_printer.dart';

class PrinterDevice {
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
    _isImageRasterPrint = isImageRasterImage;
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
    overideSetting = json['overideSeting'] ?? false;
    pc1258CodePage = json['pc1258CodePage']?.toInt();
  }
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
    final Printer printer = Printer();
    try {
      await printer.connect(host: ip, port: port);
      printer.printAllCodeTable();
      printer.cut();
    } catch (e) {
      print(e);
    } finally {
      printer.disconnect();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["name"] = name;
    data["ip"] = ip;
    data["port"] = port;
    data["type"] = type;
    data["note"] = note;
    data["isDefault"] = isDefault;
    data["profileName"] = profileName;
    data["isImageRasterPrint"] = isImageRasterPrint;
    data['packetSize'] = packetSize;
    data['delayTimeMs'] = delayTimeMs;
    data['delayBeforeDisconnectMs'] = delayBeforeDisconnectMs;
    data['overideSeting'] = overideSetting;
    data['pc1258CodePage'] = pc1258CodePage;
    return data;
  }
}
