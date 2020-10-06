/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'dart:async';

import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';

import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/services/app_setting_service.dart';
import 'package:tpos_mobile/services/log_services/log_service.dart';
import 'package:tpos_mobile/services/print_service.dart';
import 'package:tpos_mobile/services/tpos_desktop_api_service.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';

class ApplicationSettingViewModel extends ViewModel {
  ISettingService _settingService;
  ITPosDesktopService _desktopApi;
  ITposApiService _tposApi;
  PrintService _printService;

  ApplicationSettingViewModel(
      {ISettingService settingService,
      ITPosDesktopService desktopApi,
      PrintService printService,
      ITposApiService tposApi,
      LogService logService})
      : super(logService: logService) {
    _settingService = settingService ?? locator<ISettingService>();
    _desktopApi = desktopApi ?? locator<ITPosDesktopService>();
    _tposApi = tposApi ?? locator<ITposApiService>();
    _printService = printService ?? locator<PrintService>();

    onStateAdd(false);
  }

  //isPrintSaleOnlineTag
  bool _isEnablePrintSaleOnline;
  bool get isEnablePrintSaleOnline => _isEnablePrintSaleOnline;
  set isEnablePrintSaleOnline(bool value) {
    _isEnablePrintSaleOnline = value;
    _settingService.isEnablePrintSaleOnline = value;
  }

  // print many time
  bool _isAllowPrintSaleOnlineManyTime = false;
  bool get isAllowPrintSaleOnlineManyTime => _isAllowPrintSaleOnlineManyTime;

  set isAllowPrintSaleOnlineManyTime(bool value) {
    _isAllowPrintSaleOnlineManyTime = value;
    _settingService.isAllowPrintSaleOnlineManyTime = value;
  }

  // print saleo onlne method
  PrintSaleOnlineMethod _saleOnlinePrintMethod =
      PrintSaleOnlineMethod.ComputerPrinter;
  PrintSaleOnlineMethod get saleOnlinePrintMethod => _saleOnlinePrintMethod;

  set saleOnlinePrintMethod(PrintSaleOnlineMethod value) {
    _saleOnlinePrintMethod = value;
    _settingService.printMethod = value;
  }

  // computer Ip
  String _computerIp;
  String get computerIp => _computerIp;
  set computerIp(String value) {
    _computerIp = value;
    _settingService.computerIp = value;
    _desktopApi.setConfig(
        computerIp: _settingService.computerIp,
        computerPort: _settingService.computerPort);
  }

  String _computerPort;
  String get computerPort => _computerPort;
  set computerPort(String value) {
    _computerPort = value;
    _settingService.computerPort = value;
    _desktopApi.setConfig(
        computerIp: _settingService.computerIp,
        computerPort: _settingService.computerPort);
  }

  // Lan printer ip
  String _lanPrinterIp;
  String get lanPrinterIp => _lanPrinterIp;
  set lanPrinterIp(String value) {
    _lanPrinterIp = value;
    _settingService.lanPrinterIp = value;
  }
  // Lan printer port

  String _lanPrinterPort;
  String get lanPrinterPort => _lanPrinterPort;

  set lanPrinterPort(String value) {
    _lanPrinterPort = value;
    _settingService.lanPrinterPort = value;
  }

  // Không kết nối dc live
  bool _isSaleOnlineEnableConnectFailAction;
  bool get isSaleOnlineEnableConnectFailAction =>
      _isSaleOnlineEnableConnectFailAction;
  set isSaleOnlineEnableConnectFailAction(bool value) {
    _isSaleOnlineEnableConnectFailAction = value;
    _settingService.isSaleOnlineEnableConnectFailAction = value;
  }

  // Thời gian tải lại live
  int _secondRefreshComment;
  int get secondRefreshComment => _secondRefreshComment;
  set secondRefreshComment(int value) {
    _secondRefreshComment = value;
    _settingService.secondRefreshComment = value;
  }

  // In địa chỉ trong ghi chú
  bool _isSaleOnlinePrintAddress;
  bool get isSaleOnlinePrintAddress => _isSaleOnlinePrintAddress;
  set isSaleOnlinePrintAddress(bool value) {
    _isSaleOnlinePrintAddress = value;
    _settingService.isSaleOnlinePrintAddress = value;
  }

  // In bình luận vào ghi chú
  bool _isSaleOnlinePrintComment;
  bool get isSaleOnlinePrintComment => _isSaleOnlinePrintComment;
  set isSaleOnlinePrintComment(bool value) {
    _isSaleOnlinePrintComment = value;
    _settingService.isSaleOnlinePrintComment = value;
  }

  // In ghi chú khách hàng vào ghi chú
  bool _isSaleOnlinePrintParnterNote;
  bool get isSaleOnlinePrintParnterNote => _isSaleOnlinePrintParnterNote;
  set isSaleOnlinePrintParnterNote(bool value) {
    _isSaleOnlinePrintParnterNote = value;
    _settingService.isSaleOnlinePrintPartnerNote = value;
  }

  // In toàn bộ ghi chú
  bool get isSaleOnlinePrintAllOrderNote =>
      _settingService.isSaleOnlinePrintAllOrderNote;
  set isSaleOnlinePrintAllOrderNote(bool value) {
    _settingService.isSaleOnlinePrintAllOrderNote = value;
  }

  Future loadSetting({loadCompleteCallback}) async {
    try {
      _isEnablePrintSaleOnline = _settingService.isEnablePrintSaleOnline;
      _isAllowPrintSaleOnlineManyTime =
          _settingService.isAllowPrintSaleOnlineManyTime;
      _saleOnlinePrintMethod = _settingService.printMethod;
      _computerIp = _settingService.computerIp;
      _computerPort = _settingService.computerPort;
      _lanPrinterIp = _settingService.lanPrinterIp;
      _lanPrinterPort = _settingService.lanPrinterPort;
      _isSaleOnlineEnableConnectFailAction =
          _settingService.isSaleOnlineEnableConnectFailAction;
      _secondRefreshComment = _settingService.secondRefreshComment;
      _isSaleOnlinePrintAddress = _settingService.isSaleOnlinePrintAddress;
      _isSaleOnlinePrintComment = _settingService.isSaleOnlinePrintComment;
      _isSaleOnlinePrintParnterNote =
          _settingService.isSaleOnlinePrintPartnerNote;
      onPropertyChanged("");
    } catch (ex, s) {
      logger.error("load setting", ex, s);
      onDialogMessageAdd((OldDialogMessage.error(
        "Tải dữ liệu không thành công",
        ex.toString(),
      )));
    }
  }

  void setPrintMethod(int id) {}

  Future printSaleOnlineTest() async {
    try {
      await _printService.printSaleOnlineViaComputerTest();
      onDialogMessageAdd(OldDialogMessage.flashMessage(
          "Đã gửi lệnh in thử tới máy tính. Vui lòng kiểm tra máy in xem phiếu in d dã được in ra hay chưa"));
    } catch (ex) {
      onDialogMessageAdd(OldDialogMessage.error("", "", error: ex));
    }
  }

  void dispose() {
    super.dispose();
  }

  // App settin
  bool isAppLoggined = false;

  Future resetSaleOnlineSessionNumber() async {
    try {
      await _tposApi.resetSaleOnlineOrderSessionIndex();
      onDialogMessageAdd(
          OldDialogMessage.flashMessage("Đã reset số thứ tự phiếu"));
    } catch (ex, s) {
      onDialogMessageAdd(OldDialogMessage.error(
          "Không thể thực hiện reset số thứ tự phiếu", ex.toString()));
      logger.error("reset số thứ tự phiếu", ex, s);
    }
  }
}
