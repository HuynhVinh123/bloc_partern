import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/conversation/bloc/conversation_list_bloc.dart';

///Xây dựng appbar của product tempalte có animation
class ListConversationAnimation extends StatefulWidget {
  const ListConversationAnimation(
      {Key key,
      this.child,
      this.onKeyWordChanged,
      this.filter,
      this.titleAppBar,
      this.scrollController,
      this.onPressPopup,
      this.onPressFilterPopup,
      this.onPressBack,
      this.popupMenu,
      this.conversationListBloc,
      this.type,
      this.crmTeam,
      this.count})
      : assert(child != null ||
            onKeyWordChanged != null ||
            filter != null ||
            titleAppBar != null ||
            scrollController != null ||
            onPressFilterPopup != null ||
            onPressPopup != null ||
            onPressBack != null ||
            type != null),
        super(key: key);

  @override
  _ListConversationAnimationState createState() =>
      _ListConversationAnimationState();
  final Widget child;
  final Widget filter;
  final Widget popupMenu;

  /// Thanh tìm kiếm
  final Function(String keyword) onKeyWordChanged;

  /// Tiêu đề trên appbar
  final Widget titleAppBar;
  final ScrollController scrollController;

  /// Nút lọc trên appbar
  final VoidCallback onPressPopup;

  /// Nút lọc từ a->z trên appbar
  final VoidCallback onPressFilterPopup;

  /// Nút back
  final VoidCallback onPressBack;
  final ConversationListBloc conversationListBloc;
  final String type;
  final CRMTeam crmTeam;
  final int count;
}

class _ListConversationAnimationState extends State<ListConversationAnimation>
    with SingleTickerProviderStateMixin {
  final TextEditingController _keywordController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  ScrollController _scrollController;
  static const double FILTER_HEIGHT = 76;
  AnimationController _controller;

  /// Animation cho textfield
  Animation _leftTextFieldAnimation;
  Animation _topTextFieldAnimation;
  Animation _rightTextFieldAnimation;

  /// Animation cho nút lọc
  Animation _rightFilterAnimation;
  Animation _topFilterAnimation;

  /// Animation Opacity
  Animation _opacityAnimation;
  Animation _heightAnimation;

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) {
      _debounce.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onKeyWordChanged?.call(_keywordController.text);
    });
  }

  Timer _debounce;

  ///
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _controller.addListener(() {
      setState(() {});
    });

    _keywordController.addListener(_onSearchChanged);

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.forward();
        if (_controller.value == 1) {
          setState(() {});
        }
      } else {
        try {
          if (_scrollController.offset < FILTER_HEIGHT) {
            _controller.reverse();
          } else {
            setState(() {});
          }
        } catch (e) {
          _controller.reverse();
        }
      }
    });
    _scrollController = widget.scrollController;
  }

  @override
  void dispose() {
    super.dispose();
    _keywordController.removeListener(_onSearchChanged);
    _keywordController.dispose();
    _debounce?.cancel();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _leftTextFieldAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _leftTextFieldAnimation =
        Tween<double>(begin: 10, end: 60).animate(_leftTextFieldAnimation);
    _topTextFieldAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _topTextFieldAnimation =
        Tween<double>(begin: 60, end: 15).animate(_topTextFieldAnimation);

    _rightTextFieldAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _rightTextFieldAnimation =
        Tween<double>(begin: 100, end: 90).animate(_rightTextFieldAnimation);

    _heightAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _heightAnimation =
        Tween<double>(begin: 115, end: 70).animate(_heightAnimation);
    _opacityAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.ease);
    _opacityAnimation =
        Tween<double>(begin: 1, end: 0).animate(_opacityAnimation);

    _rightFilterAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _rightFilterAnimation =
        Tween<double>(begin: 10, end: 10).animate(_rightFilterAnimation);

    _topFilterAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _topFilterAnimation =
        Tween<double>(begin: 55, end: 15).animate(_topFilterAnimation);

    return Column(
      children: [
        _buildAppbarAnimation(),
        if (widget.child != null)
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!_focusNode.hasFocus) {
                  if (scrollInfo is ScrollEndNotification) {
                    if (_controller.value < 0.6) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollController.animateTo(
                          0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      });
                      _controller.reverse();
                    } else if (_controller.value < 1) {
                      if (_scrollController.offset < FILTER_HEIGHT) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _scrollController.animateTo(
                            FILTER_HEIGHT,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        });
                      }

                      _controller.forward();
                    }
                  } else if (scrollInfo is ScrollUpdateNotification) {
                    if (scrollInfo.metrics.pixels > FILTER_HEIGHT) {
                      _controller.value = 1;
                      setState(() {});
                    } else if (scrollInfo.metrics.pixels > 0) {
                      _controller.value =
                          scrollInfo.metrics.pixels / FILTER_HEIGHT;
                      setState(() {});
                    } else {
                      _controller.value = 0;
                      setState(() {});
                    }
                  }
                }
                return false;
              },
              child: widget.child,
            ),
          )
        else
          const SizedBox(),
      ],
    );
  }

  /// Animation cho appbar khi scroll
  Widget _buildAppbarAnimation() {
    return Container(
      height: _heightAnimation.value + MediaQuery.of(context).padding.top,
      width: double.infinity,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-1.0, 1.0),
          end: Alignment(0.5, -1.0),
          stops: [
            0.1,
            0.5,
            0.5,
            0.9,
          ],
          colors: [
            Color(0xff1d7d27),
            Color(0xff3ba734),
            Color(0xff43af35),
            Color(0xff63c938),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 10,
            left: 5,
            right: 0,
            child: Row(
              children: [
                if (_focusNode.hasFocus)
                  BackButton(
                      color: Colors.white,
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                      })
                else
                  IconButton(
                    iconSize: 30,
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      widget.onPressBack();
                    },
                  ),
                Opacity(
                  opacity: _opacityAnimation.value,
                  child: widget.titleAppBar,
                ),
              ],
            ),
          ),
          Positioned(
              top: _topTextFieldAnimation.value,
              left: _leftTextFieldAnimation.value,
              right: _rightTextFieldAnimation.value,
              child: _buildSearch()),
          Positioned(
            top: _topFilterAnimation.value,
            right: _rightFilterAnimation.value,
            child: Container(
              height: 40,
              width: 40,
              child: IconButton(
                onPressed: () {
                  widget.onPressPopup();
                },
                icon: Stack(
                  overflow: Overflow.visible,
                  children: [
                    const Icon(
                      Icons.filter_list,
                      color: Colors.white,
                      size: 30,
                    ),
                    Positioned(
                        top: -5,
                        right: -5,
                        child: Container(
                            width: 17,
                            height: 17,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Colors.red),
                            child: Center(
                              child: Text(
                                widget.count.toString() ?? 0,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ))),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: _topFilterAnimation.value,
            right: _rightFilterAnimation.value + 30,
            child: IconButton(
              iconSize: 30,
              icon: Image.asset('images/sort_icon.png'),
              onPressed: () async {
                widget.onPressFilterPopup();
              },
            ),
          ),
          Positioned(
            right: 0,
            top: 10,
            child: Opacity(
                opacity: _opacityAnimation.value,
                child: _opacityAnimation.value != 0 ? widget.popupMenu : null),
          ),
        ],
      ),
    );
  }

  /// Giao diện search Product
  Widget _buildSearch() {
    return Container(
      decoration: BoxDecoration(
          color: const Color.fromARGB(43, 237, 242, 246),
          borderRadius: BorderRadius.circular(24)),
      height: 40,
      width: MediaQuery.of(context).size.width -
          _leftTextFieldAnimation.value -
          _rightTextFieldAnimation.value,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(width: 12),
            const Icon(Icons.search, color: Colors.white),
            Expanded(
              child: Center(
                child: Container(
                    height: 35,
                    margin: const EdgeInsets.only(left: 4),
                    child: Center(
                      child: TextField(
                        controller: _keywordController,
                        focusNode: _focusNode,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(0),
                            isDense: true,
                            hintText: 'Tìm kiếm hội thoại, KH...',
                            hintStyle:
                                TextStyle(color: Colors.white.withAlpha(137)),
                            border: InputBorder.none),
                        onChanged: (value) {
                          widget.conversationListBloc.add(
                              ConversationSearchLoaded(
                                  keyword: value,
                                  pageId: widget.crmTeam.facebookPageId,
                                  type: widget.type,
                                  page: 1,
                                  limit: 20));
                        },
                      ),
                    )),
              ),
            ),
            Visibility(
              visible: _keywordController.text != "",
              child: Row(
                children: [
                  IconButton(
                    constraints: const BoxConstraints(
                      minWidth: 24,
                      minHeight: 48,
                    ),
                    padding: const EdgeInsets.all(0.0),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 19,
                    ),
                    onPressed: () {
                      _keywordController.text = '';
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10, left: 5),
                    child: VerticalDivider(
                      width: 1,
                      color: Color.fromARGB(79, 207, 253, 190),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 8,
            ),
          ],
        ),
      ),
    );
  }
}
