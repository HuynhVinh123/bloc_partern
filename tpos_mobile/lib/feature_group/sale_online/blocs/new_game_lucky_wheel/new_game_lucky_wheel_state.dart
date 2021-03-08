import 'package:tpos_mobile/feature_group/sale_online/game/lucky_wheel/lucky_wheel_setting.dart';
import 'package:tpos_mobile/feature_group/sale_online/game/lucky_wheel/player.dart';

abstract class GameLuckyWheelState {}

class GameLuckyWheelLoading extends GameLuckyWheelState {}

class GameLuckyWheelBusy extends GameLuckyWheelState {}

class GameLuckyWheelLoadSuccess extends GameLuckyWheelState {
  GameLuckyWheelLoadSuccess({this.players, this.setting, this.winners});

  final List<Player> players;
  final List<Player> winners;
  final LuckyWheelSetting setting;
}

class GameLuckyWheelInitialSuccess extends GameLuckyWheelLoadSuccess {
  GameLuckyWheelInitialSuccess({List<Player> players, List<Player> winners, LuckyWheelSetting setting})
      : super(players: players, setting: setting, winners: winners);
}

class GameLuckyWheelFinished extends GameLuckyWheelLoadSuccess {
  GameLuckyWheelFinished({
    List<Player> players,
    List<Player> winners,
    LuckyWheelSetting setting,
    this.winPlayer,
  }) : super(players: players, setting: setting, winners: winners);

  final Player winPlayer;
}

class GameLuckyWheelInsertSuccess extends GameLuckyWheelLoadSuccess {
  GameLuckyWheelInsertSuccess({
    List<Player> players,
    LuckyWheelSetting setting,
    List<Player> winners,
  }) : super(players: players, setting: setting, winners: winners);
}

class GameLuckyWheelShareSuccess extends GameLuckyWheelLoadSuccess {
  GameLuckyWheelShareSuccess({
    List<Player> players,
    LuckyWheelSetting setting,
    List<Player> winners,
  }) : super(players: players, setting: setting, winners: winners);

}

class GameLuckyWheelShareError extends GameLuckyWheelState {
  GameLuckyWheelShareError({this.error});

  final String error;
}

class GameLuckyWheelGameStartError extends GameLuckyWheelState {
  GameLuckyWheelGameStartError({this.error});

  final String error;
}

class GameLuckyWheelLoadFailure extends GameLuckyWheelState {
  GameLuckyWheelLoadFailure({this.error});

  final String error;
}

class GameLuckyWheelGameError extends GameLuckyWheelState {
  GameLuckyWheelGameError({this.error});

  final String error;
}


class GameLuckyWheelWinnerSaveError extends GameLuckyWheelState {
  GameLuckyWheelWinnerSaveError({this.error});

  final String error;
}

class GameLuckyWheelWinnerPrintError extends GameLuckyWheelState {
  GameLuckyWheelWinnerPrintError({this.error});

  final String error;
}

class GameLuckyWheelWinnerGetError extends GameLuckyWheelState {
  GameLuckyWheelWinnerGetError({this.error});

  final String error;
}

class GameLuckyWheelWinnerSaveSuccess extends GameLuckyWheelLoadSuccess {
  GameLuckyWheelWinnerSaveSuccess({
    List<Player> players,
    LuckyWheelSetting setting,
    List<Player> winners,
  }) : super(players: players, setting: setting, winners: winners);
}

class GameLuckyWheelWinnerPrintSuccess extends GameLuckyWheelLoadSuccess {
  GameLuckyWheelWinnerPrintSuccess({
    List<Player> players,
    LuckyWheelSetting setting,
    List<Player> winners,
  }) : super(players: players, setting: setting, winners: winners);
}