import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/app_core/helper/app_filter_helper.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_datetime.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_drawer.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_panel.dart';
import 'package:tpos_mobile/feature_group/conversation/bloc/conversation_facebook_account_select.dart';
import 'package:tpos_mobile/feature_group/conversation/bloc/conversation_list_bloc.dart';
import 'package:tpos_mobile/feature_group/conversation/bloc/conversation_tag_bloc.dart';
import 'package:tpos_mobile/feature_group/conversation/bloc/conversation_user_bloc.dart';
import 'package:tpos_mobile/feature_group/conversation/conversation_filter/conversation_filter.dart';
import 'package:tpos_mobile/feature_group/conversation/conversation_filter/conversation_filter_bloc.dart';
import 'package:tpos_mobile/feature_group/conversation/conversation_filter/conversation_filter_event.dart';
import 'package:tpos_mobile/feature_group/conversation/conversation_filter/conversation_filter_state.dart';
import 'package:tpos_mobile/feature_group/conversation/page/conversations_detail_page.dart';
import 'package:tpos_mobile/feature_group/conversation/widget/conversations_item_list.dart';
import 'package:tpos_mobile/feature_group/conversation/widget/tab_conversation_widget.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/load_status.dart';
import 'package:tpos_mobile/widgets/loading_indicator.dart';
import 'package:tpos_mobile_localization/generated/l10n.dart';

import '../widget/list_conversation_animation.dart';

class ConversationsPage extends StatefulWidget {
  @override
  _ConversationsPageState createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  ConversationListBloc conversationListBloc = ConversationListBloc();
  ConversationFacebookBloc conversationFacebookBloc =
      ConversationFacebookBloc();

  /// Tùy chọn danh sách
  bool isChangeList = true;
  final ScrollController _scrollController = ScrollController();

  /// Nhấn vào button lọc từ A-> Z . Kiểm tra bật tắt overlay
  bool isOnClick = false;

  /// Nhấn vào item mở rộng trong popup bottom
  bool isCheckItemPopup;

  ///Khởi tạo overlay
  OverlayEntry _overlayEntry;
  OverlayState _overlay;
  CRMTeam _crmTeam;

  ///Chọn tab
  bool selectedTab1;
  bool selectedTab2;
  bool selectedTab3;

  ///Lọc theo chữ cái đầu
  String _selectedAlphabet;

  String userIds = '';
  String tagIds = '';
  final ConversationFilter _conservationFilter = ConversationFilter();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  ConversationFilterBloc conservationFilterBloc = ConversationFilterBloc();
  ConversationUserBloc conversationUserBloc = ConversationUserBloc();
  ConversationTagBloc conversationTagBloc = ConversationTagBloc();

  int count = 0;
  final BehaviorSubject<int> _filterCountSubject = BehaviorSubject<int>();
  List<ApplicationUser> listApplicationUser = [];
  List<CRMTag> listCRMTag = [];
  String type = 'all';

  ///
  bool isFilterHasPhone = false;
  bool isFilterHasAddress = false;
  bool isFilterConservationUnread = false;
  bool isHasOrder = false;
  bool isByStaff = false;
  bool isCheckTag = false;
  bool isFilterByDate = false;
  int countFilter = 0;

  /// Danh sách hiển thị lọc trên overlay
  final List<String> _listAlphabet = <String>[
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];
  GetListFacebookResult getListFacebookResult;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ConversationTagBloc>(
          create: (context) => conversationTagBloc,
        ),
        BlocProvider<ConversationUserBloc>(
          create: (context) => conversationUserBloc,
        ),
        BlocProvider<ConversationListBloc>(
          create: (context) => conversationListBloc,
        ),
        BlocProvider<ConversationFacebookBloc>(
          create: (context) => conversationFacebookBloc,
        ),
      ],
      child: GestureDetector(
        onTap: () {
          _turnOffOverlay();
        },
        child: Scaffold(
          key: scaffoldKey,
          endDrawer: _buildFilterPanel(),
          body: _buildList(),
        ),
      ),
    );
  }

  /// Tạo overlay
  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      maintainState: true,
      builder: (context) => Positioned(
          right: 50,
          top: 120,
          width: 86,
          height: 511,
          child: Material(
            elevation: 4.0,
            child: Container(
              color: Colors.white,
              child: GridView.count(
                crossAxisCount: 2,
                children: List.generate(26, (index) {
                  return InkWell(
                    onTap: () {
                      if (_selectedAlphabet == _listAlphabet[index]) {
                        _selectedAlphabet = null;
                      } else {
                        _selectedAlphabet = _listAlphabet[index];
                      }

                      _turnOffOverlay();
                      conversationListBloc.add(ConversationSearchLoaded(
                          pageId: _crmTeam?.facebookPageId,
                          type: type,
                          page: 1,
                          limit: 20,
                          nameStart: _selectedAlphabet));
                    },
                    child: Center(
                      child: Text(
                        _listAlphabet[index],
                        style: TextStyle(
                            color: _selectedAlphabet != _listAlphabet[index]
                                ? const Color(0xFF2C333A)
                                : const Color(0xFF28A745),
                            fontSize: 15),
                      ),
                    ),
                  );
                }),
              ),
            ),
          )),
    );
  }

  void _reload() {
    conversationListBloc.add(ConversationLoaded(
        page: 1,
        pageId: _crmTeam?.facebookPageId,
        limit: 20,
        type: type,
        id: _crmTeam?.id,
        end: _conservationFilter.isFilterByDate
            ? _conservationFilter.dateTo
            : null,
        start: _conservationFilter.isFilterByDate
            ? _conservationFilter.dateFrom
            : null,
        userIds: userIds,
        tagIds: tagIds,
        hasUnread: _conservationFilter.isFilterConservationUnread,
        hasPhone: _conservationFilter.isFilterHasPhone,
        hasOrder: _conservationFilter.isHasOrder,
        hasAddress: _conservationFilter.isFilterHasAddress));
  }

  /// Tạo Appbar
  Widget _buildHeaderAppBar(BuildContext context,
      {GetListFacebookResult getListFacebookResult,
      ConversationFacebookAcountState state}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (_crmTeam?.name != null)
          Container(
            height: 36,
            width: 36,
            child: CircleAvatar(
              radius: 30.0,
              backgroundImage: _crmTeam?.facebookPageLogo != null
                  ? NetworkImage(_crmTeam?.facebookPageLogo)
                  : null,
              backgroundColor: Colors.white,
            ),
          ),
        if (_crmTeam?.name != null)
          const SizedBox(
            width: 14,
          ),
        InkWell(
          onTap: () {
            if (state is! FacebookWaiting) {
              _turnOffOverlay();
              conversationFacebookBloc.add(FacebookLoaded());
              if (getListFacebookResult != null) {
                buildBottomSheet(context, getListFacebookResult);
              }
            }
            // _reload();
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width - 160),
                child: Text(
                  _crmTeam?.name?.toUpperCase() ??
                      S.current.noChannelSelected.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _filterCountSubject.sink.add(count);

    ///
    selectedTab1 = true;
    selectedTab2 = false;
    selectedTab3 = false;

    ///
    _conservationFilter?.filterDateRange = getTodayDateFilter();
    _conservationFilter?.dateFrom =
        _conservationFilter.filterDateRange?.fromDate;
    _conservationFilter?.dateTo = _conservationFilter.filterDateRange?.toDate;
    conservationFilterBloc.add(ConversationFilterLoaded());

    ///
    _overlay = Overlay.of(context);
    _overlayEntry = _createOverlayEntry();
    isCheckItemPopup = false;
    conversationListBloc.add(ConversationLoaded(
        page: 1, pageId: _crmTeam?.facebookPageId, limit: 20, type: 'all'));
    conversationFacebookBloc.add(FacebookLoaded());
    conversationUserBloc.add(ConversationUserLoaded());
    conversationTagBloc.add(ConversationTagLoaded());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _filterCountSubject.close();
    _scrollController.dispose();
  }

  void handleChangeFilter({bool isConfirm = false}) {
    conservationFilterBloc.add(ConversationFilterChanged(
        filterDateRange: _conservationFilter.filterDateRange,
        filterToDate: _conservationFilter.dateTo,
        filterFromDate: _conservationFilter.dateFrom,
        isFilterHasPhone: isFilterHasPhone,
        isFilterHasAddress: isFilterHasAddress,
        isFilterByDate: isFilterByDate,
        isFilterConservationUnread: isFilterConservationUnread,
        isHasOrder: isHasOrder,
        isByStaff: isByStaff,
        isConfirm: isConfirm,
        isCheckStaff: isByStaff,
        applicationUserList: _conservationFilter.applicationUserListSelect,
        isCheckTag: isCheckTag));
  }

  Widget _buildBodyFilterDrawer(ConversationFilterLoadSuccess state) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              StatefulBuilder(
                builder: (BuildContext context,
                    void Function(void Function()) setState) {
                  return Checkbox(
                      value: isFilterHasPhone ?? false,
                      onChanged: (bool value) {
                        _conservationFilter.isFilterHasPhone = value;
                        isFilterHasPhone = value;
                        if (isFilterHasPhone) {
                          count += 1;
                          _filterCountSubject.sink.add(count);
                        } else {
                          count -= 1;
                          if (count < 0) {
                            count = 0;
                          }
                          _filterCountSubject.sink.add(count);
                        }
                        setState(() {});
                      });
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  S.current.hasPhoneNumber,
                  style: const TextStyle(color: Color(0xFF2C333A)),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              StatefulBuilder(
                builder: (BuildContext context,
                    void Function(void Function()) setState) {
                  return Checkbox(
                      value: isFilterHasAddress ?? false,
                      onChanged: (bool value) {
                        _conservationFilter.isFilterHasAddress = value;
                        isFilterHasAddress = value;
                        if (isFilterHasAddress) {
                          count += 1;
                          _filterCountSubject.sink.add(count);
                        } else {
                          count -= 1;
                          if (count < 0) {
                            count = 0;
                          }
                          _filterCountSubject.sink.add(count);
                        }
                        setState(() {});
                      });
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  S.current.hasAddress,
                  style: const TextStyle(color: Color(0xFF2C333A)),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              StatefulBuilder(
                builder: (BuildContext context,
                    void Function(void Function()) setState) {
                  return Checkbox(
                      value: isFilterConservationUnread ?? false,
                      onChanged: (bool value) {
                        _conservationFilter.isFilterConservationUnread = value;
                        isFilterConservationUnread = value;
                        if (isFilterConservationUnread) {
                          count += 1;
                          _filterCountSubject.sink.add(count);
                        } else {
                          count -= 1;
                          if (count < 0) {
                            count = 0;
                          }
                          _filterCountSubject.sink.add(count);
                        }
                        setState(() {});
                      });
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  S.current.unReadConversation,
                  style: const TextStyle(color: Color(0xFF2C333A)),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              StatefulBuilder(
                builder: (BuildContext context,
                    void Function(void Function()) setState) {
                  return Checkbox(
                      value: isHasOrder ?? false,
                      onChanged: (bool value) {
                        _conservationFilter.isHasOrder = value;
                        isHasOrder = value;
                        if (isHasOrder) {
                          count += 1;
                          _filterCountSubject.sink.add(count);
                        } else {
                          count -= 1;
                          if (count < 0) {
                            count = 0;
                          }
                          _filterCountSubject.sink.add(count);
                        }
                        setState(() {});
                      });
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  S.current.hasOrder,
                  style: const TextStyle(color: Color(0xFF2C333A)),
                ),
              ),
            ],
          ),
          StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return AppFilterPanel(
                isSelected: isByStaff ?? false,
                onSelectedChange: (bool value) {
                  _conservationFilter.isByStaff = value;
                  isByStaff = value;
                  if (isByStaff) {
                    count += 1;
                    _filterCountSubject.sink.add(count);
                  } else {
                    count -= 1;
                    if (count < 0) {
                      count = 0;
                    }
                    _filterCountSubject.sink.add(count);
                  }
                  setState(() {});
                  conversationUserBloc.add(ConversationUserLoaded());
                },
                // _vm.isFilterByTypeAccountPayment = value,
                title: Text(S.current.filter_filterByEmployee),
                children: [
                  BlocBuilder<ConversationUserBloc, ConversationUserState>(
                      builder: (context, state) {
                    if (state is ConversationUserLoad) {
                      return Wrap(
                          children: state.applicationUsers?.value != null
                              ? state.applicationUsers.value.map(
                                  (e) {
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                      return Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Container(
                                          color: listApplicationUser.any(
                                                  (element) =>
                                                      e?.id == element?.id)
                                              ? const Color(0xFFE9F6EC)
                                              : Colors.white,
                                          height: 30,
                                          child: OutlineButton(
                                            child: Text(
                                              e.name,
                                              style: listApplicationUser.any(
                                                      (element) =>
                                                          e?.id == element?.id)
                                                  ? const TextStyle(
                                                      color: Color(0xFF28A745))
                                                  : const TextStyle(
                                                      color: Color(0xFF6B7280)),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (!listApplicationUser.any(
                                                    (element) =>
                                                        e.id == element.id)) {
                                                  listApplicationUser.add(e);
                                                } else {
                                                  listApplicationUser
                                                      .removeWhere((element) =>
                                                          e.id == element.id);
                                                }
                                              });
                                            }, //callback when button is clicked
                                            borderSide: BorderSide(
                                              color: listApplicationUser.any(
                                                      (element) =>
                                                          e.id == element.id)
                                                  ? const Color(0xFF28A745)
                                                  : const Color(
                                                      0xFFE9EDF2), //Color of the border
                                              style: BorderStyle
                                                  .solid, //Style of the border
                                              width: 1, //width of the border
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                                  },
                                ).toList()
                              : []);
                    } else if (state is ConversationUserWaiting) {
                      return const LoadingIndicator();
                    }
                    return Container();
                  }),
                ],
              );
            },
          ),
          StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return AppFilterPanel(
                isSelected: isCheckTag ?? false,
                onSelectedChange: (bool value) {
                  _conservationFilter.isCheckTag = value;
                  isCheckTag = value;
                  if (isCheckTag) {
                    count += 1;
                    _filterCountSubject.sink.add(count);
                  } else {
                    count -= 1;
                    if (count < 0) {
                      count = 0;
                    }
                    _filterCountSubject.sink.add(count);
                  }
                  setState(() {});
                  conversationTagBloc.add(ConversationTagLoaded());
                },
                // _vm.isFilterByTypeAccountPayment = value,
                ///Theo nhãn
                title: Text(S.current.filterByTags),
                children: [
                  BlocBuilder<ConversationTagBloc, ConversationTagState>(
                      builder: (context, state) {
                    if (state is ConversationTagWaiting) {
                      return const LoadingIndicator();
                    } else if (state is ConversationTagLoading) {
                      return Wrap(
                          children: state.crmTags?.value != null
                              ? state.crmTags.value.map(
                                  (e) {
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                      return Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Container(
                                          color: listCRMTag.any((element) =>
                                                  e.id == element.id)
                                              ? const Color(0xFFE9F6EC)
                                              : Colors.white,
                                          height: 30,
                                          child: OutlineButton(
                                            child: Text(
                                              e.name,
                                              style: listCRMTag.any((element) =>
                                                      e.id == element.id)
                                                  ? const TextStyle(
                                                      color: Color(0xFF28A745))
                                                  : const TextStyle(
                                                      color: Color(0xFF6B7280)),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (!listCRMTag.any((element) =>
                                                    e.id == element.id)) {
                                                  listCRMTag.add(e);
                                                } else {
                                                  listCRMTag.removeWhere(
                                                      (element) =>
                                                          e.id == element.id);
                                                }
                                              });
                                            }, //callback when button is clicked
                                            borderSide: BorderSide(
                                              color: listCRMTag.any((element) =>
                                                      e.id == element.id)
                                                  ? const Color(0xFF28A745)
                                                  : const Color(
                                                      0xFFE9EDF2), //Color of the border
                                              style: BorderStyle
                                                  .solid, //Style of the border
                                              width: 1, //width of the border
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                                  },
                                ).toList()
                              : []);
                    } else if (state is ConversationUserWaiting) {
                      return const LoadingIndicator();
                    }
                    return Container();
                  }),
                ],
              );
            },
          ),
          StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return AppFilterDateTime(
                isSelected: isFilterByDate ?? false,
                initDateRange: _conservationFilter.filterDateRange,
                onSelectChange: (value) {
                  _conservationFilter.isFilterByDate = value;
                  isFilterByDate = value;
                  if (isFilterByDate) {
                    count += 1;
                    _filterCountSubject.sink.add(count);
                  } else {
                    count -= 1;
                    if (count < 0) {
                      count = 0;
                    }
                    _filterCountSubject.sink.add(count);
                  }
                  setState(() {});
                },
                toDate: _conservationFilter.dateTo,
                fromDate: _conservationFilter.dateFrom,
                dateRangeChanged: (value) {
                  _conservationFilter.filterDateRange = value;
                  handleChangeFilter();
                },
                onFromDateChanged: (value) {
                  _conservationFilter.dateFrom = value;
                  handleChangeFilter();
                },
                onToDateChanged: (value) {
                  _conservationFilter.dateTo = value;
                  handleChangeFilter();
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _countFilter(bool isCheck) {
    if (isCheck) {
      count += 1;
    }
  }

  Widget _buildFilterPanel() {
    return BlocBuilder<ConversationFilterBloc, ConversationFilterState>(
        cubit: conservationFilterBloc,
        builder: (context, state) {
          _turnOffOverlay();
          if (state is ConversationFilterLoadSuccess) {
            _conservationFilter?.dateFrom = state?.filterFromDate;
            _conservationFilter?.dateTo = state?.filterToDate;
            _conservationFilter?.filterDateRange = state?.filterDateRange;
            isFilterHasPhone = state.isFilterHasPhone ?? false;
            isFilterHasAddress = state.isFilterHasAddress ?? false;
            isFilterConservationUnread =
                state.isFilterConservationUnread ?? false;
            isHasOrder = state.isHasOrder ?? false;
            isByStaff = state.isByStaff ?? false;
            isCheckTag = state.isCheckTag ?? false;
            isFilterByDate = state.isFilterByDate ?? false;
            count = 0;
            _countFilter(isFilterHasPhone);
            _countFilter(isFilterHasAddress);
            _countFilter(isFilterConservationUnread);
            _countFilter(isHasOrder);
            _countFilter(isByStaff);
            _countFilter(isCheckTag);
            _countFilter(isFilterByDate);
            _filterCountSubject.sink.add(count);
            return StreamBuilder<int>(
              stream: _filterCountSubject.stream,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return AppFilterDrawerContainer(
                  countFilter: count,
                  onRefresh: () {
                    _conservationFilter.isFilterHasPhone = false;
                    _conservationFilter.isFilterHasAddress = false;
                    _conservationFilter.isFilterConservationUnread = false;
                    _conservationFilter.isHasOrder = false;
                    _conservationFilter.isByStaff = false;
                    _conservationFilter.isCheckTag = false;
                    _conservationFilter.isFilterByDate = false;
                    isFilterHasPhone = false;
                    isFilterHasAddress = false;
                    isFilterConservationUnread = false;
                    isHasOrder = false;
                    isByStaff = false;
                    isCheckTag = false;
                    isFilterByDate = false;
                    setState(() {
                      countFilter = 0;
                      count = 0;
                    });
                    handleChangeFilter();
                    Navigator.pop(context);
                    _reload();
                  },
                  closeWhenConfirm: false,
                  onApply: () {
                    setState(() {
                      countFilter = count;
                    });
                    _conservationFilter.applicationUserListSelect =
                        listApplicationUser;
                    _conservationFilter.crmTagListSelect = listCRMTag;
                    handleChangeFilter();
                    userIds = '';
                    tagIds = '';

                    /// Query id người dùng
                    for (int i = 0;
                        i <
                            _conservationFilter
                                .applicationUserListSelect.length;
                        i++) {
                      if (_conservationFilter
                                  .applicationUserListSelect.length ==
                              1 ||
                          i ==
                              _conservationFilter
                                      .applicationUserListSelect.length -
                                  1) {
                        userIds +=
                            _conservationFilter.applicationUserListSelect[i].id;
                      } else {
                        userIds += _conservationFilter
                                .applicationUserListSelect[i].id +
                            ',';
                      }
                    }

                    /// Query id tag
                    for (int i = 0;
                        i < _conservationFilter.crmTagListSelect.length;
                        i++) {
                      if (_conservationFilter.crmTagListSelect.length == 1 ||
                          i ==
                              _conservationFilter.crmTagListSelect.length - 1) {
                        tagIds += _conservationFilter.crmTagListSelect[i].id;
                      } else {
                        tagIds +=
                            _conservationFilter.crmTagListSelect[i].id + ',';
                      }
                    }

                    if (userIds.isEmpty && isByStaff) {
                      App.showDefaultDialog(
                          title: S.current.warning,
                          content: S.current.pleaseChooseEmployee,
                          type: AlertDialogType.warning,
                          context: context);
                    } else if (tagIds.isEmpty && isCheckTag) {
                      App.showDefaultDialog(
                          title: S.current.warning,
                          content: S.current.pleaseChooseTag,
                          type: AlertDialogType.warning,
                          context: context);
                    } else {
                      Navigator.pop(context);
                      _reload();
                    }
                  },
                  child: _buildBodyFilterDrawer(state),
                );
              },
            );
          }
          return const SizedBox();
        });
  }

  ///item mở rộng trong bottom sheet
  Widget _buildListItem({CRMTeam crmTeam}) {
    return InkWell(
      onTap: () {
        setState(() {
          _crmTeam = crmTeam;
          Navigator.pop(context);
          conversationListBloc.add(ConversationLoaded(
              page: 1,
              pageId: _crmTeam?.facebookPageId,
              limit: 20,
              type: type,
              id: _crmTeam?.id));
        });
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: (crmTeam?.facebookPageId == _crmTeam?.facebookPageId)
                ? const Color(0xFFDFE7EC)
                : Colors.white),
        margin: const EdgeInsets.only(left: 80, right: 20, bottom: 5),
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.grey,
                        child: ClipOval(
                          child: Image.network(
                            crmTeam?.facebookPageLogo,
                            fit: BoxFit.contain,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace stackTrace) {
                              return Container(
                                color: Colors.grey,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Text(
                        crmTeam.name ?? '',
                        style: const TextStyle(
                          color: Color(0xFF2C333A),
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (crmTeam?.facebookPageId == _crmTeam?.facebookPageId)
                Container(
                  margin: const EdgeInsets.only(right: 13),
                  child: const Icon(
                    Icons.check_circle,
                    color: Color(0xFF28A745),
                  ),
                )
              else
                const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar({String facebookStatusImage, CRMTeam crmTeam}) {
    return Stack(
      children: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 25,
          child: ClipOval(
            child: crmTeam.facebookUserAvatar != null
                ? Image.network(
                    crmTeam?.facebookUserAvatar,
                    fit: BoxFit.contain,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace stackTrace) {
                      return Container(
                        color: Colors.grey,
                      );
                    },
                  )
                : Container(
                    color: Colors.grey,
                  ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: 17,
            height: 17,
            child: SvgPicture.asset(
              facebookStatusImage,
              fit: BoxFit.contain,
            ),
          ),
        )
      ],
    );
  }

  Widget _openPopupMenu() => PopupMenuButton<int>(
        icon: const Icon(
          Icons.more_vert,
          color: Colors.white,
        ),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Text(
              S.current.scanPhoneNumber,
              style: const TextStyle(color: Color(0xFF2C333A)),
            ),
          ),
        ],
        elevation: 4,
        onSelected: (int value) {
          switch (value) {
            case 1:
              _turnOffOverlay();
              setState(() {
                isChangeList = !isChangeList;
              });
              break;
          }
        },
      );

  /// Tắt overlay
  void _turnOffOverlay() {
    if (isOnClick) {
      _overlayEntry.remove();
    }
    isOnClick = false;
  }

  /// Mở overlay
  void _turnOnOverlay() {
    _overlay.insert(_overlayEntry);
  }

  void buildBottomSheet(
      BuildContext context, GetListFacebookResult getListFacebookResult) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        backgroundColor: Colors.white,
        builder: (ctx) {
          return SafeArea(
            child: Container(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height - 100),
              child: Column(
                children: [
                  Stack(
                    children: [
                      ListTile(
                        title: Center(
                          child: Text(
                            S.current.chooseFacebookAccount,
                            style: const TextStyle(
                                color: Color(
                                  0xFF2C333A,
                                ),
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 7),
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                          children: getListFacebookResult != null
                              ? getListFacebookResult.items
                                  .map((e) => ExpansionTile(
                                        leading: Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          height: 36,
                                          width: 36,
                                          child: _buildAvatar(
                                              facebookStatusImage:
                                                  'assets/icon/facebook_icon.svg',
                                              crmTeam: e),
                                        ),
                                        title: Text(e.name),
                                        children: <Widget>[
                                          ListView.builder(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: e.childs.length,
                                              itemBuilder: (context, index) {
                                                return _buildListItem(
                                                  crmTeam: e.childs[index],
                                                );
                                              }),
                                        ],
                                      ))
                                  .toList()
                              : []),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  /// Ngày hiển thị trên thanh scroll
  String _buildDateScroll({int value, ConversationLoading state}) {
    if (type != 'comment') {
      if (state.getListConservationResult.items[value].lastMessage
              ?.createdTime !=
          null) {
        return DateFormat('HH:mm').format(state
            .getListConservationResult.items[value].lastMessage?.createdTime
            ?.add(const Duration(hours: 7)));
      }
    } else {
      if (state.getListConservationResult.items[value].lastComment
              ?.createdTime !=
          null) {
        return DateFormat('HH:mm').format(state
            .getListConservationResult.items[value].lastComment?.createdTime
            ?.add(const Duration(hours: 7)));
      }
    }
    return '';
  }

  Widget _buildList() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: ListConversationAnimation(
                count: countFilter,
                crmTeam: _crmTeam,
                conversationListBloc: conversationListBloc,
                onPressPopup: () {
                  scaffoldKey.currentState.openEndDrawer();
                },
                type: type,
                scrollController: _scrollController,
                popupMenu: _openPopupMenu(),
                onPressFilterPopup: () {
                  isOnClick = !isOnClick;
                  if (isOnClick) {
                    _turnOnOverlay();
                  } else {
                    _overlayEntry.remove();
                  }
                },
                onPressBack: () {
                  _turnOffOverlay();
                  Navigator.pop(context);
                },
                child:
                    BlocConsumer<ConversationListBloc, ConversationListState>(
                        listener: (context, state) {
                  if (state is ConversationFailure) {
                    // App.showDefaultDialog(title: S.current.warning,content: S.current.homePage_connectError,context: scaffoldKey.currentContext);
                  }
                }, builder: (context, state) {
                  if (state is ConversationWaiting) {
                    return const LoadingIndicator();
                  }
                  if (state is ConversationLoading) {
                    if (_crmTeam == null) {
                      return Container(
                          child: Center(
                              child: Text(
                        S.current.noChannelSelected,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w300),
                      )));
                    } else if (state.getListConservationResult.items.isEmpty) {
                      return Center(
                          child: LoadStatusWidget.empty(
                              statusName: '', content: S.of(context).noData));
                    }
                    return DraggableScrollbar.arrows(
                      alwaysVisibleScrollThumb: false,
                      labelTextBuilder: (double offset) => isChangeList
                          ? (Text(
                              (offset ~/ 95 <=
                                      state.getListConservationResult.items
                                              .length -
                                          1)
                                  ? _buildDateScroll(
                                      value: offset ~/ 95, state: state)
                                  : _buildDateScroll(
                                      value: state.getListConservationResult
                                              .items.length -
                                          1,
                                      state: state),
                              style: const TextStyle(color: Colors.white),
                            ))
                          : (Text(
                              (offset ~/ 110 <=
                                      state.getListConservationResult.items
                                              .length -
                                          1)
                                  ? _buildDateScroll(
                                      value: offset ~/ 110, state: state)
                                  : _buildDateScroll(
                                      value: state.getListConservationResult
                                              .items.length -
                                          1,
                                      state: state),
                              style: const TextStyle(color: Colors.white),
                            )),
                      controller: _scrollController,
                      backgroundColor: const Color(0xFF28A745).withOpacity(0.6),
                      child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(top: 0),
                          itemCount:
                              state.getListConservationResult.items.length,
                          itemBuilder: (context, int index) {
                            final Conversation itemConservation =
                                state.getListConservationResult.items[index];
                            return InkWell(
                              onTap: () async {
                                _turnOffOverlay();
                                final List<dynamic> list = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ConversationDetailPage(
                                              conversation: itemConservation,
                                              crmTeam: _crmTeam,
                                              type: itemConservation
                                                          .lastMessage ==
                                                      null
                                                  ? 'comment'
                                                  : 'message',
                                            )));
                                if (itemConservation.assignedToFacebook?.name !=
                                    list[0]?.name) {
                                  _reload();
                                } else if (list[1] is List<TagStatusFacebook>) {
                                  _reload();
                                }
                              },
                              child: ConversationItemList(
                                isRowThreeChat: isChangeList,
                                itemConversation: itemConservation,
                                crmTeam: _crmTeam,
                                type: type,
                                imageStatus:
                                    itemConservation.lastMessage == null
                                        ? 'assets/icon/facebook_icon.svg'
                                        : 'assets/icon/message_icon.svg',
                              ),
                            );
                          }),
                    );
                  } else if (state is ConversationFailure) {
                    return Column(
                      children: [
                        SizedBox(
                            height: 50 *
                                (MediaQuery.of(context).size.height / 700)),
                        LoadStatusWidget(
                          statusName: S.of(context).loadDataError,
                          content: state.error,
                          statusIcon: SvgPicture.asset('assets/icon/error.svg',
                              width: 170, height: 130),
                          action: AppButton(
                            onPressed: () {
                              _reload();
                            },
                            width: 180,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 40, 167, 69),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24)),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    FontAwesomeIcons.sync,
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
                  }
                  return Container();
                }),
                titleAppBar: BlocConsumer<ConversationFacebookBloc,
                    ConversationFacebookAcountState>(
                  listener: (context, state) {
                    if (state is FacebookFailure) {
                      App.showDefaultDialog(
                        title: S.current.warning,
                        content: state.error,
                        type: AlertDialogType.warning,
                        context: context,
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is FacebookLoading) {
                      return _buildHeaderAppBar(context,
                          getListFacebookResult: state.facebookAccounts,
                          state: state);
                    } else if (state is FacebookWaiting) {
                      return _buildHeaderAppBar(context,
                          state: state, getListFacebookResult: null);
                    }
                    return _buildHeaderAppBar(context,
                        getListFacebookResult: null);
                  },
                )),
          ),
          BlocBuilder<ConversationListBloc, ConversationListState>(
              builder: (context, state) {
            if (state is ConversationLoading) {
              return TabConversation(
                selectedTab1: selectedTab1,
                selectedTab2: selectedTab2,
                selectedTab3: selectedTab3,
                conversationListBloc: conversationListBloc,
                countAll: state.unread?.countAll,
                countComment: state.unread?.countComment,
                countMessage: state.unread?.countMessage,
                crmTeam: _crmTeam,
                conversationFilter: _conservationFilter,
                userIds: userIds,
                onPressAll: () {
                  setState(() {
                    type = 'all';
                    _reload();
                  });
                },
                onPressComment: () {
                  setState(() {
                    type = 'comment';
                    _reload();
                  });
                },
                onPressMessage: () {
                  setState(() {
                    type = 'message';
                    _reload();
                  });
                },
              );
            }

            return TabConversation(
              selectedTab1: selectedTab1,
              selectedTab2: selectedTab2,
              selectedTab3: selectedTab3,
              conversationListBloc: conversationListBloc,
              onPressAll: () {
                setState(() {
                  type = 'all';
                  _reload();
                });
              },
              onPressComment: () {
                setState(() {
                  type = 'comment';
                  _reload();
                });
              },
              onPressMessage: () {
                setState(() {
                  type = 'message';
                  _reload();
                });
              },
            );
          }),
        ],
      ),
    );
  }
}
