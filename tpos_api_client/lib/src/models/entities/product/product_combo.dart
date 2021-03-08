class ProductCombo {
  ProductCombo.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap["Id"];
    productId = jsonMap["ProductId"];
    productTemplateId = jsonMap["ProductTemplateId"];
    uOMId = jsonMap["UOMId"];
    createdById = jsonMap["CreatedById"];
    writeById = jsonMap["WriteById"];
    dateCreated = jsonMap["DateCreated"] != null
        ? DateTime.parse(jsonMap["DateCreated"])
        : null;
    lastUpdated = jsonMap["LastUpdated"] != null
        ? DateTime.parse(jsonMap["LastUpdated"])
        : null;
    quantity = jsonMap["Quantity"];
  }

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = {
      "Id": id,
      "ProductId": productId,
      "ProductTemplateId": productTemplateId,
      "UOMId": uOMId,
      "CreatedById": createdById,
      "WriteById": writeById,
      "Quantity": quantity,
      "DateCreated": dateCreated?.toUtc()?.toIso8601String(),
      "LastUpdated": lastUpdated?.toUtc()?.toIso8601String(),
    };

    if (removeIfNull == true) {
      data.removeWhere((key, value) => value == null);
    }

    return data;
  }

  int id;
  int productId;
  int productTemplateId;
  int uOMId;
  String createdById;
  String writeById;
  DateTime dateCreated;
  DateTime lastUpdated;
  double quantity;
}
