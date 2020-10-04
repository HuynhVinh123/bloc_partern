import 'package:flutter/material.dart';

enum PosOrderSate {
  draft,
  paid,
  done,
  cancel,
  invoiced,
}

class PosOrderSateOption {
  PosOrderSateOption(
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

  static List<PosOrderSateOption> options = [
    PosOrderSateOption(
        state: "draft",
        description: "Mới",
        backgroundColor: Colors.white,
        textColor: Colors.grey),
    PosOrderSateOption(
        state: "paid",
        description: "Đã thanh toán",
        backgroundColor: Colors.blue,
        textColor: Colors.blue),
    PosOrderSateOption(
        state: "done",
        description: "Đã ghi sổ",
        backgroundColor: Colors.orange,
        textColor: Colors.green),
    PosOrderSateOption(
        state: "cancel",
        description: "Hủy bỏ",
        backgroundColor: Colors.orange,
        textColor: Colors.red),
    PosOrderSateOption(
        state: "invoiced",
        description: "Đã hóa đơn",
        backgroundColor: Colors.orange,
        textColor: Colors.orange),
  ];

  static PosOrderSateOption getPosOrderSateOption({String state}) {
    return options.firstWhere((f) => f.state.toString().contains(state ?? ""),
        orElse: () => options.last);
  }
}
