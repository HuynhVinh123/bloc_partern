import 'package:flutter/material.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

enum SaleQuotationState { posted, draft }

class SaleQuotationStateOption {
  SaleQuotationStateOption(
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

  static List<SaleQuotationStateOption> options = [
    SaleQuotationStateOption(
        state: "draft",
        description: S.current.quotation_quotation,
        backgroundColor: Colors.white,
        textColor: Colors.grey[400]),
    SaleQuotationStateOption(
        state: "sent",
        description: S.current.quotation_quotationWasSent,
        backgroundColor: Colors.blue,
        textColor: Colors.blue),
  ];
}
