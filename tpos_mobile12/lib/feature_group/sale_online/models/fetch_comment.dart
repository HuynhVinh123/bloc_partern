class FetchComment {
  FetchComment({this.commentCount, this.newCount, this.updateCount});

  FetchComment.fromJson(Map<String, dynamic> json) {
    commentCount = json["CommentCount"];
    newCount = json["NewCount"];
    updateCount = json["UpdateCount"];
  }
  int commentCount;
  int newCount;
  int updateCount;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CommentCount'] = commentCount;
    data['UpdateCount'] = updateCount;
    data['NewCount'] = newCount;
    return data;
  }
}
