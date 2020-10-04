class UserActivities {
  int skip;
  int limit;
  int total;
  List<ActivityItem> items;

  UserActivities({this.skip, this.limit, this.total, this.items});

  UserActivities.fromJson(Map<String, dynamic> json) {
    skip = json['skip'];
    limit = json['limit'];
    total = json['total'];
    if (json['items'] != null) {
      items = new List<ActivityItem>();
      json['items'].forEach((v) {
        items.add(new ActivityItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['skip'] = this.skip;
    data['limit'] = this.limit;
    data['total'] = this.total;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ActivityItem {
  String id;
  String objectName;
  String content;
  String jSONData;
  String dateCreated;
  User user;

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
    user = json['User'] != null ? new User.fromJson(json['User']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['ObjectName'] = this.objectName;
    data['Content'] = this.content;
    data['JSONData'] = this.jSONData;
    data['DateCreated'] = this.dateCreated;
    if (this.user != null) {
      data['User'] = this.user.toJson();
    }
    return data;
  }
}

class User {
  String id;
  String userName;
  dynamic avatar;
  String name;

  User({this.id, this.userName, this.avatar, this.name});

  User.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    userName = json['UserName'];
    avatar = json['Avatar'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['UserName'] = this.userName;
    data['Avatar'] = this.avatar;
    data['Name'] = this.name;
    return data;
  }
}
