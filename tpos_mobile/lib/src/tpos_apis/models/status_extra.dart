import 'package:tpos_mobile/src/tpos_apis/models/models_base.dart';

class StatusExtra extends BaseModel {
  int id;
  int index;
  String name;
  String type;

  StatusExtra({this.id, this.index, this.name, this.type});

  StatusExtra.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    index = json['Index'];
    name = json['Name'];
    type = json['Type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Index'] = this.index;
    data['Name'] = this.name;
    data['Type'] = this.type;
    return data;
  }
}
