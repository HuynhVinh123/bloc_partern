import 'package:flutter/material.dart';

import 'package:open_file/open_file.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/helpers/tpos_api_helper.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';

import 'package:tpos_mobile/src/tpos_apis/models/order_line.dart';


import 'package:tpos_mobile/src/tpos_apis/models/sale_quotation_detail.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class SaleQuotationAddEditViewModel extends ViewModelBase {
  SaleQuotationAddEditViewModel(
      {ITposApiService tposApiService, DialogService dialogService}) {
    _tposApi = tposApiService ?? locator<ITposApiService>();
    _dialog = dialogService ?? locator<DialogService>();
  }

  DialogService _dialog;
  ITposApiService _tposApi;

  ApplicationUser _applicationUser = ApplicationUser();
  Product _product = Product();
  DateTime dateQuotation = DateTime.now();
  DateTime validityDate;
  String _selectAccountPaymentTerm = "0";
  SaleQuotationDetail _saleQuotationDetail;
  Partner _partner = Partner();
  List<OrderLines> _orderLines = <OrderLines>[];
  List<AccountPaymentTerm> _accountPaymentTerms = [];
  bool isChangeData = false;
  bool _isChangeDateQuotation = false;
  bool _isChangeValidity = false;

  ApplicationUser get applicationUser => _applicationUser;
  set applicationUser(ApplicationUser value) {
    _applicationUser = value;
    notifyListeners();
  }

  Product get product => _product;
  set product(Product value) {
    _product = value;
    notifyListeners();
  }

  String get selectAccountPaymentTerm => _selectAccountPaymentTerm;
  set selectAccountPaymentTerm(String value) {
    _selectAccountPaymentTerm = value;
    notifyListeners();
  }

  SaleQuotationDetail get saleQuotationDetail => _saleQuotationDetail;
  set saleQuotationDetail(SaleQuotationDetail value) {
    _saleQuotationDetail = value;
    notifyListeners();
  }

  Partner get partner => _partner;
  set partner(Partner value) {
    _partner = value;
    notifyListeners();
  }

  List<OrderLines> get orderLines => _orderLines;
  set orderLines(List<OrderLines> value) {
    _orderLines = value;
    notifyListeners();
  }

  List<AccountPaymentTerm> get accountPaymentTerms => _accountPaymentTerms;
  set accountPaymentTerms(List<AccountPaymentTerm> value) {
    _accountPaymentTerms = value;
    notifyListeners();
  }

  Future<void> updateQuotation() async {
    setState(true);
    try {
      await _tposApi.updateSaleQuotation(saleQuotationDetail);

      /// Cập nhật thông tin phiếu báo giá thành công
      showNotify("${S.current.quotation_quotationWasUpdatedSuccessful}!");
      setState(false);
    } catch (e, s) {
      logger.error("updateQuotation", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> markQuotation() async {
    setState(true);
    try {
      await _tposApi.markSaleQuotation(_saleQuotationDetail.id);
    } catch (e, s) {
      logger.error("markQuotation", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> addQuotation() async {
    setState(true);
    try {
      saleQuotationDetail =
          await _tposApi.addInfoSaleQuotation(saleQuotationDetail);
      showNotify("${S.current.quotation_quotationWasAddedSuccessful}!");
      setState(false);
    } catch (e, s) {
      logger.error("addQuotation", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> getInfoSaleQuotation(int id) async {
    setState(true);
    try {
      final result = await _tposApi.getInfoSaleQuotation(id.toString());
      if (result != null) {
        saleQuotationDetail = result;
        saleQuotationDetail.id = 0;
        final DateTime timeNow = DateTime.now();
        saleQuotationDetail.dateQuotation =
            timeNow.toIso8601String() + printDuration(timeNow.timeZoneOffset);
        saleQuotationDetail.state = "draft";
      }

      setState(false);
    } catch (e, s) {
      logger.error("loadInfoSaleQuotationsFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> getOrderLines(int id) async {
    setState(true);
    try {
      final result = await _tposApi.getOrderLineForSaleQuotation(id.toString());
      if (result != null) {
        orderLines = result;
      }
      setState(false);
    } catch (e, s) {
      logger.error("getOrderLines", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> getPriceList() async {
    setState(true);
    try {
      _saleQuotationDetail.partner = partner;
      _saleQuotationDetail.partner?.partnerCategories = [];
      _saleQuotationDetail.partner?.categoryId = 0;
      final SaleQuotationDetail _saleQuotation =
          await _tposApi.getPriceListSaleQuotation(saleQuotationDetail);
      _saleQuotationDetail.priceList = _saleQuotation.priceList;
      _saleQuotationDetail.priceListId = _saleQuotation.priceListId;
      if (saleQuotationDetail.priceList != null) {
        _saleQuotationDetail.priceListId = saleQuotationDetail?.priceList?.id;
      }
      _saleQuotationDetail.paymentTerm = _saleQuotation.paymentTerm;
      _saleQuotationDetail.paymentTermId = _saleQuotation.paymentTermId;
      if (_saleQuotationDetail.paymentTerm != null) {
        _selectAccountPaymentTerm =
            saleQuotationDetail.paymentTerm.id.toString();
      } else {
        _selectAccountPaymentTerm = "0";
      }

      setState(false);
    } catch (e, s) {
      logger.error("getPriceList", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> getAccountPaymentTerms() async {
    setState(true);
    try {
      final result = await _tposApi.getAccountPaymentTerms();
      if (result != null) {
        accountPaymentTerms = result;

        /// Chọn điều khoản
        accountPaymentTerms.add(
            AccountPaymentTerm(id: 0, name: S.current.quotation_chooseTerms));
      }
      setState(false);
    } catch (e, s) {
      logger.error("getAccountPaymentTerms", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> exportExcel(String id, BuildContext context) async {
    try {
      setState(true);
      final result = await _tposApi.exportExcelSaleQuotation(id);
      if (result != null) {
        Navigator.of(context).pop();
        showDialogOpenFileExcel(
            content:
                "${S.current.fileWasSavedInFolder}: $result. ${S.current.doYouWantToOpenFile}",
            context: context,
            path: result);
      } else {
        _dialog.showError(
            title: S.current.error, content: S.current.permission);
      }
      setState(false);
    } catch (e) {
      _dialog.showError(title: S.current.error, content: e.toString());
      setState(false);
    }
  }

  Future<void> exportPDF(String id, BuildContext context) async {
    try {
      setState(true);
      final result = await _tposApi.exportPDFSaleQuotation(id);
      if (result != null) {
        Navigator.of(context).pop();
        showDialogOpenFileExcel(
            content:
                "${S.current.fileWasSavedInFolder}: $result. ${S.current.doYouWantToOpenFile}",
            context: context,
            path: result);
      } else {
        _dialog.showError(
            title: S.current.error, content: S.current.permission);
      }
      setState(false);
    } catch (e) {
      _dialog.showError(title: S.current.error, content: e.toString());
      setState(false);
    }
  }

  Future<void> getDefaultSaleQuotation() async {
    setState(true);
    try {
      final result = await _tposApi.getDefaultSaleQuotation();
      if (result != null) {
        saleQuotationDetail = result;
      }
      setState(false);
    } catch (e, s) {
      logger.error("getDefaultSaleQuotation", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  double amountTotalPayment() {
    double total = 0;
    for (int i = 0; i < orderLines.length; i++) {
      total += (orderLines[i].priceUnit * orderLines[i].productUOMQty) *
          (1 - (orderLines[i].discount / 100));
    }
    return total;
  }

  double amountTotalPaymentNoTax() {
    double total = 0;
    for (int i = 0; i < orderLines.length; i++) {
      total += (orderLines[i].priceUnit * orderLines[i].productUOMQty) *
          (1 - (orderLines[i].discount / 100));
    }
    return total;
  }

  void setDateTimeQuotation(DateTime date, {bool isFirstData = true}) {
    if (isFirstData) {
      _isChangeDateQuotation = true;
    }
    dateQuotation = date;
    notifyListeners();
  }

  void setValidityDate(DateTime dateValidity) {
    if (dateValidity != null) {
      _isChangeValidity = true;
    }

    validityDate = dateValidity;
    notifyListeners();
  }

  void setDataForProduct(Product product) {
    bool isSimilar = false;
    for (int i = 0; i < orderLines.length; i++) {
      if (orderLines[i].productId == product.id) {
        isSimilar = true;
        orderLines[i].productUOMQty++;
        break;
      }
    }

    if (!isSimilar) {
      final OrderLines line = OrderLines();
      line.discount = 0;
      line.name = product.name;
      line.nameGet = product.nameGet;
      line.priceSubTotal = product.price;
      line.priceTotal = product.price;
      line.priceUnit = product.price;
      line.product = product;
      line.productId = product.id;
      line.productUOM = product.uOM;
      line.productUOMId = product.uOMId;
      line.productUOMName = product.uOMName;
      line.productUOMQty = 1;
      line.imageUrl = product.imageUrl;

      orderLines.add(line);
    }
    notifyListeners();
  }

  void updateDataForProduct(OrderLines orderLine, int index) {
    orderLines[index] = orderLine;
    notifyListeners();
  }

  void updateInfoProduct(OrderLines item, int index) {
    orderLines[index] = item;
    notifyListeners();
  }

  double amountTotal(OrderLines item) {
    double total = 0;
    total = (item.priceUnit * item.productUOMQty) * (1 - item.discount / 100);
    return total;
  }

  Future<void> updateInfoQuotation(
      String note, BuildContext context, bool isConfirm, bool isUpdate) async {
    saleQuotationDetail.amountTax = 0;
    saleQuotationDetail.note = note;
    saleQuotationDetail.amountTotal = amountTotalPayment();
    saleQuotationDetail.amountUntaxed = amountTotalPaymentNoTax();
    saleQuotationDetail.dateQuotation = _isChangeDateQuotation
        ? dateQuotation.toUtc().toIso8601String()
        : _saleQuotationDetail?.dateQuotation;
    saleQuotationDetail.orderLines = orderLines;
    saleQuotationDetail.partner = partner;
    saleQuotationDetail.partner.partnerCategories = [];
    saleQuotationDetail.partner.categoryId = 0;
    saleQuotationDetail.companyId = saleQuotationDetail.company?.id;
    saleQuotationDetail.currencyId = saleQuotationDetail.currency?.id;

    if (partner != null) {
      saleQuotationDetail.partnerId = partner.id;
    }
    for (int i = 0; i < accountPaymentTerms.length; i++) {
      if (accountPaymentTerms[i].id.toString() == _selectAccountPaymentTerm &&
          _selectAccountPaymentTerm != "0") {
        saleQuotationDetail.paymentTerm = accountPaymentTerms[i];
        saleQuotationDetail.paymentTermId = accountPaymentTerms[i].id;
        break;
      }
    }
    if (_selectAccountPaymentTerm == "0") {
      saleQuotationDetail.paymentTerm = null;
      saleQuotationDetail.paymentTermId = null;
    }
//    saleQuotationDetail.state = ;
    saleQuotationDetail.user = applicationUser;
    if (applicationUser != null) {
      saleQuotationDetail.userId = applicationUser.id;
    }
    saleQuotationDetail.validityDate = _isChangeValidity
        ? validityDate.toUtc().toIso8601String()
        : _saleQuotationDetail?.validityDate;

    print(_isChangeDateQuotation
        ? dateQuotation.toUtc().toIso8601String()
        : _saleQuotationDetail?.dateQuotation);

    print(_isChangeValidity
        ? validityDate.toUtc().toIso8601String()
        : _saleQuotationDetail?.validityDate);

    if (isUpdate) {
      await updateQuotation();
    } else {
      await addQuotation();
    }

    if (isConfirm) {
      await markQuotation();
    }
    Navigator.pop(context, true);
  }

  void showNotify(String message) {
    _dialog.showNotify(title: S.current.notification, message: message);
  }

  void showDialogOpenFileExcel(
      {String content, BuildContext context, String path}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(S.current.notification),
          content: Text(content ?? ""),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text(
                S.current.close,
                style: const TextStyle(fontSize: 16),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                S.current.open,
                style: const TextStyle(fontSize: 16),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                if (path != null) {
                  OpenFile.open(path ?? "");
                }
              },
            ),
          ],
        );
      },
    );
  }

  void incrementQty(int index) {
    isChangeData = true;
    orderLines[index].productUOMQty++;
    notifyListeners();
  }

  void decrementQty(int index) {
    isChangeData = true;
    if (orderLines[index].productUOMQty > 0) {
      orderLines[index].productUOMQty--;
    }
    notifyListeners();
  }
}
