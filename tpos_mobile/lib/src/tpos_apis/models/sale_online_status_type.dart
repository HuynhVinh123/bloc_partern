/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

class SaleOnlineStatusType {
  String text, value, group;
  bool disabled, selected;

  SaleOnlineStatusType.fromJson(Map<String, dynamic> jsonMap) {
    text = jsonMap["Text"];
    value = jsonMap["Value"];
    group = jsonMap["Group"];
    disabled = jsonMap["Disabled"];
    selected = jsonMap["Selected"];
  }

  SaleOnlineStatusType(
      {this.text, this.value, this.group, this.disabled, this.selected});
}
