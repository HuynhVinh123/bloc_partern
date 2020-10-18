import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/empty_data_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/ware_house_stock/ware_house_stock_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/ware_house_stock/ware_house_stock_event.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/ware_house_stock/ware_house_stock_state.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class WareHouseStockPage extends StatefulWidget {
  @override
  _WareHouseStockPageState createState() => _WareHouseStockPageState();
}

class _WareHouseStockPageState extends State<WareHouseStockPage> {
  final _bloc = WareHouseStockBloc();
  final TextEditingController _keywordController = TextEditingController();
  bool isSearch = true;
  final BehaviorSubject<String> _searchController = BehaviorSubject();

  @override
  void initState() {
    super.initState();
    _bloc.add(WareHouseStockLoaded());
    _searchController
        .debounceTime(const Duration(milliseconds: 500))
        .listen((newKeyword) {
      _bloc.add(WareHouseStockLoaded(keyWord: newKeyword));
    });
  }

  /// Giao diện search Product
  Widget _buildSearch() {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(24)),
      height: 40,
      child: Row(
        children: <Widget>[
          const SizedBox(
            width: 12,
          ),
          const Icon(
            Icons.search,
            color: Color(0xFF28A745),
          ),
          Expanded(
            child: Center(
              child: Container(
                  height: 35,
                  margin: const EdgeInsets.only(left: 4),
                  child: Center(
                    child: TextField(
                      controller: _keywordController,
                      onChanged: (value) {
                        if (value == "" || value.length == 1) {
                          setState(() {});
                        }
                        _searchController.add(value);
                      },
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(0),
                          isDense: true,
                          hintText: S.current.search,
                          border: InputBorder.none),
                    ),
                  )),
            ),
          ),
          Visibility(
            visible: _keywordController.text != "",
            child: IconButton(
              constraints: const BoxConstraints(
                minWidth: 24,
                minHeight: 48,
              ),
              padding: const EdgeInsets.all(0.0),
              icon: const Icon(
                Icons.close,
                color: Colors.grey,
                size: 19,
              ),
              onPressed: () {
                setState(() {
                  _keywordController.text = "";
                });
                _searchController.add("");
              },
            ),
          ),
          const SizedBox(
            width: 8,
          ),
        ],
      ),
    );
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
            // Kho hàng
            title:
                isSearch ? _buildSearch() : Text(S.current.impExpInv_warehouse),
            actions: [
              IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      isSearch = !isSearch;
                    });
                  })
            ],
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

  /// Hiển thị danh sách kho
  Widget _buildListItem(WareHouseStockLoadSuccess state) {
    assert(state != null, "WareHouseStockLoadSuccess not null");
    return state.wareHouseStocks.isEmpty
        ? EmptyDataPage()
        : ListView.separated(
            itemBuilder: (context, index) =>
                _buildItem(state.wareHouseStocks[index]),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: state.wareHouseStocks.length);
  }

  /// Hiển thị từng sản phẩm kho
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
