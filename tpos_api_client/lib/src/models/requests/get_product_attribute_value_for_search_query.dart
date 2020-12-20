class GetProductAttributeForSearchQuery {
  GetProductAttributeForSearchQuery(
      {this.format = 'json',
      String filter,
      this.count = true,
      this.orderBy = 'Sequence',
      this.attributeId,
      this.keyword,
      this.skip,
      this.top}) {
    this.filter = filter ?? keyword != null ? "contains(tolower(Name),'$keyword')" : 'AttributeId eq $attributeId';
  }

  String format;
  final String orderBy;
  String filter;
  final bool count;
  final String keyword;
  int attributeId;
  int skip;
  int top;

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['\$orderby'] = orderBy;
    data['\$format'] = format;
    data['\$filter'] = filter;
    data['\$skip'] = skip;
    data['\$top'] = top;

    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
