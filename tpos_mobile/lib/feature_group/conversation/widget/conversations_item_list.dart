import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';

class ConversationItemList extends StatelessWidget {
  const ConversationItemList(
      {this.isRowThreeChat,
      this.itemConversation,
      this.crmTeam,
      this.type,
      this.imageStatus})
      : assert(isRowThreeChat != null || itemConversation != null);

  /// Tạo Item trong danh sách hội thoại
  /// isRowThreeChat : false -> Tạo hàng nút cuộc gọi .
  final bool isRowThreeChat;
  final Conversation itemConversation;
  final CRMTeam crmTeam;
  final String type;
  final String imageStatus;

  /// Avatar của mỗi item
  Widget _buildAvatar(Conversation itemConservation) {
    return Stack(
      children: <Widget>[
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey,
          child: ClipOval(
            child: Image.network(
              'https://graph.facebook.com/${itemConservation?.psid}/picture?access_token=${crmTeam?.facebookPageToken}',
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace stackTrace) {
                return Container(
                  color: Colors.grey,
                );
              },
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: 20,
            height: 20,
            child: SvgPicture.asset(
              imageStatus,
              fit: BoxFit.contain,
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
                  margin: const EdgeInsets.only(top: 7),
                  width: App.width / 4,
                  child: Text(
                    content ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 15,
                        color: itemConservation.countUnreadMessages.toInt() == 0
                            ? const Color(0xFF929DAA)
                            : const Color(0xFF2C333A),
                        fontWeight:
                            itemConservation.countUnreadMessages.toInt() != 0
                                ? FontWeight.bold
                                : FontWeight.normal),
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
  Widget _buildTime({String time, int numberMessage, String date}) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              time,
              style: const TextStyle(color: Color(0xFF929DAA)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                date,
                style: const TextStyle(color: Color(0xFF929DAA)),
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            if (numberMessage != 0)
              Visibility(
                visible: isRowThreeChat,
                child: Container(
                  height: 19,
                  width: 25,
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                      color: const Color(0xFF2395FF),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: Text(
                    numberMessage.toString(),
                    style: const TextStyle(color: Colors.white),
                  )),
                ),
              )
            else
              const SizedBox(),
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
            mainAxisAlignment: MainAxisAlignment.start,
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
          const SizedBox(
            width: 76,
          ),
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (itemConversation.tags != null)
                Flexible(
                  child: Wrap(
                    alignment: WrapAlignment.end,
                    children: itemConversation.tags.map((e) {
                      final String color =
                          e.colorClass?.substring(1, e.colorClass?.length);
                      return Container(
                        margin: const EdgeInsets.only(right: 5, bottom: 5),
                        height: 16,
                        width: 16,
                        decoration: BoxDecoration(
                            color: color != null
                                ? Color(int.parse('0xFF$color'))
                                : Colors.white,
                            shape: BoxShape.circle),
                      );
                    }).toList(),
                  ),
                ),
              const SizedBox(
                width: 6,
              ),
              Visibility(
                  visible: itemConversation.hasOrder,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Image.asset(
                      'images/cart_tpage.png',
                      height: 20,
                      width: 20,
                    ),
                  )),
              Visibility(
                  visible: itemConversation.hasPhone,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Image.asset(
                      'images/telephone.png',
                      height: 20,
                      width: 20,
                    ),
                  )),
              Visibility(
                  visible: itemConversation.hasAddress,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Image.asset(
                      'images/locattion_tpage.png',
                      height: 20,
                      width: 20,
                    ),
                  )),
              const SizedBox(
                width: 16,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButton(
      {IconData icon, String title, Color colorIcon, BuildContext context}) {
    return Container(
      height: 30,
      child: OutlineButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: colorIcon,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(title),
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

  Widget _buildRowCall(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: _buildButton(
                icon: Icons.phone,
                title: 'Gọi',
                colorIcon: const Color(0xFF28a745),
                context: context),
          ),
          const SizedBox(
            width: 10,
          ),
          Flexible(
            child: _buildButton(
                icon: Icons.add,
                title: 'Tạo đơn',
                colorIcon: const Color(0xFF5A6271),
                context: context),
          ),
          const SizedBox(
            width: 10,
          ),
          Flexible(
            child: _buildButton(
                icon: Icons.reply,
                title: 'Trả lời',
                colorIcon: const Color(0xFF5A6271),
                context: context),
          ),
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
                  content: type != 'comment'
                      ? itemConversation.lastMessage?.message ?? ''
                      : itemConversation.lastComment?.message ?? '',
                  itemConservation: itemConversation),
              _buildTime(
                  time: type != 'comment'
                      ? itemConversation.lastMessage?.createdTime != null
                          ? DateFormat('HH:mm').format(itemConversation
                              .lastMessage?.createdTime
                              ?.add(const Duration(hours: 7)))
                          : ''
                      : itemConversation.lastComment?.createdTime != null
                          ? DateFormat('HH:mm').format(itemConversation
                              .lastComment?.createdTime
                              ?.add(const Duration(hours: 7)))
                          : '',
                  numberMessage: itemConversation.countUnreadMessages.toInt(),
                  date: type != 'comment'
                      ? itemConversation.lastMessage?.createdTime != null
                          ? DateFormat('dd/MM/yyyy').format(itemConversation
                              .lastMessage?.createdTime
                              ?.add(const Duration(hours: 7)))
                          : ''
                      : itemConversation.lastComment?.createdTime != null
                          ? DateFormat('dd/MM/yyyy').format(itemConversation
                              .lastComment?.createdTime
                              ?.add(const Duration(hours: 7)))
                          : ''),
            ],
          ),
          if (isRowThreeChat)
            _buildRowThree(name: itemConversation.assignedToFacebook?.name)
          else
            _buildRowCall(context)
        ],
      ),
    );
  }
}
