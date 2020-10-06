import 'package:flutter_test/flutter_test.dart';
import 'package:tmt_flutter_untils/sources/json_convert/JsonConvert.dart';
import 'package:tpos_api_client/src/json_convert.dart';
import 'package:tpos_api_client/src/models/entities/sale_online_order.dart';

class _TestObject {
  _TestObject({this.name, this.id});
  String name;
  String id;
  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }

  _TestObject.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }
}

void main() {
  test('jsonConvert<T> test', () {
    final Map<String, dynamic> json = {'name': "Nguyen Van Nam", 'id': "1"};

    JsonConvert convert = JsonConvert(
      configs: {
        _TestObject: (a) => _TestObject.fromJson(json),
      },
    );

    final _TestObject objectValue = convert.deserialize<_TestObject>(json);

    expect(objectValue, isNotNull);
    expect(objectValue.name, 'Nguyen Van Nam');
    expect(objectValue.id, '1');
  });
}
