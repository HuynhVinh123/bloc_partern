import 'dart:convert';
import 'package:dio/dio.dart' as dio_lib;
import 'package:http/http.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/account/account_result.dart';
import 'package:tpos_mobile/feature_group/account_payment_sale/models/base_model.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/account_bank.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/accountbank_line.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/application_user.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/cart_product.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/company.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/invoice.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/invoice_product.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/key.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/partners.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/payment.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/point_sale.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/pos_config.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/pos_make_payment.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/price_list.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/promotion.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/res_currency.dart';
import 'package:tpos_mobile/feature_group/sale_online/services/service.dart';
import 'package:tpos_mobile/feature_group/sale_online/services/tpos_api_service.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/src/tpos_apis/models/account_payment.dart';

import 'package:tpos_mobile/src/tpos_apis/models/partner_contact.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_service_base.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_helper_download.dart';

import '../models/pos_order.dart';

abstract class IPosTposApi {
  // get Session
  Future<List<Session>> getPosSession(String userId);

  // get Point Sales
  Future<List<PointSale>> getPointSales();

  // get Price List
  Future<List<PriceList>> getPriceLists();

  // check Create Session
  Future<String> checkCreateSessionSale(int configId);

  // get Company
  Future<List<Companies>> getCompanys(int companyId);

  // get ResCurreies
  Future<List<ResCurrency>> getResCurreies();

  // get Partner
  Future<List<Partners>> getPartners();

  // get Account journal
  Future<List<AccountJournal>> getAccountJournals();

  // get Product
  Future<List<CartProduct>> getProducts();

  // update Partner
  Future<Partners> updatePartner(Partners partner);

  // excute Payment
  Future<bool> exePayment(List<Payment> payments, bool isCheckInvoice);

  // fiiter price list product
  Future<List<dynamic>> exeListPrice(String id);

  // get promotion
  Future<List<Promotion>> getPromotions(List<Promotion> promotions);

  //config data offline
  Future<void> configPos(int id);

  //get pos config _ search for pos
  Future<List<PosConfig>> getPosConfigForPos(int id);

  // get application user
  Future<List<PosApplicationUser>> applicationUsers(
      {int companyId, int groupManagerId, int groupUserId});

  // get Info point sale
  Future<PointSale> getInfoPointSale(int id);

  // get Picking type (Setting point sale)
  Future<List<PickingType>> getPickingTypes();

  // get stockLocation (Setting point sale)
  Future<List<StockLocation>> getStockLocation();

  // get price List (Setting  point sale)
  Future<List<PriceList>> getPriceListPointSale();

  // get account tax
  Future<List<Tax>> getAccountTaxs();

  // update setting point sale
  Future<bool> updateConfigPointSale(PointSale pointSale);

  // get tax for Point sale
  Future<List<Tax>> getPointSaleTaxs();

  // get phương thức thanh toán (Config point sale)
  Future<List<PosMakePaymentJournal>> getAccountJournalsPointSale();

  // get invoice
  Future<List<Invoice>> getInvoicesPointSale(int id);

  // get detail invoice
  Future<PosOrder> getDetailInvoice(int id);

  // get product invoice print
  Future<List<InvoiceProduct>> getProductInvoicePrint(int id);

  // get product to return invoice
  Future<List<InvoiceProduct>> getProductInvoiceReturn(int id);

  /// Xử lý đóng phiên
  // get data
  Future<Session> getSessionById(int id);

  // close
  Future<bool> closeSession(int id);

  // get account bank
  Future<List<AccountBank>> getAccountBank(int id);

  // get account bank invoice
  Future<AccountBank> getAccountBankDetailInvoice(int id);

  // get account bank line
  Future<List<AccountBankLine>> getAccountBankLine(int id);

  // get Session id to close
  Future<String> getPosconfigCbClose(int id);

  // Xử lý mở phiên
  Future<bool> handleActionPosOpen(String id);

  // Lấy dạnh sách phiếu thu
  Future<BaseModel> getAccountPayments(
      {String keySearch,
      List<String> filterStatus,
      String fromDate,
      String toDate,
      int accountId,
      int take,
      int skip});

  // get accounts
  Future<List<Account>> getAccounts({String keySearch});

  // get accounts
  Future<List<Account>> getTypeAccounts({String keySearch});

  // get info accountPayment
  Future<AccountPayment> getInfoAccountPayment(int id);

  // get accountJournal with AccountPayment
  Future<List<AccountJournal>> getAccountJournalWithAccountPayments();

  // get list contact for acount payment
  Future<List<Partner>> getContactPartners(String keySearch);

  // get  contact default
  Future<PartnerContact> getContactDefault();

  //add contact partner
  Future<PartnerContact> addContactPartner(PartnerContact partner);

  // update accountPayment
  Future<void> updateAccountPayment(AccountPayment accountPayment);

  // add accountPayment
  Future<AccountPayment> addAccountPayment(AccountPayment accountPayment);

  //get Default accountPayment
  Future<AccountPayment> getDefaultAccountPayment();

  // cancel accountPayment
  Future<void> cancelAccountPayment(int id);

  // confirm accountPayment
  Future<void> confirmAccountPayment(int id);

  // Delete accountPayment
  Future<void> deleteAccountPayment(int id);

  // Lấy dạnh sách phiếu chi
  Future<BaseModel> getAccountPaymentSales(
      {String keySearch,
      List<String> filterStatus,
      String fromDate,
      String toDate,
      int accountId,
      int take,
      int skip});

  // get accounts cho phiếu chi
  Future<List<Account>> getAccountSales({String keySearch});

  // get type accounts cho phiếu chi
  Future<List<Account>> getTypeAccountSales({String keySearch});

  //get Default accountPaymentSale
  Future<AccountPayment> getDefaultAccountPaymentSale();

  // get danh sách loại phiếu chi
  Future<AccountResult> getTypeAccountAccountSales(
      {int page, int pageSize, int skip, int take, int companyId});

  // get danh sách loại phiếu thu
  Future<AccountResult> getTypeAccountAccounts(
      {int page, int pageSize, int skip, int take, int companyId});

  // delete danh sách loại phiếu chi
  Future<bool> deleteTypeAccountAccountSale(int id);

  // get detail thông tin loại phiếu chi
  Future<Account> getDetailAccountSale(int id);
  // get default thông tin loại phiếu chi
  Future<Account> getDefaultAccountSale();

  // get default thông tin loại phiếu thu
  Future<Account> getDefaultAccount();

  // Cập nhật thông tin loại phiếu chi
  Future<bool> updateInfoTypeAccountSale(Account account);
  // thêm thông tin loại phiếu chi
  Future<Account> addInfoTypeAccountSale(Account account);

  // Lây danh sách công ty cho loại phiếu chi
  Future<List<Company>> getCompanies(String keySearch);

  /// Xuất excel phiếu thu
  Future<String> exportExcelAccountPayment({
    String fromDate,
    String toDate,
    String keySearch,
    List<String> filterStatus,
  });

  /// Xuất excel phiếu chi
  Future<String> exportExcelAccountPaymentSale({
    String fromDate,
    String toDate,
    String keySearch,
    List<String> filterStatus,
  });
}

class PosTposApi extends ApiServiceBase implements IPosTposApi {
  @override
  Future<List<Session>> getPosSession(String userId) async {
    final List<Session> _sessions = [];

    final String body = json.encode({
      "model": {"State": "opened", "UserId": userId}
    });
    final response = await apiClient.httpPost(
        path: '/odata/POS_Session/ODataService.Search', body: body);

    if (response.statusCode == 200) {
      for (final session in json.decode(response.body)["value"]) {
        _sessions.add(Session.fromJson(session));
      }

      // var list = (map["items"] as List).map((f) => Labo.fromJson(f)).toList();
      return _sessions;
    }
//    throwHttpException(response);
    return null;
  }

  @override
  Future<List<PointSale>> getPointSales() async {
    final List<PointSale> _pointSales = [];

    final response = await apiClient.httpGet(
        path: "/odata/POS_Config/ODataService.SearchReadKanban");
    if (response.statusCode == 200) {
      for (final pointSale in json.decode(response.body)["value"]) {
        _pointSales.add(PointSale.fromJson(pointSale));
      }
      return _pointSales;
    }
//    throwHttpException(response);
    return null;
  }

  @override
  Future<List<PriceList>> getPriceLists() async {
    final List<PriceList> _priceLists = [];

    final response = await apiClient.httpGet(path: "/odata/Product_PriceList");
    if (response.statusCode == 200) {
      for (final pointSale in json.decode(response.body)["value"]) {
        _priceLists.add(PriceList.fromJson(pointSale));
      }
      return _priceLists;
    }
//    throwHttpException(response);
    return null;
  }

  @override
  Future<String> checkCreateSessionSale(int configId) async {
    final String body = json.encode({"configId": configId});

    final response = await apiClient.httpPost(
        path: "/odata/POS_Config/ODataService.OpenSessionCb", body: body);
    if (response.statusCode.toString().startsWith("2")) {
      final map = json.decode(response.body);
      return map["value"];
    }
    return null;
  }

  @override
  Future<List<Companies>> getCompanys(int companyId) async {
    final List<Companies> _companys = [];

    final String body = json.encode({
      "ids": [companyId]
    });

    final response = await apiClient.httpPost(
        path: "/odata/Company/ODataService.SearchForPos", body: body);

    if (response.statusCode == 200) {
      for (final company in json.decode(response.body)["value"]) {
        _companys.add(Companies.fromJson(company));
      }
      return _companys;
    }
//    throwHttpException(response);
    return null;
  }

  @override
  Future<List<ResCurrency>> getResCurreies() async {
    final List<ResCurrency> _resCurrencies = [];
    final String body = json.encode({
      "model": {
        "Ids": [1]
      }
    });

    final response = await apiClient.httpPost(
        path: "/odata/ResCurrency/ODataService.Search", body: body);
    if (response.statusCode == 200) {
      for (final company in json.decode(response.body)["value"]) {
        _resCurrencies.add(ResCurrency.fromJson(company));
      }
      return _resCurrencies;
    }
//    throwHttpException(response);
    return null;
  }

  @override
  Future<List<Partners>> getPartners() async {
    final List<Partners> _partners = [];
    final response = await apiClient.httpGet(
        path: "/odata/Partner/ODataService.SearchForPos");

    if (response.statusCode == 200) {
      for (final company in json.decode(response.body)["value"]) {
        _partners.add(Partners.fromJson(company));
      }
      return _partners;
    }
//    throwHttpException(response);
    return null;
  }

  @override
  Future<List<AccountJournal>> getAccountJournals() async {
    final List<AccountJournal> accountJournals = [];

    final response = await apiClient.httpGet(
        path: "/odata/AccountJournal?\$filter=(Id+eq+1)&\$select=Id,Type,Name");
    if (response.statusCode == 200) {
      for (final company in json.decode(response.body)["value"]) {
        accountJournals.add(AccountJournal.fromJson(company));
      }
      return accountJournals;
    }
//    throwHttpException(response);
    return null;
  }

  @override
  Future<List<CartProduct>> getProducts() async {
    final List<CartProduct> _products = [];

    final response = await apiClient.httpGet(
        path:
            "/odata/ProductTemplateUOMLine/ODataService.GetLastVersionV2?\$expand=Datas&countIndexDB=0&Version=-1");

    if (response.statusCode == 200) {
      for (final product in json.decode(response.body)["Datas"]) {
        _products.add(CartProduct.fromJson(product));
      }
      return _products;
    }
//    throwHttpException(response);
    return null;
  }

  @override
  Future<Partners> updatePartner(Partners partner) async {
    final String body = json.encode({"model": partner.toJson()});
    final response = await apiClient.httpPost(
        path: "/odata/Partner/ODataService.CreateUpdateFromUI", body: body);
    if (response.statusCode == 200) {
      return Partners.fromJson(json.decode(response.body));
    }
//    throwHttpException(response);
    return null;
  }

  @override
  Future<bool> exePayment(List<Payment> payments, bool isCheckInvoice) async {
    final String body = json.encode({
      "models": payments
          .map((val) => {
                "id": val.uid,
                "data": val.toJson(),
                "to_invoice": isCheckInvoice
              })
          .toList()
    });

    final response = await apiClient.httpPost(
        path: "/odata/POS_Order/ODataService.CreateFromUI", body: body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<List<dynamic>> exeListPrice(String id) async {
    var keys = [];
    final response =
        await apiClient.httpGet(path: "/api/common/getpricelistitems?id=$id");

    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      keys = res.keys.map((val) => Key(key: val, value: res[val])).toList();
    }

    return keys;
  }

  @override
  Future<List<Promotion>> getPromotions(List<Promotion> promotions) async {
    List<Promotion> _promotions = [];
    final String body =
        json.encode({"model": promotions.map((val) => val.toJson()).toList()});

    final response = await apiClient.httpPost(
        path: "/odata/POS_Order/ODataService.ApplyPromotion", body: body);

    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      _promotions =
          (map["value"] as List).map((val) => Promotion.fromJson(val)).toList();
      return _promotions;
    }
    // var list = (map["items"] as List).map((f) => Labo.fromJson(f)).toList();
//    throwHttpException(response);
    return null;
  }

  @override
  Future<void> configPos(int id) async {
    final String body = json.encode({"configId": id});
    final response = await apiClient.httpPost(
        path: "/odata/POS_Config/ODataService.OpenUI", body: body);
    if (response.statusCode == 204) {
      return;
    }
//    throwHttpException(response);
  }

  @override
  Future<List<PosConfig>> getPosConfigForPos(int id) async {
    List<PosConfig> posConfigs = [];
    final String body = json.encode({"id": id});
    final response = await apiClient.httpPost(
        path: "/odata/POS_Config/ODataService.SearchForPos", body: body);
    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      posConfigs =
          (map["value"] as List).map((val) => PosConfig.fromJson(val)).toList();
      return posConfigs;
    }
//    throwHttpException(response);
    return null;
  }

  @override
  Future<List<PosApplicationUser>> applicationUsers(
      {int companyId, int groupManagerId, int groupUserId}) async {
    List<PosApplicationUser> _applicationUsers = [];

    final String body = json.encode({
      "model": {
        "CompanyId": companyId,
        "GroupManagerId": groupManagerId,
        "GroupUserId": groupUserId
      }
    });
    final response = await apiClient.httpPost(
        path:
            "/odata/ApplicationUser/ODataService.SearchForPos?\$expand=Groups",
        body: body);
    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      _applicationUsers = (map["value"] as List)
          .map((val) => PosApplicationUser.fromJson(val))
          .toList();
      return _applicationUsers;
    }
//    throwHttpException(response);
    return null;
  }

  @override
  Future<PointSale> getInfoPointSale(int id) async {
    final response = await apiClient.httpGet(
        path:
            "/odata/POS_Config($id)?\$expand=PickingType,Printers,StockLocation,Journal,InvoiceJournal,PriceList,Journals,Loyalty,Tax,Promotions,Vouchers");
    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      return PointSale.fromJson(map);
    }
//    throwHttpException(response);
    return null;
  }

  @override
  Future<List<PickingType>> getPickingTypes() async {
    List<PickingType> _pickingTypes = [];
    final response = await apiClient.httpGet(
        path: "/odata/StockPickingType?%24format=json&%24count=true");

    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      _pickingTypes = (map["value"] as List).map((value) {
        return PickingType.fromJson(value);
      }).toList();
      return _pickingTypes;
    }
//    throwHttpException(response);
    return null;
  }

  @override
  Future<List<StockLocation>> getStockLocation() async {
    List<StockLocation> _stockLocations = [];
    final response = await apiClient.httpGet(
        path:
            "/odata/StockLocation?\$orderby=ParentLeft&%24format=json&%24filter=Usage+eq+%27internal%27&%24count=true");

    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      _stockLocations = (map["value"] as List).map((value) {
        return StockLocation.fromJson(value);
      }).toList();
      return _stockLocations;
    }
//    throwHttpException(response);
    return null;
  }

  @override
  Future<List<PriceList>> getPriceListPointSale() async {
    List<PriceList> _priceLists = [];
    final response = await apiClient.httpGet(
        path: "/odata/Product_PriceList?%24format=json&%24count=true");

    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      _priceLists = (map["value"] as List).map((value) {
        return PriceList.fromJson(value);
      }).toList();
      return _priceLists;
    }
//    throwHttpException(response);
    return null;
  }

  @override
  Future<List<Tax>> getAccountTaxs() async {
    List<Tax> _accountTaxs = [];

    final response = await apiClient.httpGet(
        path:
            "/odata/AccountTax/ODataService.GetWithCompany?%24format=json&%24filter=TypeTaxUse+eq+%27sale%27&%24count=true");

    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      _accountTaxs =
          (map["value"] as List).map((value) => Tax.fromJson(value)).toList();
      return _accountTaxs;
    }
//    throwHttpException(response);
    return null;
  }

  @override
  Future<bool> updateConfigPointSale(PointSale pointSale) async {
    if (pointSale.priceList != null) {}

    final String body = json.encode(pointSale.toJson());
    final response = await apiClient.httpPut(
        path: "/odata/POS_Config(${pointSale.id})", body: body);

    if (response.statusCode == 204) {
      return true;
    }

    return false;
  }

  @override
  Future<List<Tax>> getPointSaleTaxs() async {
    List<Tax> _taxs = [];

    final response = await apiClient.httpGet(
        path: "/odata/AccountTax/ODataService.GetWithCompany");

    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      _taxs =
          (map["value"] as List).map((value) => Tax.fromJson(value)).toList();
      return _taxs;
    }
//    throwHttpException(response);
    return null;
  }

  @override
  Future<List<PosMakePaymentJournal>> getAccountJournalsPointSale() async {
    List<PosMakePaymentJournal> _accountJournals = [];

    final response = await apiClient.httpGet(
        path:
            "/odata/AccountJournal/ODataService.GetWithCompany?%24format=json&%24filter=(JournalUser+eq+true+and+(Type+eq+%27bank%27+or+Type+eq+%27cash%27))&%24count=true");

    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      _accountJournals = (map["value"] as List)
          .map((value) => PosMakePaymentJournal.fromJson(value))
          .toList();
      return _accountJournals;
    }
//    throwHttpException(response);
    return null;
  }

  @override
  Future<bool> closeSession(int id) async {
    final String body = json.encode({"id": id});
    final response = await apiClient.httpPost(
        path: "/odata/POS_Session/ODataService.ActionPosSessionClosingControl",
        body: body);
    if (response.statusCode == 204) {
      return true;
    }
    throwHttpException(response);
    return false;
  }

  @override
  Future<List<Invoice>> getInvoicesPointSale(int id) async {
    List<Invoice> _invoices = [];
    final response =
        await apiClient.httpGet(path: "/api/common/getorderbysession?id=$id");
    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      _invoices =
          (map as List).map((value) => Invoice.fromJson(value)).toList();
      return _invoices;
    }

    return null;
  }

  @override
  Future<bool> handleActionPosOpen(String id) async {
    bool result = false;
    final String body = json.encode({"id": int.parse(id)});
    final response = await apiClient.httpPost(
        path: "/odata/POS_Session/ODataService.ActionPosSessionOpen",
        body: body);
    if (response.statusCode == 204) {
      result = true;
    } else {
      result = false;
    }
    return result;
  }

  @override
  Future<Session> getSessionById(int id) async {
    final response = await apiClient.httpGet(
        path: "/odata/POS_Session($id)?\$expand=User,Config");

    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      return Session.fromJson(map);
    }
    throwHttpException(response);
    return null;
  }

  @override
  Future<List<AccountBank>> getAccountBank(int id) async {
    List<AccountBank> _accountBanks = [];
    final response = await apiClient.httpGet(
        path:
            "/odata/AccountBankStatement?\$expand=Journal&\$filter=PosSessionId+eq+$id");

    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      _accountBanks = (map["value"] as List)
          .map((value) => AccountBank.fromJson(value))
          .toList();
      return _accountBanks;
    }
    throwHttpException(response);
    return null;
  }

  @override
  Future<String> getPosconfigCbClose(int id) async {
    final String body = json.encode({"configId": id});
    final response = await apiClient.httpPost(
        path: "/odata/POS_Config/ODataService.OpenExistingSessionCbClose",
        body: body);
    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      return map["value"];
    }
    throwHttpException(response);
    return null;
  }

  @override
  Future<PosOrder> getDetailInvoice(int id) async {
    final response = await apiClient.httpGet(
        path:
            "/odata/POS_Order($id)?\$expand=Partner,Table,Session,User,PriceList,Tax");
    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      return PosOrder.fromJson(map);
    }
    throwHttpException(response);
    return null;
  }

  @override
  Future<List<InvoiceProduct>> getProductInvoicePrint(int id) async {
    List<InvoiceProduct> _invoiceProducts = [];
    final response = await apiClient.httpGet(
        path: "/odata/POS_Order($id)/Lines?\$expand=Product,UOM");
    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      _invoiceProducts = (map["value"] as List)
          .map((value) => InvoiceProduct.fromJson(value))
          .toList();
      return _invoiceProducts;
    }
    throwHttpException(response);
    return null;
  }

  @override
  Future<List<InvoiceProduct>> getProductInvoiceReturn(int id) {
    return null;
  }

  @override
  Future<List<AccountBankLine>> getAccountBankLine(int id) async {
    List<AccountBankLine> _accountBankLines = [];
    final response = await apiClient.httpGet(
        path: "/odata/AccountBankStatementLine?\$filter=StatementId+eq+$id");

    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      _accountBankLines = (map["value"] as List)
          .map((value) => AccountBankLine.fromJson(value))
          .toList();
      return _accountBankLines;
    }
    throwHttpException(response);
    return null;
  }

  @override
  Future<AccountBank> getAccountBankDetailInvoice(int id) async {
    final response = await apiClient.httpGet(
        path: "/odata/AccountBankStatement($id)?\$expand=Journal");

    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      return AccountBank.fromJson(map);
    }
    throwHttpException(response);
    return null;
  }

  @override
  Future<BaseModel> getAccountPayments(
      {String keySearch = "",
      List<String> filterStatus,
      String fromDate,
      String toDate,
      int accountId,
      int take,
      int skip}) async {
    List<AccountPayment> accountPayments = [];

    const String path = "/odata/AccountPayment";

    final Map<String, dynamic> boby = {
      "\$format": "json",
      "\$top": take,
      "\$skip": skip,
      "\$orderby": "PaymentDate desc,Name desc",
      "\$count": "true",
    };

    if (filterStatus.isEmpty &&
        (keySearch == "" || keySearch == null) &&
        (fromDate == "" && toDate == "") &&
        accountId == null) {
    } else {
      boby["\$filter"] =
          "(${keySearch != null && keySearch != "" ? "(contains(SenderReceiver,'$keySearch') or contains(Name,'$keySearch') or contains(AccountName,'$keySearch') or contains(Communication,'$keySearch')) and " : ""}(AccountId ne null and PaymentType eq 'inbound' ${accountId != null ? "and AccountId eq $accountId" : ""}) ${fromDate != "" && toDate != "" ? "and (PaymentDate ge $fromDate and PaymentDate le $toDate)" : ""})";

      if (filterStatus.isNotEmpty) {
        if (filterStatus.length == 1) {
          boby["\$filter"] =
              "(${keySearch != null && keySearch != "" ? "(contains(SenderReceiver,'$keySearch') or contains(Name,'$keySearch') or contains(AccountName,'$keySearch') or contains(Communication,'$keySearch')) and" : ""}(AccountId ne null and PaymentType eq 'inbound' ${accountId != null ? "and AccountId eq $accountId" : ""}) and (State eq '${filterStatus[0]}') ${fromDate != "" && toDate != "" ? "and (PaymentDate ge $fromDate and PaymentDate le $toDate)" : ""})";
        } else {
          boby["\$filter"] =
              "(${keySearch != null && keySearch != "" ? "(contains(SenderReceiver,'$keySearch') or contains(Name,'$keySearch') or contains(AccountName,'$keySearch') or contains(Communication,'$keySearch')) and" : ""}(AccountId ne null and PaymentType eq 'inbound' ${accountId != null ? "and AccountId eq $accountId" : ""}) and (State eq '${filterStatus[0]}' or State eq '${filterStatus[1]}') ${fromDate != "" && toDate != "" ? "and (PaymentDate ge $fromDate and PaymentDate le $toDate)" : ""})";
        }
      }
    }

    final ISettingService _setting = locator<ISettingService>();
    final dio_lib.BaseOptions options = dio_lib.BaseOptions(
        baseUrl: _setting.shopUrl,
        connectTimeout: 5000,
        receiveTimeout: 3000,
        headers: {
          "Authorization": 'Bearer ${_setting.shopAccessToken}',
        },
        contentType: "application/json");

    final dio_lib.Dio dio = dio_lib.Dio(options);

    final dio_lib.Response<Map<String, dynamic>> response =
        await dio.get(path, queryParameters: boby);
    if (response.statusCode == 200) {
      accountPayments = (response.data['value'] as List)
          .map((value) => AccountPayment.fromJson(value))
          .toList();
      final BaseModel baseModel = BaseModel(
          result: accountPayments, totalItems: response.data['@odata.count']);
      return baseModel;
    }
    return null;
  }

  @override
  Future<List<Account>> getAccounts({String keySearch}) async {
    List<Account> accounts = [];
    String path =
        "/odata/Account?\$filter=InternalType%20eq%20%27thu%27&\$orderby=Name&%24format=json&%24count=true";

    if (keySearch != null && keySearch != "") {
      path =
          "/odata/Account?\$filter=InternalType%20eq%20%27thu%27&\$orderby=Name&%24format=json&%24filter=contains(tolower(Name)%2C%27$keySearch%27)&%24count=true";
    }

    final response = await apiClient.httpGet(path: path);

    if (response.statusCode == 200) {
      if (response.body != "") {
        final map = json.decode(response.body);
        accounts = (map["value"] as List)
            .map((value) => Account.fromJson(value))
            .toList();
      }
      return accounts;
    }
    throwHttpException(response);
    return null;
  }

  @override
  Future<AccountPayment> getInfoAccountPayment(int id) async {
    final response = await apiClient.httpGet(
        path:
            "/odata/AccountPayment($id)?\$expand=Partner,Journal,Account,Currency,Contact");

    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      return AccountPayment.fromJson(map);
    }
    throwHttpException(response);
    return null;
  }

  @override
  Future<List<AccountJournal>> getAccountJournalWithAccountPayments() async {
    List<AccountJournal> accountJournals = [];
    const String path =
        "/odata/AccountJournal/ODataService.GetWithCompany?%24format=json&%24filter=(Type+eq+%27bank%27+or+Type+eq+%27cash%27)&%24count=true";

//    if (keySearch != null && keySearch != "") {
//      path =
//      "/odata/Account?\$filter=InternalType%20eq%20%27thu%27&\$orderby=Name&%24format=json&%24filter=contains(tolower(Name)%2C%27$keySearch%27)&%24count=true";
//    }

    final response = await apiClient.httpGet(path: path);

    if (response.statusCode == 200) {
      if (response.body != "") {
        final map = json.decode(response.body);
        accountJournals = (map["value"] as List)
            .map((value) => AccountJournal.fromJson(value))
            .toList();
      }
      return accountJournals;
    }
    throwHttpException(response);
    return null;
  }

  @override
  Future<List<Partner>> getContactPartners(String keySearch) async {
    List<Partner> partners = [];
    String path =
        "/odata/Partner/ODataService.GetContact?%24format=json&%24count=true";

    if (keySearch != null && keySearch != "") {
      path =
          "/odata/Partner/ODataService.GetContact?%24format=json&%24filter=(contains(NameNoSign%2C%27$keySearch%27)+or+contains(DisplayName%2C%27a%27)+or+contains(Phone%2C%27$keySearch%27))&%24count=true";
    }

    final response = await apiClient.httpGet(path: path);

    if (response.statusCode == 200) {
      if (response.body != "") {
        final map = json.decode(response.body);
        partners = (map["value"] as List)
            .map((value) => Partner.fromJson(value))
            .toList();
      }
      return partners;
    }
    throwHttpException(response);
    return null;
  }

  @override
  Future<PartnerContact> getContactDefault() async {
    final response = await apiClient.httpPost(
        path:
            "/odata/Partner/ODataService.DefaultGet?\$expand=AccountPayable,AccountReceivable,StockCustomer,StockSupplier");

    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      return PartnerContact.fromJson(map);
    }
    throwHttpException(response);
    return null;
  }

  @override
  Future<PartnerContact> addContactPartner(PartnerContact partner) async {
    final String body = json.encode(partner.toJson());
    final response =
        await apiClient.httpPost(path: "/odata/Partner", body: body);
    if (response.statusCode == 201) {
      return PartnerContact.fromJson(json.decode(response.body));
    }
    throwHttpException(response);
    return null;
  }

  @override
  Future<void> updateAccountPayment(AccountPayment accountPayment) async {
    try {
      final String body = json.encode(accountPayment.toJson());
      await apiClient.httpPut(
          path: "/odata/AccountPayment(${accountPayment.id})", body: body);
    } catch (e) {
      throwHttpException(e);
    }
  }

  @override
  Future<AccountPayment> addAccountPayment(
      AccountPayment accountPayment) async {
    final String body = json.encode(accountPayment.toJson());
    final Response response =
        await apiClient.httpPost(path: "/odata/AccountPayment", body: body);
    if (response.statusCode == 201) {
      final map = json.decode(response.body);
      return AccountPayment.fromJson(map);
    }
    throwHttpException(response);
    return null;
  }

  @override
  Future<AccountPayment> getDefaultAccountPayment() async {
    const String body = "{\"model\":{\"PaymentType\":\"inbound\"}}";

    final response = await apiClient.httpPost(
        path:
            "/odata/AccountPayment/ODataService.DefaultGetCreate?\$expand=Currency,Journal",
        body: body);

    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      return AccountPayment.fromJson(map);
    }
    throwHttpException(response);
    return null;
  }

  @override
  Future<void> cancelAccountPayment(int id) async {
    final String body = "{\"id\":$id}";
    final response = await apiClient.httpPost(
        path: "/odata/AccountPayment/ODataService.ActionCancel", body: body);
    if (response.statusCode != 204) {
      throwHttpException(response);
    }
  }

  @override
  Future<void> confirmAccountPayment(int id) async {
    final String body = "{\"id\":$id}";
    final response = await apiClient.httpPost(
        path: "/odata/AccountPayment/ODataService.ActionPost", body: body);
    if (response.statusCode != 204) {
      throwHttpException(response);
    }
  }

  @override
  Future<void> deleteAccountPayment(int id) async {
    final response =
        await apiClient.httpDelete(path: "/odata/AccountPayment($id)");
    if (response.statusCode != 204) {
      throwHttpException(response);
    }
  }

  @override
  Future<BaseModel> getAccountPaymentSales(
      {String keySearch,
      List<String> filterStatus,
      String fromDate,
      String toDate,
      int accountId,
      int take,
      int skip}) async {
    List<AccountPayment> accountPayments = [];
    const String path = "/odata/AccountPayment/ODataService.GetChi";

    final Map<String, dynamic> boby = {
      "\$format": "json",
      "\$top": take,
      "\$skip": skip,
      "\$orderby": "PaymentDate desc,Name desc",
      "\$count": "true",
    };

    if (filterStatus.isEmpty &&
        (keySearch == "" || keySearch == null) &&
        (fromDate == "" && toDate == "") &&
        accountId == null) {
    } else {
      boby["\$filter"] =
          "(${keySearch != null && keySearch != "" ? "(contains(SenderReceiver,'$keySearch') or contains(Name,'$keySearch') or contains(AccountName,'$keySearch') or contains(Communication,'$keySearch')) and " : ""}(AccountId ne null and PaymentType eq 'outbound' ${accountId != null ? "and AccountId eq $accountId" : ""}) ${fromDate != "" && toDate != "" ? "and (PaymentDate ge $fromDate and PaymentDate le $toDate)" : ""})";

      if (filterStatus.isNotEmpty) {
        if (filterStatus.length == 1) {
          boby["\$filter"] =
              "(${keySearch != null && keySearch != "" ? "(contains(SenderReceiver,'$keySearch') or contains(Name,'$keySearch') or contains(AccountName,'$keySearch') or contains(Communication,'$keySearch')) and" : ""}(AccountId ne null and PaymentType eq 'outbound' ${accountId != null ? "and AccountId eq $accountId" : ""}) and (State eq '${filterStatus[0]}') ${fromDate != "" && toDate != "" ? "and (PaymentDate ge $fromDate and PaymentDate le $toDate)" : ""})";
        } else {
          boby["\$filter"] =
              "(${keySearch != null && keySearch != "" ? "(contains(SenderReceiver,'$keySearch') or contains(Name,'$keySearch') or contains(AccountName,'$keySearch') or contains(Communication,'$keySearch')) and" : ""}(AccountId ne null and PaymentType eq 'outbound' ${accountId != null ? "and AccountId eq $accountId" : ""}) and (State eq '${filterStatus[0]}' or State eq '${filterStatus[1]}') ${fromDate != "" && toDate != "" ? "and (PaymentDate ge $fromDate and PaymentDate le $toDate)" : ""})";
        }
      }
    }

    final ISettingService _setting = locator<ISettingService>();
    final dio_lib.BaseOptions options = dio_lib.BaseOptions(
        baseUrl: _setting.shopUrl,
        connectTimeout: 5000,
        receiveTimeout: 3000,
        headers: {
          'Authorization': 'Bearer ${_setting.shopAccessToken}',
        },
        contentType: 'application/json');

    final dio = dio_lib.Dio(options);

    final response = await dio.get(path, queryParameters: boby);
    if (response.statusCode == 200) {
      accountPayments = (response.data['value'] as List)
          .map((value) => AccountPayment.fromJson(value))
          .toList();

      print(response.data['@odata.count']);

      final BaseModel baseModel = BaseModel(
          result: accountPayments, totalItems: response.data['@odata.count']);

      return baseModel;
    }
    return null;
  }

  @override
  Future<List<Account>> getAccountSales({String keySearch}) async {
    List<Account> accounts = [];
    String path =
        "/odata/Account?\$filter=InternalType%20eq%20%27chi%27%20and%20Code%20ne%20%27CHANGE%27&\$orderby=Name&%24format=json&%24count=true";

    if (keySearch != null && keySearch != "") {
      path =
          "/odata/Account?\$filter=InternalType%20eq%20%27chi%27%20and%20Code%20ne%20%27CHANGE%27&\$orderby=Name&%24format=json&%24filter=contains(tolower(Name)%2C%27$keySearch%27)&%24count=true";
    }

    final response = await apiClient.httpGet(path: path);

    if (response.statusCode == 200) {
      if (response.body != "") {
        final map = json.decode(response.body);
        accounts = (map["value"] as List)
            .map((value) => Account.fromJson(value))
            .toList();
      }
      return accounts;
    }
    throwHttpException(response);
    return null;
  }

  @override
  Future<AccountPayment> getDefaultAccountPaymentSale() async {
    const String body = "{\"model\":{\"PaymentType\":\"outbound\"}}";

    final response = await apiClient.httpPost(
        path:
            "/odata/AccountPayment/ODataService.DefaultGetCreate?\$expand=Currency,Journal",
        body: body);

    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      return AccountPayment.fromJson(map);
    }
    throwHttpException(response);
    return null;
  }

  @override
  Future<List<Account>> getTypeAccounts({String keySearch}) async {
    List<Account> accounts = [];
    String path =
        "/odata/Account/ODataService.GetWithCompany?%24format=json&%24top=10&%24filter=InternalType+eq+%27thu%27&%24count=true";

    if (keySearch != null && keySearch != "") {
      path =
          "/odata/Account/ODataService.GetWithCompany?%24format=json&%24top=10&%24filter=(contains(tolower(NameGet)%2C%27$keySearch%27)+and+InternalType+eq+%27thu%27)&%24count=true";
    }

    final response = await apiClient.httpGet(path: path);

    if (response.statusCode == 200) {
      if (response.body != "") {
        final map = json.decode(response.body);
        accounts = (map["value"] as List)
            .map((value) => Account.fromJson(value))
            .toList();
      }
      return accounts;
    }
    throwHttpException(response);
    return null;
  }

  @override
  Future<List<Account>> getTypeAccountSales({String keySearch}) async {
    List<Account> accounts = [];
    String path =
        "/odata/Account/ODataService.GetWithCompany?%24format=json&%24top=10&%24filter=InternalType+eq+%27chi%27&%24count=true";

    if (keySearch != null && keySearch != "") {
      path =
          "/odata/Account/ODataService.GetWithCompany?%24format=json&%24top=10&%24filter=(contains(tolower(NameGet)%2C%27$keySearch%27)+and+InternalType+eq+%27chi%27)&%24count=true";
    }

    final response = await apiClient.httpGet(path: path);

    if (response.statusCode == 200) {
      if (response.body != "") {
        final map = json.decode(response.body);
        accounts = (map["value"] as List)
            .map((value) => Account.fromJson(value))
            .toList();
      }
      return accounts;
    }
    throwHttpException(response);
    return null;
  }

  @override
  Future<AccountResult> getTypeAccountAccountSales(
      {int page, int pageSize, int skip, int take, int companyId}) async {
    List<Account> accounts = [];
    const String path = "/AccountAccount/List";
    final Map<String, dynamic> body = {
      "take": take,
      "skip": skip,
      "page": page,
      "pageSize": pageSize,
      "filter": {
        "logic": "and",
        "filters": [
          {"field": "InternalType", "operator": "eq", "value": "chi"}
        ]
      }
    };

    if (companyId != null) {
      body["filter"]["filters"] = [
        {"field": "InternalType", "operator": "eq", "value": "chi"},
        {"field": "CompanyId", "operator": "eq", "value": companyId}
      ];
    }

    final response =
        await apiClient.httpPost(path: path, body: json.encode(body));

    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      if (response.body != "") {
        accounts = (map["Data"] as List)
            .map((value) => Account.fromJson(value))
            .toList();
      }
      final AccountResult accountResult =
          AccountResult(result: accounts, totalItems: map["Total"]);

      return accountResult;
    }
    throwHttpException(response);
    return null;
  }

  @override
  Future<bool> deleteTypeAccountAccountSale(int id) async {
    final result = await apiClient.httpDelete(path: "/odata/Account($id)");
    if (result.statusCode == 204) {
      return true;
    }
    throwHttpException(result);
    return false;
  }

  @override
  Future<Account> getDetailAccountSale(int id) async {
    final response = await apiClient.httpGet(
        path: "/odata/Account($id)?\$expand=Company,UserType");
    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      return Account.fromJson(map);
    }
    throwHttpException(response);
    return null;
  }

  @override
  Future<Account> getDefaultAccountSale() async {
    final response = await apiClient.httpGet(
        path:
            "/odata/Account/ODataService.DefaultGetThuChi?\$expand=Company&type=chi");
    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      return Account.fromJson(map);
    }
    throwHttpException(response);
    return null;
  }

  @override
  Future<bool> updateInfoTypeAccountSale(Account account) async {
    try {
      final String body = json.encode(account.toJson());
      final response = await apiClient.httpPut(
          path: "/odata/Account(${account.id})", body: body);
      if (response.statusCode == 204) {
        return true;
      }
      return false;
    } catch (e) {
      throwHttpException(e);
    }
    return false;
  }

  @override
  Future<Account> addInfoTypeAccountSale(Account account) async {
    final String body = json.encode(account.toJson());
    final response =
        await apiClient.httpPost(path: "/odata/Account", body: body);
    if (response.statusCode == 201) {
      final map = json.decode(response.body);
      final Account account = Account.fromJson(map);
      return account;
    }
    throwHttpException(response);
    return null;
  }

  @override
  Future<List<Company>> getCompanies(String keySearch) async {
    List<Company> companies = [];
    String path = "/odata/Company?%24format=json&%24count=true";

    if (keySearch != null && keySearch != "") {
      path =
          "/odata/Company?%24format=json&%24filter=contains(tolower(Name)%2C%27$keySearch%27)&%24count=true";
    }

    final response = await apiClient.httpGet(path: path);

    if (response.statusCode == 200) {
      if (response.body != "") {
        final map = json.decode(response.body);
        companies = (map["value"] as List)
            .map((value) => Company.fromJson(value))
            .toList();
      }
      return companies;
    }
    throwHttpException(response);
    return null;
  }

  @override
  Future<AccountResult> getTypeAccountAccounts(
      {int page, int pageSize, int skip, int take, int companyId}) async {
    List<Account> accounts = [];
    const String path = "/AccountAccount/List";
    final Map<String, dynamic> body = {
      "take": take,
      "skip": skip,
      "page": page,
      "pageSize": pageSize,
      "filter": {
        "logic": "and",
        "filters": [
          {"field": "InternalType", "operator": "eq", "value": "thu"}
        ]
      }
    };

    if (companyId != null) {
      body["filter"]["filters"] = [
        {"field": "InternalType", "operator": "eq", "value": "thu"},
        {"field": "CompanyId", "operator": "eq", "value": companyId}
      ];
    }

    final response =
        await apiClient.httpPost(path: path, body: json.encode(body));

    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      if (response.body != "") {
        accounts = (map["Data"] as List)
            .map((value) => Account.fromJson(value))
            .toList();
      }
      final AccountResult accountResult =
          AccountResult(result: accounts, totalItems: map["Total"]);
      return accountResult;
    }
    throwHttpException(response);
    return null;
  }

  @override
  Future<Account> getDefaultAccount() async {
    final response = await apiClient.httpGet(
        path:
            "/odata/Account/ODataService.DefaultGetThuChi?\$expand=Company&type=thu");
    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      return Account.fromJson(map);
    }
    throwHttpException(response);
    return null;
  }

  @override
  Future<String> exportExcelAccountPayment({
    String fromDate,
    String toDate,
    String keySearch,
    List<String> filterStatus,
  }) async {
    Map<String, dynamic> mapData = {
      "paymentType": "inbound",
      "data":
          "{\"Filter\":{\"logic\":\"and\",\"filters\":[{\"field\":\"PaymentDate\",\"operator\":\"gte\",\"value\":\"$fromDate\"},{\"field\":\"PaymentDate\",\"operator\":\"lte\",\"value\":\"$toDate\"}]}}"
    };

    if (keySearch != null || keySearch != "") {
      mapData = {
        "paymentType": "inbound",
        "data":
            "{\"Filter\":{\"logic\":\"and\",\"filters\":[{\"logic\":\"or\",\"filters\":[{\"field\":\"SenderReceiver\",\"operator\":\"contains\",\"value\":\"$keySearch\"},{\"field\":\"Name\",\"operator\":\"contains\",\"value\":\"$keySearch\"},{\"field\":\"AccountName\",\"operator\":\"contains\",\"value\":\"$keySearch\"},{\"field\":\"Communication\",\"operator\":\"contains\",\"value\":\"$keySearch\"}]},{\"field\":\"PaymentDate\",\"operator\":\"gte\",\"value\":\"$fromDate\"},{\"field\":\"PaymentDate\",\"operator\":\"lte\",\"value\":\"$toDate\"}]}}"
      };
      if (filterStatus.length == 1) {
        mapData["data"] =
            "{\"Filter\":{\"logic\":\"and\",\"filters\":[{\"logic\":\"or\",\"filters\":[{\"field\":\"SenderReceiver\",\"operator\":\"contains\",\"value\":\"$keySearch\"},{\"field\":\"Name\",\"operator\":\"contains\",\"value\":\"$keySearch\"},{\"field\":\"AccountName\",\"operator\":\"contains\",\"value\":\"$keySearch\"},{\"field\":\"Communication\",\"operator\":\"contains\",\"value\":\"$keySearch\"}]},{\"field\":\"PaymentDate\",\"operator\":\"gte\",\"value\":\"$fromDate\"},{\"field\":\"PaymentDate\",\"operator\":\"lte\",\"value\":\"$toDate\"},{\"logic\":\"or\",\"filters\":[{\"field\":\"State\",\"operator\":\"eq\",\"value\":\"${filterStatus[0]}\"}]}]}}";
      } else if (filterStatus.length == 2) {
        mapData["data"] =
            "{\"Filter\":{\"logic\":\"and\",\"filters\":[{\"logic\":\"or\",\"filters\":[{\"field\":\"SenderReceiver\",\"operator\":\"contains\",\"value\":\"$keySearch\"},{\"field\":\"Name\",\"operator\":\"contains\",\"value\":\"$keySearch\"},{\"field\":\"AccountName\",\"operator\":\"contains\",\"value\":\"$keySearch\"},{\"field\":\"Communication\",\"operator\":\"contains\",\"value\":\"$keySearch\"}]},{\"field\":\"PaymentDate\",\"operator\":\"gte\",\"value\":\"$fromDate\"},{\"field\":\"PaymentDate\",\"operator\":\"lte\",\"value\":\"$toDate\"},{\"logic\":\"or\",\"filters\":[{\"field\":\"State\",\"operator\":\"eq\",\"value\":\"${filterStatus[0]}\"},{\"field\":\"State\",\"operator\":\"eq\",\"value\":\"${filterStatus[1]}\"}]}]}}";
      }
    } else if (filterStatus.isNotEmpty) {
      if (filterStatus.length == 1) {
        mapData["data"] =
            "{\"Filter\":{\"logic\":\"and\",\"filters\":[{\"field\":\"PaymentDate\",\"operator\":\"gte\",\"value\":\"$fromDate\"},{\"field\":\"PaymentDate\",\"operator\":\"lte\",\"value\":\"$toDate\"},{\"logic\":\"or\",\"filters\":[{\"field\":\"State\",\"operator\":\"eq\",\"value\":\"${filterStatus[0]}\"}]}]}}";
        if (keySearch != null || keySearch != "") {
          mapData["data"] =
              "{\"Filter\":{\"logic\":\"and\",\"filters\":[{\"logic\":\"or\",\"filters\":[{\"field\":\"SenderReceiver\",\"operator\":\"contains\",\"value\":\"$keySearch\"},{\"field\":\"Name\",\"operator\":\"contains\",\"value\":\"$keySearch\"},{\"field\":\"AccountName\",\"operator\":\"contains\",\"value\":\"$keySearch\"},{\"field\":\"Communication\",\"operator\":\"contains\",\"value\":\"$keySearch\"}]},{\"field\":\"PaymentDate\",\"operator\":\"gte\",\"value\":\"$fromDate\"},{\"field\":\"PaymentDate\",\"operator\":\"lte\",\"value\":\"$toDate\"},{\"logic\":\"or\",\"filters\":[{\"field\":\"State\",\"operator\":\"eq\",\"value\":\"${filterStatus[0]}\"}]}]}}";
        }
      } else if (filterStatus.length == 2) {
        mapData["data"] =
            "{\"Filter\":{\"logic\":\"and\",\"filters\":[{\"field\":\"PaymentDate\",\"operator\":\"gte\",\"value\":\"$fromDate\"},{\"field\":\"PaymentDate\",\"operator\":\"lte\",\"value\":\"$toDate\"},{\"logic\":\"or\",\"filters\":[{\"field\":\"State\",\"operator\":\"eq\",\"value\":\"${filterStatus[0]}\"},{\"field\":\"State\",\"operator\":\"eq\",\"value\":\"${filterStatus[1]}\"}]}]}}";
        if (keySearch != null || keySearch != "") {
          mapData["data"] =
              "{\"Filter\":{\"logic\":\"and\",\"filters\":[{\"logic\":\"or\",\"filters\":[{\"field\":\"SenderReceiver\",\"operator\":\"contains\",\"value\":\"$keySearch\"},{\"field\":\"Name\",\"operator\":\"contains\",\"value\":\"$keySearch\"},{\"field\":\"AccountName\",\"operator\":\"contains\",\"value\":\"$keySearch\"},{\"field\":\"Communication\",\"operator\":\"contains\",\"value\":\"$keySearch\"}]},{\"field\":\"PaymentDate\",\"operator\":\"gte\",\"value\":\"$fromDate\"},{\"field\":\"PaymentDate\",\"operator\":\"lte\",\"value\":\"$toDate\"},{\"logic\":\"or\",\"filters\":[{\"field\":\"State\",\"operator\":\"eq\",\"value\":\"${filterStatus[0]}\"},{\"field\":\"State\",\"operator\":\"eq\",\"value\":\"${filterStatus[1]}\"}]}]}}";
        }
      }
    }

    final String nameFile = await downloadExcel(
        path: "/AccountPayment/Excel",
        body: json.encode(mapData),
        nameFile: "Pheu-Thu");
    return nameFile;
  }

  @override
  Future<String> exportExcelAccountPaymentSale(
      {String fromDate,
      String toDate,
      String keySearch,
      List<String> filterStatus}) async {
    print(fromDate);
    print(toDate);
    Map<String, dynamic> mapData = {
      "paymentType": "outbound",
      "data":
          "{\"Filter\":{\"logic\":\"and\",\"filters\":[{\"field\":\"PaymentDate\",\"operator\":\"gte\",\"value\":\"$fromDate\"},{\"field\":\"PaymentDate\",\"operator\":\"lte\",\"value\":\"$toDate\"}]}}"
    };

    if (keySearch != null || keySearch != "") {
      mapData = {
        "paymentType": "outbound",
        "data":
            "{\"Filter\":{\"logic\":\"and\",\"filters\":[{\"logic\":\"or\",\"filters\":[{\"field\":\"SenderReceiver\",\"operator\":\"contains\",\"value\":\"$keySearch\"},{\"field\":\"Name\",\"operator\":\"contains\",\"value\":\"$keySearch\"},{\"field\":\"AccountName\",\"operator\":\"contains\",\"value\":\"$keySearch\"},{\"field\":\"Communication\",\"operator\":\"contains\",\"value\":\"$keySearch\"}]},{\"field\":\"PaymentDate\",\"operator\":\"gte\",\"value\":\"$fromDate\"},{\"field\":\"PaymentDate\",\"operator\":\"lte\",\"value\":\"$toDate\"}]}}"
      };
      if (filterStatus.length == 1) {
        mapData["data"] =
            "{\"Filter\":{\"logic\":\"and\",\"filters\":[{\"logic\":\"or\",\"filters\":[{\"field\":\"SenderReceiver\",\"operator\":\"contains\",\"value\":\"$keySearch\"},{\"field\":\"Name\",\"operator\":\"contains\",\"value\":\"$keySearch\"},{\"field\":\"AccountName\",\"operator\":\"contains\",\"value\":\"$keySearch\"},{\"field\":\"Communication\",\"operator\":\"contains\",\"value\":\"$keySearch\"}]},{\"field\":\"PaymentDate\",\"operator\":\"gte\",\"value\":\"$fromDate\"},{\"field\":\"PaymentDate\",\"operator\":\"lte\",\"value\":\"$toDate\"},{\"logic\":\"or\",\"filters\":[{\"field\":\"State\",\"operator\":\"eq\",\"value\":\"${filterStatus[0]}\"}]}]}}";
      } else if (filterStatus.length == 2) {
        mapData["data"] =
            "{\"Filter\":{\"logic\":\"and\",\"filters\":[{\"logic\":\"or\",\"filters\":[{\"field\":\"SenderReceiver\",\"operator\":\"contains\",\"value\":\"$keySearch\"},{\"field\":\"Name\",\"operator\":\"contains\",\"value\":\"$keySearch\"},{\"field\":\"AccountName\",\"operator\":\"contains\",\"value\":\"$keySearch\"},{\"field\":\"Communication\",\"operator\":\"contains\",\"value\":\"$keySearch\"}]},{\"field\":\"PaymentDate\",\"operator\":\"gte\",\"value\":\"$fromDate\"},{\"field\":\"PaymentDate\",\"operator\":\"lte\",\"value\":\"$toDate\"},{\"logic\":\"or\",\"filters\":[{\"field\":\"State\",\"operator\":\"eq\",\"value\":\"${filterStatus[0]}\"},{\"field\":\"State\",\"operator\":\"eq\",\"value\":\"${filterStatus[1]}\"}]}]}}";
      }
    } else if (filterStatus.isNotEmpty) {
      if (filterStatus.length == 1) {
        mapData["data"] =
            "{\"Filter\":{\"logic\":\"and\",\"filters\":[{\"field\":\"PaymentDate\",\"operator\":\"gte\",\"value\":\"$fromDate\"},{\"field\":\"PaymentDate\",\"operator\":\"lte\",\"value\":\"$toDate\"},{\"logic\":\"or\",\"filters\":[{\"field\":\"State\",\"operator\":\"eq\",\"value\":\"${filterStatus[0]}\"}]}]}}";
        if (keySearch != null || keySearch != "") {
          mapData["data"] =
              "{\"Filter\":{\"logic\":\"and\",\"filters\":[{\"logic\":\"or\",\"filters\":[{\"field\":\"SenderReceiver\",\"operator\":\"contains\",\"value\":\"$keySearch\"},{\"field\":\"Name\",\"operator\":\"contains\",\"value\":\"$keySearch\"},{\"field\":\"AccountName\",\"operator\":\"contains\",\"value\":\"$keySearch\"},{\"field\":\"Communication\",\"operator\":\"contains\",\"value\":\"$keySearch\"}]},{\"field\":\"PaymentDate\",\"operator\":\"gte\",\"value\":\"$fromDate\"},{\"field\":\"PaymentDate\",\"operator\":\"lte\",\"value\":\"$toDate\"},{\"logic\":\"or\",\"filters\":[{\"field\":\"State\",\"operator\":\"eq\",\"value\":\"${filterStatus[0]}\"}]}]}}";
        }
      } else if (filterStatus.length == 2) {
        mapData["data"] =
            "{\"Filter\":{\"logic\":\"and\",\"filters\":[{\"field\":\"PaymentDate\",\"operator\":\"gte\",\"value\":\"$fromDate\"},{\"field\":\"PaymentDate\",\"operator\":\"lte\",\"value\":\"$toDate\"},{\"logic\":\"or\",\"filters\":[{\"field\":\"State\",\"operator\":\"eq\",\"value\":\"${filterStatus[0]}\"},{\"field\":\"State\",\"operator\":\"eq\",\"value\":\"${filterStatus[1]}\"}]}]}}";
        if (keySearch != null || keySearch != "") {
          mapData["data"] =
              "{\"Filter\":{\"logic\":\"and\",\"filters\":[{\"logic\":\"or\",\"filters\":[{\"field\":\"SenderReceiver\",\"operator\":\"contains\",\"value\":\"$keySearch\"},{\"field\":\"Name\",\"operator\":\"contains\",\"value\":\"$keySearch\"},{\"field\":\"AccountName\",\"operator\":\"contains\",\"value\":\"$keySearch\"},{\"field\":\"Communication\",\"operator\":\"contains\",\"value\":\"$keySearch\"}]},{\"field\":\"PaymentDate\",\"operator\":\"gte\",\"value\":\"$fromDate\"},{\"field\":\"PaymentDate\",\"operator\":\"lte\",\"value\":\"$toDate\"},{\"logic\":\"or\",\"filters\":[{\"field\":\"State\",\"operator\":\"eq\",\"value\":\"${filterStatus[0]}\"},{\"field\":\"State\",\"operator\":\"eq\",\"value\":\"${filterStatus[1]}\"}]}]}}";
        }
      }
    }

    final String nameFile = await downloadExcel(
        path: "/AccountPayment/Excel",
        body: json.encode(mapData),
        nameFile: "Pheu-Chi");
    return nameFile;
  }
}
