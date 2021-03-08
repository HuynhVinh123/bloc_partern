import 'package:tpos_api_client/tpos_api_client.dart';

class PartnerEditAddressEvent {}

/// Event load thông tin khách hàng
class PartnerEditAddressLoaded extends PartnerEditAddressEvent {
  PartnerEditAddressLoaded({this.partnerId});
  final int partnerId;
}

/// Event cập nhật địa chỉ khách hàng
class PartnerEditAddressSelectAddress extends PartnerEditAddressEvent {
  PartnerEditAddressSelectAddress({this.partner});
  final Partner partner;
}

/// Event lưu thông tin khách hàng
class PartnerEditAddressSaved extends PartnerEditAddressEvent {
  PartnerEditAddressSaved({this.partner});
  final Partner partner;
}
