import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/application_user.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/cart_product.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/company.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/money_cart.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/partners.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/payment.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/point_sale.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/pos_config.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/pos_order.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/price_list.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/print_pos_data.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/promotion.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/state_cart.dart';
import 'package:tpos_mobile/feature_group/pos_order/services/pos_tpos_api.dart';
import 'package:tpos_mobile/feature_group/pos_order/sqlite_database/database_function.dart';
import 'package:tpos_mobile/feature_group/pos_order/sqlite_database/database_helper.dart';

import 'package:tpos_mobile/helpers/app_helper.dart';
import 'package:tpos_mobile/helpers/tpos_api_helper.dart';
import 'package:tpos_mobile/locator.dart';

import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/services/print_service.dart';


import 'package:flutter/services.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class PosCartViewModel extends ViewModelBase {
  PosCartViewModel({IPosTposApi tposApiService, DialogService dialogService}) {
    _tposApi = tposApiService ?? locator<IPosTposApi>();
    _dialog = dialogService ?? locator<DialogService>();
    _dbFunction = locator<IDatabaseFunction>();
    _printService = locator<PrintService>();
  }
  DialogService _dialog;
  IPosTposApi _tposApi;
  IDatabaseFunction _dbFunction;
  PrintService _printService;

  final dbHelper = DatabaseHelper.instance;

  Tax _tax;
  Partners _partner = Partners();

  List<StateCart> childCarts = [];
  List<Lines> _lstLine = [];
  List<Session> _sessions = [];
  List<CartProduct> _products = [];
  List<CartProduct> filterProducts = [];
  List<Partners> _partners = [];
  List<PriceList> _priceLists = [];
  List<AccountJournal> _accountJournals = [];
  List<Companies> _companies = [];
  List<Payment> lstpayment = [];
  List<Promotion> _promotions = [];
  final List<Payment> _payments = [];
  Payment payment = Payment();
  PrintPostData printPostData = PrintPostData();

  PosConfig _posConfig = PosConfig();
  MoneyCart moneyCart = MoneyCart();
  List<Tax> _pointSaleTaxs = [];
  int sttPositionCart = 0;
  int discountMethod = 0;
  double discountMoney = 0;
  double discountMoneyCK = 0;
  double discountMoneyCurrent = 0;
  bool isLoadingData = true;

  bool showReduceMoney = false;
  bool showReduceMoneyCk = true;
  bool showReduceMoneyOneInTwo = false; // false: chiết khấu, true: giảm tiền
  bool showReduceMoneyCKOneInTwo = true; // false: chiết khấu, true: giảm tiền
  String applicationUserID = "";
//  String _oldPosition = "0";
  int _countPayment = 0;
  String positionCart = "-1";
  String barcode = "";

  Tax get tax => _tax;
  set tax(Tax value) {
    _tax = value;
    notifyListeners();
  }

  PosConfig get posConfig => _posConfig;
  set posConfig(PosConfig value) {
    _posConfig = value;
    notifyListeners();
  }

  List<Tax> get pointSaleTaxs => _pointSaleTaxs;
  set pointSaleTaxs(List<Tax> value) {
    _pointSaleTaxs = value;
    notifyListeners();
  }

  int get countPayment => _countPayment;
  set countPayment(int value) {
    _countPayment = value;
    notifyListeners();
  }

  List<Lines> get lstLine => _lstLine;
  set lstLine(List<Lines> value) {
    _lstLine = value;
    notifyListeners();
  }

  List<Session> get sessions => _sessions;
  set sessions(List<Session> value) {
    _sessions = value;
    notifyListeners();
  }

  List<CartProduct> get products => _products;
  set products(List<CartProduct> value) {
    _products = value;
    notifyListeners();
  }

  List<Partners> get partners => _partners;
  set partners(List<Partners> value) {
    _partners = value;
    notifyListeners();
  }

  List<PriceList> get priceLists => _priceLists;
  set priceLists(List<PriceList> value) {
    _priceLists = value;
    notifyListeners();
  }

  Partners get partner => _partner;
  set partner(Partners value) {
    _partner = value;
    notifyListeners();
  }

  List<AccountJournal> get accountJournals => _accountJournals;
  set accountJournals(List<AccountJournal> value) {
    _accountJournals = value;
    notifyListeners();
  }

  List<Companies> get companies => _companies;
  set companies(List<Companies> value) {
    _companies = value;
    notifyListeners();
  }

  List<Promotion> get promotions => _promotions;
  set promotions(List<Promotion> value) {
    _promotions = value;
    notifyListeners();
  }

  Future<void> getSession(String userId) async {
    setState(true, message: "Load Session");
    try {
      final result = await _tposApi.getPosSession(userId);
      if (result != null) {
        sessions = result;
        sttPositionCart = result[0].sequenceNumber;

        /// Check Sessiom
        final List<Session> _sessions = await _dbFunction.querySessions();
        // get list cart
        childCarts = await _dbFunction.queryAllRowsCart();
        if (childCarts.isEmpty) {
          await addCartBegin();
        } else {
          if (result[0].id != _sessions[0].id) {
            await _dbFunction.deleteCart();
            await addCartBegin();
          } else {
            if (sttPositionCart <=
                int.parse(childCarts[childCarts.length - 1].position)) {
              sttPositionCart =
                  int.parse(childCarts[childCarts.length - 1].position) + 1;
            }
            updateCartPosition();
          }
        }

        // check session
        if (_sessions.isEmpty) {
          await addSession();
        } else {
          await _dbFunction.deleteSession();
          await addSession();
        }
      }
    } on SocketException catch (e, s) {
      logger.error("SocketException", e, s);
      childCarts = await _dbFunction.queryAllRowsCart();
      sessions = await _dbFunction.querySessions();

      // cập nhật lại vị trí cart
      if (childCarts.isNotEmpty) {
        sttPositionCart =
            int.parse(childCarts[childCarts.length - 1].position) + 1;
      }

      updateCartPosition();
      setState(false);
    } catch (e, s) {
      logger.error("loadSessionFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> getProducts() async {
    setState(true, message: "Load Products");
    try {
      final result = await _tposApi.getProducts();
      if (result != null) {
        products = result;
        filterProducts = result;
        final List<CartProduct> _lstProduct =
            await _dbFunction.queryProductAllRows();
        if (_lstProduct.isEmpty) {
          await addProduct();
        } else {
          await _dbFunction.deleteProduct();
          await addProduct();
        }
      }
    } on SocketException catch (e, s) {
      logger.error("SocketException", e, s);
      products = await _dbFunction.queryProductAllRows();
      filterProducts = products;
      setState(false);
    } catch (e, s) {
      logger.error("loadProductFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> getPartners() async {
    setState(true, message: "Load Partners");
    try {
      final result = await _tposApi.getPartners();
      if (result != null) {
        partners = result;
        final List<Partners> _lstPartner = await _dbFunction.queryGetPartners();
        if (_lstPartner.isEmpty) {
          await addPartner();
        } else {
          await _dbFunction.deletePartners();
          await addPartner();
        }
      }
    } on SocketException catch (e, s) {
      logger.error("SocketException", e, s);
      partners = await _dbFunction.queryGetPartners();
      setState(false);
    } catch (e, s) {
      logger.error("loadPartnerFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> getPriceLists() async {
    setState(true, message: "Load PriceLists");
    try {
      final result = await _tposApi.getPriceLists();
      if (result != null) {
        priceLists = result;
        final List<PriceList> _lstPrice =
            await _dbFunction.queryGetPriceLists();
        if (_lstPrice.isEmpty) {
          await addPriceList();
        } else {
          await _dbFunction.deletePriceList();
          await addPriceList();
        }
      }
    } on SocketException catch (e, s) {
      logger.error("SocketException", e, s);
      priceLists = await _dbFunction.queryGetPriceLists();
      setState(false);
    } catch (e, s) {
      logger.error("loadPriceListFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> getAccountJournal() async {
    setState(true, message: "Load Account Journal");
    try {
      final result = await _tposApi.getAccountJournals();
      if (result != null) {
        accountJournals = result;
        final List<AccountJournal> _lstAccountJournal =
            await _dbFunction.queryGetAccountJournals();
        if (_lstAccountJournal.isEmpty) {
          await addAccountJournal();
        } else {
          await _dbFunction.deleteAccountJournal();
          await addAccountJournal();
        }
      }
    } on SocketException catch (e, s) {
      logger.error("SocketException", e, s);
      accountJournals = await _dbFunction.queryGetAccountJournals();
      setState(false);
    } catch (e, s) {
      logger.error("loadAccountFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> getCompanies(int companyId) async {
    setState(true, message: "Load Companies");
    try {
      final result = await _tposApi.getCompanys(companyId);
      if (result != null) {
        companies = result;
        final List<Companies> _lstCompany = await _dbFunction.queryCompanys();
        if (_lstCompany.isEmpty) {
          await addCompany();
        } else {
          await _dbFunction.deleteCompany();
          await addCompany();
        }
      }
    } on SocketException catch (e, s) {
      logger.error("SocketException", e, s);
      companies = await _dbFunction.queryCompanys();
      setState(false);
    } catch (e, s) {
      logger.error("loadCompanyFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> getConfigForPos(int id) async {
    setState(true, message: "Load PosConfig");
    try {
      final result = await _tposApi.getPosConfigForPos(id);
      if (result != null) {
        posConfig = result[0];
        final List<PosConfig> _posConfigs =
            await _dbFunction.queryGetPosConfig();
        if (_posConfigs.isEmpty) {
          await _dbFunction.insertPosConfig(result[0]);
        } else if (_posConfigs.isNotEmpty) {
          await _dbFunction.deletePosconfig();
          await _dbFunction.insertPosConfig(result[0]);
        }

        final resUser = await _tposApi.applicationUsers(
            companyId: result[0].companyId,
            groupManagerId: result[0].groupPosManagerId,
            groupUserId: result[0].groupPosUserId);
        if (resUser != null) {
          applicationUserID = resUser[0].id;
          await _dbFunction.deleteApplicationUser();
          await _dbFunction.insertApplicationUser(resUser[0]);
        }
      }
    } on SocketException catch (e, s) {
      logger.error("SocketException", e, s);
      companies = await _dbFunction.queryCompanys();
      final List<PosConfig> _posConfigs = await _dbFunction.queryGetPosConfig();
      if (_posConfigs.isNotEmpty) {
        posConfig = _posConfigs[0];
      }
      final List<PosApplicationUser> _applicationUsers =
          await _dbFunction.queryGetApplication();
      if (_applicationUsers.isNotEmpty) {
        applicationUserID = _applicationUsers[0].id;
      }
      setState(false);
    } catch (e, s) {
      logger.error("loadConfigForPosFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> copyProductCart(Lines line) async {
    await _dbFunction.insertProductCart(line);
    await getProductsForCart();
  }

  Future<void> countInvoicePayment() async {
    setState(true);
    try {
      lstpayment = await _dbFunction.queryPayments();
      countPayment = lstpayment.length;
      setState(false);
    } catch (e, s) {
      logger.error("SocketException", e, s);
      setState(false);
    }
  }

  Future<void> handlePayment() async {
    setState(true);
    try {
      final result = await _tposApi.exePayment(lstpayment, false);
      if (result) {
        showNotifyPayment(S.current.posOfSale_paymentSuccessful);
        await _dbFunction.deletePayments();
      } else {
        _dialog.showError(error: result.toString());
      }
      setState(false);
    } on SocketException catch (e, s) {
      logger.error("SocketException", e, s);
//      payment.lines = null;
//      payment.statementIds = null;
//      var result = await _dbFuction.insertPayment(payment);
      setState(false);
    } catch (e, s) {
      logger.error("handlePaymentFail", e, s);
      _dialog.showError(error: e);
    }
  }

  Future<void> addCart(bool isLoadCarts) async {
    final DateTime datimeNow = DateTime.now();
    final String dateCreateCart =
        datimeNow.toIso8601String() + printDuration(datimeNow.timeZoneOffset);

    positionCart = sttPositionCart.toString();
    await _dbFunction.insertCart(StateCart(
        time: dateCreateCart,
        position: "$sttPositionCart",
        check: 1,
        loginNumber: _sessions[0].loginNumber));

    // Chỉ load lại khi thực hiện thêm giỏ hàng mới bằng cách nhấn button
    if (isLoadCarts) {
      await getCarts();
    }

    // Cập nhật lại các giỏ hàng cũ sẽ ko check và giỏ hàng mới sẽ đc check
    List<StateCart> _updateCarts = [];
    _updateCarts = childCarts;
    for (var i = 0; i < _updateCarts.length; i++) {
      if (_updateCarts[i].position != sttPositionCart.toString()) {
        _updateCarts[i].check = 0;
      }
      await _dbFunction.updateCart(_updateCarts[i]);
    }
    sttPositionCart++;
    getProductsForCart();
    //  notifyListeners();
  }

  Future<int> deleteCart(
      {StateCart cart, bool isDelete, bool checkInvoice}) async {
    int result = 0;
    String postion;
    if (cart != null) {
      postion = cart.position;
    } else {
      postion = positionCart;
    }
    if (childCarts.length > 1) {
      // kiểm tra và cập nhật lại quyền cho giỏ khác
      String newPositionAfterDelete;
      for (var i = 0; i < childCarts.length; i++) {
        if (childCarts[i].position == postion) {
          childCarts[i].check = 0;
          if (i == childCarts.length - 1) {
            //isDelete = false;
            StateCart updateCart = StateCart();
            updateCart = childCarts[i - 1];
            updateCart.check = 1;
            await _dbFunction.updateCart(updateCart);
            newPositionAfterDelete = updateCart.position;
          } else {
            StateCart updateCart = StateCart();
            updateCart = childCarts[i + 1];
            updateCart.check = 1;
            await _dbFunction.updateCart(updateCart);
            newPositionAfterDelete = updateCart.position;
          }
        }
      }

      // kiểm tra có phải là thanh toán rồi xóa hay ko(false: thực hiện thanh toán xong thêm cart, true: nhấn nút delete giỏ hàng chỉ xóa mà ko thêm card)
      if (!isDelete) {
        await addCart(
            false); // true false để xác nhận có load lại dũ liệu ngay khi thêm vào hay ko
      }

      result = await _dbFunction.deleteCartByPosition(postion);

      if (isDelete || !checkInvoice) {
        positionCart =
            postion; // Cập nhật vị trí giỏ bị xóa để xóa tất cả các sản phẩm trong giỏ đó
        // Xóa tất cả sản phẩm trong giỏ đã bị xóa
        getProductsForCart();
        for (var i = 0; i < lstLine.length; i++) {
          await _dbFunction.deleteProductCart(lstLine[i]);
        }
        // Cập nhật lại vị trí giỏ mới và lấy sản phẩm cho giỏ mới, isDelete == true: lấy lại vị trí khi nhấn nút thêm giỏ hàng, isDelte == false: Lấy lại vị trí sau khi thanh toán và thực hiện thêm giỏ hàng mới
        if (!isDelete) {
          positionCart = (sttPositionCart - 1)
              .toString(); // sttPCart : vị trí cart tăng dần đều mỗi khi thêm hoặc xóa
        } else {
          positionCart = newPositionAfterDelete.toString();
        }
        print(positionCart);
        getProductsForCart();
      }
    } else {
      result = 1;
      if (isDelete || !checkInvoice) {
        positionCart =
            postion; // Cập nhật vị trí giỏ bị xóa để xóa tất cả các sản phẩm trong giỏ đó
        // Xóa tất cả sản phẩm trong giỏ đã bị xóa
        await getProductsForCart();
        for (var i = 0; i < lstLine.length; i++) {
          await _dbFunction.deleteProductCart(lstLine[i]);
        }
      }
      await addCart(false);
      await _dbFunction.deleteCartByPosition(postion);
    }
    await getCarts(); // Lấy danh sách cart

    return result;
  }

  // isNotifyUpdate == true : khi cập nhật lại sản phẩm show Dialog, isNotifyUpdate == false : cập nhất tăng số lượng khi Press Cộng Trừ
  Future<void> updateProductCart(Lines line, bool isNotifyUpdate) async {
    final result = await _dbFunction.updateProductCart(line);
    if (isNotifyUpdate) {
      if (result == 1) {
        getProductsForCart();
        showNotifyUpdateProduct(S.current.posOfSale_inforUpdateSuccess);
      } else {
        showNotifyUpdateProduct(S.current.posOfSale_inforUpdateSuccess);
      }
    } else {
      if (result != 1) {
        showNotifyUpdateProduct(S.current.posOfSale_inforUpdateFail);
      }
    }
  }

  Future<bool> deleteProductCart(Lines line) async {
    bool isResult = true;
    final result = await _dbFunction.deleteProductCart(line);
    if (result == 1) {
      isResult = true;
    } else {
      isResult = false;
    }
    return isResult;
  }

  Future<void> configPos(int id) async {
    setState(true);
    try {
      await _tposApi.configPos(id);
    } on SocketException catch (e, s) {
      logger.error("SocketException", e, s);
      setState(false);
    } catch (e, s) {
      logger.error("handleConfigPosFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> getPromotions() async {
    setState(true);
    try {
      final result = await _tposApi.getPromotions(promotions);
      if (result != null) {
        promotions = result;
        // add promotion to Lines
        for (var i = 0; i < promotions.length; i++) {
          final List<Lines> promotionLines = await _dbFunction
              .queryGetProductWithID(positionCart, promotions[i].productId);
          if (promotionLines.isEmpty) {
            if (promotions[i].productId != 0) {
              await insertProductPromotion(promotions[i]);
            }
          } else if (promotionLines[0].isPromotion &&
              promotionLines[0].promotionProgramId !=
                  promotions[i].promotionProgramId) {
            final Lines line = Lines();
            line.discount = promotionLines[0].discount;
            line.discountType = "percent";
            line.note = promotionLines[0].note;
            line.priceUnit = promotionLines[0].priceUnit;
            line.productId = promotionLines[0].productId;
            line.qty = promotions[i].qty + promotionLines[0].qty;
            line.uomId = promotions[i - 1].uOMId;
            line.isPromotion = promotionLines[0].isPromotion;
            line.promotionProgramId = promotionLines[0].promotionProgramId;
            line.tb_cart_position = positionCart;
            line.productName = promotionLines[0].productName;
            line.id = promotionLines[0].id;

            await _dbFunction.updateProductCart(line);
          } else if (promotionLines[0].isPromotion &&
              promotionLines.length == 1 &&
              promotionLines[0].promotionProgramId ==
                  promotions[i].promotionProgramId) {
            await _dbFunction.deleteProductCart(promotionLines[0]);
            await insertProductPromotion(promotions[i]);
          }
        }
        await getProductsForCart();
      }
    } catch (e, s) {
      logger.error("loadPromotionFail", e, s);
      _dialog.showError(error: e);
    }
    setState(false);
  }

  Future<void> getPointSaleTaxs() async {
    setState(true, message: "Load Tax");
    try {
      final result = await _tposApi.getPointSaleTaxs();
      if (result != null) {
        pointSaleTaxs = result;
        final List<Tax> _taxs = await _dbFunction.queryGetTaxs();
        if (_taxs.isEmpty) {
          for (var i = 0; i < pointSaleTaxs.length; i++) {
            await _dbFunction.insertPointSaleTax(pointSaleTaxs[i]);
          }
        } else {
          await _dbFunction.deletePointSaleTaxs();
          for (var i = 0; i < pointSaleTaxs.length; i++) {
            await _dbFunction.insertPointSaleTax(pointSaleTaxs[i]);
          }
        }
      }
    } on SocketException catch (e, s) {
      logger.error("SocketException", e, s);
      pointSaleTaxs = await _dbFunction.queryGetTaxs();
      setState(false);
    } catch (e, s) {
      logger.error("handleTaxFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> filterPrice(List<dynamic> filterPrices) async {
    for (var i = 0; i < filterPrices.length; i++) {
      for (var j = 0; j < filterProducts.length; j++) {
        if (filterPrices[i].key ==
            (filterProducts[j].id.toString() +
                "_" +
                filterProducts[j].factor.floor().toString())) {
          filterProducts[j].price = filterPrices[i].value;
          break;
        }
      }
    }
  }

  Future<void> getPriceList() async {
    setState(true, message: "Load Price List");
    try {
      final result = await _tposApi.exeListPrice("${posConfig.priceListId}");
      await filterPrice(result);
      if (result != null) {
        final _values = await _dbFunction.queryGetProductPriceList();
        if (_values.isEmpty) {
          for (var i = 0; i < result.length; i++) {
            await _dbFunction.insertProductPriceList(result[i]);
          }
        } else {
          await _dbFunction.deleteProductPriceList();
          for (var i = 0; i < result.length; i++) {
            await _dbFunction.insertProductPriceList(result[i]);
          }
        }
      }
      setState(false);
    } on SocketException catch (e, s) {
      logger.error("SocketException", e, s);
      final _values = await _dbFunction.queryGetProductPriceList();
      await filterPrice(_values);
      setState(false);
    } catch (e, s) {
      logger.error("get price list Fail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> getMoneyCart(
      String position, bool isSave, bool isNoDeleteCart) async {
    try {
      List<MoneyCart> moneyCarts = [];
      moneyCarts = await _dbFunction.queryGetMoneyCartPosition(position);
      if (moneyCarts.isNotEmpty) {
        if (isSave) {
          await _dbFunction.updateMoneyCart(moneyCart);
        } else {
          discountMethod = moneyCarts[0]
              .discountMethod; // == 0: chiết khấu  , == 1 : giảm tiền ,  == -1: cả 2 đều không
          print(discountMethod);
          if (discountMethod == 0) {
            showReduceMoneyCk = true;
            showReduceMoney = false;
            discountMoneyCK = moneyCarts[0].discount;
          } else if (discountMethod == 1) {
            showReduceMoney = true;
            showReduceMoneyCk = false;
            discountMoney = moneyCarts[0].discount;
          } else {
            showReduceMoneyCk = false;
            showReduceMoney = false;
            discountMoneyCK = 0;
            discountMoney = 0;
          }
          discountMoneyCurrent = moneyCarts[0].discount;
          final partners = await _dbFunction
              .queryGetPartnersById(moneyCarts[0].partnerId ?? 0);
          if (partners.isNotEmpty) {
            partner = partners[0];
          } else {
            partner = Partners();
          }
          final taxs = await _dbFunction
              .queryGetTaxById(moneyCarts[0].taxId ?? posConfig.taxId ?? -1);
          if (taxs.isNotEmpty) {
            tax = taxs[0];
          } else {
            tax = null;
          }
        }
      } else {
        if (isSave) {
          await _dbFunction.insertCartMoney(moneyCart);
        } else {
          partner = Partners();
          final taxs = await _dbFunction.queryGetTaxById(posConfig.taxId ?? -1);
          print(taxs.length);
          if (taxs.isNotEmpty) {
            tax = taxs[0];
          } else {
            tax = null;
          }
          // cập nhật hiển thị button giảm tiền và chiết khấu
          if (isNoDeleteCart) {
            if (posConfig.ifaceDiscount == false &&
                posConfig.ifaceDiscountFixed) {
              showReduceMoneyOneInTwo = true;
              showReduceMoneyCKOneInTwo = false;
              showReduceMoney = true;
            } else if (posConfig.ifaceDiscount &&
                posConfig.ifaceDiscountFixed == null) {
              showReduceMoneyCKOneInTwo = true;
              showReduceMoneyOneInTwo = false;
              showReduceMoneyCk = true;
            }
          }

          if (showReduceMoney) {
            discountMoney = 0;
          } else if (showReduceMoneyCk) {
            discountMoneyCK = posConfig.discountPc ?? 0;
          } else {
            discountMoneyCK = 0;
            discountMoney = 0;
          }
        }
      }
      notifyListeners();
    } catch (e) {
      _dialog.showError(title: S.current.notification, content: e.toString());
    }
  }

  Future<void> updateInfoMoneyCart(String disCount, bool isSave,
      {bool isNoDeleteCart = false}) async {
    if (isSave) {
      if (showReduceMoney) {
        moneyCart.discountMethod = 1;
      } else if (showReduceMoneyCk) {
        moneyCart.discountMethod = 0;
      } else {
        moneyCart.discountMethod = -1;
      }
      moneyCart.discount =
          double.parse(disCount == "" ? "0" : disCount.replaceAll(".", ""));

      moneyCart.position = positionCart;
      moneyCart.partnerId = partner?.id;
      moneyCart.taxId = tax?.id;
      moneyCart.amountTax = tax?.amount ?? 0;
    }
    await getMoneyCart(positionCart, isSave, isNoDeleteCart);
  }

  Future<void> deleteMoneyCart() async {
    await _dbFunction.deleteMoneyCartByPosition(positionCart);
  }

  Future<void> getTaxById() async {
    try {
      final List<Tax> _taxs =
          await _dbFunction.queryGetTaxById(posConfig.taxId);
      if (_taxs.isNotEmpty) {
        tax = _taxs[0];
      }
    } catch (e, s) {
      logger.error("SocketException", e, s);
    }
  }

  Future<void> barcodeScanning() async {
    final ScanBarcodeResult scanBarcodeResult = await scanBarcode();
    barcode = scanBarcodeResult.result;
  }

  // Method for scanning barcode....
  Future barcodeScanningProduct() async {
    try {
      final result = await BarcodeScanner.scan();
      barcode = result.rawContent;
      updateInfoBarcode(barcode);
      await insertProduct();
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        updateInfoBarcode("No camera permission!");
      } else {
        updateInfoBarcode("Unknown error: $e");
      }
    } on FormatException {
      updateInfoBarcode("UNothing captured.");
    } catch (e) {
      updateInfoBarcode("Unknown error: $e'");
    }
  }

  Future<void> insertProduct() async {
    setState(true);
    for (var i = 0; i < products.length; i++) {
      print(barcode);
      if (products[i].barcode == barcode) {
        final Lines line = Lines();
        line.discount = 0;
        line.discountType = "percent";
        line.note = "";
        line.priceUnit = products[i].price;
        line.productId = products[i].id;
        line.qty = products[i].qty;
        line.uomId = 1;
        line.productName = products[i].nameGet;
        line.tb_cart_position = positionCart;
        line.uomName = products[i].uOMName;
        line.image = products[i].imageUrl;
        final List<Lines> lstProduct = await _dbFunction.queryGetProductWithID(
            positionCart, products[i].id);
        if (lstProduct.isEmpty) {
          await _dbFunction.insertProductCart(line);
        } else {
          bool checkSameMoney = false;
          int positionUpdate = 0;
          for (var j = 0; j < lstProduct.length; j++) {
            if (lstProduct[j].priceUnit == line.priceUnit) {
              checkSameMoney = true;
              positionUpdate = j;
            }
          }
          if (checkSameMoney) {
            line.id = lstProduct[positionUpdate].id;
            line.qty = line.qty + lstProduct[positionUpdate].qty;
            await _dbFunction.updateProductCart(line);
          } else {
            await _dbFunction.insertProductCart(line);
          }
        }
      }
    }
    setState(false);
  }

  void updateInfoBarcode(String valueBarCode) {
    barcode = valueBarCode;

    notifyListeners();
  }

  Future<void> insertProductPromotion(Promotion promotion) async {
    final Lines line = Lines();
    line.discount = promotion.discount;
    line.discountType = "percent";
    line.note = promotion.notice;
    line.priceUnit = promotion.priceUnit;
    line.productId = promotion.productId;
    line.qty = promotion.qty;
    line.uomId = promotion.uOMId;
    line.isPromotion = promotion.isPromotion;
    line.promotionProgramId = promotion.promotionProgramId;
    line.tb_cart_position = positionCart;
    line.productName = promotion.productNameGet;

    await _dbFunction.insertProductCart(line);
  }

  Future<void> handleCheckCart(int index) async {
    positionCart = childCarts[index].position;
    for (var i = 0; i < childCarts.length; i++) {
      if (i == index) {
        childCarts[i].check = 1;
      } else {
        childCarts[i].check = 0;
      }
      await _dbFunction.updateCart(childCarts[i]);
    }
    getProductsForCart();
    notifyListeners();
  }

  Future<void> addCartBegin() async {
//    String dateCreateCart = convertDatetimeToString(DateTime.now());
    final DateTime datimeNow = DateTime.now();
    final String dateCreateCart =
        datimeNow.toIso8601String() + printDuration(datimeNow.timeZoneOffset);

    final id = await _dbFunction.insertCart(StateCart(
        position: "$sttPositionCart",
        check: 1,
        time: dateCreateCart,
        loginNumber: _sessions[0].loginNumber));

    positionCart = "$sttPositionCart";
    childCarts = await _dbFunction.queryAllRowsCart();
    sttPositionCart++;
  }

  Future<void> addProduct() async {
    for (var i = 0; i < _products.length; i++) {
      await _dbFunction.insertProduct(_products[i]);
    }
  }

  Future<void> addPartner() async {
    for (var i = 0; i < partners.length; i++) {
      await _dbFunction.insertPartner(partners[i]);
    }
  }

  Future<void> addPriceList() async {
    for (var i = 0; i < _priceLists.length; i++) {
      await _dbFunction.insertPriceList(_priceLists[i]);
    }
  }

  Future<void> addAccountJournal() async {
    for (var i = 0; i < _accountJournals.length; i++) {
      await _dbFunction.insertAccountJournals(_accountJournals[i]);
    }
  }

  Future<void> addSession() async {
    await _dbFunction.insertSession(sessions[0]);
  }

  Future<void> addCompany() async {
    await _dbFunction.insertCompany(companies[0]);
  }

  Future<void> getCarts() async {
    childCarts.clear();
    childCarts = await _dbFunction.queryAllRowsCart();
    notifyListeners();
  }

  Future<void> updateSession() async {
    await _dbFunction.updateSession(sessions[0]);
  }

  Future<void> getProductsForCart() async {
    setState(true);
    final List<Lines> lines =
        await _dbFunction.queryGetProductsForCart(positionCart);
    lstLine = lines;
    setState(false);
  }

  void updateCartPosition() {
//    String dateCreateCart = convertDatetimeToString(DateTime.now());
    final DateTime datimeNow = DateTime.now();
    final String dateCreateCart =
        datimeNow.toIso8601String() + printDuration(datimeNow.timeZoneOffset);
    for (var i = 0; i < childCarts.length; i++) {
      // Cập nhật giỏ hàng được chọn
      if (childCarts[i].check == 1) {
        positionCart = childCarts[i].position;
      }

      // Cập nhật lại thời gian tao cho giỏ hàng
      childCarts[i].time = dateCreateCart;

      _dbFunction.updateCart(childCarts[i]);
    }
    getProductsForCart();
  }

  double cartAmountTotal() {
    double amountTotal = 0;
    for (var i = 0; i < _lstLine.length; i++) {
      amountTotal += lstLine[i].qty *
          lstLine[i].priceUnit *
          (1 - lstLine[i].discount / 100);
    }

    return amountTotal;
  }

  void removeProduct(Lines item) {
    lstLine.remove(item);
    notifyListeners();
  }

  Future<void> excPayment() async {
    // update Lines

    await countInvoicePayment();
    for (var i = 0; i < lstpayment.length; i++) {
      final List<Lines> _lines = await _dbFunction
          .queryGetProductsForCart(lstpayment[i].sequenceNumber.toString());

      // cập nhật và add số sản phẩm cho giỏ hàng
      for (var i = 0; i < _lines.length; i++) {
        _lines[i].productName = null;
        _lines[i].tb_cart_position = null;
        _lines[i].isPromotion = null;
        _lines[i].image = null;
        _lines[i].uomName = null;
      }
      lstpayment[i].lines = _lines;

      // update StatementIds

      final List<StatementIds> statementIds = await _dbFunction
          .queryStatementIds(lstpayment[i].sequenceNumber.toString());
      print(statementIds.length);
      for (var i = 0; i < statementIds.length; i++) {
        statementIds[i].position = null;
      }
      lstpayment[i].statementIds = statementIds;
      print(json.encode(lstpayment[i].toJson()));
    }

    await handlePayment();
    await countInvoicePayment();
    notifyListeners();
  }

  void handlePromotion() {
    if (lstLine.isNotEmpty) {
      final List<Promotion> lstPromotion = [];
      for (var i = 0; i < lstLine.length; i++) {
        final Promotion promotion = Promotion();
        promotion.discount = lstLine[i].discount;
        promotion.discountType = lstLine[i].discountType;
        promotion.discountFixed =
            lstLine[i].priceUnit * lstLine[i].qty * lstLine[i].discount / 100;
        promotion.name = lstLine[i].productName;
        promotion.priceUnit = lstLine[i].priceUnit;
        promotion.productId = lstLine[i].productId;
        promotion.productNameGet = lstLine[i].productName;
        promotion.qty = lstLine[i].qty;
        promotion.uOMId = lstLine[i].uomId;
        promotion.isPromotion = lstLine[i].isPromotion;
        lstPromotion.add(promotion);
      }
      promotions = lstPromotion;

      getPromotions();
    }
  }

  void updateDiscountMoneyCurrent(String value) {
    if (value == "") {
      value = "0";
    }
    discountMoneyCurrent = double.parse(value.replaceAll(".", ""));
    notifyListeners();
  }

  void incrementQty(int index) {
    lstLine[index].qty++;
    updateProductCart(lstLine[index], false);
    notifyListeners();
  }

  void decrementQty(int index) {
    lstLine[index].qty--;

    updateProductCart(lstLine[index], false);
    notifyListeners();
  }

  void saveConfirmPrint() {}

  void changeReduceMoney() {
    showReduceMoney = !showReduceMoney;
    showReduceMoneyCKOneInTwo = false;
    showReduceMoneyOneInTwo = true;
    if (showReduceMoney) {
      showReduceMoneyCk = false;
    }
    notifyListeners();
  }

  Future<void> changeReduceMoneyCK() async {
    showReduceMoneyCk = !showReduceMoneyCk;
    showReduceMoneyCKOneInTwo = true;
    showReduceMoneyOneInTwo = false;
    if (showReduceMoneyCk) {
      showReduceMoney = false;
    } else {
      List<MoneyCart> moneyCarts = [];
      moneyCarts = await _dbFunction.queryGetMoneyCartPosition(positionCart);
      if (moneyCarts.isEmpty) {
        discountMoneyCK = posConfig.discountPc ?? 0;
      }
    }
    notifyListeners();
  }

  double amountTotalReduceMoney() {
    double amountTotal = 0;
    if (cartAmountTotal() > 0) {
      if (discountMoneyCurrent >= cartAmountTotal()) {
        discountMoneyCurrent = cartAmountTotal();
      }
      amountTotal = cartAmountTotal() - discountMoneyCurrent;
    } else if (cartAmountTotal() == 0) {
      amountTotal = 0;
    } else {
      amountTotal = cartAmountTotal() - discountMoneyCurrent;
    }
    if (tax != null) {
      amountTotal += ((tax.amount / 100) * amountTotal).roundToDouble();
    }

//    if (amountTotal < 0) {
//      amountTotal = 0;
//    }
    return amountTotal;
  }

  double amountTotalReduceMoneyCK() {
    if (discountMoneyCurrent >= 100) {
      discountMoneyCurrent = 100;
    } else if (discountMoneyCurrent <= 0) {
      discountMoneyCurrent = 0;
    }
    double amountTotal = (cartAmountTotal() -
            ((discountMoneyCurrent / 100) * cartAmountTotal()).roundToDouble())
        .roundToDouble();

    if (tax != null) {
      amountTotal += ((tax.amount / 100) * amountTotal).roundToDouble();
    }

//    if (amountTotal < 0) {
//      amountTotal = 0;
//    }
    return amountTotal;
  }

  // HANDLE PRINT
  Future<bool> addInfoPayment({BuildContext context, String userId}) async {
    _payments.clear();

    final List<StateCart> _carts =
        await _dbFunction.queryCartByPosition(positionCart);
    List<Partners> _partners = [];
    if (partner?.id != null) {
      _partners = await _dbFunction.queryGetPartnersById(partner?.id);
    }
    final List<PosApplicationUser> _applicationUsers =
        await _dbFunction.queryGetApplicationUserById(applicationUserID);
    final List<PosConfig> _posConfigs = await _dbFunction.queryGetPosConfig();

    //

    payment.statementIds = [];

    final StatementIds statementId = StatementIds();
    statementId.amount = showReduceMoney
        ? amountTotalReduceMoney().roundToDouble()
        : amountTotalReduceMoneyCK().roundToDouble();
    statementId.journalId = accountJournals[0].id;
    statementId.statementId = _sessions[0].id;
    statementId.accountId = _companies[0].transferAccountId;
    statementId.name = _carts[0].time;
    payment.statementIds.add(statementId);

    //
    // cập nhật và add số sản phẩm cho giỏ hàng
    for (var i = 0; i < lstLine.length; i++) {
      lstLine[i].productName = null;
      lstLine[i].tb_cart_position = null;
      lstLine[i].isPromotion = null;
      lstLine[i].image = null;
      lstLine[i].uomName = null;
    }

    payment.lines = lstLine;
    // tính tổng số tiền khách đã trả

    payment.amountPaid = showReduceMoney
        ? amountTotalReduceMoney().roundToDouble()
        : amountTotalReduceMoneyCK().roundToDouble();

    payment.amountReturn = 0;
    payment.amountTax = showReduceMoney
        ? handleTaxPaymentMoney().roundToDouble()
        : handleTaxPaymentMoneyCK().roundToDouble();
    payment.amountTotal = showReduceMoney
        ? (amountTotalReduceMoney() - handleTaxPaymentMoney()).roundToDouble()
        : (amountTotalReduceMoneyCK() - handleTaxPaymentMoneyCK())
            .roundToDouble();

    payment.customerCount = 1;
    if (discountMethod == 0) {
      payment.discountType = "percentage";
      payment.discount = discountMoneyCurrent;
      payment.discountFixed = 0;
    } else if (discountMethod == 1) {
      payment.discountType = "amount_fixed";
      payment.discountFixed = discountMoneyCurrent;
      payment.discount = 0;
    } else {
      payment.discountType = "percentage";
      payment.discount = 0;
      payment.discountFixed = 0;
    }

    //payment.discountType = "";
    payment.loyaltyPoints = 0;
    //payment.name;
    payment.posSessionId = _sessions[0].id;
    payment.sequenceNumber = int.parse(positionCart);
    payment.spentPoints = 0;
    payment.totalPoints = 0;
    payment.wonPoints = 0;
    payment.partnerId = partner?.id;
    payment.userId = userId;
    payment.creationDate = _carts[0].time;
    payment.uid =
        "${limitNumber(_sessions[0].id.toString(), 5)}-${limitNumber(_carts[0].loginNumber.toString(), 3)}-${limitNumber(_carts[0].position, 4)}";
    payment.name =
        "ĐH ${limitNumber(_sessions[0].id.toString(), 5)}-${limitNumber(_carts[0].loginNumber.toString(), 3)}-${limitNumber(_carts[0].position, 4)}";
    payment.taxId = tax?.id;
    _payments.add(payment);

    // Xử lý add thông tin check hóa đơn
    final List<InvoicePayment> invoicePayments = [];
    final InvoicePayment invoicePayment = InvoicePayment();
    invoicePayment.isCheck = 0;
    invoicePayment.sequence = positionCart;
    invoicePayments.add(invoicePayment);

    // Xử lý add thông tin để in hóa đơn
    printPostData.companyName = _companies[0].name;
    printPostData.companyId = _companies[0].id;
    printPostData.imageLogo = _companies[0].imageUrl;
    printPostData.companyPhone = _companies[0].phone;
    printPostData.companyAddress = _companies[0].street;
    if (_partners.isNotEmpty) {
      printPostData.partnerName = _partners[0].name;
      printPostData.partnerPhone = _partners[0].phone;
      printPostData.partnerAddress = _partners[0].street;
    }
    printPostData.dateSale = _carts[0].time;
    printPostData.employee = _applicationUsers[0].name;
    printPostData.amountTotal = payment.amountTotal;
    printPostData.amountPaid = payment.amountPaid;
    printPostData.amountReturn = payment.amountReturn;
    printPostData.namePayment = payment.name;
    printPostData.amountTax = payment.amountTax;

    if (discountMethod == 0) {
      printPostData.discount = discountMoneyCurrent;
      printPostData.discountCash = 0;
      printPostData.amountDiscount =
          (cartAmountTotal() * (discountMoneyCurrent / 100)).roundToDouble();
//      print((cartAmountTotal() * (discountMoneyCurrent / 100)).toString() +
//          " amountDiscount");
    } else if (discountMethod == 1) {
      printPostData.discountCash = discountMoneyCurrent;
      printPostData.discount = 0;
    } else {
      printPostData.discount = 0;
      printPostData.discountCash = 0;
    }

    printPostData.tax = tax?.amount ?? 0;
    printPostData.amountBeforeTax = showReduceMoney
        ? (amountTotalReduceMoney() - handleTaxPaymentMoney()).roundToDouble()
        : (amountTotalReduceMoneyCK() - handleTaxPaymentMoneyCK())
            .roundToDouble();
//    print((showReduceMoney
//                ? amountTotalReduceMoney() - handleTaxPaymentMoney()
//                : amountTotalReduceMoneyCK() - handleTaxPaymentMoneyCK())
//            .toString() +
//        " amountBeforeTax");

    // Xử lý add thông tin để in hóa đơn
    printPostData.lines =
        await _dbFunction.queryGetProductsForCart(positionCart);

    // Xét header và footer khi in
    if (_posConfigs[0].isHeaderOrFooter) {
      printPostData.header = _posConfigs[0].receiptHeader ?? "";
      printPostData.footer = _posConfigs[0].receiptFooter ?? "";
    }

    printPostData.isHeaderOrFooter = _posConfigs[0].isHeaderOrFooter;
    printPostData.isLogo = _posConfigs[0].ifaceLogo;

    final bool result = await handlePaymentPrint(
        context, _carts[0], _posConfigs[0].ifacePrintAuto);

    return result;
  }

  Future<bool> handlePaymentPrint(
      BuildContext context, StateCart cart, bool autoPrint) async {
    setState(true);
    var result = false;
    try {
      result = await _tposApi.exePayment(_payments, false);
      if (result) {
        showNotifyPayment(S.current.posOfSale_paymentSuccessful);
        await _dbFunction.deleteMoneyCartByPosition(positionCart);
        if (autoPrint) {
          try {
            await _printService.printPos80mm(printPostData);
          } catch (e) {
            _dialog.showError(
                title: S.current.printError, content: e.toString());
          }
        }
        await deleteCart(cart: cart, isDelete: false, checkInvoice: false);
        await countInvoicePayment();
      } else {
        showNotifyPayment(S.current.posOfSale_paymentFailed);
      }
      setState(false);
    } on SocketException catch (e, s) {
      logger.error("SocketException", e, s);
      if (!result) {
        await _dbFunction.deleteMoneyCartByPosition(positionCart);
        await savePaymentSqlite(context, cart);
      }
      result = true;
      setState(false);
    } catch (e, s) {
      logger.error("handlePaymentFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
    return result;
  }

  Future<void> savePaymentSqlite(BuildContext context, StateCart cart) async {
    for (var i = 0; i < payment.statementIds.length; i++) {
      payment.statementIds[i].position = payment.sequenceNumber.toString();
      await _dbFunction.insertStatementIds(payment.statementIds[i]);
    }
    payment.lines = null;
    payment.statementIds = null;
    await _dbFunction.insertPayment(payment);
    await deleteCart(cart: cart, isDelete: false, checkInvoice: true);
    await countInvoicePayment();
  }

  double handleTaxPaymentMoney() {
    double amountTax = 0;
    if (cartAmountTotal() > 0) {
      if (discountMoneyCurrent >= cartAmountTotal()) {
        discountMoneyCurrent = cartAmountTotal();
      }
      amountTax = cartAmountTotal() - discountMoneyCurrent;
    } else if (cartAmountTotal() == 0) {
      amountTax = 0;
    } else {
      amountTax = cartAmountTotal() - discountMoneyCurrent;
    }
    if (tax != null) {
      amountTax = (tax.amount / 100) * amountTax;
    }

    return amountTax;
  }

  double handleTaxPaymentMoneyCK() {
    if (discountMoneyCurrent >= 100) {
      discountMoneyCurrent = 100;
    } else if (discountMoneyCurrent <= 0) {
      discountMoneyCurrent = 0;
    }
    double amountTax =
        cartAmountTotal() - (discountMoneyCurrent / 100) * cartAmountTotal();
    if (tax != null) {
      amountTax = (tax.amount / 100) * amountTax;
    }
//    if (amountTotal < 0) {
//      amountTotal = 0;
//    }
    return amountTax;
  }

  String limitNumber(String number, int limit) {
    String res = number;
    if (number.length < limit) {
      final int count = limit - number.length;
      for (var i = 0; i < count; i++) {
        res = "0" + res;
      }
    }
    return res;
  }

  void showNotifyUpdateProduct(String message) {
    _dialog.showNotify(title: S.current.notification, message: message);
  }

  void showNotifyDeleteProduct() {
    _dialog.showNotify(
        title: S.current.notification,
        message: S.current.posOfSale_deleteProduct);
  }

  void showNotifyPayment(String message) {
    _dialog.showNotify(title: S.current.notification, message: message);
  }
}
