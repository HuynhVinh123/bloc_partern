import 'package:tpos_api_client/tpos_api_client.dart';

class PartnerEditAddressState {}

/// State loading dữ liệu
class PartnerEditAddressLoading extends PartnerEditAddressState {}

/// State load dữ liệu thành công
class PartnerEditAddressLoadSuccess extends PartnerEditAddressState {
  PartnerEditAddressLoadSuccess({this.partner});
  final Partner partner;
}

/// State load dữ liệu thất bại
class PartnerEditAddressLoadFailure extends PartnerEditAddressState {
  PartnerEditAddressLoadFailure({this.title, this.content});
  final String title;
  final String content;
}

/// State khi thực hiện hành động lưu thành công
class PartnerEditAddActionSuccess extends PartnerEditAddressState {
  PartnerEditAddActionSuccess({this.title, this.content});
  final String title;
  final String content;
}

/// State khi thực hiện lưu thất bại
class PartnerEditAddActionFailure extends PartnerEditAddressState {
  PartnerEditAddActionFailure({this.title, this.content});
  final String title;
  final String content;
}
