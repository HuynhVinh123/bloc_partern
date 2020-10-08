class DashboardReport {
  DashboardReportOverView overview;
  DashboardReport.fromJson(Map<String, dynamic> json) {
    if (json["OverView"] != null) {
      overview = DashboardReportOverView.fromJson(json["OverView"]);
    }
  }
}

class DashboardReportOverView {
  int totalOrderCurrent;
  int totalOrderReturns;
  double totalSaleCurrent;
  double totalReturn;

  DashboardReportOverView(
      {this.totalOrderCurrent, this.totalOrderReturns, this.totalSaleCurrent});

  DashboardReportOverView.fromJson(Map<String, dynamic> json) {
    totalOrderCurrent = json["TotalOrderCurrent"];
    totalOrderReturns = json["TotalOrderReturns"];
    totalSaleCurrent = json["TotalSaleCurrent"]?.toDouble();
    totalReturn = json["TotalReturns"]?.toDouble();
  }
}

class DashboardReportDataOverviewOption {
  String value;
  String text;

  DashboardReportDataOverviewOption({this.value, this.text});
}
