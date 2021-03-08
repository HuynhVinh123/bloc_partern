import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class AddEditSlide extends StatelessWidget {
  const AddEditSlide({Key key, this.onDelete, this.onEdit, this.child}) : super(key: key);
  final Function() onDelete;
  final Function() onEdit;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: key,
      secondaryActions: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          child: Padding(
            padding: const EdgeInsets.only(right: 2),
            child: Material(
              color: const Color(0xffF2F4F7),
              child: InkWell(
                onTap: () {
                  onEdit?.call();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Flexible(
                        child: Icon(
                      Icons.edit,
                      color: Color(0xff858F9B),
                    )),
                    Flexible(
                      child: Text(
                        S.current.edit,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(color: Color(0xff7E8595)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          child: Padding(
            padding: const EdgeInsets.only(left: 2, right: 2),
            child: Material(
              color: const Color(0xffEB3B5B),
              child: InkWell(
                onTap: () {
                  onDelete?.call();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Flexible(
                        child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    )),
                    Flexible(
                      child: Text(
                        S.current.delete,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
      actionPane: const SlidableStrechActionPane(),
      child: child,
    );
  }
}
