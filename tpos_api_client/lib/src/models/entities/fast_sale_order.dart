import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:tpos_api_client/src/models/entities/ship_receiver.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

import 'account.dart';
import 'account_journal.dart';
import 'delivery_carrier.dart';
import 'fast_sale_order_line.dart';
import 'journal.dart';
import 'ship_extra.dart';
import 'ship_service_extra.dart';
import 'stock_warehouse.dart';

class FastSaleOrder {
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
      this.trackingArea,
      this.dateOrderRed,
      this.numberOrder,
      this.seri,
      this.delivery,
      this.totalQuantity,
      this.cRMTeamId});
  FastSaleOrder.fromJson(Map<String, dynamic> jsonMap) {
    if (jsonMap["DateInvoice"] != null) {
      final String unixTimeStr =
          RegExp(r"(?<=Date\()\d+").stringMatch(jsonMap["DateInvoice"]);

      if (unixTimeStr != null && unixTimeStr.isNotEmpty) {
        final int unixTime = int.parse(unixTimeStr);
        dateInvoice = DateTime.fromMillisecondsSinceEpoch(unixTime);
      } else {
        if (jsonMap["DateInvoice"] != null) {
          dateInvoice = DateTime.parse(jsonMap["DateInvoice"]);
        }
      }
    }

    if (jsonMap["DeliveryDate"] != null) {
      final String unixTimeStr =
          RegExp(r"(?<=Date\()\d+").stringMatch(jsonMap["DeliveryDate"]);

      if (unixTimeStr != null && unixTimeStr.isNotEmpty) {
        final int unixTime = int.parse(unixTimeStr);
        deliveryDate = DateTime.fromMillisecondsSinceEpoch(unixTime);
      } else {
        if (jsonMap["DateInvoice"] != null) {
          deliveryDate = DateTime.parse(jsonMap["DeliveryDate"]);
        }
      }
    }

    if (jsonMap["ReceiverDate"] != null) {
      final String unixTimeStr =
          RegExp(r"(?<=Date\()\d+").stringMatch(jsonMap["ReceiverDate"]);

      if (unixTimeStr != null && unixTimeStr.isNotEmpty) {
        final int unixTime = int.parse(unixTimeStr);
        receiverDate = DateTime.fromMillisecondsSinceEpoch(unixTime);
      } else {
        if (jsonMap["ReceiverDate"] != null) {
          receiverDate = DateTime.parse(jsonMap["ReceiverDate"]);
        }
      }
    }

    final String unixDateCreated =
        RegExp(r"(?<=Date\()\d+").stringMatch(jsonMap["DateCreated"] ?? "");
    if (unixDateCreated != null && unixDateCreated.isNotEmpty) {
      final int unixTime = int.parse(unixDateCreated);
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
      orderLines = <FastSaleOrderLine>[];
      jsonMap['OrderLines'].forEach((v) {
        orderLines.add(FastSaleOrderLine.fromJson(v));
      });
    }

    if (jsonMap["Account"] != null) {
      account = Account.fromJson(jsonMap["Account"]);
    }

    // Convert warehouse
    if (jsonMap["Warehouse"] != null) {
      wareHouse = StockWareHouse.fromJson(jsonMap["Warehouse"]);
    }

    // Convert User
    if (jsonMap["User"] != null) {
      user = ApplicationUser.fromJson(jsonMap["User"]);
    }

    // Convert User
    if (jsonMap["PriceList"] != null) {
      priceList = ProductPrice.fromJson(jsonMap["PriceList"]);
    }
    // Convert Company
    if (jsonMap["Company"] != null) {
      company = Company.fromJson(jsonMap["Company"]);
    }

    // Convert Journal
    if (jsonMap["Journal"] != null) {
      journal = Journal.fromJson(jsonMap["Journal"]);
    }
    //PaymentJournal
    if (jsonMap["PaymentJournal"] != null) {
      paymentJournal = AccountJournal.fromJson(jsonMap["PaymentJournal"]);
    }

    // Partner
    if (jsonMap["Partner"] != null) {
      partner = Partner.fromJson(jsonMap["Partner"]);
    }
    // Carrier
    if (jsonMap["Carrier"] != null) {
      carrier = DeliveryCarrier.fromJson(jsonMap["Carrier"]);
    }

    if (jsonMap["Ship_Extras"] != null) {
      shipExtra = ShipExtra.fromJson(jsonMap["Ship_Extras"]);
    }

    if (jsonMap["Ship_ServiceExtras"] != null) {
      shipServiceExtras = (jsonMap["Ship_ServiceExtras"] as List)
          .map((f) => ShipServiceExtra.fromJson(f))
          .toList();
    }
    amountUntaxed = jsonMap["AmountUntaxed"]?.toDouble();
    customerDeliveryPrice = jsonMap["CustomerDeliveryPrice"]?.toDouble();
    shipInsuranceFee = jsonMap["Ship_InsuranceFee"]?.toDouble();
    amountTax = jsonMap["AmountTax"]?.toDouble();
    decreaseAmount = jsonMap["DecreaseAmount"]?.toDouble();

    receiverName = jsonMap["ReceiverName"];
    receiverAddress = jsonMap["ReceiverAddress"];
    receiverPhone = jsonMap["ReceiverPhone"];
    receiverNote = jsonMap['ReceiverNote'];

    previousBalance = jsonMap["PreviousBalance"]?.toDouble();
    revenue = jsonMap["Revenue"]?.toDouble();
    deliver = jsonMap["Deliver"];
    shipServiceExtrasText = jsonMap["Ship_ServiceExtrasText"];
    totalQuantity = jsonMap["TotalQuantity"]?.toInt();
    if (shipServiceExtrasText != null) {
      shipServiceExtraFromText = (jsonDecode(shipServiceExtrasText) as List)
          .map((f) => ShipServiceExtra.fromJson(f))
          .toList();
    }

    numberOrder = jsonMap["NumberOrder"];
    seri = jsonMap["Seri"];
    delivery = jsonMap["Deliver"];

    isProductDefault = jsonMap["IsProductDefault"] as bool;
    status = jsonMap["Status"];
    if (jsonMap["DateOrderRed"] != null) {
      final String unixTimeStr =
          RegExp(r"(?<=Date\()\d+").stringMatch(jsonMap["DateOrderRed"]);

      if (unixTimeStr != null && unixTimeStr.isNotEmpty) {
        final int unixTime = int.parse(unixTimeStr);
        dateOrderRed = DateTime.fromMillisecondsSinceEpoch(unixTime);
      } else {
        if (jsonMap["DateOrderRed"] != null) {
          dateOrderRed = DateTime.parse(jsonMap["DateOrderRed"]);
        }
      }
    }
    cRMTeamId = jsonMap["CRMTeamId"];
  }

  /// Có đang được chọn hay không? mặc đinh là không
  bool isSelected = false;
  dynamic id;
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
  String status;

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

  DateTime dateOrderRed;
  String numberOrder;
  String seri;
  String delivery;

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

  /// Số lượng
  int totalQuantity;
  int cRMTeamId;

  /// Thông tin địa chỉ giao hàng

  ///
  ///
  ///Thông tin người nhận
  ///
  ///
  bool get isStepDraft => true;
  bool get isStepConfirm => state == "open" || state == "paid";
  bool get isStepPay => state == "paid";
  bool get isStepCompleted => state == "paid";

  // Không có  trong json
  double get productQuantity {
    if (orderLines != null && orderLines.isNotEmpty) {
      return orderLines.map((f) => f.productUOMQty).reduce((f1, f2) => f1 + f2);
    }
    return 0;
  }

  double get subTotal =>
      orderLines?.map((f) => f.priceSubTotal)?.reduce((a, b) => a + b);

  /// Tổng tiền của phiếu = Tổng cộng + Phí giao hàng - Tiền đặt cọc
  double get total =>
      (amountTotal ?? 0) + (deliveryPrice ?? 0) - (amountDeposit ?? 0);

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['Id'] = id;
    data["AccountId"] = accountId;
    data["Status"] = status;
    data['PartnerId'] = partnerId;
    data['CompanyId'] = companyId;
    data['CarrierId'] = carrierId;
    data['JournalId'] = journalId;
    data["PriceListId"] = priceListId;
    data["PaymentJournalId"] = paymentJournalId;
    data["WarehouseId"] = warehouseId;
    data["UserId"] = userId;
    data['Ship_ServiceId'] = shipServiceId;
    data["TaxId"] = taxId;

    if (saleOnlineIds != null) {
      data["SaleOnlineIds"] = saleOnlineIds.toList();
    }
    data["TotalQuantity"] = totalQuantity;
    data["Account"] = account?.toJson(removeIfNull);
    data["Warehouse"] = wareHouse?.toJson(removeIfNull);
    data["User"] = user?.toJson(removeIfNull);
    data["PriceList"] = priceList?.toJson(removeIfNull);
    data["Company"] = company?.toJson();
    data["Journal"] = journal?.toJson(removeIfNull);
    data["PaymentJournal"] = paymentJournal?.toJson(removeIfNull);
    data["Partner"] = partner?.toJson(removeIfNull);
    data["Carrier"] = carrier?.toJson(removeIfNull);
    data["Ship_Extras"] = shipExtra?.toJson(removeIfNull);
    data["Ship_ServiceExtras"] = shipServiceExtras
        ?.map((f) => f.toJson(removeIfNull: removeIfNull))
        ?.toList();

    data['WeightTotal'] = weightTotal;
    data['UserId'] = userId;
    data['UserName'] = userName;
    data['DateInvoice'] = dateInvoice?.toIso8601String();
    data["DateCreated"] = dateCreated?.toIso8601String();
    data['Comment'] = comment;
    data['Type'] = type;

    data['ShipWeight'] = shipWeight;
    data["AmountDeposit"] = amountDeposit;
    data['DeliveryPrice'] = deliveryPrice;
    data['DeliveryNote'] = deliveryNote;
    data['CashOnDelivery'] = cashOnDelivery;
    data["DeliveryNote"] = deliveryNote;

    data["AmountTotal"] = amountTotal;
    data['PaymentAmount'] = paymentAmount;
    data["AmountUntaxed"] = amountUntaxed;
    data['Discount'] = discount;
    data['DiscountAmount'] = discountAmount;

    data['OldCredit'] = oldCredit;
    data['NewCredit'] = newCredit;
    data['NotModifyPriceFromSO'] = notModifyPriceFromSO;
    if (shipReceiver != null) {
      data['Ship_Receiver'] = shipReceiver.toJson(removeIfNull: removeIfNull);
    }
    data["Residual"] = residual;
    data['Ship_ServiceName'] = shipServiceName;
    if (orderLines != null) {
      data['OrderLines'] =
          orderLines.map((v) => v.toJson(removeIfNull: removeIfNull)).toList();
    }

    data["CustomerDeliveryPrice"] = customerDeliveryPrice;
    data["Ship_InsuranceFee"] = shipInsuranceFee;
    data["State"] = state;
    data["ShowState"] = showState;
    data["AmountTax"] = amountTax;
    data["DecreaseAmount"] = decreaseAmount;
    data["ReceiverName"] = receiverName;
    data["ReceiverPhone"] = receiverPhone;
    data["ReceiverAddress"] = receiverAddress;
    data["Revenue"] = revenue;
    data["DeliveryDate"] = deliveryDate;
    data["TrackingArea"] = trackingArea;
    data["ReceiverDate"] = receiverDate?.toIso8601String();
    data["DateOrderRed"] = dateOrderRed?.toIso8601String();
    data["ReceiverNote"] = receiverNote;
    data["Ship_ServiceExtrasText"] = shipServiceExtrasText;
    data["NumberOrder"] = numberOrder;
    data["Seri"] = seri;
    data["Deliver"] = delivery;
    data["CRMTeamId"] = cRMTeamId;
    if (removeIfNull == true) {
      data.removeWhere((key, value) => value == null);
    }

    return data;
  }
}

@Deprecated(
    'Class này đã bị khai tử. vui lòng điểu chỉnh lại bằng cách sử dụng [FastSaleOrder]')
class FastSaleOrderAddEditData {
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
        ? ShipReceiver.fromJson(json['Ship_Receiver'])
        : null;
    shipServiceId = json['Ship_ServiceId'];
    shipServiceName = json['Ship_ServiceName'];
    shipInsuranceFee = (json['Ship_InsuranceFee'] ?? 0).toDouble();
    if (json['OrderLines'] != null) {
      orderLines = <FastSaleOrderLine>[];
      json['OrderLines'].forEach((v) {
        orderLines.add(FastSaleOrderLine.fromJson(v));
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

  Map<String, dynamic> toJson({bool removeIfNull = false}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["Id"] = id;
    data['PartnerId'] = partnerId;
    data['Discount'] = discount;
    data['DiscountAmount'] = discountAmount;
    data['DecreaseAmount'] = decreaseAmount;
    data['WeightTotal'] = weightTotal;
    data['UserId'] = userId;
    data['UserName'] = userName;
    data['DateInvoice'] =
        DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSSS'+07:00'").format(dateInvoice);
    data['CompanyId'] = companyId;
    data['Comment'] = comment;
    data['Type'] = type;
    data['DeliveryPrice'] = deliveryPrice;
    data['CarrierId'] = carrierId;
    data['DeliveryNote'] = deliveryNote;
    data['CashOnDelivery'] = cashOnDelivery;
    data['PaymentJournalId'] = paymentJournalId;
    data['PaymentAmount'] = paymentAmount;
    data["AmountTotal"] = amountTotal;
    data["CustomerDeliveryPrice"] = customerDeliveryPrice;
    data['ShipWeight'] = shipWeight;
    data['OldCredit'] = oldCredit;
    data['NewCredit'] = newCredit;
    data['AmountDeposit'] = amountDeposit;
    data['NotModifyPriceFromSO'] = notModifyPriceFromSO;
    if (shipReceiver != null) {
      data['Ship_Receiver'] = shipReceiver.toJson(removeIfNull: removeIfNull);
    }
    data['Ship_ServiceId'] = shipServiceId;
    data['Ship_ServiceName'] = shipServiceName;
    if (orderLines != null) {
      data['OrderLines'] =
          orderLines.map((v) => v.toJson(removeIfNull: removeIfNull)).toList();
    }

    if (shipServiceExtras != null && shipServiceExtras.isNotEmpty) {
      data["Ship_ServiceExtras"] = shipServiceExtras
          .map((f) => f.toJson(removeIfNull: removeIfNull))
          .toList();
    }

    if (shipExtra != null) {
      data["Ship_Extras"] = shipExtra.toJson(removeIfNull);
    }

    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }

    return data;
  }
}
