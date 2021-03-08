class BusinessResult {
  BusinessResult(
      {this.odataContext,
      this.id,
      this.fromDate,
      this.toDate,
      this.type,
      this.datas});

  BusinessResult.fromJson(Map<String, dynamic> json) {
    odataContext = json['@odata.context'];
    id = json['Id'];
    fromDate = json['FromDate'];
    toDate = json['ToDate'];
    type = json['Type'];
    if (json['Datas'] != null) {
      datas = <Datas>[];
      json['Datas'].forEach((v) {
        datas.add(Datas.fromJson(v));
      });
    }
  }

  String odataContext;
  String id;
  String fromDate;
  String toDate;
  int type;
  List<Datas> datas;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['@odata.context'] = odataContext;
    data['Id'] = id;
    data['FromDate'] = fromDate;
    data['ToDate'] = toDate;
    data['Type'] = type;
    if (datas != null) {
      data['Datas'] = datas.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Datas {
  Datas({this.name, this.value, this.sign});

  Datas.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    value = json['Value'].toDouble();
    sign = json['Sign'];
  }
  String name;
  double value;
  int sign;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Name'] = name;
    data['Value'] = value;
    data['Sign'] = sign;
    return data;
  }
}
