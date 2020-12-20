import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/feature_group/category/product/bloc/product_variant_details_bloc.dart';
import 'package:tpos_mobile/feature_group/category/product/bloc/product_variant_details_event.dart';
import 'package:tpos_mobile/feature_group/category/product/bloc/product_variant_details_state.dart';
import 'package:tpos_mobile/feature_group/category/product/ui/product_variant_details_add_edit_page.dart';
import 'package:tpos_mobile/feature_group/category/product_template/ui/details/product_template_details_page.dart';
import 'package:tpos_mobile/widgets/bloc_widget/base_bloc_listener_ui.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/custom_snack_bar.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/load_status.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

///Màn hình chi tiết biến thể
///[productVariant] biến thể muốn xem chi tiết
///[isFromProductTemplate] nếu [true] thì sẽ back về trang trước khi chuyển sang chi tiết sản phẩm
class ProductVariantDetailsPage extends StatefulWidget {
  const ProductVariantDetailsPage({Key key, this.productVariant, this.isFromProductTemplate = false}) : super(key: key);

  @override
  _ProductVariantDetailsPageState createState() => _ProductVariantDetailsPageState();
  final Product productVariant;
  final bool isFromProductTemplate;
}

class _ProductVariantDetailsPageState extends State<ProductVariantDetailsPage> {
  ProductVariantDetailsBloc _productVariantDetailsBloc;

  Map<ProductVariantAction, String> productVariantActionMap;
  Product _productVariant;
  bool _change = false;

  @override
  void initState() {
    _productVariantDetailsBloc = ProductVariantDetailsBloc();
    _productVariantDetailsBloc.add(ProductVariantDetailsStarted(productId: widget.productVariant?.id));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (widget.productVariant.active) {
      productVariantActionMap = <ProductVariantAction, String>{
        // ProductVariantAction.PRINT_BARCODE: 'In tem mã',
        ProductVariantAction.STOP_ACTIVE: S.of(context).disableActive,
        ProductVariantAction.DELETE: S.of(context).deleteProduct
      };
    } else {
      productVariantActionMap = <ProductVariantAction, String>{
        // ProductVariantAction.PRINT_BARCODE: 'In tem mã',
        ProductVariantAction.ACTIVE: S.of(context).enableActive,
        ProductVariantAction.DELETE: S.of(context).deleteProduct
      };
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _productVariantDetailsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _back();
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xffEBEDEF),
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  void _back() {
    if (_change) {
      Navigator.pop(context, _productVariant);
    } else {
      Navigator.pop(context);
    }
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        S.of(context).variantDetails,
        style: const TextStyle(color: Colors.white, fontSize: 21),
      ),
      leading: ClipOval(
        child: Container(
          height: 50,
          width: 50,
          child: Material(
            color: Colors.transparent,
            child: IconButton(
              iconSize: 30,
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () async {
                _back();
              },
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
            icon: const Icon(Icons.edit_sharp, color: Colors.white, size: 25),
            onPressed: () async {
              final Product productVariant = await Navigator.push<Product>(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductVariantAddEditPage(
                    productVariantId: widget.productVariant?.id,
                  ),
                ),
              );

              if (productVariant != null) {
                _change = true;
                _productVariantDetailsBloc.add(ProductVariantDetailsStarted(productId: widget.productVariant?.id));
              }
            }),
        PopupMenuButton<ProductVariantAction>(
            onSelected: (ProductVariantAction value) async {
              switch (value) {
                case ProductVariantAction.STOP_ACTIVE:
                  if (_productVariant != null) {
                    _productVariantDetailsBloc.add(ProductVariantDetailsActiveSet());
                  } else {
                    App.showDefaultDialog(
                        title: S.of(context).error,
                        context: context,
                        type: AlertDialogType.error,
                        content: S.of(context).canNotGetData);
                  }
                  break;
                case ProductVariantAction.DELETE:
                  if (_productVariant != null) {
                    final bool result = await App.showConfirm(
                        title: S.of(context).confirmDelete, content: S.of(context).productDeleteConfirm);

                    if (result != null && result) {
                      _productVariantDetailsBloc.add(ProductVariantDetailsDelete());
                    }
                  } else {
                    App.showDefaultDialog(
                        title: S.of(context).error,
                        context: context,
                        type: AlertDialogType.error,
                        content: S.of(context).canNotGetData);
                  }
                  break;
                case ProductVariantAction.ACTIVE:
                  if (_productVariant != null) {
                    _productVariantDetailsBloc.add(ProductVariantDetailsActiveSet());
                  } else {
                    App.showDefaultDialog(
                        title: S.of(context).error,
                        context: context,
                        type: AlertDialogType.error,
                        content: S.of(context).canNotGetData);
                  }
                  break;
              }
            },
            itemBuilder: (BuildContext context) => productVariantActionMap.keys
                .map((ProductVariantAction action) => PopupMenuItem<ProductVariantAction>(
                      value: action,
                      child: Text(
                        productVariantActionMap[action],
                        style: const TextStyle(color: Color(0xff2C333A), fontSize: 15),
                      ),
                    ))
                .toList())
      ],
    );
  }

  Widget _buildBody() {
    return BaseBlocListenerUi<ProductVariantDetailsBloc, ProductVariantDetailsState>(
      busyState: ProductVariantDetailsBusy,
      loadingState: ProductVariantDetailsLoading,
      errorState: ProductVariantDetailsLoadFailure,
      bloc: _productVariantDetailsBloc,
      errorBuilder: (BuildContext context, ProductVariantDetailsState state) {
        String error = S.of(context).loadDataError;
        if (state is ProductVariantDetailsLoadFailure) {
          error = state.error ?? S.of(context).loadDataError;
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50 * (MediaQuery.of(context).size.height / 700)),
              LoadStatusWidget(
                statusName: S.of(context).loadDataError,
                content: error,
                statusIcon: SvgPicture.asset('assets/icon/error.svg', width: 170, height: 130),
                action: AppButton(
                  onPressed: () {
                    _productVariantDetailsBloc.add(ProductVariantDetailsStarted(productId: widget.productVariant?.id));
                  },
                  width: null,
                  height: null,
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 10),
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
      listener: (BuildContext context, ProductVariantDetailsState state) {
        if (state is ProductVariantDetailsSetActiveSuccess) {
          _change = true;
          final Widget snackBar = customSnackBar(
              message: state.active ? S.of(context).enableActiveSuccessful : S.of(context).disableActiveSuccessful,
              context: context);
          Scaffold.of(context).showSnackBar(snackBar);

          if (state.active) {
            productVariantActionMap = <ProductVariantAction, String>{
              // ProductVariantAction.PRINT_BARCODE: 'In tem mã',
              ProductVariantAction.STOP_ACTIVE: S.of(context).disableActive,
              ProductVariantAction.DELETE: S.of(context).deleteProduct
            };
          } else {
            Navigator.of(context).pop(_productVariant);
            productVariantActionMap = <ProductVariantAction, String>{
              // ProductVariantAction.PRINT_BARCODE: 'In tem mã',
              ProductVariantAction.ACTIVE: S.of(context).enableActive,
              ProductVariantAction.DELETE: S.of(context).deleteProduct
            };
          }

          setState(() {});
        } else if (state is ProductVariantDetailsDeleteSuccess) {
          final Widget snackBar = customSnackBar(message: S.of(context).deleteSuccessful, context: context);
          Scaffold.of(context).showSnackBar(snackBar);
          Navigator.of(context).pop(_productVariant);
        } else if (state is ProductVariantDetailsDeleteFailure) {
          App.showDefaultDialog(
              title: S.of(context).error, context: context, type: AlertDialogType.error, content: state.error);
        } else if (state is ProductVariantDetailsSetActiveFailure) {
          App.showDefaultDialog(
              title: S.of(context).error, context: context, type: AlertDialogType.error, content: state.error);
        }
      },
      buildWhen: (ProductVariantDetailsState last, ProductVariantDetailsState current) {
        return current is! ProductVariantDetailsSetActiveFailure ||
            current is! ProductVariantDetailsDeleteSuccess ||
            current is! ProductVariantDetailsDeleteFailure;
      },
      builder: (BuildContext context, ProductVariantDetailsState state) {
        if (state is ProductVariantDetailsLoadSuccess) {
          _productVariant = state.product;
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              _buildImage(),
              _buildGeneralInfo(),
              const SizedBox(height: 10),
              _buildNumberValue(),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImage() {
    return Container(
      height: 200,
      width: double.infinity,
      child: _productVariant.imageUrl != null && _productVariant.imageUrl != ''
          ? CachedNetworkImage(
              imageUrl: _productVariant.imageUrl,
              fit: BoxFit.cover,
              imageBuilder: (BuildContext context, ImageProvider imageProvider) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.withAlpha(30),
                    ),
                    image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
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
                child:
                    SvgPicture.asset('assets/icon/empty-image-product.svg', width: 50, height: 50, fit: BoxFit.cover),
              ),
            )
          : const SizedBox(),
    );
  }

  Widget _buildGeneralInfo() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icon/product_name.svg',
                      width: 25,
                      height: 25,
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        _productVariant.nameGet.replaceAll('[${_productVariant.defaultCode}]', '').trim(),
                        style: const TextStyle(color: Color(0xff2C333A), fontSize: 21),
                      ),
                    ),
                  ],
                ),
              ),
              ClipOval(
                child: Container(
                  height: 40,
                  width: 40,
                  child: Material(
                    color: Colors.transparent,
                    child: IconButton(
                      iconSize: 25,
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: Color(0xff28A745),
                      ),
                      onPressed: () async {
                        if (widget.isFromProductTemplate) {
                          _back();
                        } else {
                          final bool isChange = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ProductTemplateDetailsPage(
                                    productTemplate: ProductTemplate(id: _productVariant.productTmplId));
                              },
                            ),
                          );

                          if (isChange != null && isChange) {
                            _productVariantDetailsBloc
                                .add(ProductVariantDetailsStarted(productId: widget.productVariant?.id));
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildAttributeValues(),
          _buildRowField(title: S.of(context).barcode, value: _productVariant?.barcode),
          _buildRowField(title: S.of(context).variantCode, value: _productVariant?.defaultCode, isUnderLine: false),
        ],
      ),
    );
  }

  Widget _buildNumberValue() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 10),
      child: Column(
        children: [
          _buildRowField(
              title: S.of(context).variantPrice, value: vietnameseCurrencyFormat(_productVariant?.priceVariant)),
          _buildRowField(
              title: S.of(context).standardPrice, value: vietnameseCurrencyFormat(_productVariant?.standardPrice)),
          _buildRowField(
              title: '${S.of(context).weight} (Kg)', value: vietnameseCurrencyFormat(_productVariant?.weight)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Text(
                S.of(context).productActive,
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
                        color: _productVariant.active ? const Color(0xff28A745) : const Color(0xff929DAA),
                        shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    _productVariant.active ? S.of(context).using : S.of(context).expire,
                    style: TextStyle(
                        color: _productVariant.active ? const Color(0xff28A745) : const Color(0xff929DAA),
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

  Widget _buildAttributeValues() {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Text(S.of(context).attribute, style: const TextStyle(color: Color(0xff929DAA), fontSize: 15))),
              const SizedBox(width: 10),
              Expanded(
                child: Wrap(
                  runSpacing: 0,
                  spacing: 0,
                  runAlignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: _productVariant.attributeValues
                      .map((ProductAttributeValue value) => Container(
                            padding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 5),
                            margin: const EdgeInsets.only(top: 5, bottom: 5, left: 2),
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(13)), color: Color(0xffF0F1F3)),
                            child: Text(
                              value.nameGet,
                              style: const TextStyle(color: Color(0xff2C333A), fontSize: 13),
                            ),
                          ))
                      .toList(),
                ),
              )
              // ,
              // Expanded(
              //   child: Container(
              //     height: 40,
              //     child: ListView.separated(
              //       scrollDirection: Axis.horizontal,
              //       itemBuilder: (BuildContext context, int index) {
              //         return Container(
              //           padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
              //           margin: const EdgeInsets.only(top: 5, bottom: 5),
              //           decoration: const BoxDecoration(
              //               borderRadius: BorderRadius.all(Radius.circular(13)), color: Color(0xffF0F1F3)),
              //           child: Text(
              //             _productVariant.attributeValues[0].nameGet,
              //             style: const TextStyle(color: Color(0xff2C333A), fontSize: 13),
              //           ),
              //         );
              //       },
              //       separatorBuilder: (BuildContext context, int index) {
              //         return const SizedBox(width: 10);
              //       },
              //       itemCount: 5,
              //     ),
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 10),
          Container(color: Colors.grey.shade200, height: 1, width: double.infinity),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  ///Xây dựng giao diện trường dữ liệu có title và value theo chiều ngang
  Widget _buildRowField({@required String title, @required String value, bool isUnderLine = true}) {
    assert(title != null);
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Text(title, style: const TextStyle(color: Color(0xff929DAA), fontSize: 15
            ))),
            const SizedBox(width: 10),
            Expanded(child: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(value ?? '---', style: const TextStyle(color: Color(0xff2C333A), fontSize: 17)),
            )),
          ],
        ),
        const SizedBox(height: 10),
        if (isUnderLine) Container(color: Colors.grey.shade200, height: 1, width: double.infinity),
        if (isUnderLine) const SizedBox(height: 10),
      ],
    );
  }
}
