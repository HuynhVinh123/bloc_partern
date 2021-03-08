import 'package:tpos_api_client/src/models/entities/account.dart';
import 'package:tpos_api_client/src/models/entities/account_journal.dart';
import 'package:tpos_api_client/src/models/entities/account_payment.dart';
import 'package:tpos_api_client/src/models/entities/account_payment_base/account_payment_base_model.dart';
import 'package:tpos_api_client/src/models/entities/partner.dart';
import 'package:tpos_api_client/src/models/entities/partner_contact.dart';

abstract class AccountPaymentApi {
  // Lấy dạnh sách phiếu thu
  Future<AccountPaymentBaseModel> getAccountPayments(
      {String keySearch,
      List<String> filterStatus,
      String fromDate,
      String toDate,
      int accountId,
      int take,
      int skip});

  // Delete accountPayment
  Future<void> deleteAccountPayment(int id);

  // get info accountPayment
  Future<AccountPayment> getInfoAccountPayment(int id);

  // confirm accountPayment
  Future<void> confirmAccountPayment(int id);

  // cancel accountPayment
  Future<void> cancelAccountPayment(int id);

  // get accountJournal with AccountPayment
  Future<List<AccountJournal>> getAccountJournalWithAccountPayments();

  //get Default accountPayment
  Future<AccountPayment> getDefaultAccountPayment();

  // update accountPayment
  Future<void> updateAccountPayment(AccountPayment accountPayment);

  // add accountPayment
  Future<AccountPayment> addAccountPayment(AccountPayment accountPayment);

  // Lấy dạnh sách phiếu chi
  Future<AccountPaymentBaseModel> getAccountPaymentSales(
      {String keySearch,
      List<String> filterStatus,
      String fromDate,
      String toDate,
      int accountId,
      int take,
      int skip});

  //get Default accountPaymentSale
  Future<AccountPayment> getDefaultAccountPaymentSale();

  // get accounts
  Future<List<Account>> getAccounts({String keySearch});

  // get accounts cho phiếu chi
  Future<List<Account>> getAccountSales({String keySearch});

  // get accounts
  Future<List<Account>> getTypeAccounts({String keySearch});

  // get type accounts cho phiếu chi
  Future<List<Account>> getTypeAccountSales({String keySearch});

  // get list contact for acount payment
  Future<List<Partner>> getContactPartners(String keySearch);

  // get  contact default
  Future<PartnerContact> getContactDefault();

  //add contact partner
  Future<PartnerContact> addContactPartner(PartnerContact partner);
}
