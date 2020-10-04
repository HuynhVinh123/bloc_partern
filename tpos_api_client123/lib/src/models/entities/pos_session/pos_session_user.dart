class PosSessionUser {
  PosSessionUser(
      {this.email,
      this.name,
      this.id,
      this.userName,
      this.passwordNew,
      this.companyId,
      this.companyName,
      this.image,
      this.active,
      this.barcode,
      this.posSecurityPin,
      this.groupRefs,
      this.inGroupPartnerManager,
      this.partnerId,
      this.lastUpdated,
      this.functions,
      this.fields});

  PosSessionUser.fromJson(Map<String, dynamic> json) {
    email = json['Email'];
    name = json['Name'];
    id = json['Id'];
    userName = json['UserName'];
    passwordNew = json['PasswordNew'];
    companyId = json['CompanyId'];
    companyName = json['CompanyName'];
    image = json['Image'];
    active = json['Active'];
    barcode = json['Barcode'];
    posSecurityPin = json['PosSecurityPin'];

    inGroupPartnerManager = json['InGroupPartnerManager'];
    partnerId = json['PartnerId'];
    lastUpdated = json['LastUpdated'];
  }

  String email;
  String name;
  String id;
  String userName;
  String passwordNew;
  int companyId;
  String companyName;
  dynamic image;
  bool active;
  dynamic barcode;
  dynamic posSecurityPin;
  List<dynamic> groupRefs;
  bool inGroupPartnerManager;
  dynamic partnerId;
  dynamic lastUpdated;
  List<dynamic> functions;
  List<dynamic> fields;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Email'] = this.email;
    data['Name'] = this.name;
    data['Id'] = this.id;
    data['UserName'] = this.userName;
    data['PasswordNew'] = this.passwordNew;
    data['CompanyId'] = this.companyId;
    data['CompanyName'] = this.companyName;
    data['Image'] = this.image;
    data['Active'] = this.active;
    data['Barcode'] = this.barcode;
    data['PosSecurityPin'] = this.posSecurityPin;

    data['InGroupPartnerManager'] = this.inGroupPartnerManager;
    data['PartnerId'] = this.partnerId;
    data['LastUpdated'] = this.lastUpdated;
    return data;
  }
}
