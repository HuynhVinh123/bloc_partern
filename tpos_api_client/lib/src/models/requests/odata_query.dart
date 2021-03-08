/// Default odata query
class OdataObjectQuery {
  OdataObjectQuery({this.expand, this.expands})
      : assert(!(expands != null && expand != null));

  @Deprecated('Using expands instate')
  final String expand;
  final List<String> expands;

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['\$expand'] = expand;

    if (expands != null && expands.isNotEmpty) {
      data['\$expand'] = expands.join(',');
    }

    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}

class OdataGetListQuery {
  OdataGetListQuery(
      {this.top,
      this.skip,
      this.orderBy,
      this.filter,
      this.count = true,
      this.expand,
      this.format = 'json',
      this.version = -1});
  int top;
  int skip;
  String orderBy;
  String filter;
  String expand;
  String format;
  bool count;
  int version;

  /// Convert property to map of param
  Map<String, dynamic> toMapOfParam([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['\$top'] = top;
    data['\$skip'] = skip;
    data['\$orderBy'] = orderBy;
    data['\$filter'] = filter;
    data['\$count'] = count;
    data['\$expand'] = expand;
    data['Version'] = version;
    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
