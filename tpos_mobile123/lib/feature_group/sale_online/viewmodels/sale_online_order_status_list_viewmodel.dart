import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/status_extra.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';

/// VM danh sách trạng thái của hóa đơn giao hàng
/// Mặc định là Nháp, Đơn Hàng, Hủy và do người dùng tự định nghĩa
/// Cho phép xem, thêm ,sửa ,xóa, chọn, tìm kiếm...
class SaleOnlineOrderStatusListViewModel extends ViewModel {
  SaleOnlineOrderStatusListViewModel(
      {DialogService dialogService, ITposApiService tposApiService}) {
    _dialogService = dialogService ?? locator<DialogService>();
    _tposApi = tposApiService ?? locator<ITposApiService>();
  }
  DialogService _dialogService;
  ITposApiService _tposApi;

  /// Danh sách trạng thái bao gồm mặc định
  List<StatusExtra> _status;
  bool _isSelectMode;
  bool _isCloseWhenSelect;
  List<StatusExtra> get status => _status;
  bool get isSelectMode => _isSelectMode;
  bool get isCloseWhenSelect => _isCloseWhenSelect;

  void init({
    @required bool isSelectMode,
    bool closeWhenSelect = true,
    @required bool isDialogMode,
  }) {
    _isSelectMode = isSelectMode;
    _isCloseWhenSelect = closeWhenSelect;
  }

  Future initData() async {
    try {
      // Gen default
      _status = <StatusExtra>[
        StatusExtra(type: "SaleOnline", name: "Nháp"),
        StatusExtra(type: "SaleOnline", name: "Đơn hàng"),
        StatusExtra(type: "SaleOnline", name: "Hủy"),
      ];
      final extraStatus = await _tposApi.getStatusExtra();
      if (extraStatus != null) {
        _status.addAll(extraStatus);
      }
      notifyListeners();
    } catch (e, s) {
      logger.error("", e, s);
      _dialogService.showError(error: e);
    }
  }
}
