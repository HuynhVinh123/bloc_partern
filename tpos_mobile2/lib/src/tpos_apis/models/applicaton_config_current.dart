class ApplicationConfigCurrent {
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['@odata.context'] = this.odataContext;
    data['SaleOnline_Facebook_SessionStarted'] =
        this.saleOnlineFacebookSessionStarted;
    data['SaleOnline_Facebook_SessionEnable'] =
        this.saleOnlineFacebookSessionEnable;
    data['SaleOnline_Facebook_Session'] = this.saleOnlineFacebookSession;
    data['SaleOnline_Facebook_SessionIndex'] =
        this.saleOnlineFacebookSessionIndex;
    data['Month'] = this.month;
    data['LocalIP'] = this.localIP;
    data['QuantityInMonth_SaleOnline_Order'] =
        this.quantityInMonthSaleOnlineOrder;
    data['QuantityDeletedInMonth_SaleOnline_Order'] =
        this.quantityDeletedInMonthSaleOnlineOrder;
    data['FacebookMessageSender'] = this.facebookMessageSender;
    return data;
  }
}
