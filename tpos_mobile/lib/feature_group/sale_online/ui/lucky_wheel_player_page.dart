import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/player/lucky_wheel_player_bloc.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/player/lucky_wheel_player_event.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/player/lucky_wheel_player_state.dart';
import 'package:tpos_mobile/feature_group/sale_online/game/lucky_wheel/player.dart';
import 'package:tpos_mobile/widgets/bloc_widget/base_bloc_listener_ui.dart';
import 'package:tpos_mobile/widgets/search_app_bar.dart';

class LuckyWheelPlayerPage extends StatefulWidget {
  const LuckyWheelPlayerPage({Key key, this.players}) : super(key: key);

  @override
  _LuckyWheelPlayerPageState createState() => _LuckyWheelPlayerPageState();
  final List<Player> players;
}

class _LuckyWheelPlayerPageState extends State<LuckyWheelPlayerPage> {
  String _keyword = '';
  final GlobalKey<SearchAppBarState> _searchKey =
      GlobalKey<SearchAppBarState>();
  LuckyWheelPlayerBloc _luckyWheelPlayerBloc;
  List<Player> _players;

  @override
  void initState() {
    _luckyWheelPlayerBloc = LuckyWheelPlayerBloc();
    _luckyWheelPlayerBloc.add(LuckyWheelPlayerInitial(players: widget.players));
    super.initState();
  }

  @override
  void dispose() {
    _luckyWheelPlayerBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff008E30),
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildAppBar() {
    return PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: SearchAppBar(
            key: _searchKey,
            text: _keyword,
            menuActions: [
              const SizedBox(width: 10),
              ClipOval(
                child: Container(
                  height: 50,
                  width: 50,
                  child: Material(
                    color: Colors.white.withOpacity(0.13),
                    child: IconButton(
                      iconSize: 30,
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
            ],
            iconSearch: ClipOval(
              child: Container(
                height: 50,
                width: 50,
                child: Material(
                  color: Colors.white.withOpacity(0.13),
                  child: IconButton(
                    iconSize: 30,
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () {
                      _searchKey.currentState.openSearch();
                    },
                  ),
                ),
              ),
            ),
            onBack: () {},
            onKeyWordChanged: (String keyword) {
              _keyword = keyword;
              _luckyWheelPlayerBloc
                  .add(LuckyWheelPlayerSearched(keyword: _keyword));
            },
            title: 'DS người chơi',
            actions: [
              const SizedBox(width: 10),
              ClipOval(
                child: Container(
                  height: 50,
                  width: 50,
                  child: Material(
                    color: Colors.white.withOpacity(0.13),
                    child: IconButton(
                      iconSize: 30,
                      icon: const Icon(
                        Icons.sort,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        _luckyWheelPlayerBloc.add(LuckyWheelPlayerSorted());
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16)
            ],
          ),
        ));
  }

  Widget _buildBody() {
    return BaseBlocListenerUi<LuckyWheelPlayerBloc, LuckyWheelPlayerState>(
      bloc: _luckyWheelPlayerBloc,
      loadingState: LuckyWheelPlayerLoading,
      busyState: LuckyWheelPlayerBusy,
      builder: (BuildContext context, LuckyWheelPlayerState state) {
        if (state is LuckyWheelPlayerLoadSuccess) {
          _players = state.players;
        }
        print(_players.length);
        return Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 28),
            child: _buildPlayers());
      },
    );
  }

  Widget _buildPlayers() {
    return ListView.separated(
      itemCount: _players.length,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 10);
      },
      itemBuilder: (BuildContext context, int index) {
        return _buildPlayerItem(_players[index]);
      },
    );
  }

  Widget _buildPlayerItem(Player player) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 12, right: 12, top: 15, bottom: 15),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          color: Colors.white.withOpacity(0.22)),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              image: DecorationImage(
                  image: NetworkImage(player.picture), fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icon/share.svg',
                      color: Colors.white,
                      width: 14,
                      height: 14,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      player.shareCount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    const SizedBox(width: 20),
                    SvgPicture.asset(
                      'assets/icon/comment.svg',
                      color: Colors.white,
                      width: 14,
                      height: 14,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      player.commentCount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              if (player.isWinner)
                SvgPicture.asset(
                  'assets/icon/win.svg',
                  color: const Color(0xffFCD766),
                ),
              if (player.dateCreated != null &&
                  player.dateCreated.difference(DateTime.now()).inDays < 5)
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white),
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, top: 3, bottom: 3),
                    child: const Text(
                      'MỚI',
                      style: TextStyle(color: Color(0xff28A745), fontSize: 11),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
