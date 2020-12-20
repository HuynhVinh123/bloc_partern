import 'package:tpos_api_client/src/models/entities/message_conversation.dart';

class GetMessageConversationResult {
  GetMessageConversationResult.fromJson(Map<String, dynamic> json) {
    totalCount = json['TotalCount'] != null
        ? double.parse(json['TotalCount']?.toString())
        : 0;

    totalPages = json['TotalPages'] != null
        ? double.parse(json['TotalPages']?.toString())
        : 0;
    hasNextPage = json['HasNextPage'];
    hasPreviousPage = json['HasPreviousPage'];
    if (json['Items'] != null && json['Items'] is List) {
      items = (json['Items'] as List<dynamic>)
          .map((dynamic f) => MessageConversation.fromJson(f))
          .toList();
    }
  }
  bool hasNextPage;
  bool hasPreviousPage;
  double totalCount;
  double totalPages;
  List<MessageConversation> items;
}
