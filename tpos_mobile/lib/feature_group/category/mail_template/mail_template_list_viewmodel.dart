import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class MailTemplateListViewModel extends ViewModelBase {
  MailTemplateListViewModel(
      {ITposApiService tposApiService, DialogService dialogService}) {
    _tposApi = tposApiService ?? locator<ITposApiService>();
    _dialog = dialogService ?? locator<DialogService>();
  }
  ITposApiService _tposApi;
  DialogService _dialog;

  List<MailTemplate> mailTemplates;

  Future<bool> deleteMailTemplate(int id) async {
    try {
      final result = await _tposApi.deleteMailTemplate(id);
      if (result.result) {
        _dialog.showNotify(
            message: S.current.mailTemplate_DeleteMailSuccess,
            title: S.current.notification);
        return true;
      } else {
        _dialog.showError(
          title: S.current.error,
          content: result.message ?? "",
        );
        return false;
      }
    } catch (e, s) {
      logger.error("deleteMailTemplate", e, s);
      _dialog.showError(title: S.current.error, content: "$e");
      return false;
    }
  }

  void removeMailTemplate(int index) {
    mailTemplates.removeAt(index);
    notifyListeners();
  }

  Future loadMailTemplates() async {
    setState(true, message: "${S.current.loading}...");
    try {
      final result = await _tposApi.getMailTemplateResult();
      mailTemplates = result.value;
      setState(false);
    } catch (e, s) {
      setState(false);
      logger.error("loadMailTemplates", e, s);
      _dialog.showError(title: S.current.error, content: "$e");
    }
  }
}
