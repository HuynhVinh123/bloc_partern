class Currency {
  int id;
  String name;
  double rounding;
  String symbol;
  bool active;
  String position;
  double rate;
  Currency(
      {this.id,
      this.name,
      this.rounding,
      this.symbol,
      this.active,
      this.position,
      this.rate});
  Currency.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    rounding = json['Rounding'];
    symbol = json['Symbol'];
    active = json['Active'];
    position = json['Position'];
    rate = json['Rate']?.toDouble() ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['Rounding'] = this.rounding;
    data['Symbol'] = this.symbol;
    data['Active'] = this.active;
    data['Position'] = this.position;
    data['Rate'] = this.rate;
    return data;
  }
}
