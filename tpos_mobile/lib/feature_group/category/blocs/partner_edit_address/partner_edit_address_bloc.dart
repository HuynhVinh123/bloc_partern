import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/blocs/partner_edit_address/partner_edit_address_event.dart';
import 'package:tpos_mobile/feature_group/category/blocs/partner_edit_address/partner_edit_address_state.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class PartnerEditAddressBloc
    extends Bloc<PartnerEditAddressEvent, PartnerEditAddressState> {
  PartnerEditAddressBloc({PartnerApi partnerApi})
      : super(PartnerEditAddressLoading()) {
    _partnerApi = partnerApi ?? GetIt.I<PartnerApi>();
  }

  PartnerApi _partnerApi;

  @override
  Stream<PartnerEditAddressState> mapEventToState(
      PartnerEditAddressEvent event) async* {
    if (event is PartnerEditAddressLoaded) {
      /// Load thông tin partner
      yield PartnerEditAddressLoading();
      yield* getPartnerById(event);
    } else if (event is PartnerEditAddressSelectAddress) {
      /// Load thông tin lúc chọn địa chỉ
      yield PartnerEditAddressLoadSuccess(partner: event.partner);
    } else if (event is PartnerEditAddressSaved) {
      /// Thực hiện lưu dữ liệu
      yield PartnerEditAddressLoading();
      yield* savePartnerById(event);
    }
  }

  Stream<PartnerEditAddressState> getPartnerById(
      PartnerEditAddressLoaded event) async* {
    try {
      final Partner partner = await _partnerApi.getById(event.partnerId);
      yield PartnerEditAddressLoadSuccess(partner: partner);
    } catch (e) {
      yield PartnerEditAddressLoadFailure(
          title: S.current.error, content: e.toString());
    }
  }

  Stream<PartnerEditAddressState> savePartnerById(
      PartnerEditAddressSaved event) async* {
    try {
      await _partnerApi.update(event.partner);
      yield PartnerEditAddActionSuccess(
          title: S.current.notification, content: S.current.updateSuccessful);
    } catch (e) {
      yield PartnerEditAddActionFailure(
          title: S.current.error, content: e.toString());
    }
  }
}
