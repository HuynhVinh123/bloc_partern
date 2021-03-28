import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:example/route/application_item.dart';
import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:flutter/material.dart';
import 'package:extended_sliver/extended_sliver.dart';

@FFRoute(
  name: 'fluttercandies://PinnedHeader',
  routeName: 'PinnedHeader',
  description: 'pinned header without minExtent and maxExtent.',
  exts: <String, dynamic>{
    'group': 'Simple',
    'order': 0,
  },
)
class PinnedHeader extends StatefulWidget {
  @override
  _PinnedHeaderState createState() => _PinnedHeaderState();
}

class _PinnedHeaderState extends State<PinnedHeader>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final List<Tab> tabs = <Tab>[
    new Tab(text: "Featured"),
    new Tab(text: "Popular"),
    new Tab(text: "Latest")
  ];

  int _index = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);
    _tabController.addListener(() {
      _index = _tabController.index;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        ExtendedSliverAppbar(
          isOpacityFadeWithTitle: false,
          toolBarColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Chi nhanh ho chi minh ^',
                style: TextStyle(color: const Color(0xff858585)),
              ),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.location_on_sharp, color: Color(0xff858585)),
            onPressed: () {},
          ),
          background: Container(
            color: const Color(0xFFEDF4FF),
            height: 400,
            child: Stack(
              children: [
                Positioned(
                    right: 0,
                    top: 100,
                    child: Image.asset('assets/Group.png',
                        width: 240, height: 140)),
                Positioned(
                    left: 12,
                    top: 120,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Xin chao',
                          style: TextStyle(color: const Color(0xFF858585)),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Huynh Vinh',
                          style: TextStyle(
                              color: Color(0xFF303030),
                              fontWeight: FontWeight.w600,
                              fontSize: 20),
                        )
                      ],
                    )),
                Positioned(
                  top: 220,
                  left: 16,
                  right: 16,
                  child: Container(
                    height: 44,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: Center(
                        child: Row(
                      children: [
                        const SizedBox(
                          width: 12,
                        ),
                        const Icon(
                          Icons.search,
                          color: Color(0xFF858585),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(child: _buildInput()),
                      ],
                    )),
                  ),
                ),
                Positioned(
                  top: 280,
                  left: 0,
                  right: 0,
                  child: Row(
                    children: [
                      ...MenuItems.map(
                        (Item item) => Expanded(
                          child: ItemWidget(
                            title: item.name,
                            icon: item.icon,
                            permission: item.permission,
                          ),
                        ),
                      ).toList()
                    ],
                  ),
                )
              ],
            ),
          ),
          actions: const Padding(
            padding: EdgeInsets.all(10.0),
            child: Icon(Icons.notifications, color: Color(0xff858585)),
          ),
        ),
        SliverSafeArea(
          top: false,
          bottom: false,
          sliver: SliverPersistentHeader(
            delegate: SubHeader(tabs: tabs,tabController: _tabController,index: _index),
            pinned: true,
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1)),
                child: MaterialButton(
                  onPressed: () => debugPrint('$index'),
                  child: Container(
                    child: Text(
                      '$index',
                    ),
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(50),
                  ),
                ),
              );
            },
            childCount: 100,
          ),
        ),
      ],
    );
  }

  Widget _buildInput() => const TextField(
        decoration: InputDecoration.collapsed(
            hintText: 'Tìm kiếm khách hàng, phiếu điều trị',
            hintStyle: TextStyle(fontSize: 14)),
      );
}

class ItemWidget extends StatelessWidget {
  const ItemWidget({required this.title, required this.icon, this.permission});

  final String title;
  final Widget icon;
  final String? permission;

  @override
  Widget build(BuildContext context) {
    final bool isHasPermission = handlePermission(permission);

    return !isHasPermission
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16)),
                  width: 45,
                  height: 45,
                  child: const Center(child: Icon(Icons.description)),
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style:
                      const TextStyle(color: Color(0xFF303030), fontSize: 14),
                )
              ],
            ),
          );
  }
}

class MySliverPinnedPersistentHeaderDelegate
    extends SliverPinnedPersistentHeaderDelegate {
  MySliverPinnedPersistentHeaderDelegate({
    required Widget minExtentProtoType,
    required Widget maxExtentProtoType,
  }) : super(
          minExtentProtoType: minExtentProtoType,
          maxExtentProtoType: maxExtentProtoType,
        );

  @override
  Widget build(BuildContext context, double shrinkOffset, double? minExtent,
      double maxExtent, bool overlapsContent) {
    print(shrinkOffset);
    return Stack(
      children: <Widget>[
        // Positioned(
        //   child: maxExtentProtoType,
        //   top: 0,
        //   bottom: 0,
        //   left: 0,
        //   right: 0,
        // ),
        Positioned(
          child: minExtentProtoType,
          top: 0,
          left: 0,
          right: 0,
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(SliverPinnedPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}


class SubHeader extends SliverPersistentHeaderDelegate {
  SubHeader({required this.tabs,required this.tabController,required this.index});
  final List<Tab> tabs;
  final  TabController tabController;
  final int index;

  @override
  double get minExtent => 100.0;

  @override
  double get maxExtent => 100.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate _) => true;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: const Color(0xFFEDF4FF),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Lịch hẹn hôm nay',
                    style: TextStyle(
                        color: Color(0xFF303030),
                        fontSize: 17,
                        fontWeight: FontWeight.w600)),
              ),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Color(0xff1A6DE3)),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              )
            ],
          ),
          TabBar(
            isScrollable: true,
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BubbleTabIndicator(
              indicatorHeight: 32.0,
              indicatorColor:tabController.index == index ?   Color(0xff1A6DE3) : Colors.green,
              tabBarIndicatorSize: TabBarIndicatorSize.tab,
              // Other flags
              // indicatorRadius: 1,
              // insets: EdgeInsets.all(1),
              // padding: EdgeInsets.all(10)
            ),

            tabs: tabs,
            controller: tabController,
          )
        ],
      )
    );
  }
}