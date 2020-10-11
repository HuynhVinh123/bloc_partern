/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

class SaleOnlineFacebookComment {
  String id;
  DateTime createdTime;
  int lineCount;
  String message;
  String postId;
  int commentCount;

  SaleOnlineFacebookComment(
      {this.id,
      this.createdTime,
      this.lineCount,
      this.message,
      this.postId,
      this.commentCount});

  SaleOnlineFacebookComment.fromJson(Map jsonMap) {
    id = jsonMap["id"];
    commentCount = jsonMap["comment_count"];
    lineCount = jsonMap["like_count"];
    message = jsonMap["message"];
    postId = jsonMap["post_id"];
    createdTime = DateTime.tryParse(jsonMap["created_time"]);
  }
}
