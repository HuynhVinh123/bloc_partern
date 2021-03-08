/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/app_core/ui_base/app_bar_button.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/live_campaign/live_campaign_bloc.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/live_campaign/live_campaign_event.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/live_campaign/live_campaign_state.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/sale_online_add_edit_live_campaign_page.dart';
import 'package:tpos_mobile/helpers/svg_icon.dart';
import 'package:tpos_mobile/resources/app_colors.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';
import 'package:tpos_mobile/widgets/button/action_button.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/page_state/page_state.dart';
import 'package:tpos_mobile/widgets/page_state/page_state_type.dart';
import 'package:tpos_mobile/widgets/search_app_bar_custom.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class SaleOnlineLiveCampaignManagementPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<SaleOnlineLiveCampaignManagementPage> {
  final LiveCampaignBloc _bloc = LiveCampaignBloc();

  final TextEditingController _searchController = TextEditingController();
  Key refreshIndicatorKey = const Key("refreshIndicator");
  final FocusNode _focusSearch = FocusNode();
  bool _isOnlyShowAvailableCampaign = true;
  final BehaviorSubject<String> _searchBehaviorSubject = BehaviorSubject();
  bool isSearch = false;
  bool permissionAdd = true;
  bool permissionEdit = true;
  int skip = 0;
  int top = 20;

  @override
  void dispose() {
    super.dispose();
    _searchBehaviorSubject.close();
  }

  @override
  void initState() {
    super.initState();
    _bloc.add(LiveCampaignLoaded(
        isActive: _isOnlyShowAvailableCampaign,
        skip: 0,
        top: top,
        keyWord: _searchController.text));
    _searchBehaviorSubject
        .debounceTime(const Duration(milliseconds: 400))
        .listen((String value) {
      /// TO DO : keyword
      _bloc.add(LiveCampaignLoaded(
          isActive: _isOnlyShowAvailableCampaign,
          skip: 0,
          top: top,
          keyWord: value));
    });
  }

  /// Set tù khóa cho chiến dịch
  void setKeyword({String keyWord = ''}) {
    _searchBehaviorSubject.add(keyWord);
  }

  Widget buildSearchProduct() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(24)),
        height: 40,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: <Widget>[
            const SizedBox(
              width: 12,
            ),
            const Icon(
              Icons.search,
              color: Color(0xFF28A745),
            ),
            const SizedBox(
              width: 4,
            ),
            Expanded(
              child: Center(
                child: Container(
                    height: 35,
                    margin: const EdgeInsets.only(top: 0),
                    child: Center(
                      child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() {});
                            setKeyword(keyWord: value);
                          },
                          focusNode: _focusSearch,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(0),
                              isDense: true,
                              hintText: S.current.search,
                              border: InputBorder.none),
                          autofocus: isSearch),
                    )),
              ),
            ),
            Visibility(
              visible: _searchController.text != "",
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 18,
                ),
                onPressed: () {
                  setState(() {
                    _searchController.text = "";
                  });

                  setKeyword(keyWord: '');
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  /// UI button loadmore cho nhãn
  Widget _buildButtonLoadMore(int index, List<LiveCampaign> liveCampaigns) {
    return BlocBuilder<LiveCampaignBloc, LiveCampaignState>(
        builder: (context, state) {
      if (state is LiveCampaignLoadingMore) {
        return Center(
            child: SpinKitCircle(
          color: Theme.of(context).primaryColor,
        ));
      }
      return Center(
        child: Container(
            margin:
                const EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 8),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(3)),
            height: 45,
            child: FlatButton(
              onPressed: () {
                skip = liveCampaigns.length - 1;
                _bloc.add(LiveCampaignLoadedMore(
                    top: top,
                    skip: skip,
                    keyWord: _searchController.text,
                    isActive: _isOnlyShowAvailableCampaign,
                    liveCampaigns: liveCampaigns));
              },
              color: Colors.blueGrey,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(S.current.loadMore,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16)),
                    const SizedBox(
                      width: 12,
                    ),
                    const Icon(
                      Icons.save_alt,
                      color: Colors.white,
                      size: 18,
                    )
                  ],
                ),
              ),
            )),
      );
    });
  }

  void onRefreshData() {
    _bloc.add(LiveCampaignLoaded(
        isActive: _isOnlyShowAvailableCampaign,
        skip: skip,
        top: top,
        keyWord: _searchController.text));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          if (isSearch) {
            isSearch = !isSearch;
            _searchController.text = "";
            _bloc.add(LiveCampaignLoaded(
                isActive: _isOnlyShowAvailableCampaign,
                skip: 0,
                top: top,
                keyWord: _searchController.text.trim()));
          } else {
            Navigator.of(context).pop();
          }
        });
        return false;
      },
      child: BlocUiProvider<LiveCampaignBloc>(
        listen: (state) {
          if (state is LiveCampaignActionFailure) {
            App.showDefaultDialog(
                title: state.title,
                content: state.content,
                context: context,
                type: AlertDialogType.error);
          } else if (state is LiveCampaignActionSuccess) {
            if (state.path != null) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // return object of type Dialog
                  return AlertDialog(
                    title: Text(S.current.notification),
                    content: Text(
                        "${S.current.fileWasSavedInFolder}: ${state.path}. ${S.current.doYouWantToOpenFile}"),
                    actions: <Widget>[
                      // usually buttons at the bottom of the dialog
                      FlatButton(
                        child: Text(S.current.openFolder,
                            style: const TextStyle(fontSize: 16)),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          if (Platform.isAndroid) {
                            OpenFile.open('/sdcard/download');
                          } else {
                            final String dirloc =
                                (await getApplicationDocumentsDirectory()).path;
                            OpenFile.open(dirloc);
                          }
                        },
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          FlatButton(
                            child: Text(
                              S.current.close,
                              style: const TextStyle(fontSize: 16),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text(S.current.open,
                                style: const TextStyle(fontSize: 16)),
                            onPressed: () {
                              Navigator.of(context).pop();
                              OpenFile.open(state.path);
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            } else {
              _bloc.add(LiveCampaignDeleteLocal());
              App.showDefaultDialog(
                  title: state.title, content: state.content, context: context);
            }
          }
        },
        bloc: _bloc,
        child: BlocLoadingScreen<LiveCampaignBloc>(
            // ignore: prefer_const_literals_to_create_immutables
            busyStates: [LiveCampaignLoading],
            child: Scaffold(
                appBar: AppBar(
                  /// Danh sách chiến dịch
                  title: !isSearch
                      ? Text(S.current.liveCampaigns)
                      : Padding(
                          padding: const EdgeInsets.only(
                              left: 0, right: 0, top: 8, bottom: 8),
                          child: isSearch
                              ? SearchAppBarCustomWidget(
                                  color: const Color(0xFF28A745),
                                  controller: _searchController,
                                  onChanged: (text) {
                                    _bloc.add(LiveCampaignLoaded(
                                        isActive: _isOnlyShowAvailableCampaign,
                                        skip: 0,
                                        top: top,
                                        keyWord: text));
                                  },
                                )
                              : Text(S.current.liveCampaigns)),
                  actions: <Widget>[
                    if (!isSearch)
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          isSearch = !isSearch;

                          setState(() {});
                        },
                      ),
                    AppbarIconButton(
                        onPressed: () async {
                          final result = await Navigator.push(context,
                              MaterialPageRoute(builder: (ctx) {
                            return const SaleOnlineAddEditLiveCampaignPage();
                          }));

                          if (result != null) {
                            ///TO DO
                            _bloc.add(LiveCampaignLoaded(
                                isActive: _isOnlyShowAvailableCampaign,
                                skip: 0,
                                top: top,
                                keyWord: _searchController.text));
                          }
                        },
                        icon: const Icon(Icons.add),
                        isEnable: permissionAdd)
                  ],
                ),
                body: BlocBuilder<LiveCampaignBloc, LiveCampaignState>(
                    buildWhen: (LiveCampaignState prevState,
                            LiveCampaignState currState) =>
                        currState is LiveCampaignLoadSuccess ||
                        currState is LiveCampaignLoadFailure,
                    builder: (context, state) {
                      if (state is LiveCampaignLoadSuccess) {
                        return _showBody(state);
                      } else if (state is LiveCampaignLoadFailure) {
                        return AppPageState(
                          title: S.of(context).loadDataError,
                          message: state.content,
                          icon: SvgPicture.asset('assets/icon/error.svg'),
                          type: PageStateType.dataError,
                          actions: [
                            AppButton(
                              onPressed: () async {
                                _bloc.add(LiveCampaignLoaded(
                                    isActive: _isOnlyShowAvailableCampaign,
                                    skip: 0,
                                    top: top,
                                    keyWord: _searchController.text));
                              },
                              padding:
                                  const EdgeInsets.only(left: 18, right: 18),
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 40, 167, 69),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24)),
                              ),
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
                          ],
                        );
                      }
                      return const SizedBox();
                    }))),
      ),
    );
  }

  Widget _showBody(LiveCampaignLoadSuccess state) {
    return Column(children: <Widget>[
      Container(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          children: <Widget>[
            /// "Chiến dịch còn hoạt động
            Text(S.current.liveCampaign_active),
            Checkbox(
              onChanged: (value) {
                setState(() {
                  _isOnlyShowAvailableCampaign = !_isOnlyShowAvailableCampaign;
                });
                _bloc.add(LiveCampaignLoaded(
                    isActive: _isOnlyShowAvailableCampaign,
                    skip: 0,
                    top: top,
                    keyWord: _searchController.text));
              },
              value: _isOnlyShowAvailableCampaign,
            )
          ],
        ),
      ),
      const Divider(),
      Expanded(
          child: RefreshIndicator(
              key: refreshIndicatorKey,
              onRefresh: () async {
                return _bloc.add(LiveCampaignLoaded(
                    isActive: _isOnlyShowAvailableCampaign,
                    skip: 0,
                    top: top,
                    keyWord: _searchController.text));
              },
              child: state.liveCampaigns.isEmpty
                  ? _buildEmpty()
                  : ListView.separated(
                      separatorBuilder: (_, __) {
                        return const Divider();
                      },
                      itemCount: state.liveCampaigns.length,
                      itemBuilder: (ctx, index) {
                        // _buildButtonLoadMore
                        return state.liveCampaigns[index].name == 'temp'
                            ? _buildButtonLoadMore(index, state.liveCampaigns)
                            : ListTile(
                                onTap: !permissionEdit
                                    ? null
                                    : () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) {
                                            final SaleOnlineAddEditLiveCampaignPage
                                                saleOnlineAddEditLiveCampaignPage =
                                                SaleOnlineAddEditLiveCampaignPage(
                                              liveCampaign:
                                                  state.liveCampaigns[index],
                                              onEditCompleted: (value) {
                                                if (state.liveCampaigns[index]
                                                        .isActive !=
                                                    value.isActive) {
                                                  _bloc.add(LiveCampaignLoaded(
                                                      isActive:
                                                          _isOnlyShowAvailableCampaign,
                                                      skip: skip,
                                                      top: top,
                                                      keyWord: _searchController
                                                          .text));
                                                } else {
                                                  setState(() {
                                                    state.liveCampaigns[index] =
                                                        value;
                                                  });
                                                }
                                              },
                                            );
                                            return saleOnlineAddEditLiveCampaignPage;
                                          }),
                                        );
                                      },
                                title: Text(
                                  state.liveCampaigns[index].name ?? '',
                                  style: const TextStyle(color: Colors.blue),
                                ),
                                subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(state.liveCampaigns[index].note ??
                                        "${S.current.liveCampaign_noNote}.."),
                                    if (state.liveCampaigns[index]
                                            .facebookUserName !=
                                        null)

                                      /// Đã live bởi
                                      Text(
                                          "${S.current.liveCampaign_liveStreamedBy} ${state.liveCampaigns[index].facebookUserName}")
                                    else
                                      const Text(""),
                                  ],
                                ),
                                trailing: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(DateFormat("dd/MM/yyyy HH:mm")
                                            .format(state.liveCampaigns[index]
                                                .dateCreated
                                                .toLocal())),
                                        Container(
                                          width: 45,
                                          height: 35,
                                          child: Center(
                                            child: FlatButton(
                                              child: Center(
                                                  child: Icon(
                                                Icons.more_vert,
                                                color: Colors.grey[600],
                                                size: 20,
                                              )),
                                              onPressed: () {
                                                _showBottomSheet(
                                                    context,
                                                    state.liveCampaigns[index],
                                                    index);
                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                contentPadding: const EdgeInsets.only(left: 16),
                                isThreeLine: false,
                              );
                      }))),
    ]);
  }

  Widget _buildEmpty() {
    if (_searchController.text != "") {
      return AppPageState(
        title: S.of(context).searchNotFound,
        message: S
            .of(context)
            .searchNotFoundWithKeywordParam(_searchController.text, ""),
        icon: SvgPicture.asset('assets/icon/no-result.svg'),
      );
    } else {
      return AppPageState(
        title: S.of(context).noData,
        message: S.of(context).emptyNotificationParam(
            S.of(context).menu_LiveCampaign.toLowerCase()),
        icon: const SvgIcon(
          SvgIcon.emptyData,
        ),
        actions: [
          ClipOval(
            child: Container(
              height: 50,
              width: 50,
              child: Material(
                color: Colors.transparent,
                child: IconButton(
                  iconSize: 30,
                  icon: const Icon(
                    Icons.add,
                    color: Color(0xFF28A745),
                  ),
                  onPressed: () async {
                    await Navigator.push(context,
                        MaterialPageRoute(builder: (ctx) {
                      return const SaleOnlineAddEditLiveCampaignPage();
                    }));

                    ///TO DO
                    _bloc.add(LiveCampaignLoaded(
                        isActive: _isOnlyShowAvailableCampaign,
                        skip: 0,
                        top: top,
                        keyWord: _searchController.text));
                  },
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  void _showBottomSheet(context, LiveCampaign item, int index) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    topLeft: Radius.circular(12))),
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(
                      Icons.file_download,
                      color: Colors.green,
                    ),
                    title: Text(S.current.export_excel),
                    onTap: () async {
                      Navigator.pop(context);
                      // await viewModel.downloadExcel(item, context);
                      _bloc.add(LiveCampaignExportExcel(
                          liveCampaignId: item.id,
                          liveCampaignName: item.name));
                    }),
                ListTile(
                  leading: const Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                  ),
                  title: Text(S.current.delete),
                  onTap: () {
                    Navigator.pop(context);
                    App.showDefaultDialog(
                        type: AlertDialogType.error,
                        title: S.current.confirmDelete,
                        context: context,
                        content: S.current.liveCampaign_delete +
                            ' ${item?.name ?? ''}',
                        actions: [
                          ActionButton(
                              child: Text(S.current.cancel.toUpperCase()),
                              color: Colors.grey.shade200,
                              textColor: AppColors.brand3,
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              }),
                          ActionButton(
                              child: Text(S.current.agree.toUpperCase()),
                              color: Colors.grey.shade200,
                              textColor: AppColors.brand3,
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                _bloc.add(LiveCampaignDeleted(
                                    id: item.id, index: index));
                              }),
                        ]);
                  },
                ),
              ],
            ),
          );
        });
  }
}
