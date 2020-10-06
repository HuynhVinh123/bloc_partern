class StockLocation {
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

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Usage'] = this.usage;
    data['ScrapLocation'] = this.scrapLocation;
    data['Name'] = this.name;
    data['CompleteName'] = this.completeName;
    data['ParentLocationId'] = this.parentLocationId;
    data['Active'] = this.active;
    data['ParentLeft'] = this.parentLeft;
    data['CompanyId'] = this.companyId;
    data['ShowUsage'] = this.showUsage;
    data['NameGet'] = this.nameGet;
    if (removeIfNull) data.removeWhere((key, value) => value == null);
    return data;
  }
}
