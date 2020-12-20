import 'package:facebook_api_client/facebook_api_client.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/helpers/helpers.dart';

import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';

import 'package:tpos_mobile/src/tpos_apis/models/sale_online_facebook_post_summary_user.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_api.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class SaleOnlineFacebookPostSummaryViewModel extends ViewModel {
  SaleOnlineFacebookPostSummaryViewModel(
      {SaleOnlineFacebookPostSummaryViewModel tposApi}) {
    _tposApi = tposApi ?? locator<ITposApiService>();
  }
  final Logger _log = Logger("SaleOnlineFacebookPostSummaryViewModel");
  ITposApiService _tposApi;
  String _postId;
  CRMTeam _crmTeam;

  SaleOnlineFacebookPostSummaryUser _summary;

  List<DetailItemModel> _details;
  Map<String, GetFacebookPartnerResult> _partners;

  SaleOnlineFacebookPostSummaryUser get summary => _summary;
  List<DetailItemModel> get details => _details;
  Map<String, GetFacebookPartnerResult> get partners => _partners;

  void init({
    @required String postId,
    @required CRMTeam crmTeam,
  }) {
    assert(postId != null);
    _postId = postId;
    _crmTeam = crmTeam;
  }

  GetFacebookPartnerResult getPartner(String uid) {
    if (_partners != null) {
      return _partners[uid];
    }
    return null;
  }

  Future<void> initCommand() async {
    assert(_postId != null);
    onStateAdd(true, message: "${S.current.loading}...");
    try {
      await _loadSummary();
      notifyListeners();
    } catch (e, s) {
      _log.severe("", e, s);
      onDialogMessageAdd(OldDialogMessage.error("", "", error: e));
    }
    onStateAdd(false, message: "${S.current.loading}...");
    notifyListeners();
  }

  Future<void> _loadSummary() async {
    _summary = await _tposApi.getSaleOnlineFacebookPostSummaryUser(
      _postId,
      crmTeamId: _crmTeam?.id,
    );
    _partners = await _tposApi.getFacebookPartners(_crmTeam.id); //Chú ý
  }

  Future<void> refreshCommand() async {
    await initCommand();
  }
}

class DetailItemModel {
  DetailItemModel({this.user, this.partner});
  Users user;
  GetFacebookPartnerResult partner;
}
