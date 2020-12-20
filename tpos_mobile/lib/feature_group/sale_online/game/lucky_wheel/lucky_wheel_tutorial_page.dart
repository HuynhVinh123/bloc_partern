import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LuckyWheelTutorialPage extends StatefulWidget {
  @override
  _LuckyWheelTutorialPageState createState() => _LuckyWheelTutorialPageState();
}

class _LuckyWheelTutorialPageState extends State<LuckyWheelTutorialPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Column(children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.88,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Color.fromRGBO(32, 145, 58, 1)),
                    padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Container(
                        padding:
                            const EdgeInsets.only(right: 20, left: 20, top: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSetting(),
                            _buildPLayer(),
                            _buildTutorial(),
                            _buildButton(context),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
                _buildTitle()
              ],
            ),
          ),
        ));
  }
}

Widget _buildSetting() {
  return Column(
    children: [
      Row(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          const CircleAvatar(
            backgroundColor: Color.fromRGBO(0, 142, 48, 1),
            radius: 15,
            child: Text(
              '1',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const Text(
            '   Cài đặt',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'Lato'),
          )
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Image.asset(
                'lib/feature_group/sale_online/game/icon/ic_hand.png',
              ),
            ),
            const TextSpan(
                text:
                    'Có thể chọn những người có lượt share công khai hoặc có số lượng comment nhiều hơn sẽ có tỉ lệ thắng cao hơn trong phần  ',
                style: TextStyle(color: Colors.black, fontSize: 17)),
            WidgetSpan(
              child: CircleAvatar(
                  radius: 12,
                  backgroundColor: const Color.fromRGBO(240, 241, 243, 1),
                  child: Image.asset(
                    'lib/feature_group/sale_online/game/icon/ic_setting1.png',
                  )),
            ),
            const TextSpan(
                text: '  Cài đặt',
                style: TextStyle(
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 17)),
          ],
        ),
      ),
      const SizedBox(
        height: 15,
      ),
      RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Image.asset(
                'lib/feature_group/sale_online/game/icon/ic_hand.png',
              ),
            ),
            const TextSpan(
                text: 'Có thể bấm nút  ',
                style: TextStyle(color: Colors.black, fontSize: 17)),
            WidgetSpan(
              child: CircleAvatar(
                  radius: 12,
                  backgroundColor: const Color.fromRGBO(240, 241, 243, 1),
                  child: Image.asset(
                    'lib/feature_group/sale_online/game/icon/ic_rotate_screen.png',
                  )),
            ),
            const TextSpan(
                text: ' Xoay màn hình',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 17)),
            const TextSpan(
                text:
                    ' khi live bằng camera trước điện thoại để khách hàng có thể nhìn thấy nội dung',
                style: TextStyle(color: Colors.black, fontSize: 17)),
          ],
        ),
      ),
    ],
  );
}

Widget _buildPLayer() {
  return Column(
    children: [
      Row(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          const CircleAvatar(
            backgroundColor: Color.fromRGBO(0, 142, 48, 1),
            radius: 15,
            child: Text(
              '2',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const Text(
            '   Lấy danh sách người chơi',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'Lato'),
          )
        ],
      ),
      const SizedBox(
        height: 15,
      ),
      RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Image.asset(
                'lib/feature_group/sale_online/game/icon/ic_hand.png',
              ),
            ),
            const TextSpan(
                text: 'Bấm nút  ',
                style: TextStyle(color: Colors.black, fontSize: 17)),
            const WidgetSpan(
              child: CircleAvatar(
                  radius: 12,
                  backgroundColor: Color.fromRGBO(240, 241, 243, 1),
                  child: Icon(
                    Icons.refresh,
                    color: Colors.grey,
                  )),
            ),
            const TextSpan(
                text:
                    ' để reload lại danh sách người chơi. Danh sách người chơi là danh sách người đã bình luận trong bài viết của bạn.',
                style: TextStyle(color: Colors.black, fontSize: 17)),
          ],
        ),
      ),
    ],
  );
}

Widget _buildTutorial() {
  return Column(
    children: [
      Row(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          const CircleAvatar(
            backgroundColor: Color.fromRGBO(0, 142, 48, 1),
            radius: 15,
            child: Text(
              '3',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const Text(
            '   Quay vòng xoay may mắn',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'Lato'),
          )
        ],
      ),
      const SizedBox(
        height: 15,
      ),
      RichText(
        text: TextSpan(
          children: [
            const TextSpan(
                text: 'Để bắt đầu vòng xoay may mắn, bấm nút',
                style: TextStyle(color: Colors.black, fontSize: 17)),
            WidgetSpan(
              child: Image.asset(
                'lib/feature_group/sale_online/game/icon/ic_hand.png',
              ),
            ),
            WidgetSpan(
                child: Image.asset(
              'lib/feature_group/sale_online/game/icon/ic_button_turned.png',
              scale: 3,
            )),
            const TextSpan(
                text:
                    '  Vòng quay dừng lại ở ô người chơi nào thì người chơi đó sẽ là người thắng cuộc và nhận được quà.',
                style: TextStyle(color: Colors.black, fontSize: 17)),
          ],
        ),
      ),
      const SizedBox(
        height: 30,
      )
    ],
  );
}

Widget _buildButton(BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 15),
    child: RaisedButton(
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 17),
      color: const Color.fromRGBO(240, 241, 243, 1),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text(
        'Đóng',
        style: TextStyle(fontSize: 17, color: Color(0xff2C333A)),
      ),
    ),
  );
}

Widget _buildTitle() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 100),
    padding: const EdgeInsets.all(5),
    decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Color.fromRGBO(40, 167, 69, 1)),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          Image.asset(
            'lib/feature_group/sale_online/game/icon/ic_open_book.png',
            scale: 2,
          ),
          const SizedBox(
            width: 10,
          ),
          const Text(
            'HƯỚNG DẪN',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(44, 165, 78, 1),
                fontSize: 19,
                fontFamily: 'Lato'),
          ),
        ],
      ),
    ),
  );
}
