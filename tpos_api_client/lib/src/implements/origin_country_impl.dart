import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/src/abstractions/origin_country_api.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

class OriginCountryApiImpl implements OriginCountryApi {
  OriginCountryApiImpl({TPosApiClient apiClient}) {
    _apiClient = apiClient ?? GetIt.instance<TPosApi>();
  }

  TPosApi _apiClient;

  @override
  Future<OdataListResult<OriginCountry>> getList({GetOriginCountryForSearchQuery query}) async {
    final Map<String, dynamic> response =
        await _apiClient.httpGet("/odata/OriginCountry", parameters: query?.toJson(true));
    return OdataListResult<OriginCountry>.fromJson(response);
  }
}
