class SaleOnlineFacebookPostConfig {
  String facebookId;
  bool isEnableAutoHideAll;
  int minLengthToVisible;
  String textContentToHidden;
  String textContentToVisible;
  bool isHiddenWithTextUnspecified;
  bool isOnlyVisibleWithPartner;
  bool isEnableAutoHideEmail;
  bool isEnableAutoHidePhone;
  bool isEnableOrderAuto;
  bool isOnlyOrderWithPartner;
  bool isOnlyOrderWithPhone;
  int minLengthToOrder;
  bool isForceOrderWithPhone;
  bool isForcePrintWithPhone;
  String textContentToExcludeOrder;
  List<TextContentToOrders> textContentToOrders;

  SaleOnlineFacebookPostConfig(
      {this.facebookId,
      this.isEnableAutoHideAll,
      this.minLengthToVisible,
      this.textContentToHidden,
      this.textContentToVisible,
      this.isHiddenWithTextUnspecified,
      this.isOnlyVisibleWithPartner,
      this.isEnableAutoHideEmail,
      this.isEnableAutoHidePhone,
      this.isEnableOrderAuto,
      this.isOnlyOrderWithPartner,
      this.isOnlyOrderWithPhone,
      this.minLengthToOrder,
      this.isForceOrderWithPhone,
      this.isForcePrintWithPhone,
      this.textContentToExcludeOrder,
      this.textContentToOrders});

  SaleOnlineFacebookPostConfig.fromJson(Map<String, dynamic> json) {
    facebookId = json['facebook_id'];
    isEnableAutoHideAll = json['IsEnableAutoHideAll'];
    minLengthToVisible = json['MinLengthToVisible'];
    textContentToHidden = json['TextContentToHidden'];
    textContentToVisible = json['TextContentToVisible'];
    isHiddenWithTextUnspecified = json['IsHiddenWithTextUnspecified'];
    isOnlyVisibleWithPartner = json['IsOnlyVisibleWithPartner'];
    isEnableAutoHideEmail = json['IsEnableAutoHideEmail'];
    isEnableAutoHidePhone = json['IsEnableAutoHidePhone'];
    isEnableOrderAuto = json['IsEnableOrderAuto'];
    isOnlyOrderWithPartner = json['IsOnlyOrderWithPartner'];
    isOnlyOrderWithPhone = json['IsOnlyOrderWithPhone'];
    minLengthToOrder = json['MinLengthToOrder'];
    isForceOrderWithPhone = json['IsForceOrderWithPhone'];
    isForcePrintWithPhone = json['IsForcePrintWithPhone'];
    textContentToExcludeOrder = json['TextContentToExcludeOrder'];
    if (json['TextContentToOrders'] != null) {
      textContentToOrders = new List<TextContentToOrders>();
      json['TextContentToOrders'].forEach((v) {
        textContentToOrders.add(new TextContentToOrders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['facebook_id'] = this.facebookId;
    data['IsEnableAutoHideAll'] = this.isEnableAutoHideAll;
    data['MinLengthToVisible'] = this.minLengthToVisible;
    data['TextContentToHidden'] = this.textContentToHidden;
    data['TextContentToVisible'] = this.textContentToVisible;
    data['IsHiddenWithTextUnspecified'] = this.isHiddenWithTextUnspecified;
    data['IsOnlyVisibleWithPartner'] = this.isOnlyVisibleWithPartner;
    data['IsEnableAutoHideEmail'] = this.isEnableAutoHideEmail;
    data['IsEnableAutoHidePhone'] = this.isEnableAutoHidePhone;
    data['IsEnableOrderAuto'] = this.isEnableOrderAuto;
    data['IsOnlyOrderWithPartner'] = this.isOnlyOrderWithPartner;
    data['IsOnlyOrderWithPhone'] = this.isOnlyOrderWithPhone;
    data['MinLengthToOrder'] = this.minLengthToOrder;
    data['IsForceOrderWithPhone'] = this.isForceOrderWithPhone;
    data['IsForcePrintWithPhone'] = this.isForcePrintWithPhone;
    data['TextContentToExcludeOrder'] = this.textContentToExcludeOrder;
    if (this.textContentToOrders != null) {
      data['TextContentToOrders'] =
          this.textContentToOrders.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TextContentToOrders {
  int index;
  String content;
  TextContentToOrdersProduct product;

  TextContentToOrders({this.index, this.content, this.product});

  TextContentToOrders.fromJson(Map<String, dynamic> json) {
    index = json['Index'];
    content = json['Content'];
    product = json['Product'] != null
        ? new TextContentToOrdersProduct.fromJson(json['Product'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Index'] = this.index;
    data['Content'] = this.content;
    if (this.product != null) {
      data['Product'] = this.product.toJson();
    }
    return data;
  }
}

class TextContentToOrdersProduct {
  int productId;
  String productName;
  String productNameGet;
  String productCode;
  int uOMId;
  String uOMName;
  int price;

  TextContentToOrdersProduct(
      {this.productId,
      this.productName,
      this.productNameGet,
      this.productCode,
      this.uOMId,
      this.uOMName,
      this.price});

  TextContentToOrdersProduct.fromJson(Map<String, dynamic> json) {
    productId = json['ProductId'];
    productName = json['ProductName'];
    productNameGet = json['ProductNameGet'];
    productCode = json['ProductCode'];
    uOMId = json['UOMId'];
    uOMName = json['UOMName'];
    price = json['Price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProductId'] = this.productId;
    data['ProductName'] = this.productName;
    data['ProductNameGet'] = this.productNameGet;
    data['ProductCode'] = this.productCode;
    data['UOMId'] = this.uOMId;
    data['UOMName'] = this.uOMName;
    data['Price'] = this.price;
    return data;
  }
}
