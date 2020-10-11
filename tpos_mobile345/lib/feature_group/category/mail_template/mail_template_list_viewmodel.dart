import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/mail_template.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';

class MailTemplateListViewModel extends ViewModelBase {
  ITposApiService _tposApi;
  DialogService _dialog;

  MailTemplateListViewModel(
      {ITposApiService tposApiService, DialogService dialogService}) {
    _tposApi = tposApiService ?? locator<ITposApiService>();
    _dialog = dialogService ?? locator<DialogService>();
  }

  List<MailTemplate> mailTemplates;

  Future<bool> deleteMailTemplate(int id) async {
    try {
      var result = await _tposApi.deleteMailTemplate(id);
      if (result.result) {
        _dialog.showNotify(message: "Đã xóa mail template", title: "Thông báo");
        return true;
      } else {
        _dialog.showError(
          title: "Lỗi",
          content: "${result.message}",
        );
        return false;
      }
    } catch (e, s) {
      logger.error("deleteMailTemplate", e, s);
      _dialog.showError(title: "Lỗi", content: "$e");
      return false;
    }
  }

  void removeMailTemplate(int index) {
    mailTemplates.removeAt(index);
    notifyListeners();
  }

  Future loadMailTemplates() async {
    setState(true, message: "Đang tải...");
    try {
      final result = await _tposApi.getMailTemplateResult();
      mailTemplates = result.value;
      setState(false);
    } catch (e, s) {
      setState(false);
      logger.error("loadMailTemplates", e, s);
      _dialog.showError(title: "Lỗi", content: "$e");
    }
  }
}
