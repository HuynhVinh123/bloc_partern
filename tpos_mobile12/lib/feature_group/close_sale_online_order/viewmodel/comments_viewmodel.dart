import 'dart:collection';

import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/close_sale_online_order/viewmodel/view_model.dart';
import 'package:tpos_mobile/locator.dart';

import 'comment_viewmodel.dart';

/// Register it singleton in get_it to call everywhere
class CommentsViewModel extends NViewModel {
  CommentsViewModel({PartnerApi partnerApi}) {
    _partnerApi = partnerApi ?? GetIt.I<PartnerApi>();
  }
  PartnerApi _partnerApi;

  /// Danh sách live đang mở
  List<CommentViewModel> _commentViewModels = <CommentViewModel>[];

  /// Danh sách khách hàng, dùng chung cho taats cả live đang mở
  List<Partner> _partners = <Partner>[];

  /// Tìm partner trong danh sách theo id tác giả comment
  Partner getPartnerByFacebookId(String id) {
    return _partners.firstWhere((element) => element.facebookASids == id,
        orElse: () => null);
  }

  /// Thêm một phiên mới
  void addSession(CommentViewModel viewModel) {
    _commentViewModels.add(viewModel);
  }

  /// Đóng và xóa một phiên
  void closeSession(CommentViewModel viewModel) {
    viewModel.dispose();
    _commentViewModels.remove(viewModel);
  }

  PublishSubject<Partner> _partnerSubject = PublishSubject<Partner>();

  /// Tải danh sách khách hàng và lưu trữ
  void fetchPartners() {}

  @override
  Future<void> init() {
    // TODO: implement init
    throw UnimplementedError();
  }

  @override
  Future<void> load() {
    // TODO: implement load
    throw UnimplementedError();
  }
}
