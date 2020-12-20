import 'package:diacritic/diacritic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/player/lucky_wheel_player_event.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/player/lucky_wheel_player_state.dart';
import 'package:tpos_mobile/feature_group/sale_online/game/lucky_wheel/player.dart';

class LuckyWheelPlayerBloc extends Bloc<LuckyWheelPlayerEvent, LuckyWheelPlayerState> {
  LuckyWheelPlayerBloc() : super(LuckyWheelPlayerLoading());

  final List<Player> _players = [];
  List<Player> _result = [];

  String _keyword = '';
  bool _arrangeAsc = false;

  @override
  Stream<LuckyWheelPlayerState> mapEventToState(LuckyWheelPlayerEvent event) async* {
    if (event is LuckyWheelPlayerInitial) {
      _players.clear();
      _players.addAll(event.players);
      _result.clear();
      _result.addAll(_players);

      yield LuckyWheelPlayerLoadSuccess(players: _result);
    } else if (event is LuckyWheelPlayerSearched) {
      _keyword = event.keyword.toLowerCase().trim();

      _result = _players
          .where((Player player) =>
              player.name.toLowerCase().contains(_keyword) ||
              removeDiacritics(player.name).toLowerCase().contains(removeDiacritics(_keyword)))
          .toList();

      yield LuckyWheelPlayerLoadSuccess(players: _result);
    } else if (event is LuckyWheelPlayerSorted) {
      _arrangeAsc = !_arrangeAsc;

      if (_arrangeAsc) {
        _result.sort((Player a, Player b) => a.name.compareTo(b.name));
      } else {
        _result = _players
            .where((Player player) =>
                player.name.toLowerCase().contains(_keyword) ||
                removeDiacritics(player.name).toLowerCase().contains(removeDiacritics(_keyword)))
            .toList();
      }
      yield LuckyWheelPlayerLoadSuccess(players: _result);
    }
  }
}
