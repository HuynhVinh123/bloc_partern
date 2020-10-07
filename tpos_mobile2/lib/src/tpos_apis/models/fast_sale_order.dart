import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/models/ShipExtra.dart';
import 'package:tpos_mobile/src/tpos_apis/models/account.dart';
import 'package:tpos_mobile/src/tpos_apis/models/account_journal.dart';

import 'package:tpos_mobile/src/tpos_apis/models/delivery_carrier.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_sale_order_line.dart';
import 'package:tpos_mobile/src/tpos_apis/models/journal.dart';

import 'package:tpos_mobile/src/tpos_apis/models/ship_receiver.dart';
import 'package:tpos_mobile/src/tpos_apis/models/ship_service_extra.dart';
import 'package:tpos_mobile/src/tpos_apis/models/stock_warehouse.dart';

class FastSaleOrder {
  /// Có đang được chọn hay không? mặc đinh là không
  bool isSelected = false;
  int id;
  int taxId;
  int accountId;
  double weightTotal;
  String userName;
  String deliveryNote;
  int paymentJournalId;
  double paymentAmount;
  double shipWeight;
  double oldCredit;
  double newCredit;

  ///Tiền đặt cọc
  double amountDeposit;
  bool notModifyPriceFromSO;
  ShipReceiver shipReceiver;
  String shipServiceId;
  String shipServiceName;
  List<FastSaleOrderLine> orderLines;
  String address;
  String phone;
  String showState;
  String name;
  int partnerId;
  String partnerDisplayName;
  int priceListId;
  double amountTotal;
  String userId;
  DateTime dateInvoice;
  String state;
  int companyId;
  String comment;
  int warehouseId;
  List<String> saleOnlineIds;
  List<String> saleOnlineNames;
  double residual;
  String type;
  int refundOrderId;
  int journalId;
  String number;
  String partnerNameNoSign;

  /// Phí giao hàng
  double deliveryPrice;
  int carrierId;
  String carrierName;
  double cashOnDelivery;
  String trackingRef;
  String shipStatus;
  String saleOnlineName;
  double discount;
  double discountAmount;
  double decreaseAmount;

  /// Nhân viên giao hàng- Read from json Only
  String deliver;
  String shipPaymentStatus;
  String companyName;
  String carrierDeliveryType;
  String partnerPhone;
  String partnerName;
  String trackingRefSort;
  String receiverAddress;
  String receiverName;
  String receiverPhone;
  String receiverNote;
  DateTime receiverDate;

  /// Tổng tiền chưa thuế
  double amountUntaxed;

  Account account;

  /// Kho hàng
  StockWareHouse wareHouse;

  /// Người lập hóa đơn
  ApplicationUser user;

  /// Bảng giá
  ProductPrice priceList;

  /// Công ty
  Company company;

  /// Khách hàng
  Partner partner;

  /// Đơn vị giao hàng
  DeliveryCarrier carrier;

  /// Không biết là gì
  Journal journal;

  /// Ca giao hàng
  ShipExtra shipExtra;

  ///Tùy chọn thêm trong dịch vụ giao hàng
  ///Ví dụ: Gửi hàng tại điểm
  ///Khai giá hàng hóa
  ///...
  List<ShipServiceExtra> shipServiceExtras;

  /// Phương thức thanh toán
  AccountJournal paymentJournal;

  /// Phí giao hàng của đối tác, Được tính bởi đối tác giao hàng
  double customerDeliveryPrice;

  /// Khai giá hàng hóa
  double shipInsuranceFee;

  /// Tiền thuế
  double amountTax;

  /// Ngày tạo
  DateTime dateCreated;

  DateTime deliveryDate;

  // Nợ cũ
  double previousBalance;

  /// Doanh số
  double revenue;

  String shipServiceExtrasText;

  List<ShipServiceExtra> shipServiceExtraFromText;

  /// Có phải tạo từ  sản phẩm mặc định hay không
  bool isProductDefault;
  String trackingArea;

  /// Thông tin địa chỉ giao hàng

  ///
  ///
  ///Thông tin người nhận
  ///
  ///

  bool get isStepDraft => true;
  bool get isStepConfirm => this.state == "open" || this.state == "paid";
  bool get isStepPay => this.state == "paid";
  bool get isStepCompleted => this.state == "paid";

  // Không có  trong json
  double get productQuantity {
    if (orderLines != null && this.orderLines.isNotEmpty) {
      return this
          .orderLines
          .map((f) => f.productUOMQty)
          .reduce((f1, f2) => f1 + f2);
    }
    return 0;
  }

  double get subTotal =>
      this.orderLines?.map((f) => f.priceSubTotal)?.reduce((a, b) => a + b);

  FastSaleOrder(
      {this.isSelected,
      this.id,
      this.taxId,
      this.accountId,
      this.weightTotal,
      this.userName,
      this.deliveryNote,
      this.paymentJournalId,
      this.paymentAmount,
      this.shipWeight,
      this.oldCredit,
      this.newCredit,
      this.amountDeposit,
      this.notModifyPriceFromSO,
      this.shipReceiver,
      this.shipServiceId,
      this.shipServiceName,
      this.orderLines,
      this.address,
      this.phone,
      this.showState,
      this.name,
      this.partnerId,
      this.partnerDisplayName,
      this.priceListId,
      this.amountTotal,
      this.userId,
      this.dateInvoice,
      this.deliveryDate,
      this.state,
      this.companyId,
      this.comment,
      this.warehouseId,
      this.saleOnlineIds,
      this.saleOnlineNames,
      this.residual,
      this.type,
      this.refundOrderId,
      this.journalId,
      this.number,
      this.partnerNameNoSign,
      this.deliveryPrice,
      this.carrierId,
      this.carrierName,
      this.cashOnDelivery,
      this.trackingRef,
      this.shipStatus,
      this.saleOnlineName,
      this.discount,
      this.discountAmount,
      this.decreaseAmount,
      this.deliver,
      this.shipPaymentStatus,
      this.companyName,
      this.carrierDeliveryType,
      this.partnerPhone,
      this.wareHouse,
      this.user,
      this.priceList,
      this.company,
      this.partner,
      this.carrier,
      this.journal,
      this.paymentJournal,
      this.partnerName,
      this.amountUntaxed,
      this.customerDeliveryPrice,
      this.shipInsuranceFee,
      this.shipExtra,
      this.account,
      this.amountTax,
      this.dateCreated,
      this.shipServiceExtras,
      this.receiverAddress,
      this.receiverName,
      this.trackingRefSort,
      this.receiverPhone,
      this.previousBalance,
      this.revenue,
      this.receiverDate,
      this.receiverNote,
      this.shipServiceExtrasText,
      this.isProductDefault,
      this.trackingArea});

  FastSaleOrder.fromJson(Map<String, dynamic> jsonMap) {
    if (jsonMap["DateInvoice"] != null) {
      String unixTimeStr =
          RegExp(r"(?<=Date\()\d+").stringMatch(jsonMap["DateInvoice"]);

      if (unixTimeStr != null && unixTimeStr.isNotEmpty) {
        int unixTime = int.parse(unixTimeStr);
        dateInvoice = DateTime.fromMillisecondsSinceEpoch(unixTime);
      } else {
        if (jsonMap["DateInvoice"] != null) {
          dateInvoice = DateTime.parse(jsonMap["DateInvoice"]);
        }
      }
    }

    if (jsonMap["DeliveryDate"] != null) {
      String unixTimeStr =
          RegExp(r"(?<=Date\()\d+").stringMatch(jsonMap["DeliveryDate"]);

      if (unixTimeStr != null && unixTimeStr.isNotEmpty) {
        int unixTime = int.parse(unixTimeStr);
        deliveryDate = DateTime.fromMillisecondsSinceEpoch(unixTime);
      } else {
        if (jsonMap["DateInvoice"] != null) {
          deliveryDate = DateTime.parse(jsonMap["DeliveryDate"]);
        }
      }
    }

    if (jsonMap["ReceiverDate"] != null) {
      String unixTimeStr =
          RegExp(r"(?<=Date\()\d+").stringMatch(jsonMap["ReceiverDate"]);

      if (unixTimeStr != null && unixTimeStr.isNotEmpty) {
        int unixTime = int.parse(unixTimeStr);
        receiverDate = DateTime.fromMillisecondsSinceEpoch(unixTime);
      } else {
        if (jsonMap["ReceiverDate"] != null) {
          receiverDate = DateTime.parse(jsonMap["ReceiverDate"]);
        }
      }
    }

    String unixDateCreated =
        RegExp(r"(?<=Date\()\d+").stringMatch(jsonMap["DateCreated"] ?? "");
    if (unixDateCreated != null && unixDateCreated.isNotEmpty) {
      int unixTime = int.parse(unixDateCreated);
      dateCreated = DateTime.fromMillisecondsSinceEpoch(unixTime);
    } else {
      if (jsonMap["DateCreated"] != null) {
        dateCreated = DateTime.parse(jsonMap['DateCreated']);
      }
    }

    id = jsonMap["Id"];
    partnerId = jsonMap['PartnerId'];
    accountId = jsonMap["AccountId"];
    partnerNameNoSign = jsonMap["PartnerNameNoSign"];
    partnerDisplayName = jsonMap["PartnerDisplayName"];
    discount = jsonMap['Discount']?.toDouble();
    discountAmount = jsonMap['DiscountAmount']?.toDouble();
    decreaseAmount = jsonMap['DecreaseAmount']?.toDouble();
    weightTotal = jsonMap['WeightTotal'];
    userId = jsonMap['UserId'];
    userName = jsonMap['UserName'];
    number = jsonMap["Number"];
    companyId = jsonMap['CompanyId'];
    comment = jsonMap['Comment'];
    type = jsonMap['Type'];
    deliveryPrice = jsonMap['DeliveryPrice']?.toDouble();
    carrierId = jsonMap['CarrierId'];
    carrierName = jsonMap["CarrierName"];
    carrierDeliveryType = jsonMap["CarrierDeliveryType"];
    trackingRef = jsonMap["TrackingRef"];
    deliveryNote = jsonMap['DeliveryNote'];
    cashOnDelivery = jsonMap['CashOnDelivery']?.toDouble();
    paymentJournalId = jsonMap['PaymentJournalId'];
    paymentAmount = jsonMap['PaymentAmount']?.toDouble();
    shipWeight = jsonMap['ShipWeight']?.toDouble();
    oldCredit = jsonMap['OldCredit']?.toDouble();
    newCredit = jsonMap['NewCredit']?.toDouble();
    name = jsonMap["Name"];
    partnerName = jsonMap["ParterName"];
    shipStatus = jsonMap["ShipStatus"];
    shipPaymentStatus = jsonMap["ShipPaymentStatus"];
    amountTotal = jsonMap["AmountTotal"];
    showState = jsonMap["ShowState"];
    address = jsonMap["Address"];
    phone = jsonMap["Phone"];
    state = jsonMap["State"];
    partnerPhone = jsonMap["PartnerPhone"];
    residual = jsonMap["Residual"];

    trackingRefSort = jsonMap['TrackingRefSort'];
    trackingArea = jsonMap['TrackingArea'];

    if (jsonMap["AmountDeposit"] != null) {
      amountDeposit = (jsonMap['AmountDeposit']).toDouble();
    }

    notModifyPriceFromSO = jsonMap['NotModifyPriceFromSO'];
    if (jsonMap["Ship_Receiver"] != null) {
      shipReceiver = ShipReceiver.fromJson(jsonMap["Ship_Receiver"]);
    }

    shipServiceId = jsonMap['Ship_ServiceId'];
    shipServiceName = jsonMap['Ship_ServiceName'];
    if (jsonMap['OrderLines'] != null) {
      orderLines = new List<FastSaleOrderLine>();
      jsonMap['OrderLines'].forEach((v) {
        orderLines.add(new FastSaleOrderLine.fromJson(v));
      });
    }

    if (jsonMap["Account"] != null) {
      this.account = Account.fromJson(jsonMap["Account"]);
    }

    // Convert warehouse
    if (jsonMap["Warehouse"] != null) {
      this.wareHouse = StockWareHouse.fromJson(jsonMap["Warehouse"]);
    }

    // Convert User
    if (jsonMap["User"] != null) {
      user = ApplicationUser.fromJson(jsonMap["User"]);
    }

    // Convert User
    if (jsonMap["PriceList"] != null) {
      this.priceList = ProductPrice.fromJson(jsonMap["PriceList"]);
    }
    // Convert Company
    if (jsonMap["Company"] != null) {
      this.company = Company.fromJson(jsonMap["Company"]);
    }

    // Convert Journal
    if (jsonMap["Journal"] != null) {
      this.journal = Journal.fromJson(jsonMap["Journal"]);
    }
    //PaymentJournal
    if (jsonMap["PaymentJournal"] != null) {
      this.paymentJournal = AccountJournal.fromJson(jsonMap["PaymentJournal"]);
    }

    // Partner
    if (jsonMap["Partner"] != null) {
      this.partner = Partner.fromJson(jsonMap["Partner"]);
    }
    // Carrier
    if (jsonMap["Carrier"] != null) {
      this.carrier = DeliveryCarrier.fromJson(jsonMap["Carrier"]);
    }

    if (jsonMap["Ship_Extras"] != null) {
      this.shipExtra = ShipExtra.fromJson(jsonMap["Ship_Extras"]);
    }

    if (jsonMap["Ship_ServiceExtras"] != null) {
      shipServiceExtras = (jsonMap["Ship_ServiceExtras"] as List)
          .map((f) => ShipServiceExtra.fromJson(f))
          .toList();
    }
    this.amountUntaxed = jsonMap["AmountUntaxed"]?.toDouble();
    this.customerDeliveryPrice = jsonMap["CustomerDeliveryPrice"]?.toDouble();
    this.shipInsuranceFee = jsonMap["Ship_InsuranceFee"]?.toDouble();
    this.amountTax = jsonMap["AmountTax"]?.toDouble();
    this.decreaseAmount = jsonMap["DecreaseAmount"]?.toDouble();

    this.receiverName = jsonMap["ReceiverName"];
    this.receiverAddress = jsonMap["ReceiverAddress"];
    this.receiverPhone = jsonMap["ReceiverPhone"];
    this.receiverNote = jsonMap['ReceiverNote'];

    this.previousBalance = jsonMap["PreviousBalance"]?.toDouble();
    this.revenue = jsonMap["Revenue"]?.toDouble();
    this.deliver = jsonMap["Deliver"];
    this.shipServiceExtrasText = jsonMap["Ship_ServiceExtrasText"];

    if (this.shipServiceExtrasText != null) {
      this.shipServiceExtraFromText =
          (jsonDecode(shipServiceExtrasText) as List)
              .map((f) => ShipServiceExtra.fromJson(f))
              .toList();
    }

    this.isProductDefault = jsonMap["IsProductDefault"] as bool;
  }

  Map<String, dynamic> toJson({bool removeIfNull}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data["AccountId"] = this.accountId;
    data['PartnerId'] = this.partnerId;
    data['CompanyId'] = this.companyId;
    data['CarrierId'] = this.carrierId;
    data['JournalId'] = this.journalId;
    data["PriceListId"] = this.priceListId;
    data["PaymentJournalId"] = this.paymentJournalId;
    data["WarehouseId"] = this.warehouseId;
    data["UserId"] = this.userId;
    data['Ship_ServiceId'] = this.shipServiceId;
    data["TaxId"] = this.taxId;

    if (this.saleOnlineIds != null) {
      data["SaleOnlineIds"] = this.saleOnlineIds.toList();
    }

    data["Account"] = this.account?.toJson(removeIfNull);
    data["Warehouse"] = this.wareHouse?.toJson(removeIfNull);
    data["User"] = this.user?.toJson(removeIfNull);
    data["PriceList"] = this.priceList?.toJson(removeIfNull);
    data["Company"] = this.company?.toJson();
    data["Journal"] = this.journal?.toJson(removeIfNull);
    data["PaymentJournal"] = this.paymentJournal?.toJson(removeIfNull);
    data["Partner"] = this.partner?.toJson(removeIfNull);
    data["Carrier"] = this.carrier?.toJson(removeIfNull);
    data["Ship_Extras"] = this.shipExtra?.toJson(removeIfNull);
    data["Ship_ServiceExtras"] = this
        .shipServiceExtras
        ?.map((f) => f.toJson(removeIfNull: removeIfNull))
        ?.toList();

    data['WeightTotal'] = this.weightTotal;
    data['UserId'] = this.userId;
    data['UserName'] = this.userName;
    data['DateInvoice'] = dateInvoice?.toIso8601String();
    data["DateCreated"] = dateCreated?.toIso8601String();
    data['Comment'] = this.comment;
    data['Type'] = this.type;

    data['ShipWeight'] = this.shipWeight;
    data["AmountDeposit"] = this.amountDeposit;
    data['DeliveryPrice'] = this.deliveryPrice;
    data['DeliveryNote'] = this.deliveryNote;
    data['CashOnDelivery'] = this.cashOnDelivery;
    data["DeliveryNote"] = this.deliveryNote;

    data["AmountTotal"] = this.amountTotal;
    data['PaymentAmount'] = this.paymentAmount;
    data["AmountUntaxed"] = this.amountUntaxed;
    data['Discount'] = this.discount;
    data['DiscountAmount'] = this.discountAmount;

    data['OldCredit'] = this.oldCredit;
    data['NewCredit'] = this.newCredit;
    data['NotModifyPriceFromSO'] = this.notModifyPriceFromSO;
    if (this.shipReceiver != null) {
      data['Ship_Receiver'] =
          this.shipReceiver.toJson(removeIfNull: removeIfNull);
    }
    data["Residual"] = residual;
    data['Ship_ServiceName'] = this.shipServiceName;
    if (this.orderLines != null) {
      data['OrderLines'] = this
          .orderLines
          .map((v) => v.toJson(removeIfNull: removeIfNull))
          .toList();
    }

    data["CustomerDeliveryPrice"] = this.customerDeliveryPrice;
    data["Ship_InsuranceFee"] = this.shipInsuranceFee;
    data["State"] = this.state;
    data["ShowState"] = this.showState;
    data["AmountTax"] = this.amountTax;
    data["DecreaseAmount"] = this.decreaseAmount;
    data["ReceiverName"] = this.receiverName;
    data["ReceiverPhone"] = this.receiverPhone;
    data["ReceiverAddress"] = this.receiverAddress;
    data["Revenue"] = this.revenue;
    data["DeliveryDate"] = this.deliveryDate;
    data["ReceiverDate"] = this.deliveryDate?.toIso8601String();
    data["TrackingArea"] = this.trackingArea;

    if (removeIfNull == true) {
      data.removeWhere((key, value) => value == null);
    }

    return data;
  }
}

class FastSaleOrderAddEditData {
  int id;
  int partnerId;
  double discount;
  double discountAmount;
  double decreaseAmount;
  String number;

  String userId;
  String userName;
  DateTime dateInvoice;
  int companyId;
  String comment;
  String type;

  int carrierId;
  String deliveryNote;
  double cashOnDelivery;
  int paymentJournalId;
  // Phí
  double weightTotal;
  double deliveryPrice;
  double customerDeliveryPrice;
  double amountDeposit;
  double amountTotal;
  double paymentAmount;
  double shipWeight;
  double oldCredit;
  double newCredit;
  bool notModifyPriceFromSO;
  ShipReceiver shipReceiver;
  String shipServiceId;
  String shipServiceName;
  double shipInsuranceFee;

  List<FastSaleOrderLine> orderLines;
  List<ShipServiceExtra> shipServiceExtras;
  ShipExtra shipExtra;

  FastSaleOrderAddEditData(
      {this.partnerId,
      this.discount,
      this.discountAmount,
      this.decreaseAmount,
      this.weightTotal,
      this.userId,
      this.userName,
      this.dateInvoice,
      this.companyId,
      this.comment,
      this.type,
      this.deliveryPrice,
      this.carrierId,
      this.deliveryNote,
      this.cashOnDelivery,
      this.paymentJournalId,
      this.paymentAmount,
      this.customerDeliveryPrice,
      this.amountTotal,
      this.shipWeight,
      this.oldCredit,
      this.newCredit,
      this.amountDeposit,
      this.notModifyPriceFromSO,
      this.shipReceiver,
      this.shipServiceId,
      this.shipServiceName,
      this.shipInsuranceFee,
      this.orderLines,
      this.shipServiceExtras,
      this.shipExtra,
      this.number});

  FastSaleOrderAddEditData.fromJson(Map<String, dynamic> json) {
    id = json["Id"];
    number = json["Number"];
    partnerId = json['PartnerId'];
    discount = json['Discount'];
    discountAmount = json['DiscountAmount'];
    decreaseAmount = json['DecreaseAmount'];
    weightTotal = json['WeightTotal'];
    userId = json['UserId'];
    userName = json['UserName'];
    if (json["DateInvoice"] != null) {
      dateInvoice =
          DateFormat("yyyy-MM-ddThh:mm:ss").parse(json['DateInvoice']);
    }

    companyId = json['CompanyId'];
    comment = json['Comment'];
    type = json['Type'];
    deliveryPrice = json['DeliveryPrice'];
    carrierId = json['CarrierId'];
    deliveryNote = json['DeliveryNote'];
    cashOnDelivery = json['CashOnDelivery'];
    paymentJournalId = json['PaymentJournalId'];
    paymentAmount = json['PaymentAmount'];
    amountTotal = json["AmountTotal"];
    customerDeliveryPrice = json["CustomerDeliveryPrice"];
    shipWeight = json['ShipWeight'];
    oldCredit = json['OldCredit'];
    newCredit = json['NewCredit'];
    amountDeposit = json['AmountDeposit'];
    notModifyPriceFromSO = json['NotModifyPriceFromSO'];
    shipReceiver = json['Ship_Receiver'] != null
        ? new ShipReceiver.fromJson(json['Ship_Receiver'])
        : null;
    shipServiceId = json['Ship_ServiceId'];
    shipServiceName = json['Ship_ServiceName'];
    shipInsuranceFee = (json['Ship_InsuranceFee'] ?? 0).toDouble();
    if (json['OrderLines'] != null) {
      orderLines = new List<FastSaleOrderLine>();
      json['OrderLines'].forEach((v) {
        orderLines.add(new FastSaleOrderLine.fromJson(v));
      });
    }

    if (json["Ship_Extras"] != null) {
      shipExtra = ShipExtra.fromJson(json["Ship_Extras"]);
    }

    if (json["Ship_ServiceExtras"] != null) {
      shipServiceExtras = (json["Ship_ServiceExtras"] as List)
          .map((f) => ShipServiceExtra.fromJson(f))
          .toList();
    }
  }

  Map<String, dynamic> toJson({bool removeIfNull = false}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["Id"] = this.id;
    data['PartnerId'] = this.partnerId;
    data['Discount'] = this.discount;
    data['DiscountAmount'] = this.discountAmount;
    data['DecreaseAmount'] = this.decreaseAmount;
    data['WeightTotal'] = this.weightTotal;
    data['UserId'] = this.userId;
    data['UserName'] = this.userName;
    data['DateInvoice'] = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSSS'+07:00'")
        .format(this.dateInvoice);
    data['CompanyId'] = this.companyId;
    data['Comment'] = this.comment;
    data['Type'] = this.type;
    data['DeliveryPrice'] = this.deliveryPrice;
    data['CarrierId'] = this.carrierId;
    data['DeliveryNote'] = this.deliveryNote;
    data['CashOnDelivery'] = this.cashOnDelivery;
    data['PaymentJournalId'] = this.paymentJournalId;
    data['PaymentAmount'] = this.paymentAmount;
    data["AmountTotal"] = this.amountTotal;
    data["CustomerDeliveryPrice"] = this.customerDeliveryPrice;
    data['ShipWeight'] = this.shipWeight;
    data['OldCredit'] = this.oldCredit;
    data['NewCredit'] = this.newCredit;
    data['AmountDeposit'] = this.amountDeposit;
    data['NotModifyPriceFromSO'] = this.notModifyPriceFromSO;
    if (this.shipReceiver != null) {
      data['Ship_Receiver'] =
          this.shipReceiver.toJson(removeIfNull: removeIfNull);
    }
    data['Ship_ServiceId'] = this.shipServiceId;
    data['Ship_ServiceName'] = this.shipServiceName;
    if (this.orderLines != null) {
      data['OrderLines'] = this
          .orderLines
          .map((v) => v.toJson(removeIfNull: removeIfNull))
          .toList();
    }

    if (this.shipServiceExtras != null && this.shipServiceExtras.isNotEmpty) {
      data["Ship_ServiceExtras"] = shipServiceExtras
          .map((f) => f.toJson(removeIfNull: removeIfNull))
          .toList();
    }

    if (this.shipExtra != null) {
      data["Ship_Extras"] = shipExtra.toJson(removeIfNull);
    }

    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }

    return data;
  }
}
