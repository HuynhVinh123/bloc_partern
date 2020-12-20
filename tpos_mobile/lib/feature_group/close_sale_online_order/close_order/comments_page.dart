import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tpos_mobile/helpers/svg_icon.dart';
import 'package:tpos_mobile/resources/app_colors.dart';
import 'package:tpos_mobile/resources/app_route.dart';
import 'package:tpos_mobile/resources/themes.dart';

class CommentsPage extends StatefulWidget {
  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  void _handleAddSession() {
    //Navigator.pushNamed(context, AppRoute.sale_online_session_add);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: _ListSaleOnlineSession(),
      backgroundColor: AppColors.brand1,
    );
  }

  Widget _buildAppbar() => AppBar(
        title: Text('Phiên chốt đơn'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _handleAddSession,
          )
        ],
      );

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: 100),
        _Icon(),
        const SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: _Text(),
        ),
        Spacer(),
        Padding(
          padding: EdgeInsets.only(
            left: 12,
            right: 12,
            bottom: 12,
          ),
          child: _Button(
            onPressed: _handleAddSession,
          ),
        ),
      ],
    );
  }
}

class _Icon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SvgIcon(
          SvgIcon.chart,
          color: Colors.grey.shade300,
        ),
        const SvgIcon(
          SvgIcon.commentLiveStream,
          color: Colors.grey,
        ),
      ],
    );
  }
}

class _Text extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'Chưa có phiên bán hàng đang hoạt động',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Text(
          'Tạo phiên bán hàng giúp chốt đơn trên livestream hiệu quả hơn với chốt đơn bằng tay và chốt đơn tự động.',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _Button extends StatelessWidget {
  final VoidCallback onPressed;

  const _Button({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(width: 0),
      ),
      onPressed: onPressed,
      textColor: Colors.white,
      padding: EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.add_circle_outline),
          const SizedBox(
            width: 10,
          ),
          Text('Phiên bán hàng mới')
        ],
      ),
    );
  }
}

// UI Danh sách phiên bán hàng
class _ListSaleOnlineSession extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) =>
          _ItemSaleOnlineSession(),
      itemCount: 10,
    );
  }
}

// UI item phiên bán hàng
class _ItemSaleOnlineSession extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12, top: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(0),
        title: Column(
          children: [
            Row(
              children: <Widget>[
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Text(
                    "Bán sale dọn kho",
                    style: const TextStyle(
                        color: Color(0xFF28A745),
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
                _childPopup()
              ],
            ),
            Row(
              children: <Widget>[
                const SizedBox(
                  width: 16,
                ),
                Text(
                  "Tạo lúc 01/05/2020",
                  style:
                      const TextStyle(color: Color(0xFF929DAA), fontSize: 14),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                              colors: [Color(0xFF3B7AD9), Color(0xFF71A9FC)])),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            "Tạo đơn tự động",
                            style: TextStyle(color: Colors.white, fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            const Divider(
              height: 12,
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 8,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(18)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
//                          margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.deepOrange, width: 3),
                                shape: BoxShape.circle),
                            width: 36,
                            height: 36,
                            child: CircleAvatar(
                              backgroundColor: Colors.green,
                            )),
                        Positioned(
                          bottom: 0,
                          left: 20,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                                color: Colors.deepOrange,
                                shape: BoxShape.circle),
                            child: Center(
                              child: const Icon(
                                Icons.videocam,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Flexible(
                      child: Text(
                        "Page shop bán shop",
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                        "[DEAL SỐC] Quần áo XK Nhiên Trung ra mắt chương trình khuyến mãi SỐC TẬN NỐC đây,..."),
                  ),
                  Container(
                    width: 90,
                    height: 60,
                    decoration: BoxDecoration(color: Colors.blue),
                    child: Center(
                      child: Image.asset(
                        "images/ic_play.png",
                        width: 32,
                        height: 32,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              Row(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(right: 4),
                    width: 17,
                    height: 17,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        gradient: LinearGradient(
                            colors: [Color(0xFF3DEB66), Color(0xFF28A745)])),
                    child: Center(
                      child: Icon(
                        Icons.mode_comment,
                        color: Colors.white,
                        size: 10,
                      ),
                    ),
                  ),
                  Text("1", style: TextStyle(color: Color(0xFF929DAA))),
                  Container(
                    margin: const EdgeInsets.only(left: 16, right: 4),
                    width: 17,
                    height: 17,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        gradient: LinearGradient(
                            colors: [Color(0xFFC794F3), Color(0xFF9358C5)])),
                    child: Center(
                      child: Icon(
                        Icons.share,
                        color: Colors.white,
                        size: 10,
                      ),
                    ),
                  ),
                  Text(
                    "1",
                    style: const TextStyle(color: Color(0xFF929DAA)),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 16, right: 4),
                    width: 19,
                    height: 19,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        gradient: LinearGradient(
                            colors: [Color(0xFF7AB8F6), Color(0xFF3E92E5)])),
                    child: Center(
                      child: Icon(
                        Icons.card_travel,
                        color: Colors.white,
                        size: 11,
                      ),
                    ),
                  ),
                  Text(
                    "1",
                    style: const TextStyle(color: Color(0xFF929DAA)),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Text(
                      "39 phút trước",
                      style: const TextStyle(color: Color(0xFF929DAA)),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    height: 32,
                    decoration: BoxDecoration(
                        color: const Color(0xFFF0F1F3),
                        borderRadius: BorderRadius.circular(6)),
                    child: const FlatButton(
                      child: Text("Thay đổi"),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Container(
                    height: 32,
                    decoration: BoxDecoration(
                        color: const Color(0xFF28A745),
                        borderRadius: BorderRadius.circular(6)),
                    child: const FlatButton(
                      child: Text(
                        "Tiếp tục",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // UI hiển thị option cho item
  Widget _childPopup() => PopupMenuButton<String>(
        itemBuilder: (context) => [
          const PopupMenuItem(
              value: "1",
              child: Text(
                "Chỉnh sửa cấu hình",
              )),
          const PopupMenuItem(
              value: "update_data",
              child: Text(
                "Sao chép",
              )),
          const PopupMenuItem(
            value: "setting_printer",
            child: Text(
              "Xóa",
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
        icon: const Icon(
          Icons.more_horiz,
          color: Colors.grey,
        ),
        onSelected: (value) async {},
      );
}
