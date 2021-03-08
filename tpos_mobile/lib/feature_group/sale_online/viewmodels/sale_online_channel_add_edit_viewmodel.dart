import 'dart:async';

import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class SaleOnlineChannelAddEditViewModel extends ScopedViewModel {
  SaleOnlineChannelAddEditViewModel({ITposApiService tposApi}) {
    _tposApi = tposApi ?? locator<ITposApiService>();
  }
  ITposApiService _tposApi;

  final Logger _log = Logger("SaleOnlineChannelListViewModel");

  CRMTeam _channel;
  CRMTeam addOrEditchannel = CRMTeam();
  CRMTeam get channel => _channel;
  void _setChannel(CRMTeam value) {
    _channel = value;
    if (_channelController != null && _channelController.isClosed == false) {
      _channelController.add(value);
    }
  }
//
//  void _channelAddError(Object exception, [StackTrace stackTrade]) {
//    if (_channelController != null && _channelController.isClosed == false) {
//      _channelController.addError(exception, stackTrade);
//    }
//  }

  final _channelController = BehaviorSubject<CRMTeam>();
  Stream<CRMTeam> get channelStream => _channelController.stream;

  void selectTypeCommand(String type) {
    channel.type = type;
    onPropertyChanged("selectTypeCommand");
  }

  void isCheckActive(bool value) {
    channel.active = value;
    onPropertyChanged("isCheckActive");
  }

  /// Lưu dữ liệu
  Future<bool> saveInfo() async {
    try {
      addOrEditchannel.id = channel.id;
      addOrEditchannel.name = channel.name;
      addOrEditchannel.type = channel.type;
      addOrEditchannel.parentName = channel.parentName;
      addOrEditchannel.shopId = channel.shopId;
      addOrEditchannel.zaloSecretKey = channel.zaloSecretKey;
      addOrEditchannel.active = channel.active;

      if (addOrEditchannel.id != null) {
        await _tposApi.editSaleChannelById(crmTeam: addOrEditchannel);
      } else {
        await _tposApi.addSaleChannel(crmTeam: addOrEditchannel);
      }

      // Lưu thông tin thành công
      onDialogMessageAdd(
          OldDialogMessage.flashMessage(S.current.posOfSale_successful));
      return true;
    } catch (ex, stack) {
      _log.severe("saveInfo fail", ex, stack);
      // Lưu dữ liệu thất bại
      onDialogMessageAdd(
          OldDialogMessage.error(S.current.posOfSale_failed, ex.toString()));
    }
    return false;
  }

  /// init Command
  Future<void> initCommand({CRMTeam crmTeam}) async {
    onIsBusyAdd(true);
    _channel = crmTeam ?? CRMTeam();
    try {
      if (_channel.id != null) {
        _setChannel(crmTeam);
      }
    } catch (e, s) {
      _log.severe("init", e, s);
    }
    onPropertyChanged("init Command");
    onIsBusyAdd(false);
  }

  @override
  void dispose() {
    _channelController.close();
    super.dispose();
  }
}
