import 'package:tpos_mobile/feature_group/sale_online/game/lucky_wheel/player.dart';

abstract class LuckyWheelPlayerState {}

class LuckyWheelPlayerLoadSuccess extends LuckyWheelPlayerState {
  LuckyWheelPlayerLoadSuccess({this.players});

  final List<Player> players;
}

class LuckyWheelPlayerBusy extends LuckyWheelPlayerState {}
class LuckyWheelPlayerLoading extends LuckyWheelPlayerState {}