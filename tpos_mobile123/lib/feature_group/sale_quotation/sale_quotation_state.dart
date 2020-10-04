import 'package:flutter/material.dart';

enum SaleQuotationState { posted, draft }

class SaleQuotationStateOption {
  String state;
  String description;
  Color backgroundColor;
  Color textColor;
  bool isSelected;

  SaleQuotationStateOption(
      {this.state,
      this.description,
      this.backgroundColor,
      this.textColor,
      this.isSelected = false});

  static List<SaleQuotationStateOption> options = [
    SaleQuotationStateOption(
        state: "draft",
        description: "Báo giá",
        backgroundColor: Colors.white,
        textColor: Colors.grey[400]),
    SaleQuotationStateOption(
        state: "sent",
        description: "Báo giá đã gửi",
        backgroundColor: Colors.blue,
        textColor: Colors.blue),
  ];
}
