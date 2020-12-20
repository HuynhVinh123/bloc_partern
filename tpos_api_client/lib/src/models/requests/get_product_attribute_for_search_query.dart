class GetProductAttributeLineForSearchQuery {
  GetProductAttributeLineForSearchQuery({
    this.format = 'json',
    String filter,
    this.keyword = '',
    this.count = true,
    this.attributeId,
    this.orderby,
  }) {
    this.filter =
    filter ?? keyword != null ? "contains(tolower(Name),'$keyword')" : 'AttributeId eq $attributeId';
  }

  String format;
  final String orderby;
  String filter;
  final String keyword;
  final bool count;
  int attributeId;

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['\$format'] = format;
    data['\$filter'] = filter;
    data['\$count'] = count;
    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }

}
