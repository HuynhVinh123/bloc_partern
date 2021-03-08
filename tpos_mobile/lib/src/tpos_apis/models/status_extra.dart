import 'package:tpos_mobile/src/tpos_apis/models/models_base.dart';

class StatusExtra extends BaseModel {
  StatusExtra({this.id, this.index, this.name, this.type});
  StatusExtra.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    index = json['Index'];
    name = json['Name'];
    type = json['Type'];
  }
  int id;
  int index;
  String name;
  String type;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Index'] = index;
    data['Name'] = name;
    data['Type'] = type;
    return data;
  }
}
