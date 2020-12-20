import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/sale_online_reply_facebook_comment_modal.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/new_facebook_post_comment_viewmodel.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';

import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tpos_mobile/widgets/custom_bottom_sheet.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import 'new_facebook_post_comment_info_page.dart';
import 'new_facebook_post_comment_page.dart';

class NewFacebookPostCommentSearchComment extends StatefulWidget {
  const NewFacebookPostCommentSearchComment(
      {@required this.vm, this.keyword, this.autoFocus = true});
  final NewFacebookPostCommentViewModel vm;
  final String keyword;
  final bool autoFocus;

  @override
  _SearchCommentPageState createState() => _SearchCommentPageState();
}

class _SearchCommentPageState
    extends State<NewFacebookPostCommentSearchComment> {
  final _keywordController = TextEditingController();

  @override
  void initState() {
    _keywordController.text = widget.keyword;
    widget.vm.searchCommentSink.add(widget.keyword);
    super.initState();
  }

  void _onCreateOrder(CommentItemModel item) {
    widget.vm.createdOrder(item).then((value) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> _showPartnerAndOrderInfo(CommentItemModel item,
      [bool isOrder = false]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (buildContext) => NewFacebookPostCommentInfoPage(
          vm: widget.vm,
          comment: item,
          initIndex: isOrder ? 1 : 0,
          onPartnerSaved: (partner, comment) {
            widget.vm.addPartner(partner, comment);
          },
        ),
      ),
    );
  }

  CommentItemModel _selectedCommentItem;

  void _showCommentMoreAction(CommentItemModel item) {
    if (mounted)
      setState(() {
        _selectedCommentItem = item;
      });
  }

  Future _hideComment(CommentItemModel item) async {
    final dialogResult = await showQuestion(
        context: context,
        title: "Ẩn comment",
        message:
            "Bạn có muốn ${item.facebookComment.isHidden ? "HIỆN" : "ẨN"} comment này");

    if (dialogResult == OldDialogResult.Yes) {
      widget.vm.hideComment(item, !item.facebookComment.isHidden);
    }
  }

  List<MailTemplate> mailTemplates;
  Future<List<MailTemplate>> getMailTemplate() async {
    if (mailTemplates == null) {
      final tposApi = locator<ITposApiService>();
      mailTemplates = await tposApi.getMailTemplates();
    }
    return mailTemplates;
  }

  Future _showReplyComment(CommentItemModel comment,
      {bool sendMessage = false}) async {
    final bool result = await showModalBottomSheetFullPage(
      context: context,
      builder: (context) {
        return BottomSheet(
          backgroundColor: Colors.red,
          onClosing: () {},
          builder: (context) => SaleOnlineReplyFacebookCommentModal(
            comment: comment,
            accessToken: widget.vm.crmTeam.userOrPageToken,
            pageId: widget.vm.crmTeam.userAsuidOrPageId,
            isSendMessage: sendMessage,
            crmTeam: widget.vm.crmTeam,
            postId: widget.vm.facebookPost.id,
          ),
        );
      },
    );

    if (result != null) {
      if (result && sendMessage == false) {
        widget.vm.fetchReplyComment(comment);
      }
    }
  }

  void _showMoreCommentActionModal(CommentItemModel comment) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => BottomSheet(
        shape: const OutlineInputBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        onClosing: () {},
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (comment.partnerPhone != null && comment.partnerPhone != "")
              ListTile(
                leading: Icon(Icons.call),
                title: Text("Gọi ${comment.partnerPhone}"),
              ),
            ListTile(
              leading: Icon(Icons.message),
              subtitle: Row(
                children: <Widget>[
                  Expanded(
                    child: OutlineButton(
                      child: const Text("Trả lời"),
                      onPressed: () {
                        _showReplyComment(comment);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: OutlineButton(
                      child: const Text("Gủi inbox"),
                      onPressed: () {
                        //if (widget.vm.crmTeam.facebookTypeId == "Page") {
                        // urlLauch(
                        //  "fb://messaging/${comment.partnerInfo.facebookUid}");
                        //} else {
                        _showReplyComment(comment, sendMessage: true);
                        //}
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: OutlineButton(
                      child: const Text("Ẩn"),
                      onPressed: () {
                        _hideComment(comment);
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    if ((widget.vm.searchComments?.length ?? 0) == 0) {
      return const SizedBox();
    }

    return Container(
      height: 40,
      color: Colors.blue.shade100,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Text(
              "Tìm thấy ${widget.vm.searchComments?.length ?? 0} kết quả phù hợp với từ khóa"),
        ],
      ),
    );
  }

  Widget _buildCommentItemView(CommentItemModel item) {
    return CommentItemView(
      item: item,
      onTapCreateOrder: () => _onCreateOrder(item),
      onTapViewInfo: () => _showPartnerAndOrderInfo(item),
      onTapOrderNumber: () => _showPartnerAndOrderInfo(item, true),
      onTapItem: () => _showCommentMoreAction(item),
      isShowMoreActon: _selectedCommentItem == item,
      onTapHideComment: () => _hideComment(item),
      onTapSendReply: () => _showReplyComment(item),
      onTapSendInbox: () => _showReplyComment(item, sendMessage: true),
      onTapMoreAction: () => _showMoreCommentActionModal(item),
    );
  }

  Widget _buildCommentLayout(CommentItemModel item, [Animation anim]) {
    if (item.comments != null && item.comments.isNotEmpty) {
      return Column(
        children: <Widget>[
          _buildCommentItemView(item),
          Column(
            children: item.comments
                .map((f) => Padding(
                      padding: const EdgeInsets.only(left: 50, top: 8),
                      child: _buildCommentItemView(f),
                    ))
                .toList(),
          ),
        ],
      );
    } else {
      return _buildCommentItemView(item);
    }
  }

  Widget _buildListComment() {
    return ScopedModelDescendant<NewFacebookPostCommentViewModel>(
        builder: (context, child, model) {
      if (_keywordController.text.isNotEmpty &&
          (widget.vm.searchComments == null ||
              widget.vm.searchComments.isEmpty)) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  FontAwesomeIcons.facebookMessenger,
                  size: 62,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  S.current.findComment_notFound(_keywordController.text),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.orangeAccent),
                ),
              ],
            ),
          ),
        );
      }

      if (_keywordController.text.isEmpty &&
          (widget.vm.searchComments == null ||
              widget.vm.searchComments.isEmpty))
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(
                  FontAwesomeIcons.facebookMessenger,
                  size: 62,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  S.current.findComment_notifyTitle,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  S.current.findComment_description,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      return ListView.separated(
        reverse: false,
        itemBuilder: (context, index) =>
            _buildCommentLayout(widget.vm.searchComments[index]),
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemCount: widget.vm.searchComments?.length ?? 0,
        padding: const EdgeInsets.all(8),
      );
    });
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        ScopedModelDescendant<NewFacebookPostCommentViewModel>(
          builder: (context, child, index) => _buildHeader(),
        ),
        Expanded(
          child: _buildListComment(),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<NewFacebookPostCommentViewModel>(
      model: widget.vm,
      child: WillPopScope(
        onWillPop: () async {
          widget.vm.searchComments?.clear();
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            textTheme: const TextTheme(
              headline6: TextStyle(color: Colors.black),
            ),
            iconTheme: IconThemeData(color: Colors.grey),
            title: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.white),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      autofocus: widget.autoFocus,
                      controller: _keywordController,
                      onChanged: (text) {
                        widget.vm.searchCommentSink.add(text);
                      },
                      decoration: InputDecoration(
                        hintText: S.current.findComment_hint,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      _keywordController.clear();
                      widget.vm.searchCommentSink.add("");
                    },
                    child: const Icon(
                      Icons.cancel,
                      color: Colors.grey,
                      size: 20,
                    ),
                  )
                ],
              ),
            ),
          ),
          body: _buildBody(),
        ),
      ),
    );
  }
}
