/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'package:flutter/material.dart';

class DateFilterTemplate {
  String name;
  DateTime fromDate;
  DateTime toDate;
  TimeOfDay fromTimeOfDay;
  TimeOfDay toTimeOfDay;
  String description;

  DateFilterTemplate(
      {this.name,
      this.fromDate,
      this.toDate,
      this.description,
      this.fromTimeOfDay,
      this.toTimeOfDay});
}
