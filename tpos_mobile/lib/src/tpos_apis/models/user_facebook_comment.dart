class UserFacebookComment {
  UserFacebookComment(
      {this.id,
      this.postId,
      this.message,
      this.likeCount,
      this.commentCount,
      this.createdTime});
  UserFacebookComment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['post_id'];
    message = json['message'];
    likeCount = json['like_count'];
    commentCount = json['comment_count'];
    createdTime = json['created_time'];
  }
  String id;
  String postId;
  String message;
  int likeCount;
  int commentCount;
  String createdTime;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['post_id'] = postId;
    data['message'] = message;
    data['like_count'] = likeCount;
    data['comment_count'] = commentCount;
    data['created_time'] = createdTime;
    return data;
  }
}
