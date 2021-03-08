/// Object Thông báo từ máy chủ TPos cho người dùng
class TPosNotification {
  TPosNotification(
      {this.id,
      this.title,
      this.image,
      this.content,
      this.description,
      this.notificationId,
      this.enablePopup,
      this.images,
      this.topics,
      this.markReadBy,
      this.dateRead,
      this.dateCreated});

  TPosNotification.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    title = json['Title'];
    image = json['Image'];
    content = json['Content'];
    description = json['Description'];
    notificationId = json['NotificationId'];
    enablePopup = json['EnablePopup'];
    images = json['Images'];
    topics = json['Topics'];
    markReadBy = json['MarkReadBy'];
    if (json['DateRead'] != null) {
      dateRead = DateTime.parse(json['DateRead']);
    }
    if (json['DateCreated'] != null) {
      dateCreated = DateTime.parse(json['DateCreated']);
    }
  }
  String id;
  String title;
  String image;
  String content;
  String description;
  int notificationId;
  bool enablePopup;
  dynamic images;
  dynamic topics;
  dynamic markReadBy;
  DateTime dateRead;
  DateTime dateCreated;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Title'] = title;
    data['Image'] = image;
    data['Content'] = content;
    data['Description'] = description;
    data['NotificationId'] = notificationId;
    data['EnablePopup'] = enablePopup;
    data['Images'] = images;
    data['Topics'] = topics;
    data['MarkReadBy'] = markReadBy;
    data['DateRead'] = dateRead;
    data['DateCreated'] = dateCreated;
    return data;
  }
}
