import 'package:tpos_mobile/src/tpos_apis/services/object_apis/product_template_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_api.dart';

ITposApiService getTposApi() {
  DateTime d1 = DateTime(2019, 09, 01);
  DateTime d2 = DateTime.now();

  var d = d2.difference(d1);
  print(d);
}
