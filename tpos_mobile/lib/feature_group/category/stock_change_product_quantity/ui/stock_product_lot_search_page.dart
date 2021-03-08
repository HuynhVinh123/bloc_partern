import 'package:flutter/material.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/stock_change_product_quantity/bloc/production_lot/stock_product_lot_bloc.dart';
import 'package:tpos_mobile/feature_group/category/stock_change_product_quantity/bloc/production_lot/stock_product_lot_event.dart';
import 'package:tpos_mobile/feature_group/category/stock_change_product_quantity/bloc/production_lot/stock_product_lot_state.dart';
import 'package:tpos_mobile/widgets/bloc_widget/base_bloc_listener_ui.dart';
import 'package:tpos_mobile/widgets/load_status.dart';
import 'package:tpos_mobile/widgets/search_app_bar.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class StockProductionLotSearchPage extends StatefulWidget {
  const StockProductionLotSearchPage({Key key, this.stockProductionLots}) : super(key: key);

  @override
  _StockProductionLotSearchPageState createState() => _StockProductionLotSearchPageState();
  final List<StockProductionLot> stockProductionLots;
}

class _StockProductionLotSearchPageState extends State<StockProductionLotSearchPage> {
  StockProductionLotBloc _stockProductionLotBloc;
  String _search = '';

  @override
  void initState() {
    _stockProductionLotBloc = StockProductionLotBloc();
    _stockProductionLotBloc.add(StockProductionLotStarted(stockProductionLots: widget.stockProductionLots));
    super.initState();
  }

  @override
  void dispose() {
    _stockProductionLotBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      body: _buildBody(),
    );
  }

  Widget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: SearchAppBar(
        title: S.current.productVariation,
        text: _search,
        hideBackWhenSearch: true,
        onKeyWordChanged: (String search) {
          if (_search != search) {
            _search = search;
            _stockProductionLotBloc.add(StockProductionLotSearched(search: _search));
          }
        },
      ),
    );
  }

  Widget _buildBody() {
    return BaseBlocListenerUi<StockProductionLotBloc, StockProductionLotState>(
      bloc: _stockProductionLotBloc,
      loadingState: StockProductionLotLoading,
      builder: (BuildContext context, StockProductionLotState state) {
        return state.stockProductionLots.isEmpty
            ? _buildEmptyList()
            : ListView.separated(
                itemCount: state.stockProductionLots.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox();
                },
                itemBuilder: (BuildContext context, int index) {
                  return _buildItem(state.stockProductionLots[index]);
                },
              );
      },
    );
  }

  Widget _buildItem(StockProductionLot product) {
    return Column(
      children: <Widget>[
        const Divider(height: 2.0),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: ListTile(
            onTap: () {
              Navigator.pop(context, product);
            },
            contentPadding: const EdgeInsets.all(5),
            title: Text(product.productNameGet ?? '', textAlign: TextAlign.start),
            leading: CircleAvatar(
              backgroundColor: const Color(0xffE9F6EC),
              child: Text(product.name != null && product.name != '' ? product.name.substring(0, 1) : ''),
            ),
          ),
        ),
      ],
    );
  }

  ///Xây dựng giao diện trống
  Widget _buildEmptyList() {
    return SingleChildScrollView(
        child: Column(
      children: [
        SizedBox(height: 50 * (MediaQuery.of(context).size.height / 700)),
        LoadStatusWidget.empty(
          statusName: S.of(context).noData,
          content: _search != ''
              ? S.current.searchNotFoundWithKeywordParam(_search, S.current.productVariation)
              : S.of(context).emptyNotificationParam(S.of(context).productVariation.toLowerCase()),
          // action: ClipRRect(
          //   borderRadius: BorderRadius.circular(24),
          //   child: AppButton(
          //     onPressed: () async {},
          //     width: null,
          //     padding: const EdgeInsets.only(left: 20, right: 20),
          //     decoration: const BoxDecoration(
          //       color: Color.fromARGB(255, 40, 167, 69),
          //       borderRadius: BorderRadius.all(Radius.circular(24)),
          //     ),
          //     child: Center(
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           const Icon(
          //             Icons.add,
          //             color: Colors.white,
          //             size: 23,
          //           ),
          //           const SizedBox(width: 10),
          //           Text(
          //             S.of(context).addNewParam(S.of(context).productVariation.toLowerCase()),
          //             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ),
      ],
    ));
  }
}
