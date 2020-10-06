import 'package:flutter/foundation.dart';
import 'package:tpos_mobile/services/static_data.dart';

enum DeliveryCarryType {
  GHN,
  ViettelPost,
  fixed,
  JNT,
  ShipChung,
  FlashShip,
  MyVNPost,
  DHL,
  FulltimeShip,
}

extension DeliveryCarryTypeExtensions on DeliveryCarryType {
  String describe() => describeEnum(this);
  List<DeliveryCarrierService> getServices() {
    return StaticData.viettelDeliveryCarrierService
        .where((element) => element.deliveryType == 'ViettelPost')
        .toList();
  }

  DeliveryCarrierService getService(String name) {
    return StaticData.viettelDeliveryCarrierService
        .where((element) => element.deliveryType == 'ViettelPost')
        .toList()
        .firstWhere((element) => element.id == name, orElse: () => null);
  }
}
