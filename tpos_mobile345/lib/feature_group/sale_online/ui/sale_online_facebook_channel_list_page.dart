import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/resources/app_colors.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/sale_online_facebook_post_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/sale_online_facebook_channel_list_viewmodel.dart';
import 'package:tpos_mobile/app_core/ui_base/ui_vm_base.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/src/facebook_apis/src/models.dart';
import 'package:tpos_mobile/src/facebook_apis/src/services.dart';
import 'package:tpos_mobile/extensions.dart';

class SaleOnlineFacebookChannelListPage extends StatefulWidget {
  const SaleOnlineFacebookChannelListPage(
      {Key key, this.selectMode = false, this.selectPostMode = false})
      : super(key: key);

  /// Ở chế độ chọn. Chọn xong sẽ back về trang cũ cùng kết quả
  final bool selectMode;

  /// Ở chế độ chọn bài viết.
  final bool selectPostMode;

  @override
  _SaleOnlineFacebookChannelListPageState createState() =>
      _SaleOnlineFacebookChannelListPageState();
}

class _SaleOnlineFacebookChannelListPageState
    extends State<SaleOnlineFacebookChannelListPage> {
  final _fbApi = locator<IFacebookApiService>();
  final _vm = SaleOnlineFacebookChannelListViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final dividerMin = const Divider(
    indent: 20,
    height: 2,
  );
  void _showFacebookChannelMenu(CRMTeam crmTeam) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                if (crmTeam.facebookTypeId == "User") ...[
                  ListTile(
                    leading: const Icon(
                      Icons.add_circle,
                      color: Colors.green,
                    ),
                    title: Text(S.current.addNewPage),
                    onTap: () {
                      Navigator.pop(context);
                      _showFacebookSelectFacebookPages(crmTeam);
                    },
                  ),
                  dividerMin
                ],
                ListTile(
                  leading: const Icon(
                    Icons.refresh,
                    color: Colors.blue,
                  ),
                  title: Text(S.current.refresh),
                  subtitle: _vm.canRefreshToken(crmTeam) == null
                      ? null
                      : Text(
                          _vm.canRefreshToken(crmTeam),
                          style: const TextStyle(
                              color: AppColors.dialogErrorColor),
                        ),
                  onTap: _vm.canRefreshToken(crmTeam) == null
                      ? () {
                          // Làm mới
                          Navigator.pop(context);
                          _vm.refreshFacebookToken(crmTeam);
                        }
                      : null,
                ),
                dividerMin,
                ListTile(
                  leading: const Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                  ),
                  title: Text(S.current.delete),
                  onTap: () {
                    Navigator.pop(context);
                    _vm.deleteFacebookChannelCommand.execute(crmTeam);
                  },
                ),
                dividerMin,
                const ListTile(),
                dividerMin,
              ],
            ),
          ); /**/
        });
  }

  void _showAddFacebookPageChannelConfirm(
      FacebookAccount page, CRMTeam crmTeam) {
    final controller = TextEditingController(text: page.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.current.confirm),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(S.current.facebookChannel_notifySaveChannel),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                  hintText: "", labelText: S.current.saveWithName),
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(S.current.cancel.toUpperCase()),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text(S.current.save.toUpperCase()),
            onPressed: () {
              Navigator.pop(context);
              if (crmTeam.childs != null &&
                  crmTeam.childs.any((f) => f.facebookPageId == page.id)) {
                context.showToast(
                    title: S.current
                        .facebookChannel_notifyChannelAlreadyExistsTitle,
                    message: S.current
                        .facebookChannel_notifyChannelAlreadyExists(page.id),
                    type: AlertDialogType.warning,
                    durationSecond: 5);
                return;
              }
              _vm.addFacebookPageChannel(
                  page: page, name: controller.text.trim(), crmTeam: crmTeam);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showFacebookSelectFacebookPages(CRMTeam crmTeam,
      {BuildContext context}) async {
    try {
      final pages = await _fbApi.getFacebookAccount(
          accessToken: crmTeam.facebookUserToken);
      if (pages == null) {
        return;
      }
      showDialog(
        context: context ?? this.context,
        builder: (context) => AlertDialog(
          title: const Text("Chọn page: "),
          content: Container(
            width: 700,
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(pages[index].pictureString ?? ""),
                    ),
                    title: Text(pages[index].name),
                    onTap: () async {
                      Navigator.pop(context);
                      _showAddFacebookPageChannelConfirm(pages[index], crmTeam);
                    },
                  );
                },
                separatorBuilder: (context, index) => const Divider(height: 2),
                itemCount: pages?.length ?? 0),
          ),
        ),
      );
    } catch (e) {
      _vm.onDialogMessageAdd(OldDialogMessage.error("", "", error: e));
    }
  }

  Future<void> _showFacebookPostPage(CRMTeam crmTeam) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SaleOnlineFacebookPostPage(
          crmTeam: crmTeam,
          selectMode: widget.selectPostMode,
        ),
      ),
    );

    if (result != null) {
      if (widget.selectPostMode) {
        Navigator.pop(context, result);
      }
    }
  }

  @override
  void initState() {
    _vm.initCommand.execute(null);

    _vm.eventController.listen((event) {
      if (event.eventName == "GO_BACK") {
        if (mounted && Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<SaleOnlineFacebookChannelListViewModel>(
      model: _vm,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text(S.current.selectFacebookSaleChannel),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return UIViewModelBase(
      viewModel: _vm,
      child: RefreshIndicator(
        onRefresh: () async {
          await _vm.refreshCommand.execute(null);
          return true;
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: <Widget>[
              _LoginFacebook(),
              const SizedBox(
                height: 8,
              ),
              _buildList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    return ScopedModelDescendant<SaleOnlineFacebookChannelListViewModel>(
      builder: (context, widget, model) {
        if (model.crmTeams != null && model.crmTeams.isNotEmpty) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(S.current.connectedChannel),
                  ),
                ),
                const Divider(
                  height: 2,
                ),
                ScopedModelDescendant<SaleOnlineFacebookChannelListViewModel>(
                  builder: (context, child, model) {
                    if (_vm.crmTeams == null) {
                      return const SizedBox();
                    }

                    if (_vm.crmTeams.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.boxOpen,
                              size: 60,
                              color: Colors.grey.shade200,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 15),
                              child: Text(
                                "Chưa có kênh bán hàng",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Text(
                                '', //TODO
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return _buildListFacebookChannel(_vm.crmTeams);
                  },
                ),
              ],
            ),
          );
        }
        return SizedBox();
      },
    );
  }

  Widget _buildListFacebookChannel(List<CRMTeam> crmTeams) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) =>
            _buildListFacebookChannelItem(crmTeams[index]),
        separatorBuilder: (context, index) => const Divider(
              height: 2,
              indent: 70,
            ),
        itemCount: crmTeams?.length ?? 0);
  }

  Widget _buildListFacebookChannelItem(CRMTeam crmTeam) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey.shade300,
            child: Text(crmTeam.name.substring(0, 1)),
            backgroundImage: NetworkImage(crmTeam.facebookTypeId == "User"
                ? (crmTeam.facebookUserAvatar ?? "")
                : (crmTeam.facebookPageLogo ?? "")),
          ),
          title: Text(crmTeam.name),
          trailing: IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {
              _showFacebookChannelMenu(crmTeam);
            },
          ),
          contentPadding: const EdgeInsets.only(left: 12, right: 0),
          onLongPress: () {
            _showFacebookChannelMenu(crmTeam);
          },
          onTap: () {
            // Mở bài đăng nếu ở chế độ bài đăng
            if (widget.selectMode) {
              Navigator.pop(context, crmTeam);
            } else {
              _showFacebookPostPage(crmTeam);
            }

            //
          },
        ),
        if (crmTeam.childs != null) ...[
          const Divider(
            indent: 70,
          ),
          ListView.separated(
              padding: const EdgeInsets.only(left: 60),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) =>
                  _buildListFacebookChannelItem(crmTeam.childs[index]),
              separatorBuilder: (context, index) => const Divider(
                    height: 2,
                    indent: 70,
                  ),
              itemCount: crmTeam.childs?.length ?? 0)
        ],
      ],
    );
  }
}

/// UI vùng đăng nhập với facebook
class _LoginFacebook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: _buildContent(),
      padding: const EdgeInsets.all(12),
    );
  }

  Widget _buildContent() {
    return ScopedModelDescendant<SaleOnlineFacebookChannelListViewModel>(
      builder: (context, widget, model) {
        if (!model.isFacebookLoggined || model.loginedFacebookUser == null) {
          return _buildNotLogin(model);
        } else {
          return _buildLoginSuccess(context);
        }
      },
    );
  }

  Widget _buildNotLogin(SaleOnlineFacebookChannelListViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              FontAwesomeIcons.facebook,
              color: Colors.blue,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                S.current.connectWithFacebook,
                style: const TextStyle(fontSize: 20),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Text(
          S.current.facebookChannel_notifyNotConnectFacebook,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15),
        ),
        const SizedBox(
          height: 20,
        ),
        RaisedButton.icon(
          onPressed: () {
            model.loginFacebook(false);
          },
          onLongPress: () {
            model.loginFacebook(true);
          },
          color: AppColors.facebookColor,
          textColor: Colors.white,
          icon: const Icon(FontAwesomeIcons.facebookF),
          label: Text(
            S.current.loginFacebook,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        // Text(
        //   'Nhấn giữ nút Đăng nhập facebook để liên kết tới ứng dụng Facebook',
        //   textAlign: TextAlign.center,
        // ),
      ],
    );
  }

  Widget _buildLoginSuccess(BuildContext context) {
    final model =
        ScopedModel.of<SaleOnlineFacebookChannelListViewModel>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundImage:
                  NetworkImage(model.loginedFacebookUser?.pictureLink ?? ''),
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              S.current.hi,
              style: const TextStyle(fontSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                model.loginedFacebookUser.name,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
        if (model.isFacebookNotInCrmteams)
          ..._buildNotInCrmTeam(context)
        else
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildLogoutButton(context),
          ),
      ],
    );
  }

  List<Widget> _buildNotInCrmTeam(BuildContext context) {
    return [
      const SizedBox(
        height: 20,
      ),
      Text(
        S.current.facebookChannel_notifyNotConnect,
        textAlign: TextAlign.center,
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildConnectButton(context),
          _buildLogoutButton(context),
        ],
      )
    ];
  }

  Widget _buildConnectButton(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        _showAddFacebookChannelConfirm(context);
      },
      child: Text(S.current.connect.toUpperCase()),
      color: AppColors.brand3,
      textColor: Colors.white,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        ScopedModel.of<SaleOnlineFacebookChannelListViewModel>(context)
            .logoutFacebook();
      },
      child: Text(S.current.logout.toUpperCase()),
      color: AppColors.facebookColor,
      textColor: Colors.white,
    );
  }

  void _showAddFacebookChannelConfirm(BuildContext context) {
    final model =
        ScopedModel.of<SaleOnlineFacebookChannelListViewModel>(context);
    final controller =
        TextEditingController(text: model.loginedFacebookUser.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.current.confirm),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(S.current.facebookChannel_notifySaveChannel),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                  hintText: "", labelText: "${S.current.saveAsName}:"),
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(S.current.cancel.toUpperCase()),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text(S.current.save.toUpperCase()),
            onPressed: () {
              Navigator.pop(context);
              model.addFacebookChannel(controller.text.trim());
            },
          ),
        ],
      ),
    );
  }
}
