import 'package:tpos_api_client/src/models/entities/account.dart';
import 'package:tpos_api_client/src/models/entities/account_payment_type_base/account_result.dart';
import 'package:tpos_api_client/src/models/entities/company.dart';

abstract class AccountPaymentTypeApi {
  // get danh sách loại phiếu thu
  Future<AccountResult> getTypeAccountAccounts(
      {int page, int pageSize, int skip, int take, int companyId});

  // delete danh sách loại phiếu chi
  Future<bool> deleteTypeAccountAccountSale(int id);

  // get danh sách loại phiếu chi
  Future<AccountResult> getTypeAccountAccountSales(
      {int page, int pageSize, int skip, int take, int companyId});

  // get detail thông tin loại phiếu chi
  Future<Account> getDetailAccountSale(int id);

  // Cập nhật thông tin loại phiếu chi
  Future<bool> updateInfoTypeAccountSale(Account account);

  // get default thông tin loại phiếu chi
  Future<Account> getDefaultAccountSale();

  // thêm thông tin loại phiếu chi
  Future<Account> addInfoTypeAccountSale(Account account);

  // get default thông tin loại phiếu thu
  Future<Account> getDefaultAccount();

  // Lây danh sách công ty cho loại phiếu chi
  Future<List<Company>> getCompanies(String keySearch);
}
