import 'package:tpos_api_client/src/models/odata_filter/filter_base.dart';

import '../../../tpos_api_client.dart';
import 'odata_list_json_query.dart';

class GetFastSaleOrderQuery extends OdataListJsonQuery {
  GetFastSaleOrderQuery(
      {int take,
      int skip,
      int page,
      int pageSize,
      OdataFilter filter,
      List<OdataSortItem> sort})
      : super(
            take: take,
            skip: skip,
            page: page,
            pageSize: pageSize,
            filter: filter,
            sort: sort);

  factory GetFastSaleOrderQuery.getList() {
    return GetFastSaleOrderQuery(take: 50, skip: 0, page: 1, pageSize: 50);
  }
}
