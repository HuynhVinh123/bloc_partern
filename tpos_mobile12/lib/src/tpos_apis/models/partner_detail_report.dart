class PartnerDetailReport {
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Date'] = this.date;
    data['Name'] = this.name;
    data['Ref'] = this.ref;
    data['MoveName'] = this.moveName;
    data['Begin'] = this.begin;
    data['Debit'] = this.debit;
    data['Credit'] = this.credit;
    data['End'] = this.end;
    return data;
  }
}
