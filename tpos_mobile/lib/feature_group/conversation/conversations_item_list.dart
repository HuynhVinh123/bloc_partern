import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';

class ConversationItemList extends StatelessWidget {
  const ConversationItemList(
      {this.isRowThreeChat, this.itemConversation, this.crmTeam})
      : assert(isRowThreeChat != null || itemConversation != null);

  /// Tạo Item trong danh sách hội thoại
  /// isRowThreeChat : false -> Tạo hàng nút cuộc gọi .
  final bool isRowThreeChat;
  final Conversation itemConversation;
  final CRMTeam crmTeam;

  /// Avatar của mỗi item
  Widget _buildAvatar(Conversation itemConservation) {
    return Stack(
      children: <Widget>[
        CircleAvatar(
          radius: 25,
          child: ClipOval(
            child: Image.network(
              'https://graph.facebook.com/${itemConservation?.psid}/picture?access_token=${crmTeam?.facebookPageToken}',
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace stackTrace) {
                return Container(
                  color: Colors.grey,
                );
              },
              fit: BoxFit.contain,
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: 20,
            height: 20,
            child: ClipOval(
              child: Image.asset(
                'images/facebook.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        )
      ],
    );
  }

  ///Tiêu đề mỗi item
  Widget _buildTitle(
      {String name, String content, Conversation itemConservation}) {
    return Expanded(
      child: Row(
        children: [
          const SizedBox(
            width: 16,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: _buildAvatar(itemConservation),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  name ?? '',
                  style: const TextStyle(
                      color: Color(0xFF2C333A),
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  width: App.width / 4,
                  child: Text(
                    content ?? '',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Thời gian mỗi item
  Widget _buildTime({String time, String numberMessage}) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(time),
            const SizedBox(
              height: 20,
            ),
            if (isRowThreeChat)
              Container(
                height: 19,
                width: 25,
                decoration: BoxDecoration(
                    color: const Color(0xFF2395FF),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                    child: Text(
                  numberMessage.toString(),
                  style: const TextStyle(color: Colors.white),
                )),
              ),
          ],
        ),
        const SizedBox(
          width: 16,
        ),
      ],
    );
  }

  /// Hàng thứ 3 nếu có
  Widget _buildRowThree({String name}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (name != null)
          Row(
            children: [
              const SizedBox(
                width: 76,
              ),
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                    color: const Color(0xFFDFE7EC),
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                    child: Text(
                  name.substring(0, 1)?.toUpperCase(),
                  style:
                      const TextStyle(color: Color(0xFF929DAA), fontSize: 10),
                )),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(name),
            ],
          )
        else
          const SizedBox(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (itemConversation.tags != null)
              Container(
                child: Wrap(
                  children: itemConversation.tags.map((e) {
                    final String color =
                        e.colorClass.substring(1, e.colorClass.length);
                    return Container(
                      margin: const EdgeInsets.only(right: 5, bottom: 5),
                      height: 16,
                      width: 16,
                      decoration: BoxDecoration(
                          color: Color(int.parse('0xFF$color')),
                          shape: BoxShape.circle),
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(
              width: 16,
            ),
            if (itemConversation.hasOrder)
              Image.asset(
                'images/cart_tpage.png',
                height: 20,
                width: 20,
              ),
            const SizedBox(
              width: 6,
            ),
            if (itemConversation.hasPhone)
              Image.asset(
                'images/telephone.png',
                height: 20,
                width: 20,
              ),
            const SizedBox(
              width: 6,
            ),
            if (itemConversation.hasAddress)
              Image.asset(
                'images/locattion_tpage.png',
                height: 20,
                width: 20,
              ),
            const SizedBox(
              width: 16,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildButton({IconData icon, String title, Color colorIcon}) {
    return Container(
      height: 30,
      child: OutlineButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 10,
            ),
            Icon(
              icon,
              size: 18,
              color: colorIcon,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(title),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        onPressed: () {}, //callback when button is clicked
        borderSide: const BorderSide(
          color: Color(0xFFE9EDF2), //Color of the border
          style: BorderStyle.solid, //Style of the border
          width: 2, //width of the border
        ),
      ),
    );
  }

  Widget _buildRowCall() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildButton(
              icon: Icons.phone,
              title: 'Gọi',
              colorIcon: const Color(0xFF28a745)),
          _buildButton(
              icon: Icons.add,
              title: 'Tạo đơn',
              colorIcon: const Color(0xFF5A6271)),
          _buildButton(
              icon: Icons.reply,
              title: 'Trả lời',
              colorIcon: const Color(0xFF5A6271)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTitle(
                  name: itemConversation.name,
                  content: itemConversation.lastMessage?.message ?? '',
                  itemConservation: itemConversation),
              _buildTime(
                  time: itemConversation.lastMessage?.createdTime != null
                      ? DateFormat('hh:mm')
                          .format(itemConversation.lastMessage?.createdTime)
                      : '',
                  numberMessage: '3'),
            ],
          ),
          const SizedBox(
            height: 11,
          ),
          if (isRowThreeChat)
            _buildRowThree(name: itemConversation.assignedToFacebook?.name)
          else
            _buildRowCall()
        ],
      ),
    );
  }
}
