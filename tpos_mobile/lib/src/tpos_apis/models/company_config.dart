import 'package:tpos_mobile/src/tpos_apis/models/printer_configs.dart';

class CompanyConfig {
  CompanyConfig(
      {this.odataContext,
      this.id,
      this.defaultPrinterId,
      this.defaultPrinterName,
      this.defaultPrinterTemplate,
      this.companyId,
      this.companyName,
      this.printerConfigs});

  CompanyConfig.fromJson(Map<String, dynamic> json) {
    odataContext = json['@odata.context'];
    id = json['Id'];
    defaultPrinterId = json['DefaultPrinterId'];
    defaultPrinterName = json['DefaultPrinterName'];
    defaultPrinterTemplate = json['DefaultPrinterTemplate'];
    companyId = json['CompanyId'];
    companyName = json['CompanyName'];
    if (json['PrinterConfigs'] != null) {
      printerConfigs = <PrinterConfig>[];
      json['PrinterConfigs'].forEach((v) {
        printerConfigs.add(PrinterConfig.fromJson(v));
      });
    }
  }

  String odataContext;
  String id;
  int defaultPrinterId;
  String defaultPrinterName;
  String defaultPrinterTemplate;
  int companyId;
  String companyName;
  List<PrinterConfig> printerConfigs;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['@odata.context'] = odataContext;
    data['Id'] = id;
    data['DefaultPrinterId'] = defaultPrinterId;
    data['DefaultPrinterName'] = defaultPrinterName;
    data['DefaultPrinterTemplate'] = defaultPrinterTemplate;
    data['CompanyId'] = companyId;
    data['CompanyName'] = companyName;
    if (printerConfigs != null) {
      data['PrinterConfigs'] = printerConfigs.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
