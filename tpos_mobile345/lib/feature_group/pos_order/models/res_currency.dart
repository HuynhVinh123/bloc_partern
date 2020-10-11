class ResCurrency {
  ResCurrency(
      {this.id,
      this.name,
      this.rounding,
      this.symbol,
      this.active,
      this.position,
      this.rate});

  ResCurrency.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    rounding = json['Rounding'];
    symbol = json['Symbol'];
    active = json['Active'];
    position = json['Position'];
    rate = json['Rate'];
  }

  int id;
  String name;
  int rounding;
  dynamic symbol;
  bool active;
  String position;
  int rate;

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
