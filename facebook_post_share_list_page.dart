import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/app_core/ui_base/ui_vm_base.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/facebook_post_share_list_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tpos_mobile/helpers/helpers.dart';

import '../../../generated/l10n.dart';
import 'facebook_post_share_detail_page.dart';

class FacebookPostShareListPage extends StatefulWidget {
  const FacebookPostShareListPage(
      {@required this.pageId,
      @required this.postId,
      this.autoClose = false,
      @required this.crmTeam});

  final String pageId;
  final String postId;
  final bool autoClose;
  final CRMTeam crmTeam;

  @override
  _FacebookPostShareListPageState createState() =>
      _FacebookPostShareListPageState();
}

class _FacebookPostShareListPageState extends State<FacebookPostShareListPage> {
  final _vm = FacebookPostShareListViewModel();
  final GlobalKey<ScaffoldState> _scafffoldKey = GlobalKey<ScaffoldState>();

  double _tranform = 0;

  @override
  void initState() {
    _vm.init(
        postId: widget.postId,
        pageId: widget.pageId,
        crmTeam: widget.crmTeam,
        isAutoClose: widget.autoClose);
    _vm.initCommand.execute(null);
    _vm.dialogMessageController.listen((mesage) {
      registerDialogToView(context, mesage,
          scaffState: _scafffoldKey.currentState);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return UIViewModelBase(
      viewModel: _vm,
      child: ScopedModel<FacebookPostShareListViewModel>(
        model: _vm,
        child: Scaffold(
          backgroundColor: Colors.white,
          key: _scafffoldKey,
          appBar: AppBar(
            title: Text(S.current.fbPostShare_NumberOfShare),
            actions: <Widget>[
              FlatButton.icon(
                textColor: Colors.white,
                label: Text(S.current.fbPostShare_Reverse),
                icon: Icon(Icons.rotate_right),
                onPressed: () {
                  if (_tranform == pi) {
                    setState(() {
                      _tranform = 0;
                    });
                  } else {
                    setState(() {
                      _tranform = pi;
                    });
                  }
                },
              )
            ],
          ),
          body: Column(children: <Widget>[
            Expanded(
              child: _buildBody(),
            ),
            if (widget.autoClose)
              Container(
                width: double.infinity,
                height: 40,
                child: RaisedButton(
                  textColor: Colors.white,
                  child: Text(S.current.fbPostShare_CloseContinue),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              )
          ]),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (App.isTablet) {
      return _buildBodyPhone();
    } else {
      return _buildBodyPhone();
    }
  }

  Widget _buildBodyPhone() {
    return Transform(
      transform: Matrix4.rotationY(_tranform),
      alignment: Alignment.center,
      child: ScopedModelDescendant<FacebookPostShareListViewModel>(
        builder: (context, child, model) {
          return Column(
            children: <Widget>[
              if (_vm.shareCount != 0)
                Container(
                  height: 90,
                  color: const Color(0xFFF8F9FB),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        child: _itemShare(
                            S.current.fbPostShare_NumberOfSharingPeople,
                            _vm.userCount.toString(),
                            const Color(0xFF6B7280)),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Flexible(
                        // flex: null,
                        child: _itemShare(S.current.fbPostShare_SharePersonally,
                            _vm.postCount.toString(), const Color(0xFFF25D27)),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Flexible(
                        child: _itemShare(S.current.fbPostShare_ShareToGroup,
                            _vm.groupCount.toString(), const Color(0xFF2395FF)),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      _itemShare(
                          S.current.fbPostShare_Total,
                          (_vm.postCount + _vm.groupCount).toString(),
                          const Color(0xFF28A745)),
                    ],
                  ),
                ),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    Align(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 135),
                        child: Text(
                          "TPOS.VN",
                          style: TextStyle(
                              fontSize: 35,
                              color: Colors.green.shade100,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      alignment: Alignment.topCenter,
                    ),
                    RefreshIndicator(
                        onRefresh: () async {
                          model.refreshCommand.execute(null);
                          return true;
                        },
                        child: _vm.shareCount == 0 && _vm.isBusy == false
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Icon(
                                        FontAwesomeIcons.solidShareSquare,
                                        color: Colors.grey.shade200,
                                        size: 62,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        S.current.fbPostShare_NotFoundShare,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.orangeAccent),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      RaisedButton(
                                        textColor: Colors.white,
                                        child:
                                            Text(S.current.fbPostShare_Reload),
                                        onPressed: () {
                                          _vm.refreshCommand.execute(null);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.all(10),
                                physics: const AlwaysScrollableScrollPhysics(),
                                separatorBuilder: (context, index) =>
                                    const Divider(
                                  height: 2,
                                ),
                                itemCount:
                                    model.facebookShareCounts?.length ?? 0,
                                itemBuilder: (context, index) =>
                                    _buildPhoneListItem(
                                        model.facebookShareCounts[index],
                                        index),
                              )),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _itemShare(String title, String content, Color color) {
    return Column(
      children: <Widget>[
//                            Text(
//                              "${_vm.userCount} người đã chia sẻ ${_vm.shareCount} lần",
//                              textAlign: TextAlign.center,
//                              style: TextStyle(
//                                color: Colors.indigo,
//                              ),
//                            ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Color(0xFF6B7280), fontSize: 15),maxLines: 2,
        ),
        // ignore: prefer_const_literals_to_create_immutables
        Flexible(
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                content,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: 18),
              )),
        ),
      ],
    );
  }

  Widget _buildPhoneListItem(FacebookShareCount item, int index) {
    return ListTile(
      leading: InkWell(
        child: Container(
          width: 50,
          height: 50,
          child: Stack(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image:
                        DecorationImage(image: NetworkImage(item.avatarLink))),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: const Color(0xFF7AC461),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white)),
                    child: Center(
                        child: Text(
                      "${index + 1}",
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    ))),
              )
            ],
          ),
        ),
        onTap: () async {
          final String url = "fb://profile/${item.facebookUid}";
          if (await canLaunch(url)) {
            await launch(url);
          } else {}
        },
      ),
      title: Text(item.name ?? ""),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            item.countGroup.toString(),
            style: const TextStyle(
                color: Color(0xFFF25D27), fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            width: 28,
          ),
          Text(
            item.count.toString(),
            style: const TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 28),
          Text(
            (item.countGroup + item.count).toString(),
            style: const TextStyle(
                color: Color(0xFF28A745), fontWeight: FontWeight.bold),
          ),
        ],
      ),
      subtitle: Text(item.facebookUid ?? ""),
      contentPadding: const EdgeInsets.only(
        left: 0,
        right: 16,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => FacebookPostShareDetailPage(item),
          ),
        );
      },
    );
  }
}
