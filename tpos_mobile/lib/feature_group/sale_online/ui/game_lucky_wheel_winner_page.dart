import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/winner_bloc/lucky_wheel_winner_bloc.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/winner_bloc/lucky_wheel_winner_event.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/winner_bloc/lucky_wheel_winner_state.dart';
import 'package:tpos_mobile/feature_group/sale_online/game/lucky_wheel/player.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/game_lucky_wheel_history_page.dart';
import 'package:tpos_mobile/widgets/bloc_widget/base_bloc_listener_ui.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/custom_snack_bar.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';

class GameLuckyWinnerPage extends StatefulWidget {
  const GameLuckyWinnerPage({Key key, this.winners, this.pageAccessToken}) : super(key: key);

  @override
  _GameLuckyWinnerPageState createState() => _GameLuckyWinnerPageState();
  final List<Player> winners;
  final String pageAccessToken;
}

class _GameLuckyWinnerPageState extends State<GameLuckyWinnerPage> {
  final DateFormat dateTimeFormat = DateFormat("dd/MM/yyyy hh:mm");
  LuckyWheelWinnerBloc _luckyWheelWinnerBloc;
  List<Player> _winners;
  bool _change = false;

  @override
  void initState() {
    _luckyWheelWinnerBloc = LuckyWheelWinnerBloc();
    _luckyWheelWinnerBloc
        .add(LuckyWheelWinnerInitial(players: widget.winners, pageAccessToken: widget.pageAccessToken));
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
          Navigator.pop(context, _winners);
        } else {
          Navigator.pop(context);
        }

        return false;
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Container(
            decoration: const BoxDecoration(
                color: Color(0xff007E11),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                )),
            padding: const EdgeInsets.only(top: 10),
            child: Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                padding: const EdgeInsets.only(left: 10, right: 10),
                decoration:
                    const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(23))),
                child: Scaffold(backgroundColor: Colors.transparent, body: _buildBody())),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Stack(
      overflow: Overflow.visible,
      alignment: Alignment.center,
      children: [
        Positioned(
          top: -40,
          child: Container(
            padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 10),
            decoration:
                const BoxDecoration(color: Color(0xff008E30), borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icon/win.svg',
                    color: const Color(0xff008E30),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Danh sách người trúng'.toUpperCase(),
                    style: const TextStyle(color: Color(0xff008E30), fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Column(
            children: [
              Expanded(
                  child: BaseBlocListenerUi<LuckyWheelWinnerBloc, LuckyWheelWinnerState>(
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
                    App.showDefaultDialog(
                        title: 'Lỗi', context: context, type: AlertDialogType.error, content: state.error);
                  }
                },
                builder: (BuildContext context, LuckyWheelWinnerState state) {
                  if (state is LuckyWheelWinnerLoadSuccess) {
                    _winners = state.players;
                  }
                  return _buildWinPlayers();
                },
              )),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: AppButton(
                    width: double.infinity,
                    borderRadius: 13,
                    background: const Color(0xff929daa).withOpacity(0.1),
                    onPressed: () {
                      if (_change) {
                        Navigator.pop(context, _winners);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      'Đóng',
                      style: TextStyle(color: Color(0xff2C333A), fontSize: 17),
                    )),
              ),
              const SizedBox(height: 30)
            ],
          ),
        )
      ],
    );
  }

  Widget _buildWinPlayers() {
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
    return Column(
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
                        style: const TextStyle(color: Color(0xff008E30), fontSize: 17),
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
                  style: const TextStyle(color: Color(0xff929DAA), fontSize: 13),
                ),
              ]),
            ),
            IconButton(
                icon: const Icon(Icons.more_vert),
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
            leading: SvgPicture.asset('assets/icon/win.svg', color: const Color(0xff929daa)),
            onTap: () async {
              final List<Player> players = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                return GameLuckyWheelHistoryPage(
                  players: _winners.where((element) => element.uId == player.uId).toList(),
                  pageAccessToken: widget.pageAccessToken,
                );
              }));

              if (players != null) {
                _luckyWheelWinnerBloc.add(LuckyWheelWinnerUpdateLocal(players: players));
              }
            },
            title: const Text(
              'Xem lịch sử trúng thưởng',
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
