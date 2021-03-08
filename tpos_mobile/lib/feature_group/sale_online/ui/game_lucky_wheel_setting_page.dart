import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_mobile/services/config_service/shop_config_service.dart';

class GameLuckyWheelSettingPage extends StatefulWidget {
  @override
  _GameLuckyWheelSettingPageState createState() =>
      _GameLuckyWheelSettingPageState();
}

class _GameLuckyWheelSettingPageState extends State<GameLuckyWheelSettingPage> {
  final _shopConfig = GetIt.I<ShopConfigService>();
  final quantityController = TextEditingController();

  double fontSize = 1;
  final TextStyle defaultStyle = const TextStyle(
    fontFamily: 'UVNVan_B',
    color: Colors.white,
    shadows: <BoxShadow>[
      BoxShadow(
        color: Color(0xFF064BC2),
        blurRadius: 10.0,
        offset: Offset(0.0, 10.0),
      ),
    ],
  );

  final TextStyle noteStyle = const TextStyle(color: Colors.white);

  String get priorSelectGroupValue =>
      _shopConfig.oldLuckyWheelConfig.isPriorGame;

  set priorSelectGroupValue(String value) {
    if (value == "share") {
      _shopConfig.oldLuckyWheelConfig.isPriorGame = "share";
    } else if (value == "comment") {
      _shopConfig.oldLuckyWheelConfig.isPriorGame = "comment";
    } else if (value == "share_comment") {
      _shopConfig.oldLuckyWheelConfig.isPriorGame = "share_comment";
    } else {
      _shopConfig.oldLuckyWheelConfig.isPriorGame = "all";
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    fontSize = deviceWidth / 414.0;
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFF5600E8), Color(0xFF3ADDFF)],
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: Colors.white,
        toggleableActiveColor: Colors.green,
      ),
      child: ListView(
        children: <Widget>[
          const SizedBox(height: 20),
          ListTile(
            title: Row(
              children: <Widget>[
                Expanded(child: Text("Cài đặt Game", style: defaultStyle)),
                RaisedButton(
                  padding: EdgeInsets.all(5.0 * fontSize),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Text(
                    "Đóng",
                    style:
                        TextStyle(color: Colors.white, fontSize: 16 * fontSize),
                  ),
                  color: const Color(0xFFFE5250),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Expanded(
                    child: Text("Đối tượng được tham gia trò chơi",
                        style: defaultStyle)),
              ],
            ),
            subtitle: Column(
              children: <Widget>[
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  value: _shopConfig.oldLuckyWheelConfig.isCommentGame,
                  title: Text('Có Comment', style: defaultStyle),
                  onChanged: (bool value) {
                    setState(() {
                      _shopConfig.oldLuckyWheelConfig.isCommentGame = value;
                      if (_shopConfig.oldLuckyWheelConfig.isPriorGame ==
                              "comment" &&
                          !_shopConfig.oldLuckyWheelConfig.isCommentGame) {
                        _shopConfig.oldLuckyWheelConfig.isPriorGame = "share";
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  value: _shopConfig.oldLuckyWheelConfig.isShareGame,
                  title: Text('Có Share', style: defaultStyle),
                  onChanged: (bool value) {
                    setState(() {
                      _shopConfig.oldLuckyWheelConfig.isShareGame = value;
                      if (_shopConfig.oldLuckyWheelConfig.isPriorGame ==
                              "comment" &&
                          !_shopConfig.oldLuckyWheelConfig.isCommentGame) {
                        _shopConfig.oldLuckyWheelConfig.isPriorGame = "share";
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  value: _shopConfig.oldLuckyWheelConfig.isShareGame
                      ? false
                      : _shopConfig.oldLuckyWheelConfig.isOrderGame,
                  title: Text('Và phải có mua hàng', style: defaultStyle),
                  subtitle: Text(
                    "Không có đơn hàng sẽ không được phép chơi",
                    style: noteStyle,
                  ),
                  onChanged: _shopConfig.oldLuckyWheelConfig.isShareGame
                      ? null
                      : (bool value) {
                          setState(() {
                            _shopConfig.oldLuckyWheelConfig.isOrderGame = value;
                          });
                        },
                ),
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  value: _shopConfig.oldLuckyWheelConfig.isWinGame,
                  title: Text('Người đã thắng cuộc', style: defaultStyle),
                  subtitle: Text(
                    "Bao gồm cả người đã thắng cuộc chơi trong quá khứ. ",
                    style: noteStyle,
                  ),
                  onChanged: (bool value) {
                    setState(() {
                      _shopConfig.oldLuckyWheelConfig.isWinGame = value;
                    });
                  },
                ),
              ],
            ),
          ),
          const Divider(
            indent: 10,
            endIndent: 10,
            color: Colors.white,
          ),
          ListTile(
            title: Text("Ưu tiên trúng thưởng", style: defaultStyle),
            subtitle: Column(
              children: <Widget>[
                RadioListTile<String>(
                  title: Text("Share nhiều hơn", style: defaultStyle),
                  value: "share",
                  groupValue: priorSelectGroupValue,
                  onChanged: (value) {
                    setState(
                      () {
                        priorSelectGroupValue = value;
                      },
                    );
                  },
                ),
                RadioListTile<String>(
                  title: Text("Comment nhiều hơn", style: defaultStyle),
                  value: _shopConfig.oldLuckyWheelConfig.isShareGame &&
                          !_shopConfig.oldLuckyWheelConfig.isCommentGame
                      ? null
                      : "comment",
                  groupValue: _shopConfig.oldLuckyWheelConfig.isShareGame &&
                          !_shopConfig.oldLuckyWheelConfig.isCommentGame
                      ? "share"
                      : priorSelectGroupValue,
                  onChanged: _shopConfig.oldLuckyWheelConfig.isShareGame &&
                          !_shopConfig.oldLuckyWheelConfig.isCommentGame
                      ? null
                      : (value) {
                          setState(() {
                            priorSelectGroupValue = value;
                          });
                        },
                ),
                RadioListTile<String>(
                  title: Text("Share + Comment nhiều hơn", style: defaultStyle),
                  subtitle: const Text(
                    "Mỗi 1 share hoặc comment sẽ được tính 1 vé tham dự",
                    style: TextStyle(color: Colors.white),
                  ),
                  value: "share_comment",
                  groupValue: priorSelectGroupValue,
                  onChanged: (value) {
                    setState(() {
                      priorSelectGroupValue = value;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: Text("Không ưu tiên", style: defaultStyle),
                  subtitle: const Text(
                    "Cơ hội chia đều cho tất cả người tham gia",
                    style: TextStyle(color: Colors.white),
                  ),
                  value: "all",
                  groupValue: priorSelectGroupValue,
                  onChanged: (value) {
                    setState(() {
                      priorSelectGroupValue = value;
                    });
                  },
                ),
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(
                    "Không ưu tiên người đã thắng gần đây",
                    style: defaultStyle,
                  ),
                  subtitle: Text(
                    "Nếu người đó đã thắng trong khoảng ${_shopConfig.oldLuckyWheelConfig.ignoreDays} ngày gần đây sẽ chỉ được 1 vé tham dự nếu đủ điều kiện",
                    style: noteStyle,
                  ),
                  value: _shopConfig.oldLuckyWheelConfig.isIgnoreRecentWinner,
                  onChanged: (value) {
                    setState(() {
                      _shopConfig.oldLuckyWheelConfig.isIgnoreRecentWinner =
                          value;
                    });
                  },
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                        "Số ngày bỏ qua: ${_shopConfig.oldLuckyWheelConfig.ignoreDays}    ",
                        style: defaultStyle.copyWith(fontSize: 16)),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 40,
                          height: 30,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            padding: const EdgeInsets.all(0),
                            child: const Icon(
                              Icons.keyboard_arrow_up,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _shopConfig.oldLuckyWheelConfig.ignoreDays += 1;
                              });
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                        ),
                        SizedBox(
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            child: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.all(0),
                            onPressed: () {
                              setState(() {
                                if (_shopConfig.oldLuckyWheelConfig.ignoreDays >
                                    0)
                                  _shopConfig.oldLuckyWheelConfig.ignoreDays -=
                                      1;
                              });
                            },
                          ),
                          width: 40,
                          height: 30,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                        "Thời gian 1 vòng quay: ${_shopConfig.oldLuckyWheelConfig.gameDurationInSecond} (s)   ",
                        style: defaultStyle.copyWith(fontSize: 16)),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 40,
                          height: 30,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            padding: const EdgeInsets.all(0),
                            child: const Icon(
                              Icons.keyboard_arrow_up,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _shopConfig.oldLuckyWheelConfig
                                    .gameDurationInSecond += 1;
                              });
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                        ),
                        SizedBox(
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            child: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.all(0),
                            onPressed: () {
                              setState(() {
                                if (_shopConfig.oldLuckyWheelConfig
                                        .gameDurationInSecond >
                                    0)
                                  _shopConfig.oldLuckyWheelConfig
                                      .gameDurationInSecond -= 1;
                              });
                            },
                          ),
                          width: 40,
                          height: 30,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                RaisedButton(
                  padding: EdgeInsets.all(5 * fontSize),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Text(
                    "CÀI ĐẶT XONG",
                    style:
                        TextStyle(color: Colors.white, fontSize: 16 * fontSize),
                  ),
                  color: const Color(0xFFFE5250),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
