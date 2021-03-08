import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/conversation/bloc/conversation_list_bloc.dart';
import 'package:tpos_mobile/feature_group/conversation/conversation_filter/conversation_filter.dart';

class TabConversation extends StatefulWidget {
  const TabConversation(
      {this.selectedTab1 = false,
      this.selectedTab2 = false,
      this.selectedTab3 = false,
      this.countAll = 0,
      this.countComment = 0,
      this.countMessage = 0,
      this.conversationListBloc,
      this.crmTeam,
      this.conversationFilter,
      this.userIds,
      this.onPressAll,
      this.onPressComment,
      this.onPressMessage})
      : assert(selectedTab1 != null ||
            selectedTab2 != null ||
            selectedTab3 != null);
  final bool selectedTab1;
  final bool selectedTab2;
  final bool selectedTab3;
  final int countAll;
  final int countComment;
  final int countMessage;
  final CRMTeam crmTeam;
  final String userIds;
  final VoidCallback onPressAll;
  final VoidCallback onPressMessage;
  final VoidCallback onPressComment;
  final ConversationListBloc conversationListBloc;
  final ConversationFilter conversationFilter;
  @override
  _TabConversationState createState() => _TabConversationState();
}

class _TabConversationState extends State<TabConversation> {
  bool _selectedTab1;
  bool _selectedTab2;
  bool _selectedTab3;
  Color colorState;
  Color colorText;
  Color colorBorder;
  Widget _buildTabItem(
      {String image, String nameTab, int index, bool selected, int count}) {
    EdgeInsets _buildPadding() {
      if (index == 1) {
        return const EdgeInsets.only(left: 20);
      } else if (index == 3) {
        return const EdgeInsets.only(right: 20);
      } else {
        return null;
      }
    }

    if (selected) {
      colorState = const Color(0xFF28A745);
      colorText = const Color(0xFF28A745);
      colorBorder = const Color(0xFF28A745);
    } else {
      colorText = const Color(0xFF858F9B);
      colorBorder = const Color(0xFFEDF2F6);
    }

    return Container(
      width: MediaQuery.of(context).size.width / 3,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: colorBorder, width: 2))),
      margin: _buildPadding(),
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(image),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  nameTab,
                  style: TextStyle(color: colorText),
                )
              ],
            ),
            if (count != 0 && count != null)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                height: 20,
                width: 20,
                decoration: const BoxDecoration(
                    color: Colors.redAccent, shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    count.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 8),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _selectedTab1 = widget.selectedTab1;
    _selectedTab2 = widget.selectedTab2;
    _selectedTab3 = widget.selectedTab3;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: InkWell(
              onTap: () {
                _selectedTab1 = true;
                _selectedTab2 = false;
                _selectedTab3 = false;
                widget.onPressAll();
              },
              child: _buildTabItem(
                  image: _selectedTab1
                      ? 'assets/icon/all_state_conservation.svg'
                      : 'assets/icon/all_state_conservation_black.svg',
                  nameTab: 'Tất cả',
                  index: 1,
                  selected: _selectedTab1,
                  count: widget.countAll),
            ),
          ),
          Flexible(
            child: InkWell(
              onTap: () {
                _selectedTab1 = false;
                _selectedTab2 = true;
                _selectedTab3 = false;
                widget.onPressMessage();
              },
              child: _buildTabItem(
                  image: _selectedTab2
                      ? 'assets/icon/message_state_conservation_green.svg'
                      : 'assets/icon/message_state_conservation.svg',
                  nameTab: 'Tin nhắn',
                  index: 2,
                  selected: _selectedTab2,
                  count: widget.countMessage),
            ),
          ),
          Flexible(
            child: InkWell(
              onTap: () {
                _selectedTab1 = false;
                _selectedTab2 = false;
                _selectedTab3 = true;
                widget.onPressComment();
              },
              child: _buildTabItem(
                  image: _selectedTab3
                      ? 'assets/icon/comment_state_conservation_green.svg'
                      : 'assets/icon/comment_state_conservation.svg',
                  nameTab: 'Bình luận',
                  index: 3,
                  selected: _selectedTab3,
                  count: widget.countComment),
            ),
          ),
        ],
      ),
    );
  }
}
