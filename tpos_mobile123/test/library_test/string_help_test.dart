import "package:test/test.dart";
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/helpers/string_helper.dart';
import 'package:tpos_mobile/helpers/tmt.dart';
import 'package:tpos_mobile/src/number_to_text/number_to_text.dart';

void main() {
  test("getPhoneNumberTest", () {
    List<MapEntry<String, String>> testTexts = <MapEntry<String, String>>[
      new MapEntry("56 0379000555", "0379000555"),
      new MapEntry("Size 12 /0978.505.333", "0978505333"),
      new MapEntry("2 cái +841675666888", "+841675666888"),
      new MapEntry("2 cái +", ""),
      new MapEntry("20/  1c /0332211991 💕💕💕💕 cđr", "0332211991"),
      new MapEntry("0332211991💕💕💕💕 cđr", "0332211991"),
      new MapEntry("03o7264329", "0307264329"),
      new MapEntry("03o7264i29", "0307264129"),
      new MapEntry("03O7264I29", "0307264129")
    ];

    testTexts.forEach((f) {
      String phone = getPhoneNumber(f.key);
      print(phone);
      expect(phone, f.value);
    });
  });

  test("Tmt.convertToDoubleTest", _convertToDoubleTest);
  test("Tmt.convertStringToDateTimeTest", _convertStringToDatetimeTest);
  test("NumberToText.numberToTextTest", _testNumberToText);
  test("NumberToWork", () {
    double value = 960000;
    print(value);
    String number = convertNumberToWord(value.toInt().toString());
    print(number);
  });
  test("compareVersionStringTest", _compareVersionTest);
}

_convertToDoubleTest() {
  List<StringToDoubleTest> inputs = [
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
    double value = App.convertToDouble(f.input, f.locate);
    expect(value, equals(f.value));
    print(value);
  });
}

_convertStringToDatetimeTest() {
  List<MapEntry<String, DateTime>> testTexts = <MapEntry<String, DateTime>>[
    new MapEntry(
        "2019-06-05T17:27:40+07:00", new DateTime(2019, 6, 5, 17, 27, 40)),
    new MapEntry("2019-06-06T02:20:34.687+07:00",
        new DateTime(2019, 6, 6, 2, 20, 34, 687)),
    new MapEntry("2019-06-06T10:48:08.044444+08:00",
        new DateTime(2019, 6, 6, 10, 48, 08, 044, 444)),
    new MapEntry("2019-06-06T10:48:08.044444-08:00",
        new DateTime(2019, 6, 6, 10, 48, 08, 044, 444)),
    new MapEntry(
        "2019-06-06T10:48:08-08:00", new DateTime(2019, 6, 6, 10, 48, 08)),
  ];

  testTexts.forEach(
    (f) {
      print("${f.key}=> ${f.value.toString()}");
      DateTime result = DateTime.parse(f.key).toLocal();
      print(result.toString());
      print(result.toUtc().toIso8601String());
      // expect(result, equals(f.value));
    },
  );
}

_testNumberToText() async {
  List<MapEntry<int, String>> testNumbers = <MapEntry<int, String>>[
    new MapEntry(1, "một"),
    new MapEntry(2, "hai"),
    new MapEntry(3, "ba"),
    new MapEntry(4, "bốn"),
    new MapEntry(5, "năm"),
    new MapEntry(6, "sáu"),
    new MapEntry(7, "bảy"),
    new MapEntry(8, "tám"),
    new MapEntry(9, "chín"),
    new MapEntry(10, "mười"),
    new MapEntry(11, "mười một"),
    new MapEntry(12, "mười hai"),
    new MapEntry(13, "mười ba"),
    new MapEntry(14, "mười bốn"),
    new MapEntry(15, "mười lăm"),
    new MapEntry(16, "mười sáu"),
    new MapEntry(17, "mười bảy"),
    new MapEntry(18, "mười tám"),
    new MapEntry(19, "mười chín"),
    new MapEntry(20, "hai mươi"),
    new MapEntry(100, "một trăm"),
    new MapEntry(1000, "một ngàn"),
    new MapEntry(1000, "một ngàn"),
    new MapEntry(10000, "mười ngàn"),
    new MapEntry(100000, "một trăm ngàn"),
    new MapEntry(1000000, "một triệu"),
    new MapEntry(100000000, "một trăm triệu"),
    new MapEntry(100000000, "một tỷ"),
    new MapEntry(13578921,
        "mười ba triệu năm trăm bảy mươi tám nghìn chín trăm hai mươi mốt"),
  ];

  for (var check in testNumbers) {
    var value = convertNumberToWord(check.key.toString());
    print("${check.key}: $value: ${check.value}");
  }
}

_compareVersionTest() async {
  List<MultiValueTestModel> testValues = [
    MultiValueTestModel(value1: "1.3.5", value2: "1.3.6", value3: false),
    MultiValueTestModel(value1: "1.3", value2: "1.4", value3: false),
    MultiValueTestModel(value1: "1.4", value2: "1.4.1", value3: false),
    MultiValueTestModel(value1: "1.6.0", value2: "1.4", value3: true),
    MultiValueTestModel(value1: "1.6.2", value2: "1.6.10", value3: false),
  ];

  for (var itm in testValues) {
    bool result = compareVersion(itm.value1, itm.value2);
    expect(result, itm.value3);
    print(
        "test compareVersion ${itm.value1} with ${itm.value2}:  result: $result (${result == itm.value3 ? "Success" : "Fail"})");
  }
}

class StringToDoubleTest {
  final String input;
  final String locate;
  final double value;

  StringToDoubleTest(this.input, this.locate, this.value);
}

class MultiValueTestModel {
  dynamic value1;
  dynamic value2;
  dynamic value3;
  dynamic value4;
  MultiValueTestModel({this.value1, this.value2, this.value3, this.value4});
}
