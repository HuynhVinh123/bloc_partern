import 'package:facebook_api_client/facebook_api_client.dart';
import 'package:tmt_flutter_untils/tmt_flutter_utils.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/app_setting_service.dart';

class CommentData {
  CommentData(
      {ISettingService settingService,
      this.comment,
      this.receiveData,
      this.source,
      this.postId,
      this.order,
      this.partner}) {
    _setting = settingService ?? locator<ISettingService>();
  }
  ISettingService _setting;
  FacebookComment comment;
  DateTime receiveData;
  CommentSource source;
  String postId;

  bool isHiddenFromUi = false;

  /// Them reply comment
  List<CommentData> comments;

  /// Đơn hàng đã tạo từ comment này
  SaleOnlineOrder order;

  /// Khách hàng lên quan tới tài khoản facebook này
  Partner partner;

  int printCount = 0;

  /// Lấy Id của người đã bình luận comment
  ///
  /// Một lỗi sẽ được phát sinh nếu [comment] chưa được truyền vào
  String get commentAuthorId {
    if (comment == null) {
      throw Exception('author id can\'t get when [comment] is null');
    }
    return comment.from.id;
  }

  String get message => comment.message;

  /// Đã có số điện thoại hay chưa
  bool get hasPhone => partner?.phone?.isNotNullOrEmpty() ?? false;

  /// Đã có địa chỉ hay chưa
  bool get hasAddress => partner?.addressFull?.isNotNullOrEmpty() ?? false;

  /// Mã khách hàng
  String get partnerCode => partner?.ref;

  /// gets Comment có bị ẩn hay không
  bool get isHidden => comment?.isHidden;

  /// gets Hình đại diện
  String get avatarLink => comment?.from?.pictureLink ?? '';
}

enum CommentSource {
  realtimeComment,
  fetchCommentOnLivestream,
  fetchCommentOnApi
}
