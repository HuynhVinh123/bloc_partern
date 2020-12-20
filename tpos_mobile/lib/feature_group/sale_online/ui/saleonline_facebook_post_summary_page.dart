import 'package:facebook_api_client/facebook_api_client.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/saleonline_facebook_post_summary_viewmodel.dart';
import 'package:tpos_mobile/helpers/ui_help.dart';
import 'package:tpos_mobile/app_core/ui_base/ui_vm_base.dart';

import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:tpos_mobile/src/tpos_apis/models/sale_online_facebook_post_summary_user.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class SaleOnlineFacebookPostSummaryPage extends StatefulWidget {
  const SaleOnlineFacebookPostSummaryPage({
    @required this.postId,
    @required this.crmTeam,
  });
  final String postId;
  final CRMTeam crmTeam;

  @override
  _SaleOnlineFacebookPostSummaryPageState createState() =>
      _SaleOnlineFacebookPostSummaryPageState();
}

class _SaleOnlineFacebookPostSummaryPageState
    extends State<SaleOnlineFacebookPostSummaryPage> {
  final _vm = SaleOnlineFacebookPostSummaryViewModel();
  int currentTabIndex;
  bool headerVisible = true;
  double headerSize = 400;

  @override
  void initState() {
    _vm.init(
      postId: widget.postId,
      crmTeam: widget.crmTeam,
    );
    _vm.initCommand();
    _vm.dialogMessageController.listen(
      (message) {
        registerDialogToView(context, message);
      },
    );
    super.initState();
  }

  final GlobalKey _headerPhoneKey = GlobalKey();

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<SaleOnlineFacebookPostSummaryViewModel>(
      model: _vm,
      child: Scaffold(
        body: UIViewModelBase(
          backgroundColor: Colors.indigo.shade200,
          viewModel: _vm,
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildPhoneDetailList() {
    return ListView.separated(
        itemBuilder: (context, index) {
          return DetailItem(_vm.summary?.users[index], index,
              _vm.getPartner(_vm.summary?.users[index].id.toString()));
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
        itemCount: _vm.summary?.users?.length ?? 0);
  }

  Widget _buildPhoneNewCustomerList() {
    return ListView.separated(
        itemBuilder: (context, index) {
          return NewCustomerItem(
              index, _vm.summary?.availableInsertPartners[index]);
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
        itemCount: _vm.summary?.availableInsertPartners?.length ?? 0);
  }

  final ScrollController _phoneScrollController = ScrollController();
  Widget _buildPhoneLayout() {
    const headerTextStyle = TextStyle(color: Colors.white, fontSize: 18);

    return ScopedModelDescendant<SaleOnlineFacebookPostSummaryViewModel>(
      builder: (context, child, model) {
        return DefaultTabController(
          length: 2,
          child: NestedScrollView(
            controller: _phoneScrollController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  backgroundColor: Colors.indigo,
                  pinned: true,
                  expandedHeight: 200,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      _vm.summary?.post?.source ?? S.current.post,
                      style: headerTextStyle.copyWith(
                          fontSize: 14, color: Colors.indigo.shade200),
                    ),
                    background: Container(
                      key: _headerPhoneKey,
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(top: 50),
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
//                                  Text(
//                                    "${_vm.summary?.post?.story}",
//                                    style: headerTextStyle.copyWith(
//                                        color: Colors.red),
//                                  ),
                                  Text(
                                    _vm.summary?.post?.message,
                                    style: headerTextStyle,
                                  ),
                                  if (_vm.summary?.post?.createdTime != null)
                                    Text(
                                      "${S.current.dateCreated}: ${DateFormat("dd/MM/yyyy  HH:mm").format(_vm.summary?.post?.createdTime?.toLocal())}",
                                      style: headerTextStyle.copyWith(
                                          color: Colors.lightBlueAccent),
                                    ),
                                ],
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                //Bình luận
                                child: BlockItem(
                                  header: S.current.comment,
                                  backgroundColor: Colors.indigo.shade100,
                                  value: "${_vm.summary?.countComment ?? "0"}",
                                ),
                              ),
                              //Người bình luận
                              Expanded(
                                child: BlockItem(
                                  header: S.current.commentator,
                                  backgroundColor: Colors.indigo.shade100,
                                  value:
                                      "${_vm.summary?.countUserComment ?? 0}",
                                ),
                              )
                            ],
                          ),
                          //"Chia sẻ"
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: BlockItem(
                                  header: S.current.share,
                                  backgroundColor: Colors.indigo.shade100,
                                  value: "${_vm.summary?.countShare}",
                                ),
                              ),
                              //ố người chia sẻ
                              Expanded(
                                child: BlockItem(
                                  header: S.current.numberOfShare,
                                  backgroundColor: Colors.indigo.shade100,
                                  value: "${_vm.summary?.countUserShare ?? 0}",
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: BlockItem(
                                  header: S.current.order,
                                  backgroundColor: Colors.indigo.shade100,
                                  value: "${_vm.summary?.countOrder ?? 0}",
                                ),
                              ),
                              // Khách hàng mới
                              Expanded(
                                child: BlockItem(
                                  header: S.current.newCustomer,
                                  backgroundColor: Colors.indigo.shade100,
                                  value:
                                      "${_vm.summary?.availableInsertPartners?.length ?? 0}",
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      color: Colors.indigo,
                      padding: const EdgeInsets.only(bottom: 5),
                    ),
                  ]),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      indicatorColor: Colors.indigo,
                      labelColor: Colors.indigo,
                      tabs: [
                        // /Chi tiết
                        Tab(
                          text:
                              "${S.current.detail} (${_vm.summary?.users?.length ?? 0})",
                        ),
                        Tab(
                          text:
                              "${S.current.newCustomer} (${_vm.summary?.availableInsertPartners?.length ?? 0})",
                        )
                      ],
                      onTap: (index) {
                        setState(() {
                          currentTabIndex = index;
                        });
                      },
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                _buildPhoneDetailList(),
                _buildPhoneNewCustomerList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabletHeader() {
    const headerTextStyle = TextStyle(color: Colors.white, fontSize: 16);
    return ScopedModelDescendant<SaleOnlineFacebookPostSummaryViewModel>(
      builder: (context, child, vm) {
        return Container(
          height: 100,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(_vm.summary?.post?.picture ?? ""),
              ),
              Container(
                width: 350,
                child: Column(
                  children: <Widget>[
                    Text(
                      _vm.summary?.post?.story ?? "",
                      style: headerTextStyle.copyWith(color: Colors.red),
                    ),
                    Text(
                      _vm.summary?.post?.message ?? "",
                      style: headerTextStyle,
                    ),
                    if (_vm.summary?.post?.createdTime != null)
                      // /Ngày tạo
                      Text(
                        "${S.current.dateCreated}: ${DateFormat("dd/MM/yyyy  HH:mm").format(_vm.summary?.post?.createdTime?.toLocal())}",
                        style: headerTextStyle,
                      ),
                  ],
                ),
              ),
              Expanded(
                // /Bình luận
                child: BlockItem(
                  header: S.current.comment,
                  value: "${_vm.summary?.countComment}",
                ),
              ),
              //Người bình luận
              Expanded(
                child: BlockItem(
                  header: S.current.commentator,
                  value: "${_vm.summary?.countUserComment ?? 0}",
                ),
              ),
              //Chia sẻ
              Expanded(
                child: BlockItem(
                  header: S.current.share,
                  value: "${_vm.summary?.countShare ?? 0}",
                ),
              ),
              //Số người chia sẻ
              Expanded(
                child: BlockItem(
                  header: S.current.numberOfShare,
                  value: "${_vm.summary?.countUserShare ?? 0}",
                ),
              ),
              // Đơn hàng
              Expanded(
                child: BlockItem(
                  header: S.current.order,
                  value: "${_vm.summary?.countOrder ?? 0}",
                ),
              ),
              Expanded(
                //"Khách hàng mới"
                child: BlockItem(
                  header: S.current.newCustomer,
                  value: "${_vm.summary?.availableInsertPartners?.length ?? 0}",
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static const double sttWidth = 50;
  //static const double avataWidth = 50;
  static const double nameWidth = 200;
  //static const double commentWidth = 50;
  //static const double shareWidth = 50;
  // static const double invoiceWidth = 50;
  Widget _buildTabletDetailList() {
    return SingleChildScrollView(
      child: DataTable(horizontalMargin: 30, columnSpacing: 0, columns: [
        DataColumn(
          numeric: false,
          label: Container(
            child: const SizedBox(
              child: Text("STT"),
              width: sttWidth,
            ),
          ),
        ),
        const DataColumn(
          label: Text("Avata"),
        ),
        DataColumn(
          label: Container(width: nameWidth, child: const Text("Name")),
        ),
        const DataColumn(
          label: Text("Comment"),
        ),
        const DataColumn(
          label: Text("Share"),
        ),
        DataColumn(
          label: Text(S.current.order),
        ),
      ], rows: [
        for (int i = 0; i < (_vm.summary?.users?.length ?? 0); i++)
          DataRow(cells: [
            DataCell(Container(width: sttWidth, child: Text("${i + 1}")),
                placeholder: false),
            DataCell(Image.network(_vm.summary.users[i].picture)),
            DataCell(
              Builder(
                builder: (context) {
                  final partner = _vm.partners[_vm.summary.users[i].id];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _vm.summary?.users[i].name ?? '',
                        style: const TextStyle(
                            color: Colors.indigo, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: <Widget>[
                          if (partner?.hasPhone ?? false)
                            InkWell(
                              child: const Padding(
                                padding:
                                    // ignore: prefer_const_constructors
                                    EdgeInsets.only(left: 8, right: 8),
                                child: Icon(Icons.phone),
                              ),
                              onTap: () {
                                // laucher call
                                urlLauch("tel:${partner.phone}");
                              },
                            ),
                          if (partner?.hasAddress ?? false)
                            const InkWell(
                              child: Padding(
                                padding: EdgeInsets.only(left: 8, right: 8),
                                child: Icon(Icons.perm_contact_calendar),
                              ),
                            ),
                          Text(partner?.code ?? "")
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            DataCell(Text(
              "${_vm.summary?.users[i].countComment}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            )),
            DataCell(Text(
              "${_vm.summary?.users[i].countShare}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            )),
            DataCell(_vm.summary?.users[i].hasOrder
                ? const Icon(Icons.check)
                : const SizedBox()),
          ])
      ]),
    );
  }

  /// Tablet horizon layout
  Widget _buildTabletLayout() {
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.indigo,
              pinned: true,
              expandedHeight: 250,
              flexibleSpace: FlexibleSpaceBar(
                // "Bài đăng
                title: Text(
                  _vm.summary?.post?.story ?? S.current.post,
                  style: TextStyle(fontSize: 15, color: Colors.indigo.shade100),
                ),
                collapseMode: CollapseMode.pin,
                background: Padding(
                  padding: const EdgeInsets.only(top: 100, bottom: 50),
                  child: _buildTabletHeader(),
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  indicatorColor: Colors.indigo,
                  labelColor: Colors.indigo,
                  tabs: [
                    // Chi tiết
                    Tab(
                      text:
                          "${S.current.detail} (${_vm.summary?.users?.length ?? 0})",
                    ),
                    //Khách hàng mới
                    Tab(
                      text:
                          "${S.current.newCustomer} (${_vm.summary?.availableInsertPartners?.length ?? 0})",
                    )
                  ],
                  onTap: (index) {
                    setState(() {
                      currentTabIndex = index;
                    });
                  },
                ),
              ),
            ),
          ];
        },
        body: ScopedModelDescendant<SaleOnlineFacebookPostSummaryViewModel>(
          builder: (context, child, vm) => TabBarView(
            children: [
              _buildTabletDetailList(),
              _buildPhoneNewCustomerList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return LayoutBuilder(
      builder: (context, contraints) {
        if (contraints.maxWidth < 1000) {
          return _buildPhoneLayout();
        } else {
          return _buildTabletLayout();
        }
      },
    );
  }
}

class HeaderItem extends StatelessWidget {
  const HeaderItem({this.vm});
  static const headerTextStyle = TextStyle(color: Colors.white, fontSize: 15);
  final SaleOnlineFacebookPostSummaryViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: <Widget>[
//        Container(
//          color: Colors.indigo.shade400,
//          child: Image.network(
//            vm.summary?.post?.picture ?? "",
//            fit: BoxFit.fitHeight,
//          ),
//        ),
        Container(
          margin: const EdgeInsets.only(top: 50),
          padding: const EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
//              Text(
//                "${vm.summary?.post?.story}",
//                style: headerTextStyle.copyWith(color: Colors.red),
//              ),
              Text(
                vm.summary?.post?.message ?? '',
                style: headerTextStyle,
              ),
              if (vm.summary?.post?.createdTime != null)
                //"Ngày tạo
                Text(
                  "${S.current.dateCreated}: ${DateFormat("dd/MM/yyyy  HH:mm").format(vm.summary?.post?.createdTime?.toLocal())}",
                  style: headerTextStyle,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class BlockItem extends StatelessWidget {
  BlockItem({this.header, this.value, this.backgroundColor = Colors.white});
  final String header;
  final String value;
  final Color backgroundColor;

  final BoxDecoration decorate = BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.grey.shade400),
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      decoration: decorate.copyWith(color: backgroundColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(header),
          Text(
            value,
            style: const TextStyle(color: Colors.blue, fontSize: 25),
          ),
        ],
      ),
    );
  }
}

class DetailItem extends StatelessWidget {
  const DetailItem(this.user, this.index, this.partner);
  final Users user;
  final GetFacebookPartnerResult partner;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(
        left: 5,
        right: 5,
      ),
      leading: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("# ${index + 1}"),
        ),
        Image.network(user.picture ?? ""),
      ]),
      title: Wrap(
        children: <Widget>[
          Text(
            user.name ?? '',
            style: const TextStyle(color: Colors.blue),
          ),
          if (partner?.hasPhone ?? false)
            InkWell(
              child: const Padding(
                // ignore: prefer_const_constructors
                padding: EdgeInsets.only(left: 10),
                child: Icon(Icons.phone),
              ),
              onTap: () {
                urlLauch("tel:${partner.phone}");
              },
            ),
          if (partner?.hasAddress ?? false)
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Icon(Icons.perm_contact_calendar),
            ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              partner?.code ?? "",
              style: TextStyle(color: Colors.indigo.shade400),
            ),
          ),
        ],
      ),
      subtitle: Row(
        children: <Widget>[
          const Icon(
            Icons.share,
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("${user.countShare}"),
          ),
          const Icon(
            Icons.comment,
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("${user.countComment}"),
          ),
          Padding(
            child: Text(user.hasOrder ? S.current.facebook_OrdersUpdated : ""),
          ),
        ],
      ),
    );
  }
}

class NewCustomerItem extends StatelessWidget {
  const NewCustomerItem(this.index, this.partner);
  final AvailableInsertPartners partner;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("# ${index + 1}"),
        ),
        Image.network(partner.facebookAvatar ?? ""),
      ]),
      title: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              "${partner.name} (${partner.facebookUserId ?? "N/A"})",
              style: const TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      subtitle: Row(children: <Widget>[
        Text(partner.phone ?? ''),
        if (partner.phoneExisted ?? false)
          const Icon(
            Icons.check,
            color: Colors.red,
          )
      ]),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.indigo.shade50,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class MyPopupMenuItemContent extends StatelessWidget {
  const MyPopupMenuItemContent({this.icon, this.title, this.onTap});
  final Widget icon;
  final String title;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        icon,
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              title,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        )
      ],
    );
  }
}
