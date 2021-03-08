import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/ui_base/ui_base.dart';
import 'package:tpos_mobile/feature_group/category/viewmodel/stock_ware_house_select_viewmodel.dart';

class StockWareHouseSelectPage extends StatefulWidget {
  @override
  _StockWareHouseSelectPageState createState() =>
      _StockWareHouseSelectPageState();
}

class _StockWareHouseSelectPageState extends State<StockWareHouseSelectPage> {
  final _vm = StockWareHouseSelectViewModel();
  @override
  void initState() {
    _vm.initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<StockWareHouseSelectViewModel>(
      model: _vm,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Chọn kho hàng"),
        ),
        body: UIViewModelBase(
          viewModel: _vm,
          child: ScopedModelDescendant<StockWareHouseSelectViewModel>(
            builder: (context, child, model) => ListView.separated(
                itemBuilder: (context, index) =>
                    _buildListItem(_vm.stockWareHouses[index]),
                separatorBuilder: (context, index) => const Divider(height: 2),
                itemCount: _vm.stockWareHouses?.length ?? 0),
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(StockWareHouse item) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade200,
        child: Text("${item.name.substring(0, 1)}"),
      ),
      title: Text("${item.name}"),
      onTap: () {
        Navigator.pop(context, item);
      },
    );
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }
}
