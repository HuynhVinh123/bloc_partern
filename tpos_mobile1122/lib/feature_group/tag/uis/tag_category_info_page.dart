import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/tag/bloc/tag_category_info/tag_category_info_bloc.dart';
import 'package:tpos_mobile/feature_group/tag/bloc/tag_category_info/tag_category_info_event.dart';
import 'package:tpos_mobile/feature_group/tag/bloc/tag_category_info/tag_category_info_state.dart';
import 'package:tpos_mobile/feature_group/tag/tag_type_helper.dart';
import 'package:tpos_mobile/feature_group/tag/uis/tag_category_add_edit_page.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';
import 'package:tpos_mobile/widgets/custom_widget.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';

import '../../../app.dart';

class TagCategoryInfoPage extends StatefulWidget {
  const TagCategoryInfoPage({this.tag,this.callBack});

  final Tag tag;
  final Function callBack;

  @override
  _TagCategoryInfoPageState createState() => _TagCategoryInfoPageState();
}

class _TagCategoryInfoPageState extends State<TagCategoryInfoPage> {
  final TagCategoryInfoBloc _bloc = TagCategoryInfoBloc();
  Tag _tag;

  @override
  void initState() {
    super.initState();
    _bloc.add(TagCategoryLoadLocal(tag: widget.tag));
  }

  @override
  Widget build(BuildContext context) {
    return BlocUiProvider<TagCategoryInfoBloc>(
      listen: (state) {
        if (state is TagCategoryInfoActionSuccess) {
          App.showToast(title: state.title, message: state.message);
          Navigator.pop(context, widget.tag);
        } else if (state is TagCategoryInfoActionFailure) {
          App.showDefaultDialog(
              title: state.title,
              content: state.message,
              context: context,
              type: AlertDialogType.error);
        }
      },
      bloc: _bloc,
      child: BlocLoadingScreen<TagCategoryInfoBloc>(
        busyStates: const [TagCategoryInfoLoading],
        child: WillPopScope(
          onWillPop: ()async{
            widget.callBack(_tag);
            return true;
          },
          child: Scaffold(
            backgroundColor: const Color(0xFFEBEDEF),
            appBar: _buildAppBar(),
            body: BlocBuilder<TagCategoryInfoBloc, TagCategoryInfoState>(
                builder: (context, state) {
              if (state is TagCategoryInfoLoadSuccess) {
                _tag = state.tag;
                return _buildBody(state.tag);
              }
              return const SizedBox();
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: const Text("Nhãn sản phẩm"),
      actions: [
        IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TagCategoryAddEditPage(
                          tag: widget.tag,
                        )),
              ).then((value) {
                if (value != null) {
                  setState(() {});
                  _bloc.add(TagCategoryInfoLoaded(id: widget.tag.id));
                }
              });
            }),
        IconButton(
            icon: const Icon(Icons.delete_forever_rounded),
            onPressed: () async {
              final dialogResult = await showQuestion(
                  context: context,
                  title: "Xác nhận xóa",
                  message: "Bạn có chắc muốn xóa nhãn");
              if (dialogResult == OldDialogResult.Yes) {
                _bloc.add(TagCategoryInfoDeleted(tagId: widget.tag.id));
              }
            })
      ],
    );
  }

  Widget _buildBody(Tag tag) {
    return Column(
      children: [_buildHeader(tag), _buildContent(tag)],
    );
  }

  Widget _buildHeader(Tag tag) {
    return Container(
      color: const Color(0xFFF8F9FB),
      padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "NHÃN",
                  style: TextStyle(color: Color(0xFF929DAA)),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  tag.name ?? "",
                  style:
                      const TextStyle(color: Color(0xFF2C333A), fontSize: 21),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SvgPicture.asset(
              "assets/icon/ic_tags.svg",
              fit: BoxFit.fill,
              width: 100,
              height: 100,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(Tag tag) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(
            height: 12,
          ),
          InfoRow(
            title: const Text(
              "Loại nhãn",
              style: TextStyle(color: Color(0xFF2C333A)),
            ),
            content: Text(
              convertTypeTagToName(tag.type),
              style: const TextStyle(color: Color(0xFF6B7280)),
              textAlign: TextAlign.end,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(),
          ),
          Row(
            children: [
              const SizedBox(
                width: 16,
              ),
              const Text(
                "Xem trước",
                style: TextStyle(color: Color(0xFF2C333A)),
              ),
              Flexible(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 85,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Color(int.parse(
                            "0xFF${tag.color.replaceAll("#", "")}"))),
                    child: Text(
                      tag.name,
                      style: const TextStyle(fontSize: 13, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }
}
