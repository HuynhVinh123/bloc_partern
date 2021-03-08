import 'package:tpos_api_client/src/model.dart';

class AssignTagPartnerModel {
  AssignTagPartnerModel(
      {this.id,
      this.tagId,
      this.color,
      this.tags,
      this.partnerId,
      this.tagName});
  AssignTagPartnerModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    tagId = json['TagId'];
    color = json['Color'];
    if (json['Tags'] != null) {
      tags = <Tag>[];
      json['Tags'].forEach((v) {
        tags.add(Tag.fromJson(v));
      });
    }
    partnerId = json['PartnerId'];
    tagName = json['TagName'];
  }
  int id;
  int tagId;
  String color;
  List<Tag> tags;
  int partnerId;
  String tagName;

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['TagId'] = tagId;
    data['Color'] = color;
    if (tags != null) {
      data['Tags'] = tags.map((v) => v.toJson()).toList();
    }
    data['PartnerId'] = partnerId;
    data['TagName'] = tagName;
    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
