import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tpos_mobile/helpers/svg_icon.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import '../../resources/app_colors.dart';

class MenuAlertLoadingFailure extends StatelessWidget {
  const MenuAlertLoadingFailure({Key key, this.onReload, this.message = ''})
      : super(key: key);
  final VoidCallback onReload;
  final dynamic message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
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
                child: SvgIcon(
                  SvgIcon.noConnect,
                ),
              )),
          const SizedBox(
            width: 16,
          ),
          Expanded(
              child: Text(
            "Đã xảy ra lỗi khi kêt nối với TPOS. $message",
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
              onPressed: onReload,
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

class MenuAlertExpired extends StatelessWidget {
  const MenuAlertExpired({Key key, this.expiredDay}) : super(key: key);
  final String expiredDay;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: const EdgeInsets.only(top: 10),
      curve: Curves.bounceInOut,
      duration: const Duration(seconds: 3),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      color: AppColors.dialogWarningColor,
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
                  child: SvgIcon(
                    SvgIcon.ring,
                    color: Color(0xFFE94961),
                  ))),
          const SizedBox(
            width: 16,
          ),
          Expanded(
              child: Text(
            S.current.notifyExpire(expiredDay),
            style: const TextStyle(color: Colors.white, fontSize: 15),
          )),
          IconButton(
            onPressed: () {},
            icon: const Center(
              child: Icon(Icons.close, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}
