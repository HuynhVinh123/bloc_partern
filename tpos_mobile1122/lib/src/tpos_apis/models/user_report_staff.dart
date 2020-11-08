class UserReportStaff {
  bool disabled;
  Null group;
  bool selected;
  String text;
  String value;

  UserReportStaff(
      {this.disabled, this.group, this.selected, this.text, this.value});

  UserReportStaff.fromJson(Map<String, dynamic> json) {
    disabled = json['Disabled'];
    group = json['Group'];
    selected = json['Selected'];
    text = json['Text'];
    value = json['Value'];
  }
}
