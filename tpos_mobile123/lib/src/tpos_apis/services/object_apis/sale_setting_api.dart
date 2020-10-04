import 'dart:convert';

import 'package:tpos_mobile/src/tpos_apis/models/sale_setting.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_service_base.dart';

abstract class ISaleSettingApi {
  /// Lấy cấu hình bán hàng nhanh
  Future<SaleSetting> getDefault();
  Future<SaleSetting> update(SaleSetting setting);

  /// Áp dụng cấu hình
  Future<void> execute(int settingId);

  Future<void> updateAndExecute(SaleSetting setting);
}

class SaleSettingApi extends ApiServiceBase implements ISaleSettingApi {
  @override
  Future<SaleSetting> update(SaleSetting setting) async {
    var response = await apiClient.httpPost(
      path: "/odata/SaleSettings",
      body: jsonEncode(
        setting.toJson(),
      ),
    );
    if (response.statusCode == 201) {
      return SaleSetting.fromJson(jsonDecode(response.body));
    }
    throwTposApiException(response);
    return null;
  }

  @override
  Future<SaleSetting> getDefault() async {
    var response = await apiClient.httpGet(
      path: "/odata/SaleSettings/ODataService.DefaultGet",
      param: {
        "\$expand": "SalePartner,DeliveryCarrier,Tax,Product",
      },
    );
    if (response.statusCode == 200) {
      return SaleSetting.fromJson(jsonDecode(response.body));
    }
    throwTposApiException(response);
    return null;
  }

  @override
  Future<void> execute(int settingId) async {
    var response = await apiClient.httpPost(
      path: "/odata/SaleSettings/ODataService.Excute",
      body: jsonEncode({"id": settingId}),
    );
    if (response.statusCode != 204) {
      throwTposApiException(response);
    }
    return null;
  }

  @override
  Future<void> updateAndExecute(SaleSetting setting) async {
    var newSetting = await update(setting);
    await execute(newSetting.id);
  }
}
