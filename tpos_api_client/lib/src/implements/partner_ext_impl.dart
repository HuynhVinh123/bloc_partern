import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/src/abstractions/partner_ext_api.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

class PartnerExtApiImpl implements PartnerExtApi {
  PartnerExtApiImpl({TPosApiClient apiClient}) {
    _apiClient = apiClient ?? GetIt.instance<TPosApi>();
  }

  TPosApi _apiClient;

  @override
  Future<OdataListResult<PartnerExt>> getList({GetPartnerExtForSearchQuery query}) async {
    final Map<String, dynamic> response =
        await _apiClient.httpGet("/odata/PartnerExt", parameters: query?.toJson(true) );
    return OdataListResult<PartnerExt>.fromJson(response);
  }

}
