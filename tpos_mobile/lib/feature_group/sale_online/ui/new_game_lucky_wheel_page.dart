import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/new_game_lucky_wheel/new_game_lucky_wheel_bloc.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/new_game_lucky_wheel/new_game_lucky_wheel_event.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/new_game_lucky_wheel/new_game_lucky_wheel_state.dart';
import 'package:tpos_mobile/feature_group/sale_online/game/lucky_wheel/game_helper.dart';
import 'package:tpos_mobile/feature_group/sale_online/game/lucky_wheel/lucky_wheel_setting.dart';
import 'package:tpos_mobile/feature_group/sale_online/game/lucky_wheel/lucky_wheel_setting_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/game/lucky_wheel/player.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/game_lucky_wheel_winner_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/lucky_wheel_player_page.dart';
import 'package:tpos_mobile/widgets/background/congratulation_foreground.dart';
import 'package:tpos_mobile/widgets/background/lucky_wheel_background.dart';
import 'package:tpos_mobile/widgets/bloc_widget/base_bloc_listener_ui.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/custom_snack_bar.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/load_status.dart';
import 'package:tpos_mobile/widgets/particle/src/confetti.dart';

class NewGameLuckyWheelPage extends StatefulWidget {
  const NewGameLuckyWheelPage({Key key, this.crmTeam}) : super(key: key);

  @override
  _NewGameLuckyWheelPageState createState() => _NewGameLuckyWheelPageState();
  final CRMTeam crmTeam;
}

class _NewGameLuckyWheelPageState extends State<NewGameLuckyWheelPage> {
  GameLuckyWheelBloc _gameLuckyWheelBloc;
  List<Player> _players;
  List<Player> _winners;
  final ScrollController _playerController = ScrollController();
  final ScrollController _numberPlayerController = ScrollController();
  final ScrollController _numberShareController = ScrollController();
  final ScrollController _numberCommentController = ScrollController();
  final ConfettiController _controllerTopCenter = ConfettiController(duration: const Duration(seconds: 3));
  int _totalShare = 0;
  int _totalComment = 0;
  final double _itemHeight = 120;
  final Duration duration = const Duration(milliseconds: 5000);
  bool _isPlaying = false;
  LuckyWheelSetting _luckyWheelSetting;
  final BackgroundPainterController _painterController = BackgroundPainterController();
  final _NameController _startController = _NameController();
  double _transform = 0;

  @override
  void initState() {
    _gameLuckyWheelBloc = GameLuckyWheelBloc();
    _gameLuckyWheelBloc.add(GameLuckyWheelLoaded(token: widget.crmTeam.userOrPageToken));
    super.initState();
  }

  @override
  void dispose() {
    _playerController.dispose();
    _numberPlayerController.dispose();
    _numberShareController.dispose();
    _numberCommentController.dispose();
    _gameLuckyWheelBloc.close();
    _painterController.dispose();
    _controllerTopCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff198827),
      body: Transform(transform: Matrix4.rotationY(_transform), alignment: Alignment.center, child: _buildBody()),
    );
  }

  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _CircleButton(
          icon: SvgPicture.asset('assets/icon/close.svg'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Row(
          children: [
            _CircleButton(
              onPressed: () {
                _gameLuckyWheelBloc.add(GameLuckyWheelRefreshed());
              },
              icon: SvgPicture.asset('assets/icon/refresh.svg'),
            ),
            const SizedBox(width: 12),
            _CircleButton(
              icon: SvgPicture.asset('assets/icon/win.svg'),
              onPressed: () async {
                final List<Player> players = await showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return GameLuckyWinnerPage(
                      winners: _winners,
                      pageAccessToken: widget.crmTeam.facebookTypeId == 'Page' ? widget.crmTeam.userOrPageToken : null,
                    );
                  },
                  useRootNavigator: false,
                );
                if (players != null) {
                  print(players.length);
                  _gameLuckyWheelBloc.add(GameLuckyWheelWinnerUpdateLocal(players: players));
                }
              },
            ),
            const SizedBox(width: 12),
            _CircleButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () async {
                final LuckyWheelSetting luckyWheelSetting =
                    await Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return LuckyWheelSettingPage(
                    luckyWheelSetting: _luckyWheelSetting,
                  );
                }));
                if (luckyWheelSetting != null) {
                  _gameLuckyWheelBloc.add(GameLuckyWheelSaveConfig(luckyWheelSetting: luckyWheelSetting));
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBody() {
    return BaseBlocListenerUi<GameLuckyWheelBloc, GameLuckyWheelState>(
      bloc: _gameLuckyWheelBloc,
      loadingState: GameLuckyWheelLoading,
      errorState: GameLuckyWheelLoadFailure,
      busyState: GameLuckyWheelBusy,
      errorBuilder: (BuildContext context, GameLuckyWheelState state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50 * (MediaQuery.of(context).size.height / 1000)),
              LoadStatusWidget(
                statusName: 'Lỗi tải dữ liệu',
                content: 'Không thể lấy dữ liệu từ máy chủ',
                statusIcon: SvgPicture.asset('assets/icon/error.svg', width: 170, height: 130),
                action: AppButton(
                  onPressed: () {
                    _gameLuckyWheelBloc.add(GameLuckyWheelLoaded(token: widget.crmTeam.userOrPageToken));
                  },

                  width: 180,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 40, 167, 69),
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          FontAwesomeIcons.sync,
                          color: Colors.white,
                          size: 23,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Tải lại trang',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      listener: (BuildContext context, GameLuckyWheelState state) async {
        if (state is GameLuckyWheelGameStartError) {
          App.showDefaultDialog(title: 'Lỗi', context: context, type: AlertDialogType.error, content: state.error);
        } else if (state is GameLuckyWheelGameError) {
          App.showDefaultDialog(title: 'Lỗi', context: context, type: AlertDialogType.error, content: state.error);
        } else if (state is GameLuckyWheelFinished) {
          _scrollToElement(state.setting.timeInSecond, state.players.indexOf(state.winPlayer));
        } else if (state is GameLuckyWheelInsertSuccess) {
          _players = state.players;
          _totalShare = _players.fold(0, (int previous, Player current) => previous + current.shareCount);
          _totalComment = _players.fold(0, (int previous, Player current) => previous + current.commentCount);
          WidgetsBinding.instance.addPostFrameCallback((_) => _numberPlayerController.animateTo(
              (_players.length - 1) * 30.0,
              duration: const Duration(milliseconds: 3000),
              curve: Curves.easeOut));
          WidgetsBinding.instance.addPostFrameCallback((_) => _numberShareController.animateTo((_totalShare - 1) * 30.0,
              duration: const Duration(milliseconds: 3000), curve: Curves.easeOut));
          WidgetsBinding.instance.addPostFrameCallback((_) => _numberCommentController.animateTo(
              (_totalComment - 1) * 30.0,
              duration: const Duration(milliseconds: 3000),
              curve: Curves.easeOut));
        } else if (state is GameLuckyWheelInitialSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _painterController.playAnimation());
          _players = state.players;
          _winners = state.winners;
          _totalShare = _players.fold(0, (int previous, Player current) => previous + current.shareCount);
          _totalComment = _players.fold(0, (int previous, Player current) => previous + current.commentCount);
          if (_players.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) => _numberPlayerController.animateTo(
                (_players.length - 1) * 30.0,
                duration: const Duration(milliseconds: 5000),
                curve: Curves.easeOut));
          }

          if (_totalShare > 0) {
            WidgetsBinding.instance.addPostFrameCallback((_) => _numberShareController.animateTo(
                (_totalShare - 1) * 30.0,
                duration: const Duration(milliseconds: 5000),
                curve: Curves.easeOut));
          }
          if (_totalComment > 0) {
            WidgetsBinding.instance.addPostFrameCallback((_) => _numberCommentController.animateTo(
                (_totalComment - 1) * 30.0,
                duration: const Duration(milliseconds: 5000),
                curve: Curves.easeOut));
          }
        } else if (state is GameLuckyWheelShareSuccess) {
          final Widget snackBar = customSnackBar(message: 'Chia sẻ thành công', context: context);
          Scaffold.of(context).showSnackBar(snackBar);
        } else if (state is GameLuckyWheelLoadSuccess) {
          _players = state.players;
          _winners = state.winners;
          _totalShare = _players.fold(0, (int previous, Player current) => previous + current.shareCount);
          _totalComment = _players.fold(0, (int previous, Player current) => previous + current.commentCount);
          WidgetsBinding.instance.addPostFrameCallback((_) => _numberPlayerController.animateTo(
              (_players.length - 1) * 30.0,
              duration: const Duration(milliseconds: 5000),
              curve: Curves.easeOut));
          WidgetsBinding.instance.addPostFrameCallback((_) => _numberShareController.animateTo((_totalShare - 1) * 30.0,
              duration: const Duration(milliseconds: 5000), curve: Curves.easeOut));
          WidgetsBinding.instance.addPostFrameCallback((_) => _numberCommentController.animateTo(
              (_totalComment - 1) * 30.0,
              duration: const Duration(milliseconds: 5000),
              curve: Curves.easeOut));
        }
      },
      builder: (BuildContext context, GameLuckyWheelState state) {
        if (state is GameLuckyWheelLoadSuccess) {
          _luckyWheelSetting = state.setting;
          _winners = state.winners;
          _players = state.players;
          _totalShare = _players.fold(0, (int previous, Player current) => previous + current.shareCount);
          _totalComment = _players.fold(0, (int previous, Player current) => previous + current.commentCount);
        }
        final double aspectHeight = MediaQuery.of(context).size.height / 800;
        return LuckyWheelBackground(
          painterController: _painterController,
          backgroundColor: const Color(0xff198827),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                children: [
                  SizedBox(height: 10 * aspectHeight),
                  _buildAppBar(),
                  SizedBox(height: 15 * aspectHeight),
                  _buildGameName(),
                  SizedBox(height: 20 * aspectHeight),
                  _buildStatics(),
                  SizedBox(height: 11 * aspectHeight),
                  Expanded(child: _players != null && _players.isNotEmpty ? _buildScrollList() : _buildEmpty()),
                  SizedBox(height: 20 * aspectHeight),
                  if (_players != null && _players.isNotEmpty) _buildButton() else _buildDisableButton(),
                  SizedBox(height: 10 * aspectHeight),
                  _buildBottom(),
                  SizedBox(height: 10 * aspectHeight),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  ///Xây dựng giao diện  tên game
  Widget _buildGameName() {
    final double aspectHeight = MediaQuery.of(context).size.height / 800;
    return _StartAnimationNameWidget(
      nameController: _startController,
      duration: const Duration(milliseconds: 5000),
      numberLoop: 3,
      angle: 15,
      child: Container(
        height: 122 * aspectHeight,
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          image: DecorationImage(image: AssetImage('assets/game/icon/ic_logo_vong_quay.png'), fit: BoxFit.contain),
        ),
      ),
    );
  }

  ///Xây dựng giao diện thống kê số người chơi, số lượt chia sẻ, số nhận xét
  Widget _buildStatics() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        color: Colors.white.withOpacity(0.13),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return LuckyWheelPlayerPage(
                    players: _players,
                  );
                }));
              },
              child: Container(
                height: 30,
                child: _players.isNotEmpty
                    ? ListWheelScrollView.useDelegate(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _numberPlayerController,
                        onSelectedItemChanged: (int value) {},
                        itemExtent: 30,
                        diameterRatio: 100,
                        childDelegate: ListWheelChildLoopingListDelegate(
                          children: List.generate(_players.length, (index) => index + 1)
                              .map((int index) => Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset('assets/icon/person.svg'),
                                      const SizedBox(width: 5),
                                      Flexible(
                                        child: Text(
                                          index.toString(),
                                          style: const TextStyle(color: Colors.white, fontSize: 17),
                                        ),
                                      ),
                                    ],
                                  ))
                              .toList(),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/icon/person.svg'),
                          const SizedBox(width: 5),
                          const Flexible(
                            child: Text(
                              '0',
                              style: TextStyle(color: Colors.white, fontSize: 17),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          Flexible(
            child: Container(
              height: 30,
              child: _totalShare > 0
                  ? ListWheelScrollView.useDelegate(
                      controller: _numberShareController,
                      onSelectedItemChanged: (int value) {},
                      itemExtent: 30,
                      diameterRatio: 100,
                      physics: const NeverScrollableScrollPhysics(),
                      childDelegate: ListWheelChildLoopingListDelegate(
                        children: List.generate(_totalShare, (index) => index + 1)
                            .map((int index) => Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset('assets/icon/share.svg'),
                                    const SizedBox(width: 5),
                                    Flexible(
                                      child: Text(
                                        index.toString(),
                                        style: const TextStyle(color: Colors.white, fontSize: 17),
                                      ),
                                    ),
                                  ],
                                ))
                            .toList(),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icon/share.svg'),
                        const SizedBox(width: 5),
                        const Flexible(
                          child: Text(
                            '0',
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          Flexible(
            child: Container(
              height: 30,
              child: _totalComment > 0
                  ? ListWheelScrollView.useDelegate(
                      controller: _numberCommentController,
                      onSelectedItemChanged: (int value) {},
                      itemExtent: 30,
                      diameterRatio: 100,
                      physics: const NeverScrollableScrollPhysics(),
                      childDelegate: ListWheelChildLoopingListDelegate(
                        children: List.generate(_totalComment, (index) => index + 1)
                            .map((int index) => Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset('assets/icon/comment.svg'),
                                    const SizedBox(width: 5),
                                    Flexible(
                                      child: Text(
                                        index.toString(),
                                        style: const TextStyle(color: Colors.white, fontSize: 17),
                                      ),
                                    ),
                                  ],
                                ))
                            .toList(),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icon/comment.svg'),
                        const SizedBox(width: 5),
                        const Flexible(
                          child: Text(
                            '0',
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  ///Nút quay
  Widget _buildButton() {
    return InkWell(
      onTap: () {
        _isPlaying = true;
        _gameLuckyWheelBloc.add(GameLuckyWheelStarted());
      },
      child: Container(
        margin: const EdgeInsets.only(left: 40, right: 40),
        height: 65,
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/game/icon/ic_button_turned.png'), fit: BoxFit.scaleDown)),
      ),
    );
  }

  ///Nút xoay khi không có người chơi
  Widget _buildDisableButton() {
    return Container(
      margin: const EdgeInsets.only(left: 40, right: 40),
      height: 65,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/game/icon/ic_disable_button_turned.png'), fit: BoxFit.scaleDown)),
    );
  }

  ///Danh sách ngưởi chơi
  Widget _buildScrollList() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          width: double.infinity,
          height: 300,
          padding: const EdgeInsets.only(left: 9, right: 9, top: 18, bottom: 18),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            color: Colors.white.withOpacity(0.13),
          ),
          child: Stack(
            overflow: Overflow.visible,
            children: [
              ListWheelScrollView.useDelegate(
                physics: const NeverScrollableScrollPhysics(),
                controller: _playerController,
                diameterRatio: 100,
                childDelegate: ListWheelChildLoopingListDelegate(
                  children: _players.map((Player player) => _buildPlayer(player, _itemHeight)).toList(),
                ),
                itemExtent: 120,
              ),
              Positioned(
                right: -10,
                top: constraints.maxHeight / 2 - 36,
                child: Container(
                  alignment: Alignment.centerRight,
                  child: SvgPicture.asset(
                    "assets/icon/game_wheel_arrow.svg",
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ///xây dựng giao diện trống
  Widget _buildEmpty() {
    final double aspectHeight = MediaQuery.of(context).size.height / 800;
    final double aspectWidth = MediaQuery.of(context).size.width / 360;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          overflow: Overflow.visible,
          alignment: Alignment.center,
          children: [
            ClipRRect(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(19)),
                    color: Colors.white.withOpacity(0.1),
                  ),
                  padding: EdgeInsets.only(left: 40 * aspectWidth, right: 40 * aspectWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/game/icon/no_player.png',
                        width: 140 * aspectWidth,
                        height: 140 * aspectWidth,
                      ),
                      const Opacity(
                        opacity: 0.73,
                        child: Text(
                          'Chưa có người chơi nào, mời thêm khách hàng xem live của bạn hoặc tải lại trang.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                      ),
                      SizedBox(height: 20 * aspectHeight),
                      AppButton(
                        background: Colors.transparent,
                        onPressed: () {
                          _gameLuckyWheelBloc.add(GameLuckyWheelLoaded(token: widget.crmTeam.userOrPageToken));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/icon/refresh.svg'),
                            const SizedBox(width: 10),
                            const Text(
                              'Tải lại',
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20 * aspectHeight),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: -16,
              child: Container(
                alignment: Alignment.centerRight,
                child: SvgPicture.asset(
                  "assets/icon/game_wheel_arrow.svg",
                  width: 50,
                  height: 50,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  ///Giao diện người chơi
  Widget _buildPlayer(Player player, double height) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 7, right: 7),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              height: 86,
              width: 86,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(14)),
                  image: DecorationImage(image: NetworkImage(player.picture), fit: BoxFit.cover))),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  player.name,
                  style: const TextStyle(color: Color(0xff2c333a), fontSize: 19),
                ),
                const SizedBox(height: 11),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icon/share.svg',
                      color: const Color(0xffCBD1D8),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        player.shareCount.toString(),
                        style: const TextStyle(color: Color(0xff6b7280), fontSize: 17),
                      ),
                    ),
                    const SizedBox(width: 20),
                    SvgPicture.asset('assets/icon/comment.svg', color: const Color(0xffCBD1D8)),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        player.commentCount.toString(),
                        style: const TextStyle(color: Color(0xff6b7280), fontSize: 17),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  ///Xaay dựng nút ở dưới màn hình nút quay màn hình, nút hướng dẫn
  Widget _buildBottom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_buildRotateScreenButton(), _buildInstructionButton()],
    );
  }

  ///Nút quay màn hình
  Widget _buildRotateScreenButton() {
    return InkWell(
      onTap: () {
        setState(() {
          if (_transform == pi) {
            _transform = 0;
          } else {
            _transform = pi;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            SvgPicture.asset('assets/icon/rotate_screen.svg'),
            const SizedBox(width: 8),
            const Text('Xoay màn hình', style: TextStyle(color: Colors.white, fontSize: 17)),
          ],
        ),
      ),
    );
  }

  ///Nút hướng dẫn
  Widget _buildInstructionButton() {
    return InkWell(
      onTap: () {
        showTutorial(context);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            SvgPicture.asset('assets/icon/instruction.svg'),
            const SizedBox(width: 8),
            const Text('Hướng dẫn', style: TextStyle(color: Colors.white, fontSize: 17)),
          ],
        ),
      ),
    );
  }

  ///Dialog người trúng thưởng
  Widget _buildWinnerDialog(Player player) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _controllerTopCenter.play());
    return CongratulationAnimationForeground(
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyText2,
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Colors.transparent,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ClipOval(
                          child: Container(
                            height: 50,
                            width: 50,
                            child: Material(
                              color: Colors.white,
                              child: IconButton(
                                iconSize: 30,
                                icon: SvgPicture.asset('assets/icon/messenger.svg'),
                                onPressed: () {
                                  _gameLuckyWheelBloc.add(GameLuckyWheelPlayerShared(winner: player));
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 13),
                        ClipOval(
                          child: Container(
                            height: 50,
                            width: 50,
                            child: Material(
                              color: Colors.white,
                              child: IconButton(
                                iconSize: 30,
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        color: Colors.white,
                      ),
                      // padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Material(
                            color: Colors.transparent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 20),
                                Container(
                                  width: double.infinity,
                                  height: 238,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(image: NetworkImage(player.picture), fit: BoxFit.cover),
                                      shape: BoxShape.circle),
                                  child: Stack(
                                    overflow: Overflow.visible,
                                    children: [
                                      Positioned(
                                        bottom: -20,
                                        left: 0,
                                        right: 0,
                                        child: SvgPicture.asset('assets/icon/congratulation.svg'),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 36),
                                Text(
                                  player.name,
                                  style: const TextStyle(fontSize: 23, color: Color(0xff2C333A)),
                                ),
                                const SizedBox(height: 13),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icon/share.svg',
                                      color: const Color(0xffCBD1D8),
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        player.shareCount.toString(),
                                        style: const TextStyle(color: Color(0xff6b7280), fontSize: 17),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    SvgPicture.asset('assets/icon/comment.svg', color: const Color(0xffCBD1D8)),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        player.commentCount.toString(),
                                        style: const TextStyle(color: Color(0xff6b7280), fontSize: 17),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 50),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: const Color(0xffF0F1F3),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: FlatButton(
                                          padding: const EdgeInsets.only(left: 40, right: 40),
                                          child: const Center(
                                            child: Text(
                                              'In phiếu',
                                              style: TextStyle(color: Color(0xff3A3B3F), fontSize: 17),
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Flexible(
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: const Color(0xff28A745),
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: const Color(0xff28A745), width: 1)),
                                        child: FlatButton(
                                          padding: const EdgeInsets.only(left: 60, right: 60),
                                          child: const Center(
                                            child: Text(
                                              'Lưu',
                                              style: TextStyle(color: Colors.white, fontSize: 17),
                                            ),
                                          ),
                                          onPressed: () {},
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///di chuyển tới người trúng thưởng
  Future<void> _scrollToElement(int second, int playerIndex) async {
    /// Thời gian bắt đầu giảm vận tốc
    ///const double gameDurationReduce = 10;
    const int numberReverseLoop = 20;
    const int partMove = 10;

    /// Vận tốc
    const double speed = 100;

    /// Loop 60ms
    const double gameLoop = 17;

    /// Độ cao một item
    final double itemHeight = _itemHeight;

    /// Số vòng lặp
    final double gameTime = second * 1000 / gameLoop;

    /// Khoảng cách
    final double distance = gameTime * (speed / 2);

    /// Bước lùi
    final double speedStep = speed / gameTime;

    /// Vị trí dừng
    final double endOffset = itemHeight * playerIndex;

    /// Vị trí khởi đầu
    final double startOffset = endOffset - distance - 50;

    /// Vị trí hiện tại
    double tempOffset = startOffset;

    /// Vận tốc hiện tại
    double tempSpeed = speed;

    ///khởi động lấy đà
    for (final int i in List<int>.generate(numberReverseLoop, (i) => i + 1)) {
      _playerController.jumpTo((_itemHeight / partMove) * i);
      await Future.delayed(const Duration(milliseconds: 25));
    }

    ///di chuyển trở lại vị trí cũ
    for (final int i in List<int>.generate(numberReverseLoop, (i) => i + 1).reversed) {
      _playerController.jumpTo(-(_itemHeight / partMove) * i);
      await Future.delayed(Duration(milliseconds: gameLoop.toInt()));
    }

    /// loop
    while (tempSpeed > 0) {
      _playerController.jumpTo(tempOffset);
      await Future.delayed(Duration(milliseconds: gameLoop.toInt()));
      tempOffset += tempSpeed;
      tempSpeed -= speedStep;
    }

    await Future.delayed(const Duration(milliseconds: 1000));
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildWinnerDialog(_players[playerIndex]);
      },
      useRootNavigator: false,
    );
  }

  ///Thêm người chơi mới
  void _addPlayer(Player player) {
    if (!_isPlaying) {
      assert(player != null);
      _gameLuckyWheelBloc.add(GameLuckyWheelPlayerInserted(player: player));
    }
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({Key key, this.icon, this.onPressed}) : super(key: key);
  final Widget icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    assert(icon != null);
    return ClipOval(
      child: Container(
        height: 50,
        width: 50,
        child: Material(
          color: Colors.white.withOpacity(0.13),
          child: IconButton(
            iconSize: 30,
            icon: icon,
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}

///controller điều khiển vòng quay
class _NameController extends ChangeNotifier {
  bool isPlay = false;

  void playAnimation() {
    isPlay = true;
    notifyListeners();
  }
}

class _StartAnimationNameWidget extends StatefulWidget {
  const _StartAnimationNameWidget(
      {Key key,
      this.duration = const Duration(milliseconds: 5000),
      this.angle = 30,
      this.child,
      this.numberLoop = 6,
      this.nameController})
      : super(key: key);

  @override
  __StartAnimationNameWidgetState createState() => __StartAnimationNameWidgetState();
  final Duration duration;
  final Widget child;
  final double angle;
  final int numberLoop;
  final _NameController nameController;
}

class __StartAnimationNameWidgetState extends State<_StartAnimationNameWidget> with SingleTickerProviderStateMixin {
  _StartAnimationNameController _startController;
  int _countLoop = 0;
  AnimationController _controller;
  Animation _rotation;

  @override
  void didUpdateWidget(covariant _StartAnimationNameWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    final int milliseconds = widget.duration.inMilliseconds ~/ ((widget.numberLoop + 2) * 2);
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: milliseconds));

    _startController = _StartAnimationNameController();
    if (widget.nameController != null) {
      widget.nameController.addListener(() {
        if (widget.nameController.isPlay) {
          _countLoop = 0;
          widget.nameController.isPlay = false;
          _startController.playElementAnimation();
        }
      });
    }

    _startController.addListener(() {
      if (_startController.isElementFinish) {
        if (_countLoop < widget.numberLoop * 2) {
          _startController.playElementAnimation();
        } else {
          _controller.forward();
        }
        _countLoop += 1;
      }
    });

    _controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    if (widget.nameController == null) {
      _startController.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _rotation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _rotation = Tween(begin: -widget.angle, end: 0.0).animate(_rotation);

    final int milliseconds = widget.duration.inMilliseconds ~/ ((widget.numberLoop + 2) * 2);

    return Transform.rotate(
      angle: _rotation.value * pi / 180,
      child: _StartElementAnimationNameWidget(
        child: widget.child,
        angle: widget.angle * 2,
        duration: Duration(milliseconds: milliseconds),
        startAnimationNameController: _startController,
      ),
    );
  }
}

///controller điều khiển vòng quay
class _StartAnimationNameController extends ChangeNotifier {
  bool isElementPlay = true;
  bool isElementFinish = false;
  bool isPlay = false;

  void playAnimation() {
    isPlay = true;
    notifyListeners();
  }

  void playElementAnimation() {
    isElementPlay = true;
    isElementFinish = false;
    notifyListeners();
  }

  void finishElementAnimation() {
    isElementFinish = true;
    isElementPlay = false;
    notifyListeners();
  }
}

class _StartElementAnimationNameWidget extends StatefulWidget {
  const _StartElementAnimationNameWidget(
      {Key key,
      this.duration = const Duration(milliseconds: 5000),
      this.child,
      this.angle = 30,
      this.startAnimationNameController})
      : super(key: key);

  @override
  _StartElementAnimationNameWidgetState createState() => _StartElementAnimationNameWidgetState();
  final Duration duration;
  final Widget child;
  final double angle;
  final _StartAnimationNameController startAnimationNameController;
}

class _StartElementAnimationNameWidgetState extends State<_StartElementAnimationNameWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _rotation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _controller.forward();
    widget.startAnimationNameController.addListener(() {
      if (_controller.value == 1) {
        _controller.reverse();
      } else if (_controller.value == 0) {
        _controller.forward();
      }
    });

    _controller.addListener(() {
      setState(() {});
      if (!_controller.isAnimating && widget.startAnimationNameController.isElementPlay) {
        widget.startAnimationNameController?.finishElementAnimation();
      }
    });
    super.initState();
  }

  double angleToRadian(double angle) {
    return (angle * pi) / 180.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _rotation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _rotation = Tween(begin: 0.0, end: widget.angle).animate(_rotation);

    return Transform.rotate(
      angle: angleToRadian(_rotation.value),
      child: widget.child,
    );
  }
}
