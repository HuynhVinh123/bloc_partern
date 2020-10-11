import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/src/tpos_apis/models/facebook_share_info.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_api.dart';

class FacebookPostShareDetailViewModel extends ViewModel {
  FacebookPostShareDetailViewModel();
  List<FacebookShareInfo> _shareInfo;
  List<FacebookShareInfo> get shareInfo => _shareInfo;
  set shareInfo(List<FacebookShareInfo> value) {
    _shareInfo = value;
    notifyListeners();
  }

  List<ShareGroupByLinkModel> shareGroupBys;
  Future<void> initCommand() async {
    onStateAdd(true, message: "Đang tải dữ liệu...");
    try {
      //Group by link

    } catch (e, s) {
      logger.error("", e, s);
    }
    notifyListeners();
    onStateAdd(false);
  }
}

class ShareGroupByLinkModel {
  String link;
  int count;
}
