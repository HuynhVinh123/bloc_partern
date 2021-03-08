class StockLocation {
  StockLocation(
      {this.id,
      this.usage,
      this.scrapLocation,
      this.name,
      this.completeName,
      this.parentLocationId,
      this.active,
      this.parentLeft,
      this.companyId,
      this.showUsage,
      this.nameGet});

  StockLocation.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    usage = json['Usage'];
    scrapLocation = json['ScrapLocation'];
    name = json['Name'];
    completeName = json['CompleteName'];
    parentLocationId = json['ParentLocationId'];
    active = json['Active'];
    parentLeft = json['ParentLeft'];
    companyId = json['CompanyId'];
    showUsage = json['ShowUsage'];
    nameGet = json['NameGet'];
  }

  int id;
  String usage;
  bool scrapLocation;
  String name;
  String completeName;
  int parentLocationId;
  bool active;
  int parentLeft;
  int companyId;
  String showUsage;
  String nameGet;

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Usage'] = usage;
    data['ScrapLocation'] = scrapLocation;
    data['Name'] = name;
    data['CompleteName'] = completeName;
    data['ParentLocationId'] = parentLocationId;
    data['Active'] = active;
    data['ParentLeft'] = parentLeft;
    data['CompanyId'] = companyId;
    data['ShowUsage'] = showUsage;
    data['NameGet'] = nameGet;
    if (removeIfNull) data.removeWhere((key, value) => value == null);
    return data;
  }
}
