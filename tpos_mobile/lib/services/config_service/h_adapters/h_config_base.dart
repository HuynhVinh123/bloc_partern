import 'package:hive/hive.dart';

abstract class HconfigBase {
  HconfigBase(Box hive) {
    _hive = hive;
  }
  Box _hive;

  Box get hive => _hive;

  void fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson([bool removeIfNull = false]);
}
