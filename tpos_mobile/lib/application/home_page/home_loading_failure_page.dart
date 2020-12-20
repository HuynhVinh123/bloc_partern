import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tpos_mobile/helpers/svg_icon.dart';

class HomeLoadingFailureNotifyItem extends StatelessWidget {
  const HomeLoadingFailureNotifyItem({Key key, this.onRetryPressed})
      : super(key: key);
  final VoidCallback onRetryPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: const EdgeInsets.only(top: 12),
      curve: Curves.bounceInOut,
      duration: const Duration(seconds: 3),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      color: const Color(0xFFEB3B5B),
      child: Row(
        children: <Widget>[
          const SizedBox(
            width: 16,
          ),
          Container(
              height: 40,
              width: 40,
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                child: SvgIcon(SvgIcon.noConnect),
              )),
          const SizedBox(
            width: 16,
          ),
          Expanded(
              child: Text(
            "Lỗi khi kết nối với máy chủ. Vui lòng kiểm tra kết nối với Internet và thử lại.",
            style: TextStyle(color: Colors.white, fontSize: 15),
          )),
          const SizedBox(
            width: 6,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            width: 70,
            height: 30,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: FlatButton(
              onPressed: onRetryPressed,
              child: const AutoSizeText(
                "Tải lại",
                maxLines: 1,
                minFontSize: 10,
              ),
            ),
          )
        ],
      ),
    );
  }
}
