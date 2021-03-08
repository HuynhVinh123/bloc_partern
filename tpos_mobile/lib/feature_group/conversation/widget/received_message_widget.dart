import 'package:flutter/material.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

class ReceivedMessageWidget extends StatelessWidget {
  ///Giao diện nhận tin nhắn
  const ReceivedMessageWidget(
      {Key key,
      this.content,
      this.time,
      this.imageAddress,
      this.isImage,
      this.imagesSelects,
      this.type,
      this.userName,
      this.index,
      this.indexMessage,
      this.messageConversation})
      : super(key: key);
  final String content;
  final String imageAddress;
  final String time;
  final bool isImage;
  final List<Widget> imagesSelects;
  final String type;
  final String userName;
  final int index;
  final int indexMessage;
  final MessageConversation messageConversation;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (imageAddress != null)
              Container(
                height: 36,
                width: 36,
                child: CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage(imageAddress),
                  backgroundColor: Colors.white,
                ),
              )
            else
              const SizedBox(
                height: 36,
                width: 36,
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
                                left: 14.0,
                                top: 8.0,
                                bottom: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (type == 'comment')
                                  Text(
                                    userName ?? '',
                                    style: const TextStyle(
                                        color: Color(0xFF2C333A), fontSize: 17),
                                  ),
                                Text(
                                  content,
                                  style:
                                      const TextStyle(color: Color(0xFF2C333A)),
                                ),
                              ],
                            ),
                          )
                        ]),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 23.0, top: 8.0, bottom: 15.0),
                      child: imagesSelects != null
                          ? Wrap(
                              alignment: WrapAlignment.start,
                              children: imagesSelects
                                  .map((e) => Container(
                                      height: 94,
                                      width: 94,
                                      margin: const EdgeInsets.only(
                                          right: 5, bottom: 5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      child: e))
                                  .toList(),
                            )
                          : const SizedBox(),
                    ),
                  if (index == indexMessage)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Text(
                        'Được gửi bởi ${messageConversation?.message?.from?.name}',
                        style: const TextStyle(color: Color(0xFF929DAA)),
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
