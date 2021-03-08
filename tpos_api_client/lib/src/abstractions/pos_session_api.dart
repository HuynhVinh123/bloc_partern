import 'package:tpos_api_client/src/models/entities/pos_session/pos_account_bank.dart';
import 'package:tpos_api_client/src/models/entities/pos_session/pos_accoutn_bank_line.dart';
import 'package:tpos_api_client/src/models/entities/pos_session/pos_session.dart';

abstract class PosSessionApi {
  Future<List<PosSession>> getPosSession({int page, int skip, int take});

  Future<PosSession> getPosSessionById({int id});

  Future<List<PosAccountBank>> getAccountBankStatement({int id});

  Future<List<PosAccountBankLine>> getAccountBankStatementLine({int id});

  Future<PosAccountBank> getAccountBankStatementDetail({int id});

  Future<void> updatePosSession({PosSession posSession});

  Future<void> deletePosSession({int id});

  Future<void> closeSession({int id});
}
