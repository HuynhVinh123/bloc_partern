class ProductLocation {
  ProductLocation(this.name, this.id, this.active, this.completeName, this.nameGet, this.scrapLocation, this.showUsage);

  ProductLocation.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    showUsage = json['ShowUsage'];
    nameGet = json['NameGet'];
    completeName = json['CompleteName'];
    id = json['Id'];
    active = json['Active'];
    scrapLocation = json['ScrapLocation'];
  }

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> map = <String, dynamic>{
      'Name': name,
      'Active': active,
      'CompleteName': completeName,
      'ScrapLocation': scrapLocation,
      'Id': id,
      'NameGet': nameGet,
      'ShowUsage': showUsage,
    };

    if (removeIfNull) {
      map.removeWhere((key, value) => value == null);
    }

    return map;
  }

  int id;
  bool active;
  String completeName;
  String name;
  String nameGet;
  bool scrapLocation;
  String showUsage;


}
