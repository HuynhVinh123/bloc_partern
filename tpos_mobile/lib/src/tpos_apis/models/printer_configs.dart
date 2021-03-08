import 'package:tpos_mobile/src/tpos_apis/models/printer_config_other.dart';

class PrinterConfig {
  PrinterConfig(
      {this.code,
      this.name,
      this.template,
      this.printerId,
      this.printerName,
      this.ip,
      this.port,
      this.note,
      this.fontSize,
      this.noteHeader,
      this.isUseCustom,
      this.isPrintProxy,
      this.others});

  PrinterConfig.fromJson(Map<String, dynamic> jsonMap) {
    code = jsonMap["Code"];
    name = jsonMap["Name"];
    template = jsonMap["Template"];
    printerId = jsonMap["PrinterId"];
    printerName = jsonMap["PrinterName"];
    ip = jsonMap["Ip"];
    port = jsonMap["Port"];
    note = jsonMap["Note"];
    fontSize = jsonMap["FontSize"];
    noteHeader = jsonMap["NoteHeader"];
    isUseCustom = jsonMap["IsUseCustom"];
    isPrintProxy = jsonMap["IsPrintProxy"];

    if (jsonMap["Others"] != null) {
      others = (jsonMap["Others"] as List)
          .map((f) => PrinterConfigOther.fromJson(f))
          .toList();
    }
  }
  String code;
  String name;
  String template;
  int printerId;
  String printerName;
  String ip;
  String port;
  String note;
  String fontSize;
  String noteHeader;
  bool isUseCustom;
  bool isPrintProxy;
  List<PrinterConfigOther> others;

  Map<String, dynamic> toJson() {
    return {
      "Code": code,
      "Name": name,
      "Template": template,
      "PrinterId": printerId,
      "PrinterName": printerName,
      "Ip": ip,
      "Port": port,
      "Note": note,
      "NoteHeader": noteHeader,
      "IsUseCustom": isUseCustom,
      "IsPrintProxy": isPrintProxy,
      "Others": others != null ? others.map((f) => f.toJson()).toList() : null,
    };
  }
}
