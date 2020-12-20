class Unread {
  /// Đếm số lượng tin nhắn, comment chưa đọc
  Unread({this.countAll, this.countComment, this.countMessage});
  Unread.fromJson(Map<String, dynamic> json) {
    countAll = json['CountAll'];
    countComment = json['CountComment'];
    countMessage = json['CountMessage'];
  }
  int countAll;
  int countComment;
  int countMessage;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CountAll'] = countAll;
    data['CountComment'] = countComment;
    data['CountMessage'] = countMessage;
    return data;
  }
}
