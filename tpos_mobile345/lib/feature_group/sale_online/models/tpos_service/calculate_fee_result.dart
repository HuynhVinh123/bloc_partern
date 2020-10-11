/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/16/19 5:56 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/16/19 5:46 PM
 *
 */

class CalculateFastOrderFeeResult {
  CalculateFastOrderFeeResult({this.success, this.message, this.data});
  CalculateFastOrderFeeResult.fromJson(Map jsonMap) {
    success = jsonMap["Success"];
    message = jsonMap["Message"];
    data = CalculateFeeResultData.fromJson(jsonMap["Data"]);
  }
  bool success;
  String message;
  CalculateFeeResultData data;
}

class CalculateFeeResultData {
  CalculateFeeResultData({this.totalFee, this.services, this.costs});
  CalculateFeeResultData.fromJson(Map jsonMap) {
    totalFee = (jsonMap["TotalFee"])?.toDouble() ?? 0;
    if (jsonMap["Services"] != null) {
      services = (jsonMap["Services"] as List)
          .map((f) => CalculateFeeResultDataService.fromJson(f))
          .toList();
    }

    if (jsonMap["Costs"] != null) {
      costs = (jsonMap["Costs"] as List)
          .map((f) => CalculateFeeResultCost.fromJson(f))
          .toList();
    }
  }
  double totalFee;
  double serviceFee;
  List<CalculateFeeResultDataService> services;
  List<CalculateFeeResultCost> costs;
}

class CalculateFeeResultDataService {
  CalculateFeeResultDataService({
    this.serviceId,
    this.serviceName,
    this.totalFee,
    this.extras,
  });
  CalculateFeeResultDataService.fromJson(jsonMap) {
    serviceId = jsonMap["ServiceId"];
    serviceName = jsonMap["ServiceName"];
    totalFee = (jsonMap["TotalFee"])?.toDouble();
    extras = (jsonMap["Extras"] as List)
        ?.map((f) => CalculateFeeResultDataExtra.fromJson(f))
        ?.toList();
  }
  String serviceId;
  String serviceName;
  double totalFee;
  int id;
  double fee;
  List<CalculateFeeResultDataExtra> extras;
}

class CalculateFeeResultDataExtra {
  CalculateFeeResultDataExtra(
      {this.fee,
      this.serviceId,
      this.serviceName,
      this.isSelected = false,
      this.id}) {
    isSelected = false;
  }
  CalculateFeeResultDataExtra.fromJson(Map<String, dynamic> jsonMap) {
    serviceId = jsonMap["ServiceId"];
    serviceName = jsonMap["ServiceName"];
    fee = jsonMap["Fee"]?.toDouble();
    id = jsonMap["Id"];
  }

  bool isSelected = false;
  double fee;
  String serviceId;
  String serviceName;
  int id;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["ServiceId"] = serviceId;
    data["ServiceName"] = serviceName;
    data["Fee"] = fee;
    data["Id"] = id;
    return data;
  }
}

class CalculateFeeResultCost {
  CalculateFeeResultCost({this.serviceId, this.serviceName, this.totalFee});
  CalculateFeeResultCost.fromJson(Map<String, dynamic> json) {
    serviceId = json["ServiceId"];
    serviceName = json["ServiceName"];
    totalFee = (json["TotalFee"])?.toDouble() ?? 0;
  }
  String serviceId;
  String serviceName;
  double totalFee;
}
