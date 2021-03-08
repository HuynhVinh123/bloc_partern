class Currency {
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
  int id;
  String name;
  double rounding;
  String symbol;
  bool active;
  String position;
  double rate;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Name'] = name;
    data['Rounding'] = rounding;
    data['Symbol'] = symbol;
    data['Active'] = active;
    data['Position'] = position;
    data['Rate'] = rate;
    return data;
  }
}
