import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tmt_flutter_untils/sources/num_utils/num_extensions.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/product/ui/product_variant_details_page.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/details/product_variant/product_details_variant_bloc.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/details/product_variant/product_details_variant_event.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/details/product_variant/product_details_variant_state.dart';
import 'package:tpos_mobile/widgets/bloc_widget/base_bloc_listener_ui.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/load_status.dart';
import 'package:tpos_mobile/widgets/loading_indicator.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

///Tab danh sách [ProductAttribute] dùng cho [ProductDetailsVariantPage]
class ProductDetailsVariantAttributesTab extends StatefulWidget {
  const ProductDetailsVariantAttributesTab({Key key, this.onChanged})
      : super(key: key);

  @override
  _ProductDetailsVariantAttributesTabState createState() =>
      _ProductDetailsVariantAttributesTabState();
  final Function() onChanged;
}

class _ProductDetailsVariantAttributesTabState
    extends State<ProductDetailsVariantAttributesTab> {
  ProductDetailsVariantBloc _productDetailsVariantBloc;
  List<Product> _products;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    _productDetailsVariantBloc =
        BlocProvider.of<ProductDetailsVariantBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: BaseBlocListenerUi<ProductDetailsVariantBloc,
          ProductDetailsVariantState>(
        loadingState: ProductDetailsVariantLoading,
        errorState: ProductDetailsVariantLoadFailure,
        bloc: _productDetailsVariantBloc,
        errorBuilder: (BuildContext context, ProductDetailsVariantState state) {
          String error = S.of(context).canNotGetDataFromServer;

          if (state is ProductDetailsVariantLoadFailure) {
            error = state.error ?? S.of(context).canNotGetDataFromServer;
          }
          return _buildError(error);
        },
        builder: (BuildContext context, ProductDetailsVariantState state) {
          if (state is ProductDetailsVariantLoadSuccess) {
            _products = state.products;
            if (state is ProductDetailsVariantLoadNoMore) {
              _refreshController.loadNoData();
            } else {
              _refreshController.loadComplete();
            }
          }

          return _products.isEmpty
              ? _buildEmpty(context)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        '${_products.length} ${S.of(context).variant.toLowerCase()}',
                        style: const TextStyle(
                            color: Color(0xff929DAA), fontSize: 15),
                      ),
                    ),
                    Expanded(child: _buildAttributes(_products)),
                  ],
                );
        },
      ),
    );
  }

  Widget _buildError(String error) {
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
                  _productDetailsVariantBloc
                      .add(ProductDetailsVariantRefreshed());
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
  }

  Widget _buildAttributes(List<Product> products) {
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
            color: Colors.white,
            child: Center(child: body),
          );
        },
      ),
      onRefresh: () async {},
      onLoading: () async {
        _productDetailsVariantBloc.add(ProductDetailsVariantLoadMore());
      },
      child: ListView.separated(
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) {
          return AppButton(
            width: null,
            height: null,
            padding: const EdgeInsets.only(left: 16, right: 16),
            background: Colors.transparent,
            onPressed: () async {
              final Product productVariant = await Navigator.push<Product>(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductVariantDetailsPage(
                    productVariant: products[index],
                    isFromProductTemplate: true,
                  ),
                ),
              );

              if (productVariant != null) {
                _productDetailsVariantBloc
                    .add(ProductDetailsVariantRefreshed());
              }
            },
            child: _ProductItem(product: products[index]),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 0);
        },
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 50 * (MediaQuery.of(context).size.height / 700)),
        LoadStatusWidget.empty(
          statusName: S.of(context).noData,
          content: S
              .of(context)
              .emptyNotificationParam(S.of(context).variant.toLowerCase()),
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
}

class _ProductItem extends StatelessWidget {
  const _ProductItem({Key key, this.product}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
        bottom: BorderSide(
          width: 1.0,
          color: Color.fromARGB(255, 242, 244, 247),
        ),
      )),
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, left: 0, right: 13),
                child: Container(
                  width: 60,
                  height: 60,
                  // padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: product.imageUrl != null && product.imageUrl != ''
                      ? CachedNetworkImage(
                          width: 60,
                          height: 60,
                          imageUrl: product.imageUrl,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                          fit: BoxFit.cover,
                          imageBuilder: (BuildContext context,
                              ImageProvider imageProvider) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                  color: Colors.grey.withAlpha(100),
                                ),
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                            );
                          },
                          errorWidget: (context, url, error) => Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                color: Colors.grey,
                                border: Border.all(
                                  color: Colors.grey.withAlpha(100),
                                )),
                            child: SvgPicture.asset(
                                'assets/icon/empty-image-product.svg',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              color: Colors.grey,
                              border: Border.all(
                                color: Colors.grey.withAlpha(100),
                              )),
                          child: SvgPicture.asset(
                              'assets/icon/empty-image-product.svg',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover),
                        ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product.nameGet ?? '',
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 44, 51, 58),
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 1.5),
                          child: Text(
                            product.uOMName ?? '',
                            style: const TextStyle(
                                color: Color.fromARGB(255, 146, 157, 170),
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 1.5),
                          child: Text(
                            ' -',
                            style: TextStyle(
                                color: Color.fromARGB(255, 146, 157, 170),
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Text(
                          ' ${S.of(context).availableQuantity}: ',
                          style: const TextStyle(
                              color: Color.fromARGB(255, 146, 157, 170),
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                        if (product.qtyAvailable > 0)
                          Flexible(
                            child: Text(
                              product.qtyAvailable.toVietnameseCurrencyFormat(
                                  null,
                                  Localizations.localeOf(context)
                                      .languageCode),
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 40, 167, 69),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        else
                          Flexible(
                            child: Text(
                              '${product.qtyAvailable.toVietnameseCurrencyFormat(null, Localizations.localeOf(context).languageCode)} - Hết hàng',
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 235, 59, 91),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                      ],
                    ),
                    if (product.attributeValues.isNotEmpty)
                      _buildAttributes(product.attributeValues)
                    else
                      const SizedBox(),
                    if (!product.active)
                      Row(
                        children: [
                          Text(
                            S.of(context).invalidProduct,
                            style: const TextStyle(
                                color: Color(0xffA7B2BF),
                                fontSize: 15,
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                product.listPrice.toVietnameseCurrencyFormat(
                    null, Localizations.localeOf(context).languageCode),
                style: const TextStyle(
                    color: Color.fromARGB(255, 107, 114, 128),
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 12),
            ],
          ),
          if (product.displayAttributeValues != null &&
              product.displayAttributeValues != '')
            Padding(
              padding: const EdgeInsets.only(left: 70, top: 5),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          runSpacing: 5,
                          spacing: 5,
                          children: product.displayAttributeValues
                              .split(',')
                              .map((String item) => Container(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, top: 5, bottom: 5),
                                    decoration: const BoxDecoration(
                                      color: Color(0xffF0F1F3),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(13)),
                                    ),
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                          color: Color(0xff2C333A),
                                          fontSize: 13),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            )
        ],
      ),
    );
  }

  Widget _buildAttributes(List<ProductAttributeValue> tags) {
    return Row(
      children: [
        Wrap(
          spacing: 10,
          children: tags
              .map((ProductAttributeValue productAttribute) =>
                  _buildAttribute(productAttribute))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildAttribute(ProductAttributeValue tag) {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/icon/tag_green.svg',
          color: const Color(0xff858F9B),
          // color: fromHex(tag.color),
        ),
        const SizedBox(width: 5),
        // Text(
        //   tag.name,
        //   style: TextStyle(color: fromHex(tag.color)),
        // ),
      ],
    );
  }
}
