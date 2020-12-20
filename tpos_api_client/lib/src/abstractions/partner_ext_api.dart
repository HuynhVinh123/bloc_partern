import 'package:tpos_api_client/src/model.dart';
import 'package:tpos_api_client/src/models/requests/get_partner_ext_for_search_query.dart';


abstract class PartnerExtApi {
  /// Lấy partner ext
  /// https://tmt25.tpos.vn/odata/PartnerExt
  Future<OdataListResult<PartnerExt>> getList({GetPartnerExtForSearchQuery query});
}
