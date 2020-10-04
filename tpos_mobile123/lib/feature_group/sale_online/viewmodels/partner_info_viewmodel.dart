import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/services/dialog_service.dart';

class PartnerInfoViewModel extends ViewModel {
  PartnerInfoViewModel({PartnerApi partnerApi, DialogService dialogService}) {
    _partnerApi = partnerApi ?? GetIt.I<PartnerApi>();
    _dialog = dialogService ?? locator<DialogService>();
  }
  PartnerApi _partnerApi;
  final Logger _log = Logger("PartnerInfoViewModel");
  DialogService _dialog;

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
      _dialog.showError(error: ex, title: 'Không tải được thông tin');
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
      _dialog.showNotify(
          title: 'Không tải được thông tin doanh số', message: '');
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
      _dialog.showNotify(title: 'Không tải được thông tin nợ', message: '');
    }
    return false;
  }

  // update partner status
  /// Cập nhật trạng thái khách hàng
  Future<bool> updatePartnerStatus(String status, String statusText) async {
    bool result = false;
    try {
      onStateAdd(true, message: "Đang tải..");
      await _partnerApi.updateStatus(_partnerId,
          status: "${status}_$statusText");
      partner.status = status;
      partner.statusText = statusText;
      notifyListeners();
      onStateAdd(false);
      result = true;
    } catch (ex, stack) {
      _log.severe("updateParterStatus fail", ex, stack);
      _dialog.showError(error: ex);
    }
    onStateAdd(false, message: "Đang tải..");
    return result;
  }

  /// Khởi tạo. gọi trong initState
  Future<void> initData() async {
    onStateAdd(true, message: "Đang tải..");
    await _loadPartner();
    await _loadPartnerRevenue();
    await loadCreditDebitCustomerDetail();
    onStateAdd(false);
  }

  Future<void> init({int partnerId}) {
    _partnerId = partnerId;
  }
}
