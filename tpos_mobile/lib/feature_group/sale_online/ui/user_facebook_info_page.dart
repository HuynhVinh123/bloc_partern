import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/user_facebook_info_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/widgets/info_row.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class UserFacebookInfoPage extends StatefulWidget {
  const UserFacebookInfoPage(
      {this.id, this.teamId, this.postId, this.userName});
  final String id; // userId
  final int teamId;
  final String postId;
  final String userName;
  @override
  _UserFacebookInfoPageState createState() => _UserFacebookInfoPageState();
}

class _UserFacebookInfoPageState extends State<UserFacebookInfoPage> {
  final _vm = locator<UserFacebookInfoViewModel>();

  TextStyle detailFontStyle;
  TextStyle titleFontStyle;

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    await _vm.getUserFacebooks(widget.id, widget.teamId);
    await _vm.getComments(widget.postId, widget.id);
    await _vm.getOrderSaleOnline(widget.postId, widget.id);
  }

  @override
  Widget build(BuildContext context) {
    titleFontStyle = const TextStyle(color: Colors.green);
    detailFontStyle = const TextStyle(color: Colors.green);
    return ViewBase<UserFacebookInfoViewModel>(
        model: _vm,
        builder: (context, model, sizingInformation) {
          return Scaffold(
              appBar: AppBar(
                title: Text(S.current.saleOnline_UserInfo),
              ),
              body: _buildInfoPointSale());
        });
  }

  Widget _buildInfoPointSale() {
    const Widget spaceHeight = SizedBox(
      height: 10,
    );
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[400],
                        offset: const Offset(0, 2),
                        blurRadius: 2)
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      _vm.partner?.name ?? widget.userName,
                      style: detailFontStyle.copyWith(
                          fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                  spaceHeight,
                  _buildInfoGeneral(_vm.partner),
                ],
              )),
          Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[400],
                      offset: const Offset(0, 2),
                      blurRadius: 2)
                ]),
            child: ExpansionTile(
              initiallyExpanded: true,
              // Bình luận
              title: Text("${S.current.comment} (${_vm.comments.length})"),
              children: _vm.comments
                  .map((item) => Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Text(
                            "${item.message} (TG: ${item.createdTime}))",
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[400],
                      offset: const Offset(0, 2),
                      blurRadius: 2)
                ]),
            child: ExpansionTile(
              initiallyExpanded: true,
              title: Text("${S.current.posOrder} (${_vm.saleOrders.length})"),
              children: _vm.saleOrders
                  .map((item) => Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(color: Colors.grey[400]))),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        item.code ?? "",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.date_range,
                                      size: 18,
                                    ),
                                    Text(
                                        " ${DateFormat("dd-MM-yyyy  HH:ss").format(item.dateCreated)}")
                                  ],
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        "${S.current.status}: ${item.statusText}"))
                              ],
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoGeneral(Partner item) {
    const dividerMin = Divider(
      height: 2,
    );
    return Column(
      children: <Widget>[
        InfoRow(
          contentTextStyle: titleFontStyle,
          titleString: "${S.current.phone}:",
          content: Text(item.phone ?? "",
              textAlign: TextAlign.right, style: detailFontStyle),
        ),
        dividerMin,
        InfoRow(
          contentTextStyle: titleFontStyle,
          titleString: "Email ",
          content: Text(item.email ?? "",
              textAlign: TextAlign.right, style: detailFontStyle),
        ),
        dividerMin,
        // Ghi chú
        InfoRow(
          contentTextStyle: titleFontStyle,
          titleString: "${S.current.note}:",
          content: Text(item.comment ?? "",
              textAlign: TextAlign.right, style: detailFontStyle),
        ),
        dividerMin,
        // Địa chỉ
        InfoRow(
          contentTextStyle: titleFontStyle,
          titleString: "${S.current.address}:",
          content: Text(item.street ?? "",
              textAlign: TextAlign.right, style: detailFontStyle),
        ),
        dividerMin,
        // Trạng thái
        InfoRow(
          contentTextStyle: titleFontStyle,
          titleString: "${S.current.status}:",
          content: Text(item.statusText ?? "",
              textAlign: TextAlign.right, style: detailFontStyle),
        ),
        dividerMin,
      ],
    );
  }
}
