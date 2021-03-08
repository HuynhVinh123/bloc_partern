import 'package:test/test.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/setting_company_printer_viewmodel.dart';

void main() {
  _vm = SettingCompanyPrinterViewModel();
  test("initTest", _initTest);
}

SettingCompanyPrinterViewModel _vm;

Future _initTest() async {
  _vm.init();
  expect(_vm.config, isNotNull);
}
