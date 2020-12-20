import 'package:flutter/material.dart';

class AppAppBarSearchTitle extends StatefulWidget {
  final Widget title;
  final Key key;
  final ValueChanged<String> onSearch;
  final String initKeyword;
  final TextEditingController controller;
  AppAppBarSearchTitle(
      {this.key,
      this.title,
      this.onSearch,
      this.initKeyword,
      @required this.controller})
      : super(key: key);
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
      padding: EdgeInsets.only(left: 10, right: 10),
      margin: EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
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
                  ? Icon(
                      Icons.cancel,
                      color: Colors.grey,
                      size: 16,
                    )
                  : SizedBox(),
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
