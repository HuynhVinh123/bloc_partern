import 'package:tpos_mobile/feature_group/sale_online/game/lucky_wheel/player.dart';

abstract class LuckyWheelWinnerState {}

class LuckyWheelWinnerLoading extends LuckyWheelWinnerState {}

class LuckyWheelWinnerBusy extends LuckyWheelWinnerState {}

class LuckyWheelWinnerLoadSuccess extends LuckyWheelWinnerState {
  LuckyWheelWinnerLoadSuccess({this.players, this.allPlayers});

  final List<Player> players;
  final List<Player> allPlayers;
}

class LuckyWheelWinnerPrintSuccess extends LuckyWheelWinnerLoadSuccess {
  LuckyWheelWinnerPrintSuccess({List<Player> players, List<Player> allPlayers}) : super(players: players, allPlayers: allPlayers);
}


class LuckyWheelWinnerDeleteSuccess extends LuckyWheelWinnerLoadSuccess {
  LuckyWheelWinnerDeleteSuccess({List<Player> players, List<Player> allPlayers}) : super(players: players, allPlayers: allPlayers);
}

class LuckyWheelWinnerMessageSendSuccess extends LuckyWheelWinnerLoadSuccess {
  LuckyWheelWinnerMessageSendSuccess({List<Player> players, List<Player> allPlayers}) : super(players: players, allPlayers: allPlayers);
}

class LuckyWheelWinnerPageShareSuccess extends LuckyWheelWinnerLoadSuccess {
  LuckyWheelWinnerPageShareSuccess({List<Player> players, List<Player> allPlayers}) : super(players: players, allPlayers: allPlayers);
}

class LuckyWheelWinnerFailure extends LuckyWheelWinnerState {
  LuckyWheelWinnerFailure({this.error});

  final String error;
}
class LuckyWheelWinnerPrintFailure extends LuckyWheelWinnerState {
  LuckyWheelWinnerPrintFailure({this.error});

  final String error;
}
// class LuckyWheelWinnerMessageSendFailure extends LuckyWheelWinnerState {
//   LuckyWheelWinnerMessageSendFailure({this.error});
//
//   final String error;
// }
//
// class LuckyWheelWinnerPageShareFailure extends LuckyWheelWinnerState {
//   LuckyWheelWinnerPageShareFailure({this.error});
//
//   final String error;
// }
