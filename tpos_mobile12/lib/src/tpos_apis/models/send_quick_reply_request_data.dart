import 'package:tpos_mobile/src/facebook_apis/facebook_api.dart';

class SendQuickReplyRequestData {
  FacebookComment comment;
  int crmTeamId;
  String message;

  SendQuickReplyRequestData({this.comment, this.crmTeamId, this.message});

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    var data = new Map<String, dynamic>();

    if (comment != null) {
      data["Comments"] = [
        {
          "is_hidden": comment.isHidden,
          "can_hide": comment.canHide,
          "message": comment.message,
          "from": {
            "id": comment.from.id,
            "name": comment.from.name,
            "picture": comment.from.pictureLink,
          },
          "created_time": comment.createdTime?.toString(),
          "facebook_id": comment.id,
        }
      ];
    }
    data["TeamId"] = crmTeamId;
    data["Message"] = message;

    if (removeIfNull) data.removeWhere((key, value) => value == null);
    return data;
  }
}
