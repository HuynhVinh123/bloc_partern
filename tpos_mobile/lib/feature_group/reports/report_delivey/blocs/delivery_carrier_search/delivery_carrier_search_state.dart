
import 'package:tpos_api_client/tpos_api_client.dart';

class DeliveryCarrierSearchState {}

/// Loading trong khi đợi load dữ liệu
class DeliveryCarrierSearchLoading extends DeliveryCarrierSearchState {}

/// Trả về dữ liệu khi laod thành công
class DeliveryCarrierSearchLoadSuccess extends DeliveryCarrierSearchState {
  DeliveryCarrierSearchLoadSuccess({this.deliveryCarriers});
  final List<DeliveryCarrier> deliveryCarriers;
}

/// Trả về lỗi khi load thất bại
class DeliveryCarrierSearchLoadFailure extends DeliveryCarrierSearchState {
  DeliveryCarrierSearchLoadFailure({this.title, this.content});
  final String title;
  final String content;
}
