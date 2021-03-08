import 'package:cached_network_image/cached_network_image.dart';
import 'package:facebook_api_client/facebook_api_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/facebook_page/facebook_page_select_bloc.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/facebook_page/facebook_page_select_event.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/facebook_page/facebook_page_select_state.dart';
import 'package:tpos_mobile/helpers/svg_icon.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/page_state/page_state.dart';
import 'package:tpos_mobile/widgets/page_state/page_state_type.dart';
import 'package:tpos_mobile/widgets/search_app_bar_custom.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class FacebookPageSelectPage extends StatefulWidget {
  const FacebookPageSelectPage({Key key, this.crmTeam, this.isSearch = false})
      : super(key: key);

  @override
  _FacebookPageSelectPageState createState() => _FacebookPageSelectPageState();
  final CRMTeam crmTeam;
  final bool isSearch;
}

class _FacebookPageSelectPageState extends State<FacebookPageSelectPage> {
  final _bloc = FacebookPageSelectBloc();
  final TextEditingController _nameController = TextEditingController();
  bool _isSearch;

  @override
  void initState() {
    _isSearch = widget.isSearch;
    super.initState();
    _bloc.add(FacebookPageSelectLoaded(widget.crmTeam));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocUiProvider<FacebookPageSelectBloc>(
      bloc: _bloc,
      listen: (state) {},
      child: WillPopScope(
        onWillPop: () async {
          setState(() {
            if (_isSearch) {
              _isSearch = !_isSearch;
              _nameController.text = "";
              _bloc.add(FacebookPageSelectSearch(search: _nameController.text));
            } else {
              Navigator.of(context).pop();
            }
          });
          return false;
        },
        child: Scaffold(
          appBar: _buildAppBar(),
          body: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.indigo,
      title: BlocBuilder<FacebookPageSelectBloc, FacebookPageSelectState>(
          builder: (context, state) {
        if (state is FacebookPageSelectLoadSuccess) {
          return _isSearch
              ? SearchAppBarCustomWidget(
                  color: Colors.indigo,
                  controller: _nameController,
                  onChanged: (text) {
                    _bloc.add(FacebookPageSelectSearch(search: text));
                  },
                )
              : Text(S.of(context).selectFacebookPage);
        } else
          return Text(S.of(context).selectFacebookPage);
      }),
      actions: [
        BlocBuilder<FacebookPageSelectBloc, FacebookPageSelectState>(
            builder: (context, state) {
          if (state is FacebookPageSelectLoadSuccess) {
            return !_isSearch
                ? IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      _isSearch = !_isSearch;
                      setState(() {});
                    },
                  )
                : const SizedBox();
          } else
            return const SizedBox();
        }),
      ],
    );
  }

  Widget _buildList(FacebookPageSelectLoadSuccess state) {
    return Container(
      color: Colors.white,
      child: state.fbPages.isNotEmpty
          ? _buildItem(widget.crmTeam, state.fbPages)
          : _buildEmpty(widget.crmTeam),
    );
  }

  Widget _buildItem(CRMTeam crmTeam, List<FacebookAccount> fbPages) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            dense: true,
            leading: Stack(
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    height: 36,
                    imageUrl: crmTeam.facebookUserAvatar,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        Image.asset("images/no_image.png"),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: -1,
                  child: Image.asset("images/icon_fb.png"),
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
            contentPadding: const EdgeInsets.only(left: 0, right: 0, top: 10),
          ),
          const SizedBox(
            height: 10,
          ),
          ListView.builder(
              padding: const EdgeInsets.only(left: 45),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        dense: true,
                        leading: Stack(
                          children: [
                            ClipOval(
                              child: CachedNetworkImage(
                                height: 36,
                                imageUrl: fbPages[index].picture.url,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Image.asset("images/no_image.png"),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: -1,
                              child: Image.asset("images/icon_fb.png"),
                            ),
                          ],
                        ),
                        title: Transform.translate(
                          offset: const Offset(-10, 0),
                          child: Text(
                            fbPages[index].name,
                            style: const TextStyle(fontSize: 17),
                          ),
                        ),
                        trailing: ButtonTheme(
                          minWidth: 78.0,
                          height: 30.0,
                          child: RaisedButton(
                            padding: const EdgeInsets.only(
                                left: 16, right: 12, top: 6, bottom: 5),
                            color: Colors.indigo,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            onPressed: () {
                              Navigator.pop(context, fbPages[index]);
                            },
                            child: Text(S.of(context).choose,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: "Lato",
                                    fontWeight: FontWeight.normal)),
                          ),
                        ),
                        contentPadding:
                            const EdgeInsets.only(left: 0, right: 0, top: 10),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
              itemCount: fbPages.length)
        ],
      ),
    );
  }

  Widget _buildEmpty(CRMTeam crmTeam) {
    if (_nameController.text != "") {
      return AppPageState(
        title: S.of(context).searchNotFound,
        message: S
            .of(context)
            .searchNotFoundWithKeywordParam(_nameController.text, ""),
        icon: SvgPicture.asset('assets/icon/no-result.svg'),
      );
    } else {
      return AppPageState(
        title: S.of(context).noPageTitle,
        message: "${S.of(context).noPage} '${crmTeam.name}'.",
        icon: const SvgIcon(
          SvgIcon.emptyData,
        ),
      );
    }
  }

  Widget _buildBody() {
    return BlocLoadingScreen<FacebookPageSelectBloc>(
        busyStates: const [FacebookPageSelectLoading],
        child: BlocBuilder<FacebookPageSelectBloc, FacebookPageSelectState>(
            builder: (context, state) {
          if (state is FacebookPageSelectLoadFailure) {
            return AppPageState(
              type: PageStateType.dataError,
              icon: SvgPicture.asset('assets/icon/error.svg'),
              title: S.of(context).loadDataError,
              message: state.content,
              hint: state.hint,
              actions: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: AppButton(
                    onPressed: () {
                      _bloc.add(FacebookPageSelectLoaded(widget.crmTeam));
                    },
                    width: null,
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    decoration: const BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.refresh,
                            color: Colors.white,
                            size: 23,
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
            );
          } else if (state is FacebookPageSelectLoadSuccess) {
            return _buildList(state);
          } else {
            return const SizedBox();
          }
        }));
  }
}
