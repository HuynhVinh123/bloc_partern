class TposFacebookFrom {
  String id;
  String name;
  String picture;

  TposFacebookFrom({this.id, this.name, this.picture});

  TposFacebookFrom.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    picture = json['picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['picture'] = this.picture;
    return data;
  }
}
