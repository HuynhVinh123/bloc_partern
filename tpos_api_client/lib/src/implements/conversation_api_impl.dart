import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/src/abstractions/conversation_api.dart';
import 'package:tpos_api_client/src/models/entities/attachment.dart';
import 'package:tpos_api_client/src/models/entities/conversation_refetch.dart';
import 'package:tpos_api_client/src/models/entities/message_conversation.dart';
import 'package:tpos_api_client/src/models/entities/unread.dart';
import 'package:tpos_api_client/src/models/results/get_facebook_result.dart';
import 'package:tpos_api_client/src/models/results/get_list_conservation_result.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

class ConversationApiImpl implements ConversationApi {
  ConversationApiImpl({TPosApiClient apiClient}) {
    _apiClient = apiClient ?? GetIt.instance<TPosApi>();
  }
  TPosApiClient _apiClient;

  @override
  Future<GetListConversationResult> getListConversationResult({
    int page,
    int limit,
    String type,
    String pageId,
    String tagIds,
    String userIds,
    DateTime start,
    DateTime end,
    bool hasPhone,
    bool hasAddress,
    bool hasOrder,
    bool hasUnread,
  }) async {
    final response = await _apiClient.httpGet("/rest/v1.0/crmmatching",
        parameters: {
          "tag_ids": tagIds,
          "user_ids": userIds,
          "start": start?.toIso8601String(),
          "end": end?.toIso8601String(),
          "has_phone": hasPhone,
          "has_address": hasAddress,
          "has_order": hasOrder,
          "has_unread": hasUnread,
          "page": page,
          "limit": limit,
          "type": type,
          "pageId": pageId
        }..removeWhere((key, value) => value == null));
    return GetListConversationResult.fromJson(response);
  }

  @override
  Future<GetListFacebookResult> getAllFacebook() async {
    final response = await _apiClient.httpGet(
      "/rest/v1.0/crmteam/getallfacebooks",
    );
    return GetListFacebookResult.fromJson(response);
  }

  @override
  Future<Unread> getUnread({String id}) async {
    final response = await _apiClient.httpGet(
      "/rest/v1.0/crmteam/$id/unread",
    );
    return Unread.fromJson(response);
  }

  @override
  Future<GetListConversationResult> getListConversationResultBySearch({
    int page,
    int limit,
    String type,
    String pageId,
    String search,
    String nameStart,
  }) async {
    final response = await _apiClient.httpGet("/rest/v1.0/crmmatching",
        parameters: {
          "page": page,
          "limit": limit,
          "type": type,
          "pageId": pageId,
          "keyword": search,
          "nameStart": nameStart
        }..removeWhere((key, value) => value == null));
    return GetListConversationResult.fromJson(response);
  }

  @override
  Future<OdataListResult<ApplicationUser>> getApplicationUser() async {
    final response = await _apiClient.httpGet(
      "/odata/ApplicationUser",
    );
    return OdataListResult<ApplicationUser>.fromJson(response);
  }

  @override
  Future<OdataListResult<CRMTag>> getCRMTag({bool isDeleted}) async {
    final response = await _apiClient.httpGet("/odata/CRMTag",
        parameters: {"filter": 'IsDeleted eq $isDeleted'});
    return OdataListResult<CRMTag>.fromJson(response);
  }

  @override
  Future<GetMessageConversationResult> getConversationMessageList(
      {int page,
      int limit,
      String type,
      String pageId,
      String facebookId}) async {
    final response =
        await _apiClient.httpGet("/rest/v1.0/crmmatching/$facebookId/messages",
            parameters: {
              "page": page,
              "limit": limit,
              "type": type,
              "page_id": pageId,
            }..removeWhere((key, value) => value == null));
    return GetMessageConversationResult.fromJson(response);
  }

  @override
  Future<MessageConversation> addMessage(
      {String message,
      String toId,
      TPosFacebookUser from,
      String facebookId,
      Attachment attachment}) async {
    final Map<String, dynamic> mapBody = {
      "message": message,
      "to_id": toId,
      "from": from?.toJson(),
      "attachments": attachment?.toJson(),
    }..removeWhere((key, value) => value == null);
    final response = await _apiClient.httpPost(
        '/rest/v1.0/crmactivity/$facebookId/addmessage',
        data: mapBody);
    return MessageConversation.fromJson(response);
  }

  @override
  Future<TagStatusFacebook> activeCRMTag(
      {String action, String pageId, String tagId, String facebookId}) async {
    final Map<String, dynamic> mapBody = {
      "action": action,
      "pageId": pageId,
      "tagId": tagId,
    }..removeWhere((key, value) => value == null);
    final response = await _apiClient.httpPost(
        '/rest/v1.0/crmmatching/$facebookId/updatetag',
        data: mapBody);
    return TagStatusFacebook.fromJson(response);
  }

  @override
  Future<ApplicationUser> changeUser(
      {String pageId, String userId, String facebookId}) async {
    final Map<String, dynamic> mapBody = {
      "pageId": pageId,
      "userId": userId,
    }..removeWhere((key, value) => value == null);
    final response = await _apiClient.httpPost(
        '/rest/v1.0/crmmatching/$facebookId/assignuser',
        data: mapBody);
    return ApplicationUser.fromJson(response);
  }

  @override
  Future<String> convertImage({File file}) async {
    final response = await _apiClient.uploadImage(
      '/api/upload/saveimage',
      file,
    );
    return response.toString();
  }

  @override
  Future<ConversationRefetch> refetchConversation(
      {String pageId, String facebookId}) async {
    final Map<String, dynamic> mapBody = {
      "page_id": pageId,
    }..removeWhere((key, value) => value == null);
    final response = await _apiClient.httpPost(
        '/rest/v1.0/crmmatching/$facebookId/refetch?page_id=$pageId',
        data: mapBody);
    return ConversationRefetch.fromJson(response);
  }

  @override
  Future<List<Product>> getProductsByPageFacebook(
      {String keyword, int limit, int skip, String facebookId}) async {
    final List<dynamic> response = await _apiClient.httpPost(
        "/rest/v1.0/product/$facebookId/getproductsbypagefacebook",
        data: {
          "KeyWord": keyword,
          "Limmit": limit,
          "Skip": skip,
        }..removeWhere((key, value) => value == null));
    return response.map((e) => Product.fromJson(e)).toList();
  }

  @override
  Future<MessageConversation> addTemplateMessage(
      {String pageId,
      String toId,
      String facebookId,
      Product product,
      FastSaleOrder fastSaleOrder}) async {
    final Map<String, dynamic> mapBody = {
      "page_id": pageId,
      "to_id": toId,
      "product": product?.toJson(),
      "fs_order": fastSaleOrder?.toJson(),
    }..removeWhere((key, value) => value == null);
    final response = await _apiClient.httpPost(
        '/rest/v1.0/crmactivity/$facebookId/addtemplatemessage',
        data: mapBody);
    return MessageConversation.fromJson(response);
  }

  @override
  Future<OdataListResult<FastSaleOrder>> getFastSaleOrders(
      {int partnerId}) async {
    final response = await _apiClient.httpGet(
        "/odata/FastSaleOrder/ODataService.GetOrdersByPartnerId",
        parameters: {"PartnerId": partnerId});
    return OdataListResult<FastSaleOrder>.fromJson(response);
  }

  @override
  Future<GetListConversationResult> getNotes(
      {String pageId, String facebookId}) async {
    final response =
        await _apiClient.httpGet("/rest/v1.0/crmmatching/$facebookId/notes",
            parameters: {
              "page_id": pageId,
            }..removeWhere((key, value) => value == null));
    return GetListConversationResult.fromJson(response);
  }

  @override
  Future<Conversation> insertNote(
      String message, String pageId, String psid) async {
    final Map<String, dynamic> mapBody = {
      "message": message,
      "page_id": pageId,
      "psid": psid,
    }..removeWhere((key, value) => value == null);
    final response = await _apiClient
        .httpPost('/rest/v1.0/crmmatching/$psid/notes', data: mapBody);
    return Conversation.fromJson(response);
  }

  Future<void> deleteNote(String id) async {
    assert(id != null);
    await _apiClient.httpDelete('/rest/v1.0/crmmatching/$id/notes');
  }
}
