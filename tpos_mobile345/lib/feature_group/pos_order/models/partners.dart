class Partners {
  Partners(
      {this.barcode,
      this.displayName,
      this.email,
      this.id,
      this.name,
      this.phone,
      this.street,
      this.image,
      this.taxCode});

  Partners.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap["Id"];
    name = jsonMap["Name"];
    displayName = jsonMap["DisplayName"];
    street = jsonMap["Street"];
    phone = jsonMap["Phone"];
    email = jsonMap["Email"];
    barcode = jsonMap["Barcode"];
    image = jsonMap["Image"];
    taxCode = jsonMap["TaxCode"];
  }

  String barcode;
  String displayName;
  String email;
  int id;
  String name;
  String phone;
  String street;
  String image;
  String taxCode;

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    Map<String, dynamic> data;
    if (id != null) {
      data = {
        "Id": id,
        "Name": name,
        "DisplayName": displayName,
        "Street": street,
        "Phone": phone,
        "Email": email,
        "Barcode": barcode,
        "Image": image,
        "TaxCode": taxCode
      };
    } else {
      data = {
        "Name": name,
        "DisplayName": displayName,
        "Street": street,
        "Phone": phone,
        "Email": email,
        "Barcode": barcode,
        "Image": image,
        "TaxCode": taxCode
      };
    }

    return data;
  }
}
