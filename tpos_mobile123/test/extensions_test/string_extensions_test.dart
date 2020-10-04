import 'package:test/test.dart';

void main() {
  test('ConvertDateTimeToString OK', () {
    List<MapEntry<String, DateTime>> testTexts = <MapEntry<String, DateTime>>[
      new MapEntry("2020-08-04T11:34:16.7953066+07:00",
          DateTime(2020, 08, 04, 11, 34, 16, 7953066)),
      new MapEntry(
          "2020-08-04T04:43:35.779Z", DateTime(2020, 08, 04, 04, 43, 35, 779)),
    ];

    for (var itm in testTexts) {
      DateTime date = DateTime.parse(itm.key);
      print(date.toIso8601String());
      String str = date.toIso8601String();
      print(str);
    }
  });
  test('ConvertStringToDatetime OK', () {});
}
