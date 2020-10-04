import 'package:tpos_mobile/src/tpos_apis/models/account.dart';

class AccountResult {
  List<Account> result;
  int totalItems;

  AccountResult({this.totalItems, this.result});
}
