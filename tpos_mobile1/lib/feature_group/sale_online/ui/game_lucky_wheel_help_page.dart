import 'package:flutter/material.dart';

class GameLuckyWheelHelpPage extends StatefulWidget {
  @override
  _GameLuckyWheelHelpPageState createState() => _GameLuckyWheelHelpPageState();
}

class _GameLuckyWheelHelpPageState extends State<GameLuckyWheelHelpPage> {
  double fontSize;
  double deviceWidth;
  double deviceHeight;
  double statusBarHeight;

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    statusBarHeight = MediaQuery.of(context).padding.top;
    fontSize = deviceWidth / 414.0;

    final TextStyle _defaultTextStyle = TextStyle(
      fontFamily: 'UVNVan_B',
      fontSize: 20.0 * fontSize,
      color: Colors.white,
      shadows: const <BoxShadow>[
        BoxShadow(
          color: Color(0xFF064BC2),
          blurRadius: 10.0,
          offset: Offset(0.0, 10.0),
        ),
      ],
    );
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFF5600E8), Color(0xFF3ADDFF)],
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Padding(
          padding: EdgeInsets.only(bottom: fontSize * 30.0),
          child: Column(
            children: <Widget>[
              _buildGradientAppBar(),
              Expanded(
                child: Container(
                  width: deviceWidth * 0.9,
                  child: ListView(
                    padding: const EdgeInsets.all(0),
                    children: <Widget>[
                      Text(
                        'HƯỚNG DẪN CHƠI\n🔖',
                        style: _defaultTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Text(
                              '✔ Để lấy danh sách người chơi trước khi quay bấm nút ↩️',
                              style: _defaultTextStyle,
                            ),
                          ),
                          RaisedButton(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20.0, top: 10, bottom: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Text(
                              "Chuẩn bị chơi",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16 * fontSize),
                            ),
                            color: const Color(0xFFFE5250),
                            onPressed: () async {},
                          ),

                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Text(
                              '✔ Để bắt đầu vòng xoay may mắn. Bấm nút ↩️',
                              style: _defaultTextStyle,
                            ),
                          ),
                          RaisedButton(
                            padding: const EdgeInsets.only(
                                left: 30.0, right: 30.0, top: 10, bottom: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Text(
                              "Quay",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16 * fontSize),
                            ),
                            color: const Color(0xFFFE5250),
                            onPressed: () async {},
                          ),
                          Text(
                            '✔ Vòng quay dừng lại ở ô người chơi nào thì người chơi đó sẽ là người thắng cuộc và nhận được quà.',
                            style: _defaultTextStyle,
                          ),
                          Text(
                            '✔ Có thể chọn những người có lượt share công khai hoặc có số comment nhiều hơn sẽ có tỉ lệ thắng cao hơn trong phần cài đặt.',
                            style: _defaultTextStyle,
                          ),
                          Wrap(
                            children: <Widget>[
                              Text(
                                "Có thể bấm nút ",
                                style: _defaultTextStyle,
                              ),
                              Icon(Icons.screen_rotation),
                              Text(
                                "khi live bằng camera trước điện thoại để khách hàng có thể nhìn thấy nội dung",
                                style: _defaultTextStyle,
                              ),
                            ],
                          ),

//                          Container(
//                            margin: EdgeInsets.only(top: 10),
//                            decoration: new BoxDecoration(
//                              color: new Color(0xFFFFFFFF),
//                              shape: BoxShape.rectangle,
//                              borderRadius: new BorderRadius.circular(5.0),
//                              boxShadow: <BoxShadow>[
//                                new BoxShadow(
//                                  color: new Color(0xFF064BC2),
//                                  blurRadius: 10.0,
//                                  offset: new Offset(0.0, 5.0),
//                                ),
//                                new BoxShadow(
//                                  color: new Color(0xFF064BC2),
//                                  blurRadius: 10.0,
//                                  offset: new Offset(0.0, -5.0),
//                                ),
//                              ],
//                            ),
//                            child: Padding(
//                              padding: const EdgeInsets.all(8.0),
//                              child: Text(
//                                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
//                                style: TextStyle(
//                                    color: Colors.black,
//                                    fontSize: 16 * fontSize),
//                              ),
//                            ),
//                          ),
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

  Widget _buildGradientAppBar() {
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
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
