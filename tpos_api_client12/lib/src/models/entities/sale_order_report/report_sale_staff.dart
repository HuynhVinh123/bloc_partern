class ReportSaleStaff {
  ReportSaleStaff(
      {this.countOrder,
      this.customerName,
      this.customerId,
      this.date,
      this.staffId,
      this.staffName,
      this.totalAmount,
      this.totalResidual,
      this.totalCK,
      this.totalKM,
      this.totalAmountBeforeCK});

  ReportSaleStaff.fromJson(Map<String, dynamic> mapData) {
    countOrder = mapData["CountOrder"];
    customerId = mapData["CustomerId"];
    customerName = mapData["CustomerName"];
    date = DateTime.parse(mapData["Date"]).toLocal();
    staffId = mapData["StaffId"];
    staffName = mapData["StaffName"];
    totalAmount = mapData["TotalAmount"];
    totalAmountBeforeCK = mapData["TotalAmountBeforeCK"];
    totalCK = mapData["TotalCK"];
    totalKM = mapData["TotalKM"];
    totalResidual = mapData["TotalResidual"];
  }

  int countOrder;
  dynamic customerId;
  String customerName;
  DateTime date;
  String staffId;
  String staffName;
  double totalAmount;
  double totalAmountBeforeCK;
  double totalCK;
  double totalKM;
  double totalResidual;
}
