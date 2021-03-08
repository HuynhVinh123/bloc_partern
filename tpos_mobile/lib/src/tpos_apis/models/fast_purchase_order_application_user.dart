class ApplicationUserFPO {
  ApplicationUserFPO(
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

  ApplicationUserFPO.fromJson(Map<String, dynamic> json) {
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
    if (json['GroupRefs'] != null) {
      groupRefs = <dynamic>[];
      /*json['GroupRefs'].forEach((v) {
        groupRefs.add(new dynamic.fromJson(v));
      });*/
    }
    inGroupPartnerManager = json['InGroupPartnerManager'];
    partnerId = json['PartnerId'];
    lastUpdated = json['LastUpdated'];
    if (json['Functions'] != null) {
      functions = <dynamic>[];
      /*json['Functions'].forEach((v) {
        functions.add(new dynamic.fromJson(v));
      });*/
    }
    if (json['Fields'] != null) {
      fields = <dynamic>[];
      /*json['Fields'].forEach((v) {
        fields.add(new dynamic.fromJson(v));
      });*/
    }
  }
  String email;
  String name;
  String id;
  String userName;
  dynamic passwordNew;
  int companyId;
  String companyName;
  dynamic image;
  bool active;
  dynamic barcode;
  dynamic posSecurityPin;
  List<dynamic> groupRefs;
  bool inGroupPartnerManager;
  int partnerId;
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
    if (groupRefs != null) {
      data['GroupRefs'] = groupRefs.map((v) => v.toJson()).toList();
    }
    data['InGroupPartnerManager'] = inGroupPartnerManager;
    data['PartnerId'] = partnerId;
    data['LastUpdated'] = lastUpdated;
    if (functions != null) {
      data['Functions'] = functions.map((v) => v.toJson()).toList();
    }
    if (fields != null) {
      data['Fields'] = fields.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
