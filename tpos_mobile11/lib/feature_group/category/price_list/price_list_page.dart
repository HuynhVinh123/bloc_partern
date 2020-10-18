import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/price_list/price_list_viewmodel.dart';
import 'package:tpos_mobile/state_management/viewmodel/base_viewmodel.dart';
import 'package:tpos_mobile/state_management/viewmodel/viewmodel_provider.dart';
import 'package:tpos_mobile/widgets/page_state/page_state.dart';
import 'package:tpos_mobile/widgets/page_state/page_state_type.dart';

class PriceListPage extends StatefulWidget {
  const PriceListPage({Key key, this.searchMode = false}) : super(key: key);
  final bool searchMode;

  @override
  _PriceListPageState createState() => _PriceListPageState();
}

class _PriceListPageState extends State<PriceListPage> {
  final PriceListViewModel viewModel = PriceListViewModel();

  @override
  void initState() {
    viewModel.init(searchModel: widget.searchMode);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<PriceListViewModel>(
      viewModel: viewModel,
      busyStateType: PViewModelBusy,
      child: Scaffold(
        appBar: _buildAppbar(),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildAppbar() {
    return PreferredSize(
      preferredSize: const Size(double.infinity, 50),
      child: Consumer<PriceListViewModel>(
        builder: (context, model, widget) {
          return AppBar(
            title: Text(viewModel.title),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<PriceListViewModel>(builder: (context, model, child) {
      if (model.state is PViewModelLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (model.state is PViewModelLoadFailure) {
        return PageState.dataError();
      }
      return _buildList(model.priceLists);
    });
  }

  Widget _buildList(List<ProductPrice> items) {
    if (items.isEmpty) {
      return PageState(
        type: PageStateType.listEmpty,
        actions: [
          RaisedButton(
            onPressed: () {},
            child: const Text('Tải lại'),
          ),
        ],
      );
    }
    return Scrollbar(
      child: ListView.separated(
        itemBuilder: (context, index) => _buildItem(items[index]),
        itemCount: items.length,
        separatorBuilder: (context, index) => const Divider(height: 2),
      ),
    );
  }

  Widget _buildItem(ProductPrice item) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade200,
        child: Text(
          item.name.substring(0, 1),
        ),
      ),
      title: Text(item.name ?? ''),
      onTap: () {
        if (viewModel.searchModel) {
          Navigator.pop(context, item);
        }
      },
    );
  }
}
