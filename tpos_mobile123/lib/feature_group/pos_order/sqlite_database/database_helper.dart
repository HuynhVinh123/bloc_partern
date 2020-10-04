import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseHelper {
  static const databaseName = "MyDatabase.db";
  static const databaseVersion = 2;

  static const tbCart = 'tb_Cart';
  static const tbProduct = 'tb_Product';
  static const tbPaymentLines = 'tb_PaymentLines';
  static const tbPartner = 'tb_Partner';
  static const tbPriceList = 'tb_PriceList';
  static const tbAccountJournal = 'tb_AccountJournal';
  static const tbSession = 'tb_Session';
  static const tbCompany = 'tb_Company';
  static const tbPayment = 'tb_Payment';
  static const tbStatementIds = 'tb_StatementIds';
  static const tbApplicationUser = 'tb_ApplicationUser';
  static const tbPosConfig = 'tb_PosConfig';
  static const tbTax = 'tb_Tax';
  static const tbProductPriceList = 'tb_ProductPriceList';
  static const tbPointSale = 'tb_PointSale';
  static const tbMoneyCart = 'tb_MoneyCart';

  // cart
  static const columnId = 'tb_cart_id';
  static const columnPosition = 'tb_cart_position';
  static const columnCheck = 'tb_cart_check';
  static const columnTime = 'Time';
  static const columnLoginNumber = 'LoginNumber';

  // product
  static const tbId = "tbProductId";
  static const tbProductId = "Id";
  static const tbProductAvailableInPos = "AvailableInPOS";
  static const tbProductBarcode = "Barcode";
  static const tbProductDefaultCode = "DefaultCode";
  static const tbProductDiscountPurchase = "DiscountPurchase";
  static const tbProductDiscountSale = "DiscountSale";
  static const tbProductImageUrl = "ImageUrl";
  static const tbProductName = "Name";
  static const tbProductNameGet = "NameGet";
  static const tbProductNameNosign = "NameNosign";
  static const tbProductOldPrice = "OldPrice";
//  static final tbProductPosSalesCount = "PosSalesCount";
  static const tbProductPrice = "Price";
  static const tbProductProductTmplId = "ProductTmplId";
  static const tbProductPurchaseOK = "PurchaseOK";
  static const tbProductPurchasePrice = "PurchasePrice";
  static const tbProductSaleOK = "SaleOK";
  static const tbProductUOMId = "UOMId";
  static const tbProductUOMName = "UOMName";
  static const tbProductVersion = "Version";
  static const tbProductWeight = "Weight";
  static const tbProductPosSalesCount = "PosSalesCount";
  static const tbProductFactor = "Factor";

  // paymentLines
  static const tbPaymentLinesQty = "qty";
  static const tbPaymentLinesPriceUnit = "price_unit";
  static const tbPaymentLinesDiscount = "discount";
  static const tbPaymentLinesProductId = "product_id";
  static const tbPaymentLinesUomId = "uom_id";
  static const tbPaymentLinesDiscountType = "discount_type";
  static const tbPaymentLinesId = "id";
  static const tbPaymentLinesNote = "note";
  static const tbPaymentLinesNameCart = "name_cart";
  static const tbPaymentLinesTbCartPosition = "tb_cart_position";
  static const tbPaymentLinesProductName = "productName";
  static const tbPaymentLinesPromotionProgramId = "promotionprogram_id";
  static const tbPaymentLinesIsPromotion = "IsPromotion";
  static const tbPaymentLinesUOMName = "uomName";
  static const tbPaymentLinesImage = "image";

  // partner
  static const tbPartnerId = "Id";
  static const tbPartnerName = "Name";
  static const tbPartnerDisplayName = "DisplayName";
  static const tbPartnerStreet = "Street";
  static const tbPartnerPhone = "Phone";
  static const tbPartnerEmail = "Email";
  static const tbPartnerBarcode = "Barcode";
  static const tbPartnerImage = "Image";
  static const tbPartnerTaxCode = "TaxCode";

  // list price
  static const tbPriceListId = "Id";
  static const tbPriceListName = "Name";
  static const tbPriceListCurrencyId = "CurrencyId";
  static const tbPriceListCurrencyName = "CurrencyName";
  static const tbPriceListActive = "Active";
  static const tbPriceListCompanyId = "CompanyId";
  static const tbPriceListPartnerCateName = "PartnerCateName";
  static const tbPriceListSequence = "Sequence";
  static const tbPriceListDateStart = "DateStart";
  static const tbPriceListDateEnd = "DateEnd";

  // Account Journal
  static const tbAccountJournalId = "Id";
  static const tbAccountJournalCode = "Code";
  static const tbAccountJournalName = "Name";
  static const tbAccountJournalType = "Type";
  static const tbAccountJournalUpdatePosted = "UpdatePosted";
  static const tbAccountJournalCurrencyId = "CurrencyId";
  static const tbAccountJournalDefaultDebitAccountId = "DefaultDebitAccountId";
  static const tbAccountJournalDefaultCreditAccountId =
      "DefaultCreditAccountId";
  static const tbAccountJournalCompanyId = "CompanyId";
  static const tbAccountJournalCompanyName = "CompanyName";
  static const tbAccountJournalJournalUser = "JournalUser";
  static const tbAccountJournalProfitAccountId = "ProfitAccountId";
  static const tbAccountJournalLossAccountId = "LossAccountId";
  static const tbAccountJournalAmountAuthorizedDiff = "AmountAuthorizedDiff";
  static const tbAccountJournalDedicatedRefund = "DedicatedRefund";

  // session
  static const tbSessionId = "Id";
  static const tbSessionConfigId = "ConfigId";
  static const tbSessionConfigName = "ConfigName";
  static const tbSessionName = "Name";
  static const tbSessionUserId = "UserId";
  static const tbSessionUserName = "UserName";
  static const tbSessionStartAt = "StartAt";
  static const tbSessionStopAt = "StopAt";
  static const tbSessionState = "State";
  static const tbSessionShowState = "ShowState";
  static const tbSessionSequenceNumber = "SequenceNumber";
  static const tbSessionLoginNumber = "LoginNumber";
  static const tbSessionCashControl = "CashControl";
  static const tbSessionCashRegisterId = "CashRegisterId";
  static const tbSessionCashRegisterBalanceStart = "CashRegisterBalanceStart";
  static const tbSessionCashRegisterTotalEntryEncoding =
      "CashRegisterTotalEntryEncoding";
  static const tbSessionCashRegisterBalanceEnd = "CashRegisterBalanceEnd";
  static const tbSessionCashRegisterBalanceEndReal =
      "CashRegisterBalanceEndReal";
  static const tbSessionCashRegisterDifference = "CashRegisterDifference";
  static const tbSessionDateCreated = "DateCreated";

  // company tbCompany
  static const tbCompanyId = "Id";
  static const tbCompanyName = "Name";
  static const tbCompanyPartnerId = "PartnerId";
  static const tbCompanyEmail = "Email";
  static const tbCompanyPhone = "Phone";
  static const tbCompanyCurrencyId = "CurrencyId";
  static const tbCompanyStreet = "Street";
  static const tbCompanyLastUpdated = "LastUpdated";
  static const tbCompanyTransferAccountId = "TransferAccountId";
  static const tbCompanyWarehouseId = "WarehouseId";
  static const tbCompanyPeriodLockDate = "PeriodLockDate";
  static const tbCompanyCity = "City";
  static const tbCompanyDistrict = "District";
  static const tbCompanyWard = "Ward";

  // payment tbPayment
  static const tbPaymentName = "name";
  static const tbPaymentAmountPaid = "amount_paid";
  static const tbPaymentAmountTotal = "amount_total";
  static const tbPaymentAmountTax = "amount_tax";
  static const tbPaymentAmountReturn = "amount_return";
  static const tbPaymentDiscount = "discount";
  static const tbPaymentDiscountType = "discount_type";
  static const tbPaymentDiscountFixed = "discount_fixed";
  static const tbPaymentPosSessionId = "pos_session_id";
  static const tbPaymentPartnerId = "partner_id";
  static const tbPaymentTaxId = "tax_id";
  static const tbPaymentUserId = "user_id";
  static const tbPaymentUid = "uid";
  static const tbPaymentSequenceNumber = "sequence_number";
  static const tbPaymentCreationDate = "creation_date";
  static const tbPaymentTableId = "table_id";
  static const tbPaymentFloor = "floor";
  static const tbPaymentFloorId = "floor_id";
  static const tbPaymentCustomerCount = "customer_count";
  static const tbPaymentLoyaltyPoints = "loyalty_points";
  static const tbPaymentWonPoints = "won_points";
  static const tbPaymentSpentPoints = "spent_points";
  static const tbPaymentTotalPoints = "total_points";

  // StatementIds
  static const tbStatementIdsName = "name";
  static const tbStatementIdsStatementId = "statement_id";
  static const tbStatementIdsAccountId = "account_id";
  static const tbStatementIdsJournalId = "journal_id";
  static const tbStatementIdsAmount = "amount";
  static const tbStatementIdsPositIon = "positon";

  // apllication user tbApplicationUser
  static const tbApplicationUserEmail = "Email";
  static const tbApplicationUserName = "Name";
  static const tbApplicationUserId = "Id";
  static const tbApplicationUserUserName = "UserName";

  // posconfig tbPosConfig
  static const tbPosConfigId = "Id";
  static const tbPosConfigActive = "Active";
  static const tbPosConfigGroupBy = "GroupBy";
  static const tbPosConfigIfacePrintAuto = "IfacePrintAuto";
  static const tbPosConfigIfacePrintSkipScreen = "IfacePrintSkipScreen";
  static const tbPosConfigCashControl = "CashControl";
  static const tbPosConfigIfaceSplitbill = "IfaceSplitbill";
  static const tbPosConfigIfacePrintbill = "IfacePrintbill";
  static const tbPosConfigIfaceOrderlineNotes = "IfaceOrderlineNotes";
  static const tbPosConfigIfacePaymentAuto = "IfacePaymentAuto";
  static const tbPosConfigIsHeaderOrFooter = "IsHeaderOrFooter";
  static const tbPosConfigIfaceDiscount = "IfaceDiscount";
  static const tbPosConfigIfaceDiscountFixed = "IfaceDiscountFixed";
  static const tbPosConfigDiscountPc = "DiscountPc";
  static const tbPosConfigIfaceVAT = "IfaceVAT";
  static const tbPosConfigVatPc = "VatPc";
  static const tbPosConfigIfaceLogo = "IfaceLogo";
  static const tbPosConfigIfaceTax = "IfaceTax";
  static const tbPosConfigUseCache = "UseCache";
  static const tbPosConfigTaxId = "TaxId";
  static const tbPosConfigPriceListId = "PriceListId";
  static const tbPosConfigReceiptHeader = "ReceiptHeader";
  static const tbPosConfigReceiptFooter = "ReceiptFooter";

  // table Tax
  static const tbTaxId = "Id";
  static const tbTaxName = "Name";
  static const tbTaxAmount = "Amount";
  static const tbTaxAccountId = "AccountId";
  static const tbTaxAmountType = "AmountType";
  static const tbTaxCompanyId = "CompanyId";
  static const tbTaxCompanyName = "CompanyName";
  static const tbTaxDescription = "Description";
  static const tbTaxRefundAccountId = "RefundAccountId";
  static const tbTaxSequence = "Sequence";
  static const tbTaxTypeTaxUse = "TypeTaxUse";

  // table Price List
  static const tbProductPriceListKey = "Key";
  static const tbProductPriceListValue = "Value";

  // table point sale
  static const tbPointSaleId = "Id";
  static const tbPointSaleName = "Name";
  static const tbPointSaleNameGet = "NameGet";
  static const tbPointSaleCompanyId = "CompanyId";
  static const tbPointSalePOSSessionUserName = "POSSessionUserName";
  static const tbPointSaleLastSessionClosingDate = "LastSessionClosingDate";
  static const tbPointSaleVatPc = "VatPc";

  // table cart money tbMoneyCart

  static const tbMoneyCartDiscountMethod = "discountMethod";
  static const tbMoneyCartDiscount = "discount";
  static const tbMoneyCartPosition = "position";
  static const tbMoneyCartPartnerId = "partnerId";
  static const tbMoneyCartTaxId = "taxId";
  static const tbMoneyCartAmountTax = "amountTax";

  // make this a singleton class
  // ignore: sort_constructors_first
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  // only have a single app-wide reference to the database
  static Database databaseInstance;

  Future<Database> get database async {
    if (databaseInstance != null) {
      return databaseInstance;
    }
    // lazily instantiate the db the first time it is accessed
    else {
      databaseInstance = await _initDatabase();
    }
    return databaseInstance;
  }

  // this opens the database (and creates it if it doesn't exist)
  Future<Database> _initDatabase() async {
    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();
    final String path = join(documentsDirectory.path, databaseName);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('version', databaseVersion);
    return await openDatabase(path,
        version: databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tbCart (
            $columnId INTEGER PRIMARY KEY,
            $columnPosition TEXT NOT NULL,
            $columnCheck BOOL NOT NULL,
            $columnTime TEXT,
            $columnLoginNumber INTEGER
          )
          ''');
    await db.execute('''
          CREATE TABLE $tbProduct (
            $tbId INTEGER PRIMARY KEY,
            $tbProductId INTEGER,
            $tbProductName TEXT,
            $tbProductUOMId INTEGER,
            $tbProductUOMName TEXT,
            $tbProductNameNosign TEXT,
            $tbProductNameGet TEXT,
            $tbProductPrice DOUBLE,
            $tbProductOldPrice DOUBLE,
            $tbProductVersion INTEGER,  
            $tbProductDiscountSale DOUBLE, 
            $tbProductDiscountPurchase DOUBLE,
            $tbProductWeight DOUBLE,
            $tbProductProductTmplId INTEGER,
            $tbProductImageUrl TEXT,
            $tbProductPurchasePrice DOUBLE,
            $tbProductSaleOK BOOLEAN,
            $tbProductPurchaseOK BOOLEAN,           
            $tbProductAvailableInPos BOOLEAN,
            $tbProductDefaultCode TEXT,
            $tbProductBarcode TEXT,
            $tbProductPosSalesCount DOUBLE,  
            $tbProductFactor DOUBLE
          )
          ''');
    await db.execute('''
          CREATE TABLE $tbPaymentLines (
            $tbPaymentLinesQty INTEGER,
            $tbPaymentLinesPriceUnit DOUBLE,
            $tbPaymentLinesDiscount DOUBLE,
            $tbPaymentLinesProductId INTEGER NOT NULL,
            $tbPaymentLinesUomId INTEGER,
            $tbPaymentLinesDiscountType TEXT,
            $tbPaymentLinesId INTEGER NOT NULL PRIMARY KEY,
            $tbPaymentLinesNote TEXT,
            $tbPaymentLinesTbCartPosition TEXT NOT NULL,
            $tbPaymentLinesProductName TEXT,
            $tbPaymentLinesPromotionProgramId INTEGER,
            $tbPaymentLinesIsPromotion INTEGER,
            $tbPaymentLinesUOMName TEXT,
            $tbPaymentLinesImage TEXT
          )
          ''');
    await db.execute('''
          CREATE TABLE $tbPartner (
            $tbPartnerId INTEGER NOT NULL PRIMARY KEY,
            $tbPartnerName TEXT,
            $tbPartnerDisplayName TEXT,
            $tbPartnerStreet TEXT,
            $tbPartnerPhone TEXT,
            $tbPartnerEmail TEXT,
            $tbPartnerBarcode TEXT,
            $tbPartnerImage TEXT,
            $tbPartnerTaxCode TEXT
          )
          ''');
    await db.execute('''
          CREATE TABLE $tbPriceList (
            $tbPriceListId INTEGER NOT NULL PRIMARY KEY,
            $tbPriceListName TEXT,
            $tbPriceListCurrencyId INTEGER,
            $tbPriceListCurrencyName TEXT,
            $tbPriceListActive BOOLEAN,
            $tbPriceListCompanyId INTEGER,
            $tbPriceListPartnerCateName TEXT,
            $tbPriceListSequence INTEGER,
            $tbPriceListDateStart TEXT,
            $tbPriceListDateEnd TEXT
          )
          ''');

    await db.execute('''
          CREATE TABLE $tbAccountJournal (
            $tbAccountJournalId INTEGER NOT NULL PRIMARY KEY,
            $tbAccountJournalCode TEXT,
            $tbAccountJournalName TEXT,
            $tbAccountJournalType TEXT,
            $tbAccountJournalUpdatePosted BOOLEAN,
            $tbAccountJournalCurrencyId INTEGER,
            $tbAccountJournalDefaultDebitAccountId INTEGER,
            $tbAccountJournalDefaultCreditAccountId INTEGER,
            $tbAccountJournalCompanyId INTEGER,
            $tbAccountJournalCompanyName TEXT,
            $tbAccountJournalJournalUser BOOLEAN,
            $tbAccountJournalProfitAccountId INTEGER,
            $tbAccountJournalLossAccountId INTEGER,
            $tbAccountJournalAmountAuthorizedDiff TEXT,
            $tbAccountJournalDedicatedRefund TEXT
          )
          ''');

    await db.execute('''
          CREATE TABLE $tbSession (
            $tbSessionId INTEGER NOT NULL PRIMARY KEY,
            $tbSessionConfigId INTEGER,
            $tbSessionConfigName TEXT,
            $tbSessionName TEXT,
            $tbSessionUserId TEXT,
            $tbSessionUserName TEXT,
            $tbSessionStartAt TEXT,
            $tbSessionStopAt TEXT,
            $tbSessionState TEXT,
            $tbSessionShowState TEXT,
            $tbSessionSequenceNumber INTEGER,
            $tbSessionLoginNumber INTEGER,
            $tbSessionCashRegisterId INTEGER,
            $tbSessionCashRegisterBalanceStart DOUBLE,
            $tbSessionCashRegisterTotalEntryEncoding INTEGER,
            $tbSessionCashRegisterBalanceEnd INTEGER,
            $tbSessionCashRegisterBalanceEndReal INTEGER,
            $tbSessionCashRegisterDifference INTEGER,
            $tbSessionDateCreated TEXT
          )
          ''');

    await db.execute('''
          CREATE TABLE $tbCompany (
            $tbCompanyId INTEGER NOT NULL PRIMARY KEY,
            $tbCompanyName TEXT,
            $tbCompanyPartnerId INTEGER,
            $tbCompanyEmail TEXT,
            $tbCompanyPhone TEXT,
            $tbCompanyCurrencyId INTEGER,
            $tbCompanyStreet TEXT,
            $tbCompanyLastUpdated TEXT,
            $tbCompanyTransferAccountId INTEGER,
            $tbCompanyWarehouseId INTEGER,
            $tbCompanyPeriodLockDate TEXT,
            $tbCompanyCity TEXT,
            $tbCompanyDistrict TEXT,
            $tbCompanyWard TEXT
          )
          ''');

    await db.execute('''
          CREATE TABLE $tbPayment (
            $tbPaymentName TEXT,
            $tbPaymentAmountPaid DOUBLE,
            $tbPaymentAmountTotal DOUBLE,
            $tbPaymentAmountTax DOUBLE,
            $tbPaymentAmountReturn DOUBLE,
            $tbPaymentDiscount DOUBLE,
            $tbPaymentDiscountType TEXT,
            $tbPaymentDiscountFixed DOUBLE,
            $tbPaymentPosSessionId INTEGER ,
            $tbPaymentPartnerId INTEGER,
            $tbPaymentTaxId INTEGER,
            $tbPaymentUserId TEXT,
            $tbPaymentUid TEXT,
            $tbPaymentSequenceNumber INTEGER, 
            $tbPaymentCreationDate TEXT,
            $tbPaymentTableId TEXT,
            $tbPaymentFloor TEXT,
            $tbPaymentFloorId TEXT,
            $tbPaymentCustomerCount INTEGER,
            $tbPaymentLoyaltyPoints INTEGER,
            $tbPaymentWonPoints INTEGER,
            $tbPaymentSpentPoints INTEGER,
            $tbPaymentTotalPoints INTEGER
          )
          ''');

    await db.execute('''
          CREATE TABLE $tbStatementIds (
            $tbStatementIdsName TEXT,
            $tbStatementIdsStatementId INTEGER,
            $tbStatementIdsAccountId INTEGER,
            $tbStatementIdsJournalId INTEGER,
            $tbStatementIdsAmount DOUBLE,
            $tbStatementIdsPositIon DOUBLE
          )
          ''');

    await db.execute('''
          CREATE TABLE $tbApplicationUser (
            $tbApplicationUserEmail TEXT,
            $tbApplicationUserName TEXT,
            $tbApplicationUserId TEXT NOT NULL PRIMARY KEY,
            $tbApplicationUserUserName TEXT
          )
          ''');

    await db.execute('''
          CREATE TABLE $tbPosConfig (
            $tbPosConfigId INTEGER NOT NULL PRIMARY KEY,
            $tbPosConfigActive INTEGER ,
            $tbPosConfigGroupBy INTEGER ,
            $tbPosConfigIfacePrintAuto INTEGER ,
            $tbPosConfigIfacePrintSkipScreen INTEGER ,
            $tbPosConfigCashControl INTEGER ,
            $tbPosConfigIfaceSplitbill INTEGER ,
            $tbPosConfigIfacePrintbill INTEGER ,
            $tbPosConfigIfaceOrderlineNotes INTEGER ,
            $tbPosConfigIfacePaymentAuto INTEGER ,
            $tbPosConfigIsHeaderOrFooter INTEGER ,
            $tbPosConfigIfaceDiscount INTEGER ,
            $tbPosConfigIfaceDiscountFixed INTEGER ,
            $tbPosConfigDiscountPc DOUBLE ,
            $tbPosConfigIfaceVAT INTEGER ,
            $tbPosConfigVatPc INTEGER ,
            $tbPosConfigIfaceLogo INTEGER ,
            $tbPosConfigIfaceTax INTEGER ,
            $tbPosConfigUseCache INTEGER,     
            $tbPosConfigTaxId INTEGER ,
            $tbPosConfigPriceListId INTEGER,
            $tbPosConfigReceiptHeader TEXT,
            $tbPosConfigReceiptFooter TEXT
          )
          ''');

    await db.execute('''
          CREATE TABLE $tbTax (
            $tbTaxAccountId INTEGER,
            $tbTaxAmount DOUBLE,
            $tbTaxAmountType TEXT,
            $tbTaxCompanyId INTEGER ,
            $tbTaxCompanyName TEXT,
            $tbTaxDescription TEXT,
            $tbTaxId INTEGER NOT NULL PRIMARY KEY,
            $tbTaxName TEXT,
            $tbTaxRefundAccountId INTEGER,
            $tbTaxSequence INTEGER,
            $tbTaxTypeTaxUse TEXT
          )
          ''');

    await db.execute('''
          CREATE TABLE $tbProductPriceList (
            $tbProductPriceListKey TEXT,
            $tbProductPriceListValue DOUBLE
          )
          ''');

    await db.execute('''
          CREATE TABLE $tbPointSale (
            $tbPointSaleId INTEGER NOT NULL PRIMARY KEY,
            $tbPointSaleName TEXT,
            $tbPointSaleNameGet TEXT,
            $tbPointSaleCompanyId INTEGER,
            $tbPointSalePOSSessionUserName TEXT,
            $tbPointSaleLastSessionClosingDate TEXT,
            $tbPointSaleVatPc INTEGER
          )
          ''');

    await db.execute('''
          CREATE TABLE $tbMoneyCart (
            $tbMoneyCartDiscountMethod INTEGER,
            $tbMoneyCartDiscount DOUBLE,
            $tbMoneyCartPosition TEXT NOT NULL PRIMARY KEY,
            $tbMoneyCartPartnerId INTEGER,
            $tbMoneyCartTaxId INTEGER,
            $tbMoneyCartAmountTax DOUBLE
          )
          ''');
  }
}
