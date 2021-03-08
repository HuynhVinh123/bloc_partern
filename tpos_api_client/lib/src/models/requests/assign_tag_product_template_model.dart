import 'package:tpos_api_client/src/model.dart';

class AssignTagProductTemplateModel {
  AssignTagProductTemplateModel({this.id, this.tagId, this.color, this.tags, this.productTmplId, this.tagName});

  AssignTagProductTemplateModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    tagId = json['TagId'];
    color = json['Color'];
    if (json['Tags'] != null) {
      tags = <Tag>[];
      json['Tags'].forEach((v) {
        tags.add(Tag.fromJson(v));
      });
    }
    productTmplId = json['ProductTmplId'];
    tagName = json['TagName'];
  }

  int id;
  int tagId;
  String color;
  List<Tag> tags;
  int productTmplId;
  String tagName;

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['TagId'] = tagId;
    data['Color'] = color;
    if (tags != null) {
      data['Tags'] = tags.map((v) => v.toJson()).toList();
    }
    data['ProductTmplId'] = productTmplId;
    data['TagName'] = tagName;
    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
