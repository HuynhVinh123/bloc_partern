import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/tag/bloc/tag_category_add_edit/tag_category_add_edit_bloc.dart';
import 'package:tpos_mobile/feature_group/tag/bloc/tag_category_add_edit/tag_category_add_edit_event.dart';
import 'package:tpos_mobile/feature_group/tag/bloc/tag_category_add_edit/tag_category_add_edit_state.dart';
import 'package:tpos_mobile/feature_group/tag/bloc/tag_event.dart';
import 'package:tpos_mobile/feature_group/tag/tag_type_helper.dart';
import 'package:tpos_mobile/helpers/color.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';

import '../../../app.dart';

class TagCategoryAddEditPage extends StatefulWidget {
  const TagCategoryAddEditPage({this.tag});

  final Tag tag;

  @override
  _TagCategoryAddEditPageState createState() => _TagCategoryAddEditPageState();
}

class _TagCategoryAddEditPageState extends State<TagCategoryAddEditPage> {
  final TagCategoryAddEditBloc _bloc = TagCategoryAddEditBloc();
  final TextEditingController _nameController = TextEditingController();
  List<Color> colors;
  List<Type> typeTags;
  Color colorTag;
  String typeTag;
  int position = -1;
  String errorNameTag;
  bool isEmptyName = false;

  @override
  void initState() {
    super.initState();
    typeTags = tagTypeHelpers();
    colors = colorHelper();

    if (widget.tag != null) {
      final int tagColor =
      int.parse("0xFF${widget.tag.color.replaceAll("#", "")}");
      typeTag = widget.tag.type;
      _nameController.text = widget.tag.name;
      position = colors.indexWhere((element) => element.value == tagColor);
      if (position != -1) {
        colorTag = colors[position];
      } else {
        colors.insert(0, Color(tagColor));
        position = 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocUiProvider<TagCategoryAddEditBloc>(
      listen: (state) {
        if (state is TagCategoryAddEditActionSuccess) {
          Navigator.pop(context, true);
          // App.showToast(
          //     title: state.title, message: state.message, context: context);
        } else if (state is TagCategoryAddEditActionFailure) {
          App.showDefaultDialog(
              title: state.title,
              content: state.message,
              context: context,
              type: AlertDialogType.error);
        }
      },
      bloc: _bloc,
      child: BlocLoadingScreen<TagCategoryAddEditBloc>(
        busyStates: const [TagCategoryAddEditLoading],
        child: Scaffold(
          appBar: _buildAppBar(),
          body: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: const Text("Thêm nhãn mới"),
      actions: [
        IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              onSaveData();
            }),
      ],
    );
  }

  Widget _buildBody() {
    const divider = Divider(
      height: 1,
    );
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
                labelText: "Tên nhãn",
                labelStyle: const TextStyle(color: Color(0xFF929DAA)),
                border: InputBorder.none,
                errorText: isEmptyName ? errorNameTag : null),
          ),
          divider,
          const SizedBox(
            height: 8,
          ),
          const Text(
            "Loại nhãn",
            style: TextStyle(color: Color(0xFF2C333A), fontSize: 16),
          ),
          _buildTypeTag(),
          divider,
          const SizedBox(
            height: 12,
          ),
          const Text(
            "Chọn màu nhãn",
            style: TextStyle(color: Color(0xFF2C333A), fontSize: 16),
          ),
          _buildColors(),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: const Color(0xFF28A745),
                    borderRadius: BorderRadius.circular(8)),
                child: FlatButton(
                  child: const Text(
                    "Lưu",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    onSaveData();
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTypeTag() => DropdownButton(
        style: const TextStyle(color: Color(0xFF929DAA)),
        hint: const Text("Loại nhãn"),
        items: typeTags
            .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
            .toList(),
        onChanged: (value) {
          setState(() {
            typeTag = value;
          });
        },
        isExpanded: true,
        value: typeTag,
        underline: const SizedBox(),
      );

  void onSaveData() {
    if (_nameController.text != "" && typeTag != null) {
      String myColor = "#23b7e5";
      if(position != -1){
          myColor = colors[position].toString().replaceAll("Color(0xFF", "#");
          myColor = myColor.replaceAll("Color(0xff", "#");
          myColor = myColor.replaceAll(")", "");
      }
      if (widget.tag != null) {
        Tag tag = Tag();
        tag.id = widget.tag.id;
        tag.name = _nameController.text;
        tag.type = typeTag;
        tag.nameNosign = null;
        tag.color = myColor;
        _bloc.add(TagCategoryUpdated(tag: tag));
      } else {
        Tag tag = Tag();
        // tag.color = widget;
        tag.name = _nameController.text;
        tag.type = typeTag;
        tag.color = myColor;
        _bloc.add(TagCategoryAdded(tag: tag));
      }
    } else {
      App.showToast(
          title: "Thông báo",
          message: "\'Tên nhãn\' và \'Loại nhãn\ không được để trống!");
    }
  }

  Widget _buildColors() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      height: 42,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: colors.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  position = index;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                width: 36,
                height: 36,
                decoration:
                    BoxDecoration(color: colors[index], shape: BoxShape.circle),
                child: Visibility(
                  visible: position == index,
                  child: const Center(
                      child: Icon(
                    Icons.check,
                    color: Colors.white,
                  )),
                ),
              ),
            );
          }),
    );
  }
}
