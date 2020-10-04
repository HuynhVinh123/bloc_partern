import 'package:flutter/material.dart';

class EmptyData extends StatelessWidget {
  final VoidCallback onPressed;
  const EmptyData({Key key, this.onPressed}) : super(key: key);

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
                child: Icon(Icons.outlined_flag),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Không có dữ liệu",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.refresh),
                Text("Tải lại"),
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
