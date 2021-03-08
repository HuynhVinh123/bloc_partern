import 'package:flutter/material.dart';
import 'package:tpos_mobile/feature_group/category/stock_change_product_quantity/bloc/stock_location/stock_location_bloc.dart';
import 'package:tpos_mobile/feature_group/category/stock_change_product_quantity/bloc/stock_location/stock_location_event.dart';
import 'package:tpos_mobile/feature_group/category/stock_change_product_quantity/bloc/stock_location/stock_location_state.dart';
import 'package:tpos_mobile/src/tpos_apis/models/stock_location.dart';
import 'package:tpos_mobile/widgets/bloc_widget/base_bloc_listener_ui.dart';
import 'package:tpos_mobile/widgets/load_status.dart';
import 'package:tpos_mobile/widgets/search_app_bar.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class StockLocationSearchPage extends StatefulWidget {
  const StockLocationSearchPage({Key key, this.stockLocations}) : super(key: key);

  @override
  _StockLocationSearchPageState createState() => _StockLocationSearchPageState();
  final List<StockLocation> stockLocations;
}

class _StockLocationSearchPageState extends State<StockLocationSearchPage> {
  StockLocationBloc _stockLocationBloc;
  String _search = '';

  @override
  void initState() {
    _stockLocationBloc = StockLocationBloc();
    _stockLocationBloc.add(StockLocationStarted(stockLocations: widget.stockLocations));
    super.initState();
  }

  @override
  void dispose() {
    _stockLocationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
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
            _stockLocationBloc.add(StockLocationSearched(search: _search));
          }
        },
      ),
    );
  }

  Widget _buildBody() {
    return BaseBlocListenerUi<StockLocationBloc, StockLocationState>(
      bloc: _stockLocationBloc,
      loadingState: StockLocationLoading,
      builder: (BuildContext context, StockLocationState state) {
        return state.stockProductions.isEmpty
            ? _buildEmptyList()
            : ListView.separated(
                itemCount: state.stockProductions.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox();
                },
                itemBuilder: (BuildContext context, int index) {
                  return _buildItem(state.stockProductions[index]);
                },
              );
      },
    );
  }

  Widget _buildItem(StockLocation product) {
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
            title: Text(product.nameGet ?? '', textAlign: TextAlign.start),
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
        ),
      ],
    ));
  }
}
