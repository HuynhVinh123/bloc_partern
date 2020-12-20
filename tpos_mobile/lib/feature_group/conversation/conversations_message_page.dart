import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_emoji_keyboard/flutter_emoji_keyboard.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/app_filter_helper.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_drawer.dart';
import 'package:tpos_mobile/feature_group/conversation/bloc/conservation_message_bloc.dart';
import 'package:tpos_mobile/feature_group/conversation/bloc/conversation_image_bloc.dart';
import 'package:tpos_mobile/feature_group/conversation/bloc/conversation_user_bloc.dart';
import 'package:tpos_mobile/feature_group/conversation/conversation_filter/conversation_filter.dart';
import 'package:tpos_mobile/feature_group/conversation/conversation_filter/conversation_filter_bloc.dart';
import 'package:tpos_mobile/feature_group/conversation/conversation_filter/conversation_filter_event.dart';
import 'package:tpos_mobile/feature_group/conversation/conversation_filter/conversation_filter_state,.dart';

import 'package:tpos_mobile/feature_group/conversation/received_message_widget.dart';
import 'package:tpos_mobile/feature_group/conversation/sended_message_widget.dart';
import 'package:tpos_mobile/widgets/loading_indicator.dart';

class ConversationsMessagePage extends StatefulWidget {
  ConversationsMessagePage({this.conversation, this.crmTeam, this.type});
  Conversation conversation;
  CRMTeam crmTeam;
  String type;
  @override
  _ConversationsMessagePageState createState() =>
      _ConversationsMessagePageState();
}

class _ConversationsMessagePageState extends State<ConversationsMessagePage> {
  ConversationMessageBloc conversationMessageBloc = ConversationMessageBloc();
  ConversationUserBloc conversationUserBloc = ConversationUserBloc();
  ConversationImageBloc conversationImageBloc = ConversationImageBloc();

  final TextEditingController _text = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ConversationFilter _conservationFilter = ConversationFilter();
  ConversationFilterBloc conservationFilterBloc = ConversationFilterBloc();
  var childList = <Widget>[];
  bool _isOpenImage = false;
  bool _isOpenMenu = false;
  bool _isOpenTag = false;
  bool _isEmoji = false;
  List<Asset> images = <Asset>[];
  int count = 0;
  final FocusNode _focus = FocusNode();
  List<AssetEntity> media;

  ///Nhấn vào textfield
  bool selected = false;

  /// ///
  final List<Widget> _mediaList = [];
  final List<Widget> _imageSelects = [];
  int currentPage = 0;
  int lastPage;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ApplicationUser assignedToFacebook;

  ///
  File urlImage;
  _handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        _fetchNewMedia();
      }
    }
  }

  _fetchNewMedia() async {
    lastPage = currentPage;
    var result = await PhotoManager.requestPermission();
    if (result) {
      // success
//load the album list
      List<AssetPathEntity> albums =
          await PhotoManager.getAssetPathList(onlyAll: true);
      media = await albums[0].getAssetListPaged(currentPage, 60);
      List<Widget> temp = [];
      for (var asset in media) {
        temp.add(
          FutureBuilder(
            future: asset.thumbDataWithSize(200, 200),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done)
                return Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Image.memory(
                        snapshot.data,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (asset.type == AssetType.video)
                      const Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 5, bottom: 5),
                          child: Icon(
                            Icons.videocam,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                );
              return Container();
            },
          ),
        );
      }
      setState(() {
        _mediaList.addAll(temp);
        currentPage++;
      });
    } else {
      // fail
      /// if result is fail, you can call `PhotoManager.openSetting();`  to open android/ios applicaton's setting to get permission
    }
  }

  ///
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    assignedToFacebook = widget.conversation.assignedToFacebook;
    _focus.addListener(_onFocusChange);
    _fetchNewMedia();
    conversationMessageBloc.add(ConversationMessageLoaded(
        facebookId: widget.conversation.facebookTposUser.id,
        pageId: widget.crmTeam.facebookPageId,
        type: widget.type ?? 'all',
        page: 1,
        limit: 50));
    conversationUserBloc.add(ConversationLoaded());
    _conservationFilter?.filterDateRange = getTodayDateFilter();
    _conservationFilter?.dateFrom =
        _conservationFilter.filterDateRange?.fromDate;
    _conservationFilter?.dateTo = _conservationFilter.filterDateRange?.toDate;
    conservationFilterBloc.add(ConversationFilterLoaded());
  }

  void _onFocusChange() {
    setState(() {
      selected = !selected;
    });
  }

  void onEmojiSelected(Emoji emoji) {
    _text.text += emoji.text;
  }

  void clearText() => _text.text = '';

  Widget _buildEmoji() {
    return EmojiKeyboard(
      onEmojiSelected: onEmojiSelected,
    );
  }

  Widget _buildItemMenu(
      {String image, LinearGradient linearGradient, String name}) {
    return Column(
      children: [
        const SizedBox(
          height: 25,
        ),
        Container(
            margin: const EdgeInsets.only(right: 5, bottom: 5),
            height: 48,
            width: 48,
            decoration:
                BoxDecoration(gradient: linearGradient, shape: BoxShape.circle),
            child: Center(child: SvgPicture.asset(image))),
        Text(
          name,
          style: const TextStyle(color: Color(0xFF2C333A)),
        ),
      ],
    );
  }

  Widget _buildMenu() {
    return Row(
      children: [
        const SizedBox(
          width: 32,
        ),
        _buildItemMenu(
          image: 'assets/icon/product.svg',
          name: 'Sản phẩm',
          linearGradient: const LinearGradient(
              begin: Alignment(-1.0, 1.0),
              end: Alignment(0.5, -1.0),
              stops: [
                0.5,
                0.9
              ],
              colors: [
                Color(0xff3ba734),
                Color(0xff64ca37),
              ]),
        ),
        const SizedBox(
          width: 32,
        ),
        _buildItemMenu(
          image: 'assets/icon/message.svg',
          name: 'Tin nhắn nhanh',
          linearGradient: const LinearGradient(
              begin: Alignment(-1.0, 1.0),
              end: Alignment(0.5, -1.0),
              stops: [
                0.5,
                0.9
              ],
              colors: [
                Color(0xff2395FF),
                Color(0xff207BD0),
              ]),
        ),
        const SizedBox(
          width: 32,
        ),
        _buildItemMenu(
          image: 'assets/icon/order.svg',
          name: 'Đơn hàng',
          linearGradient: const LinearGradient(
              begin: Alignment(-1.0, 1.0),
              end: Alignment(0.5, -1.0),
              stops: [
                0.5,
                0.9
              ],
              colors: [
                Color(0xffFFC107),
                Color(0xffF3A72E),
              ]),
        ),
      ],
    );
  }

  Widget buildGridView() {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scroll) {
        _handleScrollEvent(scroll);
        return;
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GridView.builder(
              itemCount: media.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 2, mainAxisSpacing: 2),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                    onTap: () async {
                      urlImage = await media[index].file;
                      setState(() {
                        if (!_imageSelects
                            .any((element) => _mediaList[index] == element)) {
                          _imageSelects.add(_mediaList[index]);
                          conversationImageBloc.add(
                              ConversationImagePickerAdded(file: urlImage));
                        } else {
                          _imageSelects.removeWhere(
                              (element) => _mediaList[index] == element);
                        }
                      });
                    },
                    child: Stack(
                      children: [
                        _mediaList[index],
                        if (_imageSelects
                            .any((element) => _mediaList[index] == element))
                          Center(
                              child: Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF28A745),
                            ),
                            child: Center(
                                child: Text(
                              '${_imageSelects.indexWhere((element) => _mediaList[index] == element) + 1}',
                              style: const TextStyle(color: Colors.white),
                            )),
                          ))
                        else
                          const SizedBox(),
                      ],
                    ));
              }),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: FlatButton(
              height: 48,
              minWidth: MediaQuery.of(context).size.width,
              color: const Color(0xFF28A745),
              onPressed: () {
                setState(() {
                  conversationMessageBloc.add(ConversationMessageAdded(
                      facebookId: widget.conversation.facebookTposUser.id,
                      from: TPosFacebookUser(
                          id: widget.crmTeam.facebookPageId,
                          name: widget.crmTeam.name),
                      toId: widget.conversation.facebookTposUser.id,
                      message: _text.text,
                      attachment: Attachment(
                          data:
                              Data(imageData: ImageData(url: urlImage.path)))));
                  _isOpenImage = false;
                });
              },
              child: count != 0
                  ? Text(
                      'Gửi $count',
                      style: const TextStyle(color: Colors.white),
                    )
                  : const Text(
                      'Gửi',
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag() {
    return Container();
  }

//  _scrollToBottom() {
//    _scrollController.animateTo(
//      _scrollController.position.maxScrollExtent,
//      duration: const Duration(seconds: 1),
//      curve: Curves.fastOutSlowIn,
//    );
//  }

  Widget _buildAppbarDetail({ConversationUserState conversationUserState}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 60,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFFA7B2BF),
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pop(context, assignedToFacebook);
                  }),
              Container(
                height: 36,
                width: 36,
                child: const CircleAvatar(
                  radius: 30.0,
                  backgroundImage: AssetImage('images/avatar_tpage.png'),
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.conversation.name ?? '',
                    style:
                        const TextStyle(color: Color(0xFF2C333A), fontSize: 17),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Đã gán cho',
                        style: TextStyle(color: Color(0xFF929DAA)),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Text(
                            assignedToFacebook?.name ?? 'Người dùng',
                            style: const TextStyle(color: Color(0xFF28A745)),
                          ),
                          if (conversationUserState != null)
                            Container(
                              height: 30,
                              child: DropdownButton<ApplicationUser>(
                                underline: Container(),
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Color(0xFF929DAA),
                                  size: 14,
                                ),
                                items: conversationUserState
                                    .applicationUsers.value
                                    .map((ApplicationUser value) {
                                  return DropdownMenuItem<ApplicationUser>(
                                    value: value,
                                    child: Text(value.name),
                                  );
                                }).toList(),
                                onChanged: (user) {
                                  setState(() {
                                    assignedToFacebook = user;
                                  });
                                  conversationUserBloc.add(
                                      ConversationUserAdded(
                                          userId: user.id,
                                          pageId: widget.crmTeam.facebookPageId,
                                          facebookId: widget.conversation
                                              .facebookTposUser.id));
                                },
                              ),
                            )
                          else
                            Container(
                              height: 30,
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Row(
          children: [
            SvgPicture.asset('assets/icon/shopping_cart.svg'),
            IconButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: Color(0xFF858F9B),
                ),
                onPressed: () {
                  scaffoldKey.currentState.openEndDrawer();
                }),
          ],
        ),
      ],
    );
  }

  Widget _buildAppBar({ConversationUserState conversationUserState}) {
    if (conversationUserState is ConversationUserLoad) {
      return _buildAppbarDetail(conversationUserState: conversationUserState);
    }
    return _buildAppbarDetail();
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Flexible(
                child: Container(
                  margin: const EdgeInsets.only(top: 10, left: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(0xFFDFE5E9),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 72,
                  width: 148,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icon/shopping_message.svg',
                      ),
                      const Text(
                        'Tạo đơn hàng',
                        style: TextStyle(color: Color(0xFFa7b2bf)),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(0xFFDFE5E9),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 72,
                  width: 148,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icon/box_message.svg',
                      ),
                      const Text(
                        'Gán sản phẩm',
                        style: TextStyle(color: Color(0xFFa7b2bf)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 50,
            margin: const EdgeInsets.only(left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icon/message_person.svg',
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Khách hàng',
                      style: TextStyle(color: Color(0xFF2C333A), fontSize: 17),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Nguyễn Ngọc',
                      style: TextStyle(color: Color(0xFF929DAA), fontSize: 13),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      'images/telephone.png',
                      height: 13,
                      width: 13,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Image.asset(
                      'images/locattion_tpage.png',
                      height: 13,
                      width: 13,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 13,
                      color: Color(0xFF929DAA),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 50,
            margin: const EdgeInsets.only(left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icon/message_box.svg',
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Sản phẩm',
                      style: TextStyle(color: Color(0xFF2C333A), fontSize: 17),
                    ),
                  ],
                ),
                Row(
                  children: const [
                    Text(
                      'Chưa gán',
                      style: TextStyle(color: Color(0xFF929DAA), fontSize: 13),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 13,
                      color: Color(0xFF929DAA),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 50,
            margin: const EdgeInsets.only(left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icon/message_cart.svg',
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Đơn hàng',
                      style: TextStyle(color: Color(0xFF2C333A), fontSize: 17),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 14),
                      child: Container(
                        height: 23,
                        width: 33,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13.0),
                          color: const Color(0xFF008E30),
                        ),
                        child: const Center(
                            child: Text(
                          '4',
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 13,
                      color: Color(0xFF929DAA),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 12, right: 12),
            child: Divider(
              color: Color(0xFFE9EDF2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPanel() {
    return BlocBuilder<ConversationFilterBloc, ConversationFilterState>(
        cubit: conservationFilterBloc,
        builder: (context, state) {
          if (state is ConversationFilterLoadSuccess) {
            _conservationFilter?.dateFrom = state?.filterFromDate;
            _conservationFilter?.dateTo = state?.filterToDate;
            _conservationFilter?.filterDateRange = state?.filterDateRange;
            return AppFilterDrawerContainer(
              colorHeaderDrawer: Colors.white,
              countFilter: count,
              isDrawerConversation: true,
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
              onApply: () {},
              child: _buildBodyFilterDrawer(state),
            );
          }
          return const SizedBox();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      endDrawer: _buildFilterPanel(),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<ConversationImageBloc>(
            create: (context) => conversationImageBloc,
          ),
          BlocProvider<ConversationMessageBloc>(
            create: (context) => conversationMessageBloc,
          ),
          BlocProvider<ConversationUserBloc>(
            create: (context) => conversationUserBloc,
          ),
        ],
        child: SafeArea(
            child: Container(
          child: Stack(
            fit: StackFit.loose,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisAlignment: MainAxisAlignment.start,
                // mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  BlocBuilder<ConversationUserBloc, ConversationUserState>(
                      builder: (context, state) {
                    return _buildAppBar(conversationUserState: state);
                  }),
                  const Divider(
                    height: 0,
                    color: Colors.black54,
                  ),
                  BlocBuilder<ConversationMessageBloc,
                      ConversationMessageState>(
                    builder: (context, state) {
                      if (state is ConversationMessageLoading) {
//                        WidgetsBinding.instance
//                            .addPostFrameCallback((_) => _scrollToBottom());
                        childList = [];
                        for (int i = 0;
                            i < state.getMessageConversationResult.items.length;
                            i++) {
                          if (state.getMessageConversationResult.items[i]
                                  .fromId !=
                              widget.conversation.facebookTposUser.id) {
                            childList.add(Align(
                              alignment: const Alignment(-1, 0),
                              child: SendedMessageWidget(
                                  content: state.getMessageConversationResult
                                          .items[i].message.message ??
                                      '',
                                  time: DateFormat("dd/MM/yyyy hh:mm").format(
                                      state.getMessageConversationResult
                                          .items[i].createdTime),
                                  isImage: state.getMessageConversationResult
                                          .items[i].attachments !=
                                      null,
                                  imageAddress: 'images/avatar_tpage.png'),
                            ));
                          } else {
                            childList.add(Align(
                              alignment: const Alignment(1, 0),
                              child: ReceivedMessageWidget(
                                content: state.getMessageConversationResult
                                        .items[i].message?.message ??
                                    '',
                                time: DateFormat("dd/MM/yyyy hh:mm").format(
                                    state.getMessageConversationResult.items[i]
                                        .createdTime),
                                isImage: state.getMessageConversationResult
                                        .items[i].attachments !=
                                    null,
                                imageAddress: 'images/avatar_tpage.png',
                              ),
                            ));
                          }
                        }
//                        return Flexible(
//                          fit: FlexFit.tight,
//                          child: Container(
//                            color: Colors.white,
//                            width: MediaQuery.of(context).size.width,
//                            child: SingleChildScrollView(
//                                controller: _scrollController,
//                                // reverse: true,
//                                child: Column(
//                                  crossAxisAlignment: CrossAxisAlignment.start,
//                                  mainAxisAlignment: MainAxisAlignment.start,
//                                  children: childList,
//                                )),
//                          ),
//                        );
                        return Flexible(
                            child: ListView(
                          controller: _scrollController,
                          reverse: true,
                          children: childList,
                        ));
                      } else if (state is ConversationMessageAddSuccess ||
                          state is ConversationMessageAddFailure) {
                        conversationMessageBloc.add(ConversationMessageLoaded(
                            facebookId: widget.conversation.facebookTposUser.id,
                            pageId: widget.crmTeam.facebookPageId,
                            type: widget.type ?? 'all',
                            page: 1,
                            limit: 50));
                      }
                      return Container(
                        color: Colors.white,
                      );
                    },
                  ),
                  const Divider(height: 0, color: Colors.black26),
                  BlocBuilder<ConversationMessageBloc,
                      ConversationMessageState>(
                    builder: (context, state) {
                      if (state is ConversationMessageWaiting) {
                        return Expanded(child: LoadingIndicator());
                      }
                      if (state is ConversationMessageLoading) {
                        return Column(
                          children: [
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(8.0),
                                  itemCount: state.crmTags.value.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        if (state.conversationRefetch
                                            .conversation.tags
                                            .any((element) =>
                                                element.id ==
                                                state
                                                    .crmTags.value[index].id)) {
                                          conversationMessageBloc.add(
                                              ConversationTagAdded(
                                                  pageId: widget
                                                      .crmTeam.facebookPageId,
                                                  action: 'remove',
                                                  tagId: state
                                                      .crmTags.value[index].id,
                                                  facebookId: widget
                                                      .conversation
                                                      .facebookTposUser
                                                      .id));
                                        } else {
                                          conversationMessageBloc.add(
                                              ConversationTagAdded(
                                                  pageId: widget
                                                      .crmTeam.facebookPageId,
                                                  action: 'add',
                                                  tagId: state
                                                      .crmTags.value[index].id,
                                                  facebookId: widget
                                                      .conversation
                                                      .facebookTposUser
                                                      .id));
                                        }
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 5, right: 5),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: state.conversationRefetch
                                                  .conversation.tags
                                                  .any((element) =>
                                                      element.id ==
                                                      state.crmTags.value[index]
                                                          .id)
                                              ? const Color(0xFFF8F9FB)
                                              : Colors.white,
                                        ),
                                        padding: const EdgeInsets.all(4),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  right: 5),
                                              height: 16,
                                              width: 16,
                                              decoration: BoxDecoration(
                                                  color: Color(int.parse(
                                                      '0xFF${state.crmTags.value[index].colorClassName.substring(1, 7)}')),
                                                  shape: BoxShape.circle),
                                            ),
                                            Text(state
                                                .crmTags.value[index].name),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        );
                      } else if (state is ConversationMessageAddSuccess ||
                          state is ConversationMessageAddFailure ||
                          state is ConversationTagAddSuccess) {
                        conversationMessageBloc.add(ConversationMessageLoaded(
                            facebookId: widget.conversation.facebookTposUser.id,
                            pageId: widget.crmTeam.facebookPageId,
                            type: widget.type ?? 'all',
                            page: 1,
                            limit: 50));
                      }
                      return Expanded(
                        child: Container(
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: 50.0,
                      maxHeight: 80.0,
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 16,
                        ),
                        Visibility(
                          visible: !selected,
                          child: InkWell(
                              onTap: () {
                                setState(() {
                                  _isOpenMenu = !_isOpenMenu;
                                  _isOpenImage = false;
                                  _isOpenTag = false;
                                  _isEmoji = false;
                                });
                              },
                              child: SvgPicture.asset(
                                  'assets/icon/menu_green.svg')),
                        ),
                        Visibility(
                          visible: !selected,
                          child: const SizedBox(
                            width: 30,
                          ),
                        ),
                        Visibility(
                          visible: !selected,
                          child: InkWell(
                              onTap: () {
                                setState(() {
                                  _isOpenImage = !_isOpenImage;
                                  _isOpenMenu = false;
                                  _isOpenTag = false;
                                  _isEmoji = false;
                                });
                              },
                              child: SvgPicture.asset(
                                  'assets/icon/image_green.svg')),
                        ),
                        Visibility(
                          visible: !selected,
                          child: const SizedBox(
                            width: 30,
                          ),
                        ),
                        Visibility(
                            visible: !selected,
                            child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _isOpenTag = !_isOpenTag;
                                    _isOpenMenu = false;
                                    _isOpenImage = false;
                                    _isEmoji = false;
                                  });
                                },
                                child: SvgPicture.asset(
                                    'assets/icon/tag_green.svg'))),
                        Visibility(
                            visible: selected,
                            child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Color(0xFF28A745),
                                ),
                                onPressed: () {
                                  setState(() {
                                    selected = false;
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                  });
                                })),
                        Visibility(
                          visible: !selected,
                          child: const SizedBox(
                            width: 16,
                          ),
                        ),
                        Expanded(
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 5),
                            curve: Curves.fastOutSlowIn,
                            decoration: BoxDecoration(
                                color: const Color(0xFFF2F5FA),
                                borderRadius: BorderRadius.circular(21)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 15,
                              ),
                              child: TextField(
                                focusNode: _focus,
                                keyboardType: TextInputType.multiline,
                                maxLength: null,
                                maxLines: null,
                                controller: _text,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Tin nhắn',
                                    hintStyle: const TextStyle(
                                        color: Color(0xFF929DAA)),
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _isEmoji = !_isEmoji;
                                          _isOpenTag = false;
                                          _isOpenMenu = false;
                                          _isOpenImage = false;
                                        });
                                      },
                                      child: const Icon(
                                        Icons.tag_faces,
                                        color: Color(0xFF929DAA),
                                      ),
                                    )),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        InkWell(
                            onTap: () {
                              conversationMessageBloc
                                  .add(ConversationMessageAdded(
                                facebookId:
                                    widget.conversation.facebookTposUser.id,
                                from: TPosFacebookUser(
                                    id: widget.crmTeam.facebookPageId,
                                    name: widget.crmTeam.name),
                                toId: widget.conversation.facebookTposUser.id,
                                message: _text.text,
                              ));
                              _text.clear();
                            },
                            child:
                                SvgPicture.asset('assets/icon/like_green.svg')),
                        const SizedBox(
                          width: 16,
                        ),
                      ],
                    ),
                  ),
                  if (_isOpenImage)
                    Expanded(
                      child: buildGridView(),
                    ),
                  if (_isOpenMenu) Expanded(child: _buildMenu()),
                  if (_isOpenTag) Expanded(child: _buildTag()),
                  if (_isEmoji) Expanded(child: _buildEmoji()),
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }
}
