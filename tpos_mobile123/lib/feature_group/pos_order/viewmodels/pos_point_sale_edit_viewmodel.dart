import 'package:flutter/cupertino.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/point_sale.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/pos_make_payment.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/price_list.dart';
import 'package:tpos_mobile/feature_group/pos_order/services/pos_tpos_api.dart';
import 'package:tpos_mobile/locator.dart';

import 'package:tpos_mobile/services/dialog_service.dart';

class PosPointSaleEditViewModel extends ViewModelBase {
  PosPointSaleEditViewModel(
      {IPosTposApi tposApiService, DialogService dialogService}) {
    _tposApi = tposApiService ?? locator<IPosTposApi>();
    _dialog = dialogService ?? locator<DialogService>();
  }
  DialogService _dialog;
  IPosTposApi _tposApi;

  int countName = 0;

  PointSale pointSale = PointSale();
  PickingType _pickingType;
  StockLocation _stockLocation;
  PriceList _prices;
  Tax _tax;
  double discount = 0;
  String valuePrint = "0";

  List<Journal> _accountJournals = [];
  List<Journal> get accountJournals => _accountJournals;
  set accountJournals(List<Journal> value) {
    _accountJournals = value;
    notifyListeners();
  }

  PickingType get pickingType => _pickingType;
  set pickingType(PickingType value) {
    _pickingType = value;
    notifyListeners();
  }

  StockLocation get stockLocation => _stockLocation;
  set stockLocation(StockLocation value) {
    _stockLocation = value;
    notifyListeners();
  }

  PriceList get prices => _prices;
  set prices(PriceList value) {
    _prices = value;
    notifyListeners();
  }

  Tax get tax => _tax;
  set tax(Tax value) {
    _tax = value;
    notifyListeners();
  }

  bool ifaceDiscount = false,
      ifaceDiscountFixed = false,
      ifaceTax = false,
      isHeaderOrFooter = false,
      ifaceLogo = false;
  bool isClick = false;

  Map<String, bool> values = {
    "ifacePrintAuto": false,
    "ifacePrintSkipScreen": false,
    "ifacePaymentAuto": false,
    "ifaceOrderlineNotes": false,
    "useCache": false
  };

  Map<String, bool> actives = {
    "isActive": false,
  };

  Map<String, bool> cashMoneys = {"cashControl": false};

  List<String> nameConfigs = [
    "Tự động in",
    "Tự động chuyển sang đơn hàng kế tiếp",
    "Tự động điền số tiền thanh toán đúng với số tiền còn lại",
    "Ghi chú trên chi tiết bán hàng",
    "Giúp tải nhanh danh sách sản phẩm khi mở một phiên bán hàng"
  ];

  void setDataSetting(PointSale pointSale) {
    actives["isActive"] = pointSale.active ?? false;
    values["ifacePrintAuto"] = pointSale.ifacePrintAuto ?? false;
    values["ifacePrintSkipScreen"] = pointSale.ifacePrintSkipScreen ?? false;
    values["ifacePaymentAuto"] = pointSale.ifacePaymentAuto ?? false;
    values["ifaceOrderlineNotes"] = pointSale.ifaceOrderlineNotes ?? false;
    values["useCache"] = pointSale.useCache ?? false;
    cashMoneys["cashControl"] = pointSale.cashControl ?? false;
    ifaceDiscount = pointSale.ifaceDiscount ?? false;
    ifaceDiscountFixed = pointSale.ifaceDiscountFixed ?? false;
    ifaceTax = pointSale.ifaceTax ?? false;
    isHeaderOrFooter = pointSale.isHeaderOrFooter ?? false;
    ifaceLogo = pointSale.ifaceLogo ?? false;
    if (pointSale.printer == "58") {
      valuePrint = "2";
    } else {
      valuePrint = "1";
    }

    pickingType = pointSale.pickingType;
    stockLocation = pointSale.stockLocation;
    prices = pointSale.priceList;
    tax = pointSale.tax;

    notifyListeners();
  }

  void resetObject(
      {PickingType pickingType,
      StockLocation stockLocation,
      PriceList priceList}) {
    if (pickingType != null) {
      pickingType = null;
    } else if (stockLocation != null) {
      stockLocation = null;
    } else if (priceList != null) {
      priceList = null;
    }
    notifyListeners();
  }

  void resetPickingType() {
    pickingType = null;
    notifyListeners();
  }

  void resetStockLocation() {
    stockLocation = null;
    notifyListeners();
  }

  void resetPriceList() {
    prices = null;
    notifyListeners();
  }

  void resetTax() {
    tax = null;
    notifyListeners();
  }

  void incrementDiscount(String value) {
    discount = double.parse(value.replaceAll(".", ""));
    discount++;
    notifyListeners();
  }

  void reduceDiscount(String value) {
    discount = double.parse(value.replaceAll(".", ""));
    discount--;
    if (discount < 0) {
      discount = 0;
    }
    notifyListeners();
  }

  void updateData(
      {String name,
      BuildContext context,
      String receiptFooter,
      String receiptHeader,
      String discount}) {
    this.discount = double.parse(discount.replaceAll(".", ""));
    pointSale.receiptFooter = receiptFooter;
    pointSale.receiptHeader = receiptHeader;
    pointSale.ifacePrintAuto = values["ifacePrintAuto"];
    pointSale.ifacePrintSkipScreen = values["ifacePrintSkipScreen"];
    pointSale.ifacePaymentAuto = values["ifacePaymentAuto"];
    pointSale.ifaceOrderlineNotes = values["ifaceOrderlineNotes"];
    pointSale.useCache = values["useCache"];
    pointSale.ifaceDiscount = ifaceDiscount;
    pointSale.ifaceDiscountFixed = ifaceDiscountFixed;
    pointSale.ifaceTax = ifaceTax;
    pointSale.isHeaderOrFooter = isHeaderOrFooter;
    pointSale.ifaceLogo = ifaceLogo;
    pointSale.cashControl = cashMoneys["cashControl"];
    pointSale.active = actives["isActive"];
    pointSale.name = name;
    pointSale.pickingType = pickingType;
    if (pickingType != null) {
      pointSale.pickingTypeId = pickingType.id;
    } else {
      pointSale.pickingTypeId = null;
    }
    pointSale.stockLocation = stockLocation;
    if (stockLocation != null) {
      pointSale.stockLocationId = stockLocation.id;
    } else {
      pointSale.stockLocationId = null;
    }
    pointSale.priceList = prices;
    if (prices != null) {
      pointSale.priceListId = prices.id;
    } else {
      pointSale.priceListId = null;
    }
    pointSale.tax = tax;
    if (tax != null) {
      pointSale.taxId = tax.id;
    } else {
      pointSale.taxId = null;
    }

    pointSale.discountPc = this.discount;
    if (prices != null) {
      if (prices.active == 1) {
        prices.activeApi = true;
      } else {
        prices.activeApi = false;
      }
    }
    if (valuePrint == "1") {
      pointSale.printer = "80";
    } else {
      pointSale.printer = "58";
    }

    updatePointSale(context);
  }

  Future<void> getAccountJournalsPointSale() async {
    setState(true);
    try {
      final result = await _tposApi.getAccountJournalsPointSale();
      if (result != null) {
        accountJournals = result;
      }
    } catch (e, s) {
      logger.error("getAccountJournalsPointSaleFail", e, s);
      _dialog.showError(error: e);
    }
    setState(false);
  }

  Future<void> updatePointSale(BuildContext context) async {
    setState(true);
    try {
      final result = await _tposApi.updateConfigPointSale(pointSale);
      if (result) {
        _dialog.showNotify(
            title: "Thông báo", message: "Cập nhật thông tin thành công");
        Navigator.pop(context);
      }
    } catch (e, s) {
      logger.error("updatePointSale", e, s);
    }
    setState(false);
  }

  void handleAddAccountJournal(Journal value) {
    for (var i = 0; i < pointSale.journals.length; i++) {
      if (value.id == pointSale.journals[i].id) {
        return;
      }
    }
    pointSale.journals.add(value);
    notifyListeners();
  }

  void deleteAccountJournal(int index) {
    pointSale.journals.removeAt(index);
    notifyListeners();
  }

  void changeValuePrint(String value) {
    valuePrint = value;
    notifyListeners();
  }
}
