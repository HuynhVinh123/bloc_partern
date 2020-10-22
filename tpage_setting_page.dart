import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tpos_mobile/feature_group/tpage/uis/item_setting.dart';
import 'package:tpos_mobile/feature_group/tpage/uis/tag_page.dart';
import 'package:tpos_mobile/feature_group/tpage/uis/tpage_product_list_page.dart';

import 'fast_reply_page.dart';

class TPageSettingPage extends StatefulWidget {
  @override
  _TPageSettingPageState createState() => _TPageSettingPageState();
}

class _TPageSettingPageState extends State<TPageSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEDEF),
      appBar: AppBar(),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ItemSetting(
              icon: SvgPicture.asset(
                "assets/icon/tag-green.svg",
                height: 18,
                width: 18,
              ),
              title: "Nhãn hội thoại",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TagPage()),
                );
              },
            ),
            ItemSetting(
              icon: SvgPicture.asset(
                "assets/icon/tag-green.svg",
                height: 18,
                width: 18,
              ),
              title: "Trả lời nhanh",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FastReplyPage()),
                );
              },
            ),
            ItemSetting(
              icon: SvgPicture.asset(
                "assets/icon/tag-green.svg",
                height: 18,
                width: 18,
              ),
              title: "Sản phẩm",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TPageProductListPage()),
                );
              },
            ),
            ItemSetting(
                icon: SvgPicture.asset(
                  "assets/icon/tag-green.svg",
                  height: 18,
                  width: 18,
                ),
                title: "Cài đặt trang",
                onTap: () {},
                isLine: false)
          ],
        ),
      ),
    );
  }
}
