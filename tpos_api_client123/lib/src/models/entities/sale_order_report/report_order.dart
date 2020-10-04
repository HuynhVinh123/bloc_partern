class ReportOrder {
  ReportOrder(
      {this.date,
      this.countOrder,
      this.totalAmountBeforeCK,
      this.totalCK,
      this.totalKM,
      this.totalAmount});

  DateTime date;
  int countOrder;
  double totalAmountBeforeCK;
  double totalCK;
  double totalKM;
  double totalAmount;

  ReportOrder.fromJson(Map<String, dynamic> json) {
    date = DateTime.parse(json['Date']).toLocal();
    countOrder = json['CountOrder']?.toInt();
    totalAmountBeforeCK = json['TotalAmountBeforeCK']?.toDouble();
    totalCK = json['TotalCK']?.toDouble();
    totalKM = json['TotalKM']?.toDouble();

    countOrder = json['CountOrder'];
    totalAmountBeforeCK = double.parse(json['TotalAmountBeforeCK'].toString());
    totalCK = json['TotalCK'];
    totalKM = double.parse(json['TotalKM'].toString());
    totalAmount = json['TotalAmount'];
  }
}
