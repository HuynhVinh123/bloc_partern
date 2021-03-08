import 'package:tpos_api_client/src/models/entities/account_payment.dart';

class AccountPaymentBaseModel {
  AccountPaymentBaseModel({this.totalItems, this.result});
  List<AccountPayment> result;
  int totalItems;
}
