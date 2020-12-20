import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

void main() {
  test("dart test", () {
    var value = (1234 / 1000).ceil();
    print(value);
  });

  test("dart test tiengViet", () {
    String value = "Châu Tinh Trì";
    print(value.toLowerCase().contains("Trì".toLowerCase()));
  });

  test("rx test", () async {
    BehaviorSubject<String> testController = new BehaviorSubject<String>();

    testController.interval(Duration(seconds: 1)).listen((data) {
      print(data);
    });

    testController.add("1");
    testController.add("2");
    testController.add("3");
    testController.add("4");

    await Future.delayed(Duration(seconds: 100));
  });
}
