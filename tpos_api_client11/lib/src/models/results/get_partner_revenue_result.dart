class GetPartnerRevenueResult {
  GetPartnerRevenueResult({this.revenue, this.revenueBegan, this.revenueTotal});

  GetPartnerRevenueResult.fromJson(Map<String, dynamic> json) {
    revenue = json['Revenue']?.toDouble();
    revenueBegan = json['RevenueBegan']?.toDouble();
    revenueTotal = json['RevenueTotal']?.toDouble();
  }

  double revenue;
  double revenueBegan;
  double revenueTotal;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Revenue'] = revenue;
    data['RevenueBegan'] = revenueBegan;
    data['RevenueTotal'] = revenueTotal;
    return data;
  }
}
