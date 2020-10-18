/// Default odata query
class OdataObjectQuery {
  OdataObjectQuery({this.expand});
  final String expand;
}

class OdataGetListQuery {
  OdataGetListQuery({
    this.top,
    this.skip,
    this.orderBy,
    this.filter,
    this.count,
  });
  int top;
  int skip;
  String orderBy;
  String filter;
  bool count;

  /// Convert property to map of param
  Map<String, dynamic> toMapOfParam([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['top'] = top;
    data['skip'] = skip;
    data['orderBy'] = orderBy;
    data['filter'] = filter;
    data['count'] = count;
    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
