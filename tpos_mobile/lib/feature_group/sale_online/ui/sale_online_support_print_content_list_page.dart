import 'package:flutter/material.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/app_setting_service.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class SaleOnlineSupportPrintContentListPage extends StatefulWidget {
  const SaleOnlineSupportPrintContentListPage({this.selectedList});
  final List<SupportPrintSaleOnlineRow> selectedList;

  @override
  _SaleOnlineSupportPrintContentListPageState createState() =>
      _SaleOnlineSupportPrintContentListPageState();
}

class _SaleOnlineSupportPrintContentListPageState
    extends State<SaleOnlineSupportPrintContentListPage> {
  final _setting = locator<ISettingService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.setting_settingSaleOnlinePrintContent),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final contents = _setting.supportSaleOnlinePrintRow
        .where((f) =>
            (widget.selectedList != null &&
                !widget.selectedList.any((g) => g.name == f.name)) ||
            (widget.selectedList == null))
        .toList();
    return RefreshIndicator(
      onRefresh: () async {
        return true;
      },
      child: _buildList(contents),
    );
  }

  Widget _buildList(List<SupportPrintSaleOnlineRow> items) {
    return ListView.separated(
        itemBuilder: (context, index) => _buildListItem(items[index]),
        separatorBuilder: (context, index) => const Divider(
              height: 2,
            ),
        itemCount: items?.length ?? 0);
  }

  Widget _buildListItem(SupportPrintSaleOnlineRow item) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(item.description.substring(0, 1)),
      ),
      title: Text(item.description),
      onTap: () => Navigator.pop(context, item),
    );
  }
}
