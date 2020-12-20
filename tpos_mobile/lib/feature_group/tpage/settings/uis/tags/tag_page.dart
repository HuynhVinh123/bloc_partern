import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/feature_group/tpage/settings/blocs/tags/tag_bloc.dart';
import 'package:tpos_mobile/feature_group/tpage/settings/blocs/tags/tag_event.dart';
import 'package:tpos_mobile/feature_group/tpage/settings/blocs/tags/tag_state.dart';
import 'package:tpos_mobile/feature_group/tpage/settings/color_tag.dart';
import 'package:tpos_mobile/feature_group/tpage/settings/uis/tags/tag_page_item.dart';
import 'package:tpos_mobile/feature_group/tpage/settings/uis/tags/tag_add_edit_page.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/page_state/page_state.dart';
import 'package:tpos_mobile/widgets/page_state/page_state_type.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class TagPage extends StatefulWidget {
  @override
  _TagPageState createState() => _TagPageState();
}

class _TagPageState extends State<TagPage> {
  final TagBloc _bloc = TagBloc();

  @override
  void initState() {
    super.initState();
    _bloc.add(TagLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return BlocUiProvider<TagBloc>(
      bloc: _bloc,
      listen: (state) {
        if (state is TagLoadFailure) {
          App.showDefaultDialog(
              content: state.content,
              title: state.title,
              context: context,
              type: AlertDialogType.error);
        } else if (state is ActionSuccess) {
          App.showToast(
              title: state.title, context: context, message: state.content);
          _bloc.add(TagLoaded());
        }
      },
      child: BlocLoadingScreen<TagBloc>(
        busyStates: const [TagLoading],
        child: Scaffold(
            backgroundColor: const Color(0xFFEBEDEF),
            appBar: _buildAppBar(),
            body: _buildBody()),
      ),
    );
  }

  /// hHieern thị appbar
  Widget _buildAppBar() {
    return AppBar(
      title: const Text("Nhãn hội thoại"),
      actions: [
        IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showDialogAddTag();
            })
      ],
    );
  }

  /// Build thông tin của trang hội thoại
  Widget _buildBody() {
    return Column(
      children: [
        _buildHeader(),
        const SizedBox(
          height: 8,
        ),
        Flexible(child: _buildTags()),
      ],
    );
  }

  /// UI hiển thị nút nhấn thêm sản phẩm
  Widget _buildButtonAddTag() {
    return Container(
      margin: const EdgeInsets.only(left: 42),
      child: FlatButton.icon(
          onPressed: () {
            _showDialogAddTag();
          },
          icon: const Icon(
            Icons.add,
            color: Color(0xFF28A745),
          ),
          label: const Text(
            "Thêm nhãn mới",
            style: TextStyle(color: Color(0xFF28A745)),
          )),
    );
  }

  /// Hiển thị danh sách nhãn
  Widget _buildTags() {
    return BlocBuilder<TagBloc, TagState>(buildWhen: (prevState, currState) {
      if (currState is TagLoadSuccess || currState is TagLoadFailure) {
        return true;
      }
      return false;
    }, builder: (context, state) {
      if (state is TagLoadSuccess) {
        return Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTitleTag(state.tagTPages.length),
              Expanded(
                  child: state.tagTPages.isEmpty
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
                                    _bloc.add(TagLoaded());
                                  },
                                  child: const Text(
                                    "Tải lại",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            )
                          ],
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            _bloc.add(TagLoaded());
                            return true;
                          },
                          child: ListView.builder(
                            itemCount: state.tagTPages.length,
                            itemBuilder: (context, index) {
                              return TagItem(
                                isUnderLine:
                                    index != state.tagTPages.length - 1,
                                stateColor: Color(int.parse(
                                    "0xFF${state.tagTPages[index].colorClassName.replaceAll("#", "")}")),
                                stateText: !state.tagTPages[index].isDeleted
                                    ? "Đang sử dụng"
                                    : "Chưa sử dụng",
                                title: state.tagTPages[index].name ?? "",
                                backGroundColor:
                                    !state.tagTPages[index].isDeleted
                                        ? const Color(0xFF28A745)
                                        : const Color(0xFF929DAA),
                                actions: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        _showDialogAddTag(
                                            tagTPage: state.tagTPages[index]);
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
                                            message:
                                                "Bạn có chắc muốn xóa nhãn?");
                                        if (dialogResult ==
                                            DialogResultType.YES) {
                                          _bloc.add(TagDeleted(
                                              id: state.tagTPages[index].id));
                                        }
                                      },
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        child: const Icon(
                                          Icons.delete,
                                          size: 19,
                                          color: Color(0xFFA7B2BF),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        )),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: Divider(
                    height: 1,
                  ),
                ),
              ),
              _buildButtonAddTag()
            ],
          ),
        );
      } else if (state is TagLoadFailure) {
        return Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleTag(0),
              PageState(
                type: PageStateType.dataError,
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
                          _bloc.add(TagLoaded());
                        },
                        child: const Text(
                          "Tải lại",
                          style: TextStyle(color: Colors.white),
                        )),
                  )
                ],
              ),
            ],
          ),
        );
      }
      return const SizedBox();
    });
  }

  /// UI hiển thị số lượng nhãn
  Widget _buildTitleTag(int countTag) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        "NHÃN HỘI THOẠI ($countTag)",
        style: const TextStyle(color: Color(0xFF28A745), fontSize: 15),
      ),
    );
  }

  /// UI hiển thị thông tin setting
  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Switch.adaptive(
            value: true,
            onChanged: (value) {},
            activeColor: const Color(0xFF28A745),
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 12,
              ),
              const Text(
                "Tự động gắn nhãn vào hội thoại có chứa Số điện thoại",
                style: TextStyle(color: Color(0xFF2C333A)),
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                "Chọn nhãn",
                style: TextStyle(
                    color: Color(0xFF2C333A),
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(right: 16, top: 6, bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFDFE7EC)),
                    borderRadius: BorderRadius.circular(4)),
                child: Row(
                  children: const [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Chip(
                          padding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 6),
                          // selected: false,
                          label: Text(
                            "Mua hàng",
                            // style: TextStyle(coloTagLoadedr: Colors.white),
                          ),
                          labelStyle: TextStyle(color: Colors.white),
                          backgroundColor: Color(0xFF0DA898),
//                         selectedColor: Color(0xFF0DA898),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xFF2C333A),
                    )
                  ],
                ),
              )
            ],
          )),
        ],
      ),
    );
  }

  /// UI hiển thị dialog add nhãn
  void _showDialogAddTag({CRMTag tagTPage}) {
    showDialog(
      useRootNavigator: false,
      context: context,
      builder: (BuildContext contxt) {
        return TagAddEditPage(
          bloc: _bloc,
          tagTPage: tagTPage,
        );
      },
    );
  }
}
