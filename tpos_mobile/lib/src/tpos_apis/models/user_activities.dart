class UserActivities {
  UserActivities({this.skip, this.limit, this.total, this.items});
  UserActivities.fromJson(Map<String, dynamic> json) {
    skip = json['skip'];
    limit = json['limit'];
    total = json['total'];
    if (json['items'] != null) {
      items = <ActivityItem>[];
      json['items'].forEach((v) {
        items.add(ActivityItem.fromJson(v));
      });
    }
  }

  int skip;
  int limit;
  int total;
  List<ActivityItem> items;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['skip'] = skip;
    data['limit'] = limit;
    data['total'] = total;
    if (items != null) {
      data['items'] = items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ActivityItem {
  ActivityItem(
      {this.id,
      this.objectName,
      this.content,
      this.jSONData,
      this.dateCreated,
      this.user});

  ActivityItem.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    objectName = json['ObjectName'];
    content = json['Content'];
    jSONData = json['JSONData'];
    dateCreated = json['DateCreated'];
    user = json['User'] != null ? User.fromJson(json['User']) : null;
  }
  String id;
  String objectName;
  String content;
  String jSONData;
  String dateCreated;
  User user;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['ObjectName'] = objectName;
    data['Content'] = content;
    data['JSONData'] = jSONData;
    data['DateCreated'] = dateCreated;
    if (user != null) {
      data['User'] = user.toJson();
    }
    return data;
  }
}

class User {
  User({this.id, this.userName, this.avatar, this.name});

  User.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    userName = json['UserName'];
    avatar = json['Avatar'];
    name = json['Name'];
  }

  String id;
  String userName;
  dynamic avatar;
  String name;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['UserName'] = userName;
    data['Avatar'] = avatar;
    data['Name'] = name;
    return data;
  }
}
