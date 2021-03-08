import 'package:hive/hive.dart';
import 'package:tpos_mobile/services/config_service/h_adapters/h_config_base.dart';

const String _isWinGameKey = "oldLuckyWheelGame_isWinGame";
const String _isShareGameKey = "oldLuckyWheelGame_isShareGame";
const String _isOrderGameKey = "oldLuckyWheelGame_isOrderGame";
const String _isCommentGameKey = "oldLuckyWheelGame_isCommentGame";
const String _isPriorityGameKey = "oldLuckyWheelGame_isPriorityGame";
const String _isIgnoreRecentWinnerKey =
    "oldLuckyWheelGame_isIgnoreRecentWinner";
const String _ignoreDaysKey = "oldLuckyWheelGame_ignoreDays";
const String _gameDurationInSecondKey = "oldLuckyWheelGame_gameDurationSeconds";

const bool _isWinGameDefaultValue = true;
const bool _isCommentGameDefaultValue = true;
const bool _isShareGameDefaultValue = true;
const bool _isOrderGameDefaultValue = false;
const String _isPriorityGameDefaultValue = 'all';
const bool _isIgnoreRecentWinnerDefaultValue = false;
const int _ignoreDaysDefaultValue = 14;
const int _gameDurationInSecondDefaultValue = 16;

class OldLuckyWheelGameConfig extends HconfigBase {
  OldLuckyWheelGameConfig(Box hive) : super(hive);

  bool _isShareGame;
  bool _isCommentGame;
  bool _isOrderGame;

  /// Bao gồm cả người đã thắng
  bool _isWinGame;
  String _isPriorGame;
  bool _isIgnoreRecentWinner;

  /// Số ngày bỏ qua khi [isIgonoreRecentWInner] được đặt là true
  int _ignoreDays;

  /// Thời gian của 1 vòng quay. Tính bằng giây.
  int _wheelDurationInSecond;

  /// Đối tượng tham gia có bao gồm người thắng game hay không.
  bool get isWinGame =>
      _isWinGame ??
      (_isWinGame = hive.get(
        _isWinGameKey,
        defaultValue: _isWinGameDefaultValue,
      ));

  bool get isShareGame =>
      _isShareGame ??
      (_isShareGame =
          hive.get(_isShareGameKey, defaultValue: _isShareGameDefaultValue));

  bool get isCommentGame =>
      _isCommentGame ??
      (_isCommentGame = hive.get(_isCommentGameKey,
          defaultValue: _isCommentGameDefaultValue));

  bool get isOrderGame =>
      _isOrderGame ??
      (_isOrderGame =
          hive.get(_isOrderGameKey, defaultValue: _isOrderGameDefaultValue));

  String get isPriorGame =>
      _isPriorGame ??
      (_isPriorGame = hive.get(_isPriorityGameKey,
          defaultValue: _isPriorityGameDefaultValue));

  bool get isIgnoreRecentWinner =>
      _isIgnoreRecentWinner ??
      (_isIgnoreRecentWinner = hive.get(_isIgnoreRecentWinnerKey,
          defaultValue: _isIgnoreRecentWinnerDefaultValue));

  int get ignoreDays =>
      _ignoreDays ??
      (_ignoreDays =
          hive.get(_ignoreDaysKey, defaultValue: _ignoreDaysDefaultValue));

  int get gameDurationInSecond =>
      _wheelDurationInSecond ??
      (_wheelDurationInSecond = hive.get(_gameDurationInSecondKey,
          defaultValue: _gameDurationInSecondDefaultValue));
  set isWinGame(bool value) {
    _isWinGame = value ?? _isWinGameDefaultValue;
    hive.put(_isWinGameKey, value);
  }

  set isShareGame(bool value) {
    _isShareGame = value ?? _isShareGameDefaultValue;
    hive.put(_isShareGameKey, value);
  }

  set isCommentGame(bool value) {
    _isCommentGame = value ?? _isCommentGameDefaultValue;
    hive.put(_isCommentGameKey, value);
  }

  set isOrderGame(bool value) {
    _isOrderGame = value ?? _isOrderGameDefaultValue;
    hive.put(_isOrderGameKey, value);
  }

  set isPriorGame(String value) {
    _isPriorGame = value ?? _isPriorityGameDefaultValue;
    hive.put(_isPriorityGameKey, value);
  }

  set isIgnoreRecentWinner(bool value) {
    _isIgnoreRecentWinner = value ?? _isIgnoreRecentWinnerDefaultValue;
    hive.put(_isIgnoreRecentWinnerKey, value);
  }

  set ignoreDays(int value) {
    _ignoreDays = value;
    hive.put(_ignoreDaysKey, value);
  }

  set gameDurationInSecond(int value) {
    _wheelDurationInSecond = value ?? _gameDurationInSecondDefaultValue;
    hive.put(_gameDurationInSecondKey, value);
  }

  @override
  void fromJson(Map<String, dynamic> json) {
    isWinGame = json[_isWinGameKey];
    isShareGame = json[_isShareGameKey];
    isOrderGame = json[_isOrderGameKey];
    isCommentGame = json[_isCommentGameKey];
    isPriorGame = json[_isPriorityGameKey];
    isIgnoreRecentWinner = json[_isIgnoreRecentWinnerKey];
    ignoreDays = json[_ignoreDaysKey]?.toInt();
    gameDurationInSecond = json[_gameDurationInSecondKey]?.toInt();
  }

  @override
  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};

    data[_isWinGameKey] = isWinGame;
    data[_isShareGameKey] = isShareGame;
    data[_isOrderGameKey] = isOrderGame;
    data[_isCommentGameKey] = isCommentGame;
    data[_isPriorityGameKey] = isPriorGame;
    data[_isIgnoreRecentWinnerKey] = isIgnoreRecentWinner;
    data[_ignoreDaysKey] = ignoreDays;
    data[_gameDurationInSecondKey] = gameDurationInSecond;

    return data;
  }

  /// Khôi phục về mặc định
  void resetDefault() {
    isWinGame = null;
    isShareGame = null;
    isOrderGame = null;
    isCommentGame = null;
    isCommentGame = null;
    isPriorGame = null;
    isIgnoreRecentWinner = null;
    ignoreDays = null;
    gameDurationInSecond = null;
  }
}
