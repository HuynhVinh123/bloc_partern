import 'package:intl/intl.dart';

class PaymentInfoContent {
  int accountPaymentId;
  double amount;
  String currency;
  DateTime date;
  String journalName;
  int moveId;

  String name;
  int paymentId;
  String paymentPartnerType;
  String ref;

  PaymentInfoContent(
      this.accountPaymentId,
      this.amount,
      this.currency,
      this.date,
      this.journalName,
      this.moveId,
      this.name,
      this.paymentId,
      this.paymentPartnerType,
      this.ref);

  PaymentInfoContent.fromJson(Map<String, dynamic> jsonMap) {
    accountPaymentId = jsonMap["AccountPaymentId"];
    amount = jsonMap["Amount"];
    currency = jsonMap["Currency"];
    if (jsonMap["Date"] != null) {
      date = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(jsonMap["Date"]);
    }

    journalName = jsonMap["JournalName"];
    moveId = jsonMap["MoveId"];
    name = jsonMap["Name"];
    paymentId = jsonMap["PaymentId"];
    paymentPartnerType = jsonMap["PaymentPartnerType"];
    ref = jsonMap["Ref"];
  }
}
