import 'package:flutter/material.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_command.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/new_facebook_post_comment_viewmodel.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/sale_online_reply_facebook_comment_viewmodel.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';

import 'package:tpos_mobile/src/tpos_apis/tpos_models.dart';
import 'package:tpos_mobile/app_core/ui_base/ui_vm_base.dart';

import 'package:scoped_model/scoped_model.dart';

class SaleOnlineReplyFacebookCommentModal extends StatefulWidget {
  const SaleOnlineReplyFacebookCommentModal({
    @required this.accessToken,
    @required this.comment,
    @required this.pageId,
    @required this.crmTeam,
    @required this.postId,
    this.isSendMessage,
  });
  final String accessToken;
  final CommentItemModel comment;
  final String pageId;
  final bool isSendMessage;
  final CRMTeam crmTeam;
  final String postId;

  @override
  _SaleOnlineReplyFacebookCommentModalState createState() =>
      _SaleOnlineReplyFacebookCommentModalState();
}

class _SaleOnlineReplyFacebookCommentModalState
    extends State<SaleOnlineReplyFacebookCommentModal> {
  final _vm = SaleOnlineReplyFacebookCommentViewModel();
  var replyMessageController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    assert(widget.accessToken != null);
    assert(widget.comment != null);
    assert(widget.pageId != null);
    assert(widget.isSendMessage != null);
    _vm.init(
      accessToken: widget.accessToken,
      comment: widget.comment,
      pageId: widget.pageId,
      isSendMessage: widget.isSendMessage,
      crmTeam: widget.crmTeam,
      postId: widget.postId,
    );

    _vm.initCommand.execute(null);
    super.initState();
    _vm.dialogMessageController.listen((mesasge) {
      if (mounted) {
        registerDialogToView(context, mesasge,
            scaffState: _scaffoldKey.currentState);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(
        width: 0.2,
        color: Colors.green,
        style: BorderStyle.solid,
      ),
    );

    return ScopedModel<SaleOnlineReplyFacebookCommentViewModel>(
      model: _vm,
      child: UIViewModelBase(
        viewModel: _vm,
        child: Scaffold(
          key: _scaffoldKey,
          body: Container(
            padding:
                const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF737373),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Thông tin
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 12, right: 12, top: 8, bottom: 8),
                            child: Text(
                              "Trả lời: ${_vm.comment.facebookComment.from.name}",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Icon(Icons.settings),
                          ),
                        ),
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  // Khung gõ
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.add_circle),
                          onPressed: () async {
                            if (replyMessageController.text.trim() == "") {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text(
                                    "Thông tin",
                                  ),
                                  content: const Text(
                                      "Nhập nội dung và nhấn 'Thêm' lại để lưu mẫu tin nhắn mới"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: const Text("Đồng ý"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                ),
                              );

                              return;
                            }

                            final dialogResult = await showQuestion(
                                title: "Xác nhận thêm",
                                context: context,
                                message:
                                    "Bạn có muốn thêm '${replyMessageController.text.trim()}' vào mẫu trả lời tin nhắn");

                            if (dialogResult == OldDialogResult.Yes) {
                              _vm.addNewCommand
                                  .execute(replyMessageController.text.trim());
                            }
                          },
                        ),
                        Expanded(
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextField(
                                  controller: replyMessageController,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.grey.shade100,
                                    hintText: "Nhập nội dung",
                                    border: inputBorder,
                                    enabledBorder: inputBorder,
                                    focusedBorder: inputBorder,
                                    contentPadding: const EdgeInsets.only(
                                        left: 12, right: 12, top: 8, bottom: 8),
                                  ),
                                  onChanged: (text) {
                                    _vm.search(text);
                                  },
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, top: 8, bottom: 8),
                                    child: Icon(
                                      Icons.cancel,
                                      color: Colors.grey,
                                      size: 16,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      replyMessageController.clear();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        ScopedModel<ViewModelCommand>(
                          model: _vm.replyCommand,
                          child: ScopedModelDescendant<ViewModelCommand>(
                              builder: (context, child, model) {
                            if (model.isExecuting) {
                              return IconButton(
                                icon: const CircularProgressIndicator(),
                                onPressed: () {},
                              );
                            } else {
                              return IconButton(
                                icon: Icon(Icons.send),
                                color: Colors.deepPurpleAccent,
                                onPressed: () async {
                                  final bool result = await _vm.replyCommand
                                      .execute(
                                          replyMessageController.text.trim());

                                  if (result != null && result) {
                                    Navigator.pop(context, true);
                                  }
                                },
                              );
                            }
                          }),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<List<MailTemplate>>(
                        stream: _vm.mailTemplateStream,
                        initialData: _vm.mailTemplates,
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return const Center(
                              child: Text("Không có mẫu tin nhắn nào"),
                            );
                          }
                          final mailTemplates = snapshot.data;
                          return RefreshIndicator(
                            onRefresh: () async {
                              await _vm.initCommand.execute(null);
                              return true;
                            },
                            child: ListView.separated(
                                physics: const AlwaysScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(
                                    left: 12, right: 12, top: 12),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.message,
                                          color: Colors.grey.shade600,
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8,
                                                right: 8,
                                                top: 10,
                                                bottom: 10),
                                            child: Text(
                                                mailTemplates[index].bodyPlain),
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      replyMessageController.text =
                                          mailTemplates[index].bodyPlain;
                                    },
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const Divider(
                                    height: 2,
                                  );
                                },
                                itemCount: mailTemplates?.length ?? 0),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }
}
