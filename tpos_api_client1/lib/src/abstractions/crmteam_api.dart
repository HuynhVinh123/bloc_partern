import 'package:flutter/foundation.dart';
import 'package:tpos_api_client/src/models/entities/crm_team.dart';
import 'package:tpos_api_client/src/models/results/odata_list_result.dart';
import 'package:tpos_api_client/src/models/results/odata_result.dart';

abstract class CrmTeamApi {
  /// Lấy tất cả [CRMTeam] facebook và mở rộng trường 'Childs'
  Future<OdataListResult<CRMTeam>> getAllFacebook({String expand = 'Childs'});
  Future<OdataListResult<CRMTeam>> getAllChannel();

  /// Kiểm tra xem kênh facebook có thể thêm vào hay không
  Future<bool> checkFacebookAccount(
      {@required String facebookId,
      @required String facebookName,
      @required String facebookAvatar,
      @required String token});

  Future<CRMTeam> insert(CRMTeam data);
  Future<void> patch(CRMTeam crmTeam);
  Future<void> deleteCRMTeam(int id);
}
