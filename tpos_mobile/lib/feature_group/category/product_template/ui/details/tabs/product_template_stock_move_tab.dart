import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/details/product_template_details_event.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/details/stock_move/product_details_stock_move_bloc.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/details/stock_move/product_details_stock_move_event.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/details/stock_move/product_details_stock_move_state.dart';
import 'package:tpos_mobile/widgets/bloc_widget/base_bloc_listener_ui.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/load_status.dart';
import 'package:tpos_mobile/widgets/loading_indicator.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

///Tab danh sách [StockMove] dùng cho [ProductDetailsPage]
class ProductTemplateStockMoveTab extends StatefulWidget {
  const ProductTemplateStockMoveTab({Key key}) : super(key: key);

  @override
  _ProductTemplateStockMoveTabState createState() =>
      _ProductTemplateStockMoveTabState();
}

class _ProductTemplateStockMoveTabState
    extends State<ProductTemplateStockMoveTab> {
  ProductDetailsStockMoveBloc _productDetailsStockMoveBloc;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  Map<StockType, String> _stockTypeFilters;
  List<StockMove> _stockMoves;
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm', 'en_US');

  StockType _stockTypeFilter = StockType.ALL;

  @override
  void initState() {
    _productDetailsStockMoveBloc =
        BlocProvider.of<ProductDetailsStockMoveBloc>(context);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _stockTypeFilters = <StockType, String>{
      StockType.IMPORT: S.of(context).inStock,
      StockType.EXPORT: S.of(context).outStock,
      StockType.ALL: S.of(context).all
    };
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseBlocListenerUi<ProductDetailsStockMoveBloc,
        ProductDetailsStockMoveState>(
      listener: (BuildContext context, ProductDetailsStockMoveState state) {},
      loadingState: ProductDetailsStockMoveLoading,
      errorState: ProductDetailsStockMoveLoadFailure,
      errorBuilder: (BuildContext context, ProductDetailsStockMoveState state) {
        String error = S.of(context).canNotGetDataFromServer;
        if (state is ProductDetailsStockMoveLoadFailure) {
          error = state.error;
        }

        return Container(
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(height: 50 * (MediaQuery.of(context).size.height / 700)),
              LoadStatusWidget(
                statusName: S.of(context).loadDataError,
                content: error,
                statusIcon: SvgPicture.asset('assets/icon/error.svg',
                    width: 170, height: 130),
                action: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: AppButton(
                    onPressed: () {
                      _productDetailsStockMoveBloc
                          .add(ProductDetailsStockMoveRefresh());
                    },
                    width: null,
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 40, 167, 69),
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            FontAwesomeIcons.sync,
                            color: Colors.white,
                            size: 23,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            S.of(context).refreshPage,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      builder: (BuildContext context, ProductDetailsStockMoveState state) {
        if (state is ProductDetailsStockMoveLoadSuccess) {
          _stockMoves = state.stockMoves;
          if (state is ProductDetailsStockMoveLoadNoMore) {
            _refreshController.loadNoData();
          } else {
            _refreshController.loadComplete();
          }
        }

        return Container(
          color: Colors.white,
          child: _stockMoves.isEmpty
              ? _buildEmpty()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _buildFilters(),
                    const SizedBox(height: 15),
                    Expanded(child: _buildStockMoves())
                  ],
                ),
        );
      },
    );
  }

  Widget _buildEmpty() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        children: [
          SizedBox(height: 50 * (MediaQuery.of(context).size.height / 700)),
          LoadStatusWidget.empty(
            statusName: S.of(context).noData,
            content: S
                .of(context)
                .emptyNotificationParam(S.of(context).stockMove.toLowerCase()),
            // action: AppButton(
            //   onPressed: () {},
            //   width: 180,
            //   decoration: const BoxDecoration(
            //     color: Color.fromARGB(255, 40, 167, 69),
            //     borderRadius: BorderRadius.all(Radius.circular(24)),
            //   ),
            //   child: Center(
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: const [
            //         Icon(
            //           FontAwesomeIcons.sync,
            //           color: Colors.white,
            //           size: 23,
            //         ),
            //         SizedBox(width: 10),
            //         Text(
            //           'Thêm mới',
            //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${_stockMoves.length} ${S.of(context).stockMove.toLowerCase()}',
            style: const TextStyle(color: Color(0xff929DAA), fontSize: 15),
          ),
          Container(
            width: 120,
            height: 40,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color.fromARGB(255, 248, 249, 251)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<StockType>(
                icon: Row(
                  children: const <Widget>[
                    Icon(Icons.arrow_drop_down),
                    SizedBox(width: 10),
                  ],
                ),
                hint: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(S.of(context).arrange),
                ),
                value: _stockTypeFilter,
                isExpanded: true,
                onChanged: (StockType stockType) {
                  _stockTypeFilter = stockType;
                  _productDetailsStockMoveBloc
                      .add(ProductDetailsStockMoveFilter(filter: stockType));
                },
                selectedItemBuilder: (BuildContext context) {
                  return _stockTypeFilters.keys.map<Widget>((StockType item) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 5, left: 5),
                            alignment: Alignment.centerLeft,
                            child: Text(_stockTypeFilters[item],
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style:
                                    const TextStyle(color: Color(0xff5A6271))),
                          ),
                        ),
                      ],
                    );
                  }).toList();
                },
                items: _stockTypeFilters.keys
                    .map(
                      (key) => DropdownMenuItem<StockType>(
                        value: key,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            _stockTypeFilters[key],
                            style: const TextStyle(color: Color(0xff5A6271)),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///Xâu dựng giao diện danh sách thể kho
  Widget _buildStockMoves() {
    return SmartRefresher(
        enablePullDown: false,
        enablePullUp: true,
        header: CustomHeader(
          builder: (BuildContext context, RefreshStatus mode) {
            Widget body;
            if (mode == RefreshStatus.idle) {
              body = Text(
                S.of(context).pullDownToRefresh,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xff2C333A),
                ),
              );
            } else if (mode == RefreshStatus.canRefresh) {
              body = Text(
                S.of(context).releaseToGetData,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xff2C333A),
                ),
              );
            }
            return Container(
              height: 50,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text(
                S.of(context).pullUpToGetMoreData,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xff2C333A),
                ),
              );
            } else if (mode == LoadStatus.loading) {
              body = const LoadingIndicator();
            } else if (mode == LoadStatus.canLoading) {
              body = Text(
                S.of(context).releaseToGetMoreData,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xff2C333A),
                ),
              );
            } else {
              body = Text(
                S.of(context).noMoreData,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xff2C333A),
                ),
              );
            }
            return Container(
              height: 50,
              child: Center(child: body),
            );
          },
        ),
        onRefresh: () async {},
        onLoading: () async {
          _productDetailsStockMoveBloc.add(ProductDetailsStockMoveLoadMore());
        },
        child: ListView.separated(
          itemCount: _stockMoves.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildItem(_stockMoves[index]);
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox();
          },
        ));
  }

  Widget _buildItem(StockMove stockMove) {
    assert(dateFormat != null);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      stockMove.name,
                      style: const TextStyle(
                          color: Color(0xff2C333A), fontSize: 19),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (stockMove.type.contains('Xuất kho'))
                        SvgPicture.asset(
                          'assets/icon/upload.svg',
                          width: 20,
                          height: 20,
                        )
                      else
                        SvgPicture.asset(
                          'assets/icon/download.svg',
                          width: 20,
                          height: 20,
                        ),
                      const SizedBox(width: 7),
                      Text(
                        stockMove.productQty.toStringAsFixed(0),
                        style: TextStyle(
                            color: stockMove.type.contains('Xuất kho')
                                ? const Color(0xffEB3B5B)
                                : const Color(0xff28A745),
                            fontSize: 19,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    stockMove.locationNameGet,
                    style:
                        const TextStyle(color: Color(0xff5A6271), fontSize: 17),
                  ),
                  const SizedBox(width: 10),
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Icon(
                      Icons.arrow_right_alt,
                      color: Color(0xff28A745),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      stockMove.locationDestNameGet,
                      style: const TextStyle(
                          color: Color(0xff5A6271), fontSize: 17),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${S.of(context).summaryUnit}: ${stockMove.productUOMName}',
                    style:
                        const TextStyle(color: Color(0xff929DAA), fontSize: 15),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    stockMove.date != null
                        ? dateFormat.format(stockMove.date.toLocal())
                        : '',
                    style:
                        const TextStyle(color: Color(0xff929DAA), fontSize: 15),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
            color: Colors.grey.shade200, height: 1, width: double.infinity),
        const SizedBox(height: 10),
      ],
    );
  }
}
