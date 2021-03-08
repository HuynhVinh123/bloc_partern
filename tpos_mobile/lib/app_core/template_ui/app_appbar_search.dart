import 'package:flutter/material.dart';

@Deprecated('Sẽ được viết lại nên bỏ luôn nhé. Không dùng lại khi viết mới')
class AppAppBarSearchTitle extends StatefulWidget {
  const AppAppBarSearchTitle(
      {Key key,
      this.title,
      this.onSearch,
      this.initKeyword,
      @required this.controller})
      : super(key: key);
  final Widget title;
  final ValueChanged<String> onSearch;
  final String initKeyword;
  final TextEditingController controller;

  @override
  _AppAppBarSearchTitleState createState() => _AppAppBarSearchTitleState();
}

class _AppAppBarSearchTitleState extends State<AppAppBarSearchTitle> {
  TextEditingController get controller => widget.controller;
  bool get isCancelVisible => controller.text != null && controller.text != "";
  @override
  void initState() {
    controller.text = widget.initKeyword ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(left: 10, right: 10),
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(0),
                  hintText: "Tìm kiếm",
                  border: InputBorder.none),
              onChanged: (text) {
                setState(() {
                  if (widget.onSearch != null) widget.onSearch(text);
                });
              },
            ),
          ),
          InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: isCancelVisible
                  ? const Icon(
                      Icons.cancel,
                      color: Colors.grey,
                      size: 16,
                    )
                  : const SizedBox(),
            ),
            onTap: () {
              controller.clear();
              if (widget.onSearch != null) widget.onSearch("");
            },
          ),
        ],
      ),
    );
  }
}
