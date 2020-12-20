class OdataListQuery {
  OdataListQuery(
      {this.format = 'json',
      this.count = true,
      this.filter = 'IsDelete eq false',
      this.top = 50,
      this.orderBy = 'ParentLeft',
      this.sort,
      this.skip = 0});

  String format;
  int top;
  int skip;
  String orderBy;
  String sort;
  String filter;
  bool count;

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['\$format'] = format;
    data['\$top'] = top;
    data['\$skip'] = skip;
    data['\$orderBy'] = orderBy;
    data['\$sort'] = sort;
    data['\$filter'] = filter;
    data['\$count'] = count;
    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
