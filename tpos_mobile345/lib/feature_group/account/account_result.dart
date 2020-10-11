import 'package:tpos_mobile/src/tpos_apis/models/account.dart';

class AccountResult {
  AccountResult({this.totalItems, this.result});

  List<Account> result;
  int totalItems;
}
