import 'dart:io';

import 'package:tpos_api_client/src/models/entities/attachment.dart';
import 'package:tpos_api_client/src/models/entities/conversation_refetch.dart';
import 'package:tpos_api_client/src/models/entities/message_conversation.dart';
import 'package:tpos_api_client/src/models/entities/unread.dart';
import 'package:tpos_api_client/src/models/results/get_facebook_result.dart';
import 'package:tpos_api_client/src/models/results/get_list_conservation_result.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ConversationApi {
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
  });
  Future<GetListFacebookResult> getAllFacebook();
  Future<Unread> getUnread({String id});

  Future<GetListConversationResult> getListConversationResultBySearch(
      {int page,
      int limit,
      String type,
      String pageId,
      String search,
      String nameStart});
  Future<OdataListResult<ApplicationUser>> getApplicationUser();
  Future<OdataListResult<CRMTag>> getCRMTag({bool isDeleted});
  Future<GetMessageConversationResult> getConversationMessageList(
      {int page, int limit, String type, String pageId, String facebookId});
  Future<MessageConversation> addMessage(
      {String message,
      String toId,
      TPosFacebookUser from,
      String facebookId,
      Attachment attachment});
  Future<CRMTag> activeCRMTag(
      {String action, String pageId, String tagId, String facebookId});

  Future<ApplicationUser> changeUser(
      {String pageId, String userId, String facebookId});
  Future<String> convertImage({File file});
  Future<ConversationRefetch> refetchConversation(
      {String pageId, String facebookId});
}
