/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

class PaymentMethod {
  int id;
  String code;
  String name;
  String type;
  bool updatePosted;
  int currencyId;
  int defaultCreditAccountId;
  int companyId;
  String companyName;
  bool journalUser;
  int profitAccountId;
  int lossAccountId;
  String amountAuthorizedDiff;
  String dedicatedRefund;

  PaymentMethod(
      {this.id,
      this.code,
      this.name,
      this.type,
      this.updatePosted,
      this.currencyId,
      this.defaultCreditAccountId,
      this.companyId,
      this.companyName,
      this.journalUser,
      this.profitAccountId,
      this.lossAccountId,
      this.amountAuthorizedDiff,
      this.dedicatedRefund});

  factory PaymentMethod.fromJson(Map<String, dynamic> jsonMap) {
    return new PaymentMethod(
      id: jsonMap["Id"],
      code: jsonMap["code"],
      name: jsonMap["name"],
      type: jsonMap["type"],
      updatePosted: jsonMap["updatePosted"],
      currencyId: jsonMap["currencyId"],
      defaultCreditAccountId: jsonMap["defaultCreditAccountId"],
      companyId: jsonMap["companyId"],
      companyName: jsonMap["companyName"],
      journalUser: jsonMap["journalUser"],
      profitAccountId: jsonMap["profitAccountId"],
      lossAccountId: jsonMap["lossAccountId"],
      amountAuthorizedDiff: jsonMap["amountAuthorizedDiff"],
      dedicatedRefund: jsonMap["dedicatedRefund"],
    );
  }
}
