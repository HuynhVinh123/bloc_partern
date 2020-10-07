class ApplicationUserFPO {
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
      groupRefs = new List<dynamic>();
      /*json['GroupRefs'].forEach((v) {
        groupRefs.add(new dynamic.fromJson(v));
      });*/
    }
    inGroupPartnerManager = json['InGroupPartnerManager'];
    partnerId = json['PartnerId'];
    lastUpdated = json['LastUpdated'];
    if (json['Functions'] != null) {
      functions = new List<dynamic>();
      /*json['Functions'].forEach((v) {
        functions.add(new dynamic.fromJson(v));
      });*/
    }
    if (json['Fields'] != null) {
      fields = new List<dynamic>();
      /*json['Fields'].forEach((v) {
        fields.add(new dynamic.fromJson(v));
      });*/
    }
  }

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
    if (this.groupRefs != null) {
      data['GroupRefs'] = this.groupRefs.map((v) => v.toJson()).toList();
    }
    data['InGroupPartnerManager'] = this.inGroupPartnerManager;
    data['PartnerId'] = this.partnerId;
    data['LastUpdated'] = this.lastUpdated;
    if (this.functions != null) {
      data['Functions'] = this.functions.map((v) => v.toJson()).toList();
    }
    if (this.fields != null) {
      data['Fields'] = this.fields.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
