class CompanyOfUser {
  CompanyOfUser(
      {this.disabled, this.group, this.selected, this.text, this.value});

  CompanyOfUser.fromJson(Map<String, dynamic> json) {
    disabled = json['Disabled'];
    group = json['Group'];
    selected = json['Selected'];
    text = json['Text'];
    value = json['Value'];
  }

  bool disabled;
  dynamic group;
  bool selected;
  String text;
  String value;
}
