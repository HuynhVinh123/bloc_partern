import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/src/abstractions/tpos_facebook_api.dart';
import 'package:tpos_api_client/src/models/entities/tpos_facebook_winner.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

class TposFacebookApiImpl implements TposFacebookApi {
  TposFacebookApiImpl({TPosApi apiClient}) {
    _apiClient = apiClient ?? GetIt.I<TPosApi>();
  }

  TPosApi _apiClient;

  @override
  Future<OdataListResult<TposFacebookWinner>> getFacebookWinner() async {
    final json = await _apiClient
        .httpGet("/odata/SaleOnline_Facebook_Post/ODataService.GetWinners");

    return OdataListResult.fromJson(json);
  }

  @override
  Future<void> updateFacebookWinner(TposFacebookWinner facebookWinner) async {
    final Map<String, dynamic> model = {};
    model["model"] = facebookWinner.toJson(removeIfNull: true);
    await _apiClient.httpPost(
        "/odata/SaleOnline_Facebook_Post/ODataService.UpdateWinner",
        data: model);
  }
}
