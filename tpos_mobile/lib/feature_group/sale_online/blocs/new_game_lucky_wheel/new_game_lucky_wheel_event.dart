import 'package:tpos_mobile/feature_group/sale_online/game/lucky_wheel/lucky_wheel_setting.dart';
import 'package:tpos_mobile/feature_group/sale_online/game/lucky_wheel/player.dart';

abstract class GameLuckyWheelEvent {}

class GameLuckyWheelLoaded extends GameLuckyWheelEvent {
  GameLuckyWheelLoaded({this.token});

  final String token;
}

class GameLuckyWheelStarted extends GameLuckyWheelEvent {}

class GameLuckyWheelRefreshed extends GameLuckyWheelEvent {}

class GameLuckyWheelEnded extends GameLuckyWheelEvent {
  GameLuckyWheelEnded({this.winner});

  final Player winner;
}

class GameLuckyWheelPlayerInserted extends GameLuckyWheelEvent {
  GameLuckyWheelPlayerInserted({this.player});

  final Player player;
}

class GameLuckyWheelSaveConfig extends GameLuckyWheelEvent {
  GameLuckyWheelSaveConfig({this.luckyWheelSetting});

  final LuckyWheelSetting luckyWheelSetting;
}

class GameLuckyWheelWinnerUpdateLocal extends GameLuckyWheelEvent {
  GameLuckyWheelWinnerUpdateLocal({this.players});

  final List<Player> players;
}

class GameLuckyWheelPlayerShared extends GameLuckyWheelEvent {
  GameLuckyWheelPlayerShared({this.winner});
  final Player winner;
}