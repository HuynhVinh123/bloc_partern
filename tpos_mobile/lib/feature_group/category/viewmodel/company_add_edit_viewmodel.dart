import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/company_api.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';

class CompanyAddEditViewModel extends ScopedViewModel {
  CompanyAddEditViewModel({DialogService dialogService}) {
    _dialogService = dialogService ?? locator<DialogService>();
  }

  DialogService _dialogService;
  ICompanyApi _companyApi;

  Company _company = Company();
  Company get company => _company;

  void init({Company company}) {
    _company = company;
  }

  Future initData() async {
    setBusy(true);
    if (_company == null || _company.id == null || _company.id == 0) {
      // tạo mới
      _company = Company();
    } else {
      // Tải về
      _company = await _companyApi.getById(_company.id);
    }
    notifyListeners();
    setBusy(false);
  }

  Future<bool> save({bool refreshOnSaved}) async {
    bool isSuccess = false;
    setBusy(true, message: "Đang lưu...");
    try {
      if (_company != null && _company.id != null && _company.id != 0) {
        //update
        await _companyApi.update(_company);
        _dialogService.showNotify(
            message: "Đã cập nhật công ty ${_company.name}",
            showOnTop: true,
            type: AlertDialogType.info);
        isSuccess = true;
      } else {
        // insert
        await _companyApi.insert(_company);
        _dialogService.showNotify(message: "Đã thêm công ty mới");
        isSuccess = true;
      }

      if (refreshOnSaved) {
        await initData();
      }
    } catch (e, s) {
      logger.error("", e, s);
      _dialogService.showError(error: e);
    }

    setBusy(false);
    return isSuccess;
  }
}
