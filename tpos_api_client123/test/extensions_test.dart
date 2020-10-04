import 'package:flutter_test/flutter_test.dart';
import 'package:tpos_api_client/src/extensions.dart';

void main() {
  test('convert Future to object', () async {
    var object =
        await _TestFuture().toObject((json) => _TestObject.fromJson(json));
    print(object.a);
  });
}

Future<Map<String, dynamic>> _TestFuture() async {
  final Map<String, dynamic> json = <String, dynamic>{'a': "a", 'b': 'b'};
  await Future.delayed(Duration(seconds: 1));
  return json;
}

class _TestObject {
  String a;
  String b;

  _TestObject({this.a, this.b});

  _TestObject.fromJson(Map<String, dynamic> json) {
    a = json['a'];
    b = json['b'];
  }
}
