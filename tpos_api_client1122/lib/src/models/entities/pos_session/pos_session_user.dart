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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Email'] = email;
    data['Name'] = name;
    data['Id'] = id;
    data['UserName'] = userName;
    data['PasswordNew'] = passwordNew;
    data['CompanyId'] = companyId;
    data['CompanyName'] = companyName;
    data['Image'] = image;
    data['Active'] = active;
    data['Barcode'] = barcode;
    data['PosSecurityPin'] = posSecurityPin;

    data['InGroupPartnerManager'] = inGroupPartnerManager;
    data['PartnerId'] = partnerId;
    data['LastUpdated'] = lastUpdated;
    return data;
  }
}
