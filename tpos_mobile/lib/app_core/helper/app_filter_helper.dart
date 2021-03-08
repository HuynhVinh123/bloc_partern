import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';
import 'package:tpos_mobile_localization/generated/l10n.dart';

/// Lấy ngày lọc gợi ý mặc định
List<AppFilterDateModel> getFilterDateTemplates() {
  return <AppFilterDateModel>[
    getTodayDateFilter(),
    getYesterdayDateFilter(),
    getDateFilterThisMonth(),
    getDateFilterThisYear(),
    getDateFilterLast7Day(),
    getDateFilterLast30Day(),
    getDateFilterLast90Day(),
    getDateFilterCustom()
  ];
}

/// Lấy ngày lọc đơn gián (Hôm nay, hôm qua, tháng này, 7 ngày qua, 30 ngày qua)
List<AppFilterDateModel> getFilterDateTemplateSimple() {
  return <AppFilterDateModel>[
    getTodayDateFilter(),
    getYesterdayDateFilter(),
    getDateFilterThisMonth(),
    getDateFilterThisYear(),
    getDateFilterLast7Day(),
    getDateFilterLast30Day(),
    getDateFilterLast90Day(),
    getDateFilterCustom()
  ];
}

AppFilterDateModel getTodayDateFilter() {
  final now = DateTime.now();

  //Hôm nay
  final toDate = AppFilterDateModel(
    name: S.current.today,
    fromDate: DateTime(now.year, now.month, now.day, 0, 0, 0),
  );
  toDate.toDate = toDate.fromDate.add(const Duration(days: 1)).add(
        const Duration(milliseconds: -1),
      );

  return toDate;
}

AppFilterDateModel getYesterdayDateFilter() {
  final now = DateTime.now();
  return AppFilterDateModel()
    ..toDate = DateTime(now.year, now.month, now.day - 1, 23, 59, 59, 999, 999)
    ..fromDate = DateTime(now.year, now.month, now.day - 1, 0, 0, 0)
    ..name = S.current.yesterday;
}

AppFilterDateModel getDateFilterThisMonth() {
  final now = DateTime.now();
  final thisMonth = AppFilterDateModel();
  thisMonth.fromDate = DateTime(now.year, now.month, 1, 0, 0);
  thisMonth.toDate = DateTime(now.year, now.month + 1, 1, 23, 59, 59, 999, 999)
      .add(const Duration(days: -1));
  thisMonth.name = S.current.thisMonth;
  return thisMonth;
}

/// Lấy khoảng thời gian năm này
/// Đầu năm-> Cuối năm
AppFilterDateModel getDateFilterThisYear() {
  final now = DateTime.now();
  final thisYearModel = AppFilterDateModel();

  thisYearModel.toDate = DateTime(now.year, 12, 31, 23, 59, 59, 999, 999);

  thisYearModel.fromDate = DateTime(now.year, 1, 1, 0, 0, 0);
  thisYearModel.name = S.current.thisYear;
  return thisYearModel;
}

AppFilterDateModel getDateFilterLast7Day() {
  final now = DateTime.now();
  final thisMonth = AppFilterDateModel();

  thisMonth.toDate =
      DateTime(now.year, now.month, now.day, 23, 59, 59, 999, 999);
  final last7Date = now.add(const Duration(days: -6));
  thisMonth.fromDate =
      DateTime(last7Date.year, last7Date.month, last7Date.day, 0, 0, 0);
  thisMonth.name = S.current.filter_7daysAgo;
  return thisMonth;
}

AppFilterDateModel getDateFilterLast30Day() {
  final now = DateTime.now();
  final thisMonth = AppFilterDateModel();

  thisMonth.toDate =
      DateTime(now.year, now.month, now.day, 23, 59, 59, 999, 999);
  final last7Date = now.add(const Duration(days: -29));
  thisMonth.fromDate =
      DateTime(last7Date.year, last7Date.month, last7Date.day, 0, 0, 0);
  thisMonth.name = S.current.filter_30daysAgo;
  return thisMonth;
}

AppFilterDateModel getDateFilterLast90Day() {
  final now = DateTime.now();
  final thisMonth = AppFilterDateModel();

  thisMonth.toDate =
      DateTime(now.year, now.month, now.day, 23, 59, 59, 999, 999);
  final last7Date = now.add(const Duration(days: -89));
  thisMonth.fromDate =
      DateTime(last7Date.year, last7Date.month, last7Date.day, 0, 0, 0);
  thisMonth.name = S.current.filter_90daysAgo;
  return thisMonth;
}

AppFilterDateModel getDateFilterCustom() {
  final now = DateTime.now();
  final fromDate = DateTime(now.year, now.month, now.day, 0, 0, 0);
  //Hôm nay
  return AppFilterDateModel(
      name: S.current.custom,
      fromDate: DateTime(now.year, now.month, now.day, 0, 0, 0),
      toDate: fromDate.add(const Duration(days: 1)).add(
            const Duration(milliseconds: -1),
          ));
}
