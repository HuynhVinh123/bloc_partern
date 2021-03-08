import 'package:tpos_api_client/src/models/odata_filter/filter_item.dart';

class FilterGroup {
  FilterGroup({this.logic, this.filters});

  FilterGroup.fromJson(Map<String, dynamic> json) {
    logic = json['logic'];
    if (json['filters'] != null) {
      filters = <FilterItem>[];
      json['filters'].forEach((v) {
        filters.add(FilterItem.fromJson(v));
      });
    }
  }
  String logic;
  List<FilterItem> filters;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['logic'] = logic;
    if (filters != null) {
      data['filters'] = filters.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
