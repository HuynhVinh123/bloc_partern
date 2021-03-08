import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/services/dialog_service/new_dialog_service.dart';

class PartnerStatusBadgeEvent {}

class PartnerStatusBadgePressed extends PartnerStatusBadgeEvent {
  PartnerStatusBadgePressed(
      {this.partner, @required this.status, @required this.partnerId})
      : assert(status != null),
        assert(partnerId != null);
  final PartnerStatus status;
  final int partnerId;
  final Partner partner;
}

class PartnerStatusBadgeState {}

class PartnerStatusBadgeInitial extends PartnerStatusBadgeState {}

class PartnerStatusBadgeChangeing extends PartnerStatusBadgeState {}

class PartnerStatusBadgeChangeSuccess extends PartnerStatusBadgeState {
  PartnerStatusBadgeChangeSuccess(this.status);
  final PartnerStatus status;
}

class PartnerStatusBadgeChangeFailure extends PartnerStatusBadgeState {}

class PartnerStatusBadgeBloc
    extends Bloc<PartnerStatusBadgeEvent, PartnerStatusBadgeState> {
  PartnerStatusBadgeBloc() : super(PartnerStatusBadgeInitial());

  final Logger _logger = Logger();
  final PartnerApi _partnerApi = GetIt.I<PartnerApi>();
  final NewDialogService _dialog = GetIt.I<NewDialogService>();
  @override
  Stream<PartnerStatusBadgeState> mapEventToState(
      PartnerStatusBadgeEvent event) async* {
    if (event is PartnerStatusBadgePressed) {
      // Change the status
      yield PartnerStatusBadgeChangeing();
      try {
        await _partnerApi.updateStatus(
          event.partnerId,
          status: '${event.status.value}_${event.status.text}',
        );
        event.partner?.status = event.status.value;
        event.partner?.statusText = event.status.text;
        _dialog.showToast(
            message:
                'Đã thay đổi trạng thái khách hàng thành ${event.status.text}');
        yield PartnerStatusBadgeChangeSuccess(event.status);
      } catch (e, s) {
        _logger.e('Change status of partner fail!', e, s);
        _dialog.showError(
          content: e.toString(),
        );
        yield PartnerStatusBadgeChangeFailure();
      }
    }
  }
}
