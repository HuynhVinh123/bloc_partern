import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/feature_group/tpage/settings/blocs/fast_reply/fast_reply_bloc.dart';
import 'package:tpos_mobile/feature_group/tpage/settings/blocs/fast_reply/fast_reply_event.dart';
import 'package:tpos_mobile/feature_group/tpage/settings/blocs/fast_reply/fast_reply_state.dart';
import 'package:tpos_mobile/feature_group/tpage/settings/uis/fast_reply/fast_reply_add_page.dart';
import 'package:tpos_mobile/feature_group/tpage/settings/uis/fast_reply/item_fast_reply.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/page_state/page_state.dart';

class FastReplyPage extends StatefulWidget {
  @override
  _FastReplyPageState createState() => _FastReplyPageState();
}

class _FastReplyPageState extends State<FastReplyPage> {
  List<String> replies = ["1", "", ""];
  bool isActive = false;

  final FastReplyBloc _bloc = FastReplyBloc();

  @override
  void initState() {
    super.initState();
    _bloc.add(FastReplyLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return BlocUiProvider<FastReplyBloc>(
      listen: (state) {
        if (state is FastReplyLoadFailure) {
          App.showDefaultDialog(
              content: state.content,
              title: state.title,
              context: context,
              type: AlertDialogType.error);
        } else if (state is ActionSuccess) {
          App.showToast(
              title: state.title, context: context, message: state.content);
          _bloc.add(FastReplyLoaded());
        }else if(state is ActionFailed){
          App.showDefaultDialog(
              content: state.content,
              title: state.title,
              context: context,
              type: AlertDialogType.error);
        }
      },
      bloc: _bloc,
      child: Scaffold(
        backgroundColor: const Color(0xFFEBEDEF),
        appBar: _buildAppBar(),
        body: BlocLoadingScreen<FastReplyBloc>(
            busyStates: const [FastReplyLoading],
            child: BlocBuilder<FastReplyBloc, FastReplyState>(
                buildWhen: (prevState, currState) {
              if (currState is FastReplyLoadSuccess ||
                  currState is FastReplyLoadFailure) {
                return true;
              }
              return false;
            }, builder: (context, state) {
              if (state is FastReplyLoadSuccess) {
                return _buildBody(state);
              } else if (state is FastReplyLoadFailure) {
                return _buildFailed();
              }
              return const SizedBox();
            })),
      ),
    );
  }

  Widget _buildFailed() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text("TRẢ LỜI NHANH (0)",
                style: const TextStyle(color: Color(0xFF28A745), fontSize: 15)),
          ),
          PageState(
            actions: [
              Container(
                width: 120,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: const Color(0xFF008E30),
                ),
                child: FlatButton(
                    onPressed: () {
                      _bloc.add(FastReplyLoaded());
                    },
                    child: const Text(
                      "Tải lại",
                      style: TextStyle(color: Colors.white),
                    )),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: const Text("Trả lời nhanh"),
      actions: [
        IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showDialogAddReply();
            }),
      ],
    );
  }

  Widget _buildBody(FastReplyLoadSuccess state) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text("TRẢ LỜI NHANH (${state.mailTemplates.length})",
                style: const TextStyle(color: Color(0xFF28A745), fontSize: 15)),
          ),
          Flexible(child: _buildReplies(state.mailTemplates)),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              height: 1,
            ),
          ),
          _buildButtonAddTag()
        ],
      ),
    );
  }

  Widget _buildButtonAddTag() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Align(
        alignment: Alignment.centerLeft,
        child: FlatButton.icon(
            onPressed: () {
              _showDialogAddReply();
            },
            icon: const Icon(
              Icons.add,
              color: Color(0xFF28A745),
            ),
            label: const Text("Thêm mới trả lời nhanh",
                style: TextStyle(color: Color(0xFF28A745)))),
      ),
    );
  }

  Widget _buildReplies(List<MailTemplateTPage> mailTemplates) {
    return mailTemplates.isEmpty
        ? PageState(
            actions: [
              Container(
                width: 120,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: const Color(0xFF008E30),
                ),
                child: FlatButton(
                    onPressed: () {
                      _bloc.add(FastReplyLoaded());
                    },
                    child: const Text(
                      "Tải lại",
                      style: TextStyle(color: Colors.white),
                    )),
              )
            ],
          )
        : Container(
            child: RefreshIndicator(
            onRefresh: () async {
              _bloc.add(FastReplyLoaded());
              return true;
            },
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: mailTemplates.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildItem(mailTemplates[index]);
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(),
              ),
            ),
          ));
  }

  Widget _buildItem(MailTemplateTPage item) {
    return ItemFastReply(
      title: item.name ?? "",
      content: item.bodyPlain ?? "",
      keyBoard: "",
      actions: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              _showDialogAddReply(mailTemplateTPage: item);
            },
            child: Container(
              width: 24,
              height: 24,
              child: const Icon(
                Icons.edit,
                size: 19,
                color: Color(0xFFA7B2BF),
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          InkWell(
            onTap: () async {
              final dialogResult = await showQuestion(
                  context: context,
                  title: "Xác nhận xóa",
                  message: "Bạn có chắc muốn xóa?");
              if (dialogResult == DialogResultType.YES) {
                _bloc.add(FastReplyDeleted(id: item.id));
              }
            },
            child: Container(
              width: 24,
              height: 24,
              child:
                  const Icon(Icons.delete, size: 19, color: Color(0xFFA7B2BF)),
            ),
          )
        ],
      ),
    );
  }

  void _showDialogAddReply({MailTemplateTPage mailTemplateTPage}) {
    showDialog(
      useRootNavigator: true,
      context: context,
      builder: (BuildContext contxt) {
        return FastReplyAddPage(
          bloc: _bloc,
          mailTemplateTPage: mailTemplateTPage,
        );
      },
    );
  }
}
