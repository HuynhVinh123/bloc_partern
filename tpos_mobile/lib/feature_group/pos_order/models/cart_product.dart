class CartProduct {
  CartProduct(
      {this.id,
      this.uOMId,
      this.version,
      this.productTmplId,
      this.price,
      this.oldPrice,
      this.discountPurchase,
      this.weight,
      this.discountSale,
      this.name,
      this.uOMName,
      this.nameGet,
      this.nameNoSign,
      this.imageUrl,
      this.purchasePrice,
      this.saleOK,
      this.purchaseOK,
      this.availableInPOS,
      this.defaultCode,
      this.barcode,
      this.qty,
      this.posSalesCount,
      this.factor});

  CartProduct.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap["Id"];
    name = jsonMap["Name"];
    uOMId = jsonMap["UOMId"];
    uOMName = jsonMap["UOMName"];
    nameNoSign = jsonMap["NameNoSign"];
    nameGet = jsonMap["NameGet"];
    price = jsonMap["Price"];
    oldPrice = jsonMap["OldPrice"];
    version = jsonMap["Version"];
    discountPurchase = (jsonMap["DiscountPurchase"] ?? 0).toDouble();
    weight = (jsonMap["Weight"] ?? 0).toDouble();
    discountSale = jsonMap["DiscountSale"];
    productTmplId = jsonMap["ProductTmplId"];
    imageUrl = jsonMap["ImageUrl"];
    purchasePrice = jsonMap["PurchasePrice"];
    factor = jsonMap["Factor"];
    if (jsonMap["SaleOK"] == true || jsonMap["SaleOK"] == false) {
      saleOK = jsonMap["SaleOK"];
    } else if (jsonMap["SaleOK"] == 0 || jsonMap["SaleOK"] == 1) {
      if (jsonMap["SaleOK"] == 0) {
        saleOK = false;
      } else {
        saleOK = true;
      }
    }
    if (jsonMap["PurchaseOK"] == true || jsonMap["PurchaseOK"] == false) {
      purchaseOK = jsonMap["PurchaseOK"];
    } else if (jsonMap["PurchaseOK"] == 0 || jsonMap["PurchaseOK"] == 1) {
      if (jsonMap["PurchaseOK"] == 0) {
        purchaseOK = false;
      } else {
        purchaseOK = true;
      }
    }
    if (jsonMap["AvailableInPOS"] == true ||
        jsonMap["AvailableInPOS"] == false) {
      availableInPOS = jsonMap["AvailableInPOS"];
    } else if (jsonMap["AvailableInPOS"] == 0 ||
        jsonMap["AvailableInPOS"] == 1) {
      if (jsonMap["AvailableInPOS"] == 0) {
        availableInPOS = false;
      } else {
        availableInPOS = true;
      }
    }

    defaultCode = jsonMap["DefaultCode"];
    barcode = jsonMap["Barcode"];

    if (jsonMap["PosSalesCount"] != 0) {
      posSalesCount = jsonMap["PosSalesCount"];
    } else {
      posSalesCount = 0;
    }
  }

  int id, uOMId, version, productTmplId;
  double price, oldPrice, discountPurchase, discountSale;
  String name, uOMName, nameGet, nameNoSign;
  String imageUrl;
  String defaultCode;
  double weight;

  double purchasePrice;
  bool saleOK;
  bool purchaseOK;
  bool availableInPOS;
  String barcode;
  int qty = 0;
  double posSalesCount;
  double factor;

  Map<String, dynamic> toJson({bool removeIfNull}) {
    final map = {
      "Id": id,
      "Name": name,
      "UOMId": uOMId,
      "UOMName": uOMName,
      "NameNoSign": nameNoSign,
      "NameGet": nameGet,
      "Price": price,
      "OldPrice": oldPrice,
      "Version": version,
      "DiscountSale": discountSale,
      "DiscountPurchase": discountPurchase,
      "Weight": weight,
      "ProductTmplId": productTmplId,
      "ImageUrl": imageUrl,
      "PurchasePrice": purchasePrice,
      "SaleOK": saleOK,
      "PurchaseOK": purchaseOK,
      "AvailableInPOS": availableInPOS,
      "DefaultCode": defaultCode,
      "Barcode": barcode,
      "PosSalesCount": posSalesCount,
      "Factor": factor
    };

    map.removeWhere((key, value) => value == null || value == "");

    return map;
  }
}
