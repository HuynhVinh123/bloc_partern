import 'package:tpos_api_client/tpos_api_client.dart';

class AccountResult {
  AccountResult({this.totalItems, this.result});

  List<Account> result;
  int totalItems;
}
