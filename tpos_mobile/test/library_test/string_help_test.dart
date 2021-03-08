import "package:test/test.dart";
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/helpers/string_helper.dart';
import 'package:tpos_mobile/helpers/tmt.dart';
import 'package:tpos_mobile/src/number_to_text/number_to_text.dart';

void main() {
  test("getPhoneNumberTest", () {
    const List<MapEntry<String, String>> testTexts = <MapEntry<String, String>>[
      MapEntry("56 0379000555", "0379000555"),
      MapEntry("Size 12 /0978.505.333", "0978505333"),
      MapEntry("2 cái +841675666888", "+841675666888"),
      MapEntry("2 cái +", ""),
      MapEntry("20/  1c /0332211991 💕💕💕💕 cđr", "0332211991"),
      MapEntry("0332211991💕💕💕💕 cđr", "0332211991"),
      MapEntry("03o7264329", "0307264329"),
      MapEntry("03o7264i29", "0307264129"),
      MapEntry("03O7264I29", "0307264129")
    ];

    testTexts.forEach((f) {
      final String phone = getPhoneNumber(f.key);
      print(phone);
      expect(phone, f.value);
    });
  });

  test("Tmt.convertToDoubleTest", _convertToDoubleTest);
  test("Tmt.convertStringToDateTimeTest", _convertStringToDatetimeTest);
  test("NumberToText.numberToTextTest", _testNumberToText);
  test("NumberToWork", () {
    const double value = 960000;
    print(value);
    final String number = convertNumberToWord(value.toInt().toString());
    print(number);
  });
  test("compareVersionStringTest", _compareVersionTest);
}

void _convertToDoubleTest() {
  final List<StringToDoubleTest> inputs = [
    StringToDoubleTest(null, "vi_VN", 0.0),
    StringToDoubleTest("", "vi_VN", 0.0),
    StringToDoubleTest("0", "vi_VN", 0.0),
    StringToDoubleTest("1000", "vi_VN", 1000.0),
    StringToDoubleTest("1.000", "vi_VN", 1000.0),
    StringToDoubleTest("1000,01", "vi_VN", 1000.01),
    StringToDoubleTest("1.000,01", "vi_VN", 1000.01),
    StringToDoubleTest("10000.01", "en_US", 10000.01),
    StringToDoubleTest("1,000,000", "en_US", 1000000.00),
  ];

  inputs.forEach((f) {
    final double value = App.convertToDouble(f.input, f.locate);
    expect(value, equals(f.value));
    print(value);
  });
}

_convertStringToDatetimeTest() {
  final List<MapEntry<String, DateTime>> testTexts =
      <MapEntry<String, DateTime>>[
    MapEntry("2019-06-05T17:27:40+07:00", DateTime(2019, 6, 5, 17, 27, 40)),
    MapEntry(
        "2019-06-06T02:20:34.687+07:00", DateTime(2019, 6, 6, 2, 20, 34, 687)),
    MapEntry("2019-06-06T10:48:08.044444+08:00",
        DateTime(2019, 6, 6, 10, 48, 08, 044, 444)),
    MapEntry("2019-06-06T10:48:08.044444-08:00",
        DateTime(2019, 6, 6, 10, 48, 08, 044, 444)),
    MapEntry("2019-06-06T10:48:08-08:00", DateTime(2019, 6, 6, 10, 48, 08)),
  ];

  testTexts.forEach(
    (f) {
      print("${f.key}=> ${f.value.toString()}");
      final DateTime result = DateTime.parse(f.key).toLocal();
      print(result.toString());
      print(result.toUtc().toIso8601String());
      // expect(result, equals(f.value));
    },
  );
}

_testNumberToText() async {
  final List<MapEntry<int, String>> testNumbers = <MapEntry<int, String>>[
    const MapEntry(1, "một"),
    const MapEntry(2, "hai"),
    const MapEntry(3, "ba"),
    const MapEntry(4, "bốn"),
    const MapEntry(5, "năm"),
    const MapEntry(6, "sáu"),
    const MapEntry(7, "bảy"),
    const MapEntry(8, "tám"),
    const MapEntry(9, "chín"),
    const MapEntry(10, "mười"),
    const MapEntry(11, "mười một"),
    const MapEntry(12, "mười hai"),
    const MapEntry(13, "mười ba"),
    const MapEntry(14, "mười bốn"),
    const MapEntry(15, "mười lăm"),
    const MapEntry(16, "mười sáu"),
    const MapEntry(17, "mười bảy"),
    const MapEntry(18, "mười tám"),
    const MapEntry(19, "mười chín"),
    const MapEntry(20, "hai mươi"),
    const MapEntry(100, "một trăm"),
    const MapEntry(1000, "một ngàn"),
    const MapEntry(1000, "một ngàn"),
    const MapEntry(10000, "mười ngàn"),
    const MapEntry(100000, "một trăm ngàn"),
    const MapEntry(1000000, "một triệu"),
    const MapEntry(100000000, "một trăm triệu"),
    const MapEntry(100000000, "một tỷ"),
    const MapEntry(13578921,
        "mười ba triệu năm trăm bảy mươi tám nghìn chín trăm hai mươi mốt"),
  ];

  for (final check in testNumbers) {
    final value = convertNumberToWord(check.key.toString());
    print("${check.key}: $value: ${check.value}");
  }
}

void _compareVersionTest() {
  final List<MultiValueTestModel> testValues = [
    MultiValueTestModel(value1: "1.3.5", value2: "1.3.6", value3: false),
    MultiValueTestModel(value1: "1.3", value2: "1.4", value3: false),
    MultiValueTestModel(value1: "1.4", value2: "1.4.1", value3: false),
    MultiValueTestModel(value1: "1.6.0", value2: "1.4", value3: true),
    MultiValueTestModel(value1: "1.6.2", value2: "1.6.10", value3: false),
  ];

  for (final itm in testValues) {
    final bool result = compareVersion(itm.value1, itm.value2);
    expect(result, itm.value3);
    print(
        "test compareVersion ${itm.value1} with ${itm.value2}:  result: $result (${result == itm.value3 ? "Success" : "Fail"})");
  }
}

class StringToDoubleTest {
  StringToDoubleTest(this.input, this.locate, this.value);
  final String input;
  final String locate;
  final double value;
}

class MultiValueTestModel {
  MultiValueTestModel({this.value1, this.value2, this.value3, this.value4});
  dynamic value1;
  dynamic value2;
  dynamic value3;
  dynamic value4;
}
