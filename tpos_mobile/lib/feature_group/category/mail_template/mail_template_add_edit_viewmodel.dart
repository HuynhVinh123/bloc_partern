import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';

import 'mail_template.dart';

class MailTemplateAddEditViewModel extends ViewModelBase {
  MailTemplateAddEditViewModel(
      {ITposApiService tposApiService, DialogService dialogService}) {
    _tposApi = tposApiService ?? locator<ITposApiService>();
    _dialog = dialogService ?? locator<DialogService>();
  }

  ITposApiService _tposApi;
  DialogService _dialog;
  bool isReload = false;

  MailTemplate mailTemplate = MailTemplate();

  List<Map<String, dynamic>> headers = [
    {"name": "Mã đơn hàng", "value": "{order.code}"},
    {"name": "Mã vận đơn", "value": "{order.tracking_code}"},
    {"name": "Mã đặt hàng", "value": "{placeholder.code}"},
  ];

  List<Map<String, dynamic>> contents = [
    {"name": "Tên KH", "value": "{partner.name}"},
    {"name": "Mã KH", "value": "{partner.code}"},
    {"name": "Điện thoại KH", "value": "{partner.phone}"},
    {"name": "Địa chỉ KH", "value": "{partner.address}"},
    {"name": "Công nợ KH", "value": "{partner.debt}"},
    {"name": "Đơn hàng", "value": "{order}"},
    {"name": "Mã đơn hàng", "value": "{order.code}"},
    {"name": "Mã vận đơn", "value": "{order.tracking_code}"},
    {"name": "Tổng tiền đơn hàng", "value": "{order.total_amount}"},
    {"name": "Mã đặt hàng", "value": "{placeholder.code}"},
    {"name": "Ghi chú đặt hàng", "value": "{placeholder.note}"},
    {"name": "Chi tiết đặt hàng", "value": "{placeholder.details}"},
    {"name": "Tag Facebook", "value": "{tag}"},
    {"name": "Yêu cầu gửi sđt", "value": "{required.phone}"},
    {"name": "Yêu cầu gửi địa chỉ", "value": "{required.address}"},
    {"name": "Yêu cầu gửi đt, địa chỉ", "value": "{required.phone_address}"},
  ];

  List<MailTemplateType> mailTemplateTypes;
  String selectedMailType;

  void setCommandMailType(String value) {
    selectedMailType = value;
    notifyListeners();
  }

  Future loadMailTemplateType() async {
    setState(true, message: "Đang tải...");
    try {
      mailTemplateTypes = await _tposApi.getMailTemplateType();
      setState(false);
    } catch (e, s) {
      setState(false);
      logger.error("loadMailTemplateType", e, s);
      _dialog.showError(title: "Lỗi", content: "$e");
    }
  }

  Future loadMailTemplate(int id) async {
    setState(true, message: "Đang tải...");
    try {
      mailTemplate = await _tposApi.getMailTemplateById(id);
      setState(false);
    } catch (e, s) {
      setState(false);
      logger.error("loadMailTemplate", e, s);
      _dialog.showError(title: "Lỗi", content: "$e");
    }
  }

  Future<bool> save() async {
    setState(true, message: "Đang lưu");
    mailTemplate?.typeId = selectedMailType;
    if (mailTemplate.id != null) {
      try {
        await _tposApi.updateMailTemplate(mailTemplate);
        isReload = true;
        setState(false);
        _dialog.showNotify(
            message: "Đã cập nhật mail template", title: "Thông báo");
      } catch (e, s) {
        setState(false);
        logger.error("updateMailTemplate", e, s);
        _dialog.showError(title: 'Đã xảy ra lỗi!', content: "$e");
        return false;
      }
    } else {
      try {
        await _tposApi.addMailTemplate(mailTemplate);
        _dialog.showNotify(
            message: "Đã thêm mail template", title: "Thông báo");
        return true;
      } catch (e, s) {
        setState(false);
        logger.error("addMailTemplate", e, s);
        _dialog.showError(title: "Lỗi", content: "$e");
        return false;
      }
    }
//    setState(false);
    return true;
  }

  Future<void> initCommand() async {
    await loadMailTemplateType();
    if (mailTemplate.typeId == null) {
      selectedMailType = mailTemplateTypes.first.value;
    }
  }
}
