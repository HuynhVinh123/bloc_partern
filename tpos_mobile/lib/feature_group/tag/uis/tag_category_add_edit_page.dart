import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/tag/bloc/tag_category_add_edit/tag_category_add_edit_bloc.dart';
import 'package:tpos_mobile/feature_group/tag/bloc/tag_category_add_edit/tag_category_add_edit_event.dart';
import 'package:tpos_mobile/feature_group/tag/bloc/tag_category_add_edit/tag_category_add_edit_state.dart';
import 'package:tpos_mobile/feature_group/tag/tag_type_helper.dart';
import 'package:tpos_mobile/helpers/color.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

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
  final ScrollController _scrollController = ScrollController();
  final String errorNameTag = S.current.mailTemplate_NameCannotBeEmpty;
  final String errorTagType =
      "${S.current.tags_TagType} ${S.current.tags_cannotBeEmpty}!";

  List<Color> _colors;
  List<Type> _typeTags;
  Color _colorTag;
  String _typeTag;
  int _position = -1;
  bool _isEmptyName = false;
  bool _isEmptyTagType = false;

  @override
  void initState() {
    super.initState();
    _typeTags = tagTypeHelpers();
    _colors = colorHelper();

    if (widget.tag != null) {
      final int tagColor =
          int.parse("0xFF${widget.tag.color.replaceAll("#", "")}");
      _typeTag = widget.tag.type;
      _nameController.text = widget.tag.name;
      _position = _colors.indexWhere((element) => element.value == tagColor);
      if (_position != -1) {
        _colorTag = _colors[_position];
        _colors.removeAt(_position);
        _colors.insert(0, _colorTag);
        _position = 0;
      } else {
        _colors.insert(0, Color(tagColor));
        _position = 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocUiProvider<TagCategoryAddEditBloc>(
      listen: (state) {
        if (state is TagCategoryAddEditActionSuccess) {
          Navigator.pop(context, true);
          App.showToast(
              title: state.title, message: state.message, context: context);
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
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context)?.requestFocus(FocusNode());
          },
          child: Scaffold(appBar: _buildAppBar(), body: _buildBody()),
        ),
      ),
    );
  }

  /// UI appbar
  Widget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      // Thêm nhãn mới
      title: widget.tag != null
          ? Text(S.current.tags_EditTag)
          : Text(S.current.tags_AddTag),
      actions: [
        IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              onSaveData();
            }),
      ],
    );
  }

  /// UI hiển thị thông tin tổng quan page
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
          Row(
            children: [
              Expanded(
                child: TextField(
                    controller: _nameController,
                    // Tên nhãn
                    decoration: InputDecoration(
                        labelText: S.current.name,
                        labelStyle: const TextStyle(color: Color(0xFF929DAA)),
                        border: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        errorText: _isEmptyName ? errorNameTag : null)),
              ),
              Visibility(
                visible: widget.tag != null,
                child: Container(
                  width: 85,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: widget.tag != null
                          ? _colors[_position]
                          : Colors.white),
                  child: Text(
                    _nameController.text,
                    style: const TextStyle(fontSize: 13, color: Colors.white),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            ],
          ),
          // divider,
          const SizedBox(
            height: 8,
          ),
          //"Loại nhãn
          Text(
            S.current.tags_TagType,
            style: const TextStyle(color: Color(0xFF2C333A), fontSize: 16),
          ),
          _buildTypeTag(),
          divider,
          Visibility(
              visible: _isEmptyTagType,
              child: Text(
                errorTagType,
                style: const TextStyle(color: Colors.red),
              )),
          const SizedBox(
            height: 12,
          ),
          // Chọn màu nhãn
          Text(
            S.current.tags_TagColor,
            style: const TextStyle(color: Color(0xFF2C333A), fontSize: 16),
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
                  child: Text(
                    S.current.save,
                    style: const TextStyle(color: Colors.white),
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

  /// UI hiển thị thông tin loại nhãn
  Widget _buildTypeTag() => DropdownButton(
        style: const TextStyle(color: Color(0xFF929DAA)),
        hint: Text(S.current.tags_TagType),
        items: _typeTags
            .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
            .toList(),
        onChanged: (value) {
          FocusScope.of(context)?.requestFocus(FocusNode());
          setState(() {
            _typeTag = value;
          });
        },
        isExpanded: true,
        value: _typeTag,
        underline: const SizedBox(),
      );

  /// Thực hiện lưu thông tin nhãn
  void onSaveData() {
    if (_nameController.text != "" && _typeTag != null) {
      _isEmptyName = false;
      String myColor = "#23b7e5";
      if (_position != -1) {
        myColor = _colors[_position].toString().replaceAll("Color(0xFF", "#");
        myColor = myColor.replaceAll("Color(0xff", "#");
        myColor = myColor.replaceAll(")", "");
      }
      if (widget.tag != null) {
        final Tag tag = Tag();
        tag.id = widget.tag.id;
        tag.name = _nameController.text;
        tag.type = _typeTag;
        tag.nameNosign = null;
        tag.color = myColor;
        _bloc.add(TagCategoryUpdated(tag: tag));
      } else {
        final Tag tag = Tag();
        // tag.color = widget;
        tag.name = _nameController.text;
        tag.type = _typeTag;
        tag.color = myColor;
        _bloc.add(TagCategoryAdded(tag: tag));
      }
    } else {
      setState(() {
        _isEmptyName = _nameController.text == '';
        _isEmptyTagType = _typeTag == null;
      });

      App.showToast(
          title: S.current.notification,
          message:
              "\'${S.current.tags_TagName}\' & \'${S.current.tags_TagType}\' ${S.current.tags_cannotBeEmpty}!");
    }
  }

  /// UI hiển thị danh sách mầu sắc
  Widget _buildColors() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      height: 42,
      child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: _colors.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  _position = index;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                    color: _colors[index], shape: BoxShape.circle),
                child: Visibility(
                  visible: _position == index,
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
