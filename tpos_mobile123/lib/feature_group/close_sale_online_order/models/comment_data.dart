import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/app_setting_service.dart';
import 'package:tpos_mobile/src/facebook_apis/facebook_api.dart';

import 'package:timeago/timeago.dart' as time_ago;
import 'package:tmt_flutter_untils/tmt_flutter_utils.dart';

import 'print_order_status.dart';

class CommentData {
  ISettingService _setting;
  FacebookComment comment;
  DateTime receiveData;
  CommentSource source;
  String postId;

  bool isHiddenFromUi = false;

  /// Trạng thái in hóa đơn
  PrintOrderStatus _printOrderStatus = PrintOrderStatus.none;

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

  /// Comment time
  String get commentTime {
    return _setting.isSaleOnlineViewTimeAgoOnLiveComment
        ? time_ago.format(comment.createdTime, locale: "vi_short")
        : DateFormat(
                "${DateTime.now().day != comment.createdTime.day ? "dd/MM/yyyy HH:mm:ss" : "HH:mm:ss"}")
            .format(comment.createdTime.toLocal());
  }

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
}

enum CommentSource {
  realtimeComment,
  fetchCommentOnLivestream,
  fetchCommentOnApi
}
