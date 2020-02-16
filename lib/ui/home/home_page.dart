import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lazada/models/custom_popup.dart';
import 'package:flutter_app_lazada/ui/home/electronic_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<CustomPopupMenu> choices = <CustomPopupMenu>[
    CustomPopupMenu(title: 'Đăng nhập', icon: Icons.home),
    CustomPopupMenu(title: 'Quản lý tài khoản', icon: Icons.bookmark),
    CustomPopupMenu(title: 'Danh sách mong muốn', icon: Icons.settings),
    CustomPopupMenu(title: 'Đơn hàng của tôi', icon: Icons.settings),
    CustomPopupMenu(title: 'Sản phẩm đã xem', icon: Icons.settings),
  ];

  Widget searchApp() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(4))),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 4,
          ),
          Icon(
            Icons.search,
            color: Colors.grey[700],
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                  hintText: "Tìm kiếm sản phẩm",
                  hintStyle: TextStyle(color: Colors.grey[700]),
                  border: InputBorder.none),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
        ),
        title: searchApp(),
        actions: <Widget>[
          Center(
            child: Badge(
              badgeContent: Text('3'),
              child: Icon(Icons.shopping_cart),
            ),
          ),
          PopupMenuButton<CustomPopupMenu>(
            elevation: 2.2,
            initialValue: choices[1],
            onCanceled: () {
              print('You have not chossed anything');
            },
            tooltip: '',
            onSelected: _select,
            itemBuilder: (BuildContext context) {
              return choices.map((CustomPopupMenu choice) {
                return PopupMenuItem<CustomPopupMenu>(
                  value: choice,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        choice.icon,
                        color: Colors.grey[500],
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text("${choice.title}")
                    ],
                  ),
                );
              }).toList();
            },
          )
        ],
        bottom: TabBar(
          unselectedLabelColor: Colors.white,
          labelColor: Colors.amber,
          tabs: [
            new Text("Điện tử"),
            new Text("Nhà củ và đời sống"),
            new Text("Chương trình khuyến mãi"),
          ],
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        bottomOpacity: 1,
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[ElectronicPage(), Text("2"), Text("3")],
      ),
    );
  }

  void _select(CustomPopupMenu choice) {
    setState(() {
      //_selectedChoices = choice;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
  }
}
