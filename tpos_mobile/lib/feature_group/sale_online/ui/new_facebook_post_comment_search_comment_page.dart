import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_drawer.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_panel.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/sale_online_reply_facebook_comment_modal.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/new_facebook_post_comment_viewmodel.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tpos_mobile/widgets/custom_bottom_sheet.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
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
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    widget.vm.resetFilter(true);
    widget.vm.fetchStatusReport();
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
                leading: const Icon(Icons.call),
                title: Text("Gọi ${comment.partnerPhone}"),
              ),
            ListTile(
              leading: const Icon(Icons.message),
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
          )
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
                  color: Colors.grey,
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

  /// Giao diện filter
  Widget _buildFilterPanel() {
    return ScopedModelDescendant<NewFacebookPostCommentViewModel>(
      builder: (context, child, index) => AppFilterDrawerContainer(
        countFilter: widget.vm.countFilter(),
        onRefresh: () {
          Navigator.pop(context);

          widget.vm.resetFilter();
        },
        closeWhenConfirm: false,
        onApply: () {
          if (widget.vm.isFilterByStatus) {
            final bool isHasStatus = widget.vm.partnerStatusReportItems
                .any((element) => element.isSelect == true);
            if (isHasStatus) {
              Navigator.pop(context);
              widget.vm.updateFilterWhenConfirm();
              widget.vm.searchCommentSink.add(_keywordController.text);
            } else {
              App.showDefaultDialog(
                  title: S.current.warning,
                  content: 'Vui lòng chọn 1 trạng thái',
                  context: context,
                  type: AlertDialogType.warning);
            }
          } else {
            Navigator.pop(context);
            widget.vm.updateFilterWhenConfirm();
            widget.vm.searchCommentSink.add(_keywordController.text);
          }
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FilterBool(
                  title: const Text('Lọc comment có số điện thoại'),
                  value: widget.vm.isFilterByCommentHasPhone,
                  onSelectedChange: (bool value) {
                    widget.vm.isFilterByCommentHasPhone = value;
                  }),
              FilterBool(
                  title: const Text('Lọc comment có mua hàng'),
                  value: widget.vm.isFilterByCommentHasBuy,
                  onSelectedChange: (bool value) {
                    widget.vm.isFilterByCommentHasBuy = value;
                  }),
              // AppFilterPanel(
              //   isEnable: true,
              //   isSelected: widget.vm.isFilterByCommentHasBuyProduct,
              //   onSelectedChange: (bool value) {
              //     widget.vm.isFilterByCommentHasBuyProduct = value;
              //   },
              //   title: const Text('Lọc comment có mua sản phẩm nào đó'),
              //   children: <Widget>[
              //     Container(
              //       height: 45,
              //       margin:
              //           const EdgeInsets.only(left: 32, right: 8, bottom: 12),
              //       width: MediaQuery.of(context).size.width,
              //       child: InkWell(
              //         onTap: () async {
              //           final product = await Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //               builder: (context) => const ProductSearchPage(),
              //             ),
              //           );
              //
              //           if (product != null) {
              //             widget.vm.productFilter = product;
              //           }
              //         },
              //         child: Row(
              //           children: <Widget>[
              //             Expanded(
              //               child: Text(
              //                   widget.vm.productFilter?.name ??
              //                       'Chọn sản phẩm',
              //                   style: TextStyle(
              //                       color: Colors.grey[600], fontSize: 15)),
              //             ),
              //             Visibility(
              //               visible: widget.vm.productFilter?.name != null,
              //               child: IconButton(
              //                 icon: const Icon(
              //                   Icons.close,
              //                   color: Colors.red,
              //                   size: 20,
              //                 ),
              //                 onPressed: () {
              //                   widget.vm.productFilter = Product();
              //                 },
              //               ),
              //             ),
              //             Icon(
              //               Icons.arrow_drop_down,
              //               color: Colors.grey[600],
              //             ),
              //           ],
              //         ),
              //       ),
              //     )
              //   ],
              // ),
              AppFilterPanel(
                isEnable: true,
                isSelected: widget.vm.isFilterByStatus,
                onSelectedChange: (bool value) {
                  widget.vm.isFilterByStatus = value;
                },
                title: const Text('Lọc theo trạng thái'),
                children: <Widget>[
                  Wrap(
                    direction: Axis.horizontal,
                    children: List.generate(
                        widget.vm.partnerStatusReportItems?.length ?? 0,
                        (index) => GestureDetector(
                              onTap: () {
                                widget.vm.onSelectStatus(index);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 4),
                                margin: const EdgeInsets.only(
                                    right: 4, bottom: 4, left: 8),
                                decoration: BoxDecoration(
                                    color: widget
                                            .vm
                                            .partnerStatusReportItems[index]
                                            .isSelect
                                        ? const Color(0xFFE9F6EC)
                                        : Colors.white,
                                    border: Border.all(
                                        color: widget
                                                .vm
                                                .partnerStatusReportItems[index]
                                                .isSelect
                                            ? const Color(0xFF28A745)
                                                .withOpacity(0.7)
                                            : const Color(0xFFE9EDF2)),
                                    borderRadius: BorderRadius.circular(6)),
                                child: Text(
                                  widget.vm.partnerStatusReportItems[index]
                                          .statusText ??
                                      "",
                                  style: TextStyle(
                                      color: widget
                                              .vm
                                              .partnerStatusReportItems[index]
                                              .isSelect
                                          ? const Color(0xFF28A745)
                                          : const Color(0xFF6B7280)),
                                ),
                              ),
                            )),
                  ),
                  // ListView.builder(
                  //   physics: const NeverScrollableScrollPhysics(),
                  //   shrinkWrap: true,
                  //   itemCount: widget.vm.partnerStatusReportItems?.length ?? 0,
                  //   itemBuilder: (context, index) => Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: InkWell(
                  //       child: Row(
                  //         children: <Widget>[
                  //           Icon(
                  //               widget.vm.partnerStatusReportItem?.statusText ==
                  //                       widget
                  //                           .vm
                  //                           .partnerStatusReportItems[index]
                  //                           ?.statusText
                  //                   ? Icons.radio_button_checked
                  //                   : Icons.radio_button_unchecked),
                  //           const SizedBox(width: 10),
                  //           Expanded(
                  //             child: Text(
                  //               widget.vm.partnerStatusReportItems[index]
                  //                       .statusText ??
                  //                   "",
                  //               style: TextStyle(
                  //                   color: getPartnerStatusColor(widget
                  //                       .vm
                  //                       .partnerStatusReportItems[index]
                  //                       .statusStyle)),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       onTap: () {
                  //         widget.vm.partnerStatusReportItem =
                  //             widget.vm.partnerStatusReportItems[index];
                  //       },
                  //     ),
                  //   ),
                  // ),
                ],
              )
            ],
          ),
        ),
      ),
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
          key: scaffoldKey,
          endDrawer: _buildFilterPanel(),
          appBar: AppBar(
            actions: [
              ScopedModelDescendant<NewFacebookPostCommentViewModel>(
                  builder: (context, child, index) => InkWell(
                      onTap: () {
                        widget.vm.updateFilterWhenOpen();
                        scaffoldKey.currentState.openEndDrawer();
                      },
                      child: Badge(
                          position: const BadgePosition(top: 2, end: -6),
                          padding: const EdgeInsets.all(4),
                          badgeColor: Colors.redAccent,
                          badgeContent: Text(widget.vm.count().toString(),
                              style: const TextStyle(color: Colors.white)),
                          child: Icon(
                            Icons.filter_list,
                            color: Colors.grey[600],
                          )))),
              const SizedBox(width: 12)
            ],
            backgroundColor: Colors.white,
            textTheme: const TextTheme(
              headline6: TextStyle(color: Colors.black),
            ),
            iconTheme: const IconThemeData(color: Colors.grey),
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
                              border: InputBorder.none))),
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
                  ),
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

/// Giao diện checkbox cho lọc theo sđt, có mua hàng
class FilterBool extends StatelessWidget {
  const FilterBool({this.title, this.value = false, this.onSelectedChange});

  final Widget title;
  final bool value;
  final ValueChanged<bool> onSelectedChange;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: <Widget>[
            Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: value,
              onChanged: onSelectedChange,
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(child: title)
          ],
        ),
      ),
      onTap: onSelectedChange != null
          ? () {
              onSelectedChange(!value);
            }
          : null,
    );
  }
}
