// import 'package:flutter/material.dart';
// import 'package:logging/logging.dart';
// import 'package:test/test.dart';
// import 'package:tpos_mobile/feature_group/fast_sale_order/viewmodels/fast_sale_order_add_edit_full_viewmodel.dart';
// import 'package:tpos_mobile/services/app_setting_service.dart';
//
// import 'package:tpos_mobile/src/tpos_apis/services/tpos_api.dart';
//
//
// var _vm = new FastSaleOrderAddEditFullViewModel(
//     tposApi: _sv, setting: AppSettingService());
// void main() {
//   Logger.root.level = Level.ALL; // defaults to Level.INFO
//   Logger.root.onRecord.listen(
//     (record) {
//       debugPrint(
//           '${record.level.name}: ${record.time}| ${record.loggerName} | message:  ${record.message} ${record.error != null ? "|error: " + record.error.toString() : ""} ${record.stackTrace != null ? "\n|||||stackTrace>>>>>>>>>: " + record.stackTrace.toString() : ""}');
//     },
//   );
//
//   test("viewmodelInitTest", _viewModelInitCommandTest);
//   test("viewmodelInitTest1", _viewModelInitCommandForCreateFromSaleOnlneTest);
// }
//
// /// Test khởi tạo giá  trị mặc định form nhập liệu tạo hóa đơn bán hàng nhanh
// /// Khởi tạo mới
// /// Khởi tạo để sửa
// /// Khởi tạo từ đơn hàng facebook
// Future _viewModelInitCommandTest() async {
//   // Init create new
//   _vm.init();
//   await _vm.initCommand();
//   expect(_vm.order, isNot(Null));
//   expect(_vm.partner == null, true);
//   expect(_vm.user != null, true);
//   expect(_vm.carrier == null, true);
//   expect(_vm.paymentJournal != null, true);
//   expect(_vm.wareHouse != null, true);
//   expect(_vm.priceList == null, true);
//
//   int testId = 40235;
//   // init for edit
//   _vm.init(editOrderId: 40235);
//   await _vm.initCommand();
//   expect(_vm.order, isNot(Null));
//   expect(_vm.order.id, equals(testId));
//   expect(_vm.order.amountTotal, equals(423000));
//   expect(_vm.company.id, equals(1));
//   expect(_vm.journal.id, equals(3));
//   expect(_vm.partner.id, equals(46841));
//   expect(_vm.user != null, true);
//   expect(_vm.carrier == null, true);
//   expect(_vm.paymentJournal.id, equals(1));
//   expect(_vm.priceList.id, equals(3));
//   expect(_vm.wareHouse.id, equals(1));
//   // init for create invoice from order
// }
//
// Future _viewModelInitCommandForCreateFromSaleOnlneTest() async {
//   _vm = new FastSaleOrderAddEditFullViewModel(
//       tposApi: _sv, setting: AppSettingService());
//   _vm.init(saleOnlineIds: [
//     "6b204afc-0281-e911-b803-00155dd69a40",
//     "b32c2472-6880-e911-b803-00155dd69a40",
//     "d93cd844-3d7c-e911-b803-00155dd69a40",
//   ], partnerId: 30232);
//   await _vm.initCommand();
//   expect(_vm.order != null, true);
//   expect(_vm.order.id, equals(0));
//   expect(_vm.company.id, equals(1));
//   expect(_vm.journal.id, equals(3));
//   expect(_vm.partner.id, equals(30232));
//   expect(_vm.user != null, true);
//   expect(_vm.carrier == null, true);
//   expect(_vm.paymentJournal.id, equals(1));
//   expect(_vm.wareHouse.id, equals(1));
//   expect(_vm.orderLines.length, equals(1));
// }