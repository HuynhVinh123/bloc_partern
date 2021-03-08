class OdataSortItem {
  OdataSortItem({this.dir, this.field});
  String dir;
  String field;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["dir"] = dir;
    data["field"] = field;
    return data;
  }

  String toUrlEncode() {
    return "$field $dir";
  }
}
