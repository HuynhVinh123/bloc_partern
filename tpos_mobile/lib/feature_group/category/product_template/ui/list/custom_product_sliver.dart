import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/product_template_bloc.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/product_template_event.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/product_template_state.dart';
import 'package:tpos_mobile/feature_group/category/product_template/ui/add_edit/product_template_add_edit_page.dart';
import 'package:tpos_mobile/helpers/barcode_scan.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

///Xây dựng appbar của product tempalte có animation
///[child] là phần wiget có thể scroll
///[onKeyWordChanged] khi nhập tìm kiếm vào gọi callback này
///[filter] widget dung để lọc
///[keyword] từ khóa khởi tạo cho thanh tìm kiếm
///[autoFocus] tự động focus vào thanh tìm kiếm khi khởi tạo
///[scrollController]  scrollController của widget cuốn ở child
///[productTemplateBloc] bloc dùng để cập nhật khi thêm mới
class CustomProductSliver extends StatefulWidget {
  const CustomProductSliver(
      {Key key,
      this.child,
      this.onKeyWordChanged,
      this.filter,
      this.scrollController,
      this.productTemplateBloc,
      this.keyword = '',
      this.autoFocus = false})
      : super(key: key);

  @override
  _CustomProductSliverState createState() => _CustomProductSliverState();
  final Widget child;
  final Widget filter;
  final Function(String keyword) onKeyWordChanged;
  final String keyword;
  final bool autoFocus;
  final ScrollController scrollController;
  final ProductTemplateBloc productTemplateBloc;
}

class _CustomProductSliverState extends State<CustomProductSliver> with TickerProviderStateMixin {
  final TextEditingController _keywordController = TextEditingController();
  ScrollController _scrollController;
  final FocusNode _focusNode = FocusNode();

  static const double FILTER_HEIGHT = 60;
  double _lastScrollOffset = 0;
  AnimationController _controller;
  AnimationController _actionController;

  Animation _leftTextFieldAnimation;
  Animation _topTextFieldAnimation;
  Animation _rightTextFieldAnimation;

  Animation _rightFilterAnimation;

  Animation _topFilterAnimation;
  Animation _opacityAnimation;
  Animation _heightAnimation;
  Animation _topActionAnimation;

  double _begin = FILTER_HEIGHT;
  double _end = 0;
  double _lastEnd = 0;

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) {
      _debounce.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onKeyWordChanged?.call(_keywordController.text);
    });
  }

  Timer _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController;
    _controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _actionController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _controller.addListener(() {
      setState(() {});
    });
    _actionController.addListener(() {
      setState(() {});
    });
    _keywordController.text = widget.keyword;
    _keywordController.addListener(_onSearchChanged);

    if (widget.autoFocus) {
      _focusNode.requestFocus();
    }

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.forward();

        _end = FILTER_HEIGHT;
        _actionController.forward();
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
    _leftTextFieldAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _leftTextFieldAnimation = Tween<double>(begin: 10, end: 60).animate(_leftTextFieldAnimation);

    _topTextFieldAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _topTextFieldAnimation = Tween<double>(begin: 60, end: 15).animate(_topTextFieldAnimation);

    _rightTextFieldAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _rightTextFieldAnimation = Tween<double>(begin: 50, end: 80).animate(_rightTextFieldAnimation);

    _heightAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _heightAnimation = Tween<double>(begin: 110, end: 65).animate(_heightAnimation);

    _opacityAnimation = CurvedAnimation(parent: _controller, curve: Curves.ease);
    _opacityAnimation = Tween<double>(begin: 1, end: 0).animate(_opacityAnimation);

    _rightFilterAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _rightFilterAnimation = Tween<double>(begin: 10, end: 40).animate(_rightFilterAnimation);

    _topFilterAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _topFilterAnimation = Tween<double>(begin: 60, end: 15).animate(_topFilterAnimation);

    _topActionAnimation = CurvedAnimation(parent: _actionController, curve: Curves.easeInOut);
    _topActionAnimation = Tween<double>(begin: _begin, end: _end).animate(_topActionAnimation);
    return Column(
      children: [
        _buildAppbarAnimation(),
        if (widget.child != null)
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!_focusNode.hasFocus) {
                  ///đang scroll xuống
                  if (_lastScrollOffset < scrollInfo.metrics.pixels) {
                    final double offset = _lastScrollOffset - scrollInfo.metrics.pixels;
                    _end = _lastEnd;
                    _lastEnd = _lastEnd + offset;
                    _lastEnd = _lastEnd < 0 ? 0 : _lastEnd;
                    _begin = _lastEnd;

                    _actionController.forward();
                  }

                  ///đang scroll lên
                  else if (_lastScrollOffset > scrollInfo.metrics.pixels) {
                    final double offset = _lastScrollOffset - scrollInfo.metrics.pixels;
                    _end = _lastEnd;
                    _lastEnd = _lastEnd + offset;
                    _lastEnd = _lastEnd > FILTER_HEIGHT ? FILTER_HEIGHT : _lastEnd;
                    _begin = _lastEnd;

                    _actionController.forward();
                  }

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
                      _controller.value = scrollInfo.metrics.pixels / FILTER_HEIGHT;
                      setState(() {});
                    } else {
                      _controller.value = 0;
                      setState(() {});
                    }
                  }
                }

                _lastScrollOffset = scrollInfo.metrics.pixels;

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

  ///Giao diện appbar có animation khi trượt lên và xuống
  Widget _buildAppbarAnimation() {
    return Column(
      children: [
        Container(
          height: _heightAnimation.value + MediaQuery.of(context).padding.top,
          width: double.infinity,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          decoration: const BoxDecoration(
              gradient: LinearGradient(begin: Alignment(-1.0, 1.0), end: Alignment(0.5, -1.0), stops: [
            0.1,
            0.5,
            0.5,
            0.9
          ], colors: [
            Color(0xff1d7d27),
            Color(0xff3ba734),
            Color(0xff43af35),
            Color(0xff63c938),
          ])),
          child: Stack(
            children: [
              Positioned(
                top: 10,
                left: 5,
                child: Row(
                  children: [
                    if (_focusNode.hasFocus)
                      ClipOval(
                        child: Container(
                          height: 50,
                          width: 50,
                          child: Material(
                            color: Colors.transparent,
                            child: IconButton(
                              iconSize: 25,
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                FocusScope.of(context).requestFocus(FocusNode());
                              },
                            ),
                          ),
                        ),
                      )
                    // IconButton(
                    //   iconSize: 25,
                    //   icon: const Icon(
                    //     Icons.close,
                    //     color: Colors.white,
                    //   ),
                    //   onPressed: () {
                    //     FocusScope.of(context).requestFocus(FocusNode());
                    //   },
                    // )
                    else
                      ClipOval(
                        child: Container(
                          height: 50,
                          width: 50,
                          child: Material(
                            color: Colors.transparent,
                            child: IconButton(
                              iconSize: 25,
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ),
                      ),
                    // IconButton(
                    //   iconSize: 25,
                    //   icon: const Icon(
                    //     Icons.arrow_back,
                    //     color: Colors.white,
                    //   ),
                    //   onPressed: () {
                    //     Navigator.of(context).pop();
                    //   },
                    // ),
                    Opacity(
                      opacity: _opacityAnimation.value,
                      child: Text(
                        S.of(context).product,
                        style: const TextStyle(color: Colors.white, fontSize: 24),
                      ),
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
                child: ClipOval(
                  child: Container(
                    height: 40,
                    width: 40,
                    child: Material(
                      color: Colors.transparent,
                      child: IconButton(
                        onPressed: () async {
                          Scaffold.of(context).openEndDrawer();
                        },
                        icon: Stack(
                          overflow: Overflow.visible,
                          alignment: Alignment.center,
                          children: [
                            const Icon(Icons.filter_list, color: Colors.white, size: 30),
                            Positioned(
                                top: -5,
                                right: -5,
                                child: Container(
                                    width: 17,
                                    height: 17,
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.red),
                                    child: Center(
                                        child: BlocBuilder<ProductTemplateBloc, ProductTemplateState>(
                                      builder: (BuildContext context, state) {
                                        int filterCount = 0;
                                        if (state.isFilterCategory) {
                                          filterCount += 1;
                                        }
                                        if (state.isFilterProductPrice) {
                                          filterCount += 1;
                                        }
                                        if (state.isFilterTag) {
                                          filterCount += 1;
                                        }
                                        return Text(
                                          filterCount.toString(),
                                          style: const TextStyle(color: Colors.white),
                                        );
                                      },
                                      cubit: widget.productTemplateBloc,
                                    )))),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 13,
                child: ClipOval(
                  child: Material(
                    color: Colors.transparent,
                    child: IconButton(
                      iconSize: 30,
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        final bool isInsert = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProductTemplateAddEditPage(),
                          ),
                        );

                        if (isInsert != null && isInsert) {
                          widget.productTemplateBloc.add(ProductTemplateRefreshed());
                        }
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          height: _topActionAnimation.value,
          child: SingleChildScrollView(child: widget.filter),
        ),
      ],
    );
  }

  /// Giao diện search Product
  Widget _buildSearch() {
    return GestureDetector(
      onTap: () {
        _focusNode.requestFocus();
      },
      child: Container(
        decoration:
            BoxDecoration(color: const Color.fromARGB(43, 237, 242, 246), borderRadius: BorderRadius.circular(24)),
        height: 40,
        width: MediaQuery.of(context).size.width - _leftTextFieldAnimation.value - _rightTextFieldAnimation.value,
        child: Center(
          child: StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return Row(
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
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(0),
                                  isDense: true,
                                  hintText: S.of(context).enter_name_code_product,
                                  hintStyle: TextStyle(color: Colors.white.withAlpha(137)),
                                  border: InputBorder.none),
                            ),
                          )),
                    ),
                  ),
                  Visibility(
                    visible: _focusNode.hasFocus,
                    child: Row(
                      children: [
                        ClipOval(
                          child: Container(
                            height: 40,
                            width: 40,
                            child: Material(
                              color: Colors.transparent,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  size: 18,
                                  color: Color.fromARGB(183, 243, 253, 242),
                                ),
                                onPressed: () {
                                  _keywordController.text = '';
                                  widget.onKeyWordChanged?.call(_keywordController.text);
                                },
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10, left: 0),
                          child: VerticalDivider(
                            width: 1,
                            color: Color.fromARGB(183, 243, 253, 242),
                          ),
                        )
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Image.asset("images/scan_barcode.png",
                        width: 28, height: 24, color: const Color.fromARGB(183, 243, 253, 242)),
                    onPressed: () async {
                      final result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return BarcodeScan();
                      }));
                      if (result != null) {
                        _keywordController.text = result;
                      }
                    },
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
