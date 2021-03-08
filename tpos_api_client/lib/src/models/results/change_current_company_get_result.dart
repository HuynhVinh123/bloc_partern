import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class ChangeCurrentCompanyGetResult {
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
      companies = <ChangeCurrentCompanyGetResultCompany>[];
      json['Companies'].forEach((v) {
        companies.add(ChangeCurrentCompanyGetResultCompany.fromJson(v));
      });
    }
  }

  String odataContext;
  String currentCompany;
  DateTime dateExpired;
  int expiredIn;
  List<ChangeCurrentCompanyGetResultCompany> companies;

  String get expiredInShort {
    final int expiredInSecond = expiredIn ?? 0;
    if (expiredInSecond < 3600) {
      final double minute = expiredInSecond / 60;
      return "${minute.toStringAsFixed(1)} ${S.current.minute}";
    } else if (expiredInSecond < 86400) {
      final hour = expiredInSecond / 3600;
      return "${hour.toStringAsFixed(1)} ${S.current.hour}";
    } else if (expiredInSecond < 2592000) {
      final day = expiredInSecond / 86400;
      return "${day.toStringAsFixed(1)} ${S.current.day}";
    } else if (expiredInSecond < 31536000) {
      final month = expiredInSecond / 2592000;
      return "${month.toStringAsFixed(1)} ${S.current.month}";
    } else {
      final year = expiredInSecond / 31536000;
      return "${year.toStringAsFixed(1)} ${S.current.year}";
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['@odata.context'] = odataContext;
    data['CurrentCompany'] = currentCompany;
    data['DateExpired'] = dateExpired;
    data['ExpiredIn'] = expiredIn;
    if (companies != null) {
      data['Companies'] = companies.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChangeCurrentCompanyGetResultCompany {
  ChangeCurrentCompanyGetResultCompany(
      {this.disabled, this.selected, this.text, this.value, this.group});

  ChangeCurrentCompanyGetResultCompany.fromJson(Map<String, dynamic> json) {
    disabled = json['Disabled'];
    selected = json['Selected'];
    text = json['Text'];
    value = json['Value'];
    group = json['Group'];
  }

  bool disabled;
  bool selected;
  String text;
  String value;
  dynamic group;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Disabled'] = disabled;
    data['Selected'] = selected;
    data['Text'] = text;
    data['Value'] = value;
    data['Group'] = group;
    return data;
  }
}
