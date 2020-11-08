import 'package:tpos_mobile/feature_group/pos_order/models/payment.dart';

class PrintPostData {
  PrintPostData(
      {this.companyName,
      this.companyAddress,
      this.companyPhone,
      this.partnerName,
      this.partnerPhone,
      this.partnerAddress,
      this.dateSale,
      this.employee,
      this.lines,
      this.amountTotal,
      this.amountPaid,
      this.amountReturn,
      this.namePayment,
      this.amountBeforeTax,
      this.amountTax,
      this.tax,
      this.discount,
      this.amountDiscount,
      this.discountCash,
      this.header,
      this.footer,
      this.isLogo,
      this.isHeaderOrFooter,
      this.imageLogo,
      this.companyId});

  PrintPostData.fromJson(Map<String, dynamic> json) {
    companyName = json['companyName'];
    companyAddress = json['companyAddress'];
    companyPhone = json['companyPhone'];
    partnerName = json['partnerName'];
    partnerPhone = json['partnerPhone'];
    partnerAddress = json['partnerAddress'];
    dateSale = json['dateSale'];
    employee = json['employee'];
//    lines = json['lines'];
    amountTotal = json['amountTotal'];
    amountPaid = json['amountPaid'];
    amountReturn = json['amountReturn'];
    namePayment = json['namePayment'];
    amountTax = json['amountTax'];
    amountBeforeTax = json['amountBeforeTax'];
    tax = json['tax'];
    discount = json['discount'];
    amountDiscount = json['amountDiscount'];
    discountCash = json['discountCash'];
  }

  String header;
  String footer;
  String companyName;
  int companyId;
  String companyAddress;
  String companyPhone;
  String partnerName;
  String partnerPhone;
  String partnerAddress;
  String dateSale;
  String employee;
  List<Lines> lines = [];
  double amountTotal;
  double amountPaid;
  double amountReturn;
  String namePayment;

  double amountBeforeTax;
  double amountTax;
  double tax;
  double discount;
  double amountDiscount;
  double discountCash;
  bool isLogo;
  bool isHeaderOrFooter;
  String imageLogo;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['companyName'] = companyName;
    data['companyAddress'] = companyAddress;
    data['companyPhone'] = companyPhone;
    data['partnerName'] = partnerName;
    data['partnerPhone'] = partnerPhone;
    data['partnerAddress'] = partnerAddress;
    data['dateSale'] = dateSale;
    data['employee'] = employee;
//    data['lines'] = this.lines;
    data['amountTotal'] = amountTotal;
    data['amountPaid'] = amountPaid;
    data['amountReturn'] = amountReturn;
    data['namePayment'] = namePayment;
    data['amountTax'] = amountTax;
    data['amountBeforeTax'] = amountBeforeTax;
    data['tax'] = tax;
    data['discount'] = discount;
    data['amountDiscount'] = amountDiscount;
    data['discountCash'] = discountCash;

    return data;
  }
}
