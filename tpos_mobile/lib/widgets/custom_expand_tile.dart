import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef IconBuilder = Widget Function(BuildContext context, bool expanse);

///Sử dụng để nhấn vào mở rộng phần body, tạo giao diện mở rộng tùy chỉnh dễ hơn
/// có thêm iconBuilder giúp xây dụng icon lúc expand
class CustomExpandTile extends StatefulWidget {
  const CustomExpandTile({
    Key key,
    this.header,
    this.body = const SizedBox(),
    this.expanse = false,
    this.backgroundColor,
    this.expandCallBack,
    this.update = true,
    this.iconBuilder,
    this.iconSpace = 10,
    this.expanseWhenClick = true,
    this.contentPadding = EdgeInsets.zero,
    this.title,
    this.leading,
    this.onTap,
    this.trailing,
    this.underLine,
    this.isClickExpand = true,
  }) : super(key: key);

  final Widget header;
  final Widget body;
  final bool expanse;

  ///Nếu [update] bằng false thì didUpdateWidget sẽ không cập nhật
  ///[expanse] được truyền vào
  final bool update;
  final bool expanseWhenClick;
  final Color backgroundColor;
  final Function(bool expand) expandCallBack;
  final IconBuilder iconBuilder;
  final double iconSpace;
  final EdgeInsets contentPadding;
  final Widget title;
  final Widget leading;
  final Widget trailing;
  final Widget underLine;
  final GestureTapCallback onTap;
  final bool isClickExpand;

  @override
  CustomExpandTileState createState() => CustomExpandTileState();
}

class CustomExpandTileState extends State<CustomExpandTile>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  AnimationController _controller;
  Animation<double> _heightFactor;
  bool _expand = false;

  @override
  void didUpdateWidget(CustomExpandTile oldWidget) {
    if (widget.update) {
      if (_expand != widget.expanse) {
        _expand = widget.expanse;
        if (_expand) {
          _controller.reset();
          _controller.forward();
        } else {
          _controller.reverse();
        }
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expand = widget.expanse;
    if (_expand) {
      _controller.value = 1;
    }
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void expand() {
    _expand = !_expand;
    if (_expand) {
      _controller.reset();
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _heightFactor = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _heightFactor = Tween<double>(begin: 0, end: 1).animate(_heightFactor);

    return Column(
      children: [
        ListTile(
          contentPadding: widget.contentPadding,
          title: widget.title,
          trailing: Padding(
            padding: EdgeInsets.only(right: widget.iconSpace),
            child: widget.iconBuilder == null
                ? ClipOval(
                    child: Container(
                      height: 50,
                      width: 50,
                      child: Material(
                        color: Colors.transparent,
                        child: IconButton(
                          iconSize: 30,
                          icon: RotatedBox(
                            quarterTurns: _expand ? 3 : 1,
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                            ),
                          ),
                          onPressed: () async {
                            if (widget.expanseWhenClick) {
                              _expand = !_expand;
                              widget.expandCallBack?.call(_expand);
                              if (_expand) {
                                _controller.reset();
                                _controller.forward();
                              } else {
                                _controller.reverse();
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  )
                : widget.iconBuilder(context, _expand),
          ),
          leading: widget.leading,
          onTap: () {
            if (widget.isClickExpand) {
              expand();
            }
            widget.onTap?.call();
          },
        ),
        if (widget.underLine != null) widget.underLine,
        ClipRect(
          child: Align(
            heightFactor: _heightFactor.value,
            child: widget.body,
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
