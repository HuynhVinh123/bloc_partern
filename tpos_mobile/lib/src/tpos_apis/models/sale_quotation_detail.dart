import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/point_sale.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/sale_quotation_price_list.dart';
import 'package:tpos_mobile/src/tpos_apis/models/order_line.dart';

class SaleQuotationDetail {
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
        json['Partner'] != null ? Partner.fromJson(json['Partner']) : null;
    user = json['User'] != null ? ApplicationUser.fromJson(json['User']) : null;
    currency =
        json['Currency'] != null ? Currency.fromJson(json['Currency']) : null;
    company =
        json['Company'] != null ? Company.fromJson(json['Company']) : null;
    priceList = json['PriceList'] != null
        ? SaleQuotationPriceList.fromJson(json['PriceList'])
        : null;
    paymentTerm = json['PaymentTerm'] != null
        ? AccountPaymentTerm.fromJson(json['PaymentTerm'])
        : null;
    tax = json['Tax'];
  }
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

  Map<String, dynamic> toJson() {
    print(validityDate);
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['DateQuotation'] = dateQuotation;
    data['PartnerId'] = partnerId;
    data['AmountTax'] = amountTax;
    data['AmountUntaxed'] = amountUntaxed;
    data['AmountTotal'] = amountTotal;
    data['TaxId'] = taxId;
    data['Discount'] = discount;
    data['DiscountAmount'] = discountAmount;
    data['DecreaseAmount'] = decreaseAmount;
    data['Note'] = note;
    data['State'] = state;
    data['Name'] = name;
    data['CompanyId'] = companyId;
    data['UserId'] = userId;
    data['ConfirmationDate'] = confirmationDate;
    data['PriceListId'] = priceListId == 0 ? 1 : priceListId;
    data['CurrencyId'] = currencyId;
    data['ClientOrderRef'] = clientOrderRef;
    data['PaymentTermId'] = paymentTermId;
    data['ValidityDate'] = validityDate;
    data['InvoiceStatus'] = invoiceStatus;
    data['InvoiceCount'] = invoiceCount;
    data['InvoiceIds'] = invoiceIds;

    if (partner != null) {
      data['Partner'] = partner.toJson(true);
    }

    if (user != null) {
      data['User'] = user.toJson();
    }
    if (currency != null) {
      data['Currency'] = currency.toJson();
    }
    if (company != null) {
      data['Company'] = company.toJson();
    }
    if (priceList != null) {
      data['PriceList'] = priceList.toJson();
    }
    if (paymentTerm != null) {
      data['PaymentTerm'] = paymentTerm.toJson();
    }
    data['Tax'] = tax;

    if (orderLines != null && orderLines.isNotEmpty) {
      data['OrderLines'] =
          orderLines.map((value) => value.toJson(true)).toList();
    }
    return data;
  }
}
