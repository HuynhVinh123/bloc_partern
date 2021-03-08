import 'package:logging/logging.dart';
import 'package:test/test.dart';

void main() {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen(
    (record) {
      print(
          '${record.level.name}: ${record.time}| ${record.loggerName} | message:  ${record.message} ${record.error != null ? "|error: " + record.error.toString() : ""} ${record.stackTrace != null ? "\n|||||stackTrace>>>>>>>>>: " + record.stackTrace.toString() : ""}');
    },
  );

  test("getFastSaleOrderDefaultTest", _getFastSaleOrderDefault);
  test("getFastSaleOrderPrintDataAsHtml", _getFastSaleOrderPrintDataAsHtml);
  test("getCompanyPrinterConfig", _getCompanyConfigTest);
  test("saveCompanyConfigTest", _saveCompanyConfigTest);
  test("getMailTemplatesTest", _getMailTemplatesTest);
}

Future _getFastSaleOrderDefault() async {}

Future _getFastSaleOrderPrintDataAsHtml() async {
  // var content = await tposApi.getFastSaleOrderPrintDataAsHtml(
  //     fastSaleOrderId: 4026, carrierId: 2, type: "ship");
  // print(content);
}

Future _getCompanyConfigTest() async {
//  var config = await tposApi.getCompanyConfig();
//  expect(config, isNotNull);
//  expect(config.printerConfigs, isNotNull);
//  expect(config.printerConfigs.length, equals(11));
}

Future _saveCompanyConfigTest() async {
//  var config = await tposApi.getCompanyConfig();
//  var saveConfig = await tposApi.saveCompanyConfig(config);
//
//  expect(config, isNotNull);
//  expect(saveConfig, isNotNull);
//  expect(saveConfig.printerConfigs.length, saveConfig.printerConfigs.length);
}

Future _getMailTemplatesTest() async {}
