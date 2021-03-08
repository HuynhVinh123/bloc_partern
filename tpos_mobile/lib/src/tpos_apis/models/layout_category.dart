class LayoutCategory {
  LayoutCategory(
      {this.id, this.name, this.pageBreak, this.sequence, this.subtotal});
  LayoutCategory.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap["Id"];
    name = jsonMap["Name"];
    pageBreak = jsonMap["Pagebreak"];
    sequence = jsonMap["Sequence"];
    subtotal = jsonMap["Subtotal"];
  }

  int id;
  String name;
  int pageBreak;
  int sequence;
  bool subtotal;

  Map<String, dynamic> toJson() {
    return {
      "Id": id,
      "Name": name,
      "Pagebreak": pageBreak,
      "Sequence": sequence,
      "Subtotal": subtotal
    };
  }
}
