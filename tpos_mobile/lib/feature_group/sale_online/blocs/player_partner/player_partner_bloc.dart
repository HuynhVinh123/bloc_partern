import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/player_partner/player_partner_event.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/player_partner/player_partner_state.dart';

class PlayerPartnerBloc extends Bloc<PlayerPartnerEvent, PlayerPartnerState> {
  PlayerPartnerBloc({PartnerApi partnerApi}) : super(PlayerPartnerLoading()) {
    _partnerApi = partnerApi ?? GetIt.I<PartnerApi>();
  }

  PartnerApi _partnerApi;
  Partner _partner;
  final Logger _logger = Logger();

  @override
  Stream<PlayerPartnerState> mapEventToState(PlayerPartnerEvent event) async* {
    if (event is PlayerPartnerLoaded) {
      try {
        final OdataListResult<Partner> result =
            await _partnerApi.checkPartner(crmTeamId: event.crmTeamId, asuid: event.asuId);
        if (result.value.isNotEmpty) {
          _partner = result.value[0];
        }
        yield PlayerPartnerLoadSuccess(partner: _partner);
      } catch (e, stack) {
        _logger.e('PlayerPartnerLoadError', e, stack);
        yield PlayerPartnerLoadError(error: e.toString());
      }
    }
  }
}
