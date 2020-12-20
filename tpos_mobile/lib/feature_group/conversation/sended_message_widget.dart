import 'package:flutter/material.dart';

class SendedMessageWidget extends StatelessWidget {
  const SendedMessageWidget(
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
        padding: const EdgeInsets.only(
            right: 8.0, left: 50.0, top: 4.0, bottom: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
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
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(0)),
                      child: Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment(-1.0, 1.0),
                                end: Alignment(0.5, -1.0),
                                stops: [
                              0.5,
                              0.9
                            ],
                                colors: [
                              Color(0xff3ba734),
                              Color(0xff64ca37),
                            ])),
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
                              style: const TextStyle(color: Colors.white),
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
            const SizedBox(
              width: 8,
            ),
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
          ],
        ),
      ),
    );
  }
}
