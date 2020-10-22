import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tpos_mobile/feature_group/tpage/uis/item_fast_reply.dart';

class FastReplyPage extends StatefulWidget {
  @override
  _FastReplyPageState createState() => _FastReplyPageState();
}

class _FastReplyPageState extends State<FastReplyPage> {

  List<String> replies = ["1","",""];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEDEF),
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              "NHÃN HỘI THOẠI (4)",
              style: TextStyle(color: const Color(0xFF28A745), fontSize: 15),
            ),
          ),
          Flexible(child: _buildReplies(),)
        ],
      ),
    );
  }

  Widget _buildReplies(){
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...List.generate(replies.length, (index) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: const ItemFastReply(),
          ))
        ],
      ),
    );
  }

}
