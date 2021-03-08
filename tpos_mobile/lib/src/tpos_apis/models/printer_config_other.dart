import 'package:tpos_mobile/feature_group/sale_online/models/tpos_desktop/print_fast_sale_order_config.dart';

class PrinterConfigOther {
  PrinterConfigOther({this.text, this.key, this.value});
  PrinterConfigOther.fromJson(Map<String, dynamic> json) {
    text = json['Text'];
    key = json['Key'];
    value = json['Value'] ?? false;
  }

  String text;
  String key;
  bool value;
  Config get keyConfig {
    return Config.values.firstWhere(
        (f) => f.toString().toLowerCase().trim() == key.toLowerCase(),
        orElse: () => null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Text'] = text;
    data['Key'] = key;
    data['Value'] = value;
    return data;
  }
}
