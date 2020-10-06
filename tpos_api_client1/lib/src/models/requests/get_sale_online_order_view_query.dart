class GetSaleOnlineOrderViewQuery {
  GetSaleOnlineOrderViewQuery(
      {this.top, this.skip, this.orderBy, this.filter, this.count});
  int top;
  int skip;
  String orderBy;
  String filter;
  bool count;

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
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
