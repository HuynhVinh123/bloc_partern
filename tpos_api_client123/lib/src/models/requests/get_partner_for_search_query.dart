class GetPartnerForSearchQuery {
  GetPartnerForSearchQuery({
    this.skip,
    this.format = 'json',
    this.top = 50,
    String filter,
    this.select = 'Id,Name,Street,Phone,Facebook',
    this.orderBy = 'DisplayName',
    this.isCustomer,
    this.isSupplier,
    this.keyword,
    this.count = true,
    this.onlyActive = false,
  }) {
    filter = filter ??
        "(Customer eq $isCustomer and Supplier eq $isSupplier and (contains(DisplayName,'$keyword') or contains(NameNoSign,'$keyword') or contains(Phone,'$keyword') or contains(Zalo,'$keyword')))";
  }
  final String format;
  final int top;
  String filter;
  final bool count;
  final int skip;
  final String select;
  final String orderBy;
  final bool isCustomer;
  final bool isSupplier;
  final String keyword;
  final bool onlyActive;

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['\$format'] = format;
    data['\$top'] = top;
    data['\$filter'] = filter;
    data['\$count'] = count;
    data['\$skip'] = skip;
    data['\$select'] = select;
    data['\$orderby'] = orderBy;
    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
