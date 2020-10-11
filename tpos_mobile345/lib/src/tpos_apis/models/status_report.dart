/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

class StatusReport {
  bool isChecked = false;
  double totalAmount;
  String value;
  int count;
  String name;

  StatusReport(
      {this.totalAmount,
      this.value,
      this.count,
      this.name,
      this.isChecked = false});
  factory StatusReport.fromJson(Map<String, dynamic> jsonMap) {
    return new StatusReport(
      name: jsonMap["Name"],
      totalAmount: jsonMap["TotalAmount"],
      count: jsonMap["Count"],
      value: jsonMap["Value"],
    );
  }
}
