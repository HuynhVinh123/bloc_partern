import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_mobile/feature_group/tpage/settings/uis/products/tpage_product_list_page.dart';
import 'package:tpos_mobile/feature_group/tpage/settings/uis/setting/setting_page.dart';
import 'package:tpos_mobile/feature_group/tpage/settings/uis/setting_item.dart';
import 'package:tpos_mobile/feature_group/tpage/settings/uis/tags/tag_page.dart';
import 'package:tpos_mobile/resources/menus.dart';
import 'package:tpos_mobile/resources/tpos_mobile_icons.dart';

import 'fast_reply/fast_reply_page.dart';

class TPageSettingPage extends StatefulWidget {
  @override
  _TPageSettingPageState createState() => _TPageSettingPageState();
}

class _TPageSettingPageState extends State<TPageSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEDEF),
      appBar: AppBar(
        title: const Text("Cấu hình Tpage"),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SettingItem(
              icon: Icon(
                TPosIcons.tag,
                color: MenuGroupType.tpage.backgroundColor,
              ),
              title: "Nhãn hội thoại",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TagPage()),
                );
              },
            ),
            SettingItem(
              icon: SvgPicture.asset(
                "assets/icon/ic_reply.svg",
                height: 16,
                width: 16,
              ),
              title: "Trả lời nhanh",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FastReplyPage()),
                );
              },
            ),
            SettingItem(
              icon: Icon(
                TPosIcons.product_fill,
                color: MenuGroupType.tpage.backgroundColor,
              ),
              title: "Sản phẩm",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TPageProductListPage()),
                );
              },
            ),
            SettingItem(
                icon: Icon(
                  FontAwesomeIcons.facebookF,
                  size: 18,
                  color: MenuGroupType.tpage.backgroundColor,
                ),
                title: "Cài đặt trang",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingPage()),
                  );
                },
                isLine: false)
          ],
        ),
      ),
    );
  }
}
