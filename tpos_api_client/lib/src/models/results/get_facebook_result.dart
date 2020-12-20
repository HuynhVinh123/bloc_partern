import 'package:tpos_api_client/tpos_api_client.dart';

class GetListFacebookResult {
  GetListFacebookResult.fromJson(Map<String, dynamic> json) {
    totalCount = json['TotalCount'] != null
        ? double.parse(json['TotalCount']?.toString())
        : 0;
    hasNextPage = json['HasNextPage'];
    hasPreviousPage = json['HasPreviousPage'];
    if (json['Items'] != null && json['Items'] is List) {
      items = (json['Items'] as List<dynamic>)
          .map((dynamic f) => CRMTeam.fromJson(f))
          .toList();
    }
  }
  bool hasNextPage;
  bool hasPreviousPage;
  double totalCount;
  List<CRMTeam> items;
}
