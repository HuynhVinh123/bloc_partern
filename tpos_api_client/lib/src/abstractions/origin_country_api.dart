import 'package:tpos_api_client/src/model.dart';

abstract class OriginCountryApi {
  /// Lấy partner ext
  /// https://tmt25.tpos.vn/odata/PartnerExt
  Future<OdataListResult<OriginCountry>> getList({GetOriginCountryForSearchQuery query});
}
