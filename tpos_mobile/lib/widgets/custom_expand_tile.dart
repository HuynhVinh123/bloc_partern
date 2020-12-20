import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef IconBuilder = Widget Function(BuildContext context, bool expanse);
typedef HeaderBuilder = Widget Function(BuildContext context, bool expanse);

///Sử dụng để nhấn vào mở rộng phần body, tạo giao diện mở rộng tùy chỉnh dễ hơn
/// có thêm iconBuilder giúp xây dụng icon lúc expand
class CustomExpandTitle extends StatefulWidget {
  const CustomExpandTitle({
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
    this.headerBuilder,
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
  final HeaderBuilder headerBuilder;
  final double iconSpace;

  @override
  CustomExpandTitleState createState() => CustomExpandTitleState();
}

class CustomExpandTitleState extends State<CustomExpandTitle> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _heightFactor;
  bool _expand = false;

  @override
  void didUpdateWidget(CustomExpandTitle oldWidget) {
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

  @override
  Widget build(BuildContext context) {
    _heightFactor = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _heightFactor = Tween<double>(begin: 0, end: 1).animate(_heightFactor);

    return InkWell(
      onTap: () {
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
      child: Container(
        color: widget.backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (widget.headerBuilder != null)
              widget.headerBuilder(context, _expand)
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(child: widget.header),
                  if (widget.iconBuilder == null)
                    RotatedBox(
                      quarterTurns: _expand ? 1 : 0,
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                      ),
                    )
                  else
                    widget.iconBuilder(context, _expand),
                  SizedBox(width: widget.iconSpace)
                ],
              ),
            ClipRect(
              child: Align(
                heightFactor: _heightFactor.value,
                child: widget.body,
              ),
            )
          ],
        ),
      ),
    );
  }
}
