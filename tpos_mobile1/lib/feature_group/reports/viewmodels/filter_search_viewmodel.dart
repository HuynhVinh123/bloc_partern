import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/company_of_user.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_purchase_order_application_user.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_purchase_order_partner.dart';
import 'package:tpos_mobile/src/tpos_apis/models/partner_category.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/partner_category_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';

class FilterSearchViewModel extends ViewModelBase {
  ITposApiService _tposApi;
  PartnerCategoryApi _partnerCategoryApi;
  DialogService _dialog;
  FilterSearchViewModel({
    ITposApiService tposApi,
    PartnerCategoryApi partnerCategoryApi,
    DialogService dialogService,
  }) {
    _tposApi = tposApi ?? locator<ITposApiService>();
    _partnerCategoryApi = partnerCategoryApi ?? locator<PartnerCategoryApi>();
    _dialog = dialogService ?? locator<DialogService>();
  }

  List<PartnerFPO> _suppliers = [];
  List<PartnerFPO> _partnerFPOs = [];
  List<PartnerCategory> _partnerCategory = [];
  List<ApplicationUserFPO> _applicationUserFPOs = [];
  List<CompanyOfUser> _companyOfUsers = [];

  List<PartnerFPO> get suppliers => _suppliers;
  set suppliers(List<PartnerFPO> value) {
    _suppliers = value;
    notifyListeners();
  }

  List<PartnerFPO> get partnerFPOs => _partnerFPOs;
  set partnerFPOs(List<PartnerFPO> value) {
    _partnerFPOs = value;
    notifyListeners();
  }

  List<PartnerCategory> get partnerCategory => _partnerCategory;
  set partnerCategory(List<PartnerCategory> value) {
    _partnerCategory = value;
    notifyListeners();
  }

  List<ApplicationUserFPO> get applicationUserFPOs => _applicationUserFPOs;
  set applicationUserFPOs(List<ApplicationUserFPO> value) {
    _applicationUserFPOs = value;
    notifyListeners();
  }

  List<CompanyOfUser> get companyOfUsers => _companyOfUsers;
  set companyOfUsers(List<CompanyOfUser> value) {
    _companyOfUsers = value;
    notifyListeners();
  }

  Future<void> getSuppliers() async {
    setState(true);
    try {
      var result = await _tposApi.getSupplierSearchs();
      if (result != null) {
        suppliers = result;
      }
      setState(false);
    } catch (e, s) {
      logger.error("loadPartnerSearchReportFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> getPartnerCategorys() async {
    setState(true);
    try {
      var result = await _partnerCategoryApi.getPartnerCategorys();
      if (result != null) {
        partnerCategory = result;
      }
      setState(false);
    } catch (e, s) {
      logger.error("loadPartnerCategorysFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> getListPartnerFPO() async {
    setState(true);
    try {
      var result = await _tposApi.getPartnerSearchReport();
      if (result != null) {
        partnerFPOs = result;
      }
      setState(false);
    } catch (e, s) {
      logger.error("loadPartnerSearchReportFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> getApplicationUserSearchReport() async {
    setState(true);
    try {
      var result = await _tposApi.getApplicationUserSearchReport();
      if (result != null) {
        applicationUserFPOs = result;
      }
      setState(false);
    } catch (e, s) {
      logger.error("loadApplicationUserSearchReportFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> getCompanies() async {
    setState(true);
    try {
      var result = await _tposApi.getCompanies();
      if (result != null) {
        companyOfUsers = result;
      }
      setState(false);
    } catch (e, s) {
      logger.error("loadCompanyFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }
}
