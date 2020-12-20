import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tmt_flutter_untils/sources/num_utils/num_extensions.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/details/inventory_product/product_details_inventory_product_bloc.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/details/inventory_product/product_details_inventory_product_event.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/details/inventory_product/product_details_inventory_product_state.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/details/product_template_details_state.dart';
import 'package:tpos_mobile/widgets/bloc_widget/base_bloc_listener_ui.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/load_status.dart';
import 'package:tpos_mobile/widgets/loading_indicator.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

///Tab danh sách [InventoryProduct] dùng cho [ProductTemplateDetailsPage]
class ProductTemplateInventoryTab extends StatefulWidget {
  const ProductTemplateInventoryTab({Key key}) : super(key: key);

  @override
  _ProductTemplateInventoryTabState createState() => _ProductTemplateInventoryTabState();
}

class _ProductTemplateInventoryTabState extends State<ProductTemplateInventoryTab> {
  ProductDetailsInventoryProductBloc _productDetailsInventoryProductBloc;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  List<InventoryProduct> _inventorProducts;

  @override
  void initState() {
    _productDetailsInventoryProductBloc = BlocProvider.of<ProductDetailsInventoryProductBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseBlocListenerUi<ProductDetailsInventoryProductBloc, ProductDetailsInventoryProductState>(
        listener: (BuildContext context, ProductDetailsInventoryProductState state) {},
        loadingState: ProductDetailsInventoryProductLoading,
        errorState: ProductDetailsInventoryProductLoadFailure,
        errorBuilder: (BuildContext context, ProductDetailsInventoryProductState state) {
          String error = S.of(context).canNotGetDataFromServer;
          if (state is ProductDetailsInventoryProductLoadFailure) {
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
                  statusIcon: SvgPicture.asset('assets/icon/error.svg', width: 170, height: 130),
                  action: AppButton(
                    onPressed: () {
                      _productDetailsInventoryProductBloc.add(ProductDetailsInventoryProductRefresh());
                    },
                    width: 180,
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
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        builder: (BuildContext context, ProductDetailsInventoryProductState state) {
          if (state is ProductDetailsInventoryProductLoadSuccess) {
            _inventorProducts = state.inventoryProducts;
            if (state is ProductDetailsInventoryProductLoadNoMore) {
              _refreshController.loadNoData();
            } else {
              _refreshController.loadComplete();
            }
          }

          return Container(
              color: Colors.white,
              child: _inventorProducts.isEmpty
                  ? _buildEmpty()
                  : Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(child: _buildInventories()),
                      ],
                    ));
        });
  }

  Widget _buildEmpty() {
    return Column(
      children: [
        SizedBox(height: 50 * (MediaQuery.of(context).size.height / 700)),
        LoadStatusWidget.empty(
          statusName: S.of(context).noData,
          content: S.of(context).emptyNotificationParam(S.of(context).inventory.toLowerCase()),
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
    );
  }

  Widget _buildInventories() {
    final List<Widget> inventoryProductsWidget = [];

    double total = 0;
    for (final InventoryProduct inventoryProduct in _inventorProducts) {
      total += inventoryProduct.quantity;
      inventoryProductsWidget.add(_buildItem(inventoryProduct));
    }
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
            color: Colors.white,
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
            body = LoadingIndicator();
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
            color: Colors.white,
            child: Center(child: body),
          );
        },
      ),
      onRefresh: () async {},
      onLoading: () async {
        _productDetailsInventoryProductBloc.add(ProductDetailsInventoryProductLoadMore());
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('${S.of(context).stock}:', style: const TextStyle(color: Color(0xff929DAA), fontSize: 17)),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('${S.of(context).summaryParam(S.of(context).stock.toLowerCase())}: ',
                                style: const TextStyle(color: Color(0xff929DAA), fontSize: 17)),
                            Text(
                              total.toVietnameseCurrencyFormat(null, Localizations.localeOf(context).languageCode),
                              style: const TextStyle(color: Color(0xff28A745), fontSize: 19),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ] +
              inventoryProductsWidget,
        ),
      ),
    );
  }

  Widget _buildItem(InventoryProduct inventoryProduct) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 5),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  inventoryProduct.name,
                  style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
                ),
              ),
              Text(
                inventoryProduct.quantity.toString(),
                style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
              )
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(color: Colors.grey.shade200, height: 1, width: double.infinity),
        const SizedBox(height: 10),
      ],
    );
  }
}
