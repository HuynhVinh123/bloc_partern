import 'package:tpos_mobile/feature_group/sale_online/models/app_models/printer_type.dart';

/// Danh sách loại máy in khả dụng
List<PrinterType> appSupportPrinterType = [
  PrinterType(
      code: "tpos_printer",
      port: 8123,
      name: "Ứng dụng TPosPrinter trên windows",
      description: "Thông qua phần mềm in trên máy tính"),
  PrinterType(
      code: "esc_pos",
      port: 9100,
      name: "Máy in bill ESC/POS",
      description: "Máy in hóa đơn/ bill 80, 57mm"),
];
