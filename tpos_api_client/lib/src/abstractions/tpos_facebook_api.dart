import 'package:tpos_api_client/tpos_api_client.dart';

abstract class TposFacebookApi {
  Future<OdataListResult<TposFacebookWinner>> getFacebookWinner();
  Future<void> updateFacebookWinner(TposFacebookWinner facebookWinner);
}
