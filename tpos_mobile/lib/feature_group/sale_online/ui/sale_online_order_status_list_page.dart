import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/app_core/ui_base/ui_base.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/sale_online_order_status_list_viewmodel.dart';
import 'package:tpos_mobile/src/tpos_apis/models/status_extra.dart';

///Danh sách trạng thái đơn hàng online
///Thêm, Sủa, xóa, tìm kiếm, chọn
class SaleOnlineOrderStatusListPage extends StatefulWidget {
  const SaleOnlineOrderStatusListPage(
      {this.isSearchMode = false,
      this.isCloseWhenSelect = false,
      this.isDialogMode = false,
      this.selectedValue});
  final bool isSearchMode;
  final bool isCloseWhenSelect;
  final bool isDialogMode;
  final String selectedValue;

  @override
  _SaleOnlineOrderStatusListPageState createState() =>
      _SaleOnlineOrderStatusListPageState();
}

class _SaleOnlineOrderStatusListPageState
    extends State<SaleOnlineOrderStatusListPage> {
  final _vm = SaleOnlineOrderStatusListViewModel();
  @override
  void initState() {
    _vm.init(
      isSelectMode: widget.isSearchMode,
      closeWhenSelect: widget.isCloseWhenSelect,
      isDialogMode: widget.isDialogMode,
    );
    _vm.initData();
    _vm.setBusy(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return UIViewModelBase<SaleOnlineOrderStatusListViewModel>(
      viewModel: _vm,
      child: Scaffold(
        appBar: !widget.isDialogMode
            ? null
            : AppBar(
                leading: widget.isDialogMode ? const CloseButton() : null,
                title: const Text("Trạng thái đơn hàng online"),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {},
                  ),
                ],
              ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildStatusItem(StatusExtra item) {
    return ListTile(
      leading: widget.selectedValue == item.name
          ? const Icon(Icons.check_circle)
          : null,
      title: Text(item.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
//          IconButton(
//            icon: Icon(Icons.delete),
//            onPressed: () {},
//          ),
        ],
      ),
      selected: widget.selectedValue == item.name,
      onTap: () {
        if (widget.isSearchMode) {
          Navigator.pop(context, item);
        }
      },
    );
  }

  Widget _buildStatusList() {
    final items = _vm.status;
    return ScopedModelDescendant<SaleOnlineOrderStatusListViewModel>(
      builder: (context, __, ___) => ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) => _buildStatusItem(items[index]),
          separatorBuilder: (context, index) => const Divider(
                height: 2,
              ),
          itemCount: items?.length ?? 0),
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // _buildHeaderDialogModel(),
        _buildStatusList(),
      ],
    );
  }
}
