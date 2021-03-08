class DeliveryStatusReport {
  DeliveryStatusReport({this.count, this.name, this.totalAmount, this.value});
  DeliveryStatusReport.fromJson(Map<String, dynamic> json) {
    count = json["Count"].toInt();
    name = json["Name"];
    totalAmount = json["TotalAmount"].toInt();
    value = json["Value"];
  }
  int count;
  String name;
  int totalAmount;
  String value;
}
