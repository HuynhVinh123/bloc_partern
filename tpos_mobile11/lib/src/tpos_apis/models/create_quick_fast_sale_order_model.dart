
import 'package:tpos_api_client/tpos_api_client.dart';

class CreateQuickFastSaleOrderModel {
  int id;
  int carrierId;
  DeliveryCarrier carrier;
  List<CreateQuickFastSaleOrderLineModel> lines;

  CreateQuickFastSaleOrderModel.fromJson(Map<String, dynamic> json) {
    id = json["Id"];
    carrierId = json["CarrierId"];
    if (json["Carrier"] != null) {
      carrier = DeliveryCarrier.fromJson(json["Carrier"]);
    }
    if (json["Lines"] != null) {
      lines = (json["Lines"] as List)
          .map((f) => CreateQuickFastSaleOrderLineModel.fromJson(f))
          .toList();
    }
  }

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data["Id"] = id;
    data["CarrierId"] = carrierId;
    if (carrier != null) {
      data["Carrier"] = carrier.toJson(removeIfNull);
    }

    if (lines != null) {
      data["Lines"] = lines.map((f) => f.toJson(removeIfNull)).toList();
    }

    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }

    return data;
  }

  CreateQuickFastSaleOrderModel copyWith() {
    return CreateQuickFastSaleOrderModel(
        id: id, carrier: carrier, carrierId: carrierId, lines: lines);
  }

  CreateQuickFastSaleOrderModel(
      {this.id, this.carrierId, this.carrier, this.lines});
}

class CreateQuickFastSaleOrderLineModel {
  String id;
  List<String> ids;
  int partnerId;
  String facebookId;
  String facebookName;
  String comment;
  double cOD;
  double shipAmount;
  double depositAmount;
  double shipWeight;
  bool isPayment;
  List<String> saleOnlineIds;
  Partner partner;
  String productNote;
  double totalAmount;

  CreateQuickFastSaleOrderLineModel({
    this.id,
    this.ids,
    this.partnerId,
    this.facebookId,
    this.facebookName,
    this.comment,
    this.cOD,
    this.shipAmount,
    this.depositAmount,
    this.shipWeight,
    this.isPayment,
    this.saleOnlineIds,
    this.partner,
    this.productNote,
    this.totalAmount,
  });

  CreateQuickFastSaleOrderLineModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    if (json["Ids"] != null) {
      ids = (json["Ids"] as List).map((f) => f.toString()).toList();
    }
    partnerId = json['PartnerId'];
    facebookId = json['FacebookId'];
    facebookName = json['FacebookName'];
    comment = json['Comment'];
    cOD = json['COD']?.toDouble();
    shipAmount = json['ShipAmount']?.toDouble();
    depositAmount = json['DepositAmount']?.toDouble();
    shipWeight = json['ShipWeight']?.toDouble();
    isPayment = json['IsPayment'];
    saleOnlineIds =
        (json['SaleOnlineIds'] as List).map((f) => f.toString()).toList();
    partner =
        json['Partner'] != null ? Partner.fromJson(json['Partner']) : null;

    productNote = json["ProductNote"];
    totalAmount = json["TotalAmount"]?.toDouble();
  }

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["Id"] = id;
    data["Ids"] = ids?.toList();
    data['PartnerId'] = partnerId;
    data['FacebookId'] = facebookId;
    data['FacebookName'] = facebookName;
    data['Comment'] = comment;
    data['COD'] = cOD;
    data['ShipAmount'] = shipAmount;
    data['DepositAmount'] = depositAmount;
    data['ShipWeight'] = shipWeight;
    data['IsPayment'] = isPayment;
    data['SaleOnlineIds'] = saleOnlineIds?.toList();
    if (partner != null) {
      data['Partner'] = partner.toJson(removeIfNull);
    }

    data["ProductNote"] = productNote;
    data["TotalAmount"] = totalAmount;

    if (removeIfNull) data.removeWhere((key, value) => value == null);
    return data;
  }
}