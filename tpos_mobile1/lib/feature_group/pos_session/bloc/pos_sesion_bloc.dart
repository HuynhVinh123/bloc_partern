import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/pos_order/sqlite_database/database_function.dart';
import 'package:tpos_mobile/feature_group/pos_session/bloc/pos_session_event.dart';
import 'package:tpos_mobile/feature_group/pos_session/bloc/pos_session_state.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import '../../../locator.dart';

class PosSessionBloc extends Bloc<PosSessionEvent, PosSessionState> {
  PosSessionBloc({
    PosSessionApi apiClient,
    CommonApi commonApi,
  }) : super(PosSessionLoading()) {
    _apiClient = apiClient ?? GetIt.instance<PosSessionApi>();
    _commonApi = commonApi ?? GetIt.instance<CommonApi>();
    _dbFuction = locator<IDatabaseFunction>();
  }

  PosSessionApi _apiClient;
  CommonApi _commonApi;
  IDatabaseFunction _dbFuction;
  GetCompanyCurrentResult company;
  List<PosSession> _posSessions;
  int index;

  @override
  Stream<PosSessionState> mapEventToState(PosSessionEvent event) async* {
    if (event is PosSessionLoaded) {
      /// Lấy danh sách phiên bán hàng
      yield PosSessionLoading();
      yield* _getPosSessions(event);
    } else if (event is PosSessionLoadMoreLoaded) {
      /// Thực hiện load more lấy danh sách
      yield PosSessionLoadMoreLoading();
      yield* _getPosSessionLoadMores(event);
    } else if (event is PosSessionDeleted) {
      yield PosSessionLoading();
      yield* _deletePosSession(event);
    } else if (event is PosSessionClosed) {
      yield PosSessionLoading();
      yield* _closePosSession(event);
    } else if (event is PosSessionUpdated) {
      yield PosSessionLoading();
      yield* _deleteAndUpdateSession(event);
    }
  }

  Stream<PosSessionState> _getPosSessions(PosSessionLoaded event) async* {
    try {
      company = await _commonApi.getCompanyCurrent();
      final List<PosSession> posSessions = await _apiClient.getPosSession(
        page: 1,
        skip: event.skip,
        take: event.limit,
      );

      if (posSessions.length >= event.limit) {
        posSessions.add(tempPosSession);
      }

      yield PosSessionLoadSuccess(posSessions: posSessions, company: company);
    } catch (e) {
      yield PosSessionActionFailure(
          title: S.current.notification, content: e.toString());
    }
  }

  Stream<PosSessionState> _getPosSessionLoadMores(
      PosSessionLoadMoreLoaded event) async* {
    event.posSessions
        .removeWhere((element) => element.name == tempPosSession.name);
    try {
      final List<PosSession> posSessionLoadMores =
          await _apiClient.getPosSession(
        page: 1,
        skip: event.skip,
        take: event.limit,
      );
      if (posSessionLoadMores.length >= event.limit) {
        posSessionLoadMores.add(tempPosSession);
      }
      event.posSessions.addAll(posSessionLoadMores);
      yield PosSessionLoadSuccess(
          posSessions: event.posSessions, company: company);
    } catch (e) {
      yield PosSessionActionFailure(
          title: S.current.notification, content: e.toString());
    }
  }

  Stream<PosSessionState> _deletePosSession(PosSessionDeleted event) async* {
    try {
      _posSessions = event.posSessions;
      index = event.index;
      await _apiClient.deletePosSession(id: event.id);
      yield PosSessionActionSuccess(
          title: S.current.notification,
          content: S.current.posSession_sessionWasDelete,
          isDelete: true);
    } catch (e) {
      yield PosSessionActionFailure(
          title: S.current.delete, content: e.toString());
    }
  }

  Stream<PosSessionState> _closePosSession(PosSessionClosed event) async* {
    try {
      await _apiClient.closeSession(id: event.sessionId);
      await _clearMemory();
      yield PosSessionActionSuccess(
          title: S.current.notification,
          content: S.current.posSession_sessionWasClosed,
          isDelete: false,
          countSessions: event.posSessions.length);
    } catch (e) {
      yield PosSessionActionFailure(
          title: S.current.notification, content: e.toString());
    }
  }

  Stream<PosSessionState> _deleteAndUpdateSession(
      PosSessionUpdated event) async* {
    _posSessions.removeAt(index);
    yield PosSessionLoadSuccess(posSessions: _posSessions, company: company);
  }

  Future<void> _clearMemory() async {
    await _dbFuction.deletePayments();
    await _dbFuction.deletePointSaleTaxs();
    await _dbFuction.deletePosconfig();
    await _dbFuction.deleteCart();
    await _dbFuction.deleteSession();
    await _dbFuction.deleteProduct();
    await _dbFuction.deletePaymentLines();
    await _dbFuction.deletePartners();
    await _dbFuction.deletePriceList();
    await _dbFuction.deleteAccountJournal();
    await _dbFuction.deleteCompany();
    await _dbFuction.deleteStatementIds();
    await _dbFuction.deleteApplicationUser();
    await _dbFuction.deleteProductPriceList();
    await _dbFuction.deleteMoneyCart();
  }
}

var tempPosSession = PosSession(name: "temp");
