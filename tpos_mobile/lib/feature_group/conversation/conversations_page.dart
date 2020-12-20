import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/app_filter_helper.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_datetime.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_drawer.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_panel.dart';
import 'package:tpos_mobile/feature_group/conversation/bloc/conservation_list_bloc.dart';
import 'package:tpos_mobile/feature_group/conversation/bloc/conversation_facebook_account_select.dart';
import 'package:tpos_mobile/feature_group/conversation/conversations_message_page.dart';
import 'package:tpos_mobile/feature_group/conversation/conversations_item_list.dart';
import 'package:tpos_mobile/feature_group/conversation/conversation_filter/conversation_filter.dart';
import 'package:tpos_mobile/feature_group/conversation/conversation_filter/conversation_filter_bloc.dart';
import 'package:tpos_mobile/feature_group/conversation/conversation_filter/conversation_filter_state,.dart';
import 'package:tpos_mobile/feature_group/conversation/conversation_filter/conversation_filter_event.dart';
import 'package:tpos_mobile/feature_group/conversation/tab_conversation_widget.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/empty_data_page.dart';
import 'package:tpos_mobile/widgets/loading_indicator.dart';
import 'list_conversation_animation.dart';

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
  bool selectedTab1;
  bool selectedTab2;
  bool selectedTab3;
  String _selectedAlphabet;
  String userIds = '';
  String tagIds = '';
  final ConversationFilter _conservationFilter = ConversationFilter();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ConversationFilterBloc conservationFilterBloc = ConversationFilterBloc();
  int count = 0;
  List<ApplicationUser> listApplicationUser = [];
  List<CRMTag> listCRMTag = [];
  String type = 'all';

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
  int countValueFilter(bool isValue) {
    if (isValue) {
      count++;
    } else {
      count--;
      if (count < 0) {
        count = 0;
      }
    }
    return count;
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
                      _selectedAlphabet = _listAlphabet[index];
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
  Widget _buildHeaderAppBar(
      BuildContext context, GetListFacebookResult getListFacebookResult) {
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
            _turnOffOverlay();
            displayBottomSheet(context, getListFacebookResult);
            _reload();
          },
          child: Row(
            children: [
              Text(
                _crmTeam?.name ?? 'Chưa chọn kênh',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
                overflow: TextOverflow.ellipsis,
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
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  void handleChangeFilter({bool isConfirm = false}) {
    conservationFilterBloc.add(ConversationFilterChanged(
        filterDateRange: _conservationFilter.filterDateRange,
        filterToDate: _conservationFilter.dateTo,
        filterFromDate: _conservationFilter.dateFrom,
        isFilterHasPhone: _conservationFilter.isFilterHasPhone,
        isFilterHasAddress: _conservationFilter.isFilterHasAddress,
        isFilterByDate: _conservationFilter.isFilterByDate,
        isFilterConservationUnread:
            _conservationFilter.isFilterConservationUnread,
        isHasOrder: _conservationFilter.isHasOrder,
        isByStaff: _conservationFilter.isByStaff,
        isConfirm: isConfirm,
        isCheckStaff: _conservationFilter.isCheckStaff,
        applicationUserList: _conservationFilter.applicationUserListSelect,
        isCheckTag: _conservationFilter.isCheckTag));
  }

  Widget _buildBodyFilterDrawer(ConversationFilterLoadSuccess state) {
    state.applicationUserSelect
        ?.any((b) => state.applicationUsers.value.any((a) => a.id == b.id));
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                  value: state.isFilterHasPhone ?? false,
                  onChanged: (bool value) {
                    setState(() {
                      _conservationFilter.isFilterHasPhone = value;
                      countValueFilter(_conservationFilter.isFilterHasPhone);
                      handleChangeFilter();
                    });
                  }),
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  'Có số điện thoại',
                  style: TextStyle(color: Color(0xFF2C333A)),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                  value: state.isFilterHasAddress ?? false,
                  onChanged: (bool value) {
                    setState(() {
                      _conservationFilter.isFilterHasAddress = value;
                      countValueFilter(_conservationFilter.isFilterHasAddress);
                      handleChangeFilter();
                    });
                  }),
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  'Có địa chỉ',
                  style: TextStyle(color: Color(0xFF2C333A)),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                  value: state.isFilterConservationUnread ?? false,
                  onChanged: (bool value) {
                    setState(() {
                      _conservationFilter.isFilterConservationUnread = value;
                      countValueFilter(
                          _conservationFilter.isFilterConservationUnread);
                      handleChangeFilter();
                    });
                  }),
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  'Hội thoại chưa đọc',
                  style: TextStyle(color: Color(0xFF2C333A)),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                  value: state.isHasOrder ?? false,
                  onChanged: (bool value) {
                    setState(() {
                      _conservationFilter.isHasOrder = value;
                      countValueFilter(_conservationFilter.isHasOrder);
                      handleChangeFilter();
                    });
                  }),
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  'Có đơn hàng',
                  style: TextStyle(color: Color(0xFF2C333A)),
                ),
              ),
            ],
          ),
          AppFilterPanel(
            isSelected: state.isByStaff ?? false,
            onSelectedChange: (bool value) {
              _conservationFilter.isByStaff = value;
              countValueFilter(_conservationFilter.isByStaff);
              handleChangeFilter();
            },
            // _vm.isFilterByTypeAccountPayment = value,
            ///Theo nhân viên
            title: const Text('Theo nhân viên'),
            children: [
              Wrap(
                  children: state.applicationUsers?.value != null
                      ? state.applicationUsers.value.map(
                          (e) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                              return Padding(
                                padding: const EdgeInsets.all(5),
                                child: Container(
                                  color: listApplicationUser.any(
                                          (element) => e?.id == element?.id)
                                      ? const Color(0xFFE9F6EC)
                                      : Colors.white,
                                  height: 30,
                                  child: OutlineButton(
                                    child: Text(
                                      e.name,
                                      style: listApplicationUser.any(
                                              (element) => e?.id == element?.id)
                                          ? const TextStyle(
                                              color: Color(0xFF28A745))
                                          : const TextStyle(
                                              color: Color(0xFF6B7280)),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (!listApplicationUser.any(
                                            (element) => e.id == element.id)) {
                                          listApplicationUser.add(e);
                                        } else {
                                          listApplicationUser.removeWhere(
                                              (element) => e.id == element.id);
                                        }
                                      });
                                    }, //callback when button is clicked
                                    borderSide: BorderSide(
                                      color: listApplicationUser.any(
                                              (element) => e.id == element.id)
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
                      : []),
            ],
          ),
          AppFilterPanel(
            isSelected: state.isCheckTag ?? false,
            onSelectedChange: (bool value) {
              _conservationFilter.isCheckTag = value;
              countValueFilter(_conservationFilter.isCheckTag);
              handleChangeFilter();
            },
            // _vm.isFilterByTypeAccountPayment = value,
            ///Theo nhãn
            title: const Text('Theo nhãn'),
            children: [
              Wrap(
                  children: state.crmTags?.value != null
                      ? state.crmTags.value.map(
                          (e) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                              return Padding(
                                padding: const EdgeInsets.all(5),
                                child: Container(
                                  color: listCRMTag
                                          .any((element) => e.id == element.id)
                                      ? const Color(0xFFE9F6EC)
                                      : Colors.white,
                                  height: 30,
                                  child: OutlineButton(
                                    child: Text(
                                      e.name,
                                      style: listCRMTag.any(
                                              (element) => e.id == element.id)
                                          ? const TextStyle(
                                              color: Color(0xFF28A745))
                                          : const TextStyle(
                                              color: Color(0xFF6B7280)),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (!listCRMTag.any(
                                            (element) => e.id == element.id)) {
                                          listCRMTag.add(e);
                                        } else {
                                          listCRMTag.removeWhere(
                                              (element) => e.id == element.id);
                                        }
                                      });
                                    }, //callback when button is clicked
                                    borderSide: BorderSide(
                                      color: listCRMTag.any(
                                              (element) => e.id == element.id)
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
                      : []),
            ],
          ),
          AppFilterDateTime(
            isSelected: state.isFilterByDate ?? false,
            initDateRange: _conservationFilter.filterDateRange,
            onSelectChange: (value) {
              _conservationFilter.isFilterByDate = value;
              countValueFilter(_conservationFilter.isFilterByDate);
              handleChangeFilter();
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
          ),
        ],
      ),
    );
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

                handleChangeFilter(isConfirm: true);
              },
              closeWhenConfirm: true,
              onApply: () {
                _conservationFilter.applicationUserListSelect =
                    listApplicationUser;
                _conservationFilter.crmTagListSelect = listCRMTag;

                userIds = '';
                tagIds = '';

                /// Query id người dùng
                for (int i = 0;
                    i < _conservationFilter.applicationUserListSelect.length;
                    i++) {
                  if (_conservationFilter.applicationUserListSelect.length ==
                          1 ||
                      i ==
                          _conservationFilter.applicationUserListSelect.length -
                              1) {
                    userIds +=
                        _conservationFilter.applicationUserListSelect[i].id;
                  } else {
                    userIds +=
                        _conservationFilter.applicationUserListSelect[i].id +
                            ',';
                  }
                }

                /// Query id tag
                for (int i = 0;
                    i < _conservationFilter.crmTagListSelect.length;
                    i++) {
                  if (_conservationFilter.crmTagListSelect.length == 1 ||
                      i == _conservationFilter.crmTagListSelect.length - 1) {
                    tagIds += _conservationFilter.crmTagListSelect[i].id;
                  } else {
                    tagIds += _conservationFilter.crmTagListSelect[i].id + ',';
                  }
                }

                _reload();
              },
              child: _buildBodyFilterDrawer(state),
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
              type: 'all',
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
          radius: 25,
          child: ClipOval(
            child: Image.network(
              crmTeam?.facebookUserAvatar,
              fit: BoxFit.contain,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace stackTrace) {
                return const Text('Error');
              },
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: 17,
            height: 17,
            child: ClipOval(
              child: Image.asset(
                facebookStatusImage,
                fit: BoxFit.contain,
              ),
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
          const PopupMenuItem(
            value: 1,
            child: Text(
              'Quét số điện thoại',
              style: TextStyle(color: Color(0xFF2C333A)),
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

  void displayBottomSheet(
      BuildContext context, GetListFacebookResult getListFacebookResult) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        backgroundColor: Colors.white,
        builder: (ctx) {
          return SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  leading: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: const Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: Text(
                      'Chọn trang Facebook',
                      style: TextStyle(
                          color: Color(
                            0xFF2C333A,
                          ),
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Column(
                    children: getListFacebookResult != null
                        ? getListFacebookResult.items
                            .map((e) => ExpansionTile(
                                  leading: Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    height: 36,
                                    width: 36,
                                    child: _buildAvatar(
                                        facebookStatusImage:
                                            'images/facebook_icon.png',
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
              ],
            ),
          );
        });
  }

  Widget _buildList() {
    return Column(
      children: [
        Expanded(
          child: ListConversationAnimation(
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
              child: BlocBuilder<ConversationListBloc, ConversationListState>(
                  builder: (context, state) {
                if (state is ConversationWaiting) {
                  return LoadingIndicator();
                }
                if (state is ConversationLoading) {
                  if (_crmTeam == null) {
                    return EmptyDataPage();
                  }
                  return DraggableScrollbar.arrows(
                    alwaysVisibleScrollThumb: false,
                    labelTextBuilder: (double offset) => isChangeList
                        ? Text(
                            (offset ~/ 100 <=
                                    state.getListConservationResult.items
                                            .length -
                                        1)
                                ? DateFormat('hh:mm').format(state
                                    .getListConservationResult
                                    .items[offset ~/ 105]
                                    .lastUpdated)
                                : DateFormat('hh:mm').format(state
                                    .getListConservationResult
                                    .items[state.getListConservationResult.items
                                            .length -
                                        1]
                                    .lastUpdated),
                            style: const TextStyle(color: Colors.white),
                          )
                        : Text(
                            (offset ~/ 110 <=
                                    state.getListConservationResult.items
                                            .length -
                                        1)
                                ? DateFormat('hh:mm').format(state
                                    .getListConservationResult
                                    .items[offset ~/ 110]
                                    .lastUpdated)
                                : DateFormat('hh:mm').format(state
                                    .getListConservationResult
                                    .items[state.getListConservationResult.items
                                            .length -
                                        1]
                                    .lastUpdated),
                            style: const TextStyle(color: Colors.white),
                          ),
                    controller: _scrollController,
                    backgroundColor: const Color(0xFF28A745).withOpacity(0.6),
                    child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.only(top: 0),
                        itemCount: state.getListConservationResult.items.length,
                        itemBuilder: (context, int index) {
                          final Conversation itemConservation =
                              state.getListConservationResult.items[index];
                          return InkWell(
                            onTap: () async {
                              _turnOffOverlay();
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ConversationsMessagePage(
                                            conversation: itemConservation,
                                            crmTeam: _crmTeam,
                                          )));
                              _reload();
                            },
                            child: ConversationItemList(
                              isRowThreeChat: isChangeList,
                              itemConversation: itemConservation,
                              crmTeam: _crmTeam,
                            ),
                          );
                        }),
                  );
                }
                return Container();
              }),
              titleAppBar: BlocBuilder<ConversationFacebookBloc,
                  ConversationFacebookAcountState>(
                builder: (context, state) {
                  if (state is FacebookLoading) {
                    return _buildHeaderAppBar(context, state.facebookAccounts);
                  }
                  if (state is FacebookFailure) {
                    print(state.error);
                  }
                  return _buildHeaderAppBar(context, null);
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
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
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
}
