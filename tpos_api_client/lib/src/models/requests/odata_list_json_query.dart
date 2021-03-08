import 'package:tpos_api_client/src/model.dart';
import 'package:tpos_api_client/src/models/odata_filter/filter_base.dart';

class OdataListJsonQuery {
  OdataListJsonQuery(
      {this.take, this.skip, this.page, this.pageSize, this.filter, this.sort});
  int take;
  int skip;
  int page;
  int pageSize;
  List<OdataSortItem> sort;
  OdataFilter filter;

  Map<String, dynamic> toJson([bool removeNullValue = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['take'] = take;
    data['skip'] = skip;
    data['page'] = page;
    data['pageSize'] = pageSize;

    if (filter != null) {
      data['filter'] = filter.toJson();
    }

    if (sort != null && sort.isNotEmpty) {
      data['sort'] = sort.map((e) => e.toJson()).toList();
    }

    if (removeNullValue) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
