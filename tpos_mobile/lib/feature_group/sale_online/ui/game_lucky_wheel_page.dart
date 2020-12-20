import 'dart:async';
import 'dart:io';

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:screen/screen.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/FacebookWinner.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/game_lucky_wheel_viewmodel.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/new_facebook_post_comment_viewmodel.dart';
import 'package:tpos_mobile/helpers/ui_help.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:animated_background/animated_background.dart';
import 'game_lucky_wheel_help_page.dart';
import 'game_lucky_wheel_setting_page.dart';

class GameLuckyWheelPage extends StatefulWidget {
  const GameLuckyWheelPage({
    this.uId,
    this.postId,
    this.commentVm,
  });
  final String uId;
  final String postId;
  final NewFacebookPostCommentViewModel commentVm;

  @override
  _GameLuckyWheelPageState createState() => _GameLuckyWheelPageState();
}

class _GameLuckyWheelPageState extends State<GameLuckyWheelPage>
    with TickerProviderStateMixin {
  _GameLuckyWheelPageState();
  double transform = 0;

  LuckyWheelViewModel viewModel = LuckyWheelViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _controller = ScrollController();
  bool isReady = false;

  double deviceHeightContainer;
  double deviceWidthContainer;
  double fontSize;
  bool isClose = true;

  // Particles
  ParticleOptions particleOptions = ParticleOptions(
    image: Image.asset('images/star_stroke.png'),
    baseColor: Colors.blue,
    spawnOpacity: 0.0,
    opacityChangeRate: 0.25,
    minOpacity: 0.5,
    maxOpacity: 1.0,
    spawnMinSpeed: 30.0,
    spawnMaxSpeed: 70.0,
    spawnMinRadius: 7.0,
    spawnMaxRadius: 15.0,
    particleCount: 40,
  );

  var particlePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;

  /// Chuẩn bị chơi
  Future<void> _goToElementPrepare() async {
    if (viewModel.players == null || viewModel.players.isEmpty) {
      return;
    }
    if (viewModel.isPrepaing || viewModel.isPlaying) {
      return;
    }
    if (mounted)
      setState(() {
        viewModel.isPrepaing = true;
      });
    try {
      final double offset = (deviceHeightContainer / 5) *
          viewModel.players.indexOf(viewModel.players.last).toDouble();

      await _controller.animateTo(
        offset,
        duration: const Duration(milliseconds: 5000),
        curve: Curves.easeOut,
      );
    } catch (e) {
      viewModel.isPrepaing = false;
    }

    if (mounted)
      setState(() {
        viewModel.isPrepaing = false;
      });
  }

  /// Chơi luôn
  Future<int> _goToElement() async {
    if (viewModel.players == null || viewModel.players.isEmpty) {
      locator<DialogService>().showError(content: "Không có người chơi nào");
      return 0;
    }
    if (mounted)
      setState(() {
        viewModel.isPlaying = true;
      });

    await viewModel.startGame();

    // Tổng thời gian
    final double gameDurationSecond = viewModel.gameDurationSecond.toDouble();

    // Thời gian bắt đầu giảm vận tốc
    //const double gameDurationReduce = 10;

    // Vận tốc
    const double speed = 100;

    // Loop 33ms
    const double gameLoop = 17;

    // Độ cao một item
    final double itemHeight = deviceHeightContainer / 5;

    // Số vòng lặp
    final double gameTime = gameDurationSecond * 1000 / gameLoop;

    // Khoảng cách
    final double distance = gameTime * (speed / 2);

    // Bước lùi
    final double speedStep = speed / gameTime;
    // Vị trí dừng
    final double endOffset = itemHeight * viewModel.winPlayerIndex;

    // Vị trí khởi đầu
    final double startOffset = endOffset - distance - 50;

    // Vị trí hiện tại
    double tempOffset = startOffset;

    /// Vận tốc hiện tại
    double tempSpeed = speed;

//    print(''''
//    - Vị trí người trúng: ${viewModel.winPlayer.name}
//    - Số vòng lặp: $gameTime
//    - Khoảng cách: $distance
//    - Bước lùi: $speedStep
//    - Vị trí bắt đầu: $startOffset
//    - Vị trí dừng: $endOffset
//    ''');

    // loop
    while (tempSpeed > 0) {
      _controller.jumpTo(tempOffset);
      await Future.delayed(Duration(milliseconds: gameLoop.toInt()));
      tempOffset += tempSpeed;
      tempSpeed -= speedStep;
    }

    // Vị trí người trúng
    final int index = (tempOffset / (deviceHeightContainer / 5)).round();

    if (mounted)
      setState(() {
        viewModel.isPlaying = false;
      });

    await Future.delayed(const Duration(seconds: 1));
    await viewModel.fetchWinnerAvatar();
    await Navigator.push(
      context,
      HeroDialogRoute(builder: (BuildContext context) {
        return _buildPopUp(context, index);
      }),
    );
    return index;
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Screen.keepOn(true);
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    deviceWidthContainer = deviceWidth * 0.9;
    deviceHeightContainer = deviceHeight * 0.8;
    fontSize = deviceWidth / 414.0;

    return ScopedModel<LuckyWheelViewModel>(
      model: viewModel,
      child: WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
          key: _scaffoldKey,
          body: Transform(
            transform: Matrix4.rotationY(transform),
            alignment: Alignment.center,
            child: UIViewModelBaseGame(
              viewModel: viewModel,
              child: ScopedModelDescendant<LuckyWheelViewModel>(
                builder: (context, child, model) => Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xFF5600E8), Color(0xFF3ADDFF)],
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  child: AnimatedBackground(
                    behaviour: RandomParticleBehaviour(
                      options: particleOptions,
                      paint: particlePaint,
                    ),
                    vsync: this,
                    child: Column(
                      children: <Widget>[
                        _buildGradientAppBar(),
                        Center(
                          child: Container(
                            height: deviceHeightContainer,
                            width: deviceWidthContainer,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: deviceHeightContainer * 0.3,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        " 🌟 ",
                                        style: TextStyle(
                                          fontSize: 30.0 * fontSize,
                                          shadows: const <BoxShadow>[
                                            BoxShadow(
                                              color: Color(0xFF064BC2),
                                              blurRadius: 10.0,
                                              offset: Offset(0.0, 10.0),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        '🎁\nVÒNG XOAY\nMAY MẮN',
                                        style: TextStyle(
                                          fontFamily: 'UVNVan_B',
                                          fontSize: 30.0 * fontSize,
                                          color: Colors.white,
                                          shadows: const <BoxShadow>[
                                            BoxShadow(
                                              color: Color(0xFF064BC2),
                                              blurRadius: 10.0,
                                              offset: Offset(0.0, 10.0),
                                            ),
                                          ],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        " 🌟 ",
                                        style: TextStyle(
                                          fontSize: 30 * fontSize,
                                          shadows: const <BoxShadow>[
                                            BoxShadow(
                                              color: Color(0xFF064BC2),
                                              blurRadius: 10.0,
                                              offset: Offset(0.0, 10.0),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: InkWell(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.people, color: Colors.white),
                                        Text(
                                          "${viewModel.players?.length} ",
                                          style: TextStyle(
                                            fontSize: 20 * fontSize,
                                            color: Colors.white,
                                            shadows: const <BoxShadow>[
                                              BoxShadow(
                                                color: Color(0xFF064BC2),
                                                blurRadius: 10.0,
                                                offset: Offset(0.0, 10.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(Icons.share, color: Colors.white),
                                        Text(
                                          "${viewModel.playerShareCount} ",
                                          style: TextStyle(
                                            fontSize: 20 * fontSize,
                                            color: Colors.white,
                                            shadows: const <BoxShadow>[
                                              BoxShadow(
                                                color: Color(0xFF064BC2),
                                                blurRadius: 10.0,
                                                offset: Offset(0.0, 10.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(Icons.comment,
                                            color: Colors.white),
                                        Text(
                                          "${viewModel.playerCommentCount} ",
                                          style: TextStyle(
                                            fontSize: 20 * fontSize,
                                            color: Colors.white,
                                            shadows: const <BoxShadow>[
                                              BoxShadow(
                                                color: Color(0xFF064BC2),
                                                blurRadius: 10.0,
                                                offset: Offset(0.0, 10.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(Icons.refresh,
                                            color: Colors.white),
                                      ],
                                    ),
                                    onTap: () {
                                      viewModel.initCommand();
                                    },
                                  ),
                                ),
                                // List
                                Expanded(
                                  child: ScopedModelDescendant<
                                      LuckyWheelViewModel>(
                                    builder: (context, child, model) => Stack(
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        Container(
                                          width: deviceWidthContainer * 0.9,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFFFFF),
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            boxShadow: const <BoxShadow>[
                                              BoxShadow(
                                                color: Color(0xFF064BC2),
                                                blurRadius: 10.0,
                                                offset: Offset(0.0, 5.0),
                                              ),
                                              BoxShadow(
                                                color: Color(0xFF064BC2),
                                                blurRadius: 10.0,
                                                offset: Offset(0.0, -5.0),
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsets.all(3.0 * fontSize),
                                            child:
                                                ListWheelScrollView.useDelegate(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              diameterRatio: 100,
                                              controller: _controller,
                                              itemExtent:
                                                  deviceHeightContainer / 5,
                                              childDelegate:
                                                  ListWheelChildLoopingListDelegate(
                                                children: List<Widget>.generate(
                                                    viewModel.players?.length ??
                                                        0, (index) {
                                                  return _buildItem(index);
                                                }),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.centerRight,
                                          child: Image.asset(
                                            "images/arrow.png",
                                            width: 50 * fontSize,
                                            height: 50 * fontSize,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: deviceHeightContainer * 0.1,
                                  width: deviceWidthContainer * 0.9,
                                  margin: const EdgeInsets.only(top: 30.0),
                                  decoration: const BoxDecoration(boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFF064BC2),
                                      blurRadius: 10.0,
                                      offset: Offset(0.0, 10.0),
                                    ),
                                  ]),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0)),
                                          padding: const EdgeInsets.only(
                                              left: 25.0,
                                              right: 25.0,
                                              top: 15,
                                              bottom: 15),
                                          color: Colors.green,
                                          child: Text(
                                            "Hướng dẫn",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16 * fontSize),
                                          ),
                                          onPressed: () async {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (ctx) =>
                                                    GameLuckyWheelHelpPage(),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10 * fontSize,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: RaisedButton(
                                          padding: const EdgeInsets.only(
                                              left: 25.0,
                                              right: 25.0,
                                              top: 15,
                                              bottom: 15),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0)),
                                          child: Text(
                                            "Quay",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16 * fontSize),
                                          ),
                                          color: const Color(0xFFFE5250),
                                          onPressed: viewModel.isPlaying ||
                                                  viewModel.isPrepaing
                                              ? null
                                              : () async {
                                                  try {
                                                    await _goToElement();
                                                  } catch (e, s) {
                                                    print(s);
                                                  }
                                                },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(int index) {
    return Padding(
      padding: EdgeInsets.only(top: 3.0 * fontSize),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFF28A7),
          gradient: LinearGradient(
              colors: const [Color(0xFFFF28A7), Color(0xFFFE5250)],
              begin: Alignment.bottomRight,
              end: const Alignment(-1.0, -1.0)),
          borderRadius: BorderRadius.circular(3.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: "hero_${viewModel.players[index].id}",
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.white,
                  )),
                  width: deviceHeightContainer / 6.25,
                  margin: const EdgeInsets.only(right: 10),
                  child: FadeInImage(
                    placeholder: const AssetImage("images/game_avatar.jfif"),
                    image: CachedNetworkImageProvider(
                      viewModel.players[index].picture ?? '',
                    ),
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                    fadeInDuration: const Duration(milliseconds: 200),
                    fadeInCurve: Curves.linear,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(viewModel.players[index].name,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22 * fontSize,
                          )),
                      Row(
                        children: <Widget>[
                          Icon(Icons.share, color: Colors.white),
                          Text(
                            "${viewModel.players[index].countShare ?? "0"}  ",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 20 * fontSize,
                              color: Colors.white,
                            ),
                          ),
                          Icon(Icons.comment, color: Colors.white),
                          Text(
                            " ${viewModel.players[index].countComment ?? "0"}",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 20 * fontSize,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopUp(BuildContext context, int index) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    fontSize = deviceWidth / 414.0;
    return Center(
      child: AnimatedBackground(
        behaviour: RandomParticleBehaviour(
          options: particleOptions.copyWith(
              image: Image.asset('images/ballon.png'),
              spawnMaxRadius: 50,
              particleCount: 20),
          paint: particlePaint,
        ),
        vsync: this,
        child: AlertDialog(
          content: Transform(
            transform: Matrix4.rotationY(transform),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "⭐ Xin chúc mừng! ⭐",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18 * fontSize, color: Colors.red),
                      ),
                      Text(
                        viewModel.players[index].name ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24 * fontSize, color: Colors.red),
                      ),
                    ],
                  ),
                ),
                Hero(
                  tag: "hero_${viewModel.players[index].id}",
                  child: Container(
                    width: deviceHeightContainer / 2,
                    decoration: BoxDecoration(
                        border: Border.all(
                      color: Colors.white,
                    )),
                    child: FadeInImage(
                      placeholder: const AssetImage(
                          "images/game_luckywheel_avatar_white.jpg"),
                      image: FileImage(File(viewModel.winnerAvatar ?? "")),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 20, right: 20, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          padding: EdgeInsets.all(5 * fontSize),
                          color: Colors.green,
                          child: Text(
                            "Lưu & In",
                            style: TextStyle(
                                color: Colors.white, fontSize: 16 * fontSize),
                          ),
                          onPressed: () async {
                            await viewModel.updateFacebookWinner();
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: RaisedButton(
                          padding: EdgeInsets.all(5 * fontSize),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Text(
                            "Đóng",
                            style: TextStyle(
                                color: Colors.white, fontSize: 16 * fontSize),
                          ),
                          color: const Color(0xFFFE5250),
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future showDialogFacebookWinner() async {
    await showDialog(
        context: context,
        builder: (ctx) {
          return StreamBuilder<List<FacebookWinner>>(
              initialData: viewModel.facebookWinners.reversed.toList(),
              stream: viewModel.facebookWinnersStream,
              builder: (context, AsyncSnapshot<List<FacebookWinner>> snapshot) {
                return AlertDialog(
                  shape: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  contentPadding: const EdgeInsets.all(0),
                  title: const Text("Danh sách người trúng"),
                  content: Container(
                    width: 1000,
                    padding: const EdgeInsets.only(top: 10),
                    child: Scrollbar(
                      child: ListView.separated(
                          shrinkWrap: false,
                          itemCount: snapshot.data?.length ?? 0,
                          separatorBuilder: (ctx, index) {
                            return const Divider();
                          },
                          itemBuilder: (ctx, index) {
                            return ListTile(
                              contentPadding: const EdgeInsets.only(
                                left: 5,
                                right: 5,
                              ),
                              leading: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text("${index + 1}."),
                                    FadeInImage(
                                      width: deviceHeightContainer / 7.25,
                                      placeholder: const AssetImage(
                                          "images/no_image.png"),
                                      image: CachedNetworkImageProvider(
                                          "http://graph.facebook.com/${snapshot.data[index].facebookUId}/picture?width=${(deviceHeightContainer / 7.25).round()}&access_token=${widget.commentVm.crmTeam.userOrPageToken}",
                                          errorListener: () {
                                        print("load image fail");
                                      }),
                                      fit: BoxFit.contain,
                                      alignment: Alignment.center,
                                      fadeInDuration:
                                          const Duration(milliseconds: 200),
                                      fadeInCurve: Curves.linear,
                                    ),
                                  ]),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          snapshot.data[index].facebookName ??
                                              '',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
                                      PopupMenuButton<String>(
                                        itemBuilder: (context) => [
                                          PopupMenuItem<String>(
                                            child: Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Icon(Icons.message),
                                                ),
                                                const Expanded(
                                                  child: Text(
                                                      "Gửi tin nhắn Messenger"),
                                                ),
                                              ],
                                            ),
                                            value: "messenger",
                                          ),
                                          PopupMenuItem<String>(
                                            child: Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Icon(Icons.message),
                                                ),
                                                const Expanded(
                                                  child: Text("In phiếu"),
                                                ),
                                              ],
                                            ),
                                            value: "print",
                                          ),
                                        ],
                                        onSelected: (value) {
                                          switch (value) {
                                            case "messenger":
                                              urlLauch(
                                                "fb://messaging/${snapshot.data[index].facebookUId}",
                                              );
                                              break;
                                            case "print":
                                              viewModel.printWin(
                                                  snapshot
                                                      .data[index].facebookName,
                                                  snapshot
                                                      .data[index].facebookUId);
                                              break;
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  Text(
                                    DateFormat("dd/MM/yyyy  HH:mm", "en_US")
                                        .format(
                                      snapshot.data[index].dateCreated
                                          .toLocal(),
                                    ),
                                    style: TextStyle(
                                        color: Colors.indigo.shade400),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: const Text("ĐÓNG"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                );
              });
        });
  }

  @override
  void initState() {
    // Chỉ màn hình dọc
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    viewModel.init(
        postId: widget.postId,
        facebookUid: widget.postId,
        crmTeam: widget.commentVm?.crmTeam,
        commentVM: widget.commentVm);
    viewModel.initCommand().then((data) async {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GameLuckyWheelSettingPage()));
        viewModel.refreshPlayer();
      });
    });

    // Lắng nghe sự kiện từ vm
    viewModel.eventController.listen((event) {
      if (event.eventName == LuckyWheelViewModel.REFRESH_PLAYER_EVENT) {
        // gọi chuẩn bị chơi game

        _goToElementPrepare();
      }
    });

    super.initState();
//    viewModel.initCommand().then((value) {
//      // _showUpdateNotify();
//    });
  }

  Widget _buildGradientAppBar() {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    fontSize = deviceWidth / 414.0;
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      padding: EdgeInsets.only(top: statusBarHeight),
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            IconButton(
              iconSize: 24 * fontSize,
              color: Colors.white,
              icon: Icon(Icons.close),
              onPressed: () {
                if (viewModel.isPlaying) {
                  return;
                }

                Navigator.pop(context);
              },
            ),
            IconButton(
              iconSize: 24 * fontSize,
              color: Colors.white,
              onPressed: () {
                setState(() {
                  if (transform == pi) {
                    transform = 0;
                  } else {
                    transform = pi;
                  }
                });
              },
              icon: Icon(
                Icons.screen_rotation,
              ),
            ),
            IconButton(
              iconSize: 24 * fontSize,
              color: Colors.white,
              onPressed: () async {
                showDialogFacebookWinner();
              },
              icon: Icon(
                Icons.list,
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.topRight,
                child: IconButton(
                  iconSize: 24 * fontSize,
                  color: Colors.white,
                  onPressed: () async {
                    await Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return GameLuckyWheelSettingPage();
                    }));

                    viewModel.refreshPlayer();
                  },
                  icon: Icon(
                    Icons.settings,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum ParticleType {
  Shape,
  Image,
}

class HeroDialogRoute<T> extends PageRoute<T> {
  HeroDialogRoute({this.builder}) : super();

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black54;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child);
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  String get barrierLabel => null;
}

class UIViewModelBaseGame extends StatelessWidget {
  const UIViewModelBaseGame(
      {@required this.viewModel,
      @required this.child,
      this.errorBuilder,
      this.indicatorBuilder,
      this.defaultIndicatorColor,
      this.defaultIndicatorBackgroundColor,
      this.backgroundColor});
  final ViewModel viewModel;
  final Widget child;
  final Widget Function(BuildContext) errorBuilder;
  final Widget Function(BuildContext) indicatorBuilder;
  final Color defaultIndicatorColor;
  final Color defaultIndicatorBackgroundColor;
  final Color backgroundColor;

  Widget _buildDefaultIndicator({String message, BuildContext context}) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFF5600E8), Color(0xFF3ADDFF)],
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                message ?? "",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: defaultIndicatorBackgroundColor ?? Colors.grey.shade300,
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text("Có gì đó không đúng rồi"),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RaisedButton(
                    child: const Text("Về trang trước"),
                    onPressed: () {},
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  RaisedButton(
                    child: const Text("Thử lại"),
                    onPressed: () {},
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        StreamBuilder<ViewModelState>(
          stream: viewModel.stateController,
          initialData: ViewModelState(isBusy: true, message: "Đang tải..."),
          builder: (context, snapshot) {
            if (snapshot.data.isError) {
              return errorBuilder ?? _buildDefaultError();
            }

            if (snapshot.data.isBusy) {
              return indicatorBuilder ??
                  _buildDefaultIndicator(
                      message: snapshot.data.message, context: context);
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }
}
