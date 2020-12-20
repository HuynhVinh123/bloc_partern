import 'package:flutter/material.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class EmptyData extends StatelessWidget {
  const EmptyData({Key key, this.onPressed}) : super(key: key);
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 70,
            width: 70,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Transform.scale(
                scale: 1.65,
//                child: FlareActor(
//                  "images/empty_state.flr",
//                  alignment: Alignment.center,
//                  fit: BoxFit.fitWidth,
//                  animation: "idle",
//                ),
                child: const Icon(Icons.outlined_flag),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          // Không có dữ liệu
          Text(
            S.current.noData,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          RaisedButton(
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(Icons.refresh),
                //Tải lại
                Text(S.current.reload),
              ],
            ),
            onPressed: () {
              onPressed();
            },
          ),
        ],
      ),
    );
  }
}
