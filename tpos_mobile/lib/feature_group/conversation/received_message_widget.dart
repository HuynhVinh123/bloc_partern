import 'package:flutter/material.dart';

class ReceivedMessageWidget extends StatelessWidget {
  const ReceivedMessageWidget(
      {Key key,
      this.content,
      this.time,
      this.imageAddress,
      this.isImage,
      this.imagesSelects})
      : super(key: key);
  final String content;
  final String imageAddress;
  final String time;
  final bool isImage;
  final List<Widget> imagesSelects;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              child: Image.asset(
                imageAddress,
                height: 30,
                width: 30,
                color: Colors.green,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    time,
                    style: const TextStyle(color: Color(0xFF929DAA)),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  if (!isImage)
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(15)),
                      child: Container(
                        color: Colors.black12,
                        // margin: const EdgeInsets.only(left: 10.0),
                        child: Stack(children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 12.0,
                                left: 23.0,
                                top: 8.0,
                                bottom: 15.0),
                            child: Text(
                              content,
                              style: const TextStyle(color: Color(0xFF2C333A)),
                            ),
                          )
                        ]),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 23.0, top: 8.0, bottom: 15.0),
                      child: Wrap(
                        children: imagesSelects
                            .map((e) => Container(
                                height: 94,
                                width: 94,
                                margin: const EdgeInsets.only(right: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4)),
                                child: e))
                            .toList(),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
