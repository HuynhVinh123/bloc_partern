import 'package:tpos_mobile/app_core/helper/app_filter_helper.dart';

class AppFilterDateModel {
  String name;
  DateTime fromDate;
  DateTime toDate;

  AppFilterDateModel({this.name, this.fromDate, this.toDate});

  factory AppFilterDateModel.toDay() {
    return getTodayDateFilter();
  }

  factory AppFilterDateModel.yesterday() {
    return getYesterdayDateFilter();
  }
  factory AppFilterDateModel.thisMonth() {
    return getDateFilterThisMonth();
  }
}
