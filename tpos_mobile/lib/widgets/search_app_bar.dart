import 'dart:async';

import 'package:flutter/material.dart';

class SearchAppBar extends StatefulWidget {
  const SearchAppBar({
    Key key,
    this.onKeyWordChanged,
    this.search = true,
    this.menuActions = const <Widget>[],
    this.actions = const <Widget>[],
    this.closeSearch = false,
    this.text = '',
    this.padding = const EdgeInsets.only(top: 0, left: 5, right: 5),
    this.title,
    this.onBack,
    this.iconSearch,
    this.delaySearch = const Duration(milliseconds: 0),
  }) : super(key: key);

  @override
  SearchAppBarState createState() => SearchAppBarState();
  final Function(String) onKeyWordChanged;
  final Function() onBack;
  final bool search;
  final bool closeSearch;
  final EdgeInsets padding;
  final String text;
  final Widget iconSearch;
  final Duration delaySearch;

  ///nếu không truyền vào danh sách mặc định sẽ là nút menu và nút search
  final List<Widget> menuActions;

  ///danh sách các nút bên trái
  final List<Widget> actions;

  final String title;
}

class SearchAppBarState extends State<SearchAppBar> {
  TextEditingController _controllerSearch;
  FocusNode _searchFocusNode;
  bool _showSearch = false;
  double _screeWidth;
  Timer _debounce;

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) {
      _debounce.cancel();
    }

    _debounce = Timer(widget.delaySearch, () {
      widget.onKeyWordChanged?.call(_controllerSearch.text);
    });
  }

  @override
  void initState() {
    super.initState();
    _controllerSearch = TextEditingController();
    _searchFocusNode = FocusNode();
    _searchFocusNode.addListener(() {
      if (!_searchFocusNode.hasFocus) {
        _showSearch = false;
        setState(() {});
      }
    });
    _controllerSearch.addListener(_onSearchChanged);
  }

  ///Mở tìm kiếm ra
  void openSearch() {
    _searchFocusNode.requestFocus();
    _showSearch = true;
    setState(() {});
  }

  @override
  void didUpdateWidget(SearchAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != _controllerSearch.text) {
      _controllerSearch.text = widget.text;
    }
    if (_showSearch == widget.closeSearch) {
      if (widget.closeSearch) {
        _showSearch = false;
        setState(() {});
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screeWidth = MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    super.dispose();
    _controllerSearch.removeListener(_onSearchChanged);
    _controllerSearch.dispose();
    _debounce?.cancel();
    _searchFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff008E30),
      child: SafeArea(
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    if (widget.menuActions.isEmpty)
                      ClipOval(
                        child: Container(
                          height: 50,
                          width: 50,
                          child: Material(
                            color: Colors.transparent,
                            child: IconButton(
                              iconSize: 30,
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                if (widget.onBack != null) {
                                  widget.onBack.call();
                                } else {
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ...widget.menuActions,
                    if (widget.search)
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: AnimatedSwitcher(
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              return ScaleTransition(
                                scale: animation,
                                alignment: Alignment.centerRight,
                                child: child,
                              );
                            },
                            layoutBuilder: (Widget currentChild, List<Widget> previousChildren) {
                              return Stack(
                                children: <Widget>[
                                  ...previousChildren,
                                  if (currentChild != null) currentChild,
                                ],
                                alignment: Alignment.centerLeft,
                              );
                            },
                            duration: const Duration(milliseconds: 500),
                            child: _showSearch
                                ? Container(
                                    height: 40,
                                    width: _screeWidth,
                                    child: TextField(
                                      cursorColor: Colors.white,
                                      style: const TextStyle(color: Colors.white, fontSize: 17),
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(top: 20, left: 20),
                                        prefixIcon: ClipOval(
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                            child: Material(
                                              color: Colors.transparent,
                                              child: IconButton(
                                                iconSize: 25,
                                                icon: const Icon(
                                                  Icons.search_rounded,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () {
                                                  _showSearch = false;
                                                  setState(() {});
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        // hintText: enabled ? hint : '',
                                        // hintStyle: hintStyle,
                                        filled: true,
                                        suffixIcon: ClipOval(
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                            child: Material(
                                              color: Colors.transparent,
                                              child: IconButton(
                                                iconSize: 25,
                                                icon: const Icon(
                                                  Icons.clear,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () {
                                                  _controllerSearch.text = '';
                                                  setState(() {});
                                                  widget.onKeyWordChanged?.call(_controllerSearch.text);
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        fillColor: const Color.fromARGB(43, 237, 242, 246),
                                        enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(30)),
                                          borderSide: BorderSide(color: Colors.transparent, width: 1),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(30)),
                                          borderSide: BorderSide(color: Colors.transparent),
                                        ),
                                      ),
                                      focusNode: _searchFocusNode,
                                      // style: const TextStyle(
                                      //   fontSize: 14,
                                      //   color: AppColors.focusTextBoxColor,
                                      // ),
                                      controller: _controllerSearch,
                                    ),
                                  )
                                : Row(
                                    children: <Widget>[
                                      if (widget.title != null && widget.title != '')
                                        Expanded(
                                            child: Text(
                                          widget.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 21, color: Colors.white, fontWeight: FontWeight.w500),
                                        )),
                                      widget.iconSearch ??
                                          ClipOval(
                                            child: Container(
                                              height: 50,
                                              width: 50,
                                              child: Material(
                                                color: Colors.transparent,
                                                child: IconButton(
                                                  iconSize: 30,
                                                  icon: const Icon(Icons.search, color: Colors.white),
                                                  onPressed: () {
                                                    _searchFocusNode.requestFocus();
                                                    _showSearch = true;

                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Row(
                children: widget.actions,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
