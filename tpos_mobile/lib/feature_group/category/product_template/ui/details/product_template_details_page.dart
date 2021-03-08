import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tmt_flutter_untils/sources/num_utils/num_extensions.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/feature_group/category/attribute_value_price/ui/attribute_value_price_page.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/details/images/product_details_image_bloc.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/details/images/product_details_image_event.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/details/images/product_details_image_state.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/details/inventory_product/product_details_inventory_product_bloc.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/details/inventory_product/product_details_inventory_product_event.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/details/product_template_details_bloc.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/details/product_template_details_event.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/details/product_template_details_state.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/details/product_variant/product_details_variant_bloc.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/details/product_variant/product_details_variant_event.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/details/stock_move/product_details_stock_move_bloc.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/details/stock_move/product_details_stock_move_event.dart';
import 'package:tpos_mobile/feature_group/category/product_template/ui/add_edit/product_template_add_edit_page.dart';
import 'package:tpos_mobile/feature_group/category/product_template/ui/details/tabs/product_template_details_attributes_tab.dart';
import 'package:tpos_mobile/feature_group/category/product_template/ui/details/tabs/product_template_inventory_tab.dart';
import 'package:tpos_mobile/feature_group/category/product_template/ui/details/tabs/product_template_stock_move_tab.dart';
import 'package:tpos_mobile/feature_group/category/product_template_tags/ui/tag_product_search_page.dart';
import 'package:tpos_mobile/feature_group/category/stock_change_product_quantity/ui/stock_change_product_quanlity_page.dart';
import 'package:tpos_mobile/src/tpos_apis/models/stock_change_product_quantity.dart';
import 'package:tpos_mobile/widgets/alive_state.dart';
import 'package:tpos_mobile/widgets/bloc_widget/base_bloc_listener_ui.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/custom_expand_widget.dart';
import 'package:tpos_mobile/widgets/custom_snack_bar.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/load_status.dart';
import 'package:tpos_mobile/widgets/scroll_tab_view.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

///Xây dựng giao diện màn hình chi tiết sản phẩm [ProductTemplate]
class ProductTemplateDetailsPage extends StatefulWidget {
  const ProductTemplateDetailsPage({Key key, this.productTemplate})
      : super(key: key);

  @override
  _ProductTemplateDetailsPageState createState() =>
      _ProductTemplateDetailsPageState();
  final ProductTemplate productTemplate;
}

class _ProductTemplateDetailsPageState
    extends State<ProductTemplateDetailsPage> {
  ProductTemplateDetailsBloc _productTemplateDetailsBloc;
  ProductDetailsStockMoveBloc _productDetailsStockMoveBloc;
  ProductDetailsInventoryProductBloc _productDetailsInventoryProductBloc;
  ProductDetailsVariantBloc _productDetailsVariantBloc;
  ProductDetailsImageBloc _productDetailsImageBloc;

  bool _change = false;
  bool _loadStockMove = false;
  bool _loadInventoryProduct = false;
  bool _loadProductVariant = false;
  ProductTemplate _productTemplate;
  UserPermission _userPermission;
  final PageController _pageController = PageController(initialPage: 0);

  Map<ProductTemplateAction, String> productTemplateActionMap;

  List<String> tabs;

  @override
  void initState() {
    _productDetailsVariantBloc = ProductDetailsVariantBloc();
    _productDetailsStockMoveBloc = ProductDetailsStockMoveBloc();
    _productDetailsInventoryProductBloc = ProductDetailsInventoryProductBloc();
    _productDetailsImageBloc = ProductDetailsImageBloc();
    _productTemplateDetailsBloc = ProductTemplateDetailsBloc();
    _productTemplateDetailsBloc.add(
        ProductTemplateDetailsStarted(productTemplate: widget.productTemplate));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    tabs = [
      S.current.generalInformation,
      S.current.variant,
      S.current.stockMove,
      S.current.inventory
    ];

    if (widget.productTemplate.active) {
      productTemplateActionMap = <ProductTemplateAction, String>{
        ProductTemplateAction.EDIT_STOCK_MOVE: S.current.editAvailableInventory,
        // ProductTemplateAction.PRINT_BARCODE: 'In tem mã',
        ProductTemplateAction.STOP_ACTIVE: S.current.disableActive,
        ProductTemplateAction.ATTRIBUTE_PRICE: S.current.attributePrice,
        ProductTemplateAction.DELETE: S.current.deleteProduct
      };
    } else {
      productTemplateActionMap = <ProductTemplateAction, String>{
        ProductTemplateAction.EDIT_STOCK_MOVE: S.current.editAvailableInventory,
        // ProductTemplateAction.PRINT_BARCODE: 'In tem mã',
        ProductTemplateAction.ACTIVE: S.current.enableActive,
        ProductTemplateAction.ATTRIBUTE_PRICE: S.current.attributePrice,
        ProductTemplateAction.DELETE: S.current.deleteProduct
      };
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _productTemplateDetailsBloc.close();
    _productDetailsInventoryProductBloc.close();
    _productDetailsStockMoveBloc.close();
    _productDetailsVariantBloc.close();
    _productTemplateDetailsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _change);
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xffEBEDEF),
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        S.current.productDetails,
        style: const TextStyle(color: Colors.white, fontSize: 21),
      ),
      leading: ClipOval(
        child: Container(
          height: 50,
          width: 60,
          child: Material(
            color: Colors.transparent,
            child: IconButton(
              iconSize: 25,
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () async {
                Navigator.pop(context, _change);
              },
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
            icon: const Icon(Icons.edit_sharp, color: Colors.white, size: 23),
            onPressed: () async {
              final bool isInsert = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductTemplateAddEditPage(
                    productTemplate: widget.productTemplate,
                  ),
                ),
              );

              if (isInsert != null && isInsert) {
                _change = true;
                _productTemplateDetailsBloc.add(ProductTemplateDetailsStarted(
                    productTemplate: widget.productTemplate));
                if (_loadProductVariant) {
                  _productDetailsVariantBloc
                      .add(ProductDetailsVariantRefreshed());
                }
                if (_loadStockMove) {
                  _productDetailsStockMoveBloc
                      .add(ProductDetailsStockMoveRefresh());
                }

                if (_loadInventoryProduct) {
                  _productDetailsInventoryProductBloc
                      .add(ProductDetailsInventoryProductRefresh());
                }
              }
            }),
        PopupMenuButton<ProductTemplateAction>(
            onSelected: (ProductTemplateAction value) async {
              switch (value) {
                case ProductTemplateAction.EDIT_STOCK_MOVE:
                  final StockChangeProductQuantity _stockChangeProductQuantity =
                      await Navigator.push<StockChangeProductQuantity>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StockChangeProductQuantityPage(
                        productTemplateId: widget.productTemplate.id,
                      ),
                    ),
                  );
                  if (_stockChangeProductQuantity != null) {
                    _productTemplateDetailsBloc.add(
                        ProductTemplateDetailsStarted(
                            productTemplate: widget.productTemplate));
                    if (_loadProductVariant) {
                      _productDetailsVariantBloc
                          .add(ProductDetailsVariantRefreshed());
                    }
                    if (_loadInventoryProduct) {
                      _productDetailsInventoryProductBloc
                          .add(ProductDetailsInventoryProductRefresh());
                    }

                    if (_loadStockMove) {
                      _productDetailsStockMoveBloc
                          .add(ProductDetailsStockMoveRefresh());
                    }
                  }
                  break;
                case ProductTemplateAction.PRINT_BARCODE:
                  // TODO(sangcv): thêm chức năng in barcode
                  break;
                case ProductTemplateAction.STOP_ACTIVE:
                  if (_productTemplate != null) {
                    _productTemplateDetailsBloc
                        .add(ProductTemplateDetailsActiveSet(active: false));
                    if (_loadProductVariant) {
                      _productDetailsVariantBloc
                          .add(ProductDetailsVariantRefreshed());
                    }
                  } else {
                    App.showDefaultDialog(
                        title: S.current.error,
                        context: context,
                        type: AlertDialogType.error,
                        content: S.current.canNotGetData);
                  }
                  break;
                case ProductTemplateAction.DELETE:
                  if (_productTemplate != null) {
                    final bool result = await App.showConfirm(
                        title: S.current.confirmDelete,
                        content: S.current.productDeleteConfirm);
                    if (result != null && result) {
                      _productTemplateDetailsBloc
                          .add(ProductTemplateDetailsDelete());
                    }
                  } else {
                    App.showDefaultDialog(
                        title: S.current.error,
                        context: context,
                        type: AlertDialogType.error,
                        content: S.current.canNotGetData);
                  }
                  break;
                case ProductTemplateAction.ATTRIBUTE_PRICE:
                  final bool change = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AttributeValuePricePage(
                        productTemplate: widget.productTemplate,
                      ),
                    ),
                  );

                  if (change != null && change) {
                    _productTemplateDetailsBloc.add(
                        ProductTemplateDetailsStarted(
                            productTemplate: widget.productTemplate));
                    if (_loadProductVariant) {
                      _productDetailsVariantBloc
                          .add(ProductDetailsVariantRefreshed());
                    }
                  }
                  break;
                case ProductTemplateAction.ACTIVE:
                  if (_productTemplate != null) {
                    _productTemplateDetailsBloc
                        .add(ProductTemplateDetailsActiveSet(active: true));
                  } else {
                    App.showDefaultDialog(
                        title: S.current.error,
                        context: context,
                        type: AlertDialogType.error,
                        content: S.current.canNotGetData);
                  }
                  break;
              }
            },
            itemBuilder: (BuildContext context) => productTemplateActionMap.keys
                .map((ProductTemplateAction action) =>
                    PopupMenuItem<ProductTemplateAction>(
                      value: action,
                      child: Text(
                        productTemplateActionMap[action],
                        style: const TextStyle(
                            color: Color(0xff2C333A), fontSize: 15),
                      ),
                    ))
                .toList())
      ],
    );
  }

  Widget _buildBody() {
    return BaseBlocListenerUi<ProductTemplateDetailsBloc,
        ProductTemplateDetailsState>(
      busyState: ProductTemplateDetailsBusy,
      bloc: _productTemplateDetailsBloc,
      listener: (BuildContext context, ProductTemplateDetailsState state) {
        if (state is ProductTemplateDetailsActiveSetSuccess) {
          _change = true;
          final Widget snackBar = getCloseableSnackBar(
              message: state.active
                  ? S.current.enableActiveSuccessful
                  : S.current.disableActiveSuccessful,
              context: context);
          Scaffold.of(context).showSnackBar(snackBar);

          if (state.active) {
            productTemplateActionMap = <ProductTemplateAction, String>{
              ProductTemplateAction.EDIT_STOCK_MOVE:
                  S.current.editAvailableInventory,
              // ProductTemplateAction.PRINT_BARCODE: 'In tem mã',
              ProductTemplateAction.STOP_ACTIVE: S.current.disableActive,
              ProductTemplateAction.ATTRIBUTE_PRICE: S.current.attributePrice,
              ProductTemplateAction.DELETE: S.current.deleteProduct
            };
          } else {
            productTemplateActionMap = <ProductTemplateAction, String>{
              ProductTemplateAction.EDIT_STOCK_MOVE:
                  S.current.editAvailableInventory,
              // ProductTemplateAction.PRINT_BARCODE: 'In tem mã',
              ProductTemplateAction.ACTIVE: S.current.enableActive,
              ProductTemplateAction.ATTRIBUTE_PRICE: S.current.attributePrice,
              ProductTemplateAction.DELETE: S.current.deleteProduct
            };
          }

          setState(() {});
        } else if (state is ProductTemplateDetailsDeleteSuccess) {
          final Widget snackBar = getCloseableSnackBar(
              message: S.current.deleteSuccessful, context: context);
          Scaffold.of(context).showSnackBar(snackBar);
          Navigator.of(context).pop(true);
        } else if (state is ProductTemplateDetailsDeleteFailure) {
          App.showDefaultDialog(
              title: S.current.error,
              context: context,
              type: AlertDialogType.error,
              content: state.error);
        } else if (state is ProductTemplateDetailsActiveSetFailure) {
          App.showDefaultDialog(
              title: S.current.error,
              context: context,
              type: AlertDialogType.error,
              content: state.error);
        } else if (state is ProductTemplateDetailsStartSuccess) {
          _productTemplate = state.productTemplate;
          if (_productTemplate.active) {
            productTemplateActionMap = <ProductTemplateAction, String>{
              ProductTemplateAction.EDIT_STOCK_MOVE:
                  S.current.editAvailableInventory,
              // ProductTemplateAction.PRINT_BARCODE: 'In tem mã',
              ProductTemplateAction.STOP_ACTIVE: S.current.disableActive,
              ProductTemplateAction.ATTRIBUTE_PRICE: S.current.attributePrice,
              ProductTemplateAction.DELETE: S.current.deleteProduct
            };
          } else {
            productTemplateActionMap = <ProductTemplateAction, String>{
              ProductTemplateAction.EDIT_STOCK_MOVE:
                  S.current.editAvailableInventory,
              // ProductTemplateAction.PRINT_BARCODE: 'In tem mã',
              ProductTemplateAction.ACTIVE: S.current.enableActive,
              ProductTemplateAction.ATTRIBUTE_PRICE: S.current.attributePrice,
              ProductTemplateAction.DELETE: S.current.deleteProduct
            };
          }

          setState(() {});
          _productDetailsImageBloc.add(ProductDetailsImageStarted(
              productTemplateId: _productTemplate?.id));
        } else if (state is ProductTemplateDetailsAssignTagSuccess) {
          _change = true;
          final Widget snackBar = getCloseableSnackBar(
              message: S.current.assignTagSuccessful, context: context);
          Scaffold.of(context).showSnackBar(snackBar);
        } else if (state is ProductTemplateDetailsAssignTagFailure) {
          App.showDefaultDialog(
              title: S.of(context).error,
              context: context,
              type: AlertDialogType.error,
              content: state.error);
        }
      },
      buildWhen: (ProductTemplateDetailsState last,
          ProductTemplateDetailsState current) {
        return current is! ProductTemplateDetailsActiveSetFailure ||
            current is! ProductTemplateDetailsDeleteSuccess ||
            current is! ProductTemplateDetailsDeleteFailure;
      },
      builder: (BuildContext context, ProductTemplateDetailsState state) {
        if (state is ProductTemplateDetailsLoadSuccess) {
          _productTemplate = state.productTemplate;
          _userPermission = state.userPermission;
        }

        return Column(
          children: [
            _buildHeaderTab(),
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: [
                  AliveState(
                    child: BlocProvider<ProductDetailsImageBloc>.value(
                      value: _productDetailsImageBloc,
                      child: _buildBLocUi(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildImagesBloc(),
                              _GeneralInfoTab(
                                productTemplate: _productTemplate,
                                userPermission: _userPermission,
                                productTemplateDetailsBloc:
                                    _productTemplateDetailsBloc,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  AliveState(
                    child: BlocProvider<ProductDetailsVariantBloc>.value(
                      value: _productDetailsVariantBloc,
                      child: ProductDetailsVariantAttributesTab(
                        onChanged: () {
                          _productTemplateDetailsBloc.add(
                              ProductTemplateDetailsStarted(
                                  productTemplate: widget.productTemplate));
                          _productDetailsStockMoveBloc.add(
                              ProductDetailsStockMoveStarted(
                                  productTemplateId:
                                      widget.productTemplate?.id));
                          _productDetailsInventoryProductBloc.add(
                              ProductDetailsInventoryProductStarted(
                                  productTemplateId:
                                      widget.productTemplate?.id));
                        },
                      ),
                    ),
                  ),
                  AliveState(
                    child: BlocProvider<ProductDetailsStockMoveBloc>.value(
                      value: _productDetailsStockMoveBloc,
                      child: const ProductTemplateStockMoveTab(),
                    ),
                  ),
                  AliveState(
                    child:
                        BlocProvider<ProductDetailsInventoryProductBloc>.value(
                      value: _productDetailsInventoryProductBloc,
                      child: const ProductTemplateInventoryTab(),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  ///Xây dựng giao diện bloc hình ảnh
  Widget _buildImagesBloc() {
    return Container(
      height: 200,
      width: double.infinity,
      child:
          BaseBlocListenerUi<ProductDetailsImageBloc, ProductDetailsImageState>(
        loadingState: ProductDetailsImageLoading,
        errorState: ProductDetailsImageLoadFailure,
        errorBuilder: (BuildContext context, ProductDetailsImageState state) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  S.current.canNotLoadImage,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff2C333A)),
                ),
                const SizedBox(
                  height: 10,
                ),
                AppButton(
                  onPressed: () {
                    _productDetailsImageBloc
                        .add(ProductDetailsImageRefreshed());
                  },
                  width: null,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 40, 167, 69),
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  child: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                    size: 23,
                  ),
                ),
              ],
            ),
          );
        },
        builder: (BuildContext context, ProductDetailsImageState state) {
          if (state is ProductDetailsImageLoadSuccess) {
            return _buildImagesContent(state.productImages);
          }
          return const SizedBox();
        },
      ),
    );
  }

  ///Xây dựng giao diện hiện thị danh sách hình ảnh
  Widget _buildImagesContent(List<ProductImage> productImages) {
    int imageSize = productImages.length;
    final bool hasImage =
        _productTemplate.imageUrl != null && _productTemplate.imageUrl != '';
    if (hasImage) {
      imageSize += 1;
    }
    return imageSize == 0
        ? Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
                color: Colors.grey,
                border: Border.all(
                  color: Colors.grey.withAlpha(100),
                )),
            child: SvgPicture.asset('assets/icon/empty-image-product.svg',
                width: 50, height: 50, fit: BoxFit.cover),
          )
        : Container(
            width: double.infinity,
            height: 200,
            child: Swiper(
              key: const ValueKey<String>('Swiper'),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () async {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return _buildDialogImage(context, index, productImages);
                      },
                      useRootNavigator: false,
                    );
                  },
                  child: index == 0 &&
                          _productTemplate.imageUrl != null &&
                          _productTemplate.imageUrl != ''
                      ? CachedNetworkImage(
                          imageUrl: _productTemplate.imageUrl,
                          fit: BoxFit.cover,
                          imageBuilder: (BuildContext context,
                              ImageProvider imageProvider) {
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.withAlpha(100),
                                ),
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                            );
                          },
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                          errorWidget: (context, url, error) => Container(
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                border: Border.all(
                                  color: Colors.grey.withAlpha(100),
                                )),
                            child: SvgPicture.asset(
                                'assets/icon/empty-image-product.svg',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover),
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: (_productTemplate.imageUrl != null &&
                                  _productTemplate.imageUrl != '')
                              ? productImages[index - 1].url
                              : productImages[index].url,
                          fit: BoxFit.cover,
                          imageBuilder: (BuildContext context,
                              ImageProvider imageProvider) {
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.withAlpha(100),
                                ),
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                            );
                          },
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                          errorWidget: (context, url, error) => Container(
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                border: Border.all(
                                  color: Colors.grey.withAlpha(100),
                                )),
                            child: SvgPicture.asset(
                                'assets/icon/empty-image-product.svg',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover),
                          ),
                        ),
                );
              },
              itemCount: imageSize,

              pagination: const SwiperPagination(
                builder: SwiperPagination(
                  alignment: Alignment.bottomCenter,
                  builder: DotSwiperPaginationBuilder(
                    color: Color(0xffCDD3DB),
                    activeColor: Color(0xff38547C),
                  ),
                ),
              ),
              // control: const SwiperControl(color: Color(0xff929DAA)),
            ),
          );
  }

  ///Giao diện bloc của tab thông tin chung
  Widget _buildBLocUi({@required Widget child}) {
    return BlocProvider<ProductTemplateDetailsBloc>.value(
      value: _productTemplateDetailsBloc,
      child: BaseBlocListenerUi<ProductTemplateDetailsBloc,
          ProductTemplateDetailsState>(
        loadingState: ProductTemplateDetailsLoading,
        errorState: ProductTemplateDetailsLoadFailure,
        bloc: _productTemplateDetailsBloc,
        buildWhen: (ProductTemplateDetailsState last,
            ProductTemplateDetailsState current) {
          return current is! ProductTemplateDetailsActiveSetFailure ||
              current is! ProductTemplateDetailsDeleteSuccess ||
              current is! ProductTemplateDetailsDeleteFailure;
        },
        errorBuilder:
            (BuildContext context, ProductTemplateDetailsState state) {
          String error = S.current.canNotGetDataFromServer;

          if (state is ProductTemplateDetailsLoadFailure) {
            error = state.error ?? S.current.canNotGetDataFromServer;
          }
          return _buildError(error);
        },
        builder: (BuildContext context, ProductTemplateDetailsState state) {
          return child;
        },
      ),
    );
  }

  ///Xây dựng giao diện khi không thể lấy dữ liệu thông tin chung
  Widget _buildError(String error) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(height: 50 * (MediaQuery.of(context).size.height / 700)),
          LoadStatusWidget(
            statusName: S.current.loadDataError,
            content: error,
            statusIcon: SvgPicture.asset('assets/icon/error.svg',
                width: 170, height: 130),
            action: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: AppButton(
                onPressed: () {
                  _productTemplateDetailsBloc
                      .add(ProductTemplateDetailsRefresh());
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
                        S.current.refreshPage,
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

  ///Xây dụng giao diện header tab
  Widget _buildHeaderTab() {
    return Container(
      height: 55,
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.only(left: 10, top: 0, bottom: 0),
      child: ScrollTabViewHeader<String>(
        defaultIndex: 0,
        headerBuilder: (BuildContext context, bool isSelected, String item) {
          return Container(
            padding: const EdgeInsets.only(left: 5, right: 5),
            decoration: BoxDecoration(
                border: Border(
              bottom: BorderSide(
                width: 2,
                color:
                    isSelected ? const Color(0xff28A745) : Colors.transparent,
              ),
            )),
            child: Center(
              child: Text(
                item,
                style: TextStyle(
                  color: isSelected
                      ? const Color(0xff28A745)
                      : const Color(0xff929DAA),
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
        objects: tabs,
        onSelectedChange: (String value) {
          final int index = tabs.indexOf(value);
          if (_pageController.page != index) {
            _pageController.animateToPage(index,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut);

            if (value == S.current.stockMove && !_loadStockMove) {
              _loadStockMove = true;
              _productDetailsStockMoveBloc.add(ProductDetailsStockMoveStarted(
                  productTemplateId: widget.productTemplate?.id));
            } else if (value == S.current.inventory && !_loadInventoryProduct) {
              _loadInventoryProduct = true;
              _productDetailsInventoryProductBloc.add(
                  ProductDetailsInventoryProductStarted(
                      productTemplateId: widget.productTemplate?.id));
            } else if (value == S.current.variant && !_loadProductVariant) {
              _loadProductVariant = true;
              _productDetailsVariantBloc.add(ProductDetailsVariantStarted(
                  productTemplateId: widget.productTemplate?.id));
            }

            setState(() {});
          }
        },
      ),
    );
  }

  ///Hiện thị dialog xem ảnh lớn hơn
  Widget _buildDialogImage(
      BuildContext context, int index, List<ProductImage> productImages) {
    int imageSize = productImages.length;
    final bool hasImage =
        _productTemplate.imageUrl != null && _productTemplate.imageUrl != '';
    if (hasImage) {
      imageSize += 1;
    }

    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyText2,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: double.infinity,
                      height: 400 * (MediaQuery.of(context).size.height / 700),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 60,
                            left: 0,
                            right: 0,
                            child: index == 0 && hasImage
                                ? Container(
                                    width: double.infinity,
                                    height: 379 *
                                        (MediaQuery.of(context).size.height /
                                            700),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            _productTemplate.imageUrl),
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: double.infinity,
                                    height: 379 *
                                        (MediaQuery.of(context).size.height /
                                            700),
                                    color: Colors.white,
                                    child: _buildBigUrlImageView(hasImage
                                        ? productImages[index - 1].url
                                        : productImages[index].url)),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: ClipOval(
                              child: Container(
                                height: 50,
                                width: 50,
                                child: Material(
                                  color: Colors.grey.withOpacity(0.3),
                                  child: IconButton(
                                    iconSize: 30,
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            Text(
              '${index + 1}/$imageSize',
              style: const TextStyle(color: Colors.white, fontSize: 17),
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  Widget _buildBigUrlImageView(String imageUrl) {
    return imageUrl != null && imageUrl != ''
        ? CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            imageBuilder: (BuildContext context, ImageProvider imageProvider) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.withAlpha(100),
                  ),
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              );
            },
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircularProgressIndicator(value: downloadProgress.progress),
            errorWidget: (context, url, error) => Container(
              decoration: BoxDecoration(
                  color: Colors.grey,
                  border: Border.all(
                    color: Colors.grey.withAlpha(100),
                  )),
              child: SvgPicture.asset('assets/icon/empty-image-product.svg',
                  width: 50, height: 50, fit: BoxFit.cover),
            ),
          )
        : Container(
            decoration: BoxDecoration(
                color: Colors.grey,
                border: Border.all(
                  color: Colors.grey.withAlpha(100),
                )),
            child: SvgPicture.asset('assets/icon/empty-image-product.svg',
                width: 50, height: 50, fit: BoxFit.cover),
          );
  }
}

class _GeneralInfoTab extends StatelessWidget {
  const _GeneralInfoTab(
      {Key key,
      this.productTemplate,
      this.productTemplateDetailsBloc,
      this.userPermission})
      : super(key: key);
  final ProductTemplate productTemplate;
  final ProductTemplateDetailsBloc productTemplateDetailsBloc;
  final UserPermission userPermission;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProductCode(context),
        const SizedBox(height: 10),
        _buildProductType(context),
        const SizedBox(height: 10),
        _buildNumbers(context),
        const SizedBox(height: 10),
        _buildUom(context),
        const SizedBox(height: 10),
        _buildConfig(context),
        const SizedBox(height: 10),
        _buildAnotherInfo(context),
        const SizedBox(height: 23),
        // _buildAnotherInfo()
      ],
    );
  }

  ///Xây dựng giao diện hiện thị code và barcode
  Widget _buildProductCode(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (userPermission.permissionProductTemplateName)
            Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            productTemplate.name,
                            style: const TextStyle(
                                color: Color(0xff2C333A),
                                fontSize: 23,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      ClipOval(
                        child: Material(
                          color: Colors.transparent,
                          child: IconButton(
                            icon: SvgPicture.asset(
                              'assets/icon/tag_green.svg',
                              width: 16,
                              height: 16,
                            ),
                            onPressed: () async {
                              final List<Tag> selectedTags = [];
                              if (productTemplate.tags != null &&
                                  productTemplate.tags.isNotEmpty) {
                                selectedTags.addAll(productTemplate.tags);
                              }

                              List<Tag> result;
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return TagProductListPage(
                                      selectedItems: selectedTags,
                                      onSelected: (List<Tag> tags) {
                                        result = tags;
                                      },
                                    );
                                  },
                                ),
                              );

                              if (result != null) {
                                productTemplateDetailsBloc
                                    .add(ProductTemplateDetailsAssignTag(
                                  tags: result,
                                  productTemplate: productTemplate,
                                ));
                              }
                            },
                          ),
                        ),
                      )
                    ]))
          else
            InkWell(
              onTap: () {
                App.showToast(
                  title: S.current.warning,
                  context: context,
                  type: AlertDialogType.warning,
                  message: S.current.noPermissionToViewContent,
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 30,
                    padding: const EdgeInsets.only(left: 5),
                    child: const Icon(
                      Icons.warning,
                      color: Color(0xffF3A72E),
                      size: 25,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                      color: Colors.grey.shade200,
                      height: 1,
                      width: double.infinity),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          if (userPermission.permissionProductTemplateCode)
            _buildRowField(
                title: S.current.productCode,
                value: productTemplate.defaultCode)
          else
            _buildRowWarningPermission(
                title: S.current.productCode,
                onPressed: () {
                  App.showToast(
                    title: S.current.warning,
                    context: context,
                    type: AlertDialogType.warning,
                    message: S.current.noPermissionToViewContent,
                  );
                }),
          if (userPermission.productProductTemplateBarcode)
            _buildRowField(
                title: S.current.barcode,
                value: productTemplate.barcode,
                isUnderLine: false)
          else
            Column(
              children: [
                _buildRowWarningPermission(
                    underLine: false,
                    title: S.current.barcode,
                    onPressed: () {
                      App.showToast(
                        title: S.current.warning,
                        context: context,
                        type: AlertDialogType.warning,
                        message: S.current.noPermissionToViewContent,
                      );
                    }),
              ],
            ),
        ],
      ),
    );
  }

  ///Xây dựng giao diện hiện thị loại sản phẩm và nhóm sản phẩm
  Widget _buildProductType(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRowField(
              title: S.current.productType, value: productTemplate.showType),
          _buildRowField(
              title: S.current.productCategory,
              value: productTemplate.categName,
              isUnderLine: false),
        ],
      ),
    );
  }

  ///Xây dựng giao diện hiện thị thông tin là số
  Widget _buildNumbers(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildColumnField(
                    title: '${S.current.weight} (Kg)',
                    isUnderLine: false,
                    value: productTemplate.weight.toString(),
                    height: 10,
                    space: 5),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: userPermission != null &&
                        userPermission.permissionProductTemplatePrice
                    ? _buildColumnField(
                        height: 10,
                        space: 5,
                        isUnderLine: false,
                        title: S.current.salePrice,
                        value: productTemplate.listPrice
                            .toVietnameseCurrencyFormat(null,
                                Localizations.localeOf(context).languageCode),
                      )
                    : _buildColumnWarningPermission(
                        title: S.current.salePrice,
                        onPressed: () {
                          App.showToast(
                            title: S.current.warning,
                            context: context,
                            type: AlertDialogType.warning,
                            message: S.current.noPermissionToViewContent,
                          );
                        }),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                    color: Colors.grey.shade200,
                    height: 1,
                    width: double.infinity),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                    color: Colors.grey.shade200,
                    height: 1,
                    width: double.infinity),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: userPermission != null &&
                        userPermission.permissionProductTemplatePurchasePrice
                    ? _buildColumnField(
                        title: S.current.purchasePrice,
                        isUnderLine: false,
                        value: productTemplate.purchasePrice
                            .toVietnameseCurrencyFormat(null,
                                Localizations.localeOf(context).languageCode),
                        height: 10,
                        space: 5)
                    : _buildColumnWarningPermission(
                        title: S.current.purchasePrice,
                        onPressed: () {
                          App.showToast(
                            title: S.current.warning,
                            context: context,
                            type: AlertDialogType.warning,
                            message: S.current.noPermissionToViewContent,
                          );
                        }),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: userPermission != null &&
                        userPermission.permissionProductTemplateStandardPrice
                    ? _buildColumnField(
                        title: S.current.standardPrice,
                        isUnderLine: false,
                        value: productTemplate.standardPrice
                            .toVietnameseCurrencyFormat(null,
                                Localizations.localeOf(context).languageCode),
                        height: 10,
                        space: 5)
                    : _buildColumnWarningPermission(
                        title: S.current.standardPrice,
                        onPressed: () {
                          App.showToast(
                            title: S.current.warning,
                            context: context,
                            type: AlertDialogType.warning,
                            message: S.current.noPermissionToViewContent,
                          );
                        }),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                    color: Colors.grey.shade200,
                    height: 1,
                    width: double.infinity),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                    color: Colors.grey.shade200,
                    height: 1,
                    width: double.infinity),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildColumnField(
                  title: S.current.discountSale,
                  isUnderLine: false,
                  value: productTemplate.discountSale
                      .toVietnameseCurrencyFormat(
                          null, Localizations.localeOf(context).languageCode),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildColumnField(
                    title: S.current.discountPurchase,
                    value: productTemplate.discountPurchase
                        .toVietnameseCurrencyFormat(
                            null, Localizations.localeOf(context).languageCode),
                    isUnderLine: false),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRowWarningPermission(
      {String title, VoidCallback onPressed, bool underLine = true}) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          const SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Text(title,
                    style: const TextStyle(
                        color: Color(0xff929DAA), fontSize: 15)),
              ),
              const SizedBox(width: 10),
              Container(
                height: 30,
                padding: const EdgeInsets.only(left: 5),
                child: const Icon(
                  Icons.warning,
                  color: Color(0xffF3A72E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          if (underLine)
            Container(
                color: Colors.grey.shade200, height: 1, width: double.infinity)
          else
            const SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget _buildColumnWarningPermission({String title, VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(color: Color(0xff929DAA), fontSize: 15)),
          Container(
            height: 30,
            padding: const EdgeInsets.only(left: 0),
            child: const Icon(
              Icons.warning,
              color: Color(0xffF3A72E),
            ),
          ),
          const SizedBox(height: 5)
        ],
      ),
    );
  }

  ///Xây dựng giao diện đơn vị
  Widget _buildUom(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: _buildColumnField(
                      title: S.current.defaultUnit,
                      value: productTemplate.uOMName)),
              const SizedBox(width: 10),
              Expanded(
                  child: _buildColumnField(
                      title: S.current.purchaseUnit,
                      value: productTemplate.uOMPOName)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Text(
                S.current.productActive,
                style: const TextStyle(color: Color(0xff929DAA), fontSize: 15),
              )),
              const SizedBox(width: 10),
              Expanded(
                  child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                        color: productTemplate.active
                            ? const Color(0xff28A745)
                            : const Color(0xff929DAA),
                        shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    productTemplate.active ? S.current.using : S.current.expire,
                    style: TextStyle(
                        color: productTemplate.active
                            ? const Color(0xff28A745)
                            : const Color(0xff929DAA),
                        fontSize: 17),
                  ),
                ],
              )),
            ],
          )
        ],
      ),
    );
  }

  ///Xây dựng giao diện cấu hình sản phẩm
  Widget _buildConfig(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.current.productConfiguration.toUpperCase(),
            style: const TextStyle(color: Color(0xff28A745), fontSize: 17),
          ),
          const SizedBox(height: 10),
          Wrap(
            children: [
              _buildCheckRow(
                  S.current.allowSale, context, productTemplate.saleOK),
              _buildCheckRow(
                  S.current.allowPurchase, context, productTemplate.purchaseOK),
              _buildCheckRow(
                  S.current.isCombo, context, productTemplate.isCombo),
              _buildCheckRow(S.current.availableInPOS, context,
                  productTemplate.availableInPOS),
              _buildCheckRow(S.current.allowSaleInAnotherCompany, context,
                  productTemplate.enableAll),
            ],
          ),
        ],
      ),
    );
  }

  ///Xây dựng giao diện thông tin khác
  Widget _buildAnotherInfo(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 16),
      child: CustomExpandWidget(
        expanseWhenClick: true,
        update: false,
        expanse: false,
        iconSpace: 10,
        header: Text(
          S.current.otherInformation,
          style: const TextStyle(color: Color(0xff2C333A), fontSize: 19),
        ),
        iconBuilder: (BuildContext context, bool expanse) {
          return RotatedBox(
            quarterTurns: expanse ? 3 : 0,
            child: const Icon(
              Icons.keyboard_arrow_down,
              color: Color.fromARGB(255, 167, 178, 191),
            ),
          );
        },
        body: Padding(
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRowField(
                  title: S.current.distributor,
                  value: productTemplate.distributorName),
              _buildRowField(
                  title: S.current.importer,
                  value: productTemplate.importerName),
              _buildRowField(
                  title: S.current.producer,
                  value: productTemplate.producerName),
              _buildRowField(
                  title: S.current.origin,
                  value: productTemplate.originCountryName),
              _buildRowField(
                  title: S.current.element, value: productTemplate.element),
              _buildRowField(
                  title: S.current.technicalSpecifications,
                  value: productTemplate.specifications),
              _buildRowField(
                  title: S.current.warningInformation,
                  value: productTemplate.infoWarning,
                  isUnderLine: false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckRow(String name, BuildContext context, bool value) {
    assert(name != null);
    assert(value != null);
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 16,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            FontAwesomeIcons.checkCircle,
            color: value ? const Color(0xff28A745) : const Color(0xff929DAA),
            size: 23,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
            ),
          ),
        ],
      ),
    );
  }

  ///Xây dựng giao diện trường dữ liệu có title và value theo chiều dọc
  Widget _buildColumnField(
      {@required String title,
      @required String value,
      double height,
      double space,
      bool isUnderLine = true}) {
    assert(title != null);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(color: Color(0xff929DAA), fontSize: 15)),
        SizedBox(height: space ?? 0),
        Text(value ?? '---',
            style: const TextStyle(color: Color(0xff2C333A), fontSize: 17)),
        SizedBox(height: height ?? 10),
        if (isUnderLine)
          Container(
              color: Colors.grey.shade200, height: 1, width: double.infinity),
        if (isUnderLine) const SizedBox(height: 10),
      ],
    );
  }

  ///Xây dựng giao diện trường dữ liệu có title và value theo chiều ngang
  Widget _buildRowField(
      {@required String title,
      @required String value,
      bool isUnderLine = true}) {
    assert(title != null);
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Text(title,
                    style: const TextStyle(
                        color: Color(0xff929DAA), fontSize: 17))),
            Expanded(
                child: Text(value ?? '---',
                    style: const TextStyle(
                        color: Color(0xff2C333A), fontSize: 17))),
          ],
        ),
        const SizedBox(height: 10),
        if (isUnderLine)
          Container(
              color: Colors.grey.shade200, height: 1, width: double.infinity),
        if (isUnderLine) const SizedBox(height: 10),
      ],
    );
  }
}
