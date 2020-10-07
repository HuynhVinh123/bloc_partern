import 'package:tpos_mobile/src/tpos_apis/models/service_custom.dart';

class ShipExtra {
  String deliverWorkShift;
  String deliverWorkShiftName;
  String pickWorkShift;
  String pickWorkShiftName;
  bool isDropoff;
  String posId;
  dynamic paymentTypeId;
  bool isInsurance;
  double insuranceFee;
  bool isPackageViewable;
  String pickupAccountId;
  String soldToAccountId;
  List<ServiceCustom> serviceCustoms;

  bool get hasSetting {
    if (deliverWorkShift != null) return true;
    if (deliverWorkShiftName != null) return true;
    if (pickWorkShift != null) return true;
    if (pickWorkShiftName != null) return true;
    if (isDropoff != null) return true;
    if (posId != null) return true;
    if (paymentTypeId != null) return true;
    return false;
  }

  ShipExtra(
      {this.deliverWorkShift,
      this.deliverWorkShiftName,
      this.pickWorkShift,
      this.pickWorkShiftName,
      this.posId,
      this.isInsurance,
      this.insuranceFee,
      this.isPackageViewable,
      this.pickupAccountId,
      this.soldToAccountId,
      this.serviceCustoms});

  ShipExtra.fromJson(Map<String, dynamic> json) {
    deliverWorkShift = json["DeliverWorkShift"];
    deliverWorkShiftName = json["DeliverWorkShiftName"];
    pickWorkShift = json["PickWorkShift"];
    pickWorkShiftName = json["PickWorkShiftName"];
    pickupAccountId = json["PickupAccountId"];
    soldToAccountId = json["SoldToAccountId"];

    posId = json["PosId"];
    isDropoff = json["IsDropoff"];
    paymentTypeId = json["PaymentTypeId"];
    isInsurance = json["IsInsurance"];
    insuranceFee = json["InsuranceFee"]?.toDouble();
    isPackageViewable = json['IsPackageViewable'];
    if (json["ServiceCustoms"] != null) {
      serviceCustoms = (json["ServiceCustoms"] as List)
          .map((value) => ServiceCustom.fromJson(value))
          .toList();
    }
  }

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data["DeliverWorkShift"] = deliverWorkShift;
    data["DeliverWorkShiftName"] = deliverWorkShiftName;
    data["PickWorkShift"] = pickWorkShift;
    data["PickWorkShiftName"] = pickWorkShiftName;
    data["PickupAccountId"] = pickupAccountId;
    data["SoldToAccountId"] = soldToAccountId;

    data["PosId"] = posId;
    data["IsDropoff"] = isDropoff;
    data["PaymentTypeId"] = paymentTypeId;
    data["IsInsurance"] = isInsurance;
    data["InsuranceFee"] = insuranceFee;
    data['IsPackageViewable'] = isPackageViewable;
    if (this.serviceCustoms != null) {
      if (this.serviceCustoms.isNotEmpty) {
        data["ServiceCustoms"] =
            this.serviceCustoms.map((v) => v.toJson()).toList();
      }
    }

    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
