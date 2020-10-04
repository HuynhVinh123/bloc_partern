class ChangeCurrentCompanyGetResult {
  String odataContext;
  String currentCompany;
  DateTime dateExpired;
  int expiredIn;
  List<ChangeCurrentCompanyGetResultCompany> companies;

  String get expiredInShort {
    final int expiredInSecond = expiredIn ?? 0;
    if (expiredInSecond < 3600) {
      final double minute = (expiredInSecond / 60);
      return "${minute.toStringAsFixed(1)} phút";
    } else if (expiredInSecond < 86400) {
      var hour = expiredInSecond / 3600;
      return "${hour.toStringAsFixed(1)} giờ";
    } else if (expiredInSecond < 2592000) {
      var day = (expiredInSecond / 86400);
      return "${day.toStringAsFixed(1)} ngày";
    } else if (expiredInSecond < 31536000) {
      var month = expiredInSecond / 2592000;
      return "${month.toStringAsFixed(1)} tháng";
    } else {
      var year = expiredInSecond / 31536000;
      return "${year.toStringAsFixed(1)} năm";
    }
  }

  ChangeCurrentCompanyGetResult(
      {this.odataContext,
      this.currentCompany,
      this.dateExpired,
      this.expiredIn,
      this.companies});

  ChangeCurrentCompanyGetResult.fromJson(Map<String, dynamic> json) {
    odataContext = json['@odata.context'];
    currentCompany = json['CurrentCompany'];
    if (json['DateExpired'] != null)
      dateExpired = DateTime.parse(json['DateExpired']);
    expiredIn = json['ExpiredIn'];
    if (json['Companies'] != null) {
      companies = new List<ChangeCurrentCompanyGetResultCompany>();
      json['Companies'].forEach((v) {
        companies.add(new ChangeCurrentCompanyGetResultCompany.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['@odata.context'] = this.odataContext;
    data['CurrentCompany'] = this.currentCompany;
    data['DateExpired'] = this.dateExpired;
    data['ExpiredIn'] = this.expiredIn;
    if (this.companies != null) {
      data['Companies'] = this.companies.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChangeCurrentCompanyGetResultCompany {
  bool disabled;
  bool selected;
  String text;
  String value;
  dynamic group;

  ChangeCurrentCompanyGetResultCompany(
      {this.disabled, this.selected, this.text, this.value, this.group});

  ChangeCurrentCompanyGetResultCompany.fromJson(Map<String, dynamic> json) {
    disabled = json['Disabled'];
    selected = json['Selected'];
    text = json['Text'];
    value = json['Value'];
    group = json['Group'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Disabled'] = this.disabled;
    data['Selected'] = this.selected;
    data['Text'] = this.text;
    data['Value'] = this.value;
    data['Group'] = this.group;
    return data;
  }
}
