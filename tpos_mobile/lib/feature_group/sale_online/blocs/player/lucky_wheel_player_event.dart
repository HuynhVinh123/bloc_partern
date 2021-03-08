import 'package:tpos_mobile/feature_group/sale_online/game/lucky_wheel/player.dart';

abstract class LuckyWheelPlayerEvent {}

class LuckyWheelPlayerSearched extends LuckyWheelPlayerEvent {
  LuckyWheelPlayerSearched({this.keyword});

  final String keyword;
}

class LuckyWheelPlayerInitial extends LuckyWheelPlayerEvent {
  LuckyWheelPlayerInitial({this.players});

  final List<Player> players;
}

class LuckyWheelPlayerSorted extends LuckyWheelPlayerEvent {}
