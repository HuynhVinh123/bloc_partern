import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/state_management/viewmodel/viewmodel_provider.dart';

import 'viewmodel/partner_status_select_viewmodel.dart';

class PartnerStatusSelectPage extends StatefulWidget {
  const PartnerStatusSelectPage(
      {Key key, this.selectedStatus, this.isDialog = false})
      : assert(isDialog != null),
        super(key: key);
  final String selectedStatus;
  final bool isDialog;

  @override
  _PartnerStatusSelectPageState createState() =>
      _PartnerStatusSelectPageState();
}

class _PartnerStatusSelectPageState extends State<PartnerStatusSelectPage> {
  final PartnerStatusSelectViewModel viewModel = PartnerStatusSelectViewModel();
  @override
  void initState() {
    viewModel.start();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<PartnerStatusSelectViewModel>(
      viewModel: viewModel,
      child: Scaffold(
        appBar: _buildAppbar(),
        body: _buildBody(),
      ),
    );
  }

  /// UI appbar. Nếu [widget.isDialog] = true thì appbar sẽ bị ẩn
  Widget _buildAppbar() {
    if (widget.isDialog) {
      return const SizedBox();
    }
    return AppBar(
      title: const Text('Chọn trạng thái khách hàng'),
    );
  }

  Widget _buildBody() {
    return Consumer<PartnerStatusSelectViewModel>(
        builder: (context, model, child) {
      if (model.partnerStatus != null) {
        return _buildList(model.partnerStatus);
      }
      return const SizedBox();
    });
  }

  Widget _buildList(List<PartnerStatus> items) {
    if (items.isEmpty) {
      return const Center(
        child: Text('Không có dữ liệu...'),
      );
    }
    return Scrollbar(
      child: ListView.separated(
          itemBuilder: (context, index) => _buildItem(items[index]),
          separatorBuilder: (context, index) => const Divider(height: 2),
          itemCount: items.length),
    );
  }

  Widget _buildItem(PartnerStatus item) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade200,
        child: Text(
          item.text.substring(0, 1),
        ),
      ),
      title: Text(item.text),
      onTap: () => Navigator.pop(context, item),
    );
  }
}
