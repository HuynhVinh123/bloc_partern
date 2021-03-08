import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

void main() {
  test("dart test", () {
    final value = (1234 / 1000).ceil();
    print(value);
  });

  test("dart test tiengViet", () {
    const String value = "Châu Tinh Trì";
    print(value.toLowerCase().contains("Trì".toLowerCase()));
  });

  test("rx test", () async {
    final BehaviorSubject<String> testController = BehaviorSubject<String>();

    testController.interval(const Duration(seconds: 1)).listen((data) {
      print(data);
    });

    testController.add("1");
    testController.add("2");
    testController.add("3");
    testController.add("4");

    await Future.delayed(const Duration(seconds: 100));
  });
}
