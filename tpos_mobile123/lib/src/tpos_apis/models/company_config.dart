
import 'package:tpos_mobile/src/tpos_apis/models/printer_configs.dart';

class CompanyConfig {
  String odataContext;
  String id;
  int defaultPrinterId;
  String defaultPrinterName;
  String defaultPrinterTemplate;
  int companyId;
  String companyName;
  List<PrinterConfig> printerConfigs;

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
      printerConfigs = new List<PrinterConfig>();
      json['PrinterConfigs'].forEach((v) {
        printerConfigs.add(new PrinterConfig.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['@odata.context'] = this.odataContext;
    data['Id'] = this.id;
    data['DefaultPrinterId'] = this.defaultPrinterId;
    data['DefaultPrinterName'] = this.defaultPrinterName;
    data['DefaultPrinterTemplate'] = this.defaultPrinterTemplate;
    data['CompanyId'] = this.companyId;
    data['CompanyName'] = this.companyName;
    if (this.printerConfigs != null) {
      data['PrinterConfigs'] =
          this.printerConfigs.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
