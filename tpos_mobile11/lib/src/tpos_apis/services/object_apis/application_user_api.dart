import 'dart:convert';

import 'package:tpos_mobile/feature_group/pos_order/models/application_user.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_service_base.dart';

abstract class IApplicationUserApi {
  /// Lấy danh sách người dùng ứng dụng
  Future<List<PosApplicationUser>> getAll();

  ///Chuyển công ty người dùng
  Future<void> switchCompany(int companyId);
}

class ApplicationUserApi extends ApiServiceBase implements IApplicationUserApi {
  @override
  Future<List<PosApplicationUser>> getAll() async {
    final response = await apiClient.httpGet(
      path: "/odata/ApplicationUser",
      param: {"\$count": true},
    );

    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);

      return (json["value"] as List)
          .map((f) => PosApplicationUser.fromJson(f))
          .toList();
    }

    throwTposApiException(response);
    return null;
  }

  @override
  Future<void> switchCompany(int companyId) async {
    Map<String, dynamic> bodyMap = {"companyId": companyId};
    var response = await apiClient.httpPost(
      path: "/odata/ApplicationUser/ODataService.SwitchCompany",
      body: jsonEncode(bodyMap),
    );
    if (response.statusCode == 204) {
      return true;
    } else {
      throw new Exception("${response.statusCode}, ${response.reasonPhrase}");
    }
  }
}
