import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/point_sale.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/sale_quotation_price_list.dart';

import 'package:tpos_mobile/src/tpos_apis/models/currency.dart';
import 'package:tpos_mobile/src/tpos_apis/models/order_line.dart';

import '../tpos_models.dart';

class SaleQuotationDetail {
  String odataContext;
  int id;
  String dateQuotation;
  int partnerId;
  double amountTax;
  double amountUntaxed;
  double amountTotal;
  String taxId;
  double discount;
  double discountAmount;
  double decreaseAmount;
  String note;
  String state;
  String name;
  int companyId;
  String userId;
  String confirmationDate;
  int priceListId;
  int currencyId;
  String clientOrderRef;
  int paymentTermId;
  String validityDate;
  String invoiceStatus;
  int invoiceCount;
  List<int> invoiceIds;
  Partner partner;
  ApplicationUser user;
  Currency currency;
  Company company;
  SaleQuotationPriceList priceList;
  AccountPaymentTerm paymentTerm;
  Tax tax;
  List<OrderLines> orderLines = [];

  SaleQuotationDetail(
      {this.odataContext,
      this.id,
      this.dateQuotation,
      this.partnerId,
      this.amountTax,
      this.amountUntaxed,
      this.amountTotal,
      this.taxId,
      this.discount,
      this.discountAmount,
      this.decreaseAmount,
      this.note,
      this.state,
      this.name,
      this.companyId,
      this.userId,
      this.confirmationDate,
      this.priceListId,
      this.currencyId,
      this.clientOrderRef,
      this.paymentTermId,
      this.validityDate,
      this.invoiceStatus,
      this.invoiceCount,
      this.invoiceIds,
      this.partner,
      this.user,
      this.currency,
      this.company,
      this.priceList,
      this.paymentTerm,
      this.tax,
      this.orderLines});

  SaleQuotationDetail.fromJson(Map<String, dynamic> json) {
    print(json['DateQuotation']);
    id = json['Id'];
    dateQuotation = json['DateQuotation'];
    partnerId = json['PartnerId'];
    amountTax = json['AmountTax'] != null
        ? double.parse(json['AmountTax'].toString())
        : 0;
    amountUntaxed = json['AmountUntaxed'] != null
        ? double.parse(json['AmountUntaxed'].toString())
        : 0;
    amountTotal = json['AmountTotal'] != null
        ? double.parse(json['AmountTotal'].toString())
        : null;
    taxId = json['TaxId'];
    discount = json['Discount'];
    discountAmount = json['DiscountAmount'];
    decreaseAmount = json['DecreaseAmount'];
    note = json['Note'];
    state = json['State'];
    name = json['Name'];
    companyId = json['CompanyId'];
    userId = json['UserId'];
    confirmationDate = json['ConfirmationDate'];
    priceListId = json['PriceListId'];
    currencyId = json['CurrencyId'];
    clientOrderRef = json['ClientOrderRef'];
    paymentTermId = json['PaymentTermId'];
    validityDate = json['ValidityDate'];
    invoiceStatus = json['InvoiceStatus'];
    invoiceCount = json['InvoiceCount'];
    invoiceIds = json['InvoiceIds'].cast<int>();
    partner =
        json['Partner'] != null ? new Partner.fromJson(json['Partner']) : null;
    user = json['User'] != null ? ApplicationUser.fromJson(json['User']) : null;
    currency = json['Currency'] != null
        ? new Currency.fromJson(json['Currency'])
        : null;
    company =
        json['Company'] != null ? new Company.fromJson(json['Company']) : null;
    priceList = json['PriceList'] != null
        ? new SaleQuotationPriceList.fromJson(json['PriceList'])
        : null;
    paymentTerm = json['PaymentTerm'] != null
        ? new AccountPaymentTerm.fromJson(json['PaymentTerm'])
        : null;
    tax = json['Tax'];
  }

  Map<String, dynamic> toJson() {
    print(this.validityDate);
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['DateQuotation'] = this.dateQuotation;
    data['PartnerId'] = this.partnerId;
    data['AmountTax'] = this.amountTax;
    data['AmountUntaxed'] = this.amountUntaxed;
    data['AmountTotal'] = this.amountTotal;
    data['TaxId'] = this.taxId;
    data['Discount'] = this.discount;
    data['DiscountAmount'] = this.discountAmount;
    data['DecreaseAmount'] = this.decreaseAmount;
    data['Note'] = this.note;
    data['State'] = this.state;
    data['Name'] = this.name;
    data['CompanyId'] = this.companyId;
    data['UserId'] = this.userId;
    data['ConfirmationDate'] = this.confirmationDate;
    data['PriceListId'] = this.priceListId == 0 ? 1 : priceListId;
    data['CurrencyId'] = this.currencyId;
    data['ClientOrderRef'] = this.clientOrderRef;
    data['PaymentTermId'] = this.paymentTermId;
    data['ValidityDate'] = this.validityDate;
    data['InvoiceStatus'] = this.invoiceStatus;
    data['InvoiceCount'] = invoiceCount;
    data['InvoiceIds'] = invoiceIds;

    if (partner != null) {
      data['Partner'] = this.partner.toJson();
    }

    if (user != null) {
      data['User'] = this.user.toJson();
    }
    if (currency != null) {
      data['Currency'] = this.currency.toJson();
    }
    if (company != null) {
      data['Company'] = this.company.toJson();
    }
    if (priceList != null) {
      data['PriceList'] = this.priceList.toJson();
    }
    if (paymentTerm != null) {
      data['PaymentTerm'] = this.paymentTerm.toJson();
    }
    data['Tax'] = this.tax;

    if (orderLines != null && this.orderLines.isNotEmpty) {
      data['OrderLines'] =
          this.orderLines.map((value) => value.toJson(true)).toList();
    }
    return data;
  }
}
