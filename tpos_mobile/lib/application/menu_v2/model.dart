class HomeMenuV2FavoriteModel {
  HomeMenuV2FavoriteModel(
      {this.maxItem = 8, this.maxPage = 2, this.routes = const <String>[]});

  HomeMenuV2FavoriteModel.fromJson(Map<String, dynamic> json) {
    maxItem = json['maxItem']?.toInt();
    maxPage = json['maxPage']?.toInt();
    if (json['routes'] != null) {
      routes = (json['routes'] as List).cast<String>();
    }
  }

  int maxItem = 8;
  int maxPage = 2;
  List<String> routes = <String>[];

  Map<String, dynamic> toJson([removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['maxItem'] = maxItem;
    data['maxPage'] = maxPage;
    data['routes'] = routes;

    if (removeIfNull) {
      data.removeWhere((String key, dynamic value) => value == null);
    }

    return data;
  }
}
