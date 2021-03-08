import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/pos_session/bloc/add_edit_detail_account/add_edit_detail_account_event.dart';
import 'package:tpos_mobile/feature_group/pos_session/bloc/add_edit_detail_account/add_edit_detail_account_state.dart';

class PosAddEditDetailAccountBloc
    extends Bloc<PosAddEditDetailAccountEvent, PosAddEditDetailAccountState> {
  PosAddEditDetailAccountBloc({PosSessionApi apiClient})
      : super(PosSessionDetailAccountLoading()) {
    _apiClient = apiClient ?? GetIt.instance<PosSessionApi>();
  }

  PosSessionApi _apiClient;

  @override
  Stream<PosAddEditDetailAccountState> mapEventToState(
      PosAddEditDetailAccountEvent event) async* {
    if (event is PosSessionDetailLoaded) {
      yield PosSessionDetailAccountLoading();
      yield* _getPosSessionInfoInvocie(event);
    }
  }

  Stream<PosAddEditDetailAccountState> _getPosSessionInfoInvocie(
      PosSessionDetailLoaded event) async* {
    try {
      final posAccountBank =
          await _apiClient.getAccountBankStatementDetail(id: event.id);

      final posAccountBankLines =
          await _apiClient.getAccountBankStatementLine(id: event.id);

      yield PosSessionDetailAccountLoadSuccess(
          posAccountBankDetail: posAccountBank,
          posAccountBankLines: posAccountBankLines);
    } catch (e) {
      yield PosSessionActionFailure(title: "Thông báo", content: e.toString());
    }
  }
}
