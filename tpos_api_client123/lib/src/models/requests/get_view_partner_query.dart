class GetViewPartnerQuery {
  GetViewPartnerQuery(
      {this.skip,
      this.format = 'json',
      this.top = 50,
      this.filter = '(Customer eq true and Active eq true)',
      this.count = true});
  final String format;
  final int top;
  final String filter;
  final bool count;
  final int skip;

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['\$format'] = format;
    data['\$top'] = top;
    data['\$filter'] = filter;
    data['\$count'] = count;
    data['\$skip'] = skip;
    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
