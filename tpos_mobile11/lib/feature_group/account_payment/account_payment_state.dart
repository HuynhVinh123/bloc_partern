import 'package:flutter/material.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

enum AccountPaymentState { posted, draft }

class AccountPaymentStateOption {
  AccountPaymentStateOption(
      {this.state,
      this.description,
      this.backgroundColor,
      this.textColor,
      this.isSelected = false});

  String state;
  String description;
  Color backgroundColor;
  Color textColor;
  bool isSelected;

  static List<AccountPaymentStateOption> options = [
    AccountPaymentStateOption(
        state: "draft",
        description: S.current.draft,
        backgroundColor: Colors.white,
        textColor: Colors.grey[400]),
    AccountPaymentStateOption(
        state: "posted",
        description: S.current.hasEnteredTheBook,
        backgroundColor: Colors.blue,
        textColor: Colors.blue),
  ];
}
