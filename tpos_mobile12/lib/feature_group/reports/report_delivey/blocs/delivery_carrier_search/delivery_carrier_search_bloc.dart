import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/delivery_carrier_search/delivery_carrier_search_event.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/delivery_carrier_search/delivery_carrier_search_state.dart';
import 'package:tpos_mobile/src/tpos_apis/models/delivery_carrier.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import '../../../../../locator.dart';

class DeliveryCarrierSearchBloc
    extends Bloc<DeliveryCarrierSearchEvent, DeliveryCarrierSearchState> {
  DeliveryCarrierSearchBloc({ITposApiService tposApi})
      : super(DeliveryCarrierSearchLoading()) {
    _tposApi = tposApi ?? locator<ITposApiService>();
  }

  ITposApiService _tposApi;

  @override
  Stream<DeliveryCarrierSearchState> mapEventToState(
      DeliveryCarrierSearchEvent event) async* {
    if (event is DeliveryCarrierSearchLoaded) {
      yield* _getDeliveryCarrierSearch();
    }
  }

  Stream<DeliveryCarrierSearchState> _getDeliveryCarrierSearch() async* {
    try {
      final List<DeliveryCarrier> deliveryCarriers =
          await _tposApi.getDeliveryCarriers();
      yield DeliveryCarrierSearchLoadSuccess(
          deliveryCarriers: deliveryCarriers);
    } catch (e, s) {
      yield DeliveryCarrierSearchLoadFailure(
          title: S.current.notification, content: e.toString());
    }
  }
}
