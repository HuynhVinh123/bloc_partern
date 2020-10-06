import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/pos_order/sqlite_database/database_function.dart';
import 'package:tpos_mobile/feature_group/pos_session/bloc/add_edit/pos_session_add_edit_event.dart';
import 'package:tpos_mobile/feature_group/pos_session/bloc/add_edit/pos_session_add_edit_state.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class PosSessionAddEditBloc
    extends Bloc<PosSessionAddEditEvent, PosSessionAddEditState> {
  PosSessionAddEditBloc({PosSessionApi apiClient})
      : super(PosSessionInfoLoading()) {
    _apiClient = apiClient ?? GetIt.instance<PosSessionApi>();
    _dbFuction = locator<IDatabaseFunction>();
  }

  PosSessionApi _apiClient;
  IDatabaseFunction _dbFuction;

  @override
  Stream<PosSessionAddEditState> mapEventToState(event) async* {
    if (event is PosSessionInfoLoaded) {
      yield PosSessionInfoLoading();
      yield* _getPosSessionInfo(event);
    } else if (event is PosSessionSaved) {
      yield PosSessionInfoLoading();
      yield* _savePosSession(event);
    } else if (event is PosSessionAddEditClosed) {
      yield PosSessionInfoLoading();
      yield* _closePosSession(event);
    }
  }

  Stream<PosSessionAddEditState> _getPosSessionInfo(
      PosSessionInfoLoaded event) async* {
    try {
      final PosSession posSession =
          await _apiClient.getPosSessionById(id: event.id);
      final posAccountBanks =
          await _apiClient.getAccountBankStatement(id: event.id);

      yield PosSessionInfoLoadSuccess(
          posSession: posSession, posAccountBanks: posAccountBanks);
    } catch (e) {
      yield PosSessionInfoLoadFailure(
          title: S.current.notification, content: e.toString());
    }
  }

  Stream<PosSessionAddEditState> _savePosSession(PosSessionSaved event) async* {
    try {
      await _apiClient.updatePosSession(posSession: event.posSession);

      yield PosSessionActionSuccess(
          title: S.current.notification,
          content: S.current.posSession_sessionWasUpdated);
    } catch (e) {
      yield PosSessionInfoLoadFailure(
          title: S.current.notification, content: e.toString());
    }
  }

  Stream<PosSessionAddEditState> _closePosSession(
      PosSessionAddEditClosed event) async* {
    try {
      await _apiClient.closeSession(id: event.sessionId);
      await _clearMemory();
      yield PosSessionActionSuccess(
          title: S.current.notification,
          content: S.current.posSession_sessionWasClosed);
    } catch (e) {
      yield PosSessionInfoLoadFailure(
          title: S.current.notification, content: e.toString());
    }
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
