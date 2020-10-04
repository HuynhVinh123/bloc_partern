/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'package:tpos_mobile/src/tpos_apis/models/tpos_facebook_from.dart';

class TposFacebookComment {
  String id;
  String message;
  DateTime createdTime;
  DateTime createdTimeConverted;
  TposFacebookFrom from;
  List<TposFacebookComment> comments;

  TposFacebookComment(
      {this.id,
      this.message,
      this.createdTime,
      this.createdTimeConverted,
      this.from,
      this.comments});

  TposFacebookComment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    createdTime = DateTime.parse(json['created_time']);
    createdTimeConverted = DateTime.parse(json['created_time_converted']);
    from = json['from'] != null
        ? new TposFacebookFrom.fromJson(json['from'])
        : null;
    if (json['comments'] != null) {
      comments = new List<Null>();
      json['comments'].forEach((v) {
        comments.add(new TposFacebookComment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message'] = this.message;
    data['created_time'] = this.createdTime?.toString();
    data['created_time_converted'] = this.createdTimeConverted?.toString();
    if (this.from != null) {
      data['from'] = this.from.toJson();
    }
    if (this.comments != null) {
      data['comments'] = this.comments.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
