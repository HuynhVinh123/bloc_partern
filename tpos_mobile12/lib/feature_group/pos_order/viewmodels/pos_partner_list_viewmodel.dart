import 'package:rxdart/rxdart.dart';
import 'package:tmt_flutter_untils/sources/string_utils/string_utils.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/partners.dart';
import 'package:tpos_mobile/feature_group/pos_order/sqlite_database/database_function.dart';
import 'package:tpos_mobile/feature_group/pos_order/sqlite_database/database_helper.dart';
import 'package:tpos_mobile/locator.dart';

import 'package:tpos_mobile/services/dialog_service.dart';

class PosPartnerListViewModel extends ViewModelBase {
  PosPartnerListViewModel({DialogService dialogService}) {
    _dbFunction = dialogService ?? locator<IDatabaseFunction>();

    _keywordController
        .debounceTime(const Duration(milliseconds: 500))
        .listen((keyword) {
      searchPartner();
    });
  }

  IDatabaseFunction _dbFunction;

  final dbHelper = DatabaseHelper.instance;

  final BehaviorSubject<String> _keywordController = BehaviorSubject();
  String _keyword = "";
  String get keyword => _keyword;

  Future<void> setKeyword(String value) async {
    _keyword = value;
    _keywordController.add(value);
    //notifyListeners();
  }

  Partners _partner;
  List<Partners> _searchPartners = [];
  List<Partners> _partners = [];
  List<Partners> get partners => _partners;
  set partners(List<Partners> value) {
    _partners = value;
    notifyListeners();
  }

  Partners get partner => _partner;
  set partner(Partners value) {
    _partner = value;
    notifyListeners();
  }

  Future<void> getPartners() async {
    setState(true);
    try {
      partners = await _dbFunction.queryGetPartners();
      print(partners.length);
      _searchPartners = partners;
    } catch (e, s) {
      logger.error("loadProductFail", e, s);
    }
    setState(false);
  }

  void searchPartner() {
    final List<Partners> findPartner = [];
    if (_keyword == "") {
      partners = _searchPartners;
    } else {
      for (var i = 0; i < _searchPartners.length; i++) {
        if (StringUtils.removeVietnameseMark(_searchPartners[i].name)
            .toLowerCase()
            .contains(StringUtils.removeVietnameseMark(_keyword.toLowerCase()))) {
          findPartner.add(_searchPartners[i]);
        }
      }
      partners = findPartner;
    }
  }
}
