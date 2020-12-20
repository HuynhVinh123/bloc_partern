import 'package:tpos_api_client/src/models/entities/conversation.dart';

class GetListConversationResult {
  GetListConversationResult.fromJson(Map<String, dynamic> json) {
    totalCount = json['TotalCount'] != null
        ? double.parse(json['TotalCount']?.toString())
        : 0;
    hasNextPage = json['HasNextPage'];
    hasPreviousPage = json['HasPreviousPage'];
    if (json['Items'] != null && json['Items'] is List) {
      items = (json['Items'] as List<dynamic>)
          .map((dynamic f) => Conversation.fromJson(f))
          .toList();
    }
  }
  bool hasNextPage;
  bool hasPreviousPage;
  double totalCount;
  List<Conversation> items;
}
