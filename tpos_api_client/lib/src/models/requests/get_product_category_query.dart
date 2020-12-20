import 'package:tpos_api_client/src/abstraction.dart';

/// Query body cho hàm [getList] trong class [ProductTemplateApi]
class GetProductCategoryQuery {
  GetProductCategoryQuery(
      {this.top = 50,
      this.skip = 0,
      this.filter = 'IsDelete eq false',
      this.orderby = 'ParentLeft',
      this.format = 'json',
      this.count = true});

  int top;
  int skip;
  String filter;
  String format;
  String orderby;
  bool count;

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['\format'] = format;
    data['\$top'] = top;
    data['\$skip'] = skip;
    data['\$orderby'] = orderby;
    data['\$filter'] = filter;
    data['\count'] = count;
    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
