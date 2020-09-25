import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/pos_session/bloc/pos_session_event.dart';
import 'package:tpos_mobile/feature_group/pos_session/bloc/pos_session_state.dart';

class PosSessionBloc extends Bloc<PosSessionEvent, PosSessionState> {
  PosSessionBloc({PosSessionApi apiClient}) : super(PosSessionLoading()) {
    _apiClient = apiClient ?? GetIt.instance<PosSessionApi>();
  }

  PosSessionApi _apiClient;

  @override
  Stream<PosSessionState> mapEventToState(PosSessionEvent event) async* {
    if (event is PosSessionLoaded) {
      yield PosSessionLoading();
      yield* _getPosSessions(event);
    }else if(event is PosSessionLoadMoreLoaded){
      yield PosSessionLoadMoreLoading();
      yield* _getPosSessionLoadMores(event);
    }
  }

  Stream<PosSessionState> _getPosSessions(PosSessionLoaded event) async* {
    try {
      final List<PosSession> posSessions = await _apiClient.getPosSession(
        page: 1,
        skip: event.skip,
        take: event.limit,
      );

      if(posSessions.length == event.limit){
        posSessions.add(tempPosSession);
      }

      yield PosSessionLoadSuccess(posSessions: posSessions);
    } catch (e) {
      yield PosSessionLoadFailure(title: "Thông báo", content: e.toString());
    }
  }

  Stream<PosSessionState> _getPosSessionLoadMores(PosSessionLoadMoreLoaded event) async* {

    event.posSessions.removeWhere(
            (element) => element.name == tempPosSession.name);

    try {
      final List<PosSession> posSessionLoadMores = await _apiClient.getPosSession(
        page: 1,
        skip: event.skip,
        take: event.limit,
      );
      if(posSessionLoadMores.length == event.limit){
        posSessionLoadMores.add(tempPosSession);
      }
      event.posSessions.addAll(posSessionLoadMores);
      yield PosSessionLoadSuccess(posSessions: event.posSessions);
    } catch (e) {
      yield PosSessionLoadFailure(title: "Thông báo", content: e.toString());
    }
  }
}

var tempPosSession = PosSession(name: "temp");
