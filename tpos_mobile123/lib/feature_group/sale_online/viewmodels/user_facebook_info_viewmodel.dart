import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';

import 'package:tpos_mobile/src/tpos_apis/models/user_facebook_comment.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';

class UserFacebookInfoViewModel extends ViewModelBase {
  UserFacebookInfoViewModel(
      {ITposApiService tposApiService, DialogService dialogService}) {
    _tposApi = tposApiService ?? locator<ITposApiService>();
    _dialog = dialogService ?? locator<DialogService>();
  }
  ITposApiService _tposApi;
  DialogService _dialog;

  Partner _partner = Partner();
  Partner get partner => _partner;
  set partner(Partner value) {
    _partner = value;
    notifyListeners();
  }

  List<UserFacebookComment> _comments = [];
  List<UserFacebookComment> get comments => _comments;
  set comments(List<UserFacebookComment> value) {
    _comments = value;
    notifyListeners();
  }

  List<SaleOnlineOrder> _saleOrders = [];
  List<SaleOnlineOrder> get saleOrders => _saleOrders;
  set saleOrders(List<SaleOnlineOrder> value) {
    _saleOrders = value;
    notifyListeners();
  }

  Future<void> getUserFacebooks(String userId, int teamId) async {
    setState(true);
    try {
      final result = await _tposApi.getDetailUserFacebook(userId, teamId);
      if (result != null) {
        partner = result;
      }
      setState(false);
    } catch (e, s) {
      logger.error("get UserFacebook fail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> getComments(String postId, String userId) async {
    setState(true);
    try {
      final result =
          await _tposApi.getCommentUserFacebook(userId: userId, postId: postId);
      comments = result;
      setState(false);
    } catch (e, s) {
      logger.error("get UserFacebook fail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> getOrderSaleOnline(String postId, String userId) async {
    setState(true);
    try {
      final result =
          await _tposApi.getOrderSaleOnline(userId: userId, postId: postId);
      saleOrders = result;
      setState(false);
    } catch (e, s) {
      logger.error("get UserFacebook fail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }
}
