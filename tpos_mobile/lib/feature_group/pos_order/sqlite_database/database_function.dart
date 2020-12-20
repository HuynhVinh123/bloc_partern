import 'package:sqflite/sqlite_api.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/application_user.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/cart_product.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/company.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/key.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/money_cart.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/partners.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/payment.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/point_sale.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/point_sale_db.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/pos_config.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/pos_order.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/price_list.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/state_cart.dart';



import 'database_helper.dart';

abstract class IDatabaseFunction {
  // insert
  Future<int> insertCart(StateCart stateCart);
  Future<int> insertProduct(CartProduct product);
  Future<int> insertProductCart(Lines line);
  Future<int> insertPartner(Partners partner);
  Future<int> insertPriceList(PriceList priceList);
  Future<int> insertAccountJournals(AccountJournal accountJournal);
  Future<int> insertSession(Session session);
  Future<int> insertCompany(Companies company);
  Future<int> insertPayment(Payment payment);
  Future<int> insertStatementIds(StatementIds statementIds);
  Future<int> insertApplicationUser(PosApplicationUser applicationUser);
  Future<int> insertPosConfig(PosConfig posConfig);
  Future<int> insertPointSaleTax(Tax tax);
  Future<int> insertProductPriceList(Key key);
  Future<int> insertPointSale(PointSaleDB pointSale);
  Future<int> insertCartMoney(MoneyCart moneyCart);

  // query get rows
  Future<List<StateCart>> queryAllRowsCart();
  Future<List<StateCart>> queryCartByPosition(String position);
  Future<List<CartProduct>> queryProductAllRows();
  Future<List<Lines>> queryGetProductsForCart(String positionCart);
  Future<List<Lines>> queryGetProductWithID(String positionCart, int productId);
  Future<List<Partners>> queryGetPartners();
  Future<List<Partners>> queryGetPartnersById(int partnerID);
  Future<List<PriceList>> queryGetPriceLists();
  Future<List<AccountJournal>> queryGetAccountJournals();
  Future<List<Session>> querySessions();
  Future<List<Companies>> queryCompanys();
  Future<List<Payment>> queryPayments();
  Future<List<StatementIds>> queryStatementIds(String position);
  Future<List<PosApplicationUser>> queryGetApplicationUserById(String id);
  Future<List<PosConfig>> queryGetPosConfig();
  Future<List<Tax>> queryGetTaxs();
  Future<List<Tax>> queryGetTaxById(int id);
  Future<List<Key>> queryGetProductPriceList();
  Future<List<PriceList>> queryGetPriceListById(int id);
  Future<List<PosApplicationUser>> queryGetApplication();
  Future<List<PointSaleDB>> queryGetPointSale();
  Future<List<MoneyCart>> queryGetMoneyCartPosition(String position);

  // delete
  Future<int> deleteCartByPosition(String position);
  Future<int> deleteProductCart(Lines line);
  Future<int> deletePayments();
  Future<int> deletePointSaleTaxs();
  Future<int> deletePosconfig();
  Future<int> deleteCart();
  Future<int> deleteSession();
  Future<int> deleteProduct();
  Future<int> deletePaymentLines();
  Future<int> deletePartners();
  Future<int> deletePriceList();
  Future<int> deleteAccountJournal();
  Future<int> deleteCompany();
  Future<int> deleteStatementIds();
  Future<int> deleteApplicationUser();
  Future<int> deleteProductPriceList();
  Future<int> deletePointSale();
  Future<int> deleteMoneyCart();
  Future<int> deleteMoneyCartByPosition(String position);

  // update
  Future<int> updateCart(StateCart cart);
  Future<int> updateProductCart(Lines line);
  Future<int> updatePartner(Partners partner);
  Future<int> updateSession(Session session);
  Future<int> updatePosconfig(PosConfig posConfig);
  Future<int> updateMoneyCart(MoneyCart moneyCart);
}

class DatabaseFunction implements IDatabaseFunction {
  // inserted row.
  Future<int> insertCart(StateCart stateCart) async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.insert(DatabaseHelper.tbCart, stateCart.toJson());
  }

  // insert product
  Future<int> insertProduct(CartProduct product) async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.insert(DatabaseHelper.tbProduct, product.toJson());
  }

  // insert product for cart
  Future<int> insertProductCart(Lines line) async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.insert(DatabaseHelper.tbPaymentLines, line.toJson());
  }

  // insert partner
  Future<int> insertPartner(Partners partner) async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.insert(DatabaseHelper.tbPartner, partner.toJson());
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<StateCart>> queryAllRowsCart() async {
    final Database db = await DatabaseHelper.instance.database;
    final res = await db.query(DatabaseHelper.tbCart);

    final List<StateCart> list = res.isNotEmpty
        ? res.map((val) => StateCart.fromJson(val)).toList()
        : [];
    return list;
  }

  Future<List<CartProduct>> queryProductAllRows() async {
    final Database db = await DatabaseHelper.instance.database;
    final res = await db.query(DatabaseHelper.tbProduct);
    final List<CartProduct> list = res.isNotEmpty
        ? res.map((val) => CartProduct.fromJson(val)).toList()
        : [];
    return list;
  }

  Future<List<Lines>> queryGetProductsForCart(String positionCart) async {
    final Database db = await DatabaseHelper.instance.database;
    final result = await db.query(DatabaseHelper.tbPaymentLines,
        where: '${DatabaseHelper.columnPosition} = ?',
        whereArgs: [positionCart]);
    final List<Lines> lines = result.isNotEmpty
        ? result.map((value) => Lines.fromJson(value)).toList()
        : [];
    return lines;
  }

  Future<List<Lines>> queryGetProductWithID(
      String positionCart, int productId) async {
    final Database db = await DatabaseHelper.instance.database;
    final result = await db.query(DatabaseHelper.tbPaymentLines,
        where:
            '${DatabaseHelper.tbPaymentLinesProductId} = ? and ${DatabaseHelper.tbPaymentLinesTbCartPosition} = ?',
        whereArgs: [productId, positionCart]);
    final List<Lines> lines = result.isNotEmpty
        ? result.map((value) => Lines.fromJson(value)).toList()
        : [];
    return lines;
  }

  Future<List<Partners>> queryGetPartners() async {
    final Database db = await DatabaseHelper.instance.database;
    final res = await db.query(DatabaseHelper.tbPartner);
    final List<Partners> partners = res.isNotEmpty
        ? res.map((value) => Partners.fromJson(value)).toList()
        : [];
    return partners;
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> deleteCartByPosition(String position) async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.delete(DatabaseHelper.tbCart,
        where: '${DatabaseHelper.columnPosition} = ?', whereArgs: [position]);
  }

  // Để xóa tất cả sản phẩm trong 1 giỏ hàng
  @override
  Future<int> deleteProductCart(Lines line) async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.delete(DatabaseHelper.tbPaymentLines,
        where:
            '${DatabaseHelper.tbPaymentLinesTbCartPosition} = ?  and ${DatabaseHelper.tbPaymentLinesProductId} = ? and ${DatabaseHelper.tbPaymentLinesId} = ?',
        whereArgs: [line.tb_cart_position, line.productId, line.id]);
  }

  //update
  Future<int> updateCart(StateCart cart) async {
    final Database db = await DatabaseHelper.instance.database;
    final res = await db.update(DatabaseHelper.tbCart, cart.toJson(),
        where: '${DatabaseHelper.tbPaymentLinesTbCartPosition} = ?',
        whereArgs: [cart.position]);
    return res;
  }

  Future<int> updateProductCart(Lines line) async {
    final Database db = await DatabaseHelper.instance.database;
    final res = await db.update(DatabaseHelper.tbPaymentLines, line.toJson(),
        where:
            '${DatabaseHelper.tbPaymentLinesTbCartPosition} = ? and ${DatabaseHelper.tbPaymentLinesProductId} = ? and ${DatabaseHelper.tbPaymentLinesId} = ? and ${DatabaseHelper.tbPaymentLinesPriceUnit} = ?',
        whereArgs: [
          line.tb_cart_position,
          line.productId,
          line.id,
          line.priceUnit
        ]);
    return res;
  }

  Future<int> updatePartner(Partners partner) async {
    int id;
    id = partner.id;
    partner.id = null;
    final Database db = await DatabaseHelper.instance.database;
    final response = await db.update(DatabaseHelper.tbPartner, partner.toJson(),
        where: '${DatabaseHelper.tbPartnerId} = ?', whereArgs: [id]);
    return response;
  }

  @override
  Future<int> insertPriceList(PriceList priceList) async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.insert(DatabaseHelper.tbPriceList, priceList.toJson());
  }

  @override
  Future<List<PriceList>> queryGetPriceLists() async {
    final Database db = await DatabaseHelper.instance.database;
    final res = await db.query(DatabaseHelper.tbPriceList);

    final List<PriceList> list = res.isNotEmpty
        ? res.map((val) => PriceList.fromJson(val)).toList()
        : [];
    return list;
  }

  @override
  Future<int> insertAccountJournals(AccountJournal accountJournal) async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.insert(
        DatabaseHelper.tbAccountJournal, accountJournal.toJson());
  }

  @override
  Future<List<AccountJournal>> queryGetAccountJournals() async {
    final Database db = await DatabaseHelper.instance.database;
    final res = await db.query(DatabaseHelper.tbAccountJournal);

    final List<AccountJournal> list = res.isNotEmpty
        ? res.map((val) => AccountJournal.fromJson(val)).toList()
        : [];
    return list;
  }

  @override
  Future<List<Session>> querySessions() async {
    final Database db = await DatabaseHelper.instance.database;
    final res = await db.query(DatabaseHelper.tbSession);

    final List<Session> list =
        res.isNotEmpty ? res.map((val) => Session.fromJson(val)).toList() : [];
    return list;
  }

  @override
  Future<int> updateSession(Session session) async {
    int id;
    id = session.id;
    //int cashControl = session.cashControl ? 1 : 0;
    final Database db = await DatabaseHelper.instance.database;
    final response = await db.update(DatabaseHelper.tbSession, session.toJson(),
        where: '${DatabaseHelper.tbSessionId} = ?', whereArgs: [id]);
    return response;
  }

  @override
  Future<int> insertCompany(Companies company) async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.insert(DatabaseHelper.tbCompany, company.toJson());
  }

  @override
  Future<List<Companies>> queryCompanys() async {
    final Database db = await DatabaseHelper.instance.database;
    final res = await db.query(DatabaseHelper.tbCompany);

    final List<Companies> list = res.isNotEmpty
        ? res.map((val) => Companies.fromJson(val)).toList()
        : [];
    return list;
  }

  @override
  Future<List<StateCart>> queryCartByPosition(String position) async {
    final Database db = await DatabaseHelper.instance.database;
    final res = await db.query(DatabaseHelper.tbCart,
        where: '${DatabaseHelper.columnPosition} = ?', whereArgs: [position]);

    final List<StateCart> list = res.isNotEmpty
        ? res.map((val) => StateCart.fromJson(val)).toList()
        : [];
    return list;
  }

  @override
  Future<int> insertSession(Session session) async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.insert(DatabaseHelper.tbSession, session.toJson());
  }

  @override
  Future<int> insertPayment(Payment payment) async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.insert(DatabaseHelper.tbPayment, payment.toJson());
  }

  @override
  Future<List<Payment>> queryPayments() async {
    final Database db = await DatabaseHelper.instance.database;
    final res = await db.query(DatabaseHelper.tbPayment);

    final List<Payment> list =
        res.isNotEmpty ? res.map((val) => Payment.fromJson(val)).toList() : [];
    return list;
  }

  @override
  Future<int> deletePayments() async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.delete(DatabaseHelper.tbPayment);
  }

  @override
  Future<int> insertStatementIds(StatementIds statementIds) async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.insert(
        DatabaseHelper.tbStatementIds, statementIds.toJson());
  }

  @override
  Future<List<StatementIds>> queryStatementIds(String position) async {
    final Database db = await DatabaseHelper.instance.database;
    final res = await db.query(DatabaseHelper.tbStatementIds,
        where: '${DatabaseHelper.tbStatementIdsPositIon} = ?',
        whereArgs: [position]);

    final List<StatementIds> list = res.isNotEmpty
        ? res.map((val) => StatementIds.fromJson(val)).toList()
        : [];
    return list;
  }

  @override
  Future<List<Partners>> queryGetPartnersById(int partnerID) async {
    final Database db = await DatabaseHelper.instance.database;
    final res = await db.query(DatabaseHelper.tbPartner,
        where: '${DatabaseHelper.tbPartnerId} = ?', whereArgs: [partnerID]);
    final List<Partners> partners = res.isNotEmpty
        ? res.map((value) => Partners.fromJson(value)).toList()
        : [];
    return partners;
  }

  @override
  Future<int> insertApplicationUser(PosApplicationUser applicationUser) async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.insert(
        DatabaseHelper.tbApplicationUser, applicationUser.toJson());
  }

  @override
  Future<List<PosApplicationUser>> queryGetApplicationUserById(String id) async {
    final Database db = await DatabaseHelper.instance.database;
    final res = await db.query(DatabaseHelper.tbApplicationUser,
        where: '${DatabaseHelper.tbApplicationUserId} = ?', whereArgs: [id]);
    final List<PosApplicationUser> applicationUsers = res.isNotEmpty
        ? res.map((value) => PosApplicationUser.fromJson(value)).toList()
        : [];
    return applicationUsers;
  }

  @override
  Future<int> insertPosConfig(PosConfig posConfig) async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.insert(DatabaseHelper.tbPosConfig, posConfig.toJson());
  }

  @override
  Future<List<PosConfig>> queryGetPosConfig() async {
    final Database db = await DatabaseHelper.instance.database;
    final res = await db.query(DatabaseHelper.tbPosConfig);

    final List<PosConfig> posConfigs = res.isNotEmpty
        ? res.map((value) {
            return PosConfig.fromJson(value);
          }).toList()
        : [];
    return posConfigs;
  }

  @override
  Future<int> updatePosconfig(PosConfig posConfig) async {
    int id;
    id = posConfig.id;

    final Database db = await DatabaseHelper.instance.database;
    final response = await db.update(
        DatabaseHelper.tbPosConfig, posConfig.toJson(),
        where: '${DatabaseHelper.tbPosConfigId} = ?', whereArgs: [id]);
    return response;
  }

  @override
  Future<int> insertPointSaleTax(Tax tax) async {
    final Database db = await DatabaseHelper.instance.database;
    tax.active = null;
    tax.priceInclude = null;
    return await db.insert(DatabaseHelper.tbTax, tax.toJson());
  }

  @override
  Future<List<Tax>> queryGetTaxs() async {
    final Database db = await DatabaseHelper.instance.database;
    final res = await db.query(DatabaseHelper.tbTax);

    final List<Tax> taxs = res.isNotEmpty
        ? res.map((value) {
            return Tax.fromJson(value);
          }).toList()
        : [];
    return taxs;
  }

  @override
  Future<int> deletePointSaleTaxs() async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.delete(DatabaseHelper.tbTax);
  }

  @override
  Future<List<Tax>> queryGetTaxById(int id) async {
    final Database db = await DatabaseHelper.instance.database;
    final res = await db.query(DatabaseHelper.tbTax,
        where: '${DatabaseHelper.tbTaxId} = ?', whereArgs: [id]);
    final List<Tax> taxs =
        res.isNotEmpty ? res.map((value) => Tax.fromJson(value)).toList() : [];
    return taxs;
  }

  @override
  Future<int> deletePosconfig() async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.delete(DatabaseHelper.tbPosConfig);
  }

  @override
  Future<int> deleteCart() async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.delete(DatabaseHelper.tbCart);
  }

  @override
  Future<int> deleteSession() async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.delete(DatabaseHelper.tbSession);
  }

  @override
  Future<int> deleteAccountJournal() async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.delete(DatabaseHelper.tbAccountJournal);
  }

  @override
  Future<int> deleteApplicationUser() async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.delete(DatabaseHelper.tbApplicationUser);
  }

  @override
  Future<int> deleteCompany() async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.delete(DatabaseHelper.tbCompany);
  }

  @override
  Future<int> deletePartners() async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.delete(DatabaseHelper.tbPartner);
  }

  @override
  Future<int> deletePaymentLines() async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.delete(DatabaseHelper.tbPaymentLines);
  }

  @override
  Future<int> deletePriceList() async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.delete(DatabaseHelper.tbPriceList);
  }

  @override
  Future<int> deleteProduct() async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.delete(DatabaseHelper.tbProduct);
  }

  @override
  Future<int> deleteStatementIds() async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.delete(DatabaseHelper.tbStatementIds);
  }

  @override
  Future<int> deleteProductPriceList() async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.delete(DatabaseHelper.tbProductPriceList);
  }

  @override
  Future<int> insertProductPriceList(Key key) async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.insert(DatabaseHelper.tbProductPriceList, key.toJson());
  }

  @override
  Future<List<Key>> queryGetProductPriceList() async {
    final Database db = await DatabaseHelper.instance.database;
    final res = await db.query(DatabaseHelper.tbProductPriceList);

    final List<Key> products = res.isNotEmpty
        ? res.map((value) {
            return Key.fromJson(value);
          }).toList()
        : [];
    return products;
  }

  @override
  Future<List<PriceList>> queryGetPriceListById(int id) async {
    final Database db = await DatabaseHelper.instance.database;
    final res = await db.query(DatabaseHelper.tbPriceList,
        where: '${DatabaseHelper.tbPriceListId} = ?', whereArgs: [id]);

    final List<PriceList> list = res.isNotEmpty
        ? res.map((val) => PriceList.fromJson(val)).toList()
        : [];
    return list;
  }

  @override
  Future<List<PosApplicationUser>> queryGetApplication() async {
    final Database db = await DatabaseHelper.instance.database;
    final res = await db.query(DatabaseHelper.tbApplicationUser);
    final List<PosApplicationUser> applicationUsers = res.isNotEmpty
        ? res.map((value) => PosApplicationUser.fromJson(value)).toList()
        : [];
    return applicationUsers;
  }

  @override
  Future<int> deletePointSale() async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.delete(DatabaseHelper.tbPointSale);
  }

  @override
  Future<int> insertPointSale(PointSaleDB pointSale) async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.insert(DatabaseHelper.tbPointSale, pointSale.toJson());
  }

  @override
  Future<List<PointSaleDB>> queryGetPointSale() async {
    final Database db = await DatabaseHelper.instance.database;
    final res = await db.query(DatabaseHelper.tbPointSale);
    final List<PointSaleDB> pointSales = res.isNotEmpty
        ? res.map((value) => PointSaleDB.fromJson(value)).toList()
        : [];
    return pointSales;
  }

  @override
  Future<int> deleteMoneyCart() async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.delete(DatabaseHelper.tbMoneyCart);
  }

  @override
  Future<int> insertCartMoney(MoneyCart moneyCart) async {
    print(moneyCart.toJson());
    final Database db = await DatabaseHelper.instance.database;
    return await db.insert(DatabaseHelper.tbMoneyCart, moneyCart.toJson());
  }

  @override
  Future<List<MoneyCart>> queryGetMoneyCartPosition(String position) async {
    final Database db = await DatabaseHelper.instance.database;
    final res = await db.query(DatabaseHelper.tbMoneyCart,
        where: '${DatabaseHelper.tbMoneyCartPosition} = ?',
        whereArgs: [position]);
    final List<MoneyCart> moneyCarts = res.isNotEmpty
        ? res.map((value) => MoneyCart.fromJson(value)).toList()
        : [];
    return moneyCarts;
  }

  @override
  Future<int> updateMoneyCart(MoneyCart moneyCart) async {
    final Database db = await DatabaseHelper.instance.database;
    final response = await db.update(
        DatabaseHelper.tbMoneyCart, moneyCart.toJson(),
        where: '${DatabaseHelper.tbMoneyCartPosition} = ?',
        whereArgs: [moneyCart.position]);
    return response;
  }

  @override
  Future<int> deleteMoneyCartByPosition(String position) async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.delete(DatabaseHelper.tbMoneyCart,
        where: '${DatabaseHelper.tbMoneyCartPosition} = ?',
        whereArgs: [position]);
  }
}
