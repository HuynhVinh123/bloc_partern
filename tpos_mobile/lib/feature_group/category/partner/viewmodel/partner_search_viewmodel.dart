import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tmt_flutter_untils/sources/string_utils/string_utils.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';

class PartnerSearchViewModel extends ViewModel implements ViewModelBase {
  PartnerSearchViewModel(
      {ITposApiService tposApi,
      PartnerApi partnerApi,
      TagPartnerApi tagPartnerApi,
      DialogService dialog}) {
    _tposApi = tposApi ?? locator<ITposApiService>();
    _dialog = dialog ?? locator<DialogService>();
    _partnerApi = partnerApi ?? GetIt.I<PartnerApi>();
    _tagPartnerApi = tagPartnerApi ?? GetIt.I<TagPartnerApi>();

    // Listen keyword changing
    _keywordController
        .debounceTime(const Duration(milliseconds: 500))
        .listen((newKeyword) {
      loadPartners();
    });
  }
  //log
  final log = Logger("PartnerSearchViewModel");
  DialogService _dialog;
  ITposApiService _tposApi;
  PartnerApi _partnerApi;
  TagPartnerApi _tagPartnerApi;
  bool isCustomer;
  bool isSupplier;
  bool isSearchMode;

  final BehaviorSubject<List<Partner>> _partnersController = BehaviorSubject();
  Stream<List<Partner>> get partnersStream => _partnersController.stream;

  // Keyword controll
  String _keyword;
  String get keyword => _keyword;
  BehaviorSubject<String> _keywordController = BehaviorSubject();
  void _onKeywordAdd(String value) {
    _keyword = value;
    if (_keywordController.isClosed == false) {
      _keywordController.add(value);
    }
  }

  Future<void> keywordChangedCommand(String keyword) async {
    _onKeywordAdd(keyword);
  }

  void init(
      {bool isCustomer = true, bool isSupplier, bool isSearchMode = false}) {
    this.isCustomer = isCustomer;
    this.isSupplier = isSupplier;
    this.isSearchMode = isSearchMode;
  }

  Future<void> loadPartners() async {
    try {
      onIsBusyAdd(true);
      _keyword = StringUtils.removeVietnameseMark(keyword);
      // var partners = await _partnerApi.getPartnersForSearch(_keyword, 200,
      //     isCustomer: isCustomer,
      //     isSupplier: isSupplier,
      //     onlyActive: isSearchMode);

      final result = await _partnerApi.getForSearch(GetPartnerForSearchQuery(
        keyword: _keyword,
        top: 200,
        isCustomer: isCustomer,
        isSupplier: isSupplier,
        onlyActive:
            isSearchMode, //TODO(namnv): Kiểm tra xem biến này hoạt động ra sao
      ));
      onIsBusyAdd(false);
      if (_partnersController.isClosed == false)
        _partnersController.add(result.value);
    } catch (ex, stack) {
      log.severe("loadPartners fail", ex, stack);
      _partnersController.addError(ex);
    }
  }

  Future<bool> deletePartner(int id) async {
    onIsBusyAdd(true);
    try {
      await _tposApi.deletePartner(id);
      _dialog.showNotify(message: "Đã xóa khách hàng $id");
      return true;
    } catch (ex, stack) {
      log.severe("deletePartners fail", ex, stack);
      onDialogMessageAdd(OldDialogMessage.error("", ex.toString(),
          title: "Lỗi không xác định!"));
    }
    onIsBusyAdd(false);
    return false;
  }

  Future<void> initCommand() async {
    onIsBusyAdd(true);
    _keyword = "";
    try {
      await loadPartners();
    } catch (e) {}
    onIsBusyAdd(false);
  }

  @override
  void dispose() {
    _partnersController.close();
    _keywordController.close();
    super.dispose();
  }
}
