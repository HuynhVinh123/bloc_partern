class PartnerDetailReport {
  PartnerDetailReport(
      {this.id,
      this.date,
      this.name,
      this.ref,
      this.moveName,
      this.begin,
      this.debit,
      this.credit,
      this.end,
      this.totalItem});

  PartnerDetailReport.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    date = json['Date'];
    name = json['Name'];
    ref = json['Ref'];
    moveName = json['MoveName'];
    begin = double.parse(json['Begin'].toString());
    debit = double.parse(json['Debit'].toString());
    credit = double.parse(json['Credit'].toString());
    end = double.parse(json['End'].toString());
  }

  int id;
  String date;
  String name;
  String ref;
  String moveName;
  double begin;
  double debit;
  double credit;
  double end;
  int totalItem;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Date'] = date;
    data['Name'] = name;
    data['Ref'] = ref;
    data['MoveName'] = moveName;
    data['Begin'] = begin;
    data['Debit'] = debit;
    data['Credit'] = credit;
    data['End'] = end;
    return data;
  }
}
