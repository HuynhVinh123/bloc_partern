import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/tpage/settings/blocs/tags/tag_bloc.dart';
import 'package:tpos_mobile/feature_group/tpage/settings/blocs/tags/tag_event.dart';
import 'package:tpos_mobile/feature_group/tpage/settings/color_tag.dart';

class TagAddEditPage extends StatefulWidget {
  const TagAddEditPage({@required this.bloc, this.tagTPage})
      : assert(bloc != null);
  final TagBloc bloc;
  final CRMTag tagTPage;
  @override
  _TagAddEditPageState createState() => _TagAddEditPageState();
}

class _TagAddEditPageState extends State<TagAddEditPage> {
  bool isActive;
  List<Color> colors = [];
  List<bool> isSelects = [];

  int positionChecked;
  final TextEditingController _nameController = TextEditingController();
  String errorText;

  @override
  void initState() {
    colors = colorTags();
    // ignore: avoid_function_literals_in_foreach_calls
    colors.forEach((element) {
      isSelects.add(false);
    });
    isActive = false;
    if (widget.tagTPage != null) {
      isActive = !widget.tagTPage.isDeleted;
      _nameController.text = widget.tagTPage.name;
      positionChecked = colors.indexWhere((element) =>
          element
              .toString()
              .replaceAll("Color(0xff", "#")
              .replaceAll(")", "") ==
          widget.tagTPage.colorClassName);
      isSelects[positionChecked] = true;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.only(bottom: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          width: 0,
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 16),
              child: Row(
                children: const [
                  Text(
                    "Thêm nhãn hội thoại",
                    style: TextStyle(color: Color(0xFF2C333A), fontSize: 20),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 0),
              child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.close,
                    size: 20,
                    color: Color(0xFF929DAA),
                  )),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Tên nhãn",
                  style: TextStyle(color: Color(0xFF929DAA), fontSize: 12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      hintText: "Tên nhãn", errorText: errorText),
                  style: const TextStyle(color: Color(0xFF2C333A)),
                ),
              ),
              buildContain()
            ]),
      ),
      actions: <Widget>[
        Container(
          width: 120,
          height: 40,
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE9EDF2)),
              borderRadius: BorderRadius.circular(5)),
          child: FlatButton(
            child: const Text(
              "Hủy",
              style: TextStyle(color: Color(0xFF5A6271)),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        Container(
          width: 120,
          height: 40,
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF28A745)),
              borderRadius: BorderRadius.circular(5)),
          child: FlatButton(
            child: Text(
              widget.tagTPage != null ? "Lưu" : "Tạo mới",
              style: const TextStyle(color: Color(0xFF28A745)),
            ),
            onPressed: () async {
              if (_nameController.text != "" && positionChecked != null) {
                errorText = null;
                Navigator.pop(context);
                if (widget.tagTPage != null) {
                  final CRMTag tagTPage = widget.tagTPage;
                  tagTPage.name = _nameController.text;
                  tagTPage.colorClassName = colors[positionChecked]
                      .toString()
                      .replaceAll("Color(0xff", "#")
                      .replaceAll(")", "");
                  tagTPage.isDeleted = !isActive;
                  widget.bloc.add(TagUpdated(tag: tagTPage));
                } else {
                  widget.bloc.add(TagAdded(
                      tag: CRMTag(
                          colorClassName: colors[positionChecked]
                              .toString()
                              .replaceAll("Color(0xff", "#")
                              .replaceAll(")", ""),
                          isDeleted: !isActive,
                          name: _nameController.text)));
                }
              } else {
                if (_nameController.text == "") {
                  setState(() {
                    errorText = "Tên nhãn không được để trống!";
                  });
                } else {
                  setState(() {
                    errorText = null;
                  });
                }
              }
            },
          ),
        ),
      ],
    );
  }

  /// Build nội dung thêm
  Widget buildContain() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 24,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Chọn màu nhãn",
            style: TextStyle(color: Color(0xFF2C333A), fontSize: 12),
          ),
        ),
        Container(
          margin:
              const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 6),
          width: MediaQuery.of(context).size.width,
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: colors.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(right: 13),
                child: BoxColor(
                  isVisible: isSelects[index],
                  color: colors[index],
                  onPress: () {
                    setState(() {
                      for (int i = 0; i < colors.length; i++) {
                        if (index == i) {
                          isSelects[i] = true;
                          positionChecked = i;
                        } else {
                          isSelects[i] = false;
                        }
                      }
                    });
                  },
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Visibility(
              visible: positionChecked == null,
              child: const Text(
                "Không được để trống màu",
                style: TextStyle(color: Colors.red, fontSize: 12),
              )),
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            const SizedBox(
              width: 4,
            ),
            Switch.adaptive(
              value: isActive,
              onChanged: (value) {
                setState(() {
                  isActive = !isActive;
                });
              },
              activeColor: const Color(0xFF28A745),
            ),
            const Text(
              "Kích hoạt",
              style: TextStyle(color: Color(0xFF2C333A)),
            )
          ],
        )
      ],
    );
  }
}

/// Ô tròn hiển thị màu
class BoxColor extends StatelessWidget {
  const BoxColor({@required this.color, this.isVisible = false, this.onPress})
      : assert(color != null);
  final Color color;
  final bool isVisible;
  final VoidCallback onPress;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress ?? () {},
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        child: Visibility(
          visible: isVisible,
          child: const Center(
            child: Icon(
              Icons.check,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
