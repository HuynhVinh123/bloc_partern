class PartnerSaleReport {
  PartnerSaleReport(
      {this.countOrder,
      this.customerId,
      this.customerName,
      this.date,
      this.staffId,
      this.staffName,
      this.totalAmount,
      this.totalAmountBeforeCK,
      this.totalKM,
      this.totalCK,
      this.totalResidual});

  PartnerSaleReport.fromJson(Map<String, dynamic> mapData) {
    countOrder = mapData["CountOrder"];
    customerId = mapData["CustomerId"];
    customerName = mapData["CustomerName"];
    date = DateTime.parse(mapData["Date"]).toLocal();
    staffId = mapData["StaffId"];
    staffName = mapData["StaffName"];
    totalAmount = mapData["TotalAmount"];
    totalAmountBeforeCK =
        double.parse(mapData["TotalAmountBeforeCK"].toString());
    totalCK = mapData["TotalCK"];
    totalKM = double.parse(mapData["TotalKM"].toString());
    totalResidual = mapData["TotalResidual"];
  }

  int countOrder;
  int customerId;
  String customerName;
  DateTime date;
  dynamic staffId;
  dynamic staffName;
  double totalAmount;
  double totalAmountBeforeCK;
  double totalCK;
  double totalKM;
  double totalResidual;
}
