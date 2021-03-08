import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:facebook_api_client/facebook_api_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/app_core/ui_base/ui_vm_base.dart';
import 'package:tpos_mobile/extensions.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/config_camera/camera_controller.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/facebook_page_select_list_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/sale_online_facebook_post_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/sale_online_facebook_channel_list_viewmodel.dart';
import 'package:tpos_mobile/helpers/svg_icon.dart';
import 'package:tpos_mobile/resources/app_colors.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/page_state/page_state.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

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
  final _vm = SaleOnlineFacebookChannelListViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final dividerMin = const Divider(
    indent: 20,
    height: 2,
  );

  // Khi thực hiện liveStrea,m
  bool isLiveStream = false;

  List<CRMTeam> _crmTeamSelected = [];
  List<String> tokens = [];

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
                    onTap: () async {
                      Navigator.pop(context);
                      // _showFacebookSelectFacebookPages(crmTeam);
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FacebookPageSelectPage(
                            crmTeam: crmTeam,
                          ),
                        ),
                      );
                      if (result != null) {
                        _showAddFacebookPageChannelConfirm(result, crmTeam);
                      }
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
                  onTap: () async {
                    Navigator.pop(context);
                    final bool result = await App.showConfirm(
                        title: S.of(context).confirmDelete,
                        content: S.of(context).deleteSelectConfirmParam(
                            S.of(context).connectionChannel));

                    if (result != null && result) {
                      _vm.deleteFacebookChannelCommand.execute(crmTeam);
                    }
                  },
                ),
                dividerMin,
                Visibility(
                  visible: !isLiveStream,
                  child: ListTile(
                    leading: const Icon(
                      Icons.video_call_rounded,
                      color: Colors.red,
                    ),
                    title: const Text('Phát livestream'),
                    onTap: () async {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CameraControllerConfig(
                                  tokens: [crmTeam.facebookPageToken],
                                  crmTeams: [crmTeam],
                                )),
                      );
                    },
                  ),
                ),
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

  /// Xử lý khi nhấn và đi vào một kênh bán
  Future<void> _handleSelectFacebookPage(CRMTeam crmTeam) async {
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
    _vm.initData();
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
        body: Stack(
          children: [
            _buildBody(),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Visibility(
                visible: false,
                child: Center(
                  child: Container(
                    width: 150,
                    child: RaisedButton(
                      child: const Center(
                          child: Text('Live stream',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold))),
                      onPressed: () async {
                        runMul();
                      },
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultError() {
    return AppPageState(
      icon: SvgPicture.asset('assets/icon/error.svg'),
      title: S.of(context).loadDataError,
      message: _vm.errorMessage,
      actions: [
        AppButton(
          onPressed: () {
            _vm.initData();
          },
          padding: const EdgeInsets.only(left: 18, right: 18),
          decoration: const BoxDecoration(
            color: Colors.indigo,
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SvgIcon(
                  SvgIcon.reload,
                ),
                const SizedBox(width: 6),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3.0),
                  child: Text(
                    S.of(context).refreshPage,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return UIViewModelBase(
      errorBuilder: (context) {
        return _buildDefaultError();
      },
      viewModel: _vm,
      child: ScopedModelDescendant<SaleOnlineFacebookChannelListViewModel>(
        builder: (context, widget, model) {
          return RefreshIndicator(
            onRefresh: () async {
              await _vm.refreshCommand.execute(null);
              return true;
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: <Widget>[
                  if (model.crmTeams != null && model.crmTeams.isNotEmpty)
                    _LoginFacebook()
                  else
                    const SizedBox(),
                  const SizedBox(
                    height: 8,
                  ),
                  if (model.crmTeams != null && model.crmTeams.isNotEmpty)
                    _buildList()
                  else
                    const SizedBox(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildList() {
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
              child: Row(
                children: [
                  Expanded(child: Text(S.current.connectedChannel)),
                  Switch.adaptive(
                      value: isLiveStream,
                      onChanged: (value) {
                        setState(() {
                          isLiveStream = !isLiveStream;
                        });
                      }),
                  const Text('Live')
                ],
              ),
            ),
          ),
          Visibility(
            visible: isLiveStream,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                alignment: Alignment.centerLeft,
                width: 150,
                child: FlatButton.icon(
                  icon: const Icon(
                    Icons.live_tv,
                    size: 20,
                  ),
                  label: Text(
                    'Phát  (${_crmTeamSelected.length})',
                    // style: TextStyle(
                    //     color: Colors.white, fontWeight: FontWeight.bold)
                  ),
                  onPressed: () async {
                    if (isLiveStream) {
                      runMul();
                    }
                  },
                ),
              ),
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
          selected: isLiveStream ? crmTeam.isSelected : false,
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey.shade300,
            child: crmTeam.isImageError
                ? Text(crmTeam.name.substring(0, 1))
                : null,
            backgroundImage: NetworkImage(crmTeam.facebookTypeId == "User"
                ? (crmTeam.facebookUserAvatar ?? "")
                : (crmTeam.facebookPageLogo ?? "")),
            onBackgroundImageError: (e, s) {
              setState(() {
                crmTeam.isImageError = true;
              });
            },
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
            if (isLiveStream) {
              setState(() {
                crmTeam.isSelected = !crmTeam.isSelected;
                if (crmTeam.isSelected) {
                  _crmTeamSelected.add(crmTeam);
                  tokens.add(crmTeam.facebookPageToken);
                } else {
                  final bool isExist = _crmTeamSelected
                      .any((element) => element.id == crmTeam.id);
                  if (isExist) {
                    _crmTeamSelected.remove(crmTeam);
                    tokens.remove(crmTeam.facebookPageToken);
                  }
                }
              });
            } else {
              // Mở bài đăng nếu ở chế độ bài đăng
              if (widget.selectMode) {
                Navigator.pop(context, crmTeam);
              } else {
                _handleSelectFacebookPage(crmTeam);
              }
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

  void runMul() {
    if (_crmTeamSelected.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CameraControllerConfig(
                crmTeams: _crmTeamSelected, tokens: tokens)),
      );
    } else {
      App.showToast(context: context, message: 'Vui lòng chọn page');
    }
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
    return Container(
      width: double.infinity,
      child: Column(
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
                  textAlign: TextAlign.center,
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
      ),
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
