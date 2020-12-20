import 'package:tpos_api_client/src/abstraction.dart';

/// Query body cho hàm [getList] trong class [ProductTemplateApi]
class GetProductTemplateQuery {
  GetProductTemplateQuery({this.take, this.skip, this.sort, this.filter});

  int take;
  int skip;
  Map<String, dynamic> sort;
  Map<String, dynamic> filter;

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['take'] = take;
    data['skip'] = skip;
    data['sort'] = sort != null ? [sort] : null;
    data['filter'] = sort != null ? filter : null;
    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
