import 'dart:io';
import 'package:badges/badges.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_emoji_keyboard/flutter_emoji_keyboard.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/app_core/helper/app_filter_helper.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/feature_group/conversation/bloc/conversation_detail_bloc.dart';
import 'package:tpos_mobile/feature_group/conversation/bloc/conversation_fs_order_bloc.dart';
import 'package:tpos_mobile/feature_group/conversation/bloc/conversation_image_bloc.dart';
import 'package:tpos_mobile/feature_group/conversation/bloc/conversation_mail_template_bloc.dart';
import 'package:tpos_mobile/feature_group/conversation/bloc/conversation_note_bloc.dart';
import 'package:tpos_mobile/feature_group/conversation/bloc/conversation_product_bloc.dart';
import 'package:tpos_mobile/feature_group/conversation/bloc/conversation_tag_bloc.dart';
import 'package:tpos_mobile/feature_group/conversation/bloc/conversation_user_bloc.dart';
import 'package:tpos_mobile/feature_group/conversation/conversation_filter/conversation_filter.dart';
import 'package:tpos_mobile/feature_group/conversation/conversation_filter/conversation_filter_bloc.dart';
import 'package:tpos_mobile/feature_group/conversation/conversation_filter/conversation_filter_event.dart';
import 'package:tpos_mobile/feature_group/conversation/page/conversation_partner_edit_page.dart';
import 'package:tpos_mobile/feature_group/conversation/page/conversation_product_edit_page.dart';
import 'package:tpos_mobile/feature_group/conversation/widget/received_message_widget.dart';
import 'package:tpos_mobile/feature_group/conversation/widget/sended_message_widget.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/load_status.dart';
import 'package:tpos_mobile/widgets/loading_indicator.dart';
import 'package:tpos_mobile_localization/generated/l10n.dart';

class ConversationDetailPage extends StatefulWidget {
  const ConversationDetailPage({this.conversation, this.crmTeam, this.type});
  final Conversation conversation;
  final CRMTeam crmTeam;

  ///type= message,comment,all
  final String type;
  @override
  _ConversationDetailPageState createState() => _ConversationDetailPageState();
}

class _ConversationDetailPageState extends State<ConversationDetailPage>
    with SingleTickerProviderStateMixin {
  final RefreshController _refreshMessageController =
      RefreshController(initialRefresh: false);

  ///Animation Image
  Animation<double> animation;
  AnimationController controller;

  ///Bloc
  ConversationDetailBloc conversationMessageBloc = ConversationDetailBloc();
  ConversationUserBloc conversationUserBloc = ConversationUserBloc();
  ConversationImageBloc conversationImageBloc = ConversationImageBloc();
  ConversationTagBloc conversationTagBloc = ConversationTagBloc();
  ConversationProductBloc conversationProductBloc = ConversationProductBloc();
  ConversationMailTemplateBloc conversationMailTemplateBloc =
      ConversationMailTemplateBloc();
  ConversationNoteBloc conversationNoteBloc = ConversationNoteBloc();
  ConversationFsOrderBloc conversationFsOrderBloc = ConversationFsOrderBloc();
  ConversationFilterBloc conservationFilterBloc = ConversationFilterBloc();
  final ConversationFilter _conservationFilter = ConversationFilter();
  final TextEditingController _textMessage = TextEditingController();
  final TextEditingController _textSearch = TextEditingController();
  final TextEditingController _textNote = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  ///Lựa chọn dưới menu tin nhắn
  bool _isOpenImage = false;
  bool _isOpenMenu = false;
  bool _isEmoji = false;
  bool isRemove = false;
  bool isTextOneLine = false;
  List<Data> attachments = [];
  var childList = <Widget>[];
  int skip = 0;
  bool isIconSend = false;
  int count = 0;

  ///Focus input Tin nhắn
  final FocusNode _focus = FocusNode();

  ///Trả giá trị về màn hình trước
  List<dynamic> listPop = [];

  ///Giá trị trả về màn hình trước
  OdataListResult<CRMTag> crmTmpTags;
  ApplicationUser applicationUser;

  ///Nhấn vào textfield
  bool selected = false;

  /// Xử lí hình
  List<Asset> images = <Asset>[];
  List<AssetEntity> media;
  final List<Widget> _mediaList = [];
  List<Widget> _imageSelects = [];
  List<Widget> _imagePostApi = [];

  ///Danh sách tag
  List<TagStatusFacebook> tmpTags = [];
  List<TagStatusFacebook> newTmpTags = [];

  ///Chọn tin nhắn xem ai gửi
  int indexSeenMessage;
  File urlImage;
  List<File> listUrl = [];
  int currentPage = 0;
  int lastPage;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  ///Click ghi chú hội thoại
  bool isClickNote = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      endDrawer: _buildFilterPanel(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          setState(() {
            _isOpenImage = false;
            _isOpenMenu = false;
            _isEmoji = false;
            selected = false;
            isIconSend = false;
            isTextOneLine = true;
          });
        },
        child: MultiBlocProvider(
          providers: [
            BlocProvider<ConversationFsOrderBloc>(
              create: (context) => conversationFsOrderBloc,
            ),
            BlocProvider<ConversationMailTemplateBloc>(
              create: (context) => conversationMailTemplateBloc,
            ),
            BlocProvider<ConversationProductBloc>(
              create: (context) => conversationProductBloc,
            ),
            BlocProvider<ConversationImageBloc>(
              create: (context) => conversationImageBloc,
            ),
            BlocProvider<ConversationDetailBloc>(
              create: (context) => conversationMessageBloc,
            ),
            BlocProvider<ConversationUserBloc>(
              create: (context) => conversationUserBloc,
            ),
            BlocProvider<ConversationTagBloc>(
              create: (context) => conversationTagBloc,
            ),
            BlocProvider<ConversationNoteBloc>(
              create: (context) => conversationNoteBloc,
            ),
          ],
          child: SafeArea(
            child: Stack(
              children: <Widget>[
                Container(
                  child: Stack(
                    fit: StackFit.loose,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //mainAxisAlignment: MainAxisAlignment.start,
                        // mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          BlocBuilder<ConversationUserBloc,
                              ConversationUserState>(builder: (context, state) {
                            return _buildAppBar(conversationUserState: state);
                          }),
                          const Divider(
                            height: 0,
                            color: Colors.black54,
                          ),
                          BlocConsumer<ConversationDetailBloc,
                              ConversationDetailState>(
                            listener: (context, state) {
                              if (state is ConversationDetailFailure ||
                                  state is ConversationDetailAddFailure) {
                                App.showDefaultDialog(
                                  title: S.current.warning,
                                  content: state.error,
                                  type: AlertDialogType.warning,
                                  context: context,
                                );
                              }
                            },
                            builder: (context, state) {
                              if (state is ConversationDetailLoading) {
                                if (widget.type != 'comment') {
                                  childList = [];
                                  for (int i = 0;
                                      i <
                                          state.getMessageConversationResult
                                              .items.length;
                                      i++) {
                                    if (state.getMessageConversationResult
                                            .items[i].fromId !=
                                        widget
                                            .conversation.facebookTposUser.id) {
                                      if (state
                                              .getMessageConversationResult
                                              .items[i]
                                              .message
                                              ?.attachment
                                              ?.data !=
                                          null) {
                                        _imagePostApi = [];
                                        for (int j = 0;
                                            j <
                                                state
                                                    .getMessageConversationResult
                                                    .items[i]
                                                    .message
                                                    .attachment
                                                    .data
                                                    .length;
                                            j++) {
                                          _imagePostApi.add(ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.network(
                                              state
                                                  .getMessageConversationResult
                                                  .items[i]
                                                  .message
                                                  .attachment
                                                  .data[j]
                                                  .imageData
                                                  .url,
                                            ),
                                          ));
                                        }
                                      }

                                      childList.add(Align(
                                        alignment: const Alignment(-1, 0),
                                        child: SendedMessageWidget(
                                          messageConversation: state
                                              .getMessageConversationResult
                                              .items[i],
                                          index: i,
                                          indexMessage: indexSeenMessage,
                                          content: state
                                                  .getMessageConversationResult
                                                  .items[i]
                                                  ?.message
                                                  ?.message ??
                                              '',
                                          time: DateFormat(
                                                  "dd/MM/yyyy HH:mm:ss")
                                              .format(state
                                                  .getMessageConversationResult
                                                  .items[i]
                                                  .createdTime
                                                  .add(const Duration(
                                                      hours: 7))),
                                          isImage: state
                                                  .getMessageConversationResult
                                                  .items[i]
                                                  ?.message
                                                  ?.attachment !=
                                              null,
                                          imageAddress: widget
                                                  ?.crmTeam?.facebookPageLogo ??
                                              'images/avatar_tpage.png',
                                          imagesSelects: _imagePostApi,
                                          crmTeam: widget.crmTeam,
                                        ),
                                      ));
                                    } else {
                                      childList.add(Align(
                                        alignment: const Alignment(1, 0),
                                        child: ReceivedMessageWidget(
                                          messageConversation: state
                                              .getMessageConversationResult
                                              .items[i],
                                          index: i,
                                          indexMessage: indexSeenMessage,
                                          content: state
                                                  .getMessageConversationResult
                                                  .items[i]
                                                  .message
                                                  ?.message ??
                                              '',
                                          time: DateFormat(
                                                  "dd/MM/yyyy HH:mm:ss")
                                              .format(state
                                                  .getMessageConversationResult
                                                  .items[i]
                                                  .createdTime
                                                  .add(const Duration(
                                                      hours: 7))),
                                          isImage: state
                                                  .getMessageConversationResult
                                                  .items[i]
                                                  ?.message
                                                  ?.attachment !=
                                              null,
                                          imageAddress:
                                              'https://graph.facebook.com/${widget.conversation?.psid}/picture?access_token=${widget.crmTeam?.facebookPageToken}',
                                          imagesSelects: _imagePostApi,
                                        ),
                                      ));
                                    }
                                  }

                                  return Flexible(
                                      child: ListView.builder(
                                    itemCount: childList.length,
                                    controller: _scrollController,
                                    reverse: true,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                          onTap: () {
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                            setState(() {
                                              _isOpenImage = false;
                                              _isOpenMenu = false;
                                              isIconSend = false;
                                              _isEmoji = false;
                                              selected = false;
                                              isTextOneLine = true;
                                            });
                                            setState(() {
                                              if (indexSeenMessage == index) {
                                                indexSeenMessage = null;
                                              } else {
                                                indexSeenMessage = index;
                                              }
                                            });
                                          },
                                          child: childList[index]);
                                    },
                                  ));
                                } else {
                                  if (state.getMessageConversationResult.extras
                                      .posts.isEmpty) {
                                  } else {
                                    return Expanded(
                                      child: ListView.builder(
                                        itemCount: state
                                            .getMessageConversationResult
                                            .extras
                                            .posts
                                            ?.length,
                                        controller: _scrollController,
                                        itemBuilder: (context, index) {
                                          return _buildPost(
                                              context: context,
                                              state: state,
                                              index: index);
                                        },
                                      ),
                                    );
                                  }
                                }
                              }
                              return Expanded(
                                child: Container(
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                          BlocConsumer<ConversationTagBloc,
                              ConversationTagState>(listener: (context, state) {
                            if (state is ConversationTagAddFailure) {}
                          }, builder: (context, state) {
                            return _buildListTag(state);
                          }),
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              minHeight: 30.0,
                              maxHeight: 80.0,
                            ),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 5,
                                ),
                                Visibility(
                                    visible: !selected,
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _isOpenMenu = true;
                                          _isOpenImage = false;
                                          _isEmoji = false;
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                        });
                                      },
                                      icon: SvgPicture.asset(
                                          'assets/icon/menu_green.svg'),
                                    )),
                                Visibility(
                                    visible: !selected,
                                    child: IconButton(
                                      onPressed: () {
                                        count++;
                                        if (count == 0 || count == 1) {
                                          _fetchNewMedia();
                                        }
                                        setState(() {
                                          _isOpenImage = true;
                                          _isOpenMenu = false;
                                          _isEmoji = false;
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                        });
                                      },
                                      icon: SvgPicture.asset(
                                          'assets/icon/image_green.svg'),
                                    )),
                                Visibility(
                                    visible: !selected,
                                    child: IconButton(
                                      onPressed: () {
                                        buildTagBottomSheet(context);
                                        conversationTagBloc
                                            .add(ConversationTagLoaded());
                                        setState(() {
                                          _isOpenMenu = false;
                                          _isOpenImage = false;
                                          _isEmoji = false;
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                        });
                                      },
                                      icon: SvgPicture.asset(
                                          'assets/icon/tag_green.svg'),
                                    )),
                                if (selected)
                                  IconButton(
                                      icon: const Icon(
                                        Icons.arrow_forward_ios,
                                        color: Color(0xFF28A745),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          selected = false;
                                          isIconSend = false;
                                          isTextOneLine = true;
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                        });
                                      }),
                                Visibility(
                                  visible: !selected,
                                  child: const SizedBox(
                                    width: 5,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: AnimatedContainer(
                                      duration: const Duration(seconds: 5),
                                      curve: Curves.fastOutSlowIn,
                                      decoration: BoxDecoration(
                                          color: const Color(0xFFF2F5FA),
                                          borderRadius:
                                              BorderRadius.circular(21)),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Stack(
                                          alignment: Alignment.centerRight,
                                          children: <Widget>[
                                            TextField(
                                              focusNode: _focus,
                                              maxLength: null,
                                              maxLines:
                                                  isTextOneLine ? 1 : null,
                                              controller: _textMessage,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        right: 32),
                                                border: InputBorder.none,
                                                hintText: S.current.message,
                                                hintStyle: const TextStyle(
                                                  color: Color(0xFF929DAA),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20),
                                              child: IconButton(
                                                icon: const Icon(
                                                  Icons.tag_faces,
                                                  color: Color(0xFF929DAA),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    selected = true;
                                                    _isEmoji = true;
                                                    isIconSend = true;
                                                    _isOpenMenu = false;
                                                    _isOpenImage = false;
                                                    isTextOneLine = false;
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            FocusNode());
                                                  });

                                                  // Your codes...
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                IconButton(
                                  onPressed: () {
                                    _sendImageMessage();
                                  },
                                  icon: isIconSend == false
                                      ? SvgPicture.asset(
                                          'assets/icon/like_green.svg')
                                      : const Icon(
                                          Icons.send,
                                          color: Color(0xFF28A745),
                                        ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                          ),
                          if (_isOpenMenu)
                            Container(height: 228, child: _buildMenu()),
                          if (_isEmoji) Expanded(child: _buildEmoji()),
                          if (_isOpenImage) Expanded(child: Container()),
                        ],
                      ),
                    ],
                  ),
                ),
                if (_isOpenImage)
                  DraggableScrollableSheet(
                    initialChildSize: 0.38,
                    minChildSize: 0.38,
                    maxChildSize: 0.92,
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      return Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            if (media != null)
                              Expanded(
                                  child: BlocConsumer<ConversationImageBloc,
                                      ConversationImageState>(
                                cubit: conversationImageBloc,
                                listener: (context, state) {
                                  if (state
                                      is ConversationImageLoadAddSuccess) {
                                    attachments.add(Data(
                                        imageData: ImageData(
                                            url: state.urlImage.substring(1,
                                                state.urlImage.length - 1))));

                                    if (attachments.length == listUrl.length) {
                                      conversationMessageBloc.add(
                                          ConversationDetailAdded(
                                              facebookId: widget.conversation
                                                  .facebookTposUser.id,
                                              from: TPosFacebookUser(
                                                  id: widget
                                                      .crmTeam.facebookPageId,
                                                  name: widget.crmTeam.name),
                                              toId: widget.conversation
                                                  .facebookTposUser.id,
                                              message: _textMessage.text,
                                              attachments:
                                                  Attachment(data: attachments),
                                              pageId:
                                                  widget.crmTeam.facebookPageId,
                                              type: widget.type ?? 'all',
                                              page: 1,
                                              limit: 50));
                                      setState(() {
                                        _imageSelects = [];
                                        listUrl = [];
                                        attachments = [];
                                      });
                                    }
                                  }
                                },
                                builder: (context, state) {
                                  return buildGridView(scrollController);
                                },
                              )),
                          ],
                        ),
                      );
                    },
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _sendImageMessage() {
    if (_imageSelects.isNotEmpty) {
      for (int i = 0; i < listUrl.length; i++) {
        conversationImageBloc
            .add(ConversationImagePickerAdded(file: listUrl[i]));
      }
    } else {
      conversationMessageBloc.add(ConversationDetailAdded(
          facebookId: widget.conversation.facebookTposUser.id,
          from: TPosFacebookUser(
              id: widget.crmTeam.facebookPageId, name: widget.crmTeam.name),
          toId: widget.conversation.facebookTposUser.id,
          message: _textMessage.text,
          pageId: widget.crmTeam.facebookPageId,
          type: widget.type ?? 'all',
          page: 1,
          limit: 50));
    }

    _textMessage.clear();
  }

  Future<void> _fetchNewMedia() async {
    lastPage = currentPage;

    ///load the album list
    final List<AssetPathEntity> albums =
        await PhotoManager.getAssetPathList(onlyAll: true);
    if (albums.isNotEmpty) {
      media = await albums[0].getAssetListPaged(currentPage, 60);
      final List<Widget> temp = [];
      for (final asset in media) {
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
    }
  }

  ///
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tmpTags = widget.conversation.tags;
    for (int i = 0; i < tmpTags.length; i++) {
      newTmpTags.add(tmpTags[i]);
    }

    ///
    applicationUser = widget.conversation.assignedToFacebook;
    _focus.addListener(_onFocusChange);

    ///bloc
    conversationMessageBloc.add(ConversationDetailLoaded(
        facebookId: widget.conversation?.psid,
        pageId: widget.crmTeam.facebookPageId,
        type: widget.type ?? 'all',
        page: 1,
        limit: 50));
    conversationNoteBloc.add(ConversationNoteLoaded(
      facebookId: widget.crmTeam.facebookPageId,
      pageId: widget.crmTeam.facebookPageId,
    ));

    conversationMailTemplateBloc.add(ConversationMailTemplateLoaded());
    conversationTagBloc.add(ConversationTagLoaded());
    conversationUserBloc.add(ConversationUserLoaded());
    conversationFsOrderBloc.add(
        ConversationFsOrderLoaded(partnerId: widget?.conversation?.partnerId));
    conservationFilterBloc.add(ConversationFilterLoaded());
    conversationProductBloc.add(ConversationProductLoaded(
        facebookId: widget.crmTeam.facebookPageId, limit: 10, skip: 0));

    ///filter
    _conservationFilter?.filterDateRange = getTodayDateFilter();
    _conservationFilter?.dateFrom =
        _conservationFilter.filterDateRange?.fromDate;
    _conservationFilter?.dateTo = _conservationFilter.filterDateRange?.toDate;

    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animation = Tween<double>(begin: 0, end: 50)
        .chain(CurveTween(curve: Curves.fastOutSlowIn))
        .animate(controller)
          ..addListener(() {
            setState(() {});
          });
  }

  void _onFocusChange() {
    setState(() {
      _textMessage.selection = TextSelection.fromPosition(
          TextPosition(offset: _textMessage.text.length));

      _isOpenImage = false;
      _isOpenMenu = false;
      _isEmoji = false;
      if (!_focus.hasFocus) {
        isTextOneLine = true;
        selected = false;
        isIconSend = false;
      } else {
        isTextOneLine = false;
        selected = true;
        isIconSend = true;
      }
    });
  }

  @override
  void dispose() {
    _scrollController
        .dispose(); // it is a good practice to dispose the controller
    super.dispose();
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
        isCheckTag: _conservationFilter.isCheckTag));
  }

  void clearText() => _textMessage.text = '';

  Widget _buildEmoji() {
    return EmojiKeyboard(
      onEmojiSelected: (Emoji emoji) {
        _textMessage.text += emoji.text;
        _textMessage.selection = TextSelection.fromPosition(
            TextPosition(offset: _textMessage.text.length));
      },
    );
  }

  Widget _buildItemMenu(
      {String image,
      LinearGradient linearGradient,
      String name,
      VoidCallback onPress}) {
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
            child: InkWell(
                onTap: () {
                  onPress();
                },
                child: Center(child: SvgPicture.asset(image)))),
        Text(
          name,
          style: const TextStyle(color: Color(0xFF2C333A)),
        ),
      ],
    );
  }

  Widget _buildSearch({String title = '', VoidCallback onSearch}) {
    return Container(
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 248, 249, 251),
          borderRadius: BorderRadius.circular(24)),
      height: 40,
      width: 200,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(width: 12),
            const Icon(Icons.search, color: Color(0xFF5A6271)),
            Expanded(
              child: Center(
                child: Container(
                    height: 35,
                    margin: const EdgeInsets.only(left: 4),
                    child: Center(
                      child: TextField(
                        controller: _textSearch,
                        style: const TextStyle(
                            color: Color(0xFF929DAA), fontSize: 14),
                        decoration: InputDecoration.collapsed(
                            hintText: title,
                            hintStyle:
                                const TextStyle(color: Color(0xFF929DAA)),
                            border: InputBorder.none),
                        onChanged: (value) {
                          onSearch();
                        },
                      ),
                    )),
              ),
            ),
            Visibility(
              visible: _textSearch.text != "",
              child: Row(
                children: [
                  IconButton(
                    constraints: const BoxConstraints(
                      minWidth: 24,
                      minHeight: 48,
                    ),
                    padding: const EdgeInsets.all(0.0),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 19,
                    ),
                    onPressed: () {
                      _textSearch.text = '';
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10, left: 5),
                    child: VerticalDivider(
                      width: 1,
                      color: Color.fromARGB(79, 207, 253, 190),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 8,
            ),
          ],
        ),
      ),
    );
  }

  /// Bottom sheet Sản phẩm
  void _buildBottomSheetProduct(BuildContext context) {
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ListTile(
                        title: Center(
                          child: Text(
                            S.current.product,
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
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, top: 12, bottom: 16, right: 20),
                    child: Row(
                      children: [
                        Expanded(
                            child: _buildSearch(
                                title: S.current.searchProduct,
                                onSearch: () {
                                  conversationProductBloc.add(
                                      ConversationProductLoaded(
                                          facebookId:
                                              widget.crmTeam.facebookPageId,
                                          limit: 10,
                                          skip: 0,
                                          keyword: _textSearch.text));
                                })),
                        const SizedBox(
                          width: 10,
                        ),
                        ClipOval(
                          child: Container(
                            height: 40,
                            width: 40,
                            child: Material(
                              color: const Color.fromARGB(255, 248, 249, 251),
                              child: IconButton(
                                splashColor: Colors.green,
                                tooltip: S.of(context).horizontalList,
                                icon: const Icon(
                                  FontAwesomeIcons.list,
                                  color: Color.fromARGB(255, 107, 114, 128),
                                  size: 20,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Badge(
                          position: const BadgePosition(top: 4, end: -4),
                          padding: const EdgeInsets.all(4),
                          badgeColor: Colors.redAccent,
                          badgeContent: const Text(
                            '1',
                            style: TextStyle(color: Colors.white),
                          ),
                          child: ClipOval(
                            child: Container(
                              height: 40,
                              width: 40,
                              child: Material(
                                color: const Color.fromARGB(255, 248, 249, 251),
                                child: IconButton(
                                  splashColor: Colors.green,
                                  tooltip: S.of(context).horizontalList,
                                  icon:
                                      SvgPicture.asset('assets/icon/sort.svg'),
                                  onPressed: () {},
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  BlocBuilder<ConversationProductBloc,
                          ConversationProductState>(
                      cubit: conversationProductBloc,
                      builder: (context, state) {
                        if (state is ConversationProductWating) {
                          return const Expanded(child: LoadingIndicator());
                        } else if (state is ConversationProductEmpty) {
                          return Center(
                              child: LoadStatusWidget.empty(
                                  statusName: S.of(context).noData,
                                  content: S.of(context).emptyNotificationParam(
                                      S.of(context).product.toLowerCase())));
                        } else if (state is ConversationProductFailure) {
                          return Column(
                            children: [
                              SizedBox(
                                  height: 50 *
                                      (MediaQuery.of(context).size.height /
                                          700)),
                              LoadStatusWidget(
                                statusName: S.of(context).loadDataError,
                                content: state.error,
                                statusIcon: SvgPicture.asset(
                                    'assets/icon/error.svg',
                                    width: 170,
                                    height: 130),
                                action: AppButton(
                                  onPressed: () {
                                    conversationProductBloc.add(
                                        ConversationProductLoaded(
                                            facebookId:
                                                widget.crmTeam.facebookPageId,
                                            limit: 10,
                                            skip: 0));
                                  },
                                  width: 180,
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 40, 167, 69),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(24)),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                        } else if (state is ConversationProductLoading ||
                            state is ConversationProductLoadNoMore) {
                          _refreshMessageController.loadComplete();
                          return Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: SmartRefresher(
                                controller: _refreshMessageController,
                                header: CustomHeader(
                                  builder: (BuildContext context,
                                      RefreshStatus mode) {
                                    Widget body;
                                    if (mode == RefreshStatus.idle) {
                                      body = const Text(
                                        'Kéo xuống để lấy dữ liệu',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black12,
                                        ),
                                      );
                                    } else if (mode ==
                                        RefreshStatus.canRefresh) {
                                      body = const Text(
                                        'Thả ra để lấy lại dữ liệu',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black12,
                                        ),
                                      );
                                    }
                                    return Container(
                                      height: 50,
                                      child: Center(child: body),
                                    );
                                  },
                                ),
                                onLoading: () {
                                  skip += 10;
                                  conversationProductBloc.add(
                                      ConversationProductLoadedMore(
                                          facebookId:
                                              widget.crmTeam.facebookPageId,
                                          limit: 10,
                                          skip: skip));
                                },
                                footer: CustomFooter(
                                  builder:
                                      (BuildContext context, LoadStatus mode) {
                                    Widget body;
                                    if (mode == LoadStatus.idle) {
                                      body = const Text(
                                        'Kéo lên để lấy thêm dữ liệu',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black12,
                                        ),
                                      );
                                    } else if (mode == LoadStatus.loading) {
                                      body = const LoadingIndicator();
                                    } else if (mode == LoadStatus.canLoading) {
                                      body = const Text(
                                        'Thả ra để lấy lại dữ liệu',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black12,
                                        ),
                                      );
                                    } else {
                                      body = const Text(
                                        'Không còn dữ liệu',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black12,
                                        ),
                                      );
                                    }
                                    return Container(
                                      height: 50,
                                      child: Center(child: body),
                                    );
                                  },
                                ),
                                enablePullDown: false,
                                enablePullUp: true,
                                child: GridView.builder(
                                    shrinkWrap: true,
                                    itemCount: state.products.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 10),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final Product product =
                                          state.products[index];
                                      return InkWell(
                                        onTap: () {
                                          conversationMessageBloc.add(
                                              ConversationProductAdded(
                                                  facebookId: widget
                                                      .conversation
                                                      .facebookTposUser
                                                      .id,
                                                  pageId: widget
                                                      .crmTeam.facebookPageId,
                                                  toId: widget.conversation
                                                      .facebookTposUser.id,
                                                  type: widget.type ?? 'all',
                                                  product: Product(
                                                      id: product.id,
                                                      name: product.name,
                                                      price: product.price,
                                                      picture:
                                                          product.imageUrl),
                                                  page: 1,
                                                  limit: 50));
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                            width: 184,
                                            height: 184,
                                            decoration: const BoxDecoration(
                                                border: Border(
                                              right: BorderSide(
                                                color: Color(0xFFF2F4F7),
                                                width: 1.0,
                                              ),
                                              bottom: BorderSide(
                                                color: Color(0xFFF2F4F7),
                                                width: 1.0,
                                              ),
                                            )),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                if (product.imageUrl != null)
                                                  Flexible(
                                                    child: product.imageUrl !=
                                                            ''
                                                        ? Image.network(
                                                            product.imageUrl,
                                                            width: 186,
                                                            fit: BoxFit.fill,
                                                          )
                                                        : Container(
                                                            width: 186,
                                                            color: const Color(
                                                                0xFFF2F5FA),
                                                          ),
                                                  )
                                                else
                                                  Flexible(
                                                    child: Container(
                                                      width: 186,
                                                      color: const Color(
                                                          0xFFF2F5FA),
                                                    ),
                                                  ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8,
                                                          bottom: 2,
                                                          left: 9,
                                                          right: 15),
                                                  child: Text(
                                                    product.name,
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xFF2C333A),
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 9, bottom: 17),
                                                  child: Text(
                                                    vietnameseCurrencyFormat(
                                                        product.price ?? 0),
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xFF929DAA),
                                                        fontSize: 14),
                                                  ),
                                                ),
                                              ],
                                            )),
                                      );
                                    }),
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      }),
                ],
              ),
            ),
          );
        });
  }

  void buildBottomSheetFsOrder(BuildContext context) {
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
                            S.current.saleCoupon,
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
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, top: 12, bottom: 16, right: 20),
                    child: Row(
                      children: [
                        Expanded(
                            child: _buildSearch(
                                title: S.current.searchSaleCoupon,
                                onSearch: () {})),
                        const SizedBox(
                          width: 10,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Badge(
                          position: const BadgePosition(top: 4, end: -4),
                          padding: const EdgeInsets.all(4),
                          badgeColor: Colors.redAccent,
                          badgeContent: const Text(
                            '1',
                            style: TextStyle(color: Colors.white),
                          ),
                          child: ClipOval(
                            child: Container(
                              height: 40,
                              width: 40,
                              child: Material(
                                color: const Color.fromARGB(255, 248, 249, 251),
                                child: IconButton(
                                  splashColor: Colors.green,
                                  tooltip: S.of(context).horizontalList,
                                  icon:
                                      SvgPicture.asset('assets/icon/sort.svg'),
                                  onPressed: () {},
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  BlocBuilder<ConversationFsOrderBloc,
                          ConversationFsOrderState>(
                      cubit: conversationFsOrderBloc,
                      builder: (context, state) {
                        if (state is ConversationFsOrderWating) {
                          return const Expanded(child: LoadingIndicator());
                        }
                        if (state is ConversationFsOrderFailure) {
                          return Column(
                            children: [
                              SizedBox(
                                  height: 50 *
                                      (MediaQuery.of(context).size.height /
                                          700)),
                              LoadStatusWidget(
                                statusName: S.of(context).loadDataError,
                                content: state.error,
                                statusIcon: SvgPicture.asset(
                                    'assets/icon/error.svg',
                                    width: 170,
                                    height: 130),
                                action: AppButton(
                                  onPressed: () {
                                    conversationFsOrderBloc.add(
                                        ConversationFsOrderLoaded(
                                            partnerId: widget
                                                ?.conversation?.partnerId));
                                  },
                                  width: 180,
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 40, 167, 69),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(24)),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                        if (state is ConversationFsOrderEmpty) {
                          return Center(
                              child: LoadStatusWidget.empty(
                                  statusName: S.of(context).noData,
                                  content: S.of(context).emptyNotificationParam(
                                      S.of(context).saleCoupon.toLowerCase())));
                        }
                        if (state is ConversationFsOrderLoading) {
                          return Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: state.fastSaleOrders.value.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      conversationMessageBloc.add(
                                          ConversationProductAdded(
                                              facebookId: widget.conversation
                                                  .facebookTposUser.id,
                                              pageId:
                                                  widget.crmTeam.facebookPageId,
                                              toId: widget.conversation
                                                  .facebookTposUser.id,
                                              type: widget.type ?? 'all',
                                              fsOrder: FastSaleOrder(
                                                  id: state.fastSaleOrders
                                                      .value[index].id),
                                              page: 1,
                                              limit: 50));
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 16, right: 16, bottom: 11),
                                        color: const Color(0xFFF0F1F3),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 13,
                                              top: 10,
                                              bottom: 10,
                                              right: 13),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Text(
                                                  state.fastSaleOrders
                                                          .value[index].number
                                                          .toUpperCase() ??
                                                      '',
                                                  style: const TextStyle(
                                                      color: Color(0xFF28A745),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 17),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 6,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5, right: 5),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      state
                                                              .fastSaleOrders
                                                              .value[index]
                                                              .phone
                                                              .toString() ??
                                                          '',
                                                      style: const TextStyle(
                                                          color:
                                                              Color(0xFF2C333A),
                                                          fontSize: 15),
                                                    ),
                                                    Container(
                                                      height: 12,
                                                      width: 1,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 5,
                                                              right: 5),
                                                      color: const Color(
                                                          0xFF929DAA),
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        state
                                                                .fastSaleOrders
                                                                .value[index]
                                                                .address ??
                                                            '',
                                                        style: const TextStyle(
                                                            color: Color(
                                                                0xFF929DAA),
                                                            fontSize: 15),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5, top: 8, bottom: 3),
                                                child: Text(
                                                  DateFormat('dd/MM/yyyy HH:mm')
                                                          .format(state
                                                              .fastSaleOrders
                                                              .value[index]
                                                              .dateCreated) ??
                                                      '',
                                                  style: const TextStyle(
                                                      color: Color(0xFF2C333A),
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Container(
                                                height: 1,
                                                margin: const EdgeInsets.only(
                                                    top: 10,
                                                    bottom: 10,
                                                    right: 5,
                                                    left: 5),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                color: const Color(0xFFCDD3DB),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                                .only(
                                                            left: 5, right: 5),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: state
                                                                      .fastSaleOrders
                                                                      .value[
                                                                          index]
                                                                      .showState ==
                                                                  'Nháp'
                                                              ? const Color(
                                                                  0xFF858F9B)
                                                              : const Color(
                                                                  0xFF28A745),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 4,
                                                                bottom: 4,
                                                                right: 10,
                                                                left: 10),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right: 5),
                                                              height: 7,
                                                              width: 7,
                                                              decoration: const BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  shape: BoxShape
                                                                      .circle),
                                                            ),
                                                            Text(
                                                              state
                                                                  .fastSaleOrders
                                                                  .value[index]
                                                                  .showState,
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Text(
                                                        state
                                                                    .fastSaleOrders
                                                                    .value[
                                                                        index]
                                                                    .productQuantity
                                                                    .toInt()
                                                                    .toString() +
                                                                ' ${S.current.product}' ??
                                                            '',
                                                        style: const TextStyle(
                                                            color: Color(
                                                                0xFF2395FF),
                                                            fontSize: 15),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 5),
                                                    child: Text(
                                                      vietnameseCurrencyFormat(state
                                                                  .fastSaleOrders
                                                                  .value[index]
                                                                  .amountTotal) +
                                                              ' đ' ??
                                                          '',
                                                      style: const TextStyle(
                                                          color:
                                                              Color(0xFF5A6271),
                                                          fontSize: 15),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )),
                                  );
                                }),
                          );
                        }
                        return Container();
                      }),
                ],
              ),
            ),
          );
        });
  }

  void buildBottomSheetMailTemplate(BuildContext context) {
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
                            S.current.fastMessage,
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
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, top: 12, bottom: 16, right: 20),
                    child: Row(
                      children: [
                        Expanded(
                            child: _buildSearch(
                                title: S.current.searchFastMessage,
                                onSearch: () {})),
                        const SizedBox(
                          width: 10,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Badge(
                          position: const BadgePosition(top: 4, end: -4),
                          padding: const EdgeInsets.all(4),
                          badgeColor: Colors.redAccent,
                          badgeContent: const Text(
                            '1',
                            style: TextStyle(color: Colors.white),
                          ),
                          child: ClipOval(
                            child: Container(
                              height: 40,
                              width: 40,
                              child: Material(
                                color: const Color.fromARGB(255, 248, 249, 251),
                                child: IconButton(
                                  splashColor: Colors.green,
                                  tooltip: S.of(context).horizontalList,
                                  icon:
                                      SvgPicture.asset('assets/icon/sort.svg'),
                                  onPressed: () {},
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  BlocBuilder<ConversationMailTemplateBloc,
                          ConversationMailTemplateState>(
                      cubit: conversationMailTemplateBloc,
                      builder: (context, state) {
                        if (state is ConversationMailTemplateWating) {
                          return const Expanded(child: LoadingIndicator());
                        }
                        if (state is ConversationMailTemplateFailure) {
                          return Column(
                            children: [
                              SizedBox(
                                  height: 50 *
                                      (MediaQuery.of(context).size.height /
                                          700)),
                              LoadStatusWidget(
                                statusName: S.of(context).loadDataError,
                                content: state.error,
                                statusIcon: SvgPicture.asset(
                                    'assets/icon/error.svg',
                                    width: 170,
                                    height: 130),
                                action: AppButton(
                                  onPressed: () {
                                    conversationMailTemplateBloc
                                        .add(ConversationMailTemplateLoaded());
                                  },
                                  width: 180,
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 40, 167, 69),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(24)),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                        if (state is ConversationMailTemplateLoading) {
                          if (state.mailTemplates.isEmpty) {
                            return Center(
                                child: LoadStatusWidget.empty(
                                    statusName: S.of(context).noData,
                                    content: S
                                        .of(context)
                                        .emptyNotificationParam(S
                                            .of(context)
                                            .fastMessage
                                            .toLowerCase())));
                          }
                          return Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: state.mailTemplates.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      conversationMessageBloc.add(
                                          ConversationDetailAdded(
                                              facebookId: widget.conversation
                                                  .facebookTposUser.id,
                                              from:
                                                  TPosFacebookUser(
                                                      id: widget.crmTeam
                                                          .facebookPageId,
                                                      name:
                                                          widget.crmTeam.name),
                                              toId: widget.conversation
                                                  .facebookTposUser.id,
                                              message: state
                                                      .mailTemplates[index]
                                                      .bodyPlain ??
                                                  '',
                                              pageId:
                                                  widget.crmTeam.facebookPageId,
                                              type: widget.type ?? 'all',
                                              page: 1,
                                              limit: 50));
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 16, right: 16, bottom: 11),
                                        color: const Color(0xFFF0F1F3),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 13,
                                              top: 10,
                                              bottom: 10,
                                              right: 13),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      state.mailTemplates[index]
                                                              .name ??
                                                          '',
                                                      style: const TextStyle(
                                                          color:
                                                              Color(0xFF2C333A),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 17),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color(0xFFDCDFE3),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  6)),
                                                    ),
                                                    child: const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 13,
                                                          right: 13,
                                                          top: 2,
                                                          bottom: 2),
                                                      child: Text(
                                                        '/dh',
                                                        style: TextStyle(
                                                            fontSize: 15),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                state.mailTemplates[index]
                                                        .bodyPlain ??
                                                    '',
                                                style: const TextStyle(
                                                    color: Color(0xFF6B7280)),
                                              ),
                                            ],
                                          ),
                                        )),
                                  );
                                }),
                          );
                        }
                        return Container();
                      }),
                ],
              ),
            ),
          );
        });
  }

  void _buildBottomSheetUser(
      BuildContext context, ConversationUserState conversationUserState) {
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
                            S.current.assignEmployee,
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
                  if (conversationUserState is ConversationUserWaiting)
                    const LoadingIndicator(),
                  if (conversationUserState is ConversationUserLoad &&
                      conversationUserState?.applicationUsers != null)
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(
                            top: 24, bottom: 20, right: 16, left: 16),
                        shrinkWrap: true,
                        itemCount:
                            conversationUserState.applicationUsers.value.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                applicationUser = conversationUserState
                                    .applicationUsers.value[index];
                              });
                              conversationUserBloc.add(ConversationUserAdded(
                                  userId: conversationUserState
                                      .applicationUsers.value[index].id,
                                  pageId: widget.crmTeam.facebookPageId,
                                  facebookId: widget.conversation.psid));
                              Navigator.pop(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    ClipOval(
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        color: Colors.grey,
                                        child: conversationUserState
                                                    .applicationUsers
                                                    .value[index]
                                                    .avatar !=
                                                null
                                            ? Image.network(
                                                conversationUserState
                                                    .applicationUsers
                                                    .value[index]
                                                    ?.avatar,
                                                fit: BoxFit.fill,
                                                errorBuilder:
                                                    (BuildContext context,
                                                        Object exception,
                                                        StackTrace stackTrace) {
                                                  return Container(
                                                    color: Colors.grey,
                                                  );
                                                },
                                              )
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 14,
                                    ),
                                    Text(conversationUserState.applicationUsers
                                            .value[index]?.name ??
                                        S.current.user),
                                  ],
                                ),
                                if (applicationUser?.name ==
                                    conversationUserState
                                        .applicationUsers.value[index]?.name)
                                  const Icon(
                                    Icons.check_circle,
                                    color: Color(0xFF28A745),
                                  )
                                else
                                  const Icon(
                                    Icons.check_circle,
                                    color: Color(0xFFDFE5E9),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        });
  }

  void buildTagBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
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
                            S.current.assignTag,
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
                            for (int i = 0; i < tmpTags.length; i++) {
                              if (!newTmpTags.any(
                                  (element) => element.id == tmpTags[i].id)) {
                                conversationTagBloc.add(ConversationTagAdded(
                                  pageId: widget.crmTeam.facebookPageId,
                                  action: 'add',
                                  tagId: tmpTags[i]?.id,
                                  facebookId:
                                      widget.conversation.facebookTposUser.id,
                                ));
                              }
                            }
                            for (int i = 0; i < newTmpTags.length; i++) {
                              if (!tmpTags.any((element) =>
                                  element.id == newTmpTags[i].id)) {
                                conversationTagBloc.add(ConversationTagAdded(
                                  pageId: widget.crmTeam.facebookPageId,
                                  action: 'remove',
                                  tagId: newTmpTags[i]?.id,
                                  facebookId:
                                      widget.conversation.facebookTposUser.id,
                                ));
                              }
                            }

                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                  BlocConsumer<ConversationTagBloc, ConversationTagState>(
                    cubit: conversationTagBloc,
                    listener: (context, state) {},
                    builder: (context, state) {
                      if (state is ConversationTagWaiting) {
                        return Expanded(
                          child: Container(
                            color: Colors.white.withAlpha(125),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        );
                      }
                      if (state is ConversationTagAddFailure) {
                        return Column(
                          children: [
                            SizedBox(
                                height: 50 *
                                    (MediaQuery.of(context).size.height / 700)),
                            LoadStatusWidget(
                              statusName: S.of(context).loadDataError,
                              content: state.message,
                              statusIcon: SvgPicture.asset(
                                  'assets/icon/error.svg',
                                  width: 170,
                                  height: 130),
                              action: AppButton(
                                onPressed: () {
                                  conversationTagBloc
                                      .add(ConversationTagLoaded());
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
                      if (state is ConversationTagLoading) {
                        final List<bool> isCheck = [];
                        for (int i = 0; i < state.crmTags.value.length; i++) {
                          isCheck.add(false);
                        }

                        return Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 16, bottom: 30),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final List<CRMTag> cRMTags =
                                    state.crmTags.value;
                                if (widget.conversation.tags.any((element) =>
                                    element.id ==
                                    state.crmTags.value[index].id)) {
                                  isCheck[index] = true;
                                } else {
                                  isCheck[index] = false;
                                }
                                return StatefulBuilder(
                                  builder: (BuildContext context,
                                      void Function(void Function())
                                          setState1) {
                                    return InkWell(
                                      onTap: () {
                                        if (widget.conversation.tags.any(
                                            (element) =>
                                                element.id ==
                                                state
                                                    .crmTags.value[index].id)) {
                                          setState1(() {
                                            isCheck[index] = false;
                                          });
                                          tmpTags.removeWhere((element) =>
                                              element.id ==
                                              state.crmTags.value[index].id);
                                        } else {
                                          setState1(() {
                                            isCheck[index] = true;
                                          });
                                          tmpTags.add(TagStatusFacebook(
                                              id: state.crmTags.value[index].id,
                                              name: state
                                                  .crmTags.value[index].name,
                                              colorClass: state
                                                  .crmTags
                                                  .value[index]
                                                  .colorClassName));
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Opacity(
                                                opacity: widget.conversation
                                                            .tags !=
                                                        null
                                                    ? (isCheck[index] == true
                                                        ? 1
                                                        : 0.5)
                                                    : 0.5,
                                                child: SvgPicture.asset(
                                                    'assets/icon/tag_bottomsheet.svg',
                                                    color: Color(int.parse(
                                                        '0xFF${cRMTags[index].colorClassName.substring(1, 7)}'))),
                                              ),
                                              if (isCheck[index] == true)
                                                SvgPicture.asset(
                                                  'assets/icon/check.svg',
                                                ),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 25,
                                          ),
                                          Text(
                                            cRMTags[index].name,
                                            style: TextStyle(
                                                color: widget.conversation.tags
                                                        .any((element) =>
                                                            element.id ==
                                                            cRMTags[index].id)
                                                    ? const Color(0xFF2C333A)
                                                    : const Color(0xFF6B7280),
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 60,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              itemCount: state.crmTags.value.length,
                            ),
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  ///Container Menu
  Widget _buildMenu() {
    return Row(
      children: [
        const SizedBox(
          width: 32,
        ),
        _buildItemMenu(
            image: 'assets/icon/product.svg',
            name: S.current.product,
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
            onPress: () {
              _textSearch.text = '';
              skip = 0;
              conversationProductBloc.add(ConversationProductLoaded(
                  facebookId: widget.crmTeam.facebookPageId,
                  limit: 10,
                  skip: 0));
              _buildBottomSheetProduct(context);
            }),
        const SizedBox(
          width: 32,
        ),
        _buildItemMenu(
          onPress: () {
            conversationMailTemplateBloc.add(ConversationMailTemplateLoaded());
            buildBottomSheetMailTemplate(context);
          },
          image: 'assets/icon/message.svg',
          name: S.current.fastMessage,
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
          onPress: () {
            conversationFsOrderBloc.add(ConversationFsOrderLoaded(
                partnerId: widget?.conversation?.partnerId));
            buildBottomSheetFsOrder(context);
          },
          image: 'assets/icon/order.svg',
          name: S.current.order,
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

  ///Container Image
  Widget buildGridView(ScrollController scrollController) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        GridView.builder(
            itemCount: media.length,
            controller: scrollController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 2, mainAxisSpacing: 2),
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                  onTap: () async {
                    urlImage = await media[index].file;
                    setState(() {
                      if (!_imageSelects
                          .any((element) => _mediaList[index] == element)) {
                        isRemove = false;
                        listUrl.add(urlImage);

                        /// Danh sách hình
                        // conversationImageBloc.add(
                        //     ConversationImagePickerAdded(file: urlImage));
                        _imageSelects.add(_mediaList[index]);
                      } else {
                        setState(() {
                          isRemove = true;
                        });
                        listUrl.removeWhere(
                            (element) => element.path == urlImage.path);
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
        if (listUrl.isNotEmpty)
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: FlatButton(
              height: 48,
              minWidth: MediaQuery.of(context).size.width,
              color: const Color(0xFF28A745),
              onPressed: () {
                _sendImageMessage();
              },
              child: Text(
                S.current.forgotPassword_Send,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAppbarDetail({ConversationUserState conversationUserState}) {
    listPop.insert(0, applicationUser);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 60,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BackButton(
                  color: const Color(0xFFA7B2BF),
                  onPressed: () {
                    Navigator.pop(context, listPop);
                  }),
              Container(
                height: 40,
                width: 40,
                child: CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage(
                      'https://graph.facebook.com/${widget.conversation?.psid}/picture?access_token=${widget.crmTeam?.facebookPageToken}'),
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
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width - 200),
                    child: Text(
                      widget.conversation.name ?? '',
                      style: const TextStyle(
                          color: Color(0xFF2C333A), fontSize: 19),
                      overflow: TextOverflow.ellipsis,
                    ),
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
                      InkWell(
                        onTap: () {
                          _buildBottomSheetUser(context, conversationUserState);
                        },
                        child: Text(
                          applicationUser?.name ?? S.current.user,
                          style: const TextStyle(color: Color(0xFF28A745)),
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xFF929DAA),
                        size: 14,
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

  void buildBottomSheet(BuildContext context, String id) {
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
                  maxHeight: MediaQuery.of(context).size.height / 6),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 35),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.edit,
                          color: Color(0xFF929DAA),
                        ),
                        SizedBox(
                          width: 22,
                        ),
                        Text(
                          'Chỉnh sửa',
                          style: TextStyle(color: Color(0xFF2C333A)),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      conversationNoteBloc.add(ConversationNoteDeleted(
                        id: id,
                        facebookId: widget.conversation.facebookTposUser.id,
                        pageId: widget.crmTeam.facebookPageId,
                      ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, top: 20),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.delete,
                            color: Color(0xFFEB3B5B),
                          ),
                          SizedBox(
                            width: 22,
                          ),
                          Text(
                            'Xóa',
                            style: TextStyle(color: Color(0xFF2C333A)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildBodyFilterDrawer() {
    String name = widget.conversation.name;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(5),
          child: SafeArea(
            child: Row(
              children: <Widget>[
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      // ignore: unnecessary_string_interpolations
                      'Tùy chọn',
                      style: TextStyle(
                        color: Color(0xFF2C333A),
                        fontSize: 21,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  child: const Padding(
                    padding: EdgeInsets.all(3),
                    child: Icon(
                      Icons.close,
                      color: Color(0xFF858F9B),
                      size: 30,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        ),
        Row(
          children: [
            InkWell(
              onTap: () {},
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
                      style: TextStyle(color: Color(0xFF5A6271), fontSize: 14),
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
                      style: TextStyle(color: Color(0xFF5A6271), fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () async {
            final Partner partner = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ConversationPartnerEditPage(
                          conversation: widget.conversation,
                          crmTeam: widget.crmTeam,
                        )));
            setState(() {
              name = partner?.name;
            });
          },
          child: Container(
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      name ?? '',
                      style: const TextStyle(
                          color: Color(0xFF929DAA), fontSize: 15),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    if (widget.conversation.hasPhone)
                      Row(
                        children: [
                          Image.asset(
                            'images/telephone.png',
                            height: 13,
                            width: 13,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    if (widget.conversation.hasAddress)
                      Row(
                        children: [
                          Image.asset(
                            'images/locattion_tpage.png',
                            height: 13,
                            width: 13,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                        ],
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
        ),
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ConversationProductEditPage(
                          partnerId: widget?.conversation?.partnerId,
                          crmTeam: widget.crmTeam,
                        )));
          },
          child: Container(
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
                      style: TextStyle(color: Color(0xFF929DAA), fontSize: 15),
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
        InkWell(
          onTap: () {
            setState(() {
              isClickNote = !isClickNote;
            });
            if (isClickNote) {
              conversationNoteBloc.add(ConversationNoteLoaded(
                facebookId: widget.conversation.facebookTposUser.id,
                pageId: widget.crmTeam.facebookPageId,
              ));
            }
          },
          child: Container(
            height: 50,
            margin: const EdgeInsets.only(left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icon/note.svg',
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Ghi chú hội thoại',
                      style: TextStyle(color: Color(0xFF2C333A), fontSize: 17),
                    ),
                  ],
                ),
                Row(
                  children: const [
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
        ),
        if (isClickNote)
          Expanded(
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    _textNote.text = '';
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        insetPadding: const EdgeInsets.all(10),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Thêm ghi chú hội thoại',
                              style: TextStyle(
                                  color: Color(0xFF2C333A), fontSize: 21),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(
                                Icons.close,
                                color: Color(0xFF929DAA),
                              ),
                            ),
                          ],
                        ),
                        content: Builder(
                          builder: (context) {
                            final double width =
                                MediaQuery.of(context).size.width;
                            return Container(
                              width: width,
                              child: TextField(
                                controller: _textNote,
                                style: const TextStyle(
                                    color: Color(0xFF929DAA), fontSize: 17),
                                decoration: const InputDecoration(
                                    hintText: 'Nhập ghi chú',
                                    hintStyle:
                                        TextStyle(color: Color(0xFF929DAA)),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFE9EDF2)))),
                                onChanged: (value) {},
                              ),
                            );
                          },
                        ),
                        actions: <Widget>[
                          OutlineButton(
                            child: const Text(
                              "Hủy",
                              style: TextStyle(color: Color(0xFF5A6271)),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0)),
                          ),
                          OutlineButton(
                            onPressed: () {
                              Navigator.pop(context);
                              conversationNoteBloc.add(ConversationNoteAdded(
                                  facebookId: widget.conversation.psid,
                                  pageId: widget.crmTeam.facebookPageId,
                                  message: _textNote.text));
                            },
                            child: const Text("Lưu"),
                            borderSide:
                                const BorderSide(color: Color(0xFF28A745)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Center(
                    child: Container(
                      width: 142,
                      height: 34,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(17),
                          color: const Color(0xFFF8F9Fb)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.add,
                            color: Color(0xFFA7B2BF),
                          ),
                          Text(
                            'Thêm ghi chú',
                            style: TextStyle(color: Color(0xFF5A6271)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child:
                      BlocConsumer<ConversationNoteBloc, ConversationNoteState>(
                          cubit: conversationNoteBloc,
                          listener: (context, state) {
                            if (state is ConversationNoteAddSuccess) {
                              conversationNoteBloc.add(ConversationNoteLoaded(
                                facebookId:
                                    widget.conversation.facebookTposUser.id,
                                pageId: widget.crmTeam.facebookPageId,
                              ));
                            }
                          },
                          builder: (context, state) {
                            if (state is ConversationNoteLoading) {
                              return ListView.builder(
                                  padding: const EdgeInsets.only(top: 0),
                                  shrinkWrap: true,
                                  itemCount: state
                                      .getListConversationResult.items.length,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: _buildNote(
                                            state
                                                .getListConversationResult
                                                .items[index]
                                                .createdBy
                                                .nameUser,
                                            DateFormat('HH:mm dd/MM/yyyy')
                                                .format(state
                                                    .getListConversationResult
                                                    .items[index]
                                                    .dateCreated),
                                            state.getListConversationResult
                                                .items[index].message,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            buildBottomSheet(
                                                context,
                                                state.getListConversationResult
                                                    .items[index].id);
                                          },
                                          icon: const Icon(
                                            Icons.more_vert,
                                            color: Color(0xFFA7B2BF),
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            } else if (state is ConversationNoteWaiting) {
                              return const Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: LoadingIndicator(),
                              );
                            } else if (state is ConversationNoteLoadFailure) {}
                            return Container();
                          }),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
      ],
    );
  }

  ///Item ghi chú
  Widget _buildNote(
    String name,
    String date,
    String content,
  ) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 12),
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: Color(0xFFCDD3DB), width: 2)),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 7,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: '$name \b',
                      style: const TextStyle(
                          fontSize: 14.0, color: Color(0xFF2C333A))),
                  TextSpan(
                      text: date ?? '',
                      style: const TextStyle(
                          fontSize: 12.0, color: Color(0xFF929DAA))),
                ])),
                Text(
                  content ?? '',
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPanel() {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: _buildBodyFilterDrawer(),
      ),
    );
  }

  ///List Tag
  Widget _buildListTag(ConversationTagState state) {
    /// Sử lí nhãn hội thoại
    if (tmpTags.isEmpty) {
      return Container();
    }
    listPop.insert(1, tmpTags);
    return Column(
      children: [
        Container(
          height: 50,
          color: Colors.white,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              padding: const EdgeInsets.all(8.0),
              itemCount: tmpTags.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(left: 5, right: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFFF8F9FB),
                  ),
                  padding: const EdgeInsets.only(
                      top: 4, bottom: 4, right: 10, left: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 5),
                        height: 16,
                        width: 16,
                        decoration: BoxDecoration(
                            color: Color(int.parse(
                                '0xFF${tmpTags[index]?.colorClass?.substring(1, 7)}')),
                            shape: BoxShape.circle),
                      ),
                      Text(
                        tmpTags[index]?.name,
                        style: const TextStyle(
                          color: Color(0xFF5A6271),
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }

  /// List comment
  Widget _buildPost(
      {BuildContext context, ConversationDetailLoading state, int index}) {
    childList = [];
    String content =
        state.getMessageConversationResult.extras.posts[index].message ?? '';
    if (state.getMessageConversationResult.extras.posts[index].story != null) {
      content += state.getMessageConversationResult.extras.posts[index].story;
    }

    for (int i = 0; i < state.getMessageConversationResult.items.length; i++) {
      if (state.getMessageConversationResult.extras.posts[index].id ==
          state.getMessageConversationResult.items[i].comment?.postId) {
        childList.add(Align(
          alignment: const Alignment(1, 0),
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ReceivedMessageWidget(
                messageConversation: state.messageConversation,
                type: 'comment',
                userName: state
                    .getMessageConversationResult.items[i].comment.from.nameFb,
                content:
                    state.getMessageConversationResult.items[i].messageFormat ??
                        '',
                time: DateFormat("dd/MM/yyyy hh:mm:ss").format(state
                    .getMessageConversationResult.items[i].createdTime
                    .add(const Duration(hours: 7))),
                isImage: state.getMessageConversationResult.items[i].message
                        ?.attachment !=
                    null,
                imageAddress: state.getMessageConversationResult.items[i]
                    .comment?.from?.picture?.dataImageFacebook?.url),
          ),
        ));
      }
    }
    if (state.messageConversation != null &&
        index == state.getMessageConversationResult.extras.posts.length - 1) {
      childList.add(Align(
        alignment: const Alignment(1, 0),
        child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: SendedMessageWidget(
            messageConversation: state.messageConversation,
            content: state.messageConversation.messageFormat ?? '',
            time: DateFormat("dd/MM/yyyy hh:mm:ss").format(state
                .messageConversation.createdTime
                .add(const Duration(hours: 7))),
            isImage: state.messageConversation.message?.attachment != null,
            imageAddress: 'images/avatar_tpage.png',
          ),
        ),
      ));
    }
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 52,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 16,
                ),
                Image.asset('images/facebook_icon.png'),
                const SizedBox(
                  width: 8,
                ),
                const Text(
                  'Bài viết',
                  style: TextStyle(color: Color(0xFF1976D2), fontSize: 17),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  DateFormat("dd-MM-yyyy HH:mm").format(state
                          ?.getMessageConversationResult
                          ?.extras
                          ?.posts[index]
                          ?.dateCreated
                          ?.add(const Duration(hours: 7))) ??
                      '',
                  style:
                      const TextStyle(color: Color(0xFF929DAA), fontSize: 17),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 16, bottom: 10),
            child: Text(
              content ?? '',
              style: const TextStyle(fontSize: 15),
            ),
          ),
          if (state.getMessageConversationResult.extras.posts[index].type ==
              'video')
            Image.network(
              state.getMessageConversationResult.extras.posts[index]
                      .fullPicture ??
                  '',
              height: 217,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            )
          else
            Container(),
          Container(
            margin:
                const EdgeInsets.only(left: 16, top: 10, bottom: 10, right: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset('images/like.png'),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      state.getMessageConversationResult.extras.posts[index]
                              .countReactions
                              .toString() ??
                          '',
                      style: const TextStyle(color: Color(0xFF929DAA)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      state.getMessageConversationResult.extras.posts[index]
                              .countComments
                              .toString() ??
                          '',
                      style: const TextStyle(color: Color(0xFF929DAA)),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    const Text(
                      'Bình luận',
                      style: TextStyle(color: Color(0xFF929DAA)),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    const Icon(
                      Icons.keyboard_arrow_up,
                      color: Color(0xFF929DAA),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            children: childList,
          ),
        ],
      ),
    );
  }
}
