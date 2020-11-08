import 'package:flutter/material.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/sale_online_edit_order_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/sale_online_partner_add_edit_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/new_facebook_post_comment_viewmodel.dart';

class NewFacebookPostCommentInfoPage extends StatefulWidget {
  const NewFacebookPostCommentInfoPage(
      {@required this.vm,
      @required this.comment,
      this.initIndex = 0,
      @required this.onPartnerSaved});
  final NewFacebookPostCommentViewModel vm;
  final CommentItemModel comment;
  final int initIndex;
  final Function(Partner, CommentItemModel) onPartnerSaved;

  @override
  _NewFacebookPostCommentInfoPageState createState() =>
      _NewFacebookPostCommentInfoPageState();
}

class _NewFacebookPostCommentInfoPageState
    extends State<NewFacebookPostCommentInfoPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: widget.initIndex,
      length: 2,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: <Widget>[
              Container(
                color: Colors.indigo.shade300,
                child: TabBar(
                  labelColor: Colors.white,
                  indicatorColor: Colors.red,
                  tabs: const <Widget>[
                    Tab(
                      child: Text("Khách hàng"),
                    ),
                    Tab(
                      child: Text("Đơn hàng"),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: TabBarView(
                    children: <Widget>[
                      SaleOnlinePartnerAddEditPage(
                        facebookPostId: widget.vm.facebookPost.id,
                        comment: widget.comment,
                        crmTeam: widget.vm.crmTeam,
                        onSaved: widget.onPartnerSaved,
                      ),
                      SaleOnlineEditOrderPage(
                        order: widget.comment.saleOnlineOrder,
                        orderId: widget.comment.saleOnlineOrder?.id,
                        comment: widget.comment,
                        facebookPostId: widget.vm.facebookPost.id,
                        crmTeam: widget.vm.crmTeam,
                        product: widget.vm.product,
                        productQuantity: widget.vm.productQuantity,
                        liveCampaign: widget.vm.liveCampaign,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
