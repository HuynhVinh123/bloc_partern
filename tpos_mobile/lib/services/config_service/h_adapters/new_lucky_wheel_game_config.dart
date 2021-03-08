import 'package:hive/hive.dart';

import 'h_config_base.dart';

class NewLuckyWheelGameConfig extends HconfigBase {
  NewLuckyWheelGameConfig(Box hive) : super(hive);

  bool _luckyWheelHasOrder;
  bool _luckyWheelIgnoreWinnerPlayer;
  bool _luckyWheelPrioritySharers;
  bool _luckyWheelPriorityGroupSharers;
  bool _luckyWheelPriorityPersonalSharers;
  bool _luckyWheelPriorityCommentPlayers;
  bool _luckyWheelPriorityIgnoreWinner;
  int _luckyWheelTimeInSecond;
  int _luckyWheelSkipDays;
  int _luckyWheelMinNumberComment;
  int _luckyWheelMinNumberShare;
  int _luckyWheelMinNumberShareGroup;
  bool _luckyWheelIsPriority;
  bool _luckyWheelUseApi;
  bool _luckyWheelIsMinShare;
  bool _luckyWheelIsMinShareGroup;
  bool _luckyWheelIsMinComment;
  bool _luckyWheelPriorityUnWinner;

  int get luckyWheelMinNumberComment =>
      _luckyWheelMinNumberComment ??
      (_luckyWheelMinNumberComment = hive.get('luckyWheelMinNumberComment')) ??
      1;

  int get luckyWheelMinNumberShare =>
      _luckyWheelMinNumberShare ??
      (_luckyWheelMinNumberShare = hive.get('luckyWheelMinNumberShare')) ??
      1;

  int get luckyWheelMinNumberShareGroup =>
      _luckyWheelMinNumberShareGroup ??
      (_luckyWheelMinNumberShareGroup =
          hive.get('luckyWheelMinNumberShareGroup')) ??
      1;

  bool get luckyWheelPriorityUnWinner =>
      _luckyWheelPriorityUnWinner ??
      (_luckyWheelPriorityUnWinner = hive.get('luckyWheelPriorityUnWinner')) ??
      false;

  bool get luckyWheelIsMinShare =>
      _luckyWheelIsMinShare ??
      (_luckyWheelIsMinShare = hive.get('luckyWheelIsMinShare')) ??
      false;

  bool get luckyWheelIsMinComment =>
      _luckyWheelIsMinComment ??
      (_luckyWheelIsMinComment = hive.get('luckyWheelIsMinComment')) ??
      false;

  bool get luckyWheelIsMinShareGroup =>
      _luckyWheelIsMinShareGroup ??
      (_luckyWheelIsMinShareGroup = hive.get('luckyWheelIsMinShareGroup')) ??
      false;


  bool get luckyWheelHasOrder =>
      _luckyWheelHasOrder ??
      (_luckyWheelHasOrder = hive.get('luckyWheelHasOrder')) ??
      false;


  bool get luckyWheelIgnoreWinnerPlayer =>
      _luckyWheelIgnoreWinnerPlayer ??
      (_luckyWheelIgnoreWinnerPlayer =
          hive.get('luckyWheelIgnoreWinnerPlayer')) ??
      true;

  bool get luckyWheelPriorityCommentPlayers =>
      _luckyWheelPriorityCommentPlayers ??
      (_luckyWheelPriorityCommentPlayers =
          hive.get('luckyWheelPriorityCommentPlayers')) ??
      true;

  bool get luckyWheelPriorityGroupSharers =>
      _luckyWheelPriorityGroupSharers ??
      (_luckyWheelPriorityGroupSharers =
          hive.get('luckyWheelPriorityGroupSharers')) ??
      true;

  bool get luckyWheelPriorityIgnoreWinner =>
      _luckyWheelPriorityIgnoreWinner ??
      (_luckyWheelPriorityIgnoreWinner =
          hive.get('luckyWheelPriorityIgnoreWinner')) ??
      true;

  bool get luckyWheelPriorityPersonalSharers =>
      _luckyWheelPriorityPersonalSharers ??
      (_luckyWheelPriorityPersonalSharers =
          hive.get('luckyWheelPriorityPersonalSharers')) ??
      true;

  bool get luckyWheelPrioritySharers =>
      _luckyWheelPrioritySharers ??
      (_luckyWheelPrioritySharers = hive.get('luckyWheelPrioritySharers')) ??
      true;

  int get luckyWheelTimeInSecond =>
      _luckyWheelTimeInSecond ??
      (_luckyWheelTimeInSecond = hive.get('luckyWheelTimeInSecond')) ??
      10;

  int get luckyWheelSkipDays =>
      _luckyWheelSkipDays ??
      (_luckyWheelSkipDays = hive.get('luckyWheelSkipDays')) ??
      14;

  bool get luckyWheelIsPriority =>
      _luckyWheelIsPriority ??
      (_luckyWheelIsPriority = hive.get('luckyWheelIsPriority')) ??
      true;

  bool get luckyWheelUseApi =>
      _luckyWheelUseApi ??
      (_luckyWheelUseApi = hive.get('luckyWheelUseApi')) ??
      true;

  void setLuckyWheelIsPriority(bool value) {
    if (_luckyWheelIsPriority != value) {
      _luckyWheelIsPriority = value ?? luckyWheelIsPriority;
      hive.put('luckyWheelIsPriority', _luckyWheelIsPriority);
    }
  }


  void setLuckyWheelHasOrder(bool value) {
    if (_luckyWheelHasOrder != value) {
      _luckyWheelHasOrder = value ?? luckyWheelHasOrder;
      hive.put('luckyWheelHasOrder', _luckyWheelHasOrder);
    }
  }

  void setLuckyWheelIgnoreWinnerPlayer(bool value) {
    if (_luckyWheelIgnoreWinnerPlayer != value) {
      _luckyWheelIgnoreWinnerPlayer = value ?? luckyWheelIgnoreWinnerPlayer;
      hive.put('luckyWheelIgnoreWinnerPlayer', _luckyWheelIgnoreWinnerPlayer);
    }
  }

  void setLuckyWheelPriorityGroupSharers(bool value) {
    if (_luckyWheelPriorityGroupSharers != value) {
      _luckyWheelPriorityGroupSharers = value ?? luckyWheelPriorityGroupSharers;
      hive.put(
          'luckyWheelPriorityGroupSharers', _luckyWheelPriorityGroupSharers);
    }
  }

  void setLuckyWheelPriorityIgnoreWinner(bool value) {
    if (_luckyWheelPriorityIgnoreWinner != value) {
      _luckyWheelPriorityIgnoreWinner = value ?? luckyWheelPriorityIgnoreWinner;
      hive.put(
          'luckyWheelPriorityIgnoreWinner', _luckyWheelPriorityIgnoreWinner);
    }
  }

  void setLuckyWheelPriorityPersonalSharers(bool value) {
    if (_luckyWheelPriorityPersonalSharers != value) {
      _luckyWheelPriorityPersonalSharers =
          value ?? luckyWheelPriorityPersonalSharers;
      hive.put('luckyWheelPriorityPersonalSharers',
          _luckyWheelPriorityPersonalSharers);
    }
  }

  void setLuckyWheelPrioritySharers(bool value) {
    if (_luckyWheelPrioritySharers != value) {
      _luckyWheelPrioritySharers = value ?? luckyWheelPrioritySharers;
      hive.put('luckyWheelPrioritySharers', _luckyWheelPrioritySharers);
    }
  }

  void setLuckyWheelTimeInSecond(int value) {
    if (_luckyWheelTimeInSecond != value) {
      _luckyWheelTimeInSecond = value ?? luckyWheelTimeInSecond;
      hive.put('luckyWheelTimeInSecond', _luckyWheelTimeInSecond);
    }
  }

  void setLuckyWheelSkipDays(int value) {
    if (_luckyWheelSkipDays != value) {
      _luckyWheelSkipDays = value ?? luckyWheelSkipDays;
      hive.put('luckyWheelSkipDays', _luckyWheelSkipDays);
    }
  }

  void setLuckyWheelPriorityCommentPlayers(bool value) {
    if (_luckyWheelPriorityCommentPlayers != value) {
      _luckyWheelPriorityCommentPlayers =
          value ?? luckyWheelPriorityCommentPlayers;
      hive.put('luckyWheelPriorityCommentPlayers',
          _luckyWheelPriorityCommentPlayers);
    }
  }

  void setLuckyWheelMinNumberComment(int value) {
    if (_luckyWheelMinNumberComment != value) {
      _luckyWheelMinNumberComment = value ?? luckyWheelMinNumberComment;
      hive.put('luckyWheelMinNumberComment', _luckyWheelMinNumberComment);
    }
  }

  void setLuckyWheelUseApi(bool value) {
    if (_luckyWheelUseApi != value) {
      _luckyWheelUseApi = value ?? luckyWheelUseApi;
      hive.put('luckyWheelUseApi', _luckyWheelUseApi);
    }
  }

  void setLuckyWheelMinNumberShare(int value) {
    if (_luckyWheelMinNumberShare != value) {
      _luckyWheelMinNumberShare = value ?? luckyWheelMinNumberShare;
      hive.put('luckyWheelMinNumberShare', _luckyWheelMinNumberShare);
    }
  }

  void setLuckyWheelMinNumberShareGroup(int value) {
    if (_luckyWheelMinNumberShareGroup != value) {
      _luckyWheelMinNumberShareGroup = value ?? luckyWheelMinNumberShareGroup;
      hive.put('luckyWheelMinNumberShareGroup', _luckyWheelMinNumberShareGroup);
    }
  }

  void setLuckyWheelIsMinShare(bool value) {
    if (_luckyWheelIsMinShare != value) {
      _luckyWheelIsMinShare = value ?? luckyWheelIsMinShare;
      hive.put('luckyWheelIsMinShare', _luckyWheelIsMinShare);
    }
  }

  void setLuckyWheelIsMinComment(bool value) {
    if (_luckyWheelIsMinComment != value) {
      _luckyWheelIsMinComment = value ?? luckyWheelIsMinComment;
      hive.put('luckyWheelIsMinComment', _luckyWheelIsMinComment);
    }
  }

  void setLuckyWheelIsMinShareGroup(bool value) {
    if (_luckyWheelIsMinShareGroup != value) {
      _luckyWheelIsMinShare = value ?? luckyWheelIsMinShareGroup;
      hive.put('luckyWheelIsMinShareGroup', _luckyWheelIsMinShareGroup);
    }
  }

  void setLuckyWheelPriorityUnWinner(bool value) {
    if (_luckyWheelPriorityUnWinner != value) {
      _luckyWheelPriorityUnWinner = value ?? luckyWheelPriorityUnWinner;
      hive.put('luckyWheelPriorityUnWinner', _luckyWheelPriorityUnWinner);
    }
  }

  void fromJson(Map<String, dynamic> json) {
    setLuckyWheelIgnoreWinnerPlayer(json['luckyWheelIgnoreWinnerPlayer']);
    setLuckyWheelPriorityGroupSharers(json['luckyWheelPrioritySharers']);
    setLuckyWheelPriorityGroupSharers(json['luckyWheelPriorityGroupSharers']);
    setLuckyWheelPriorityPersonalSharers(
        json['luckyWheelPriorityPersonalSharers']);
    setLuckyWheelPriorityCommentPlayers(
        json['luckyWheelPriorityCommentPlayers']);
    setLuckyWheelPriorityIgnoreWinner(json['luckyWheelPriorityIgnoreWinner']);
    setLuckyWheelTimeInSecond(json['luckyWheelTimeInSecond']);
    setLuckyWheelSkipDays(json['luckyWheelSkipDays']);
    setLuckyWheelIsPriority(json['luckyWheelIsPriority']);
    setLuckyWheelMinNumberComment(json['luckyWheelMinNumberComment']);
    setLuckyWheelUseApi(json['luckyWheelUseApi']);
    setLuckyWheelMinNumberShare(json['luckyWheelMinNumberShare']);
    setLuckyWheelMinNumberShareGroup(json['luckyWheelMinNumberShareGroup']);
    setLuckyWheelIsMinShareGroup(json['luckyWheelIsMinShareGroup']);
    setLuckyWheelIsMinComment(json['luckyWheelIsMinComment']);
    setLuckyWheelIsMinShare(json['luckyWheelIsMinShare']);
    setLuckyWheelPriorityUnWinner(json['luckyWheelPriorityUnWinner']);
  }

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['luckyWheelHasOrder'] = luckyWheelHasOrder;
    data['luckyWheelIgnoreWinnerPlayer'] = luckyWheelIgnoreWinnerPlayer;
    data['luckyWheelPrioritySharers'] = luckyWheelPrioritySharers;
    data['luckyWheelPriorityGroupSharers'] = luckyWheelPriorityGroupSharers;
    data['luckyWheelPriorityPersonalSharers'] =
        luckyWheelPriorityPersonalSharers;
    data['luckyWheelPriorityCommentPlayers'] = luckyWheelPriorityCommentPlayers;
    data['luckyWheelPriorityIgnoreWinner'] = luckyWheelPriorityIgnoreWinner;
    data['luckyWheelTimeInSecond'] = luckyWheelTimeInSecond;

    data['luckyWheelSkipDays'] = luckyWheelSkipDays;
    data['luckyWheelIsPriority'] = luckyWheelIsPriority;
    data['luckyWheelMinNumberComment'] = luckyWheelMinNumberComment;
    data['luckyWheelUseApi'] = luckyWheelUseApi;
    data['luckyWheelMinNumberShare'] = luckyWheelMinNumberShare;
    data['luckyWheelMinNumberShareGroup'] = luckyWheelMinNumberShareGroup;
    data['luckyWheelIsMinShareGroup'] = luckyWheelIsMinShareGroup;
    data['luckyWheelIsMinComment'] = luckyWheelIsMinComment;
    data['luckyWheelIsMinShare'] = luckyWheelIsMinShare;
    data['luckyWheelPriorityUnWinner'] = luckyWheelPriorityUnWinner;
    return data;
  }
}
