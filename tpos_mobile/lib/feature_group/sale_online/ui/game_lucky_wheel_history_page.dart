import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/winner_bloc/lucky_wheel_winner_bloc.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/winner_bloc/lucky_wheel_winner_event.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/winner_bloc/lucky_wheel_winner_state.dart';
import 'package:tpos_mobile/feature_group/sale_online/game/lucky_wheel/player.dart';
import 'package:tpos_mobile/widgets/bloc_widget/base_bloc_listener_ui.dart';
import 'package:tpos_mobile/widgets/custom_snack_bar.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/search_app_bar.dart';

class GameLuckyWheelHistoryPage extends StatefulWidget {
  const GameLuckyWheelHistoryPage({Key key, this.players, this.pageAccessToken}) : super(key: key);

  @override
  _GameLuckyWheelHistoryPageState createState() => _GameLuckyWheelHistoryPageState();
  final List<Player> players;
  final String pageAccessToken;
}

class _GameLuckyWheelHistoryPageState extends State<GameLuckyWheelHistoryPage> {
  final DateFormat dateTimeFormat = DateFormat("dd/MM/yyyy hh:mm");
  String _keyword = '';
  final GlobalKey<SearchAppBarState> _searchKey = GlobalKey<SearchAppBarState>();
  LuckyWheelWinnerBloc _luckyWheelWinnerBloc;
  List<Player> _winners;
  List<Player> _allWinners;
  bool _change = false;

  @override
  void initState() {
    _luckyWheelWinnerBloc = LuckyWheelWinnerBloc();
    _luckyWheelWinnerBloc
        .add(LuckyWheelWinnerInitial(players: widget.players, pageAccessToken: widget.pageAccessToken));
    super.initState();
  }

  @override
  void dispose() {
    _luckyWheelWinnerBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_change) {
          Navigator.pop(context, _allWinners);
        } else {
          Navigator.pop(context);
        }

        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xff008E30),
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
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
                        if (_change) {
                          Navigator.pop(context, _allWinners);
                        } else {
                          Navigator.pop(context);
                        }
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
              _luckyWheelWinnerBloc.add(LuckyWheelWinnerSearched(keyword: _keyword));
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
                        _luckyWheelWinnerBloc.add(LuckyWheelWinnerSorted());
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
    return BaseBlocListenerUi<LuckyWheelWinnerBloc, LuckyWheelWinnerState>(
      bloc: _luckyWheelWinnerBloc,
      loadingState: LuckyWheelWinnerLoading,
      busyState: LuckyWheelWinnerBusy,
      listener: (BuildContext context, LuckyWheelWinnerState state) {
        if (state is LuckyWheelWinnerMessageSendSuccess) {
          final Widget snackBar = customSnackBar(message: 'Gửi thành công', context: context);
          Scaffold.of(context).showSnackBar(snackBar);
        } else if (state is LuckyWheelWinnerDeleteSuccess) {
          _change = true;
          final Widget snackBar = customSnackBar(message: 'Xóa thành công', context: context);
          Scaffold.of(context).showSnackBar(snackBar);
        } else if (state is LuckyWheelWinnerPageShareSuccess) {
          final Widget snackBar = customSnackBar(message: 'Chia sẻ thành công', context: context);
          Scaffold.of(context).showSnackBar(snackBar);
        } else if (state is LuckyWheelWinnerFailure) {
          App.showDefaultDialog(title: 'Lỗi', context: context, type: AlertDialogType.error, content: state.error);
        }
      },
      builder: (BuildContext context, LuckyWheelWinnerState state) {
        if (state is LuckyWheelWinnerLoadSuccess) {
          _winners = state.players;
          _allWinners = state.allPlayers;
        }
        print(_winners.length);
        return Padding(padding: const EdgeInsets.only(left: 16, right: 16, top: 28), child: _buildPlayers());
      },
    );
  }

  Widget _buildPlayers() {
    return ListView.separated(
      itemCount: _winners.length,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 10);
      },
      itemBuilder: (BuildContext context, int index) {
        return _buildWinPlayerItem(_winners[index]);
      },
    );
  }

  Widget _buildWinPlayerItem(Player player) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 12, right: 12, top: 15, bottom: 15),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)), color: Colors.white.withOpacity(0.22)),
      child: Column(
        children: [
          Row(
            children: [
              ClipOval(
                child: FadeInImage(
                  width: 50,
                  placeholder: const AssetImage("images/no_image.png"),
                  image: CachedNetworkImageProvider(player.picture),
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  fadeInDuration: const Duration(milliseconds: 200),
                  fadeInCurve: Curves.linear,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          player.name,
                          style: const TextStyle(color: Colors.white, fontSize: 17),
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (player.totalDays < 2)
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.only(left: 8, right: 8, top: 3, bottom: 3),
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                gradient: LinearGradient(colors: [
                                  Color(0xffF22727),
                                  Color(0xffff7575),
                                ], stops: [
                                  0,
                                  1
                                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                            child: Text(
                              'Mới'.toUpperCase(),
                              style: const TextStyle(color: Colors.white, fontSize: 11),
                            ),
                          ),
                        )
                    ],
                  ),
                  Text(
                    dateTimeFormat.format(player.lastWinDate),
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ]),
              ),
              IconButton(
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    showModalBottomSheet<void>(
                        context: context,
                        shape: RoundedRectangleBorder(
                          side: BorderSide.none,
                          borderRadius: BorderRadius.circular(13.0),
                        ),
                        builder: (BuildContext context) {
                          return _buildBottomSheet(player);
                        });
                  })
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 1,
            color: const Color(0xff929daa).withOpacity(0.1),
          )
        ],
      ),
    );
  }

  Widget _buildBottomSheet(Player player) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.only(left: 8, right: 20),
            leading: ClipOval(
              child: FadeInImage(
                width: 50,
                placeholder: const AssetImage("images/no_image.png"),
                image: CachedNetworkImageProvider(player.picture),
                fit: BoxFit.contain,
                alignment: Alignment.center,
                fadeInDuration: const Duration(milliseconds: 200),
                fadeInCurve: Curves.linear,
              ),
            ),
            onTap: () {},
            title: Text(
              player.name,
              style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
            ),
            subtitle: const Text(
              '',
              style: TextStyle(color: Color(0xff2C333A), fontSize: 13),
            ),
            trailing: ClipOval(
              child: Container(
                height: 45,
                width: 45,
                child: Material(
                  color: const Color(0xff28A745),
                  child: IconButton(
                    iconSize: 25,
                    icon: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      App.showDefaultDialog(
                          title: 'Lỗi',
                          context: context,
                          type: AlertDialogType.error,
                          content: 'Hiện tại không thể liên kết được với khách hàng');
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 1,
            color: const Color(0xff929daa).withOpacity(0.1),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(FontAwesomeIcons.print, color: Color(0xff929daa), size: 23),
            onTap: () {
              _luckyWheelWinnerBloc.add(LuckyWheelWinnerPrinted(player: player));
            },
            title: const Text(
              'In phiếu trúng thưởng',
              style: TextStyle(color: Color(0xff2C333A), fontSize: 17),
            ),
          ),
          ListTile(
            leading: SvgPicture.asset('assets/icon/share.svg', color: const Color(0xff929daa)),
            onTap: () {
              if (widget.pageAccessToken != null) {
                _luckyWheelWinnerBloc.add(LuckyWheelWinnerPageShared());
                Navigator.of(context).pop();
              } else {
                App.showDefaultDialog(
                    title: 'Lỗi',
                    context: context,
                    type: AlertDialogType.error,
                    content: 'Chỉ sử dụng chức năng với page');
              }
            },
            title: const Text(
              'Chia sẻ lên Page Facebook',
              style: TextStyle(color: Color(0xff2C333A), fontSize: 17),
            ),
            subtitle: Text(
              'Chỉ sử dụng với page',
              style: TextStyle(color: const Color(0xff2C333A).withOpacity(0.5), fontSize: 13),
            ),
          ),
          ListTile(
            leading: SvgPicture.asset('assets/icon/messenger.svg'),
            onTap: () {
              if (widget.pageAccessToken != null) {
                _luckyWheelWinnerBloc.add(LuckyWheelWinnerMessageSent(player: player));
                Navigator.of(context).pop();
              } else {
                App.showDefaultDialog(
                    title: 'Lỗi',
                    context: context,
                    type: AlertDialogType.error,
                    content: 'Chỉ sử dụng chức năng với page');
              }
            },
            title: const Text(
              'Gửi tin nhắn qua Messenger',
              style: TextStyle(color: Color(0xff2C333A), fontSize: 17),
            ),
            subtitle: Text(
              'Chỉ sử dụng với page',
              style: TextStyle(color: const Color(0xff2C333A).withOpacity(0.5), fontSize: 13),
            ),
          ),
          ListTile(
            leading: SvgPicture.asset('assets/icon/delete.svg'),
            onTap: () async {
              final bool result = await App.showConfirm(
                  title: 'Xác nhận xóa', content: 'Bạn có muốn xóa các sản phẩm được chọn không?');

              if (result != null && result) {
                _luckyWheelWinnerBloc.add(LuckyWheelWinnerDeleted(player: player));
                Navigator.of(context).pop();
              }
            },
            title: const Text(
              'Xóa',
              style: TextStyle(color: Color(0xff2C333A), fontSize: 17),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
