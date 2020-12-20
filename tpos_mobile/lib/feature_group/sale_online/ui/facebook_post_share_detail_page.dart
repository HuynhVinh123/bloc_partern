import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/app_core/ui_base/ui_vm_base.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/facebook_post_share_detail_viewmodel.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/facebook_post_share_list_viewmodel.dart';
import 'package:tpos_mobile/src/tpos_apis/models/facebook_share_info.dart';
import 'package:url_launcher/url_launcher.dart';

class FacebookPostShareDetailPage extends StatefulWidget {
  const FacebookPostShareDetailPage(this.userShared);
  final FacebookShareCount userShared;

  @override
  _FacebookPostShareDetailPageState createState() =>
      _FacebookPostShareDetailPageState();
}

class _FacebookPostShareDetailPageState
    extends State<FacebookPostShareDetailPage> {
  final FacebookPostShareDetailViewModel _vm =
      FacebookPostShareDetailViewModel();
  @override
  Widget build(BuildContext context) {
    return UIViewModelBase(
      viewModel: _vm,
      child: ScopedModel<FacebookPostShareDetailViewModel>(
        model: _vm,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Chi tiết lượt share"),
          ),
          body: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Column(
              children: <Widget>[
                Image.network(widget.userShared.avatarLink),
                InkWell(
                  child: Text(
                    " ${widget.userShared.name}",
                    style: TextStyle(color: Colors.blue),
                  ),
                  onTap: () async {
                    final String url =
                        "fb://profile/${widget.userShared.facebookUid}";
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {}
                  },
                ),
                Text(
                  "Share: ${widget.userShared.count}",
                  style: TextStyle(color: Colors.redAccent),
                ),
              ],
            ),
          ),
          Expanded(
            child: Scrollbar(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.all(10),
                physics: const AlwaysScrollableScrollPhysics(),
                separatorBuilder: (context, index) => const Divider(
                  height: 2,
                ),
                itemCount: _vm.shareInfo.length ?? 0,
                itemBuilder: (context, index) =>
                    _buildListItem(_vm.shareInfo[index], index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(FacebookShareInfo item, int index) {
    final TextStyle linkStyle = TextStyle(color: Colors.blue);
    return ListTile(
      leading: Text("# ${index + 1}"),
      title: Text(
        DateFormat("dd/MM/yyyy HH:mm")
            .format(DateTime.parse(item.updatedTime).toLocal() ?? ""),
        style: linkStyle.copyWith(color: Colors.green),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            child: Text(
              item.permalinkUrl ?? '',
              style: linkStyle,
            ),
            onTap: () async {
              final String url = item.permalinkUrl;
              if (await canLaunch(url)) {
                await launch(url);
              } else {}
            },
          ),
        ],
      ),
      contentPadding: const EdgeInsets.only(
        left: 0,
        right: 16,
      ),
    );
  }

  @override
  void initState() {
    _vm.shareInfo = widget.userShared.details;
    _vm.initCommand();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
