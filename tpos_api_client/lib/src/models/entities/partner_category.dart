class PartnerCategory {
  PartnerCategory(
      {this.id,
      this.parent,
      this.name,
      this.parentId,
      this.completeName,
      this.active,
      this.parentLeft,
      this.parentRight,
      this.discount});

  PartnerCategory.fromJson(Map<String, dynamic> jsonMap) {
    PartnerCategory detail;
    final detailMap = jsonMap["Parent"];
    if (detailMap != null) {
      detail = PartnerCategory.fromJson(detailMap);
    }

    parent = detail;
    id = jsonMap["Id"];
    name = jsonMap["Name"];
    parentId = jsonMap["ParentId"];
    completeName = jsonMap["CompleteName"];
    active = jsonMap["Active"];
    parentLeft = jsonMap["ParentLeft"];
    parentRight = jsonMap["ParentRight"];
    discount = jsonMap["Discount"]?.toDouble() ?? 0;
  }

  int id;
  String name;
  int parentId;
  String completeName;
  bool active;
  int parentLeft;
  int parentRight;
  double discount;
  PartnerCategory parent;

  Map<String, dynamic> toJson([removeIfNull = false]) {
    final Map<String, dynamic> data = {
      "Parent": parent != null ? parent.toJson() : null,
      "Id": id,
      "Name": name,
      "CompleteName": completeName,
      "Active": active,
      "ParentLeft": parentLeft,
      "ParentRight": parentRight,
      "ParentId": parentId,
      "Discount": discount,
    };

    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }

    return data;
  }
}
