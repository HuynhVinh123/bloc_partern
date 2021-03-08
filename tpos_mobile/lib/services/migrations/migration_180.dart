import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/models/enums/font_scale.dart';
import 'package:tpos_mobile/services/config_service/config_service.dart';
import 'package:tpos_mobile/services/config_service/h_adapters/old_lucky_wheel_game_config.dart';
import 'package:tpos_mobile/services/config_service/shop_config_service.dart';
import 'package:tpos_mobile/services/print_service/printer_device.dart';
import 'package:version/version.dart';

import 'config_migrations.dart';

/// Migration App Config from old version to version 1.8.0
/// From v1.5.4-> v1.7.xx to v1.8.0 or last version is unknow.
/// The previous version will get from [setting_last_app_version] on [AppSettingService]
/// Because the migration using Service so must start migration after init locator.
///
///
/// Ghi chú. Do các phiên bản trước ko lưu được phiên bản đó đang là phiên bản
/// nào nên cần chạy upgrade ngay khi cài đặt.
/// Kể từ phiên bản 1.8.0 sẽ lưu một biến
class Migration180 extends MigrationBase {
  @override
  Future<bool> get condition async {
    try {
      bool result = false;

      if (GetIt.I<ConfigService>().isUpdated) {
        return false;
      }

      /// Current version
      final String currentVersion = App.appVersion;

      /// this app version
      final Version version = Version.parse(currentVersion);

      /// Affect from version
      final Version fromVersion = Version(1, 5, 4);

      /// To version.
      final Version toVersion = Version(1, 7, 30);

      final lastVersionString = GetIt.I<ConfigService>().previousVersion;
      Version lastVersion;

      if (lastVersionString.isNotNullOrEmpty()) {
        lastVersion = Version.parse(lastVersionString);
      }

      if (lastVersion != null) {
        if (lastVersion >= fromVersion && lastVersion <= toVersion) {
          result = true;
        }
      } else {
        result = true;
      }

      return result;
    } catch (e, s) {
      return false;
    }
  }

  @override
  Future<void> up() async {
    // migrate all config from old to new.
    // ************** Migration **********************//
    // - shopInfo (shopUsername, shopUrl).
    // - SaleOnlineConfig.
    // - print deliver order config.
    // - print invoice config.

    // ************** Migrate shop config service *****************//
    // Clear shop token to re login.

    final _pref = await SharedPreferences.getInstance();
    final _secureConfig = GetIt.I<SecureConfigService>();
    final _logger = Logger();

    // Don't migration shop token and required user to re login the app.
    // _secureConfig.setShopToken(_pref.getString('shopAccessToken') ?? '');
    // Don't start migration  [shopRefreshToken]. Required the user must be re login
    // after update the app.
    // _secureConfig.setRefreshToken(_pref.getString('shopRefreshAccessToken'));

    // Migrate printer setting.
    try {
      await _migrationPrinterSetting();
    } catch (e, s) {
      _logger.e('Migrate printer setting.', e, s);
    }

    // Convert sale online setting
    try {
      await _migrationSaleOnlineSetting();
    } catch (e, s) {
      _logger.e('Convert sale online setting.', e, s);
    }

    // Convert old luckyWheelConfig to new LuckyWheelConfig.
    try {
      await _migrationOldLuckyWheelGame();
    } catch (e, s) {
      _logger.e('Convert old luckyWheelConfig to new LuckyWheelConfig.', e, s);
    }

    try {
      //TODO(namnv): continue convert.
      await _migrationFastSaleOrderSetting();
    } catch (e, s) {
      _logger.e('.', e, s);
    }
  }

  ///TODO(namnv): Migrate old lucky wheel game.
  ///Priority. low
  Future<void> _migrationOldLuckyWheelGame() async {
    final _shopConfig = GetIt.I<ShopConfigService>();
    final _pref = await SharedPreferences.getInstance();
    final _oldLuckyWheelGame = _shopConfig.oldLuckyWheelConfig;

    _oldLuckyWheelGame.isShareGame = _pref.getBool('setting_is_share_game') ??
        _oldLuckyWheelGame.isShareGame;
    _oldLuckyWheelGame.isIgnoreRecentWinner =
        _pref.getBool('setting_is_win_game') ??
            _oldLuckyWheelGame.isIgnoreRecentWinner;

    _oldLuckyWheelGame.isPriorGame = _pref.getBool('setting_is_prior_game') ??
        _oldLuckyWheelGame.isPriorGame;

    _oldLuckyWheelGame.isCommentGame =
        _pref.getBool('setting_is_comment_game') ??
            _oldLuckyWheelGame.isCommentGame;

    _oldLuckyWheelGame.isOrderGame = _pref.getBool('setting_is_order_game') ??
        _oldLuckyWheelGame.isOrderGame;

    _oldLuckyWheelGame.gameDurationInSecond =
        _pref.getInt('gameDuration') ?? _oldLuckyWheelGame.gameDurationInSecond;
    _oldLuckyWheelGame.ignoreDays =
        _pref.getInt('days') ?? _oldLuckyWheelGame.ignoreDays;
  }

  Future<void> _migrationPrinterSetting() async {
    final _shopConfig = GetIt.I<ShopConfigService>();
    final _pref = await SharedPreferences.getInstance();
    final _shipConfig = _shopConfig.printerConfig;

    /// Convert printer config
    final int oldPrintSaleOnlineMethod = _pref.getInt('printSaleOnlineMethod');
    if (oldPrintSaleOnlineMethod != null) {
      _shopConfig.printerConfig.saleOnlinePrinterName =
          oldPrintSaleOnlineMethod == 0
              ? 'Máy ESC/POS (In qua Wifi)'
              : 'TPos Printer (In qua máy tính)';
    }

    // Convert printer list from old setting to new config.
    final printerJson = _pref.getString('setting_printer_list');
    if (printerJson != null && printerJson != "") {
      final _printers = (jsonDecode(printerJson) as List)
          .map((f) => PrinterDevice.fromJson(f))
          .toList();

      _shopConfig.printerConfig.printerDevices = _printers;
    }

    // Keep sale online printer setting.
    final saleOnlinePrinter = _shopConfig.printerConfig.saleOnlinePrinterDevice;
    if (saleOnlinePrinter != null) {
      final String ip = _pref.getString('lanPrinterIp');
      final String port = _pref.getString('lanPrinterPort');
      final String computerIp = _pref.getString('computerIp');
      final String computerPort = _pref.getString('computerPort');

      if (saleOnlinePrinter.type == 'esc_pos') {
        if (ip.isNotNullOrEmpty()) {
          saleOnlinePrinter.ip = ip;
        }
        if (port.isNotNullOrEmpty()) {
          saleOnlinePrinter.port = int.parse(port);
        }
      } else if (saleOnlinePrinter.type == 'tpos_printer') {
        if (computerIp.isNotNullOrEmpty()) {
          saleOnlinePrinter.ip = computerIp;
        }

        saleOnlinePrinter.port =
            computerPort != null ? int.parse(computerPort) : 8123;
      }

      _shopConfig.printerConfig.updatePrinterDevice(saleOnlinePrinter);
    }

    /// ******************* PRINT DELIVERY ***********************************/
    _shopConfig.printerConfig.shipPrinterName =
        _pref.getString('shipPrinterName') ??
            _shopConfig.printerConfig.shipPrinterName;

    _shopConfig.printerConfig.shipPaperSize =
        _pref.getString('setting_ship_size') ??
            _shopConfig.printerConfig.shipPaperSize;

    // Migration shipFontScale.
    final String shipFontScaleString = _pref.getString('shipFontScale');
    if (shipFontScaleString != null && shipFontScaleString.isNotEmpty) {
      _shipConfig.shipFontScale =
          shipFontScaleString.toEnum<FontScale>(FontScale.values);
    }

    _shipConfig.printShipShowProductQuantity =
        _pref.getBool('setting_print_ship_show_product_quantity') ??
            _shipConfig.printShipShowProductQuantity;

    _shipConfig.printShipShowDepositAmount =
        _pref.getBool('setting_print_ship_show_deposit_amount') ??
            _shipConfig.printShipShowDepositAmount;

    _shipConfig.printShipShowInvoiceNote =
        _pref.getBool('settingPrintShipShowInvoiceNote') ??
            _shipConfig.printShipShowDepositAmount;

    /// ******************* PRINT INVOICE ***********************************/
    _shopConfig.printerConfig.invoicePrinterName =
        _pref.getString('setting_fast_sale_order_printer_name') ??
            _shopConfig.printerConfig.shipPrinterName;

    _shopConfig.printerConfig.invoicePaperSize =
        _pref.getString('setting_fast_sale_order_print_size') ??
            _shopConfig.printerConfig.invoicePaperSize;
    // Migration invoice font scale.
    final String savedValue = _pref.getString("fastSaleOrderFontScale");
    if (savedValue != null && savedValue.isNotEmpty) {
      _shipConfig.invoiceFontScale =
          savedValue.toEnum<FontScale>(FontScale.values);
    }
  }

  /// Start migration Sale online config.
  Future<void> _migrationSaleOnlineSetting() async {
    final _shopConfig = GetIt.I<ShopConfigService>();
    final _pref = await SharedPreferences.getInstance();
    final _saleOnlineConfig = _shopConfig.saleFacebookConfig;

    final bool isEnablePrintSaleOnline =
        _pref.getBool('isEnablePrintSaleOnline') ?? true;
    _saleOnlineConfig.enablePrint = isEnablePrintSaleOnline ?? true;
    _saleOnlineConfig.printComment =
        _pref.getBool('isSaleOnlinePrintComment') ??
            _saleOnlineConfig.printComment;

    _saleOnlineConfig.printAddress =
        _pref.getBool('isSaleOnlinePrintAddress') ??
            _saleOnlineConfig.printAddress;

    _saleOnlineConfig.printPartnerNote =
        _pref.getBool('isSaleOnlinePrintPartnerNote') ??
            _saleOnlineConfig.printPartnerNote;

    _saleOnlineConfig.printAllOrderNote =
        _pref.getBool('isSaleOnlinePrintAllOrderNote') ??
            _saleOnlineConfig.printAllOrderNote;

    _saleOnlineConfig.fetchCommentDurationSecond =
        _pref.getInt('secondRefreshLiveComment') ??
            _saleOnlineConfig.fetchCommentDurationSecond;

    _saleOnlineConfig.allowPrintManyTime =
        _pref.getBool('isAllowPrintSaleOnlineManyTime') ??
            _saleOnlineConfig.allowPrintManyTime;

    _saleOnlineConfig.printPartnerNote =
        _pref.getBool('isSaleOnlinePrintPartnerNote') ??
            _saleOnlineConfig.printPartnerNote;

    _saleOnlineConfig.printCustomHeader =
        _pref.getBool('isSaleOnlinePrintCustoHeader') ??
            _saleOnlineConfig.printCustomHeader;

    _saleOnlineConfig.showCommentTimeAsTimeAgo =
        _pref.getBool('isSaleOnlineViewCommentTimeAgoOnLive') ??
            _saleOnlineConfig.showCommentTimeAsTimeAgo;
    _saleOnlineConfig.hideShortComment =
        _pref.getBool('setting_sale_online_hide_short_comment') ??
            _saleOnlineConfig.hideShortComment;

    _saleOnlineConfig.customHeader =
        _pref.getString('saleOnlinePrintCustomHeader') ??
            _saleOnlineConfig.customHeader;

    _saleOnlineConfig.printOnlyOneIfHaveOrder =
        _pref.getBool('saleOnlinePrintOnlyOneIfHavaOrder') ??
            _saleOnlineConfig.printOnlyOneIfHaveOrder;

    _saleOnlineConfig.printAllOrderNoteWhenReprint =
        _pref.getBool('saleOnlinePrintAllNoteWhenPreprint') ??
            _saleOnlineConfig.printAllOrderNoteWhenReprint;

    _saleOnlineConfig.postCountPerFetchTimes =
        _pref.getInt('getFacebookPostTake') ??
            _saleOnlineConfig.postCountPerFetchTimes;

    _saleOnlineConfig.commentCountPerFetchTimes =
        _pref.getInt('getFacebookCommentTake') ??
            _saleOnlineConfig.commentCountPerFetchTimes;

    _saleOnlineConfig.fetchCommentDurationSecond =
        _pref.getInt('secondRefreshLiveComment') ??
            _saleOnlineConfig.fetchCommentDurationSecond;

    _saleOnlineConfig.autoSaveCommentEveryInMinute =
        _pref.getInt('setting_sale_online_save_comment_minute') ??
            _saleOnlineConfig.autoSaveCommentEveryInMinute;

    /// Not need set orderby
    /// Not need set fetch comment rate.
  }

  Future<void> _migrationFastSaleOrderSetting() async {
    final _shopConfig = GetIt.I<ShopConfigService>();
    final _pref = await SharedPreferences.getInstance();
    //final _fasltSaleOrderConfig = _shopConfig.;
  }
}

class Migration180App extends MigrationBase {
  /// Chạy nếu phiên bản cũ = null hoặc phiên bản cũ.
  @override
  Future<bool> get condition async {
    try {
      bool result = false;

      /// Current version
      final String currentVersion = App.appVersion;

      /// this app version
      final Version version = Version.parse(currentVersion);

      /// Affect from version
      final Version fromVersion = Version(1, 5, 4);

      /// To version.
      final Version toVersion = Version(1, 7, 30);

      final lastVersionString = GetIt.I<ConfigService>().previousVersion;
      Version lastVersion;

      if (lastVersionString.isNotNullOrEmpty()) {
        lastVersion = Version.parse(lastVersionString);
      }

      if (lastVersion != null) {
        if (lastVersion >= fromVersion && lastVersion <= toVersion) {
          result = true;
        }
      } else {
        result = true;
      }

      return result;
    } catch (e, s) {
      return false;
    }
  }

  @override
  Future<void> up() async {
    final _pref = await SharedPreferences.getInstance();
    final _secureConfig = GetIt.I<SecureConfigService>();
    final _logger = Logger();
    // Convert Old shopUrl config to new shopUrl config.
    final String oldShopUrl = _pref.getString('shopUrl');
    final String oldShopUsername = _pref.getString('shopUsername');

    if (oldShopUrl.isNotNullOrEmpty()) {
      _secureConfig.setShopUrl(oldShopUrl);
    }

    if (oldShopUsername.isNotNullOrEmpty()) {
      _secureConfig.setShopUsername(oldShopUsername);
    }
  }
}
