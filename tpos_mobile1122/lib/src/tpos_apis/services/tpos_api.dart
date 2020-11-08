import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:facebook_api_client/facebook_api_client.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/mail_template/mail_template.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/data_helper.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/pos_make_payment.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/pos_order.dart';
import 'package:tpos_mobile/feature_group/reports/business_result.dart';
import 'package:tpos_mobile/feature_group/reports/statistic_report/viewmodels/report_dashboard_viewmodel.dart';
import 'package:tpos_mobile/feature_group/reports/thong_ke_giao_hang/report_delivery.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/FacebookWinner.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/fetch_comment.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/tpos_service/calculate_fee_result.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/tpos_service/create_invoice_from_app_request.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/tpos_service/odata_filter.dart';
import 'package:tpos_mobile/feature_group/sale_online/services/tpos_api_service.dart';
import 'package:tpos_mobile/feature_group/sale_order/sale_order.dart';
import 'package:tpos_mobile/feature_group/sale_order/sale_order_line.dart';
import 'package:tpos_mobile/feature_group/sale_quotation/models/base_model_sale_quotation.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/app_setting_service.dart';
import 'package:tpos_mobile/services/log_services/log_service.dart';

import 'package:tpos_mobile/src/tpos_apis/models/facebook_account.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_purchase_order.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_purchase_order_account_tax.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_purchase_order_application_user.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_purchase_order_partner.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_purchase_order_payment.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_purchase_order_stock_picking_type.dart';
import 'package:tpos_mobile/src/tpos_apis/models/get_ship_token_result_model.dart';
import 'package:tpos_mobile/src/tpos_apis/models/order_line.dart';
import 'package:tpos_mobile/src/tpos_apis/models/partner_detail_report.dart';
import 'package:tpos_mobile/src/tpos_apis/models/partner_report.dart';
import 'package:tpos_mobile/src/tpos_apis/models/partner_staff_detail_report.dart';
import 'package:tpos_mobile/src/tpos_apis/models/product_cateogry_for_stock_ware_house_report.dart';
import 'package:tpos_mobile/src/tpos_apis/models/register_tpos_result.dart';
import 'package:tpos_mobile/src/tpos_apis/models/sale_quotation.dart';
import 'package:tpos_mobile/src/tpos_apis/models/sale_quotation_detail.dart';
import 'package:tpos_mobile/src/tpos_apis/models/status_extra.dart';
import 'package:tpos_mobile/src/tpos_apis/models/stock_report_result.dart';
import 'package:tpos_mobile/src/tpos_apis/models/supplier_report.dart';
import 'package:tpos_mobile/src/tpos_apis/models/tpos_city.dart';
import 'package:tpos_mobile/src/tpos_apis/models/user_activities.dart';
import 'package:tpos_mobile/src/tpos_apis/models/user_facebook_comment.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_models.dart';

import '../tpos_helper_download.dart';

class TposApiService implements ITposApiService {
  TposApiService({
    TposApiClient tposClient,
    ISettingService setting,
  }) {
    _log = locator<LogService>();
    _tposClient = tposClient ?? locator<TposApiClient>();
    _setting = setting ?? locator<ISettingService>();
    _log.info("TposApiService Created");
  }
  LogService _log;
  TposApiClient _tposClient;
  ISettingService _setting;

  /// Hàm lấy Danh sách City
  Future<List<CityAddress>> getCityAddress() async {
    final body = json.encode({" provider": "Undefined"});
    var results;
    try {
      final response = await http.post(
        "https://aship.skyit.vn/api/ApiShippingCity/GetCities",
        headers: {
          "Content-type": "application/json",
          "accept": "application/json",
        },
        body: body,
      );
      print("Response status: ${response.statusCode}");
      //
      if (response.statusCode == 200) {
        print("Response body: ${response.body}");
        var jsonMap = jsonDecode(response.body);
        final cityAddress = jsonMap as List;

        results = cityAddress.map((map) {
          return CityAddress.fromMap(map);
        }).toList();
      } else {
        print("Response status: ${response.statusCode}");
      }
    } catch (ex) {
      print(ex.toString());
    }
    return results;
  }

  @override
  Future<TposUser> getLoginedUserInfo() async {
    final response = await _tposClient.httpGet(path: "/rest/v1.0/user/info");
    if (response.statusCode == 200) {
      return TposUser.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("${response.statusCode}, ${response.reasonPhrase}");
    }
  }

  /// Hàm lấy Danh sách District
  Future<List<DistrictAddress>> getDistrictAddress(String cityCode) async {
    var data = {
      "data": {"code": cityCode},
      "provider": "Undefined"
    };
    var results;
    try {
      final response = await http.post(
        "https://aship.skyit.vn/api/ApiShippingDistrict/GetDistricts",
        headers: {
          "Content-type": "application/json",
          "accept": "application/json",
        },
        body: jsonEncode(data),
      );
      print("Response status: ${response.statusCode}");
      //
      if (response.statusCode == 200) {
        print("Response body: ${response.body}");
        final jsonMap = jsonDecode(response.body);
        var districtAddress = jsonMap as List;

        results = districtAddress.map((map) {
          return DistrictAddress.fromMap(map);
        }).toList();
      } else {
        print("Response status: ${response.statusCode}");
      }
    } catch (ex) {
      print(ex.toString());
    }
    return results;
  }

  /// Hàm lấy Danh sách Ward
  Future<List<WardAddress>> getWardAddress(String districtCode) async {
    var results;
    final data = {
      "data": {"code": districtCode},
      "provider": "Undefined"
    };
    try {
      var response = await http.post(
        "https://aship.skyit.vn/api/ApiShippingWard/GetWards",
        headers: {
          "Content-type": "application/json",
          "accept": "application/json",
        },
        body: jsonEncode(data),
      );
      print("Response status: ${response.statusCode}");
      //
      if (response.statusCode == 200) {
        print("Response body: ${response.body}");
        final jsonMap = jsonDecode(response.body);
        final wardAddress = jsonMap as List;

        results = wardAddress.map((map) {
          return WardAddress.fromMap(map);
        }).toList();
      } else {
        print("Response status: ${response.statusCode}");
      }
    } catch (ex) {
      print(ex.toString());
    }
    return results;
  }

  @override
  Future<CheckFacebookIdResult> checkFacebookId(
      String asUid, String postId, int teamId,
      {int timeoutSecond = 1000}) async {
    final response = await _tposClient.httpGet(
        path: "/api/facebook/checkfacebookid",
        param: {
          "asuid": asUid,
          "postid": postId,
          "teamId": teamId,
        }..removeWhere((key, value) => value == null),
        timeoutInSecond: timeoutSecond);

    if (response.statusCode == 200)
      return CheckFacebookIdResult.fromJson(jsonDecode(response.body));
    throwTposApiException(response);
    return null;
  }

  @override
  Future<Map<String, dynamic>> checkPartnerJson({String aSUId}) async {
    final response = await _tposClient.httpGet(
      path: "/odata/SaleOnline_Order/ODataService.CheckPartner",
      param: {"ASUId": aSUId},
    );
    return jsonDecode(response.body);
  }

  @override
  Future<List<SaleOnlineStatusType>> getSaleOnlineOrderStatus() async {
    final response = await _tposClient.httpGet(
      path: "/json/SaleOnline_StatusType",
      param: {},
    );
    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body);
      return (jsonMap as List)
          .map((status) => SaleOnlineStatusType.fromJson(status))
          .toList();
    }

    throwTposApiException(response);
    return null;
  }

  @override
  Future<List<LiveCampaign>> getAvaibleLiveCampaigns() async {
    final response = await _tposClient.httpGet(
      path: "/odata/SaleOnline_LiveCampaign/ODataService.GetAvailables",
      param: {},
    );
    if (response.statusCode == 200) {
      var jsonMap = jsonDecode(response.body);
      return (jsonMap["value"] as List)
          .map((status) => LiveCampaign.fromJson(status))
          .toList();
    }
    throwTposApiException(response);
    return null;
  }

  @override
  Future<List<LiveCampaign>> getLiveCampaigns() async {
    final response = await _tposClient.httpGet(
      path: "/odata/SaleOnline_LiveCampaign",
      param: {},
    );

    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body);
      return (jsonMap["value"] as List)
          .map((status) => LiveCampaign.fromJson(status))
          .toList();
    }
    throwTposApiException(response);
    return null;
  }

  Future<LiveCampaign> getDetailLiveCampaigns(String liveCampaignId) async {
    final response = await _tposClient.httpGet(
      path: "/odata/SaleOnline_LiveCampaign($liveCampaignId)",
      param: {
        "\$expand": "Details",
      },
    );
    if (response.statusCode == 200) {
      var jsonMap = jsonDecode(response.body);
      return LiveCampaign.fromJson(jsonMap);
    }
    throwTposApiException(response);
    return null;
  }

  @override
  Future<bool> addLiveCampaign({LiveCampaign newLiveCampaign}) async {
    final jsonMap = newLiveCampaign.toJson();
    jsonMap.removeWhere((key, value) {
      return value == null;
    });

    var response = await _tposClient.httpPost(
      path: "/odata/SaleOnline_LiveCampaign",
      body: jsonEncode(
        jsonMap,
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) return true;
    throwTposApiException(response);
    return false;
  }

  @override
  Future<bool> editLiveCampaign(LiveCampaign editLiveCampaign) async {
    final jsonMap = editLiveCampaign.toJson();

    var response = await _tposClient.httpPut(
      path: "/odata/SaleOnline_LiveCampaign(${editLiveCampaign.id})",
      body: jsonEncode(jsonMap),
    );
    if (response.statusCode == 204) return true;
    return false;
  }

  @override
  Future<Map<String, GetFacebookPartnerResult>> getFacebookPartners(
      int teamId) async {
    final response = await _tposClient.httpGet(
      path: "/api/common/getfacebookpartners",
      param: {"legacy": false, "teamId": teamId}
        ..removeWhere((key, value) => value == null),
    );

    if (response.statusCode == 200) {
      Map<String, GetFacebookPartnerResult> results =
          new Map<String, GetFacebookPartnerResult>();
      final jsonD = jsonDecode(response.body);
      jsonD.forEach((key, value) {
        results[key] = GetFacebookPartnerResult.fromJson(value);
      });

      return results;
    }

    throwTposApiException(response);
    return null;
  }

  @override
  Future<List<SaleOnlineOrder>> getOrdersByFacebookPostId(String postId) async {
    final response = await _tposClient.httpGet(
      path: "/odata/SaleOnline_Order/ODataService.GetOrdersByPostId",
      param: {
        "PostId": postId,
        "orderby": "DateCreated esc",
        "count": true,
      },
    );

    if (response.statusCode == 200) {
      var jsonMap = jsonDecode(response.body);
      return (jsonMap["value"] as List).map((map) {
        return SaleOnlineOrder.fromJson(map);
      }).toList();
    }
    throwTposApiException(response);
    return null;
  }

  /// Tải danh sách
  Future<int> getProductQuantityByPostId(String postId) async {
    final response = await _tposClient.httpGet(
      path: "/odata/SaleOnline_Order/ODataService.GetOrdersProductSumByPostId",
      param: {
        "PostId": postId,
      },
    );

    print(response.body);
    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body);
      return jsonMap["value"].toInt();
    }
    throwTposApiException(response);
    return null;
  }

  @override
  Future<SaleOnlineOrder> insertSaleOnlineOrderFromApp(SaleOnlineOrder order,
      {int timeoutSecond = 300}) async {
    assert(order.crmTeamId != null);
    assert(order.facebookAsuid != null);
    assert(order.facebookCommentId != null);
    assert(order.facebookPostId != null);
    assert(order.note != null);
    assert(order.facebookUserName != null);
    final Map jsonMap = order.toJson(true);

    final Map temp = {"model": jsonMap};
    String body = jsonEncode(temp);
    var response = await _tposClient.httpPost(
        path:
            "/odata/SaleOnline_Order/ODataService.InsertFromApp?IsIncrease=True",
        body: body,
        timeOut: Duration(seconds: timeoutSecond));

    if (response.statusCode == 200) {
      final Map resultJonMap = jsonDecode(response.body);

      return SaleOnlineOrder.fromJson(resultJonMap);
    }
    throwTposApiException(response);
    return null;
  }

  @override
  Future<void> updateSaleOnlineOrder(SaleOnlineOrder order) async {
    final Map jsonMap = order.toJson(true);
    jsonMap.removeWhere((key, value) {
      return value == null;
    });

    String body = jsonEncode(jsonMap);
    final response = await _tposClient.httpPut(
      path: "/odata/SaleOnline_Order(${order.id})",
      body: body,
    );

    if (response.statusCode == 204) {
      return null;
    } else {
      throwHttpException(response);
      return null;
    }
  }

  @override
  Future<List<SavedFacebookPost>> getSavedFacebookPost(
      String fromId, List<String> postIds) async {
    Map<String, dynamic> bodyMap = {
      "models": {
        "FromId": fromId,
        "PostIds": postIds,
      },
    };

    final String bodyEncode = jsonEncode(bodyMap);
    final response = await _tposClient.httpPost(
      path: "/odata/SaleOnline_Facebook_Post/ODataService.GetSavedPosts",
      body: bodyEncode,
    );

    if (response.statusCode == 200) {
      final Map returnJsonMap = jsonDecode(response.body);
      return (returnJsonMap["value"] as List)
          .map((item) => SavedFacebookPost.fromJson(item))
          .toList();
    }
    throwTposApiException(response);
    return null;
  }

  @override
  Future<List<SaleOrderLine>> getSaleOrderInfo(int id) async {
    final response = await _tposClient
        .httpGet(path: "/odata/SaleOrder($id)/OrderLines", param: {
      "\$expand": "Product,ProductUOM,InvoiceUOM",
      "\$orderby": "Sequence",
    });

    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body);
      final orderMap = jsonMap["value"] as List;
      return orderMap.map((f) {
        return SaleOrderLine.fromJson(f);
      }).toList();
    }
    throwTposApiException(response);
    return null;
  }

  @override
  Future<bool> resetSaleOnlineOrderSessionIndex() async {
    final response = await _tposClient.httpPost(
        path: "/odata/SaleOnline_Order/ODataService.RefreshSessionIndex");

    if (response.statusCode == 200) {
      final Map jsonMap = jsonDecode(response.body);
      if (jsonMap["value"] != null) {
        return jsonMap["value"];
      } else {
        return null;
      }
    }
    throwTposApiException(response);
    return null;
  }

  Future<SaleOnlineOrder> getOrderById(String orderId) async {
    final response = await _tposClient.httpGet(
        path: "/odata/SaleOnline_Order($orderId)",
        param: {"\$expand": "Details, Partner"});
    if (response.statusCode == 200)
      return SaleOnlineOrder.fromJson(jsonDecode(response.body));
    throwTposApiException(response);
    return null;
  }

  @override
  Future<List<SaleOrderLine>> getSaleOrderLineById(int orderId) async {
    final response = await _tposClient.httpGet(
        path:
            "/odata/SaleOrder($orderId)/OrderLines?\$expand=Product,ProductUOM,InvoiceUOM&\$orderby=Sequence");
    if (response.statusCode == 200) {
      var jsonMap = jsonDecode(response.body);
      final orderMap = jsonMap["value"] as List;
      return orderMap.map((map) {
        return SaleOrderLine.fromJson(map);
      }).toList();
    }
    throwTposApiException(response);
    return null;
  }

  @override
  Future<List<CheckAddress>> quickCheckAddress(String keyword) async {
    final response =
        await _tposClient.httpGet(path: "/home/checkaddress", param: {
      "address": "' + $keyword'",
    });
    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body);
      final checkAddressMap = jsonMap["data"] as List;
      return checkAddressMap.map((map) {
        return CheckAddress.fromMap(map);
      }).toList();
    }
    throwTposApiException((response));
    return null;
  }

  @override
  Future<GetSaleOnlineOrderFromAppResult> getSaleOnlineOrderFromApp(
      List<String> listOrderId) async {
    final bodyMap = {"ids": listOrderId};
    String body = jsonEncode(bodyMap);
    final response = await _tposClient.httpPost(
      path: "/odata/SaleOnline_Order/ODataService.GetOrderFromApp",
      body: body,
    );

    if (response.statusCode == 200)
      return GetSaleOnlineOrderFromAppResult.fromJson(
          jsonDecode(response.body));
    throwTposApiException(response);
    return null;
  }

  @override
  Future<List<DeliveryCarrier>> getDeliveryCarriers() async {
    final response = await _tposClient.httpGet(
      path: "/odata/DeliveryCarrier",
      param: {
        "\$filter": "Active eq true",
        "\$format": "json",
        "\$count": "true",
      },
    );

    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body);
      return (jsonMap["value"] as List)
          .map((f) => DeliveryCarrier.fromJson(f))
          .toList();
    }
    throwTposApiException(response);
    return null;
  }

  @override
  Future<List<DeliveryCarrier>> getDeliveryCarriersList() async {
    final response = await _tposClient.httpPost(
      path: "/DeliveryCarrier/List",
      body: jsonEncode({"take": 50, "skip": 0, "page": 1, "pageSize": 50}),
    );

    if (response.statusCode == 200)
      return (jsonDecode(response.body)["Data"] as List)
          .map((f) => DeliveryCarrier.fromJson(f))
          .toList();
    throwTposApiException(response);
    return null;
  }

  @override
  Future<Map<String, dynamic>> getProductInventory() async {
    final response = await _tposClient.httpGet(
      path: "/rest/v1.0/product/getinventory",
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throwTposApiException(response);
    }
    return null;
  }

  @override
  Future<List<ReportDeliveryOrderLine>> getReportDeliveryOrderDetail(
      int id) async {
    final response = await _tposClient.httpGet(
      path:
          "/odata/FastSaleOrder($id)?\$expand=Partner,User,Warehouse,Company,PriceList,RefundOrder,Account,Journal,PaymentJournal,Carrier,Tax,SaleOrder,OrderLines(\$expand=Product,ProductUOM,Account)",
    );
    if (response.statusCode == 200) {
      var jsonMap = jsonDecode(response.body);
      return (jsonMap["OrderLines"] as List).map((map) {
        return ReportDeliveryOrderLine.fromJson(map);
      }).toList();
    }

    throwTposApiException(response);
    return null;
  }

  @override
  Future<bool> changeLiveCampaignStatus(String liveCampaignId) async {
    final response = await _tposClient.httpPost(
        path: "/SaleOnline_LiveCampaign/Approve?id=$liveCampaignId");

    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body);
      return jsonMap["success"];
    }
    throwTposApiException(response);
    return null;
  }

  @override
  Future<CalculateFeeResultData> calculateShipingFee(
      {int partnerId,
      @required int companyId,
      int carrierId,
      double weight,
      ShipReceiver shipReceiver,
      List<ShipServiceExtra> shipServiceExtras,
      double shipInsuranceFee,
      String shipServiceId,
      String shipServiceName,
      int cashOnDelivery // Dùng cho MyVNPost
      }) async {
    assert(companyId != null);
    final Map bodyMap = {
      "PartnerId": partnerId,
      "CompanyId": companyId,
      "CarrierId": carrierId,
      "ShipWeight": weight,
      "InsuranceFee": shipInsuranceFee ?? 0,
      "ServiceId": shipServiceId,
      "CashOnDelivery": cashOnDelivery,
    };

    if (shipReceiver != null) {
      bodyMap["Ship_Receiver"] = shipReceiver.toJson(removeIfNull: true);
    }

    if (shipServiceExtras != null) {
      bodyMap["ServiceExtras"] =
          shipServiceExtras.map((f) => f.toJson(removeIfNull: true)).toList();
    }

    bodyMap.removeWhere((key, value) => value == null);

    final response = await _tposClient.httpPost(
      path: "/rest/v1.0/fastsaleorder/calculatefee",
      body: jsonEncode(bodyMap),
    );

    String error;
    try {
      error = jsonDecode(response.body)["error_description"];
    } catch (e) {}

    if (error != null) {
      throw Exception(error);
    }

    final jsonMap = getHttpResult(response);
    return CalculateFeeResultData.fromJson(jsonMap);
  }

  @override
  Future<List<SaleOnlineFacebookComment>> getCommentsByUserAndPost(
      {@required String userId, @required String postId}) async {
    assert(userId != null);
    assert(postId != null);
    final response = await _tposClient.httpGet(
        path:
            "/odata/SaleOnline_Facebook_Comment/ODataService.GetCommentsByUserAndPost",
        param: {
          "userId": userId,
          "postId": postId,
        });

    if (response.statusCode == 200)
      return (jsonDecode(response.body)["value"] as List)
          .map((f) => SaleOnlineFacebookComment.fromJson(f))
          .toList();

    throwTposApiException(response);
    return null;
  }

  @override
  Future<bool> updateLiveCampaignFacebook(
      {LiveCampaign campaign,
      TposFacebookPost tposFacebookPost,
      bool isCancel = false}) async {
    final bodyMap = {
      "action": isCancel == true ? "cancel" : "update",
      "model": campaign.toJson(removeNullValue: true),
    };
    String body = jsonEncode(bodyMap);
    await _tposClient.httpPost(
      path:
          "/odata/SaleOnline_LiveCampaign(${campaign.id})/ODataService.UpdateFacebook",
      body: body,
    );

    return true;
  }

  @override
  Future<List<ProductCategory>> getProductCategories() async {
    final response = await _tposClient.httpGet(
        path:
            "/odata/ProductCategory?%24format=json&%24orderby=ParentLeft&%24count=true");
    if (response.statusCode == 200) {
      var jsonMap = jsonDecode(response.body);
      return (jsonMap["value"] as List).map((map) {
        return ProductCategory.fromJson(map);
      }).toList();
    }
    throwTposApiException(response);
    return null;
  }

  @override
  Future<SaleOnlineFacebookPostSummaryUser>
      getSaleOnlineFacebookPostSummaryUser(String id, {int crmTeamId}) async {
    final response = await _tposClient.httpGet(
      path: "/odata/SaleOnline_Facebook_Post/ODataService.GetPostSummary",
      param: {
        "\$expand": "Users,Post",
        "fbid": "$id",
        "teamId": crmTeamId,
      },
    );

    if (response.statusCode == 200)
      return SaleOnlineFacebookPostSummaryUser.fromJson(
          jsonDecode(response.body));
    else
      throwTposApiException(response);
    return null;
  }

  @override
  Future<List<FacebookShareInfo>> getSharedFacebook(String postId, String uid,
      {bool mapUid = false, @required int teamId}) async {
    final response = await _tposClient.httpGet(
        path: "/api/facebook/getshareds",
        param: {
          "uid": uid,
          "objectId": postId,
          "ins": "",
          "fll": "",
          "legacy": false,
          "map": mapUid,
          "teamId": teamId,
        },
        timeoutInSecond: 1200);
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((f) => FacebookShareInfo.fromJson(f))
          .toList();
    } else
      throwTposApiException(response);
    return null;
  }

  @override
  Future<OdataResult<ProductCategory>> getProductCategory(int id) async {
    final response =
        await _tposClient.httpGet(path: "/odata/ProductCategory($id)", param: {
      "\$expand":
          "Parent,StockAccountInputCateg,StockAccountOutputCateg,StockValuationAccount,StockJournal,AccountIncomeCateg,AccountExpenseCateg,Routes",
    });
    return OdataResult.fromJson(jsonDecode(response.body), parseValue: () {
      return ProductCategory.fromJson(jsonDecode(response.body));
    });
  }

  @override
  Future<List<PaymentMethod>> getPaymentMethod() async {
    final response = await _tposClient.httpGet(
      path: "/odata/AccountJournal/ODataService.GetWithCompany",
      param: {
        "\$format": "json",
        "\&filter": "(Type eq 'cash' or Type eq 'bank')",
        "&\$count": true,
        "&select": "id,Name,Code",
      },
    );

    if (response.statusCode == 200) {
      var jsonMap = jsonDecode(response.body);
      return (jsonMap["value"] as List).map((map) {
        return PaymentMethod.fromJson(map);
      });
    }
    throwTposApiException(response);
    return null;
  }

  @override
  Future<FastSaleOrderAddEditData> prepareFastSaleOrder(saleOnlineIds) async {
    final Map temp = {"SaleOnlineIds": saleOnlineIds};
    String body = jsonEncode(temp);
    var response = await _tposClient.httpPost(
      path: "/rest/v1.0/fastsaleorder/prepare",
      body: body,
    );

    if (response.statusCode == 200)
      return FastSaleOrderAddEditData.fromJson(jsonDecode(response.body));
    throwTposApiException(response);
    return null;
  }

  @override
  Future<List<StatusReport>> getStatusReport(startDate, endDate) async {
    final response = await _tposClient.httpGet(
        path: "/api/common/getstatusreport",
        param: {"startDate": startDate, "endDate": endDate});

    if (response.statusCode == 200)
      return (jsonDecode(response.body) as List).map((map) {
        return StatusReport.fromJson(map);
      }).toList();
    throwTposApiException(response);
    return null;
  }

  @override
  Future<List<CompanyOfUser>> getCompanyOfUser() async {
    final response = await _tposClient.httpGet(path: "/Json/GetCompanyOfUser");
    if (response.statusCode == 200) {
      var jsonMap = jsonDecode(response.body);
      return (jsonMap as List).map((map) {
        return CompanyOfUser.fromJson(map);
      }).toList();
    }
    throwTposApiException(response);
    return null;
  }

  @override
  Future<List<UserReportStaff>> getUserReportStaff() async {
    final response = await _tposClient.httpGet(path: "/ReportStaff/GetUser");
    if (response.statusCode == 200) {
      var jsonMap = jsonDecode(response.body);
      return (jsonMap as List).map((map) {
        return UserReportStaff.fromJson(map);
      }).toList();
    }

    throwTposApiException(response);
    return null;
  }

  @override
  Future<ProductCategory> insertProductCategory(productCategory) async {
    final Map jsonMap = productCategory.toJson();
    jsonMap.removeWhere((key, value) {
      return value == null;
    });

    final String body = jsonEncode(jsonMap);
    final response = await _tposClient.httpPost(
      path: "/odata/ProductCategory",
      body: body,
    );

    if (response.statusCode == 201) {
      final Map resultJsonMap = jsonDecode(response.body);
      return ProductCategory.fromJson(resultJsonMap);
    }
    throwTposApiException(response);
    return null;
  }

  @override
  Future<List<ProductUOM>> getProductUOM({uomCateogoryId}) async {
    var param;
    if (uomCateogoryId != null) {
      param = {
        "\$format": "json",
        "\$filter": "CategoryId eq $uomCateogoryId",
        "\$count": "true",
      };
    } else {
      param = {
        "\$format": "json",
        "\$count": "true",
      };
    }
    final response = await _tposClient.httpGet(
      path: "/odata/ProductUOM",
      param: param,
    );

    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body);
      return (jsonMap["value"] as List).map((map) {
        return ProductUOM.fromJson(map);
      }).toList();
    }
    throwTposApiException(response);
    return null;
  }

  @override
  Future<List<ProductUOMLine>> getProductUOMLine(productId) async {
    final param = {
      "\$expand": "UOM",
    };

    final response = await _tposClient.httpGet(
      path: "/odata/ProductTemplate($productId)/UOMLines",
      param: param,
    );

    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body);
      return (jsonMap["value"] as List).map((map) {
        return ProductUOMLine.fromJson(map);
      }).toList();
    }
    throwTposApiException(response);
    return null;
  }

  Future<List<ProductAttributeLine>> getProductAttribute(productId) async {
    final param = {
      "\$expand": "Attribute,Values",
    };

    final response = await _tposClient.httpGet(
      path: "/odata/ProductTemplate($productId)/AttributeLines",
      param: param,
    );
    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body);
      return (jsonMap["value"] as List).map((map) {
        return ProductAttributeLine.fromJson(map);
      }).toList();
    }
    throwTposApiException(response);
    return null;
  }

  //Hàm lấy danh sách Order
  @override
  Future<List<SaleOnlineOrder>> getSaleOnlineOrders(
      {int take,
      int skip,
      int partnerId,
      String facebookPostId,
      int crmTeamId,
      DateTime fromDate,
      DateTime toDate}) async {
    String filterQuery = "";

    //Thêm điều kiện lọc

    //String sortQuery = "";
    List<String> filter = <String>[];

    if (facebookPostId != null)
      filter.add("Facebook_PostId eq $facebookPostId");
    if (partnerId != null) filter.add("PartnerId eq $partnerId");
    if (crmTeamId != null) filter.add("CRMTeamId eq $crmTeamId");
    if (fromDate != null)
      filter.add(
          "DateCreated ge ${DateFormat("yyyy-MM-ddTHH:mm:ss'+00:00'").format(fromDate)}");
    if (toDate != null)
      filter.add(
          "DateCreated le ${DateFormat("yyyy-MM-ddTHH:mm:ss'+00:00'").format(toDate)}");

    filterQuery = filter.join(" and ");

    Map<String, dynamic> paramMap = {
      "\$top": take,
//      "\$orderby": orderBy,
      "\$count": true,
      "\$filter": filterQuery != "" ? "($filterQuery)" : filterQuery,
    };

    paramMap.removeWhere((key, value) => value == null || value == "");

    var response = await _tposClient.httpGet(
      path: "/odata/SaleOnline_Order",
      param: paramMap,
    );

    if (response.statusCode == 200) {
      return (jsonDecode(response.body)["value"] as List)
          .map((f) => SaleOnlineOrder.fromJson(f))
          .toList();
    }
    throwHttpException(response);
    return null;
  }

  @override
  Future<List<SaleOnlineOrder>> getSaleOnlineOrdersFilter(
      {int take, int skip, OdataFilter filter, OdataSortItem sort}) async {
    final Map<String, dynamic> paramMap = <String, dynamic>{};
    if (take != null) {
      paramMap["\$top"] = take;
    }

    if (skip != null) {
      paramMap["\$skip"] = skip;
    }
    if (filter != null) {
      paramMap["\$filter"] = filter.toUrlEncode();
    }
    if (sort != null) {
      paramMap["\$orderby"] = sort.tourlEncode();
    }

//    paramMap["\$Expand"] = "Details";

    var response = await _tposClient.httpGet(
      path: "/odata/SaleOnline_Order/ODataService.GetView",
      param: paramMap,
    );

    if (response.statusCode == 200) {
      return await compute(_getOrder, response.body);
    }
    throwTposApiException(response);
    return null;
  }

  Future<List<ViewSaleOnlineOrder>> getViewSaleOnlineOrderWithFitter(
      {int take, int skip, OdataFilter filter, OdataSortItem sort}) async {
    Map<String, dynamic> paramMap = new Map<String, dynamic>();
    if (take != null) {
      paramMap["\$top"] = take;
    }

    if (skip != null) {
      paramMap["\$skip"] = skip;
    }
    if (filter != null) {
      paramMap["\$filter"] = filter.toUrlEncode();
    }
    if (sort != null) {
      paramMap["\$orderby"] = sort.tourlEncode();
    }

    var response = await _tposClient.httpGet(
        path: "/odata/SaleOnline_Order/ODataService.GetView", param: paramMap);

    if (response.statusCode == 200) {
      return await compute(_getViewOrder, response.body);
    }
    throwTposApiException(response);
    return null;
  }

  static List<SaleOnlineOrder> _getOrder(String json) {
    var jsonMap = jsonDecode(json);
    return (jsonMap["value"] as List).map(
      (map) {
        return SaleOnlineOrder.fromJson(map);
      },
    ).toList();
  }

  static List<ViewSaleOnlineOrder> _getViewOrder(String json) {
    final jsonMap = jsonDecode(json);
    return (jsonMap["value"] as List).map(
      (map) {
        return ViewSaleOnlineOrder.fromJson(map);
      },
    ).toList();
  }

  @override
  Future<FastSaleOrderAddEditData> getFastSaleOrderForEdit(int id) async {
    final response =
        await _tposClient.httpGet(path: "/odata/FastSaleOrder($id)");
    if (response.statusCode == 200)
      return FastSaleOrderAddEditData.fromJson(jsonDecode(response.body));
    throwTposApiException(response);
    return null;
  }

  @override
  Future<String> getBarcodeShip(String id) async {
    var url =
        "${_tposClient.shopUrl}/Web/Barcode?type=Code%20128&value=$id&width=600&height=100";
    return url;
  }

  @override
  Future<TPosApiResult<FastSaleOrderAddEditData>> createFastSaleOrder(
      FastSaleOrderAddEditData order,
      [bool isDraft = false]) async {
    final Map bodyMap = order.toJson(removeIfNull: true);
    String body = jsonEncode(bodyMap);

    final response = await _tposClient.httpPost(
        path:
            "/rest/v1.0/fastsaleorder/create${isDraft ? "?IsDraft=true" : ""}",
        body: body);

    if (response.statusCode == 200) {
      String json = response.body;
      return TPosApiResult(
          result: FastSaleOrderAddEditData.fromJson(jsonDecode(json)["Data"]),
          message: jsonDecode(json)["Message"]);
    } else {
      final String errorMessage = jsonDecode(response.body)["message"];
      if (errorMessage != null) {
        throw Exception("$errorMessage");
      } else {
        throw Exception("${response.reasonPhrase} (${response.statusCode})");
      }
    }
  }

  @override
  Future<List<AccountPaymentTerm>> getAccountPayments() async {
    final response =
        await _tposClient.httpGet(path: "/odata/AccountPaymentTerm", param: {
      "\$format": "json",
      "\$count": "true",
    });
    if (response.statusCode == 200) {
      var jsonMap = jsonDecode(response.body);
      return (jsonMap["value"] as List).map((map) {
        return AccountPaymentTerm.fromJson(map);
      }).toList();
    }
    throwTposApiException(response);
    return null;
  }

  @override
  Future<TPosApiResult<bool>> editProductCategory(productCategory) async {
    final Map jsonMap = productCategory.toJson();
    jsonMap.removeWhere((key, value) {
      return value == null;
    });
    String body = jsonEncode(jsonMap);
    final response = await _tposClient.httpPut(
      path: "/odata/ProductCategory(${productCategory.id})",
      body: body,
    );
    if (response.statusCode.toString().startsWith("2")) {
      return TPosApiResult(error: false, result: true);
    } else {
      final String message = (jsonDecode(response.body))["message"];
      return new TPosApiResult(error: true, result: false, message: message);
    }
  }

  @override
  Future<List<CRMTeam>> getSaleChannelList() async {
    final response = await _tposClient.httpGet(path: "/odata/CRMTeam");

    return (getHttpResult(response)["value"] as List)
        .map((f) => CRMTeam.fromJson(f))
        .toList();
  }

  /// Hàm check địa chỉ
  Future<List<CheckAddress>> checkAddress(String text) async {
    final response = await _tposClient.httpGet(
      path: "/home/checkaddress",
      param: {
        "address": "+ $text",
      },
    );
    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body);
      final checkAddressMap = jsonMap["data"] as List;
      return checkAddressMap.map((map) {
        return CheckAddress.fromMap(map);
      }).toList();
    } else {
      throw Exception("Lỗi request");
    }
  }

  @override
  Future<bool> editSaleChannelById({CRMTeam crmTeam}) async {
    final jsonMap = crmTeam.toJson();
    jsonMap.removeWhere((key, value) {
      return value == null;
    });

    await _tposClient.httpPatch(
      path: "/odata/CRMTeam(${crmTeam.id})",
      body: jsonEncode(
        jsonMap,
      ),
    );

    return true;
  }

  @override
  Future<bool> addSaleChannel({CRMTeam crmTeam}) async {
    final jsonMap = crmTeam.toJson();
    jsonMap.removeWhere((key, value) {
      return value == null;
    });

    var response = await _tposClient.httpPost(
      path: "/odata/CRMTeam/",
      body: jsonEncode(
        jsonMap,
      ),
    );
    if (response.statusCode == 201) return true;
    throwTposApiException(response);
    return false;
  }

  @override
  Future<TPosApiResult<bool>> fastSaleOrderCancelShip(int orderId) async {
    final Map bodyMap = {"id": orderId};
    String body = jsonEncode(bodyMap);
    final response = await _tposClient.httpPost(
      path: "/odata/FastSaleOrder/ODataService.CancelShip",
      body: body,
    );

    if (response.statusCode.toString().startsWith("2")) {
      return new TPosApiResult(result: true);
    } else {
      //Return error and message
      //catch Server Error
      var json = jsonDecode(response.body);
      if (json["error"] != null) {
        var odataError = OdataError.fromJson(json["error"]);
        return TPosApiResult(
            result: false, error: true, message: odataError.message);
      }
      return TPosApiResult(
          result: false,
          error: true,
          message: "${response.statusCode}: ${response.reasonPhrase}");
    }
  }

  @override
  Future<TPosApiResult<bool>> fastSaleOrderCancelOrder(
      List<int> orderIds) async {
    assert(orderIds != null && orderIds.isNotEmpty);
    if (orderIds == null || orderIds.isEmpty) {
      throw Exception("orderIds null");
    }
    final bodyMap = {"ids": orderIds.toList()};
    final response = await _tposClient.httpPost(
        path: "/odata/FastSaleOrder/OdataService.ActionCancel",
        body: jsonEncode(bodyMap));

    if (response.statusCode.toString().startsWith("2")) {
      return TPosApiResult(result: true);
    } else {
      //Return error and message
      var json = jsonDecode(response.body);
      final String error = json["message"];
      return TPosApiResult(
          result: false,
          error: true,
          message: error ?? "${response.statusCode}: ${response.reasonPhrase}");
    }
  }

  @override
  Future<TPosApiResult<bool>> fastSaleOrderConfirmOrder(
      List<int> orderIds) async {
    assert(orderIds != null && orderIds.isNotEmpty);
    if (orderIds == null || orderIds.isEmpty) {
      throw Exception("orderIds null");
    }
    final bodyMap = {"ids": orderIds.toList()};
    String body = jsonEncode(bodyMap);
    final response = await _tposClient.httpPost(
        path: "/odata/FastSaleOrder/OdataService.ActionInvoiceOpen",
        body: body);

    if (response.statusCode.toString().startsWith("2")) {
      final Map resultMap = jsonDecode(response.body);
      final bool success = resultMap["Success"];
      final String error = resultMap["Error"];
      return TPosApiResult(result: success, message: error, error: !success);
    } else {
      //Return error and message
      return TPosApiResult(
          result: false,
          error: true,
          message: "${response.statusCode}: ${response.reasonPhrase}");
    }
  }

  @override
  Future<bool> confirmSaleOrder(int orderId) async {
    assert(orderId != null);
    if (orderId == null) {
      throw Exception("orderId null");
    }
    final bodyMap = {"id": orderId};
    final response = await _tposClient.httpPost(
        path: "/odata/SaleOrder/ODataService.ActionConfirm2",
        body: jsonEncode(bodyMap));

    if (response.statusCode.toString().startsWith("2")) {
      return true;
    } else {
      //Return error and message
      return false;
    }
  }

  @override
  Future<TPosApiResult<bool>> deleteSaleOrder(int id) async {
    assert(id != null);
    final response =
        await _tposClient.httpDelete(path: "/odata/SaleOrder($id)");
    if (response.statusCode.toString().startsWith("2")) {
      return TPosApiResult(error: false, result: true);
    } else {
      final String message = (jsonDecode(response.body))["message"];
      return TPosApiResult(error: true, result: false, message: message);
    }
  }

  @override
  Future<TPosApiResult<bool>> cancelSaleOrder(int orderId) async {
    assert(orderId != null);
    if (orderId == null) {
      throw Exception("orderId null");
    }
    final bodyMap = {"id": orderId};
    final response = await _tposClient.httpPost(
        path: "/odata/SaleOrder/ODataService.ActionCancel2",
        body: jsonEncode(bodyMap));

    if (response.statusCode.toString().startsWith("2")) {
      return TPosApiResult(
          result: true, message: "Đã hủy đơn đặt hàng ", error: !true);
    } else {
      //Return error and message
      Map resultMap = jsonDecode(response.body);
      var error = OdataError.fromJson(resultMap["error"]);
      print(error.message);
      return TPosApiResult(
          result: false, error: true, message: "${error.message}");
    }
  }

  @override
  Future<TPosApiResult<bool>> createSaleOrderInvoice(int orderId,
      {List<int> orderIds}) async {
    assert(orderId != null && orderIds.isNotEmpty);
    if (orderId == null || orderIds.isEmpty) {
      throw Exception("orderId null");
    }
    final bodyMap = {"id": orderId, "ids": orderIds.toList()};
    final response = await _tposClient.httpPost(
        path:
            "/odata/FastSaleOrder/ODataService.DefaultGet?\$expand=Warehouse,User,PriceList,Company,Journal,PaymentJournal,Partner,Carrier,Tax,SaleOrder",
        body: jsonEncode(bodyMap));

    if (response.statusCode.toString().startsWith("2")) {
      final Map resultMap = jsonDecode(response.body);
      final bool success = resultMap["Success"];
      final String error = resultMap["Error"];
      return TPosApiResult(result: success, message: error, error: !success);
    } else {
      //Return error and message
      return TPosApiResult(
          result: false,
          error: true,
          message: "${response.statusCode}: ${response.reasonPhrase}");
    }
  }

  @override
  Future<TPosApiResult<int>> accountPaymentCreatePost(
      AccountPayment data) async {
    final dataMap = data.toJson(true);
    final bodyMap = {"model": dataMap};

    final String body = jsonEncode(bodyMap);
    final response = await _tposClient.httpPost(
        path: "/odata/AccountPayment/OdataService.ActionCreatePost",
        body: body);

    if (response.statusCode.toString().startsWith("2")) {
      final resultMap = jsonDecode(response.body);
      return TPosApiResult(
          error: false, message: "", result: resultMap["value"]);
    } else {
      var erorr = OdataError.fromJson(jsonDecode(response.body));
      return TPosApiResult(
          error: true,
          message: erorr.message ??
              "${response.statusCode}: ${response.reasonPhrase}",
          result: null);
    }
  }

  @override
  Future<TPosApiResult<AccountPayment>> accountPaymentPrepairData(
      int orderId) async {
    final bodyMap = {"orderId": orderId};
    final response = await _tposClient.httpPost(
        path:
            "/odata/AccountPayment/ODataService.DefaultGetFastSaleOrder?\$expand=Currency,FastSaleOrders",
        body: jsonEncode(bodyMap));

    if (response.statusCode.toString().startsWith("2")) {
      final Map resultMap = jsonDecode(response.body);
      return TPosApiResult(
          result: AccountPayment.fromJson(resultMap), error: false);
    } else {
      //Return error and message
      // var odataErorr = OdataError.fromJson(jsonDecode(response.body));
      return TPosApiResult(
          result: null,
          error: true,
          message: "${response.statusCode}: ${response.reasonPhrase}");
    }
  }

  @override
  Future<TPosApiResult<List<AccountJournal>>>
      accountJournalGetWithCompany() async {
    final response = await _tposClient.httpGet(
        path: "/odata/AccountJournal/ODataService.GetWithCompany",
        param: {
          "\$format": "json",
          "\$filter": "(Type eq 'bank' or Type eq 'cash')",
          "\$count": "true",
        });

    if (response.statusCode == 200) {
      final results = (jsonDecode(response.body)["value"] as List)
          .map((f) => AccountJournal.fromJson(f))
          .toList();
      return new TPosApiResult(error: false, result: results);
    } else {
      return TPosApiResult(
          error: true,
          result: null,
          message: "${response.statusCode}: ${response.reasonPhrase}");
    }
  }

  @override
  Future<OdataResult<List<PaymentInfoContent>>> getPaymentInfoContent(
      int orderId) async {
    final response = await _tposClient.httpGet(
        path: "/odata/FastSaleOrder($orderId)/ODataService.GetPaymentInfoJson");

    //if (response == 200) {
    Map jsonMap = jsonDecode(response.body);
    var lists = (jsonMap["value"] as List)
        ?.map((f) => PaymentInfoContent.fromJson(f))
        ?.toList();
    return OdataResult.fromJson(jsonMap, parseValue: () => lists);
  }

  @override
  Future<OdataResult<AccountPayment>> accountPaymentOnChangeJournal(
      int journalId, String paymentType) async {
    final response = await _tposClient.httpGet(
        path: "/odata/AccountPayment/ODataService.OnChangeJournal",
        param: {
          "\$expand": "Currency",
          "journalId": journalId,
          "paymentType": paymentType,
        });

    return OdataResult.fromJson(jsonDecode(response.body), parseValue: () {
      return AccountPayment.fromJson(jsonDecode(response.body));
    });
  }

  @override
  Future<ProductSearchResult<List<ProductCategory>>> productCategorySearch(
      String keyword,
      {int top,
      int skip,
      OdataSortItem sortBy}) async {
    Map<String, dynamic> param = {};
    if (keyword != null && keyword != "") {
      param["\$filter"] = "contains(NameNoSign,'$keyword')";
    }

    if (sortBy != null) {
      param["\$orderby"] = sortBy.tourlEncode();
    }

    if (top != null) {
      param["\$top"] = top;
    }
    if (skip != null) {
      param["\$skip"] = skip;
    }

    param["\$count"] = true;
    var response = await _tposClient.httpGet(
      path: "/odata/ProductCategory",
      param: param,
    );

    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body);
      return ProductSearchResult(
          keyword: keyword,
          error: false,
          resultCount: jsonMap["@odata.count"],
          result: (jsonMap["value"] as List)
              .map((f) => ProductCategory.fromJson(f))
              .toList());
    } else {
      return ProductSearchResult(
          error: true,
          message:
              OdataError.fromJson(jsonDecode(response.body)["error"]).message);
    }
  }

  @override
  Future<List<PrinterConfig>> getPrinterConfigs() async {
    final response = await _tposClient.httpGet(
      path: "/odata/Company_Config/ODataService.GetConfigs",
    );

    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body);
      final printerConfigsMap = jsonMap["PrinterConfigs"] as List;
      return printerConfigsMap.map((map) {
        return PrinterConfig.fromJson(map);
      }).toList();
    } else {
      throw Exception("Lỗi request");
    }
  }

  @override
  Future<void> deletePartner(int id) async {
    assert(id != null);
    final response = await _tposClient.httpDelete(path: "/odata/Partner($id)");
    if (response.statusCode == 204) {
      return null;
    }
    throwTposApiException(response);
    return null;
  }

  @override
  Future<TPosApiResult<bool>> deleteProductCategory(int id) async {
    assert(id != null);
    final response = await _tposClient.httpDelete(
      path: "/odata/ProductCategory($id)",
    );
    if (response.statusCode.toString().startsWith("2")) {
      return TPosApiResult(error: false, result: true);
    } else {
      final String message = (jsonDecode(response.body))["message"];
      return TPosApiResult(error: true, result: false, message: message);
    }
  }

  @override
  Future<OdataResult<List<ApplicationUser>>> getApplicationUsersSaleOrder(
      String keyword) async {
    final response = await _tposClient.httpGet(
      path: "/odata/ApplicationUser",
      param: {
        "\$format": "json",
        "\$count": true,
        "\$filter": "contains(tolower(Name),'$keyword')",
      },
    );

    final Map json = jsonDecode(response.body);
    return OdataResult.fromJson(json, parseValue: () {
      return (json["value"] as List)
          .map((f) => ApplicationUser.fromJson(f))
          .toList();
    });
  }

  @override
  Future<OdataResult<List<StockWareHouse>>>
      getStockWareHouseWithCurrentCompany() async {
    final response = await _tposClient.httpGet(
      path: "/odata/StockWarehouse/ODataService.GetByCompany",
      param: {
        "\$count": true,
        "\$format": "json",
      },
    );

    Map json = jsonDecode(response.body);
    return OdataResult.fromJson(json, parseValue: () {
      return (json["value"] as List)
          .map((f) => StockWareHouse.fromJson(f))
          .toList();
    });
  }

  @override

  ///@odata.context=/odata/$metadata#FastSaleOrder_SaleOnlinePrepare/$entity
  Future<OdataResult<FastSaleOrderSaleLinePrepareResult>>
      getDetailsForCreateInvoiceFromOrder(List<String> saleOnlineIds) async {
    final model = {"ids": saleOnlineIds.toList()};
    final response = await _tposClient.httpPost(
        path: "/odata/SaleOnline_Order/ODataService.GetDetails",
        params: {"\$expand": "orderLines(\$expand=Product,ProductUOM),partner"},
        body: jsonEncode(model));

    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body);
      return OdataResult.fromJson(jsonMap, parseValue: () {
        return FastSaleOrderSaleLinePrepareResult.fromJson(jsonMap);
      });
    } else {
      throwHttpException(response);
      return null;
    }
  }

  @override
  Future<FastSaleOrderLine> getFastSaleOrderLineProductForCreateInvoice({
    FastSaleOrderLine orderLine,
    FastSaleOrder order,
  }) async {
    final Map model = {
      "model": orderLine.toJson(removeIfNull: true),
      "order": order.toJson(removeIfNull: true),
    };

    final response = await _tposClient.httpPost(
      path: "/odata/FastSaleOrderLine/ODataService.OnChangeProduct",
      params: {
        "\$expand": "ProductUOM,Account",
      },
      body: jsonEncode(model),
    );

    if (response.statusCode == 200) {
      return FastSaleOrderLine.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("${response.statusCode} : ${response.reasonPhrase}");
    }
  }

  Future<SaleOrderLine> getSaleOrderLineProductForCreateInvoice({
    SaleOrderLine orderLine,
    SaleOrder order,
  }) async {
    final Map model = {
      "model": orderLine.toJson(removeIfNull: true),
      "order": order.toJson(removeIfNull: true),
    };

    final response = await _tposClient.httpPost(
      path: "/odata/SaleOrderLine/ODataService.OnChangeProduct",
      params: {
        "\$expand": "ProductUOM",
      },
      body: jsonEncode(model),
    );

    if (response.statusCode == 200) {
      return SaleOrderLine.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("${response.statusCode} : ${response.reasonPhrase}");
    }
  }

  @override
  Future<DashboardReport> getDashboardReport(
      {String columnChartValue = "W",
      String columnCharText = "TUẦN NÀY",
      String barChartValue = "W",
      String barChartText = "TUẦN NÀY",
      int barChartOrderValue = 1,
      String barChartOrderText = "THEO DOANH SỐ",
      String lineChartValue = "WNWP",
      String lineChartText = "TUẦN NÀY",
      String overViewValue = "T",
      String overViewText = "HÔM NAY"}) async {
    final response = await _tposClient.httpGet(
      path: "/Home/GeneralDashboard",
      param: {
        "ColumnChartValue": columnChartValue,
        "ColumnCharText": columnCharText,
        "BarChartValue": barChartValue,
        "BarChartText": barChartText,
        "BarChartOrderValue": barChartOrderValue,
        "BarChartOrderText": barChartOrderText,
        "LineChartValue": lineChartValue,
        "LineChartText": lineChartText,
        "OverViewValue": overViewValue,
        "OverViewText": overViewText,
      },
    );

    if (response.statusCode == 200) {
      return DashboardReport.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("error for read data from server");
    }
  }

  @override
  Future<DashboardReportOverView> getDashboardReportOverview(
      {String columnChartValue = "W",
      String columnCharText = "TUẦN NÀY",
      String barChartValue = "W",
      String barChartText = "TUẦN NÀY",
      int barChartOrderValue = 1,
      String barChartOrderText = "THEO DOANH SỐ",
      String lineChartValue = "WNWP",
      String lineChartText = "TUẦN NÀY",
      String overViewValue = "T",
      String overViewText = "HÔM NAY"}) async {
    var response = await _tposClient.httpGet(
      path: "/Home/GetDataOverview",
      param: {
        "ColumnChartValue": columnChartValue,
        "ColumnCharText": columnCharText,
        "BarChartValue": barChartValue,
        "BarChartText": barChartText,
        "BarChartOrderValue": barChartOrderValue,
        "BarChartOrderText": barChartOrderText,
        "LineChartValue": lineChartValue,
        "LineChartText": lineChartText,
        "OverViewValue": overViewValue,
        "OverViewText": overViewText,
      },
    );

    if (response.statusCode == 200) {
      return DashboardReportOverView.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("error for read data from server");
    }
  }

  DateTime lastCheckTime = DateTime.now();

  @override
  Future<String> getFacebookUidFromAsuid(String asuid, int teamId) async {
    if (DateTime.now()
        .add(const Duration(seconds: -30))
        .isAfter(lastCheckTime)) {
      throw Exception("Hành động này chỉ cho phép thực hiện mỗi 30 giây");
    }
    var response =
        await _tposClient.httpGet(path: "/home/checkfacebookid", param: {
      "asuid": asuid,
      "teamId": teamId,
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body)["uid"];
    } else {
      return null;
    }
  }

  @override
  Future<String> getFastSaleOrderPrintDataAsHtml(
      {@required fastSaleOrderId, String type, int carrierId}) async {
    String url = "";
    Map<String, dynamic> param = {};
    switch (type) {
      case "ship":
        url = "/fastsaleorder/PrintShipThuan";
        param = {
          "ids": fastSaleOrderId,
          "carrierId": carrierId,
        }..removeWhere((key, value) => value == null);
        break;
      case "invoice":
        url = "/fastsaleorder/print";
        param = {
          "ids": fastSaleOrderId,
        };
        break;
      case "orderA4":
        break;
    }

    var response = await _tposClient.httpGet(path: url, param: param);
    if (response.statusCode == 200)
      return response.body;
    else
      return null;
  }

  @override
  Future<bool> checkTokenIsValid() async {
    var response = await _tposClient.httpGet(path: "/rest/v1.0/user/info");
    if (response.statusCode == 401 || response.statusCode == 403) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Future<List<MailTemplate>> getMailTemplates() async {
    final response = await _tposClient.httpGet(
      path: "/odata/MailTemplate",
      param: {
        "\$orderby": "Name asc",
        "\$filter": "TypeId eq 'General'",
      },
    );

    if (response.statusCode == 200) {
      var map = jsonDecode(response.body);
      return (map["value"] as List)
          .map((f) => MailTemplate.fromJson(f))
          .toList();
    } else {
      throw Exception("${response.statusCode}, ${response.reasonPhrase}");
    }
  }

  @override
  Future<void> addMailTemplate(MailTemplate template) async {
    Map bodyMap = template.toJson(true);
    final response = await _tposClient.httpPost(
      path: "/odata/MailTemplate",
      body: jsonEncode(bodyMap),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throwTposApiException(response);
      return null;
    }
  }

  @override
  Future<String> getFacebookPSUID({String asuid, String pageId}) async {
    assert(asuid != null && asuid != "");
    assert(pageId != null && pageId != "");
    final response = await _tposClient.httpGet(
      path: "/api/facebook/getfacebookpsuid",
      param: {
        "asuid": asuid,
        "pageid": pageId,
      },
    );

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      final success = json["success"];
      if (success) {
        return json["psid"];
      } else {
        return null;
      }
    } else {
      throw new Exception("${response.statusCode}, ${response.reasonPhrase}");
    }
  }

  @override
  Future<String> insertFacebookPostComment(
      List<TposFacebookPost> posts, int crmTeamId) async {
    assert(crmTeamId != null);
    final bodyMap = {
      "isEnableDeepScan": false,
      "isInitialized": false,
      "models": posts.map((f) => f.toJson(removeNullValue: true)).toList(),
    };

    var json = jsonEncode(bodyMap);
    final response = await _tposClient.httpPost(
        path: "/odata/SaleOnline_Facebook_Post/ODataService.Inserts",
        params: {"CRMTeamId": crmTeamId},
        body: json);

    if (response.statusCode == 200) {
      return jsonDecode(response.body)["Id"];
    } else
      throwHttpException(response);
    return null;
  }

  @override
  Future<List<DeliveryStatusReport>> getFastSaleOrderDeliveryStatusReports(
      {DateTime startDate, DateTime endDate}) async {
    final response = await _tposClient.httpGet(
        path: "/FastSaleOrder/GetStatusReportDelivery",
        param: startDate != null && endDate != null
            ? {
                "startDate": startDate?.toString(),
                "endDate": endDate?.toString(),
              }
            : null);

    if (response.statusCode == 200) {
      if (response.body != null &&
          response.body != "" &&
          response.body != '""' &&
          response.body.length > 10) {
        return (jsonDecode(response.body) as List)
            .map((f) => DeliveryStatusReport.fromJson(f))
            .toList();
      }
    } else {
      throwHttpException(response);
    }
    return null;
  }

  @override
  Future<void> sendFastSaleOrderToShipper(int fastSaleOrderId) async {
    var bodyMap = {"id": fastSaleOrderId};
    var reponse = await _tposClient.httpPost(
      path: "/odata/FastSaleOrder/ODataService.SendToShipper",
      body: jsonEncode(bodyMap),
    );

    if (reponse.statusCode == 200 || reponse.statusCode == 204) {
      return null;
    } else {
      throwTposApiException(reponse);
      return null;
    }
  }

  ///Tắt mở tính năng sale online order
  @override
  Future<ApplicationConfigCurrent> updateSaleOnlineSessionEnable() async {
    final response = await _tposClient.httpPost(
        path: "/odata/SaleOnline_Order/ODataService.UpdateSessionEnable");

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return ApplicationConfigCurrent.fromJson(json);
    } else {
      throwHttpException(response);
      return null;
    }
  }

  @override
  Future<ApplicationConfigCurrent> getCheckSaleOnlineSessionEnable() async {
    final response = await _tposClient.httpGet(
        path: "/odata/SaleOnline_Order/ODataService.CheckSessionEnable");
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return ApplicationConfigCurrent.fromJson(json);
    } else {
      throwHttpException(response);
      return null;
    }
  }

  ///sort:  DateInvoice,AmountTotal,Number
  ///dir asc ,desc
  @override
  Future<List<FastPurchaseOrder>> getFastPurchaseOrderList(
      take, skip, page, pageSize, sort, filter) async {
    final body = {
      "take": take,
      "skip": skip,
      "page": page,
      "pageSize": pageSize,
      "sort": sort,
      "filter": filter
    };
    final response = await _tposClient.httpPost(
        path: "/FastPurchaseOrder/List", body: jsonEncode(body));
    if (response.statusCode == 200) {
      var map = jsonDecode(response.body);
      return (map["Data"] as List).map((f) {
        try {
          //print(f.toString());
          return FastPurchaseOrder.fromJson(f);
        } catch (e) {
          print(e);
          throw new Exception("lỗi nè $e ");
        }
      }).toList();
    } else {
      throwTposApiException(response);
      return null;
    }
  }

  @override
  Future<String> unlinkPurchaseOrder(List<int> ids) async {
    final body = {
      "ids": ids,
    };
    var response = await _tposClient.httpPost(
        path: "/odata/FastPurchaseOrder/ODataService.Unlink",
        body: jsonEncode(body));

    if (response.statusCode == 204) {
      return "Xóa thành công ${ids.length} hóa đơn";
    } else if (response.statusCode == 500) {
      return jsonDecode(response.body)["message"];
    } else {
      throw Exception("${response.statusCode}, ${response.reasonPhrase}");
    }
  }

  @override
  Future<void> sendFacebookPageInbox(
      {@required String message,
      @required int cmrTeamid,
      @required FacebookComment comment,
      @required String facebookPostId}) async {
    assert(message != null);
    assert(cmrTeamid != null && comment != null && facebookPostId != null);
    Map<String, dynamic> body = {
      "Comments": [
        {
          "is_hidden": comment.isHidden,
          "can_hide": comment.canHide,
          "message": comment.message,
          "from": {
            "id": comment.from.id,
            "name": comment.from.name,
            "picture": comment.from.pictureLink,
          },
          "created_time": comment.createdTime?.toString(),
          "facebook_id": comment.id,
          "post": {
            "facebook_id": facebookPostId,
          }
        }
      ],
      "TeamId": cmrTeamid,
      "Message": message,
    };

    final response = await _tposClient.httpPost(
      path: "/api/facebook/sendquickreply",
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      return;
    }
    throwTposApiException(response);
  }

  Future<FastPurchaseOrder> getDetailsPurchaseOrderById(int id) async {
    final response = await _tposClient.httpGet(
        path:
            "/odata/FastPurchaseOrder($id)?\$expand=Partner,PickingType,Company,Journal,Account,User,RefundOrder,PaymentJournal,Tax,OrderLines(\$expand%3DProduct,ProductUOM,Account)");
    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body);
      //debugPrint(JsonEncoder.withIndent('  ').convert(jsonMap));
      return FastPurchaseOrder.fromJson(jsonMap);
    } else {
      //catch error
      throw Exception((jsonDecode(response.body)["message"]) ??
          "${response.statusCode}, ${response.reasonPhrase}");
    }
  }

  Future<Map<String, dynamic>> doPaymentFastPurchaseOrder(
      FastPurchaseOrderPayment fastPurchaseOrderPayment) async {
    final Map<String, dynamic> body = {
      "model": fastPurchaseOrderPayment.toJson(),
    };

    final response = await _tposClient.httpPost(
      path: "/odata/AccountPayment/ODataService.ActionCreatePost",
      body: jsonEncode(body),
    );
    debugPrint(const JsonEncoder.withIndent('  ').convert(body));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 500) {
      return jsonDecode(response.body);
    }
    throw Exception((jsonDecode(response.body)["message"]) ??
        "${response.statusCode}, ${response.reasonPhrase}");
  }

  Future<FastPurchaseOrderPayment> getPaymentFastPurchaseOrderForm(
      int id) async {
    Map<String, dynamic> body = {
      "orderId": id,
    };

    var response = await _tposClient.httpPost(
      path:
          "/odata/AccountPayment/ODataService.DefaultGetFastPurchaseOrder?\$expand=Currency,FastPurchaseOrders",
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      return FastPurchaseOrderPayment.fromJson(jsonDecode(response.body));
    }
    throw Exception((jsonDecode(response.body)["message"]) ??
        "${response.statusCode}, ${response.reasonPhrase}");
  }

  Future<List<JournalFPO>> getJournalOfFastPurchaseOrder() async {
    final response = await _tposClient.httpGet(
        path:
            "/odata/AccountJournal/ODataService.GetWithCompany?%24format=json&%24filter=(Type+eq+%27bank%27+or+Type+eq+%27cash%27)&%24count=true");
    if (response.statusCode == 200) {
      return (jsonDecode(response.body)["value"] as List)
          .map((f) => JournalFPO.fromJson(f))
          .toList();
    } else {
      throw Exception(jsonDecode(response.body)["message"]);
    }
  }

  Future<String> cancelFastPurchaseOrder(List<int> ids) async {
    Map<String, dynamic> body = {"ids": ids};
    final response = await _tposClient.httpPost(
        path: "/odata/FastPurchaseOrder/ODataService.ActionCancel",
        body: jsonEncode(body));
    if (response.statusCode == 204) {
      return "Success";
    } else {
      return jsonDecode(response.body)["message"];
    }
  }

  Future<FastPurchaseOrder> getDefaultFastPurchaseOrder(
      {bool isRefund = false}) async {
    final Map<String, dynamic> body = {
      "model": {"Type": isRefund ? "refund" : "invoice"}
    };
    var response = await _tposClient.httpPost(
        path:
            "/odata/FastPurchaseOrder/ODataService.DefaultGet?\$expand=Company,PickingType,Journal,User,PaymentJournal",
        body: jsonEncode(body));

    if (response.statusCode == 200) {
      debugPrint(const JsonEncoder.withIndent('  ')
          .convert(jsonDecode(response.body)));
      return FastPurchaseOrder.fromJson(jsonDecode(response.body));
    } else {
      throw Exception((jsonDecode(response.body)["message"]) ??
          "${response.statusCode}, ${response.reasonPhrase}");
    }
  }

  Future<List<AccountTaxFPO>> getListAccountTaxFPO() async {
    var response = await _tposClient.httpGet(
        path: "/odata/AccountTax/ODataService.GetWithCompany");
    if (response.statusCode == 200) {
      return (jsonDecode(response.body)["value"] as List)
          .map((f) => AccountTaxFPO.fromJson(f))
          .toList();
    } else {
      throw Exception((jsonDecode(response.body)["message"]) ??
          "${response.statusCode}, ${response.reasonPhrase}");
    }
  }

  Future<List<PartnerFPO>> getListPartnerFPO() async {
    var response = await _tposClient.httpGet(
        path:
            "/odata/Partner?%24format=json&%24top=10&%24filter=(Supplier+eq+true+and+Active+eq+true)&%24count=true");
    if (response.statusCode == 200) {
      return (jsonDecode(response.body)["value"] as List)
          .map((f) => PartnerFPO.fromJson(f))
          .toList();
    } else {
      throw Exception((jsonDecode(response.body)["message"]) ??
          "${response.statusCode}, ${response.reasonPhrase}");
    }
  }

  Future<List<StockPickingTypeFPO>> getStockPickingTypeFPO() async {
    final response = await _tposClient.httpGet(
        path:
            "/odata/StockPickingType/ODataService.GetByCompany?%24format=json&%24filter=Code+eq+%27incoming%27&%24count=true");
    if (response.statusCode == 200) {
      return (jsonDecode(response.body)["value"] as List)
          .map((f) => StockPickingTypeFPO.fromJson(f))
          .toList();
    } else {
      throw Exception((jsonDecode(response.body)["message"]) ??
          "${response.statusCode}, ${response.reasonPhrase}");
    }
  }

  Future<List<PartnerFPO>> getListPartnerByKeyWord(String text) async {
    var response = await _tposClient.httpGet(
      path:
          "/odata/Partner?%24format=json&%24top=10&%24orderby=DisplayName&%24filter=(contains(DisplayName%2C%27$text%27)+or+contains(NameNoSign%2C%27$text%27)+or+contains(Phone%2C%27$text%27))&%24count=true",
    );

    if (response.statusCode == 200) {
      return (jsonDecode(response.body)["value"] as List)
          .map((f) => PartnerFPO.fromJson(f))
          .toList();
    } else {
      throw Exception((jsonDecode(response.body)["message"]) ??
          "${response.statusCode}, ${response.reasonPhrase}");
    }
  }

  Future<List<ApplicationUserFPO>> getApplicationUserFPO() async {
    var response = await _tposClient.httpGet(
      path: "/odata/ApplicationUser?%24format=json&%24count=true",
    );

    if (response.statusCode == 200) {
      return (jsonDecode(response.body)["value"] as List)
          .map((f) => ApplicationUserFPO.fromJson(f))
          .toList();
    } else {
      throw Exception((jsonDecode(response.body)["message"]) ??
          "${response.statusCode}, ${response.reasonPhrase}");
    }
  }

  Future<Account> onChangePartnerFPO(
      FastPurchaseOrder fastPurchaseOrder) async {
    Map<String, dynamic> body = {
      "model": fastPurchaseOrder.toJson(),
    };
    final response = await _tposClient.httpPost(
        path:
            "/odata/FastPurchaseOrder/ODataService.OnChangePartner?\$expand=Account",
        body: jsonEncode(body));
    debugPrint(const JsonEncoder.withIndent('   ').convert(body));
    debugPrint(
        const JsonEncoder.withIndent('   ').convert(jsonDecode(response.body)));
    if (response.statusCode == 200) {
      return Account.fromJson(jsonDecode(response.body)["Account"]);
    } else {
      throw Exception((jsonDecode(response.body)["message"]) ??
          "${response.statusCode}, ${response.reasonPhrase}");
    }
  }

  Future<OrderLine> onChangeProductFPO(
      FastPurchaseOrder fastPurchaseOrder, OrderLine orderLine) async {
    Map<String, dynamic> body = {
      "paramModel": {
        "PartnerId": fastPurchaseOrder.partner.id,
        "DateOrder": dateTimeOffset(fastPurchaseOrder.dateInvoice)
      },
      "model": orderLine.toJson(),
      "order": fastPurchaseOrder.toJsonOnChangeProduct(),
    };

    print(jsonEncode(body["model"]));

    final response = await _tposClient.httpPost(
        path:
            "/odata/FastPurchaseOrderLine/ODataService.OnChangeProduct?\$expand=ProductUOM,Account",
        body: jsonEncode(body));

    if (response.statusCode == 200) {
//      debugPrint(
//          JsonEncoder.withIndent('   ').convert(jsonDecode(response.body)));
      Account account = Account.fromJson(jsonDecode(response.body)["Account"]);
      ProductUOM productUOM =
          ProductUOM.fromJson(jsonDecode(response.body)["ProductUOM"]);
      orderLine.accountId = account.id;
      orderLine.account = account;
      orderLine.productUom = productUOM;
      orderLine.productUOMId = productUOM.id;

      return orderLine;
    } else {
      throw Exception((jsonDecode(response.body)["message"]) ??
          "${response.statusCode}, ${response.reasonPhrase}");
    }
  }

  /// /odata/ProductTemplate(12108)?$expand=UOM
  Future<ProductUOM> getUomFPO(int id) async {
    final response = await _tposClient.httpGet(
        path: "/odata/ProductTemplate($id)?\$expand=UOM");
    if (response.statusCode == 200) {
      debugPrint(const JsonEncoder.withIndent('   ')
          .convert(jsonDecode(response.body)['UOM']));
      return ProductUOM.fromJson(jsonDecode(response.body)["UOM"]);
    } else {
      throw Exception((jsonDecode(response.body)["message"]) ??
          "${response.statusCode}, ${response.reasonPhrase} ${response.body}");
    }
  }

  Future<List<AccountTaxFPO>> getTextFPO() async {
    final response = await _tposClient.httpGet(
        path: "/odata/AccountTax/ODataService.GetWithCompany");
    if (response.statusCode == 200) {
      return (jsonDecode(response.body)["value"] as List)
          .map((f) => AccountTaxFPO.fromJson(f))
          .toList();
    } else {
      throw Exception((jsonDecode(response.body)["message"]) ??
          "${response.statusCode}, ${response.reasonPhrase} ${response.body}");
    }
  }

  Future<FastPurchaseOrder> actionInvoiceDraftFPO(
      FastPurchaseOrder item) async {
    ///gán id
    item.companyId = item.company.id;
    item.journalId = item.journal.id;
    item.partnerId = item.partner.id;
    item.paymentJournalId = item.paymentJournal.id;
    item.pickingTypeId = item.pickingType.id;
    item.userId = item.user.id;
    item.taxId = item.tax != null ? item.tax.id : null;
    item.accountId = item.account.id;

    Map<String, dynamic> body = item.toJson();

    final response = await _tposClient.httpPost(
      path: "/odata/FastPurchaseOrder",
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      return FastPurchaseOrder.fromJsonResponse(jsonDecode(response.body));
    } else {
      throw Exception((jsonDecode(response.body)["message"]) ??
          "${response.statusCode}, ${response.reasonPhrase} ${response.body}");
    }
  }

  Future<bool> actionInvoiceOpenFPO(FastPurchaseOrder item) async {
    Map<String, dynamic> body = {
      "ids": [item.id]
    };
    final response = await _tposClient.httpPost(
        path: "/odata/FastPurchaseOrder/ODataService.ActionInvoiceOpen",
        body: jsonEncode(body));
    debugPrint(const JsonEncoder.withIndent('   ').convert(body));
    if (response.statusCode == 204) {
      return true;
    } else {
      throw Exception((jsonDecode(response.body)["message"]) ??
          "${response.statusCode}, ${response.reasonPhrase} ${response.body}");
    }
  }

  Future<FastPurchaseOrder> actionEditInvoice(FastPurchaseOrder item) async {
    //print("ID của hóa đơn: ${item.id}");

    ///gán id
    item.companyId = item.company.id;
    item.journalId = item.journal.id;
    item.partnerId = item.partner.id;
    item.paymentJournalId = item.paymentJournal.id;
    item.pickingTypeId = item.pickingType.id;
    item.userId = item.user.id;
    item.taxId = item.tax != null ? item.tax.id : null;
    item.accountId = item.account.id;
    item.refundOrderId = item.refundOrder != null ? item.refundOrder.id : null;

    Map<String, dynamic> body = item.toJson();

    final response = await _tposClient.httpPut(
      path: "/odata/FastPurchaseOrder(${item.id})",
      body: jsonEncode(body),
    );
    debugPrint(const JsonEncoder.withIndent('   ').convert(body));

    /// 204 = No content
    if (response.statusCode == 204) {
      return item;
    } else {
      throw Exception((jsonDecode(response.body)["message"]) ??
          "${response.statusCode}, ${response.reasonPhrase} ${response.body}");
    }
  }

  Future<int> createRefundOrder(int id) async {
    Map<String, dynamic> body = {"id": id};
    var response = await _tposClient.httpPost(
        path: "/odata/FastPurchaseOrder/ODataService.ActionRefund",
        body: jsonEncode(body));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)["value"];
    } else {
      throw Exception((jsonDecode(response.body)["message"]) ??
          "${response.statusCode}, ${response.reasonPhrase} ${response.body}");
    }
  }

  @override
  Future<GetInventoryProductResult> getProductInventoryById(
      {int tmplId}) async {
    final response = await _tposClient.httpGet(
      path: "/odata/ProductTemplate/ODataService.GetInventoryProduct",
      param: {
        "productTmplId": tmplId,
        "\$format": tmplId,
        "\$filter": "ProductTmplId eq $tmplId",
        "\$orderby": "Name"
      },
    );
    return GetInventoryProductResult.fromJson(jsonDecode(response.body));
  }

  @override
  Future<dynamic> getDashBoardChart(
      {@required String chartType,
      String columnChartValue = "W",
      String columnCharText = "TUẦN NÀY",
      String barChartValue = "W",
      String barChartText = "TUẦN NÀY",
      int barChartOrderValue = 1,
      String barChartOrderText = "THEO DOANH SỐ",
      String lineChartValue = "WNWP",
      String lineChartText = "TUẦN NÀY",
      String overViewValue = "T",
      String overViewText = "HÔM NAY"}) async {
    var response = await _tposClient.httpGet(
      path: "/Home/$chartType",
      param: {
        "ColumChartValue": columnChartValue,
        "ColumChartText": columnCharText,
        "BarChartValue": barChartValue,
        "BarChartText": barChartText,
        "BarChartOrderValue": barChartOrderValue,
        "BarChartOrderText": barChartOrderText,
        "LineChartValue": lineChartValue,
        "LineChartText": lineChartText,
        "OverViewValue": overViewValue,
        "OverViewText": overViewText,
      },
    );

    if (response.statusCode == 200) {
      if (chartType == "GetDataLine")
        return (jsonDecode(response.body)["Data$lineChartValue"] as List)
            .map((f) => DataLineChart.fromJson(f))
            .toList();
      else if (chartType == "GetSales") {
        return DataColumnChartOverView.fromJson(json.decode(response.body));
      } else if (chartType == "GetSales2") {
        return (jsonDecode(response.body) as List)
            .map((f) => DataPieChart.fromJson(f))
            .toList();
      }
    } else {
      throwTposApiException(response);
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>> getPriceListItems(int priceListId) async {
    final response = await _tposClient.httpGet(
        path: "/api/common/getpricelistitems", param: {"id": priceListId});

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throwTposApiException(response);
    return null;
  }

  Future<FacebookWinner> updateFacebookWinner(
      FacebookWinner facebookWinner) async {
    var model = {};
    model["model"] = facebookWinner.toMap();
    var body = json.encode(model);

    final response = await _tposClient.httpPost(
      path: "/odata/SaleOnline_Facebook_Post/ODataService.UpdateWinner",
      body: body,
    );
    return facebookWinner;
  }

  Future<List<FacebookWinner>> getFacebookWinner() async {
    var results;
    final response = await _tposClient.httpGet(
      path: "/odata/SaleOnline_Facebook_Post/ODataService.GetWinners",
    );
    if (response.statusCode == 200) {
      var jsonMap = jsonDecode(response.body);
      var facebookWinner = jsonMap["value"] as List;

      results = facebookWinner.map((map) {
        return FacebookWinner.fromMap(map);
      }).toList();
    } else {
      throw Exception("Loi request");
    }
    return results;
  }

  @override
  Future<List<String>> getCommentIdsByPostId(String postId) async {
    assert(postId != null);
    final response = await _tposClient.httpGet(
        path: "/odata/SaleOnline_Facebook_Post/ODataService.GetCommentIds",
        param: {"PostId": postId});

    if (response.statusCode == 200) {
      return (jsonDecode(response.body)["value"] as List)
          .map((f) => f.toString())
          .toList();
    }
    throwHttpException(response);
    return null;
  }

  Future<UserActivities> getUserActivities(
      {int skip = 0, int limit = 50}) async {
    var response = await _tposClient.httpGet(
        path: "/api/activity/all?skip=$skip&limit=$limit");
    if (response.statusCode == 200) {
      return UserActivities.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(jsonDecode(response.body)["message"] ?? "Lỗi rồi!");
    }
  }

  @override
  Future<LiveCampaign> getLiveCampaignByPostId(String postId) async {
    var response = await _tposClient.httpGet(
        path: "/odata/SaleOnline_LiveCampaign/ODataService.GetCampaigns",
        param: {
          "\$expand": "Details",
          "liveId": postId,
        });

    if (response.statusCode == 200) {
      final campaigns = (jsonDecode(response.body)["value"] as List)
          .map((f) => LiveCampaign.fromJson(f))
          .toList();
      if (campaigns != null && campaigns.isNotEmpty)
        return campaigns.first;
      else
        return null;
    }
    throwHttpException(response);
    return null;
  }

  Future<bool> doChangeUserPassWord(
      {String oldPassword, String newPassword, String confirmPassWord}) async {
    Map<String, dynamic> body = {
      "OldPassword": "$oldPassword",
      "NewPassword": "$newPassword",
      "ConfirmPassword": "$confirmPassWord"
    };
    debugPrint(
      const JsonEncoder.withIndent('  ').convert(body),
    );
    var response = await _tposClient.httpPost(
      path: "/manage/changepassword",
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 400) {
      return false;
    } else {
      throw Exception("Không thể kết nối máy chủ");
    }
  }

  @override
  Future<void> deleteSaleOnlineOrder(String orderId) async {
    final response =
        await _tposClient.httpDelete(path: "/odata/SaleOnline_Order($orderId)");

    if (response.statusCode != 204) {
      throwTposApiException(response);
    }
  }

  @override
  @override
  Future<void> deleteFastSaleOrder(int orderId) async {
    final response =
        await _tposClient.httpDelete(path: "/odata/FastSaleOrder($orderId)");

    if (response.statusCode != 204) {
      throwTposApiException(response);
    }
  }

  @override
  @override
  Future<void> deletePartnerCategory(int categoryId) async {
    assert(categoryId != null);
    final response = await _tposClient.httpDelete(
        path: "/odata/PartnerCategory($categoryId)");
    if (response.statusCode == 204) return null;
    throwTposApiException(response);
    return null;
  }

  @override
  Future<RegisterTposResult> registerTpos(
      {String name,
      String message,
      String email,
      String company,
      String phone,
      String cityCode,
      String prefix,
      String facebookPhoneValidateToken,
      String facebookUserToken}) async {
    Map<String, dynamic> bodyMap = {
      "Name": name,
      "Message": message,
      "Email": email,
      "Company": company,
      "Telephone": phone,
      "CityCode": cityCode,
      "Prefix": prefix,
      "ProductCode": "TPOS",
      "PackageCode": "BASIC",
      "recaptcha": null,
      "FacebookUserToken": facebookUserToken,
    };
//    }..removeWhere((key, value) => value == null);
    _log.debug(bodyMap);
    final response = await http.post(
      "https://tpos.vn/api/Order/Create",
      headers: {"content-type": "application/json"},
      body: jsonEncode(bodyMap),
    );

    print(response.body);
    if (response.statusCode == 200) {
      return RegisterTposResult.fromJson(jsonDecode(response.body));
    }
    throwTposApiException(response);
    return null;
  }

  @override
  Future<List<TPosCity>> getTposCity() async {
    final response = await http.get("https://tpos.vn/api/City");
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((f) => TPosCity.fromJson(f))
          .toList();
    }

    throwTposApiException(response);
    return null;
  }

  @override
  Future<void> deleteDeliveryCarrier(int carrierId) async {
    assert(carrierId != null);
    final response = await _tposClient.httpDelete(
        path: "/odata/DeliveryCarrier($carrierId)");
    if (response.statusCode == 204) return null;
    throwTposApiException(response);
    return null;
  }

  @override
  Future<void> refreshFastSaleOnlineOrderDeliveryState() async {
    final response = await _tposClient.httpGet(
      path: "/odata/FastSaleOrder/ODataService.UpdateShipOrdersInfo",
    );

    if (response.statusCode != 200) throwTposApiException(response);
    return null;
  }

  @override
  Future<void> refreshFastSaleOrderDeliveryState(List<int> ids) async {
    var response = await _tposClient.httpPost(
      path: "/odata/FastSaleOrder/ODataService.UpdateShipOrderInfo",
      body: jsonEncode({
        "ids": ids.toList(),
      }),
    );

    if (response.statusCode != 204) throwTposApiException(response);
    return null;
  }

  @override
  Future<StockReport> getStockReport({
    DateTime fromDate,
    DateTime toDate,
    bool isIncludeCanceled = false,
    bool isIncludeReturned = false,
    int wareHouseId,
    int productCategoryId,
  }) async {
    final response = await _tposClient.httpPost(
        path: "/StockReport/XuatNhapTon",
        body: jsonEncode({
          "FromDate": fromDate?.toIso8601String(),
          "ToDate": toDate?.toIso8601String(),
          "IncludeCancelled": false,
          "IncludeReturned": false,
          "take": null,
          "skip": null,
          "page": null,
          "pageSize": null,
          "WarehouseId": wareHouseId,
          "ProductCategoryId": productCategoryId,
          "aggregate": [
            {"field": "Begin", "aggregate": "sum"},
            {"field": "Import", "aggregate": "sum"},
            {"field": "Export", "aggregate": "sum"},
            {"field": "End", "aggregate": "sum"}
          ]
        }..removeWhere((key, value) => value == null)));
    if (response.statusCode == 200) {
      return StockReport.fromJson(
        jsonDecode(response.body),
      );
    }
    throwTposApiException(response);
    return null;
  }

  @override
  Future<List<StockWareHouse>> getStockWarehouse() async {
    final response = await _tposClient.httpGet(
        path: "/odata/StockWarehouse?%24format=json&%24count=true");

    if (response.statusCode == 200)
      return (jsonDecode(response.body)["value"] as List)
          .map((f) => StockWareHouse.fromJson(f))
          .toList();
    throwTposApiException(response);
    return null;
  }

  @override
  Future<List<ProductCategoryForStockWareHouseReport>>
      getProductCategoryForStockReport() async {
    var response =
        await _tposClient.httpGet(path: "/StockReport/GetProductCategory");
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((f) => ProductCategoryForStockWareHouseReport.fromJson(f))
          .toList();
    }
    throwTposApiException(response);
    return null;
  }

  @override
  Future<PosOrderResult> getPosOrders(
      {int page,
      int pageSize,
      int skip,
      int take,
      OdataFilter filter,
      List<OdataSortItem> sorts}) async {
    var body = {
      "take": take,
      "skip": skip,
      "page": page,
      "pageSize": pageSize,
      "sort": sorts,
      "filter": filter
    };

    final bodyEncode = jsonEncode(body);
    final response = await _tposClient.httpPost(
      path: "/POS_Order/List",
      body: jsonEncode(body),
    );

    if (response.statusCode == 200)
      return PosOrderResult.fromJson(jsonDecode(response.body));
    throwTposApiException(response);
    return null;
  }

  @override
  Future<TPosApiResult<bool>> deletePosOrder(int id) async {
    assert(id != null);
    final response =
        await _tposClient.httpDelete(path: "/odata/POS_Order($id)");
    if (response.statusCode.toString().startsWith("2")) {
      return TPosApiResult(error: false, result: true);
    } else {
      var json = jsonDecode(response.body);
      if (json["error"] != null) {
        var odataError = OdataError.fromJson(json["error"]);
        return TPosApiResult(
            result: false, error: true, message: odataError.message);
      }
      return TPosApiResult(
          result: false,
          error: true,
          message: "${response.statusCode}: ${response.reasonPhrase}");
    }
  }

  @override
  Future<PosOrder> getPosOrderInfo(int id) async {
    final response = await _tposClient.httpGet(
      path: "/odata/POS_Order($id)",
      param: {
        "\$expand": "Partner,Table,Session,User,PriceList,Tax",
      },
    );

    if (response.statusCode == 200)
      return PosOrder.fromJson(jsonDecode(response.body));
    throwTposApiException(response);
    return null;
  }

  @override
  Future<List<PosOrderLine>> getPosOrderLines(int id) async {
    final response = await _tposClient.httpGet(
        path: "/odata/POS_Order($id)/Lines",
        param: {
          "\$expand": "Product,UOM",
        },
        timeoutInSecond: 1200);
    if (response.statusCode == 200) {
      return (jsonDecode(response.body)["value"] as List)
          .map((f) => PosOrderLine.fromJson(f))
          .toList();
    } else
      throwTposApiException(response);
    return null;
  }

  @override
  Future<List<PosAccountBankStatement>> getPosAccountBankStatement(
      int id) async {
    final response = await _tposClient.httpGet(
        path: "/odata/AccountBankStatementLine",
        param: {
          "\$filter": "PosStatementId+eq+$id",
        },
        timeoutInSecond: 1200);
    if (response.statusCode == 200) {
      return (jsonDecode(response.body)["value"] as List)
          .map((f) => PosAccountBankStatement.fromJson(f))
          .toList();
    } else
      throwTposApiException(response);
    return null;
  }

  @override
  Future<TPosApiResult<String>> refundPosOrder(int id) async {
    assert(id != null);
    final body = {"id": id};

    var response = await _tposClient.httpPost(
      path: "/odata/POS_Order/ODataService.Refund",
      body: jsonEncode(body),
    );

    var json = jsonDecode(response.body);

    if (response.statusCode.toString().startsWith("2")) {
      return TPosApiResult(error: false, result: json["value"].toString());
    } else {
      if (json != null) {
        var odataError = OdataError.fromJson(json);
        return TPosApiResult(error: true, message: odataError.message);
      }
      return TPosApiResult(
          error: true,
          message: "${response.statusCode}: ${response.reasonPhrase}");
    }
  }

  @override
  Future<TPosApiResult<PosMakePayment>> getPosMakePayment(int id) async {
    assert(id != null);
    var body = {"id": id};

    var response = await _tposClient.httpPost(
      path: "/odata/PosMakePayment/ODataService.DefaultGet",
      params: {
        "\$expand": "Journal ",
      },
      body: jsonEncode(body),
    );

    var json = jsonDecode(response.body);
    if (response.statusCode.toString().startsWith("2")) {
      return TPosApiResult(error: false, result: PosMakePayment.fromJson(json));
    } else {
      if (json != null) {
        var odataError = OdataError.fromJson(json);
        return TPosApiResult(error: true, message: odataError.message);
      }
      return TPosApiResult(
          error: true,
          message: "${response.statusCode}: ${response.reasonPhrase}");
    }
  }

  @override
  Future<TPosApiResult<bool>> posMakePayment(
      PosMakePayment payment, int posOrderId) async {
    assert(payment != null);
    final jsonMap = {
      "id": posOrderId,
      "model": payment,
    };

    var body = jsonEncode(jsonMap);

    var response = await _tposClient.httpPost(
      path: "/odata/PosMakePayment/ODataService.Check",
      body: body,
    );

    if (response.statusCode.toString().startsWith("2")) {
      return TPosApiResult(error: false, result: true);
    } else {
      var json = jsonDecode(response.body);
      if (json != null) {
        final odataError = OdataError.fromJson(json);
        return TPosApiResult(error: true, message: odataError.message);
      }
      return TPosApiResult(
          error: true,
          message: "${response.statusCode}: ${response.reasonPhrase}");
    }
  }

  @override
  Future<DeliveryCarrier> getDeliverCarrierCreateDefault() async {
    final response = await _tposClient.httpGet(
        path: "/odata/DeliveryCarrier/ODataService.DefaultGet");

    if (response.statusCode == 200) {
      return DeliveryCarrier.fromJson(jsonDecode(response.body));
    }
    throwTposApiException(response);
    return null;
  }

  @override
  Future<DeliveryCarrier> getDeliveryCarrierById(int id) async {
    final response =
        await _tposClient.httpGet(path: "/odata/DeliveryCarrier($id)", param: {
      "\$expand": "Product,HCMPTConfig",
    });

    if (response.statusCode == 200) {
      return DeliveryCarrier.fromJson(jsonDecode(response.body));
    }
    throwTposApiException(response);
    return null;
  }

  @override
  Future<void> updateDeliveryCarrier(DeliveryCarrier edit) async {
    final response = await _tposClient.httpPut(
      path: "/odata/DeliveryCarrier(${edit.id})",
      body: jsonEncode(edit.toJson(true)),
    );

    if (response.statusCode == 204) {
      return null;
    }
    throwTposApiException(response);
    return null;
  }

  @override
  Future<void> createDeliveryCarrier(DeliveryCarrier item) async {
    final response = await _tposClient.httpPost(
      path: "/odata/DeliveryCarrier",
      body: jsonEncode(item.toJson(true)),
    );

    if (response.statusCode == 201) return null;
    throwTposApiException(response);
    return null;
  }

  @override
  Future<GetShipTokenResultModel> getShipToken(
      {String apiKey,
      String email,
      String host,
      String password,
      String provider}) async {
    var response = await _tposClient.httpPost(
      path: "https://aship.skyit.vn/api/ApiShippingConnect/GetToken",
      useBasePath: false,
      timeOut: const Duration(minutes: 10),
      body: jsonEncode(
        {
          "data": {
            "email": email,
            "password": password,
            "host": _setting.shopUrl?.replaceAll("https://", ""),
            "apiKey": apiKey,
          },
          "provider": provider,
          "config": {"apiKey": ""}
        },
      ),
    );

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return GetShipTokenResultModel.fromJson(json);
    }
    throwTposApiException(response);
    return null;
  }

  @override
  Future<String> getTokenShip() async {
    final response = await _tposClient.httpGet(
        path: "/odata/Company_Config/ODataService.GetTokenShip");
    if (response.statusCode == 200) return (jsonDecode(response.body)["value"]);
    throwTposApiException(response);
    return null;
  }

  @override
  Future<MailTemplateResult> getMailTemplateResult() async {
    var response = await _tposClient.httpGet(
      path: "/odata/MailTemplate",
      param: {
        "\$format": "json",
        "\$top": 100,
        "\$count": "true",
      },
    );

    if (response.statusCode == 200) {
      var map = jsonDecode(response.body);
      return MailTemplateResult.fromJson(map);
    } else {
      throw Exception("${response.statusCode}, ${response.reasonPhrase}");
    }
  }

  @override
  Future<MailTemplate> getMailTemplateById(int id) async {
    final response =
        await _tposClient.httpGet(path: "/odata/MailTemplate($id)");

    if (response.statusCode == 200) {
      return MailTemplate.fromJson(jsonDecode(response.body));
    }
    throwTposApiException(response);
    return null;
  }

  @override
  Future<TPosApiResult<bool>> deleteMailTemplate(int id) async {
    assert(id != null);
    var response =
        await _tposClient.httpDelete(path: "/odata/MailTemplate($id)");
    if (response.statusCode.toString().startsWith("2")) {
      return new TPosApiResult(error: false, result: true);
    } else {
      var json = jsonDecode(response.body);
      if (json["error"] != null) {
        var odataError = OdataError.fromJson(json["error"]);
        return TPosApiResult(
            result: false, error: true, message: odataError.message);
      }
      return TPosApiResult(
          result: false,
          error: true,
          message: "${response.statusCode}: ${response.reasonPhrase}");
    }
  }

  @override
  Future<List<MailTemplateType>> getMailTemplateType() async {
    final response = await _tposClient.httpGet(
      path: "/api/common/getmailtemplatetypes",
    );

    if (response.statusCode == 200) {
      final mailTemplateMap = jsonDecode(response.body) as List;

      return mailTemplateMap.map((f) {
        return MailTemplateType.fromJson(f);
      }).toList();
    } else {
      throw Exception("${response.statusCode}, ${response.reasonPhrase}");
    }
  }

  @override
  Future<bool> updateMailTemplate(MailTemplate template) async {
    final Map jsonMap = template.toJson(true);
    jsonMap.removeWhere((key, value) {
      return value == null;
    });

    String body = jsonEncode(jsonMap);
    final response = await _tposClient.httpPut(
      path: "/odata/MailTemplate(${template.id})",
      body: body,
    );

    if (response.statusCode == 204) {
      return true;
    } else {
      throwHttpException(response);
      return null;
    }
  }

  @override
  Future<List<StatusExtra>> getStatusExtra() async {
    final repsonse = await _tposClient.httpGet(
      path: "/odata/StatusExtra",
    );

    if (repsonse.statusCode == 200)
      return (jsonDecode(repsonse.body)["value"] as List)
          .map((f) => StatusExtra.fromJson(f))
          .toList();

    throwTposApiException(repsonse);
    return null;
  }

  @override
  Future<bool> saveChangeStatus(List<String> ids, String status) async {
    final response = await _tposClient.httpPost(
      path: "/SaleOnline_Order/UpdateStatus",
      body: jsonEncode({"ids": ids, "status": status}),
    );
    if (response.statusCode == 200) return jsonDecode(response.body)["success"];
    throwTposApiException(response);
    return null;
  }

  @override
  Future<BusinessResult> getBusinessResult(
      DateTime dateFrom, DateTime dateTo, String companyId) async {
    final response = await _tposClient.httpGet(
      path: "/odata/Report/ODataService.GetBussinessResults",
      param: {
        "DateFrom": dateFrom,
        "DateTo": dateTo,
        "TypeReportTime": 2,
        "CompanyId": companyId ?? "",
      },
    );

    if (response.statusCode == 200) {
      var map = jsonDecode(response.body);
      return BusinessResult.fromJson(map);
    } else {
      throw Exception("${response.statusCode}, ${response.reasonPhrase}");
    }
  }

  @override
  Future<PrinterConfig> getPrintShipConfig() async {
    final shipConfig = await getPrinterConfigs();
    return shipConfig.firstWhere((f) => f.code == "08", orElse: () => null);
  }

  @override
  Future<PrinterConfig> getPrintInvoiceConfig() async {
    final shipConfig = await this.getPrinterConfigs();
    return shipConfig.firstWhere((f) => f.code == "01", orElse: () => null);
  }

  @override
  Future<List<PartnerReport>> getPartnerReports(
      {String display,
      String dataFrom,
      String dateTo,
      int take,
      int skip,
      int page,
      int pageSize,
      String resultSelection,
      String companyId,
      String partnerId,
      String userId,
      String categid,
      String typeReport}) async {
    List<PartnerReport> _partnerReports = [];

    String body = json.encode({
      "Display": display,
      "DateFrom": dataFrom,
      "DateTo": dateTo,
      "ResultSelection": resultSelection,
      "take": take,
      "skip": skip,
      "page": page,
      "pageSize": pageSize,
      "CategId": categid,
      "CompanyId": companyId,
      "PartnerId": partnerId,
      "UserId": userId
    });

    final response = await _tposClient.httpPost(
        path: typeReport == "1"
            ? "/AccountCommonPartnerReport/ReportSummary"
            : "/AccountCommonPartnerReport/ReportStaffSummary",
        body: body);

    if (response.statusCode == 200) {
      var map = json.decode(response.body);

      _partnerReports = (map["Data"] as List)
          .map((val) => PartnerReport.fromJson(val))
          .toList();

      for (final partnerReport in _partnerReports) {
        partnerReport.totalItem = map["Total"];
      }

      return _partnerReports;
    }
    throwHttpException(response);
    return null;
  }

  @override
  Future<List<PartnerFPO>> getPartnerSearchReport() async {
    final response = await _tposClient.httpGet(
        path:
            "/odata/Partner?%24format=json&%24top=10&%24orderby=Name&%24filter=Customer+eq+true&%24count=true");
    if (response.statusCode == 200) {
      return (jsonDecode(response.body)["value"] as List)
          .map((f) => PartnerFPO.fromJson(f))
          .toList();
    } else {
      throw Exception((jsonDecode(response.body)["message"]) ??
          "${response.statusCode}, ${response.reasonPhrase}");
    }
  }

  @override
  Future<List<ApplicationUserFPO>> getApplicationUserSearchReport() async {
    final response = await _tposClient.httpGet(
        path: "/odata/ApplicationUser?%24format=json&%24count=true");
    if (response.statusCode == 200) {
      return (jsonDecode(response.body)["value"] as List)
          .map((f) => ApplicationUserFPO.fromJson(f))
          .toList();
    } else {
      throw new Exception((jsonDecode(response.body)["message"]) ??
          "${response.statusCode}, ${response.reasonPhrase}");
    }
  }

  @override
  Future<List<CompanyOfUser>> getCompanies() async {
    final response = await _tposClient.httpGet(
        path: "/odata/ApplicationUser/ODataService.ChangeCurrentCompanyGet");
    if (response.statusCode == 200) {
      return (jsonDecode(response.body)["Companies"] as List)
          .map((val) => CompanyOfUser.fromJson(val))
          .toList();
    } else {
      throw Exception((jsonDecode(response.body)["message"]) ??
          "${response.statusCode}, ${response.reasonPhrase}");
    }
  }

  @override
  Future<List<PartnerDetailReport>> getPartnerDetailReports({
    String dataFrom,
    String dateTo,
    int take,
    int skip,
    int page,
    int pageSize,
    String resultSelection,
    String companyId,
    String partnerId,
  }) async {
    List<PartnerDetailReport> _partnerDetailReports = [];

    final String body = json.encode({
      "DateFrom": dataFrom,
      "DateTo": dateTo,
      "ResultSelection": resultSelection,
      "take": take,
      "skip": skip,
      "page": page,
      "pageSize": pageSize,
      "CompanyId": companyId,
      "PartnerId": partnerId
    });

    final response = await _tposClient.httpPost(
        path: "/AccountCommonPartnerReport/ReportDetail", body: body);

    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      _partnerDetailReports = (map["Data"] as List)
          .map((val) => PartnerDetailReport.fromJson(val))
          .toList();

      for (var partnerDetailReport in _partnerDetailReports) {
        partnerDetailReport.totalItem = map["Total"];
      }

      return _partnerDetailReports;
    } else {
      throw Exception((jsonDecode(response.body)["message"]) ??
          "${response.statusCode}, ${response.reasonPhrase}");
    }
  }

  @override
  Future<List<PartnerStaffDetailReport>> getPartnerStaffDetailReports(
      {String dataFrom,
      String dateTo,
      int take,
      int skip,
      int page,
      int pageSize,
      String resultSelection,
      String partnerId}) async {
    List<PartnerStaffDetailReport> _partnerStaffDetailReports = [];

    String body = json.encode({
      "DateFrom": dataFrom,
      "DateTo": dateTo,
      "ResultSelection": resultSelection,
      "take": take,
      "skip": skip,
      "page": page,
      "pageSize": pageSize,
      "PartnerId": partnerId
    });

    final response = await _tposClient.httpPost(
        path: "/AccountCommonPartnerReport/ReportStaffDetail", body: body);

    if (response.statusCode == 200) {
      var map = json.decode(response.body);
      _partnerStaffDetailReports = (map["Data"] as List)
          .map((val) => PartnerStaffDetailReport.fromJson(val))
          .toList();

      for (var partnerDetailReport in _partnerStaffDetailReports) {
        partnerDetailReport.totalItem = map["Total"];
      }

      return _partnerStaffDetailReports;
    } else {
      throw Exception((jsonDecode(response.body)["message"]) ??
          "${response.statusCode}, ${response.reasonPhrase}");
    }
  }

  @override
  Future<List<SupplierReport>> getSupplierReports(
      {String display,
      String dateFrom,
      String dateTo,
      int take,
      int skip,
      int page,
      int pageSize,
      String resultSelection,
      String companyId,
      String partnerId,
      String userId,
      String categId,
      String typeReport}) async {
    List<SupplierReport> _supplierReports = [];

    String body = json.encode({
      "Display": display,
      "DateFrom": dateFrom,
      "DateTo": dateTo,
      "ResultSelection": resultSelection,
      "take": take,
      "skip": skip,
      "page": page,
      "pageSize": pageSize,
      "CompanyId": companyId,
      "PartnerId": partnerId
    });

    final response = await _tposClient.httpPost(
        path: "/AccountCommonPartnerReport/ReportSummary", body: body);

    if (response.statusCode == 200) {
      final map = json.decode(response.body);

      _supplierReports = (map["Data"] as List)
          .map((val) => SupplierReport.fromJson(val))
          .toList();

      for (var supplierReport in _supplierReports) {
        supplierReport.totalItem = map["Total"];
      }

      return _supplierReports;
    }
    throwHttpException(response);
    return null;
  }

  @override
  Future<List<PartnerFPO>> getSupplierSearchs() async {
    List<PartnerFPO> _suppliers = [];

    final response = await _tposClient.httpGet(
        path:
            "/odata/Partner?%24format=json&%24top=10&%24orderby=Name&%24filter=Supplier+eq+true&%24count=true");

    if (response.statusCode == 200) {
      final map = json.decode(response.body);

      _suppliers = (map["value"] as List)
          .map((val) => PartnerFPO.fromJson(val))
          .toList();
      return _suppliers;
    }

    throwHttpException(response);
    return null;
  }

  @override
  Future<List<PartnerDetailReport>> getSupplierDetailReports(
      {String dataFrom,
      String dateTo,
      int take,
      int skip,
      int page,
      int pageSize,
      String resultSelection,
      String companyId,
      String partnerId}) async {
    List<PartnerDetailReport> _supplierDetailReports = [];

    String body = json.encode({
      "DateFrom": dataFrom,
      "DateTo": dateTo,
      "ResultSelection": resultSelection,
      "take": take,
      "skip": skip,
      "page": page,
      "pageSize": pageSize,
      "CompanyId": companyId,
      "PartnerId": partnerId
    });

    final response = await _tposClient.httpPost(
        path: "/AccountCommonPartnerReport/ReportDetail", body: body);

    if (response.statusCode == 200) {
      var map = json.decode(response.body);
      _supplierDetailReports = (map["Data"] as List)
          .map((val) => PartnerDetailReport.fromJson(val))
          .toList();

      for (var partnerDetailReport in _supplierDetailReports) {
        partnerDetailReport.totalItem = map["Total"];
      }

      return _supplierDetailReports;
    } else {
      throw Exception((jsonDecode(response.body)["message"]) ??
          "${response.statusCode}, ${response.reasonPhrase}");
    }
  }

  @override
  Future<List<ProductAttribute>> getProductAttributeSearch() async {
    List<ProductAttribute> _productAttributes = [];

    final response = await _tposClient.httpGet(
        path:
            "/odata/ProductAttribute?\$orderby=Sequence&%24format=json&%24filter=contains(tolower(Name)%2C%27%27)&%24count=true");

    if (response.statusCode == 200) {
      var map = json.decode(response.body);
      _productAttributes = (map["value"] as List)
          .map((val) => ProductAttribute.fromJson(val))
          .toList();
      return _productAttributes;
    }

    throwHttpException(response);
    return null;
  }

  @override
  Future<List<ProductAttribute>> getProductAttributeValueSearch() async {
    List<ProductAttribute> _productAttributes = [];

    var response = await _tposClient.httpGet(
        path:
            "/odata/ProductAttributeValue?\$orderby=Sequence&%24format=json&%24count=true");

    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      _productAttributes = (map["value"] as List)
          .map((val) => ProductAttribute.fromJson(val))
          .toList();
      return _productAttributes;
    }

    throwHttpException(response);
    return null;
  }

  @override
  Future<List<FaceBookAccount>> getUserFacebooks(String postId) async {
    List<FaceBookAccount> _userFacebooks = [];
    final response = await _tposClient.httpGet(
        path:
            "/odata/SaleOnline_Facebook_Comment/ODataService.GetByGroupUserByPost?\$expand=from,items&PostId=$postId");

    if (response.statusCode == 200) {
      var mapData = json.decode(response.body);
      _userFacebooks = (mapData["value"] as List)
          .map((value) => FaceBookAccount.fromMap(value))
          .toList();
      return _userFacebooks;
    }
    throwHttpException(response);
    return null;
  }

  @override
  Future<Partner> getDetailUserFacebook(String id, int teamId) async {
    List<Partner> _partners = [];
    final response = await _tposClient.httpGet(
        path:
            "/odata/SaleOnline_Order/ODataService.CheckPartner?ASUId=$id&TeamId=$teamId");

    if (response.statusCode == 200) {
      var mapData = json.decode(response.body);
      _partners = (mapData["value"] as List)
          .map((value) => Partner.fromJson(value))
          .toList();
      if (_partners.isEmpty) {
        return null;
      }
      return _partners[0];
    }
    throwHttpException(response);
    return null;
  }

  @override
  Future<List<UserFacebookComment>> getCommentUserFacebook(
      {String userId, String postId}) async {
    List<UserFacebookComment> comments = [];
    final response = await _tposClient.httpGet(
        path:
            "/odata/SaleOnline_Facebook_Comment/ODataService.GetCommentsByUserAndPost?userId=$userId&postId=$postId");

    if (response.statusCode == 200) {
      var mapData = json.decode(response.body);
      comments = (mapData["value"] as List)
          .map((value) => UserFacebookComment.fromJson(value))
          .toList();
      return comments;
    }
    throwHttpException(response);
    return null;
  }

  @override
  Future<List<SaleOnlineOrder>> getOrderSaleOnline(
      {String userId, String postId}) async {
    List<SaleOnlineOrder> saleOrders = [];
    final response = await _tposClient.httpGet(
        path:
            "/odata/SaleOnline_Order/ODataService.GetOrdersByUserId?userId=$userId&postId=$postId&asuid=$userId");

    if (response.statusCode == 200) {
      var mapData = json.decode(response.body);
      saleOrders = (mapData["value"] as List)
          .map((value) => SaleOnlineOrder.fromJson(value))
          .toList();
      return saleOrders;
    }
    throwHttpException(response);
    return null;
  }

  @override
  Future<String> exportExcel(String postId) async {
    final Permission _permissionHandler = Permission.storage;
    var status = await _permissionHandler.status;
    print(status);
    if (status == PermissionStatus.undetermined) {
      await Permission.storage.request();
      status = await _permissionHandler.status;
    }
    if (status == PermissionStatus.denied) {
      await Permission.storage.request();
      status = await _permissionHandler.status;
    }
    if (status == PermissionStatus.granted) {
      ISettingService _setting = locator<ISettingService>();

      BaseOptions options = BaseOptions(
          connectTimeout: 60000,
          receiveTimeout: 60000,
          headers: {
            "Authorization": 'Bearer ${_setting.shopAccessToken}',
          },
          contentType: "application/json");

      Dio dio = Dio(options);
      String dirloc = "";
      if (Platform.isAndroid) {
        dirloc = "/sdcard/download/comments-";
      } else {
        dirloc = (await getApplicationDocumentsDirectory()).path;
      }

      final String dateCreated =
          DateFormat("dd-MM-yyyy(hh-mm-ss)").format(DateTime.now());
      var response = await dio.download(
          "${_setting.shopUrl}/facebook/exportcommentstoexcel?postid=$postId",
          dirloc + postId + "-$dateCreated" + ".xlsx",
          onReceiveProgress: (receivedBytes, totalBytes) {},
          options: Options(method: "post"));
      if (response.statusCode == 200) {
        return dirloc + postId + "-$dateCreated" + ".xlsx";
      }
      throw Exception("${response.statusCode}, ${response.statusMessage}");
    }
    return null;
  }

  @override
  Future<String> exportExcelByPhone(String postId) async {
    Permission _permissionHandler = Permission.storage;
    var status = await _permissionHandler.status;
    print(status);
    if (status == PermissionStatus.undetermined) {
      await Permission.storage.request();
      status = await _permissionHandler.status;
    }
    if (status == PermissionStatus.denied) {
      await Permission.storage.request();
      status = await _permissionHandler.status;
    }
    if (status == PermissionStatus.granted) {
      ISettingService _setting = locator<ISettingService>();

      BaseOptions options = BaseOptions(
          connectTimeout: 60000,
          receiveTimeout: 60000,
          headers: {
            "Authorization": 'Bearer ${_setting.shopAccessToken}',
          },
          contentType: "application/json");

      Dio dio = Dio(options);
      String dirloc = "";

      if (Platform.isAndroid) {
        dirloc = "/sdcard/download/comments-";
      } else {
        dirloc = (await getApplicationDocumentsDirectory()).path;
      }

      Random random = Random();
      var randid = random.nextInt(10000);
      String dateCreated =
          DateFormat("dd-MM-yyyy(hh-mm-ss)").format(DateTime.now());
//      FileUtils.mkdir([dirloc]);
      var response = await dio.download(
          "${_setting.shopUrl}/facebook/exportcommentstoexcel?postid=$postId&isPhone=true",
          dirloc + postId + "-$dateCreated" + "-with-phone" + ".xlsx",
          onReceiveProgress: (receivedBytes, totalBytes) {},
          options: Options(method: "post"));
      if (response.statusCode == 200) {
        return dirloc + postId + "-$dateCreated" + "-with-phone" + ".xlsx";
      }
      throw new Exception("${response.statusCode}, ${response.statusMessage}");
    }
    return null;
  }

  @override
  Future<FetchComment> fetchCommentFacebookByBody(
      String videoId, String ASUid) async {
    ISettingService _setting = locator<ISettingService>();
    var response;

    String body =
        "{\"ASUId\":\"$ASUid\",\"VideoId\":\"$videoId\",\"Offset\":0,\"Length\":46}";
    _log.info(
        "TPOS API POST: http://${_setting.computerIp}:${_setting.computerPort}/api/facebook/fetchcomments");
    response = await http.post(
      "http://${_setting.computerIp}:${_setting.computerPort}/api/facebook/fetchcomments",
      body: body,
      headers: {
        "Content-Type": 'application/json',
      },
    );
    _log.info(
        "RESPONSE FROM TPOS API POST: http://${_setting.computerIp}:${_setting.computerPort}/api/facebook/fetchcomments:");
    _log.info(response.statusCode);
    _log.info(response.body);
    var mapResponse = json.decode(response.body);

    if (mapResponse["Success"] == null) {
      var result = await _tposClient.httpPost(
          path: "/api/facebook/fetchcommentscallbacknew", body: response.body);
      if (result.statusCode == 200) {
        var mapData = json.decode(result.body);
        if (mapData["success"]) {
          return FetchComment.fromJson(mapData["data"]);
        }
      }

      throwHttpException(result);
    }
    List<int> bytes = response.body.toString().codeUnits;
    jsonDecode(utf8.decode(bytes));
    throw new Exception(jsonDecode(utf8.decode(bytes))["Message"]);
    return null;
  }

  @override
  Future<String> exportExcelLiveCampaign(
      String campaignId, String campaignName) async {
    Permission _permissionHandler = Permission.storage;
    var status = await _permissionHandler.status;
    if (status == PermissionStatus.undetermined) {
      await Permission.storage.request();
      status = await _permissionHandler.status;
    }
    if (status == PermissionStatus.denied) {
      await Permission.storage.request();
      status = await _permissionHandler.status;
    }
    if (status == PermissionStatus.granted) {
      ISettingService _setting = locator<ISettingService>();

      BaseOptions options = BaseOptions(
          connectTimeout: 50000,
          receiveTimeout: 3000,
          headers: {
            "Authorization": 'Bearer ${_setting.shopAccessToken}',
          },
          contentType: "application/json");

      Dio dio = Dio(options);
      String dirloc = "";

      if (Platform.isAndroid) {
        dirloc = "/sdcard/download/comments-";
      } else {
        dirloc = (await getApplicationDocumentsDirectory()).path;
      }

      String dateCreated =
          DateFormat("dd-MM-yyyy(hh-mm-ss)").format(DateTime.now());
//      FileUtils.mkdir([dirloc]);
      campaignName = campaignName.replaceAll("\\", "-");
      campaignName = campaignName.replaceAll("\/", "-");
      campaignName = campaignName.replaceAll("\:", "-");
      campaignName = campaignName.replaceAll("\*", "-");
      campaignName = campaignName.replaceAll("\?", "-");
      campaignName = campaignName.replaceAll("\<", "-");
      campaignName = campaignName.replaceAll("\>", "-");
      campaignName = campaignName.replaceAll("\|", "-");
      var response = await dio.download(
          "${_setting.shopUrl}/SaleOnline_Order/ExportFile?campaignId=$campaignId&sort=date",
          dirloc + campaignName + "-$dateCreated" + ".xlsx",
          onReceiveProgress: (receivedBytes, totalBytes) {},
          options: Options(method: "post"),
          data: "{\"data\":\"{}\"}");
      if (response.statusCode == 200) {
        return dirloc + campaignName + "-$dateCreated" + ".xlsx";
      }
      throw new Exception("${response.statusCode}, ${response.statusMessage}");
    }
    return null;
  }

  @override
  Future<BaseModelSaleQuotation> getSaleQuotations(
      {String keySearch,
      String fromDate,
      String toDate,
      int accountId,
      int take,
      int skip,
      int page,
      int pageSize,
      List<String> states}) async {
    List<SaleQuotation> saleQuotations = [];
    String path = "/SaleQuotation/List";
    Map<String, dynamic> body = {
      "take": take,
      "skip": skip,
      "page": page,
      "pageSize": pageSize,
      "sort": [
        {"field": "Id", "dir": "desc"}
      ],
      "filter": {
        "logic": "or",
        "filters": [
          {"field": "State", "operator": "eq", "value": "draft"},
          {"field": "State", "operator": "eq", "value": "sent"},
          {"field": "State", "operator": "eq", "value": "cancel"}
        ]
      }
    };
    print(states.length);
    if (states.length == 1) {
      body["filter"] = {
        "logic": "and",
        "filters": [
          {"field": "State", "operator": "eq", "value": "${states[0]}"}
        ]
      };
      if (keySearch != null && keySearch != "") {
        body["filter"] = {
          "logic": "and",
          "filters": [
            {
              "logic": "or",
              "filters": [
                {
                  "field": "Partner",
                  "operator": "contains",
                  "value": "$keySearch"
                },
                {
                  "field": "PartnerNameNoSign",
                  "operator": "contains",
                  "value": "$keySearch"
                },
                {
                  "field": "User",
                  "operator": "contains",
                  "value": "$keySearch"
                },
                {
                  "field": "Name",
                  "operator": "contains",
                  "value": "$keySearch"
                },
              ]
            },
            {"field": "State", "operator": "eq", "value": "${states[0]}"}
          ]
        };
        if (fromDate != null && toDate != null) {
          body["filter"]["filters"] = [
            {
              "logic": "or",
              "filters": [
                {
                  "field": "Partner",
                  "operator": "contains",
                  "value": "$keySearch"
                },
                {
                  "field": "PartnerNameNoSign",
                  "operator": "contains",
                  "value": "$keySearch"
                },
                {
                  "field": "User",
                  "operator": "contains",
                  "value": "$keySearch"
                },
                {"field": "Name", "operator": "contains", "value": "$keySearch"}
              ]
            },
            {"field": "DateQuotation", "operator": "gte", "value": "$fromDate"},
            {"field": "DateQuotation", "operator": "lte", "value": "$toDate"},
            {"field": "State", "operator": "eq", "value": "${states[0]}"},
          ];
        }
      } else if (fromDate != null && toDate != null) {
        body["filter"] = {
          "logic": "and",
          "filters": [
            {"field": "DateQuotation", "operator": "gte", "value": "$fromDate"},
            {"field": "DateQuotation", "operator": "lte", "value": "$toDate"},
            {"field": "State", "operator": "eq", "value": "${states[0]}"},
          ]
        };
        if (keySearch != null && keySearch != "") {
          body["filter"]["filters"] = [
            {
              "logic": "or",
              "filters": [
                {
                  "field": "Partner",
                  "operator": "contains",
                  "value": "$keySearch"
                },
                {
                  "field": "PartnerNameNoSign",
                  "operator": "contains",
                  "value": "$keySearch"
                },
                {
                  "field": "User",
                  "operator": "contains",
                  "value": "$keySearch"
                },
                {"field": "Name", "operator": "contains", "value": "$keySearch"}
              ]
            },
            {"field": "DateQuotation", "operator": "gte", "value": "$fromDate"},
            {"field": "DateQuotation", "operator": "lte", "value": "$toDate"},
            {"field": "State", "operator": "eq", "value": "${states[0]}"},
          ];
        }
      }
    } else if (states.length == 2) {
      body["filter"] = {
        "logic": "or",
        "filters": [
          {"field": "State", "operator": "eq", "value": "${states[0]}"},
          {"field": "State", "operator": "eq", "value": "${states[1]}"},
        ]
      };

      if (keySearch != null && keySearch != "") {
        body["filter"] = {
          "logic": "and",
          "filters": [
            {
              "logic": "or",
              "filters": [
                {
                  "field": "Partner",
                  "operator": "contains",
                  "value": "$keySearch"
                },
                {
                  "field": "PartnerNameNoSign",
                  "operator": "contains",
                  "value": "$keySearch"
                },
                {
                  "field": "User",
                  "operator": "contains",
                  "value": "$keySearch"
                },
                {"field": "Name", "operator": "contains", "value": "$keySearch"}
              ]
            },
            {
              "logic": "or",
              "filters": [
                {"field": "State", "operator": "eq", "value": "${states[0]}"},
                {"field": "State", "operator": "eq", "value": "${states[1]}"}
              ]
            },
          ]
        };
        if (fromDate != null && toDate != null) {
          body["filter"]["filters"] = [
            {
              "logic": "or",
              "filters": [
                {
                  "field": "Partner",
                  "operator": "contains",
                  "value": "$keySearch"
                },
                {
                  "field": "PartnerNameNoSign",
                  "operator": "contains",
                  "value": "$keySearch"
                },
                {
                  "field": "User",
                  "operator": "contains",
                  "value": "$keySearch"
                },
                {"field": "Name", "operator": "contains", "value": "$keySearch"}
              ]
            },
            {"field": "DateQuotation", "operator": "gte", "value": "$fromDate"},
            {"field": "DateQuotation", "operator": "lte", "value": "$toDate"},
            {
              "logic": "or",
              "filters": [
                {"field": "State", "operator": "eq", "value": "${states[0]}"},
                {"field": "State", "operator": "eq", "value": "${states[1]}"}
              ]
            },
          ];
        }
      } else if (fromDate != null && toDate != null) {
        body["filter"] = {
          "logic": "and",
          "filters": [
            {"field": "DateQuotation", "operator": "gte", "value": "$fromDate"},
            {"field": "DateQuotation", "operator": "lte", "value": "$toDate"},
            {
              "logic": "or",
              "filters": [
                {"field": "State", "operator": "eq", "value": "${states[0]}"},
                {"field": "State", "operator": "eq", "value": "${states[1]}"}
              ]
            }
          ]
        };
        if (keySearch != null && keySearch != "") {
          body["filter"]["filters"] = [
            {
              "logic": "or",
              "filters": [
                {
                  "field": "Partner",
                  "operator": "contains",
                  "value": "$keySearch"
                },
                {
                  "field": "PartnerNameNoSign",
                  "operator": "contains",
                  "value": "$keySearch"
                },
                {
                  "field": "User",
                  "operator": "contains",
                  "value": "$keySearch"
                },
                {"field": "Name", "operator": "contains", "value": "$keySearch"}
              ]
            },
            {"field": "DateQuotation", "operator": "gte", "value": "$fromDate"},
            {"field": "DateQuotation", "operator": "lte", "value": "$toDate"},
            {
              "logic": "or",
              "filters": [
                {"field": "State", "operator": "eq", "value": "${states[0]}"},
                {"field": "State", "operator": "eq", "value": "${states[1]}"}
              ]
            },
          ];
        }
      }
    } else {
      if (keySearch != null && keySearch != "") {
        body["filter"] = {
          "logic": "and",
          "filters": [
            {
              "logic": "or",
              "filters": [
                {
                  "field": "Partner",
                  "operator": "contains",
                  "value": "$keySearch"
                },
                {
                  "field": "PartnerNameNoSign",
                  "operator": "contains",
                  "value": "$keySearch"
                },
                {
                  "field": "User",
                  "operator": "contains",
                  "value": "$keySearch"
                },
                {"field": "Name", "operator": "contains", "value": "$keySearch"}
              ]
            },
          ]
        };
        if (fromDate != null && toDate != null) {
          body["filter"]["filters"] = [
            {
              "logic": "or",
              "filters": [
                {
                  "field": "Partner",
                  "operator": "contains",
                  "value": "$keySearch"
                },
                {
                  "field": "PartnerNameNoSign",
                  "operator": "contains",
                  "value": "$keySearch"
                },
                {
                  "field": "User",
                  "operator": "contains",
                  "value": "$keySearch"
                },
                {"field": "Name", "operator": "contains", "value": "$keySearch"}
              ]
            },
            {"field": "DateQuotation", "operator": "gte", "value": "$fromDate"},
            {"field": "DateQuotation", "operator": "lte", "value": "$toDate"}
          ];
        }
      } else if (fromDate != null && toDate != null) {
        body["filter"] = {
          "logic": "and",
          "filters": [
            {"field": "DateQuotation", "operator": "gte", "value": "$fromDate"},
            {"field": "DateQuotation", "operator": "lte", "value": "$toDate"}
          ]
        };
        if (keySearch != null && keySearch != "") {
          body["filter"]["filters"] = [
            {
              "logic": "or",
              "filters": [
                {
                  "field": "Partner",
                  "operator": "contains",
                  "value": "$keySearch"
                },
                {
                  "field": "PartnerNameNoSign",
                  "operator": "contains",
                  "value": "$keySearch"
                },
                {
                  "field": "User",
                  "operator": "contains",
                  "value": "$keySearch"
                },
                {"field": "Name", "operator": "contains", "value": "$keySearch"}
              ]
            },
            {"field": "DateQuotation", "operator": "gte", "value": "$fromDate"},
            {"field": "DateQuotation", "operator": "lte", "value": "$toDate"}
          ];
        }
      }
    }

    var response =
        await _tposClient.httpPost(path: path, body: json.encode(body));

    if (response.statusCode == 200) {
      var map = json.decode(response.body);
      if (response.body != "") {
        saleQuotations = (map["Data"] as List)
            .map((value) => SaleQuotation.fromJson(value))
            .toList();
      }
      BaseModelSaleQuotation baseModelSaleQuotation = BaseModelSaleQuotation(
          result: saleQuotations, totalItems: map["Total"]);
      return baseModelSaleQuotation;
    }
    throwHttpException(response);
    return null;
  }

  @override
  Future<SaleQuotationDetail> getInfoSaleQuotation(String id) async {
    var response = await _tposClient.httpGet(
        path:
            "/odata/SaleQuotation($id)?\$expand=Partner,User,Currency,Company,PriceList,PaymentTerm,Tax");
    if (response.statusCode == 200) {
      var mapData = json.decode(response.body);
      return SaleQuotationDetail.fromJson(mapData);
    }
    throwHttpException(response);
    return null;
  }

  @override
  Future<List<OrderLines>> getOrderLineForSaleQuotation(String id) async {
    List<OrderLines> orderLines = [];

    var response = await _tposClient.httpGet(
        path:
            "/odata/SaleQuotation($id)/OrderLines?\$expand=Product,ProductUOM,LayoutCategory");
    if (response.statusCode == 200) {
      var mapData = json.decode(response.body);
      orderLines = (mapData["value"] as List)
          .map((item) => OrderLines.fromJson(item))
          .toList();
      return orderLines;
    }
    throwHttpException(response);
    return null;
  }

  @override
  Future<void> deleteSaleQuotation(int id) async {
    var result =
        await _tposClient.httpDelete(path: "/odata/SaleQuotation($id)");
    if (result.statusCode == 204) {
      return;
    }
    var mapResult = json.decode(result.body);
    throw new Exception(
        "${result.statusCode}, ${"${mapResult["error"]["message"]}"}");

    return false;
  }

  @override
  Future<List<AccountPaymentTerm>> getAccountPaymentTerms() async {
    List<AccountPaymentTerm> accountPaymentTerms = [];
    var response = await _tposClient.httpGet(
        path: "/odata/AccountPaymentTerm?%24format=json&%24count=true");
    if (response.statusCode == 200) {
      var mapData = json.decode(response.body);
      accountPaymentTerms = (mapData["value"] as List)
          .map((value) => AccountPaymentTerm.fromJson(value))
          .toList();
      return accountPaymentTerms;
    }
    throwHttpException(response);
    return null;
  }

  @override
  Future<void> updateSaleQuotation(
      SaleQuotationDetail saleQuotationDetail) async {
    String body = json.encode(saleQuotationDetail.toJson());

    var response = await _tposClient.httpPut(
        path: "/odata/SaleQuotation(${saleQuotationDetail.id})", body: body);
    if (response.statusCode == 204) {
      return;
    }
    throwHttpException(response);
  }

  @override
  Future<SaleQuotationDetail> getDefaultSaleQuotation() async {
    var response = await _tposClient.httpGet(
        path:
            "/odata/SaleQuotation/ODataService.DefaultGet?\$expand=Currency,Company,User");
    if (response.statusCode == 200) {
      var mapData = json.decode(response.body);
      return SaleQuotationDetail.fromJson(mapData);
    }
    throwHttpException(response);
    return null;
  }

  @override
  Future<SaleQuotationDetail> addInfoSaleQuotation(
      SaleQuotationDetail saleQuotationDetail) async {
    String body = json.encode(saleQuotationDetail.toJson());
    var response =
        await _tposClient.httpPost(path: "/odata/SaleQuotation", body: body);
    if (response.statusCode == 201) {
      var mapData = json.decode(response.body);
      return SaleQuotationDetail.fromJson(mapData);
    }
    throwHttpException(response);
    return null;
  }

  @override
  Future<void> markSaleQuotation(int id) async {
    String body = "{\"id\":$id}";
    var response = await _tposClient.httpPost(
        path: "/odata/SaleQuotation/ODataService.MarkQuotationSent",
        body: body);
    if (response.statusCode == 204) {
      return;
    }
    throwHttpException(response);
  }

  @override
  Future<String> exportExcelSaleQuotation(String id) async {
    String nameFile = await downloadExcel(
        path: "/salequotation/ExportToExcel?id=$id",
        nameFile: "Báo giá",
        method: "get");
    return nameFile;
  }

  @override
  Future<String> exportPDFSaleQuotation(String id) async {
    Permission _permissionHandler = Permission.storage;
    var status = await _permissionHandler.status;
    print(status);
    if (status == PermissionStatus.undetermined) {
      await Permission.storage.request();
      status = await _permissionHandler.status;
    }
    if (status == PermissionStatus.denied) {
      await Permission.storage.request();
      status = await _permissionHandler.status;
    }
    if (status == PermissionStatus.granted) {
      ISettingService _setting = locator<ISettingService>();

      BaseOptions options = BaseOptions(
        baseUrl: "${_setting.shopUrl}",
        headers: {
          "Cookie":
              'ASP.NET_SessionId=li5wdbtcsipqv4iupmid2g1a; .AspNet.ApplicationCookie=eHxQKtSuK2GE02r2fxUlupo_nDQInag7hA3kElJcJmQt6UkSHTieaS73s-CZN5x8jhWUZVf_VBWQslhTFcwCgYVAW76lt2WUuJ0xsCJ0nRxIL8SCoH83uCKOcBedWb1bCsAGj7KrWQ8Z4WrCPfBm2cWnGen31BGS1PbomshieoaSf8btfcsIVhAuO5FgohBXMJzz09HR9zLpAD_lCn3yHhQJETX21oOaXFW4I5C9iepYne_2jC30me99UPB1yCBt10S4gzmZfAKqaxJUiyjXvXxHIpd_6RgVZE41jiyJzcHns2EpPdpXQ40dkvp7t2DX-SzWaANDkLJv0Jmtoy3YaIPPmiKi3ZClH6SslfBr_B_Tt2dgXC4tzvuRtPbB48Xn4E8bS-awzdXmPGZC191WZ4N3bAlOJezKXRBDL0Gl8hqackyeEVTa9fzXiToGCeLQi_3v9LYBVN-kNOuNZ8C9GBzGgTcPu8NOweNdarQN5M3vDZ3-WQQHBIyraTXjzF4N56SjSuQ1m6EUSPkq6PRlLeWeKE9rTyNbFo9jS9UXVAVfXOocDva9Z72Zp-Z-4fMf4-NUbXBmgH9w7ywAbDrgCoJ-UKL7nlCDC-CuKUV1T3WcdpoT6MqwiY04U5S-KZzGIe1YfkjaUCZYZ8xIofWAbHgUDPNqRjq49Gw1xS_K9yygRuXAKtzkrVRPUzZfm5FC-b-2iw; __RequestVerificationToken=syGFs8k6mvRfa1ZcRq9O-R9wWyLLIoOycBj4f-krfJMprQBallA5MwoSRTKI3cD2SU7P4o5w9v3g-20lyFqZ8cqydGM1',
        },
      );

      Dio dio = Dio(options);
      String dirloc = "";

      if (Platform.isAndroid) {
        dirloc = "/sdcard/download/comments";
      } else {
        dirloc = (await getApplicationDocumentsDirectory()).path;
      }

      String dateCreated =
          DateFormat("dd-MM-yyyy(hh-mm-ss)").format(DateTime.now());

      var response = await dio.download(
        "https://tmt25.tpos.vn/SaleQuotation/PrintQuotation2?id=$id",
        dirloc + "Báo giá" + "$dateCreated" + ".pdf",
      );

      if (response.statusCode == 200) {
        return dirloc + "Báo giá" + "$dateCreated" + ".pdf";
      }
      throw new Exception("${response.statusCode}, ${response.statusMessage}");
    }
    return null;
  }

  @override
  Future<void> deleteMultiSaleQuotation(List<int> ids) async {
    var body = {"ids": ids};

    var response = await _tposClient.httpPost(
        path: "/odata/SaleQuotation/ODataService.Unlink",
        body: json.encode(body));
    if (response.statusCode == 204) {
      return;
    }

    throw new Exception(jsonDecode(response.body)["error"]["message"]);
  }

  @override
  Future<SaleQuotationDetail> getPriceListSaleQuotation(
      SaleQuotationDetail saleQuotationDetail) async {
    final String body =
        "{\"model\" : ${json.encode(saleQuotationDetail.toJson())}}";
    final response = await _tposClient.httpPost(
        path:
            "/odata/SaleQuotation/ODataService.OnChangePartner?\$expand=PriceList,PaymentTerm",
        body: body);

    if (response.statusCode == 200) {
      final mapData = json.decode(response.body);
      final SaleQuotationDetail _saleQuotationDetail =
          SaleQuotationDetail.fromJson(mapData);
      return _saleQuotationDetail;
    }

    throwHttpException(response);
    return null;
  }

  @override
  Future<String> exportInvoiceSaleOnline(
      {String campaignId,
      int crmTeamId,
      String keySearch,
      List<String> statusTexts,
      String fromDate,
      String toDate,
      List<String> ids}) async {
    Map<String, dynamic> mapData = {
      "data": "{}",
      "ids": ids,
      "campaignId": "($campaignId)"
    };
    String objectStatus = "";
    String status = "";

    if (statusTexts.isNotEmpty) {
      for (int i = 0; i < statusTexts.length; i++) {
        objectStatus +=
            "{\"field\":\"StatusText\",\"operator\":\"eq\",\"value\":\"${statusTexts[i]}\"},";
      }
    }
    status = "{\"logic\":\"or\",\"filters\":[$objectStatus]}";
    if ((keySearch != null && keySearch != "") ||
        crmTeamId != null ||
        statusTexts.isNotEmpty ||
        fromDate != null ||
        toDate != null) {
      mapData = {
        "data":
            "{\"Filter\":{\"logic\":\"and\",\"filters\":[${crmTeamId == null ? "" : "{\"logic\":\"or\",\"filters\":[{\"field\":\"CRMTeamId\",\"operator\":\"eq\",\"value\":$crmTeamId}]},"} ${keySearch != null && keySearch != "" ? "{\"logic\":\"or\",\"filters\": ${"[{\"field\":\"Name\",\"operator\":\"contains\",\"value\":\"$keySearch\"},{\"field\":\"PartnerNameNosign\",\"operator\":\"contains\",\"value\":\"$keySearch\"},{\"field\":\"Facebook_UserId\",\"operator\":\"contains\",\"value\":\"$keySearch\"},{\"field\":\"Telephone\",\"operator\":\"contains\",\"value\":\"$keySearch\"},{\"field\":\"Code\",\"operator\":\"contains\",\"value\":\"$keySearch\"}]"}}," : ""} ${fromDate != null ? "{\"field\":\"DateCreated\",\"operator\":\"gte\",\"value\":\"$fromDate\"}," : ""} ${toDate != null ? "{\"field\":\"DateCreated\",\"operator\":\"lte\",\"value\":\"$toDate\"}," : ""} ${statusTexts.length == 0 ? "" : "$status,"}]}}",
        "ids": ids,
        "campaignId": "${campaignId ?? "(null)"}"
      };
    }
    print(mapData);
    String nameFile = await downloadExcel(
        path: "/SaleOnline_Order/ExportFile",
        body: json.encode(mapData),
        nameFile: "Don-Hang-Online");
    return nameFile;
  }

  @override
  Future<String> exportExcelDeliveryInvoice(
      {String keySearch,
      String fromDate,
      String toDate,
      String statusTexts,
      List<int> ids,
      String deliveryType,
      bool isFilterStatus}) async {
    Map<String, dynamic> mapData = {
      "data":
          "{\"Filter\":{\"logic\":\"and\",\"filters\":[{\"field\":\"Type\",\"operator\":\"eq\",\"value\":\"invoice\"}]}}",
      "ids": ids
    };

    if ((keySearch != null && keySearch != "") ||
        fromDate != null ||
        toDate != null ||
        (statusTexts != null || isFilterStatus) ||
        deliveryType != null) {
      mapData["data"] =
          "{\"Filter\":{\"logic\":\"and\",\"filters\":[{\"field\":\"Type\",\"operator\":\"eq\",\"value\":\"invoice\"},${keySearch != null && keySearch != "" ? "{\"logic\":\"or\",\"filters\":[{\"field\":\"PartnerDisplayName\",\"operator\":\"contains\",\"value\":\"$keySearch\"},{\"field\":\"PartnerNameNoSign\",\"operator\":\"contains\",\"value\":\"$keySearch\"},{\"field\":\"TrackingRef\",\"operator\":\"contains\",\"value\":\"$keySearch\"},{\"field\":\"Number\",\"operator\":\"contains\",\"value\":\"$keySearch\"}]}," : ""} ${fromDate != null ? "{\"field\":\"DateInvoice\",\"operator\":\"gte\",\"value\":\"$fromDate\"}," : ""} ${toDate != null ? "{\"field\":\"DateInvoice\",\"operator\":\"lte\",\"value\":\"$toDate\"}," : ""} ${deliveryType != null ? "{\"field\":\"CarrierDeliveryType\",\"operator\":\"eq\",\"value\":\"$deliveryType\"}," : ""} ${statusTexts != null ? "{\"field\":\"ShipPaymentStatus\",\"operator\":\"eq\",\"value\":\"$statusTexts\"}" : isFilterStatus ? "{\"field\":\"ShipPaymentStatus\",\"operator\":\"eq\",\"value\":null}" : ""}]}}";
    }

    String nameFile = await downloadExcel(
        path: "/FastSaleOrder/ExportFileDelivery",
        body: json.encode(mapData),
        nameFile: "Hoa-Don-Giao-Hang");
    return nameFile;
  }

  @override
  Future<String> exportExcelDeliveryInvoiceDetail(
      {String keySearch,
      String fromDate,
      String toDate,
      String statusTexts,
      List<int> ids,
      String deliveryType,
      bool isFilterStatus}) async {
    Map<String, dynamic> mapData = {
      "data":
          "{\"Filter\":{\"logic\":\"and\",\"filters\":[{\"field\":\"Type\",\"operator\":\"eq\",\"value\":\"invoice\"}]}}",
      "ids": ids
    };

    if ((keySearch != null && keySearch != "") ||
        fromDate != null ||
        toDate != null ||
        (statusTexts != null || isFilterStatus) ||
        deliveryType != null) {
      mapData["data"] =
          "{\"Filter\":{\"logic\":\"and\",\"filters\":[{\"field\":\"Type\",\"operator\":\"eq\",\"value\":\"invoice\"},${keySearch != null && keySearch != "" ? "{\"logic\":\"or\",\"filters\":[{\"field\":\"PartnerDisplayName\",\"operator\":\"contains\",\"value\":\"$keySearch\"},{\"field\":\"PartnerNameNoSign\",\"operator\":\"contains\",\"value\":\"$keySearch\"},{\"field\":\"TrackingRef\",\"operator\":\"contains\",\"value\":\"$keySearch\"},{\"field\":\"Number\",\"operator\":\"contains\",\"value\":\"$keySearch\"}]}," : ""} ${fromDate != null ? "{\"field\":\"DateInvoice\",\"operator\":\"gte\",\"value\":\"$fromDate\"}," : ""} ${toDate != null ? "{\"field\":\"DateInvoice\",\"operator\":\"lte\",\"value\":\"$toDate\"}," : ""} ${deliveryType != null ? "{\"field\":\"CarrierDeliveryType\",\"operator\":\"eq\",\"value\":\"$deliveryType\"}," : ""} ${statusTexts != null ? "{\"field\":\"ShipPaymentStatus\",\"operator\":\"eq\",\"value\":\"$statusTexts\"}" : isFilterStatus ? "{\"field\":\"ShipPaymentStatus\",\"operator\":\"eq\",\"value\":null}" : ""}]}}";
    }

    String nameFile = await downloadExcel(
        path: "/FastSaleOrder/ExportFileDeliveryDetail",
        body: json.encode(mapData),
        nameFile: "Chi-Tiet-Hoa-Don-Giao-Hang");
    return nameFile;
  }

  @override
  Future<List<SaleOnlineStatusType>> getSaleOnlineStatus() async {
    final response = await _tposClient.httpGet(
      path: "/json/StatusTypeExt",
      param: {},
    );
    if (response.statusCode == 200) {
      var jsonMap = jsonDecode(response.body);
      return (jsonMap as List)
          .map((status) => SaleOnlineStatusType.fromJson(status))
          .toList();
    }

    throwTposApiException(response);
    return null;
  }
}
