class Alert {
  Alert(
      {this.id,
      this.alertDate,
      this.content,
      this.itemsText,
      this.typeId,
      this.active,
      this.items,
      this.dateRead});

  Alert.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    alertDate = json['AlertDate'];
    content = json['Content'];
    itemsText = json['ItemsText'];
    typeId = json['TypeId'];
    active = json['Active'];
    if (json['Items'] != null) {
      items = <Items>[];
      json['Items'].forEach((v) {
        items.add(Items.fromJson(v));
      });
    }
    dateRead = json['DateRead'];
  }

  String id;
  String alertDate;
  String content;
  dynamic itemsText;
  int typeId;
  bool active;
  List<Items> items;
  String dateRead;
}

class Items {
  Items(
      {this.id,
      this.content,
      this.date,
      this.dateExpected,
      this.type,
      this.typeText});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    content = json['Content'];
    date = json['Date'];
    dateExpected = json['DateExpected'];
    type = json['Type'];
    typeText = json['TypeText'];
  }

  int id;
  String content;
  String date;
  String dateExpected;
  int type;
  String typeText;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Content'] = content;
    data['Date'] = date;
    data['DateExpected'] = dateExpected;
    data['Type'] = type;
    data['TypeText'] = typeText;
    return data;
  }
}
