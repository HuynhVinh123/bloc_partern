import 'package:tpos_mobile/feature_group/sale_online/game/lucky_wheel/player.dart';

abstract class LuckyWheelWinnerEvent {}

class LuckyWheelWinnerInitial extends LuckyWheelWinnerEvent {
  LuckyWheelWinnerInitial({this.players, this.pageAccessToken});

  final List<Player> players;
  final String pageAccessToken;
}

class LuckyWheelWinnerSearched extends LuckyWheelWinnerEvent {
  LuckyWheelWinnerSearched({this.keyword});

  final String keyword;
}

class LuckyWheelWinnerSorted extends LuckyWheelWinnerEvent {}

class LuckyWheelWinnerMessageSent extends LuckyWheelWinnerEvent {
  LuckyWheelWinnerMessageSent({this.player});

  final Player player;
}

class LuckyWheelWinnerDeleted extends LuckyWheelWinnerEvent {
  LuckyWheelWinnerDeleted({this.player});

  final Player player;
}

class LuckyWheelWinnerPageShared extends LuckyWheelWinnerEvent {}


class LuckyWheelWinnerPrinted extends LuckyWheelWinnerEvent {
  LuckyWheelWinnerPrinted({this.player});

  final Player player;
}

class LuckyWheelWinnerUpdateLocal extends LuckyWheelWinnerEvent {
  LuckyWheelWinnerUpdateLocal({this.players});

  final List<Player> players;
}
