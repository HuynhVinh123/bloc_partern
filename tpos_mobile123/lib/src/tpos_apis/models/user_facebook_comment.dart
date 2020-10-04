class UserFacebookComment {
  String id;
  String postId;
  String message;
  int likeCount;
  int commentCount;
  String createdTime;

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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['post_id'] = this.postId;
    data['message'] = this.message;
    data['like_count'] = this.likeCount;
    data['comment_count'] = this.commentCount;
    data['created_time'] = this.createdTime;
    return data;
  }
}
