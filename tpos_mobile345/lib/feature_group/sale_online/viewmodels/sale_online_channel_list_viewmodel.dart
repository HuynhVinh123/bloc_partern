import 'dart:async';
import 'dart:io';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/sale_online/services/service.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';

import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';

import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';

class SaleOnlineChannelListViewModel extends ViewModel {
  SaleOnlineChannelListViewModel(
      {CrmTeamApi crmTeamApi, DialogService dialogService}) {
    _crmTeamApi = crmTeamApi ?? GetIt.I<CrmTeamApi>();
    _dialog = dialogService ?? locator<DialogService>();
  }

  CrmTeamApi _crmTeamApi;
  final Logger _log = Logger("SaleOnlineChannelListViewModel");
  DialogService _dialog;

  List<CRMTeam> _channels;
  List<CRMTeam> get channels => _channels;
  void _setChannels(List<CRMTeam> value) {
    _channels = value;
    if (_channelsController != null && _channelsController.isClosed == false) {
      _channelsController.add(value);
    }
  }

  void _channelsAddError(Object exception, [StackTrace stackTrade]) {
    if (_channelsController != null && _channelsController.isClosed == false) {
      _channelsController.addError(exception, stackTrade);
    }
  }

  final _channelsController = BehaviorSubject<List<CRMTeam>>();
  Stream<List<CRMTeam>> get channelsStream => _channelsController.stream;

  /// init Command
  Future<void> initCommand() async {
    onIsBusyAdd(true);
    try {
      await _loadChannels();
    } on SocketException {
      _channelsAddError("Không có mạng internet!");
    } catch (e, s) {
      _log.severe("init", e, s);
      _channelsAddError(e, s);
    }
    onIsBusyAdd(false);
  }

  /// refresh Command
  Future<void> refreshCommand() async {
    try {
      await _loadChannels();
    } catch (e, s) {
      _log.severe("", e, s);
      _channelsAddError(e, s);
    }
  }

  Future<void> _loadChannels() async {
    final OdataListResult<CRMTeam> result = await _crmTeamApi.getAllChannel();
    _channels = result.value;
    _setChannels(_channels);
  }

  Future<void> deleteChannel(CRMTeam crmTeam) async {
    try {
      await _crmTeamApi.deleteCRMTeam(crmTeam.id);
      _channels?.remove(crmTeam);
      _dialog.showNotify(message: "Đã xóa kênh bán ${crmTeam.name}");
      addSubject(_channelsController, _channels);
    } catch (e, s) {
      _log.severe("", e, s);
      _dialog.showError(error: e);
    }
  }

  @override
  void dispose() {
    _channelsController.close();
    super.dispose();
  }
}
