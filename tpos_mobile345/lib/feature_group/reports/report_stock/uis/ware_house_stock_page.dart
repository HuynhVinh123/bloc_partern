import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/empty_data_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/ware_house_stock/ware_house_stock_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/ware_house_stock/ware_house_stock_event.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/ware_house_stock/ware_house_stock_state.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';

class WareHouseStockPage extends StatefulWidget {

  @override
  _WareHouseStockPageState createState() => _WareHouseStockPageState();
}

class _WareHouseStockPageState extends State<WareHouseStockPage> {
  final _bloc = WareHouseStockBloc();

  @override
  void initState() {
    super.initState();
    _bloc.add(WareHouseStockLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return BlocUiProvider<WareHouseStockBloc>(
      bloc: _bloc,
      listen: (state) {
        if (state is WareHouseStockLoadFailure) {
          showError(
              title: state.title, message: state.content, context: context);
        }
      },
      child: Scaffold(
          appBar: AppBar(

            title: const Text("Kho hàng"),
          ),
          body: _buildBody()),
    );
  }

  Widget _buildBody() {
    return BlocLoadingScreen<WareHouseStockBloc>(
        busyStates: const [WareHouseStockLoading],
        child: BlocBuilder<WareHouseStockBloc, WareHouseStockState>(
            builder: (context, state) => state is WareHouseStockLoadSuccess
                ? _buildListItem(state)
                : Container()));
  }

  Widget _buildListItem(WareHouseStockLoadSuccess state) {
    return state.wareHouseStocks.isEmpty
        ? EmptyDataPage()
        : ListView.separated(
        itemBuilder: (context, index) =>
            _buildItem(state.wareHouseStocks[index]),
        separatorBuilder: (context, index) => const Divider(),
        itemCount: state.wareHouseStocks.length);
  }

  Widget _buildItem(WareHouseStock item) {
    return InkWell(
      onTap: () {
        Navigator.pop(context, item);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(item.name ?? ""),
      ),
    );
  }
}
