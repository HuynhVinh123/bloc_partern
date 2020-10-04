class SumReportGeneral {
  SumReportGeneral(
      {this.id,
      this.totalOrder,
      this.totalSale,
      this.totalCk,
      this.totalAmount,
      this.totalKM});

  SumReportGeneral.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    totalOrder = json['TotalOrder'];
    totalSale = json['TotalSale']?.toDouble();
    totalCk = json['TotalCk']?.toDouble();
    totalAmount = json['TotalAmount']?.toDouble();
    totalKM = json['TotalKM']?.toDouble();
  }

  int id;
  int totalOrder;
  double totalSale;
  double totalCk;
  double totalAmount;
  double totalKM;
}
