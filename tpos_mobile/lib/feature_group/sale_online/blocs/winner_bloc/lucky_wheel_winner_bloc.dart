import 'package:diacritic/diacritic.dart';
import 'package:facebook_api_client/facebook_api_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/winner_bloc/lucky_wheel_winner_event.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/winner_bloc/lucky_wheel_winner_state.dart';
import 'package:tpos_mobile/feature_group/sale_online/game/lucky_wheel/player.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/print_service.dart';

class LuckyWheelWinnerBloc extends Bloc<LuckyWheelWinnerEvent, LuckyWheelWinnerState> {
  LuckyWheelWinnerBloc({FacebookApi facebookApi, PrintService printService}) : super(LuckyWheelWinnerLoading()) {
    _facebookApi = facebookApi ?? GetIt.I<FacebookApi>();
    _printService = printService ?? locator<PrintService>();
  }

  FacebookApi _facebookApi;

  ///Danh sách người chơi đã được lọc
  List<Player> _filterWinners = [];

  ///danh sách người chơi ban đầu
  final List<Player> _allWinners = [];
  String _accessToken;
  String _keyword = '';
  bool _arrangeAsc = false;
  PrintService _printService;
  final Logger _logger = Logger();

  @override
  Stream<LuckyWheelWinnerState> mapEventToState(LuckyWheelWinnerEvent event) async* {
    if (event is LuckyWheelWinnerInitial) {
      _allWinners.clear();
      _allWinners.addAll(event.players);

      _filterWinners = event.players;
      _accessToken = event.pageAccessToken;
      yield LuckyWheelWinnerLoadSuccess(players: _filterWinners, allPlayers: _allWinners);
    } else if (event is LuckyWheelWinnerMessageSent) {
      try {
        yield LuckyWheelWinnerBusy();
        String message = _filterWinners.map((Player player) => player.name).join('\n');
        message = 'Danh sách người thắng cuộc\n' + message;
        _logger.i(event.player.uId);
        await _facebookApi.sendPageMessage(accessToken: _accessToken, psid: event.player.uId, message: message);
        yield LuckyWheelWinnerMessageSendSuccess(players: _filterWinners, allPlayers: _allWinners);
      } catch (e, stack) {
        _logger.e('LuckyWheelWinnerFailure', e, stack);
        yield LuckyWheelWinnerFailure(error: e.toString());
      }
    } else if (event is LuckyWheelWinnerDeleted) {
      try {
        yield LuckyWheelWinnerBusy();

        ///TODO (sangcv): khi có api
        _filterWinners.remove(event.player);
        _allWinners.remove(event.player);

        yield LuckyWheelWinnerDeleteSuccess(players: _filterWinners, allPlayers: _allWinners);
      } catch (e, stack) {
        _logger.e('LuckyWheelWinnerFailure', e, stack);
        yield LuckyWheelWinnerFailure(error: e.toString());
      }
    } else if (event is LuckyWheelWinnerPageShared) {
      try {
        yield LuckyWheelWinnerBusy();
        String message = _filterWinners.map((Player player) => player.name).join('\n');
        message = 'Danh sách người thắng cuộc\n' + message;
        await _facebookApi.postMessage(message: message, accessToken: _accessToken);
        yield LuckyWheelWinnerPageShareSuccess(players: _filterWinners, allPlayers: _allWinners);
      } catch (e, stack) {
        _logger.e('LuckyWheelWinnerFailure', e, stack);
        yield LuckyWheelWinnerFailure(error: e.toString());
        yield LuckyWheelWinnerLoadSuccess(players: _filterWinners, allPlayers: _allWinners);
      }
    } else if (event is LuckyWheelWinnerSearched) {
      yield LuckyWheelWinnerBusy();
      _keyword = event.keyword.toLowerCase().trim();

      _filterWinners = _allWinners
          .where((Player player) =>
              player.name.toLowerCase().contains(_keyword) ||
              removeDiacritics(player.name).toLowerCase().contains(removeDiacritics(_keyword)))
          .toList();

      yield LuckyWheelWinnerLoadSuccess(players: _filterWinners, allPlayers: _allWinners);
    } else if (event is LuckyWheelWinnerSorted) {
      yield LuckyWheelWinnerBusy();
      _arrangeAsc = !_arrangeAsc;

      if (_arrangeAsc) {
        _allWinners.sort((Player a, Player b) => a.name.compareTo(b.name));
      } else {
        _filterWinners = _allWinners
            .where((Player player) =>
                player.name.toLowerCase().contains(_keyword) ||
                removeDiacritics(player.name).toLowerCase().contains(removeDiacritics(_keyword)))
            .toList();
      }
      yield LuckyWheelWinnerLoadSuccess(players: _filterWinners, allPlayers: _allWinners);
    } else if (event is LuckyWheelWinnerUpdateLocal) {
      yield LuckyWheelWinnerBusy();
      _allWinners.clear();
      _allWinners.addAll(event.players);

      _filterWinners = _allWinners
          .where((Player player) =>
              player.name.toLowerCase().contains(_keyword) ||
              removeDiacritics(player.name).toLowerCase().contains(removeDiacritics(_keyword)))
          .toList();

      yield LuckyWheelWinnerLoadSuccess(players: _filterWinners, allPlayers: _allWinners);
    } else if (event is LuckyWheelWinnerPrinted) {
      try {
        yield LuckyWheelWinnerBusy();
        await _printService.printGame(name: event.player.name, uid: event.player.uId, partnerCode: '', phone: '');

        yield LuckyWheelWinnerPrintSuccess(players: _filterWinners, allPlayers: _allWinners);
      } catch (e, stack) {
        _logger.e('LuckyWheelWinnerFailure', e, stack);
        yield LuckyWheelWinnerFailure(error: e.toString());
        //yield LuckyWheelWinnerLoadSuccess(players: _filterWinners, allPlayers: _allWinners);
      }
    }
  }
}
