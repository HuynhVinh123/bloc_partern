import 'package:facebook_api_client/facebook_api_client.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';
import 'package:tpos_mobile/services/app_setting_service.dart';
import 'package:tpos_mobile/services/config_service/h_adapters/h_config_base.dart';
import 'package:tpos_mobile/services/config_service/h_adapters/h_config_schema.dart';

const _allowPrintManyTimeKey = HConfigSchema(
  'saleFacebookConfig_allowPrintManyTime',
  true,
);
const _enablePrintKey = HConfigSchema(
  'saleFacebookConfig_enablePrint',
  true,
);

const _printAddressKey = HConfigSchema(
  'saleFacebookConfig_printAddress',
  true,
);

const _printCommentKey = HConfigSchema(
  'saleFacebookConfig_printComment',
  true,
);

const _printAllOrderNoteKey = HConfigSchema(
  'saleFacebookConfig__printAllOrderNote',
  false,
);

const _printPartnerNoteKey = HConfigSchema(
  'saleFacebookConfig__printPartnerNote',
  false,
);

const _printCustomHeaderKey = HConfigSchema(
  'saleFacebookConfig_printCustomHeader',
  false,
);

const _customHeaderKey = HConfigSchema(
  'saleFacebookConfig_customHeader',
  '',
);

const _fetchCommentDurationSecondKey = HConfigSchema(
  'saleFacebookConfig_fetchCommentDurationSecond',
  5,
);

const _printOnlyOnePerPartner = HConfigSchema(
  'saleFacebookConfig_printOnlyOnePerPartner',
  false,
);

const _postCountPerFetchTimesKey = HConfigSchema(
  'saleFacebookConfig_postCountPerFetchTimes',
  20,
);

const _commentCountPerFetchTimesKey = HConfigSchema(
  'saleFacebookConfig_commentCountPerFetchTimes',
  200,
);

const _printAllOrderNoteWhenRePrintKey = HConfigSchema(
  'saleFacebookConfig_printAllOrderNoteWhenRePrint',
  false,
);

const _hideShortCommentKey =
    HConfigSchema('saleFacebookConfig_hideShortComment', false);

const _printNoSignKey = HConfigSchema('saleFacebookConfig_printNoSign', false);

const _autoSaveCommentEveryInMinuteKey =
    HConfigSchema('saleFacebookConfig_autoSaveCommentEveryInMinute', 5);

const _commentRateKey = HConfigSchema(
    'saleFacebookConfig_commentRate', CommentRate.one_hundred_per_second);

const _orderCommentByKey = HConfigSchema('saleFacebookConfig_orderCommentBy',
    SaleOnlineCommentOrderBy.DATE_CREATE_DESC);

const _showCommentTimeAsTimeAgoKey =
    HConfigSchema('saleFacebookConfig_showCommentTimeAsTimeAgo', true);

const _printPaperSizeKey =
    HConfigSchema('saleFacebookConfig_printPaperSize', 'BILL80-RAW');

class HSaleOnlineConfig extends HconfigBase {
  HSaleOnlineConfig(Box hive) : super(hive);

  /// Lưu giá trị xác định có cho phép in nhiều lần trên một comment hay không.
  bool _allowPrintManyTime;
  bool get allowPrintManyTime =>
      _allowPrintManyTime ??
      (_allowPrintManyTime = hive.get(_allowPrintManyTimeKey.key,
          defaultValue: _allowPrintManyTimeKey.defaultValue));

  set allowPrintManyTime(bool value) {
    _allowPrintManyTime = value;
    hive.put(_allowPrintManyTimeKey.key, value);
  }

  /// Có cho phép in phiếu [Bán hàng qua facebook] hay không.
  bool _enablePrint;
  bool get enablePrint =>
      _enablePrint ??
      (_enablePrint = hive.get(_enablePrintKey.key,
          defaultValue: _enablePrintKey.defaultValue));

  set enablePrint(bool value) {
    _enablePrint = value;
    hive.put(_enablePrintKey.key, value);
  }

  /// Có in địa chỉ hay không.
  bool _printAddress;

  bool get printAddress =>
      _printAddress ??
      (_printAddress = hive.get(_printAddressKey.key,
          defaultValue: _printAddressKey.defaultValue));
  set printAddress(bool value) {
    _printAddress = value;
    hive.put(_printAddressKey.key, value);
  }

  /// Có in comment hay không.
  bool _printComment;
  bool get printComment =>
      _printComment ??
      (_printComment = hive.get(_printCommentKey.key,
          defaultValue: _printCommentKey.defaultValue));

  set printComment(bool value) {
    hive.put(_printCommentKey.key, _printComment = value);
  }

  /// In tất cả ghi chú đơn hàng
  bool _printAllOrderNote;

  bool get printAllOrderNote =>
      _printAllOrderNote ??
      (_printAllOrderNote = hive.get(_printAllOrderNoteKey.key,
          defaultValue: _printAllOrderNoteKey.defaultValue));
  set printAllOrderNote(bool value) {
    _printAllOrderNote = value;
    hive.put(_printAllOrderNoteKey.key, value);
  }

  /// In ghi chú khách hàng
  bool _printPartnerNote;
  bool get printPartnerNote {
    return _printPartnerNote ??= hive.get(_printPartnerNoteKey.key,
        defaultValue: _printPartnerNoteKey.defaultValue);
  }

  set printPartnerNote(bool value) =>
      hive.put(_printPartnerNoteKey.key, _printPartnerNote = value);

  /// In một header tùy chỉnh riêng trên thiết bị này.
  bool _printCustomHeader;

  bool get printCustomHeader =>
      _printCustomHeader ??
      (_printCustomHeader = hive.get(_printCustomHeaderKey.key,
          defaultValue: _printCustomHeaderKey.defaultValue));

  set printCustomHeader(bool value) =>
      hive.put(_printCustomHeaderKey.key, _printCustomHeader = value);

  /// Nội dung header tùy chỉnh
  String _customHeader;

  String get customHeader => _customHeader ??= hive.get(_customHeaderKey.key,
      defaultValue: _customHeaderKey.defaultValue);

  set customHeader(String value) =>
      hive.put(_customHeaderKey.key, _customHeader = value);

  /// Số giây sẽ tải lại comment.
  int _fetchCommentDurationSecond;
  int get fetchCommentDurationSecond => _fetchCommentDurationSecond ??=
      hive.get(_fetchCommentDurationSecondKey.key,
          defaultValue: _fetchCommentDurationSecondKey.defaultValue);

  set fetchCommentDurationSecond(int value) => hive.put(
      _fetchCommentDurationSecondKey.key, _fetchCommentDurationSecond = value);

  /// Chỉ in 1 lần nếu cùng khách hàng
  bool _printOnlyOneIfHaveOrder;

  bool get printOnlyOneIfHaveOrder =>
      _printOnlyOneIfHaveOrder ??= hive.get(_printOnlyOnePerPartner.key,
          defaultValue: _printOnlyOnePerPartner.defaultValue);

  set printOnlyOneIfHaveOrder(bool value) =>
      hive.put(_printOnlyOnePerPartner.key, _printOnlyOneIfHaveOrder = value);

  /// Số bài đăng facebook sẽ tải trong 1 lần gửi request
  int _postCountPerFetchTimes;
  int get postCountPerFetchTimes =>
      _postCountPerFetchTimes ??= hive.get(_postCountPerFetchTimesKey.key,
          defaultValue: _postCountPerFetchTimesKey.defaultValue);

  set postCountPerFetchTimes(int value) =>
      hive.put(_postCountPerFetchTimesKey.key, _postCountPerFetchTimes = value);

  /// Số comment sẽ tải trong 1 lần request.
  int _commentCountPerFetchTimes;
  int get commentCountPerFetchTimes =>
      _commentCountPerFetchTimes ??= hive.get(_commentCountPerFetchTimesKey.key,
          defaultValue: _commentCountPerFetchTimesKey.defaultValue);

  set commentCountPerFetchTimes(int value) => hive.put(
      _commentCountPerFetchTimesKey.key, _postCountPerFetchTimes = value);

  bool get printAllOrderNoteWhenReprint =>
      hive.get(_printAllOrderNoteWhenRePrintKey.key,
          defaultValue: _printAllOrderNoteWhenRePrintKey.defaultValue);
  set printAllOrderNoteWhenReprint(bool value) =>
      hive.put(_printAllOrderNoteWhenRePrintKey.key, value);

  /// Ẩn bình luận có ít hơn 3 kí tự
  bool _hideShortComment;
  bool get hideShortComment =>
      _hideShortComment ??= hive.get(_hideShortCommentKey.key,
          defaultValue: _hideShortCommentKey.defaultValue);

  set hideShortComment(bool value) =>
      hive.put(_hideShortCommentKey.key, _hideShortComment = value);

  /// In không dấu
  bool _printNoSign;
  bool get printNoSign => _printNoSign ??=
      hive.get(_printNoSignKey.key, defaultValue: _printNoSignKey.defaultValue);

  set printNoSign(bool value) =>
      hive.put(_printNoSignKey.key, _printNoSign = value);

  /// Tự động lưu comment mỗi n phút
  int _autoSaveCommentEveryInMinute;
  int get autoSaveCommentEveryInMinute => _autoSaveCommentEveryInMinute ??=
      hive.get(_autoSaveCommentEveryInMinuteKey.key,
          defaultValue: _autoSaveCommentEveryInMinuteKey.defaultValue);

  set autoSaveCommentEveryInMinute(int value) => hive.put(
      _autoSaveCommentEveryInMinuteKey.key,
      _autoSaveCommentEveryInMinute = value);

  /// lượng comment sẽ tải về
  ///   one_per_two_seconds,
  ///   ten_per_second,
  ///   one_hundred_per_second,
  CommentRate _fetchCommentRate;
  CommentRate get fetchCommentRate {
    if (_fetchCommentRate == null) {
      final String str = hive.get(_commentRateKey.key);
      if (str.isNotNullOrEmpty()) {
        _fetchCommentRate = str.toEnum<CommentRate>(CommentRate.values);
      }
    }

    return _fetchCommentRate ?? _commentRateKey.defaultValue;
  }

  set fetchCommentRate(CommentRate value) {
    _fetchCommentRate = value;
    hive.put(_commentRateKey.key, value.describe);
  }

  /// Sắp xếp bình luận khi vào bài live. Mới nhất ở cuối hoặc ở trên đầu
  SaleOnlineCommentOrderBy _orderCommentBy;

  SaleOnlineCommentOrderBy get orderCommentBy {
    if (_orderCommentBy == null) {
      final String str = hive.get(_orderCommentByKey.key);
      if (str.isNotNullOrEmpty()) {
        _orderCommentBy = str
            .toEnum<SaleOnlineCommentOrderBy>(SaleOnlineCommentOrderBy.values);
      }
    }
    return _orderCommentBy ?? _orderCommentByKey.defaultValue;
  }

  set orderCommentBy(SaleOnlineCommentOrderBy value) {
    _orderCommentBy = value;
    hive.put(_orderCommentByKey.key, describeEnum(value));
  }

  /// Hiện thời gian bình luận dưới dạng time ago
  bool _showCommentTimeAsTimeAgo;
  bool get showCommentTimeAsTimeAgo =>
      _showCommentTimeAsTimeAgo ??= hive.get(_showCommentTimeAsTimeAgoKey.key,
          defaultValue: _showCommentTimeAsTimeAgoKey.defaultValue);

  set showCommentTimeAsTimeAgo(bool value) {
    _showCommentTimeAsTimeAgo = value;
    hive.put(_showCommentTimeAsTimeAgoKey.key, value);
  }

  String _printPaperSize;
  String get printPaperSize =>
      _printPaperSize ??= hive.get(_printPaperSizeKey.key,
          defaultValue: _printPaperSizeKey.defaultValue);

  set printPaperSize(String value) {
    _printPaperSize = value;
    hive.put(_printPaperSizeKey.key, value);
  }

  @override
  void fromJson(Map<String, dynamic> json) {
    allowPrintManyTime =
        json[_allowPrintManyTimeKey.key] ?? _allowPrintManyTimeKey.defaultValue;
    enablePrint = json[_enablePrintKey.key] ?? _enablePrintKey.defaultValue;
    printAddress = json[_printAddressKey.key] ?? _printAddressKey.defaultValue;
    printComment = json[_printCommentKey.key] ?? _printCommentKey.defaultValue;
    printAllOrderNote =
        json[_printAllOrderNoteKey.key] ?? _printAllOrderNoteKey.defaultValue;
    printPartnerNote =
        json[_printPartnerNoteKey.key] ?? _printPartnerNoteKey.defaultValue;
    printCustomHeader =
        json[_printCustomHeaderKey.key] ?? _printCustomHeaderKey.defaultValue;
    customHeader = json[_customHeaderKey.key] ?? _customHeaderKey.defaultValue;
    postCountPerFetchTimes = json[_postCountPerFetchTimesKey.key] ??
        _postCountPerFetchTimesKey.defaultValue;
    commentCountPerFetchTimes = json[_commentCountPerFetchTimesKey.key] ??
        _commentCountPerFetchTimesKey.defaultValue;
    printAllOrderNoteWhenReprint = json[_printAllOrderNoteWhenRePrintKey.key] ??
        _printAllOrderNoteWhenRePrintKey.defaultValue;

    hideShortComment =
        json[_hideShortCommentKey.key] ?? _hideShortCommentKey.defaultValue;

    printNoSign = json[_printNoSignKey.key] ?? _printNoSignKey.defaultValue;

    if (json[_orderCommentByKey.key] != null) {
      final String jsonString = json[_orderCommentByKey.key];
      orderCommentBy = jsonString
          .toEnum<SaleOnlineCommentOrderBy>(SaleOnlineCommentOrderBy.values);
    } else {
      orderCommentBy = _orderCommentByKey.defaultValue;
    }

    if (json[_commentRateKey.key] != null) {
      final String jsonString = json[_commentRateKey.key];
      fetchCommentRate = jsonString.toEnum<CommentRate>(CommentRate.values);
    } else {
      fetchCommentRate = _commentRateKey.defaultValue;
    }
  }

  @override
  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[_allowPrintManyTimeKey.key] = allowPrintManyTime;
    data[_enablePrintKey.key] = enablePrint;
    data[_printAddressKey.key] = printAddress;
    data[_printCommentKey.key] = printComment;
    data[_printAllOrderNoteKey.key] = printAllOrderNote;
    data[_printPartnerNoteKey.key] = printPartnerNote;
    data[_printCustomHeaderKey.key] = printCustomHeader;
    data[_fetchCommentDurationSecondKey.key] = fetchCommentDurationSecond;
    data[_postCountPerFetchTimesKey.key] = postCountPerFetchTimes;
    data[_commentCountPerFetchTimesKey.key] = commentCountPerFetchTimes;
    data[_printAllOrderNoteWhenRePrintKey.key] = printAllOrderNoteWhenReprint;
    data[_hideShortCommentKey.key] = hideShortComment;
    data[_printNoSignKey.key] = printNoSign;
    data[_commentRateKey.key] = fetchCommentRate.describe;
    data[_orderCommentByKey.key] = describeEnum(_orderCommentBy);

    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }

    return data;
  }
}
