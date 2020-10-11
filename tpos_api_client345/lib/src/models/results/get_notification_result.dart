import 'package:tpos_api_client/src/models/entities/notification.dart';

class GetNotificationResult {
  int count;
  List<TPosNotification> items;
  TPosNotification popup;

  GetNotificationResult({this.count, this.items, this.popup});

  GetNotificationResult.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['items'] != null) {
      items = <TPosNotification>[];
      json['items'].forEach((v) {
        items.add(TPosNotification.fromJson(v));
      });
    }

    if (json["popup"] != null) {
      popup = TPosNotification.fromJson(json["popup"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (items != null) {
      data['items'] = items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
