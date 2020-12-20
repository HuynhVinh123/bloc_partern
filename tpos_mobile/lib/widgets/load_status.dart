import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

///Sử dụng để thông báo chung (có thể là lỗi, không kết nối được với server, thông báo người dùng dữ liệu đang trống,... )
// ignore: must_be_immutable
class LoadStatusWidget extends StatelessWidget {
  LoadStatusWidget({
    Key key,
    this.statusIcon,
    this.dashPadding = const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
    this.statusName,
    this.content,
    this.action,
  }) : super(key: key);

  LoadStatusWidget.empty(
      {this.statusIcon,
      this.action,
      this.dashPadding = const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
      this.statusName,
      this.content}) {
    statusIcon = statusIcon ?? SvgPicture.asset('assets/icon/empty-data.svg', width: 170, height: 130);
    statusName = statusName ?? '';
  }

  Widget statusIcon;
  final Widget action;
  final EdgeInsets dashPadding;
  String statusName;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(7)),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          statusIcon,
          const SizedBox(height: 25),
          Padding(
              padding: dashPadding,
              child: Text(
                statusName,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(color: Color.fromARGB(255, 44, 51, 58), fontSize: 21, fontWeight: FontWeight.bold),
              )),
          const SizedBox(height: 13),
          Padding(
            padding: dashPadding,
            child: Text(
              content,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(color: Color.fromARGB(255, 107, 114, 128), fontSize: 17),
            ),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              action ?? const SizedBox(),
            ],
          ),
          if (action != null) const SizedBox(height: 25),
        ],
      ),
    );
  }
}
