import 'package:test/test.dart';
import 'package:tpos_mobile/models/enums/font_scale.dart';

void main() {
  test('fromJson should be done with valid data', () {
    final Map<String, dynamic> json = <String, dynamic>{
      'printerConfig_invoiceFontScale': FontScale.scale100,
      'printerConfig_invoicePrinterName': 'Xem và in',
      'printerConfig_InvoicePaperSize': 'BILL80-IMAGE',
    };
  });
  test('toJson should be done with valid data', () {});
}
