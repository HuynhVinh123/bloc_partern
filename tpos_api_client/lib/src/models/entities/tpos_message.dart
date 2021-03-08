class TposMessage {
  TposMessage({this.message, this.attachments, this.createdTime, this.id});
  TposMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    attachments = json['attachments'];
    if (json['created_time'] != null) {
      createdTime = DateTime.parse(json['created_time'])
        ..add(const Duration(hours: 7));
    }
  }
  dynamic attachments;
  DateTime createdTime;
  String id;
  String message;
  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['message'] = message;
    data['attachments'] = attachments;
    data['created_time'] = createdTime?.toIso8601String();
    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
