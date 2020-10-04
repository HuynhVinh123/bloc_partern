import 'package:rxdart/subjects.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/feature_group/pos_order/services/pos_tpos_api.dart';
import 'package:tpos_mobile/feature_group/pos_order/sqlite_database/database_function.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:rxdart/rxdart.dart';

class SearchContactPartnerViewModel extends ViewModelBase {
  SearchContactPartnerViewModel(
      {IPosTposApi tposApiService, DialogService dialogService}) {
    _tposApi = tposApiService ?? locator<IPosTposApi>();
    _dialog = dialogService ?? locator<DialogService>();
    _keywordController
        .debounceTime(
      const Duration(milliseconds: 400),
    )
        .listen((key) {
      getContactPartners();
    });
  }

  DialogService _dialog;
  IPosTposApi _tposApi;
  IDatabaseFunction _dbFuction;

  bool _isSearch = false;
  bool get isSearch => _isSearch;
  set isSearch(bool value) {
    _isSearch = value;
    notifyListeners();
  }

  List<Partner> _partners = [];
  List<Partner> get partners => _partners;
  set partner(List<Partner> value) {
    _partners = value;
    notifyListeners();
  }

  Future<void> getContactPartners() async {
    try {
      setState(true);
      final result = await _tposApi.getContactPartners(_keyword);
      if (result != null) {
        _partners = result;
      }
      setState(false);
    } catch (e, s) {
      logger.error("loadAccountJournalsFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  //searchKeyword
  String _keyword;
  String get keyword => _keyword;
  final BehaviorSubject<String> _keywordController = BehaviorSubject();
  void onKeywordAdd(String value) {
    _keyword = value;
    if (_keywordController.isClosed == false) {
      _keywordController.add(_keyword);
    }
  }

  // Search
  Future<void> searchOrderCommand(String keyword) async {
    onKeywordAdd(keyword);
  }
}
