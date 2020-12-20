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
      textContentToOrders = <TextContentToOrders>[];
      json['TextContentToOrders'].forEach((v) {
        textContentToOrders.add(TextContentToOrders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['facebook_id'] = facebookId;
    data['IsEnableAutoHideAll'] = isEnableAutoHideAll;
    data['MinLengthToVisible'] = minLengthToVisible;
    data['TextContentToHidden'] = textContentToHidden;
    data['TextContentToVisible'] = textContentToVisible;
    data['IsHiddenWithTextUnspecified'] = isHiddenWithTextUnspecified;
    data['IsOnlyVisibleWithPartner'] = isOnlyVisibleWithPartner;
    data['IsEnableAutoHideEmail'] = isEnableAutoHideEmail;
    data['IsEnableAutoHidePhone'] = isEnableAutoHidePhone;
    data['IsEnableOrderAuto'] = isEnableOrderAuto;
    data['IsOnlyOrderWithPartner'] = isOnlyOrderWithPartner;
    data['IsOnlyOrderWithPhone'] = isOnlyOrderWithPhone;
    data['MinLengthToOrder'] = minLengthToOrder;
    data['IsForceOrderWithPhone'] = isForceOrderWithPhone;
    data['IsForcePrintWithPhone'] = isForcePrintWithPhone;
    data['TextContentToExcludeOrder'] = textContentToExcludeOrder;
    if (textContentToOrders != null) {
      data['TextContentToOrders'] =
          textContentToOrders.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TextContentToOrders {
  TextContentToOrders({this.index, this.content, this.product});
  TextContentToOrders.fromJson(Map<String, dynamic> json) {
    index = json['Index'];
    content = json['Content'];
    product = json['Product'] != null
        ? TextContentToOrdersProduct.fromJson(json['Product'])
        : null;
  }

  int index;
  String content;
  TextContentToOrdersProduct product;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Index'] = index;
    data['Content'] = content;
    if (product != null) {
      data['Product'] = product.toJson();
    }
    return data;
  }
}

class TextContentToOrdersProduct {
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

  int productId;
  String productName;
  String productNameGet;
  String productCode;
  int uOMId;
  String uOMName;
  int price;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ProductId'] = productId;
    data['ProductName'] = productName;
    data['ProductNameGet'] = productNameGet;
    data['ProductCode'] = productCode;
    data['UOMId'] = uOMId;
    data['UOMName'] = uOMName;
    data['Price'] = price;
    return data;
  }
}
