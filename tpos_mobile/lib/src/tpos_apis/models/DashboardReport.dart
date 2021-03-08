class DashboardReport {
  DashboardReport.fromJson(Map<String, dynamic> json) {
    if (json["OverView"] != null) {
      overview = DashboardReportOverView.fromJson(json["OverView"]);
    }
  }
  DashboardReportOverView overview;
}

class DashboardReportOverView {
  DashboardReportOverView(
      {this.totalOrderCurrent, this.totalOrderReturns, this.totalSaleCurrent});

  DashboardReportOverView.fromJson(Map<String, dynamic> json) {
    totalOrderCurrent = json["TotalOrderCurrent"]?.toDouble();
    totalOrderReturns = json["TotalOrderReturns"]?.toDouble();
    totalSaleCurrent = json["TotalSaleCurrent"]?.toDouble();
    totalReturn = json["TotalReturns"]?.toDouble();
  }
  double totalOrderCurrent;
  double totalOrderReturns;
  double totalSaleCurrent;
  double totalReturn;
}

class DashboardReportDataOverviewOption {
  DashboardReportDataOverviewOption({this.value, this.text});
  String value;
  String text;
}
