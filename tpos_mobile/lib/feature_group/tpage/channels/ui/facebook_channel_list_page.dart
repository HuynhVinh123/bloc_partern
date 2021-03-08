import 'package:cached_network_image/cached_network_image.dart';
import 'package:facebook_api_client/facebook_api_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tmt_flutter_ui/tmt_flutter_ui.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/empty_data_page.dart';
import 'package:tpos_mobile/feature_group/tpage/channels/bloc/facebook_channel_bloc.dart';
import 'package:tpos_mobile/feature_group/tpage/channels/bloc/facebook_channel_event.dart';
import 'package:tpos_mobile/feature_group/tpage/channels/bloc/facebook_channel_state.dart';
import 'package:tpos_mobile/helpers/svg_icon.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/loading_indicator.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class FacebookChannelListPage extends StatefulWidget {
  @override
  _FacebookChannelListPageState createState() =>
      _FacebookChannelListPageState();
}

class _FacebookChannelListPageState extends State<FacebookChannelListPage> {
  final _bloc = FacebookChannelBloc();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _bloc.add(FbChannelLoaded());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).connectionChannel),
/*          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => null,
                      ));
                })
          ],*/
        ),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: [
        BlocConsumer<FacebookChannelBloc, FbChannelState>(
            buildWhen: (last, current) =>
                current is FbChannelLoadSuccess ||
                current is FbChannelLoadFailure,
            listener: (context, state) {
              if (state is FbChannelConnectFailure) {
                App.showToast(
                    durationSecond: 2,
                    type: AlertDialogType.error,
                    title: state.title,
                    message: state.content);
              } else if (state is FbChannelConnectSuccess) {
                App.showToast(
                    durationSecond: 2,
                    type: AlertDialogType.success,
                    title: S.current.success,
                    message: state.content);
              } else if (state is FbChannelDisconnectSuccess) {
                App.showToast(
                    durationSecond: 2,
                    type: AlertDialogType.success,
                    title: S.current.success,
                    message: state.content);
              } else if (state is FbChannelRefreshTokenSuccess) {
                App.showToast(
                    durationSecond: 2,
                    type: AlertDialogType.success,
                    title: S.current.success,
                    message: state.content);
              } else if (state is FbChannelActionFailure) {
                App.showDefaultDialog(
                    title: state.title, content: state.content);
              }
            },
            builder: (context, state) {
              if (state is FbChannelLoading) {
                return LoadingIndicator();
              } else if (state is FbChannelLoadFailure)
                return _buildError(context, state);
              else if (state is FbChannelLoadSuccess)
                return _buildList(state);
              else
                return const SizedBox();
            }),
        BlocBuilder<FacebookChannelBloc, FbChannelState>(
          builder: (context, state) {
            if (state is FbChannelEditLoading)
              return LoadingIndicator();
            else
              return const SizedBox();
          },
        ),
      ],
    );
  }

  Widget _buildError(BuildContext context, state) {
    return Center(
      child: SingleChildScrollView(
        child: PageState(
          icon: SvgPicture.asset('assets/icon/error.svg'),
          title: Text(S.of(context).loadDataError),
          description: Text(state.content),
          actions: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: AppButton(
                onPressed: () {
                  _bloc.add(FbChannelLoaded());
                },
                padding: const EdgeInsets.only(left: 20, right: 20),
                decoration: const BoxDecoration(
                  color: Color(0xFF28A745),
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SvgIcon(
                        SvgIcon.reload,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        S.of(context).refreshPage,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomMenu(CRMTeam crmTeam) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.only(top: 10.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                  leading: const Icon(
                    Icons.visibility_outlined,
                    color: Colors.green,
                  ),
                  title: Text("Ẩn/hiện"),
                  onTap: () async {},
                ),
                if (crmTeam.facebookPageId != null) ...[
                  ListTile(
                    leading: const Icon(
                      Icons.refresh,
                      color: Colors.green,
                    ),
                    title: Text("Cập nhật token"),
                    onTap: () async {
                      Navigator.pop(context);
                      _bloc.add(FbChannelTokenRefreshed(
                        crmTeam: crmTeam,
                      ));
                    },
                  ),
                ],
                ListTile(
                  leading: const Icon(
                    Icons.delete_forever_outlined,
                    color: Colors.red,
                  ),
                  title: Text(S.current.delete),
                  onTap: () async {
                    Navigator.pop(context);
                    final bool result = await App.showConfirm(
                        title: S.of(context).confirmDelete,
                        content: S.of(context).deleteSelectConfirmParam(
                            S.of(context).connectionChannel.toLowerCase()));

                    if (result != null && result) {
                      _bloc.add(FbChannelDisconnected(
                        crmTeam: crmTeam,
                      ));
                    }
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ); /**/
        });
  }

  Widget _buildLoginFacebook(state) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 10),
      margin: const EdgeInsets.only(bottom: 9),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Align(
            child: Padding(
              padding: EdgeInsets.only(top: 3.0),
              child: Icon(
                Icons.close,
                color: Color(0xFFA7B2BF),
              ),
            ),
            alignment: Alignment(1.02, 0),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                FontAwesomeIcons.facebook,
                size: 27,
                color: Color(0xFF1877F2),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 0),
                child: Text(
                  S.of(context).connectWithFacebook,
                  style: const TextStyle(
                      fontSize: 17,
                      fontFamily: "Lato",
                      fontWeight: FontWeight.normal),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            S.of(context).connectFacebookWithTpage,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: Color(0xFF929DAA)),
          ),
          const SizedBox(
            height: 15,
          ),
          IgnorePointer(
            ignoring: !state.isFinished,
            child: RaisedButton.icon(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              color: const Color(0xFF4064AD),
              onPressed: () {
                _bloc.add(FbChannelAccountLogged());
              },
              textColor: Colors.white,
              icon: const Icon(
                FontAwesomeIcons.facebookF,
                size: 18,
              ),
              label: Text(
                S.of(context).connectWithFacebook,
                style: const TextStyle(
                    fontSize: 16,
                    fontFamily: "Lato",
                    fontWeight: FontWeight.normal),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginSuccess(FbChannelLoadSuccess state, BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 10),
      margin: const EdgeInsets.only(top: 9, bottom: 9),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          ClipOval(
            child: CachedNetworkImage(
              height: 36,
              imageUrl: state.facebookUser?.pictureLink ?? "",
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
                  Image.asset("images/no_image.png"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              state.facebookUser?.name ?? "",
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Text(
            S.current.connectFacebookWithTpage,
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!state.isFacebookUserConnected)
                IgnorePointer(
                  ignoring: !state.isFinished,
                  child: ButtonTheme(
                    minWidth: 78.0,
                    height: 30.0,
                    child: RaisedButton(
                      padding: const EdgeInsets.only(
                          left: 16, right: 12, top: 6, bottom: 5),
                      color: const Color(0xFF28A745),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      onPressed: () {
                        _buildConnectPage(
                            facebookUser: state.facebookUser, state: state);
                      },
                      child: Text(S.of(context).connect,
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: "Lato",
                              fontWeight: FontWeight.normal)),
                    ),
                  ),
                ),
              const SizedBox(width: 5),
              IgnorePointer(
                ignoring: !state.isFinished,
                child: ButtonTheme(
                  minWidth: 78.0,
                  height: 30.0,
                  child: RaisedButton(
                    padding: const EdgeInsets.only(
                        left: 16, right: 12, top: 6, bottom: 5),
                    color: const Color(0xFFE55A58),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    onPressed: () {
                      _bloc.add(FbChannelAccountLogout());
                    },
                    child: Text(S.of(context).logout,
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: "Lato",
                            fontWeight: FontWeight.normal)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildList(FbChannelLoadSuccess state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (state.token != null)
            _buildLoginSuccess(state, context)
          else
            _buildLoginFacebook(state),
          if (state.crmTeams.isEmpty)
            EmptyDataPage()
          else
            Container(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 16, bottom: 16),
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      S.of(context).connectedAccount,
                      style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF929DAA),
                          fontFamily: "Lato",
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        return _buildListItem(state.crmTeams[index], state);
                      },
                      itemCount: state.crmTeams.length),
                ],
              ),
            )
        ],
      ),
    );
  }

  Widget _buildListItem(CRMTeam crmTeam, state) {
    return crmTeam.facebookUserToken != null
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                dense: true,
                leading: Stack(
                  children: [
                    ClipOval(
                      child: CachedNetworkImage(
                        height: 36,
                        imageUrl: crmTeam.facebookUserAvatar ?? "",
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            Image.asset("images/no_image.png"),
                      ),
                    ),
                    const Positioned(
                      right: 0,
                      bottom: -1,
                      child: SvgIcon(
                        SvgIcon.facebook,
                      ),
                    ),
                  ],
                ),
                title: Transform.translate(
                  offset: const Offset(-10, 0),
                  child: Text(
                    crmTeam.name,
                    style: const TextStyle(fontSize: 17),
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: !state.isFinished
                      ? null
                      : () {
                          _showBottomMenu(crmTeam);
                        },
                ),
                contentPadding:
                    const EdgeInsets.only(left: 0, right: 0, top: 10),
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  ListView.builder(
                      padding: const EdgeInsets.only(left: 45),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => _buildListChannelItem(
                          crmTeam: crmTeam.childs[index], state: state),
                      itemCount: crmTeam?.childs?.length ?? 0),
                  BlocBuilder<FacebookChannelBloc, FbChannelState>(
                    builder: (context, state) {
                      if (state is FbChannelLoading)
                        return const Center(
                          child: SpinKitCircle(
                            color: Colors.green,
                            size: 25,
                          ),
                        );
                      else
                        return const SizedBox();
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    height: 1,
                  ),
                ],
              )
            ],
          )
        : const SizedBox();
  }

  Widget _buildListChannelItem({CRMTeam crmTeam, state}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: ClipOval(
              child: CachedNetworkImage(
                height: 36,
                imageUrl: crmTeam.facebookPageLogo,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    Image.asset("images/no_image.png"),
              ),
            ),
            title: Transform.translate(
              offset: const Offset(-10, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    crmTeam.name,
                    style: const TextStyle(fontSize: 17),
                  ),
                  Row(
                    children: [
                      if (crmTeam.active) ...[
                        const Icon(
                          Icons.check_circle,
                          size: 14,
                          color: Colors.green,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            S.of(context).connected,
                            style: const TextStyle(
                                fontSize: 13, color: Color(0xFF929DAA)),
                          ),
                        ),
                      ] else ...[
                        SvgPicture.asset(
                          'assets/icon/disconnect.svg',
                          width: 12,
                          height: 12,
                          color: const Color(0xFF929DAA),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            S.of(context).deliveryPartner_noConnected,
                            style: const TextStyle(
                                fontSize: 13, color: Color(0xFF929DAA)),
                          ),
                        ),
                      ]
                    ],
                  )
                ],
              ),
            ),
            trailing: crmTeam.active
                ? IconButton(
                    icon: const Icon(Icons.more_horiz),
                    onPressed: !state.isFinished
                        ? null
                        : () {
                            _showBottomMenu(crmTeam);
                          },
                  )
                : ButtonTheme(
                    minWidth: 78.0,
                    height: 30.0,
                    child: RaisedButton(
                      padding: const EdgeInsets.only(
                          left: 16, right: 12, top: 6, bottom: 5),
                      color: const Color(0xFF28A745),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      onPressed: !state.isFinished
                          ? null
                          : () {
                              _buildConnectPage(crmTeam: crmTeam);
                            },
                      child: Text(S.of(context).connect,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: "Lato",
                              fontWeight: FontWeight.normal)),
                    ),
                  ),
            contentPadding: const EdgeInsets.only(left: 0, right: 0),
          ),
        ],
      ),
    );
  }

  void _buildConnectPage(
      {CRMTeam crmTeam,
      FacebookUser facebookUser,
      FbChannelLoadSuccess state}) {
    final fbTextController = TextEditingController(
        text:
            crmTeam?.parentName ?? crmTeam?.parent?.name ?? facebookUser?.name);
    final pageTextController = TextEditingController(text: crmTeam?.name ?? "");
    final nameTextController =
        TextEditingController(text: crmTeam?.name ?? facebookUser?.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).addNewPage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              enabled: false,
              controller: fbTextController,
              decoration:
                  const InputDecoration(hintText: "", labelText: "Facebook"),
            ),
            if (crmTeam != null)
              TextFormField(
                enabled: false,
                controller: pageTextController,
                decoration:
                    const InputDecoration(hintText: "", labelText: "Page"),
              ),
            TextFormField(
              controller: nameTextController,
              decoration: const InputDecoration(hintText: "", labelText: "Tên"),
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            color: Colors.grey.shade100,
            child: Text(
              S.current.cancel.toUpperCase(),
              style: const TextStyle(color: Colors.grey),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          FlatButton(
            padding: const EdgeInsets.only(left: 20, right: 20),
            color: Colors.green,
            child: Text(S.current.save.toUpperCase()),
            onPressed: () {
              CRMTeam newCRMTeam;
              if (nameTextController.text != null &&
                  nameTextController.text != "") {}
              if (crmTeam != null)
                newCRMTeam = CRMTeam(
                  name: nameTextController.text.trim(),
                  facebookASUserId: crmTeam.facebookASUserId,
                  facebookLink: crmTeam.facebookLink,
                  facebookPageId: crmTeam.facebookPageId,
                  facebookPageLogo: crmTeam.facebookPageLogo,
                  facebookPageName: crmTeam.facebookPageName,
                  facebookPageToken: crmTeam.facebookPageToken,
                  facebookTypeId: crmTeam.facebookTypeId,
                  id: 0,
                  parentId: crmTeam.parentId,
                  type: crmTeam.type,
                );
              else
                newCRMTeam = CRMTeam(
                  id: null,
                  name: nameTextController.text.trim(),
                  active: true,
                  type: "Facebook",
                  facebookTypeId: "User",
                  facebookUserAvatar: facebookUser.pictureLink,
                  facebookUserToken: state.token,
                  facebookASUserId: facebookUser.id,
                );
              Navigator.pop(context);
              _bloc.add(FbChannelConnected(
                crmTeam: newCRMTeam,
              ));
            },
          ),
        ],
      ),
    );
  }
}
