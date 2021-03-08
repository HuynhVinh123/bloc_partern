import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/services/dialog_service/new_dialog_service.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class PartnerInfoViewModel extends ScopedViewModel {
  PartnerInfoViewModel(
      {PartnerApi partnerApi, NewDialogService dialogService}) {
    _partnerApi = partnerApi ?? GetIt.I<PartnerApi>();
    _newDialog = dialogService ?? GetIt.I<NewDialogService>();
  }
  PartnerApi _partnerApi;
  final Logger _log = Logger("PartnerInfoViewModel");
  NewDialogService _newDialog;

  int _partnerId;
  Partner _partner;
  Partner get partner => _partner;

  set partner(Partner value) {
    _partner = value;
    notifyListeners();
  }

  List<CreditDebitCustomerDetail> creditDebitCustomerDetails;
  GetPartnerRevenueResult partnerRevenue = GetPartnerRevenueResult();

  // Lọc
  int take = 100;
  int skip = 0;
  var page = 1;
  var pageSize = 100;

  /// Tải đối tác
  Future<bool> _loadPartner() async {
    try {
      partner = await _partnerApi.getById(_partnerId);
      _partnerId = partner.id;
      return true;
    } catch (ex, stack) {
      _log.severe("loadPartner fail", ex, stack);
      _newDialog.showDialog(content: ex.toString());
    }
    return false;
  }

  /// Tải doanh số đối tác
  Future<bool> _loadPartnerRevenue() async {
    try {
      partnerRevenue = await _partnerApi.getRevenueById(_partnerId);
      notifyListeners();
      return true;
    } catch (ex, stack) {
      _log.severe("load fail", ex, stack);
      _newDialog.showToast(
          // Không tải được thông tin doanh số
          title: S.current.partner_LoadSaleInfoFailed,
          message: ex.toString(),
          type: AlertDialogType.error);
      return false;
    }
  }

  /// Danh sách công nợ
  Future<bool> loadCreditDebitCustomerDetail() async {
    try {
      creditDebitCustomerDetails = await _partnerApi
          .getCreditDebitCustomerDetail(id: _partnerId, top: take, skip: skip);
      notifyListeners();
      return true;
    } catch (ex, stack) {
      _log.severe("loadCreditDebitCustomerDetail fail", ex, stack);
      // Không tải được thông tin nợ
      _newDialog.showToast(
          title: S.current.partner_LoadDebtInfoFailed, message: ex.toString());
    }
    return false;
  }

  // update partner status
  /// Cập nhật trạng thái khách hàng
  Future<bool> updatePartnerStatus(String status, String statusText) async {
    bool result = false;
    try {
      // Đang tải
      setBusy(true, message: "${S.current.loading}..");
      await _partnerApi.updateStatus(_partnerId,
          status: "${status}_$statusText");
      partner.status = status;
      partner.statusText = statusText;
      notifyListeners();
      setBusy(false);
      result = true;
    } catch (ex, stack) {
      _log.severe("updateParterStatus fail", ex, stack);
      _newDialog.showDialog(content: ex, type: AlertDialogType.error);
    }
    setBusy(false, message: "${S.current.loading}..");
    return result;
  }

  void updatePartnerStatus2(PartnerStatus status) {
    partner.status = status.value;
    partner.statusText = status.text;
    notifyListeners();
  }

  /// Khởi tạo. gọi trong initState
  Future<void> initData() async {
    setBusy(true, message: "${S.current.loading}..");
    await _loadPartner();
    await _loadPartnerRevenue();
    await loadCreditDebitCustomerDetail();
    setBusy(false);
  }

  Future<void> init({int partnerId}) async {
    _partnerId = partnerId;
  }
}
