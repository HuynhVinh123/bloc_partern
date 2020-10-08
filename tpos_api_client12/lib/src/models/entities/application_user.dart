class ApplicationUser {
  ApplicationUser({
    this.email,
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
    //this.groupRefs,
    this.inGroupPartnerManager,
    this.partnerId,
    this.lastUpdated,
    //this.functions,
    //this.fields
    this.avatar,
  });

  ApplicationUser.fromJson(Map<String, dynamic> json) {
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
//    if (json['GroupRefs'] != null) {
//      groupRefs = new List<Null>();
//      json['GroupRefs'].forEach((v) {
//        groupRefs.add(new Null.fromJson(v));
//      });
//    }
    inGroupPartnerManager = json['InGroupPartnerManager'];
    partnerId = json['PartnerId'];
    lastUpdated = json['LastUpdated'];
    avatar = json['Avatar'];
//    if (json['Functions'] != null) {
//      functions = new List<Null>();
//      json['Functions'].forEach((v) {
//        functions.add(new Null.fromJson(v));
//      });
//    }
//    if (json['Fields'] != null) {
//      fields = new List<Null>();
//      json['Fields'].forEach((v) {
//        fields.add(new Null.fromJson(v));
//      });
//    }
  }
  String email;
  String name;
  String id;
  String userName;
  String passwordNew;
  int companyId;
  String companyName;
  String image;
  bool active;
  String barcode;
  int posSecurityPin;
  //List<Null> groupRefs;
  bool inGroupPartnerManager;
  int partnerId;
  DateTime lastUpdated;
  String avatar;
  //List<Null> functions;
  //List<Null> fields;
  Map<String, dynamic> toJson([bool removeIfNull = false]) {
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
//    if (this.groupRefs != null) {
//      data['GroupRefs'] = this.groupRefs.map((v) => v.toJson()).toList();
//    }
    data['InGroupPartnerManager'] = inGroupPartnerManager;
    data['PartnerId'] = partnerId;
    data['LastUpdated'] = lastUpdated;
//    if (this.functions != null) {
//      data['Functions'] = this.functions.map((v) => v.toJson()).toList();
//    }
//    if (this.fields != null) {
//      data['Fields'] = this.fields.map((v) => v.toJson()).toList();
//    }

    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}

class User {
  User(
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

  User.fromJson(Map<String, dynamic> json) {
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
