/// Query body cho hàm [getProductTemplateStockMoves] trong class [StockMoveApi]
class GetProductTemplateStockMoveQuery {
  GetProductTemplateStockMoveQuery(
      {this.productTmplId,
      this.format = 'json',
      this.orderby = 'Name',
      this.filter,
      this.top = 5,
      this.skip = 0,
      this.count = true});

  int productTmplId;
  String format;
  int top;
  int skip;
  String orderby;
  String filter;
  bool count;

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productTmplId'] = productTmplId;

    data['\$top'] = top;
    data['\$orderby'] = orderby;
    data['\$filter'] = filter;
    data['\$skip'] = skip;
    data['\$count'] = count;
    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
