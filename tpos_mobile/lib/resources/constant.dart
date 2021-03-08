import 'package:tpos_mobile/services/print_service/printer_device.dart';

class Const {
  Const._();
  static const double boxBorderRadius = 5.0;
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing48 = 48.0;

  /// Get the list of default printer devices.
  static List<PrinterDevice> get defaultPrinterDevices => <PrinterDevice>[
        PrinterDevice(
            type: "preview",
            ip: "null",
            port: null,
            name: "Xem và in",
            isDefault: true),
        PrinterDevice(
            type: "tpos_printer",
            ip: "192.168.1.22",
            port: 8123,
            name: "TPos Printer (In qua máy tính)",
            isDefault: true),
        PrinterDevice(
            type: "esc_pos",
            ip: "192.168.1.222",
            port: 9100,
            name: "Máy ESC/POS (In qua Wifi)",
            isDefault: true),
      ];

  /// Get the list of support printer profiles.
  static const supportPrinterProfiles = {
    "sale_online": {
      "tpos_printer": [
        {"code": "A5Portrait", "name": "A5 dọc"},
        {"code": "A4Portrait", "name": "A4 dọc"},
        {"code": "BILL80", "name": "BILL 80mm"},
      ]
    },
    "ship": {
      "tpos_printer": [
        {"code": "A5Portrait", "name": "A5 dọc"},
        {"code": "A4Portrait", "name": "A4 dọc"},
        {"code": "BILL80", "name": "BILL 80mm"},
      ],
      "esc_pos": [
        {"code": "BILL80", "name": "BILL 80mm (Raw-nhanh)"},
        {"code": "BILL80-IMAGE", "name": "BILL 80mm (Đẹp hơn-chậm)"},
      ],
      "preview": [
        {"code": "AUTO", "name": "Tự động"},
        {"code": "BILL80", "name": "BILL80"},
        {"code": "A5", "name": "A5"},
        {"code": "A4", "name": "A4"},
      ],
    },
    "fast_sale_order": {
      "preview": [
        {"code": "AUTO", "name": "Tự động"},
        {"code": "A5", "name": "A5"},
        {"code": "A4", "name": "A4"},
      ],
      "tpos_printer": [
        {"code": "BILL80", "name": "BILL 80mm"},
        {"code": "A5Lanscape", "name": "A5 ngang"},
        {"code": "A4Portrait", "name": "A4 dọc"},
      ],
      "esc_pos": [
        {"code": "BILL80", "name": "BILL 80mm (Raw-nhanh)"},
        {"code": "BILL80-IMAGE", "name": "BILL 80mm (Đẹp hơn-chậm)"},
      ],
    },
    "pos_order": {
      "tpos_printer": [
        {"code": "A5Portrait", "name": "A5 dọc"},
        {"code": "A4Portrait", "name": "A4 dọc"},
        {"code": "BILL80", "name": "BILL 80mm"},
      ],
      "esc_pos": [
        {"code": "BILL80", "name": "BILL 80mm (Raw-nhanh)"},
        {"code": "BILL80-IMAGE", "name": "BILL 80mm (Đẹp hơn-chậm)"},
      ],
      "preview": [
        {"code": "AUTO", "name": "Tự động"},
        {"code": "BILL80", "name": "BILL80"},
        {"code": "A5", "name": "A5"},
        {"code": "A4", "name": "A4"},
      ],
    },
  };
}
