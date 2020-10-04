class BusinessResult {
  String odataContext;
  String id;
  String fromDate;
  String toDate;
  int type;
  List<Datas> datas;

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
      datas = new List<Datas>();
      json['Datas'].forEach((v) {
        datas.add(new Datas.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['@odata.context'] = this.odataContext;
    data['Id'] = this.id;
    data['FromDate'] = this.fromDate;
    data['ToDate'] = this.toDate;
    data['Type'] = this.type;
    if (this.datas != null) {
      data['Datas'] = this.datas.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Datas {
  String name;
  double value;
  int sign;

  Datas({this.name, this.value, this.sign});

  Datas.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    value = json['Value'].toDouble();
    sign = json['Sign'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['Value'] = this.value;
    data['Sign'] = this.sign;
    return data;
  }
}
