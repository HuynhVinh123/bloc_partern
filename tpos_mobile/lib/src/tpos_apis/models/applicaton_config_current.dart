class ApplicationConfigCurrent {
  ApplicationConfigCurrent(
      {this.odataContext,
      this.saleOnlineFacebookSessionStarted,
      this.saleOnlineFacebookSessionEnable,
      this.saleOnlineFacebookSession,
      this.saleOnlineFacebookSessionIndex,
      this.month,
      this.localIP,
      this.quantityInMonthSaleOnlineOrder,
      this.quantityDeletedInMonthSaleOnlineOrder,
      this.facebookMessageSender});

  ApplicationConfigCurrent.fromJson(Map<String, dynamic> json) {
    odataContext = json['@odata.context'];
    saleOnlineFacebookSessionStarted =
        json['SaleOnline_Facebook_SessionStarted'];
    saleOnlineFacebookSessionEnable = json['SaleOnline_Facebook_SessionEnable'];
    saleOnlineFacebookSession = json['SaleOnline_Facebook_Session'];
    saleOnlineFacebookSessionIndex = json['SaleOnline_Facebook_SessionIndex'];
    month = json['Month'];
    localIP = json['LocalIP'];
    quantityInMonthSaleOnlineOrder = json['QuantityInMonth_SaleOnline_Order'];
    quantityDeletedInMonthSaleOnlineOrder =
        json['QuantityDeletedInMonth_SaleOnline_Order'];
    facebookMessageSender = json['FacebookMessageSender'];
  }
  String odataContext;
  String saleOnlineFacebookSessionStarted;
  bool saleOnlineFacebookSessionEnable;
  int saleOnlineFacebookSession;
  int saleOnlineFacebookSessionIndex;
  String month;
  String localIP;
  int quantityInMonthSaleOnlineOrder;
  int quantityDeletedInMonthSaleOnlineOrder;
  String facebookMessageSender;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['@odata.context'] = odataContext;
    data['SaleOnline_Facebook_SessionStarted'] =
        saleOnlineFacebookSessionStarted;
    data['SaleOnline_Facebook_SessionEnable'] = saleOnlineFacebookSessionEnable;
    data['SaleOnline_Facebook_Session'] = saleOnlineFacebookSession;
    data['SaleOnline_Facebook_SessionIndex'] = saleOnlineFacebookSessionIndex;
    data['Month'] = month;
    data['LocalIP'] = localIP;
    data['QuantityInMonth_SaleOnline_Order'] = quantityInMonthSaleOnlineOrder;
    data['QuantityDeletedInMonth_SaleOnline_Order'] =
        quantityDeletedInMonthSaleOnlineOrder;
    data['FacebookMessageSender'] = facebookMessageSender;
    return data;
  }
}
