import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/feature_group/category/product/bloc/add_edit/product_variant_add_edit_bloc.dart';
import 'package:tpos_mobile/feature_group/category/product/bloc/add_edit/product_variant_add_edit_event.dart';
import 'package:tpos_mobile/feature_group/category/product/bloc/add_edit/product_variant_add_edit_state.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/ui/product_attribute_line_page.dart';
import 'package:tpos_mobile/feature_group/category/product_category/ui/product_category_list_page.dart';
import 'package:tpos_mobile/feature_group/category/product_uom/ui/product_uoms_page.dart';
import 'package:tpos_mobile/helpers/barcode_scan.dart';
import 'package:tpos_mobile/widgets/bloc_widget/base_bloc_listener_ui.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/custom_snack_bar.dart';
import 'package:tpos_mobile/widgets/custom_switch.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/load_status.dart';
import 'package:tpos_mobile/widgets/money_format_controller.dart';
import 'package:tpos_mobile/widgets/reg_ex_input_formatter.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

///Xây dựng giao diện sửa thông tin sản phẩm [Product]
class ProductVariantAddEditPage extends StatefulWidget {
  const ProductVariantAddEditPage({Key key, this.productVariantId}) : super(key: key);

  final int productVariantId;

  @override
  _ProductVariantAddEditPageState createState() => _ProductVariantAddEditPageState();
}

class _ProductVariantAddEditPageState extends State<ProductVariantAddEditPage> {
  ProductVariantAddEditBloc _productVariantAddEditBloc;
  Product _productVariant;
  final TextEditingController _productNameController = TextEditingController();
  final FocusNode _productNameFocusNode = FocusNode();
  final FocusNode _variantPriceFocusNode = FocusNode();

  final FocusNode _standardPriceFocusNode = FocusNode();

  final TextEditingController _productCodeController = TextEditingController();
  final TextEditingController _barCodeController = TextEditingController();

  final CustomMoneyMaskedTextController _variantPriceController = CustomMoneyMaskedTextController(
      minValue: 0, precision: 0, thousandSeparator: '.', decimalSeparator: '', defaultValue: 0);

  final CustomMoneyMaskedTextController _standardPriceController =
      CustomMoneyMaskedTextController(minValue: 0, precision: 0, thousandSeparator: '.', decimalSeparator: '');

  bool _change = false;

  final ImagePicker picker = ImagePicker();

  Map<String, String> _mapTypes;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isInteger(String s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

  @override
  void initState() {
    super.initState();
    _productVariantAddEditBloc = ProductVariantAddEditBloc();
    _productVariantAddEditBloc.add(ProductVariantAddEditStarted(productVariantId: widget.productVariantId));
  }

  @override
  void didChangeDependencies() {
    _mapTypes = <String, String>{
      'product': S.of(context).canBeStored,
      'consu': S.of(context).canBeConsumed,
      'service': S.of(context).service,
    };
    super.didChangeDependencies();

  }

  @override
  void dispose() {
    _variantPriceController.dispose();
    _barCodeController.dispose();
    _productCodeController.dispose();
    _productNameController.dispose();
    _standardPriceController.dispose();

    _productNameFocusNode.dispose();
    _variantPriceFocusNode.dispose();
    _standardPriceFocusNode.dispose();
    _productVariantAddEditBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _back();
        return false;
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: const Color(0xffebedef),
          appBar: _buildAppbar(),
          body: _buildBody(),
        ),
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

  Widget _buildAppbar() {
    return AppBar(
      leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            _back();
          }),
      title: Text(
        widget.productVariantId != null
            ? S.of(context).editNormalParam(S.of(context).variant.toLowerCase())
            : S.of(context).addParam(S.of(context).variant.toLowerCase()),
        style: const TextStyle(color: Colors.white, fontSize: 21),
      ),
      actions: [
        IconButton(
            icon: const Icon(Icons.check, color: Colors.white, size: 30),
            onPressed: () {
              _save();
            }),
      ],
    );
  }

  void _save() {
    if (_productVariant != null) {
      _productVariant.priceVariant = _variantPriceController.numberValue;
      _productVariant.lstPrice = _variantPriceController.numberValue;
      _productVariant.standardPrice = _standardPriceController.numberValue;
      _productVariant.name = _productNameController.text;
      _productVariant.defaultCode = _productCodeController.text;
      _productVariant.barcode = _productVariant.barcode == '' ? null : _barCodeController.text;
      _productVariant.priceVariant = _variantPriceController.numberValue;
      _productVariant.lstPrice = _variantPriceController.numberValue;
      _productVariantAddEditBloc.add(ProductVariantAddEditSaved(productVariant: _productVariant));
    } else {
      App.showDefaultDialog(
          title: S.of(context).error,
          context: context,
          type: AlertDialogType.error,
          content: S.of(context).canNotGetData);
    }
  }

  Widget _buildBody() {
    final bool isOpenKeyBoard = MediaQuery.of(context).viewInsets.bottom != 0;
    return BaseBlocListenerUi<ProductVariantAddEditBloc, ProductVariantAddEditState>(
      loadingState: ProductVariantAddEditLoading,
      bloc: _productVariantAddEditBloc,
      busyState: ProductVariantAddEditBusy,
      errorState: ProductVariantAddEditLoadFailure,
      // buildWhen: (ProductVariantAddEditState last, ProductVariantAddEditState current) {
      //   return !(current is ProductVariantAddEditSaveError || current is ProductVariantAddEditUploadImageError);
      // },
      listener: (BuildContext context, ProductVariantAddEditState state) {
        if (state is ProductVariantAddEditSaveSuccess) {
          // _dialogService.showToast(message: 'Đã lưu sản phẩm thành công');
          Navigator.pop(context, _productVariant);
        } else if (state is ProductVariantAddEditSaveFailure) {
          App.showDefaultDialog(
              title: S.of(context).error, context: context, type: AlertDialogType.error, content: state.error);
        } else if (state is ProductVariantAddEditLoadSuccess) {
          _productVariant = state.productVariant;
          _productNameController.text = _productVariant.name ?? '';
          _productCodeController.text = _productVariant.defaultCode ?? '';
          _barCodeController.text = _productVariant.barcode ?? '';
          _variantPriceController.text = _productVariant.priceVariant?.toStringAsFixed(0);

          _standardPriceController.text = _productVariant.standardPrice?.toStringAsFixed(0);
        }
        // else if (state is ProductVariantAddEditNameError) {
        //   App.showDefaultDialog(
        //       title: S.of(context).error, context: context, type: AlertDialogType.error, content: state.error);
        // }
      },
      errorBuilder: (BuildContext context, ProductVariantAddEditState state) {
        String error = S.of(context).canNotGetDataFromServer;
        if (state is ProductVariantAddEditLoadFailure) {
          error = state.error ?? S.of(context).canNotGetDataFromServer;
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
                    _productVariantAddEditBloc
                        .add(ProductVariantAddEditStarted(productVariantId: widget.productVariantId));
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
      builder: (BuildContext context, ProductVariantAddEditState state) {
        bool errorName = false;
        // if (state is ProductVariantAddEditNameError) {
        //   errorName = true;
        // }

        if (state is ProductVariantAddEditLoadSuccess) {
          _productVariant = state.productVariant;
        }

        return Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _buildImages(),
                    const SizedBox(height: 10),
                    _buildNameGroup(),
                    const SizedBox(height: 10),
                    _buildCodeGroup(),
                    const SizedBox(height: 10),
                    _buildTypeGroup(),
                    const SizedBox(height: 10),
                    _buildInputNumberGroup(),
                    const SizedBox(height: 10),
                    _buildUomGroup(),
                    const SizedBox(height: 10),
                    _buildControlInvoice(),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
              if (!isOpenKeyBoard)
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: AppButton(
                    onPressed: () {
                      _save();
                    },
                    borderRadius: 8,
                    width: double.infinity,
                    height: 48,
                    background: const Color(0xff28A745),
                    child: Text(
                      S.of(context).save,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInsertImageButton() {
    return DottedBorder(
      borderType: BorderType.RRect,
      dashPattern: const <double>[4, 4],
      color: const Color(0xFFCACACA),
      radius: const Radius.circular(10),
      strokeWidth: 2,
      child: AppButton(
        width: 100,
        height: 100,
        decoration: const BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.all(Radius.circular(12))),
        onPressed: () async {
          try {
            final PickedFile pickedFile = await picker.getImage(source: ImageSource.gallery);
            if (pickedFile != null) {
              _productVariantAddEditBloc.add(ProductVariantAddEditUploadImage(file: File(pickedFile.path)));
            }
          } catch (e) {}
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/icon/insert_image.svg'),
            Text(
              S.of(context).addParam(S.of(context).image.toLowerCase()),
              style: const TextStyle(color: Color(0xff929DAA), fontSize: 12),
            )
          ],
        ),
      ),
    );
  }

  ///Xây dựng giao diện danh sách hình ảnh
  Widget _buildImages() {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Container(
          width: double.infinity,
          child: Wrap(spacing: 10, runSpacing: 10, children: <Widget>[
            if (_productVariant.id != 0 && _productVariant.imageUrl != null && _productVariant.imageUrl != '')
              InkWell(
                child: _buildImage(),
                onTap: () async {
                  try {
                    final PickedFile pickedFile = await picker.getImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      _productVariantAddEditBloc.add(ProductVariantAddEditUploadImage(file: File(pickedFile.path)));
                    }
                    // ignore: empty_catches
                  } catch (e) {}
                },
              )
            else if (_productVariant.image != null &&
                _productVariant.image != '' &&
                (_productVariant.imageUrl == null || _productVariant.imageUrl == ''))
              InkWell(
                child: _buildSelectImage(),
                onTap: () async {
                  try {
                    final PickedFile pickedFile = await picker.getImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      _productVariantAddEditBloc.add(ProductVariantAddEditUploadImage(file: File(pickedFile.path)));
                    }
                    // ignore: empty_catches
                  } catch (e) {}
                },
              )
            else
              InkWell(
                child: _buildDefaultImage(),
                onTap: () async {
                  try {
                    final PickedFile pickedFile = await picker.getImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      _productVariantAddEditBloc.add(ProductVariantAddEditUploadImage(file: File(pickedFile.path)));
                    }
                    // ignore: empty_catches
                  } catch (e) {}
                },
              )
          ]
              // +
              // _productVariant.images
              //     .map((ProductImage productImage) => _buildImage(productImage, () {
              //           setState(() {});
              //         }))
              //     .toList() +
              // [_buildInsertImageButton()],
              ),
        );
      },
    );
  }

  ///Xây dựng giao diện hiện thị hình hiện tại của biến thể
  Widget _buildImage() {
    return Container(
      width: 100,
      height: 100,
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: _productVariant.imageUrl,
            fit: BoxFit.cover,
            imageBuilder: (BuildContext context, ImageProvider imageProvider) {
              return Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    color: Colors.grey.withAlpha(100),
                  ),
                  image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              );
            },
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircularProgressIndicator(value: downloadProgress.progress),
            errorWidget: (context, url, error) => Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Colors.grey,
                  border: Border.all(
                    color: Colors.grey.withAlpha(100),
                  )),
              child: SvgPicture.asset('assets/icon/empty-image-product.svg', fit: BoxFit.cover),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: ClipOval(
              child: Container(
                width: 30,
                height: 30,
                child: Material(
                  color: Colors.transparent,
                  child: IconButton(
                      iconSize: 25,
                      padding: const EdgeInsets.all(0),
                      icon: Icon(
                        Icons.cancel,
                        color: const Color(0xff22313F).withOpacity(0.5),
                      ),
                      onPressed: () async {
                        final bool result = await App.showConfirm(
                            title: S.of(context).confirmDelete, content: S.of(context).deleteImageInquiry);

                        if (result != null && result) {
                          _productVariant.image = null;
                          _productVariant.imageUrl = null;
                          setState(() {});
                        }
                      }),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  ///Hiện thị giao diện khi chọn ảnh từ local
  Widget _buildSelectImage() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: Colors.grey.withAlpha(100),
        ),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: MemoryImage(_productVariant.imageBytes),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: ClipOval(
              child: Container(
                width: 30,
                height: 30,
                child: Material(
                  color: Colors.transparent,
                  child: IconButton(
                      iconSize: 25,
                      padding: const EdgeInsets.all(0),
                      icon: Icon(
                        Icons.cancel,
                        color: const Color(0xff22313F).withOpacity(0.5),
                      ),
                      onPressed: () async {
                        final bool result = await App.showConfirm(
                            title: S.of(context).confirmDelete, content: S.of(context).deleteImageInquiry);

                        if (result != null && result) {
                          _productVariant.image = null;
                          _productVariant.imageUrl = null;
                          setState(() {});
                        }
                      }),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  ///Hiện thị hình ảnh mặc định khi không có ảnh
  Widget _buildDefaultImage() {
    return Container(
      width: 100,
      height: 100,
      child: CachedNetworkImage(
        imageUrl: _productVariant.defaultImageUrl,
        fit: BoxFit.cover,
        imageBuilder: (BuildContext context, ImageProvider imageProvider) {
          return Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(
                color: Colors.grey.withAlpha(100),
              ),
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          );
        },
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(value: downloadProgress.progress),
        errorWidget: (context, url, error) => Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Colors.grey,
              border: Border.all(
                color: Colors.grey.withAlpha(100),
              )),
          child: SvgPicture.asset('assets/icon/empty-image-product.svg', fit: BoxFit.cover),
        ),
      ),
    );
  }

  ///Xây dựng giao diện nhóm các widget với nền trắng bo tròn 4 cạnh
  Widget _buildGroup(
      {Widget child, EdgeInsets padding = const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 20)}) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: Colors.white,
      ),
      padding: padding,
      child: child,
    );
  }

  ///Xây dựng giao diện nhập Tên sản phẩm, Mã sản phẩm, Mã vạch
  Widget _buildNameGroup() {
    return _buildGroup(
      child: Column(
        children: [
          StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return _buildTextField(
                  controller: _productNameController,
                  hint: S.of(context).enterParam(S.of(context).variantName.toLowerCase()),
                  contentPadding: const EdgeInsets.only(right: 55),
                  title: S.of(context).variantName,
                  isRequire: true,
                  onTextChanged: (String value) {
                    _productVariant.name = _productNameController.text;
                  });
            },
          ),
          const SizedBox(height: 10),
          _buildAttributeValues()
        ],
      ),
    );
  }

  Widget _buildCodeGroup() {
    return _buildGroup(
      child: Column(
        children: [
          StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return _buildTextField(
                  controller: _barCodeController,
                  hint: S.of(context).enterParam(S.of(context).barcode.toLowerCase()),
                  title: S.of(context).barcode,
                  contentPadding: const EdgeInsets.only(right: 55),
                  suffix: AppButton(
                    width: 40,
                    height: 40,
                    background: Colors.transparent,
                    // padding: const EdgeInsets.all(0),
                    child:
                        Image.asset("images/scan_barcode.png", width: 28, height: 24, color: const Color(0xff858F9B)),
                    onPressed: () async {
                      // final ScanBarcodeResult result = await scanBarcode();

                      final result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return BarcodeScan();
                      }));
                      if (result != null) {
                        _barCodeController.text = result;
                      }
                    },
                  ),
                  onTextChanged: (String value) {
                    _productVariant.barcode = _barCodeController.text;
                  });
            },
          ),
          const SizedBox(height: 10),
          _buildTextField(
              controller: _productCodeController,
              hint: S.of(context).enterParam(S.of(context).variantCode.toLowerCase()),
              title: S.of(context).variantCode,
              contentPadding: const EdgeInsets.only(right: 55),
              // suffix: GestureDetector(
              //   onTap: () {
              //     final dynamic tooltip = _toolTipKey.currentState;
              //     tooltip.ensureTooltipVisible();
              //   },
              //   child: Tooltip(
              //     key: _toolTipKey,
              //     message: S.of(context).emptyAutoGenerate,
              //     decoration:
              //         const BoxDecoration(color: Colors.green, borderRadius: BorderRadius.all(Radius.circular(8))),
              //     child: Container(
              //       width: 40,
              //       height: 40,
              //       child: const Icon(
              //         Icons.info_outline,
              //         color: Color(0xff28A745),
              //       ),
              //     ),
              //   ),
              // ),
              onTextChanged: (String value) {
                _productVariant.defaultCode = _productCodeController.text;
              }),
        ],
      ),
    );
  }

  double getTextLength(String text, TextStyle textStyle) {
    const BoxConstraints constraints = BoxConstraints(
      maxWidth: 800.0,
      minHeight: 0.0,
      minWidth: 0.0,
    );

    final RenderParagraph renderParagraph = RenderParagraph(
      TextSpan(
        text: text,
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );
    renderParagraph.layout(constraints);
    return renderParagraph.getMinIntrinsicWidth(textStyle.fontSize).ceilToDouble();
  }

  Widget _buildAttributeValues() {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Container(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.of(context).attribute, style: const TextStyle(color: Color(0xff2C333A), fontSize: 17)),
                    const SizedBox(height: 10),
                    Wrap(
                      runSpacing: 10,
                      spacing: 0,
                      runAlignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: _productVariant.attributeValues
                          .map((ProductAttributeValue value) => LayoutBuilder(
                                builder: (BuildContext context, BoxConstraints constraints) {
                                  final double currentWidth = constraints.maxWidth;

                                  double nameSize = getTextLength(
                                      value.nameGet, const TextStyle(color: Color(0xff2C333A), fontSize: 13));
                                  nameSize = nameSize + 20 + 10 + 40;

                                  return nameSize < currentWidth
                                      ? Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(left: 20, right: 10, top: 0, bottom: 0),
                                              margin: const EdgeInsets.only(top: 0, bottom: 0, left: 0),
                                              decoration: const BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                                  color: Color(0xffF0F1F3)),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    value.nameGet,
                                                    style: const TextStyle(color: Color(0xff2C333A), fontSize: 13),
                                                  ),
                                                  ClipOval(
                                                    child: Container(
                                                      width: 40,
                                                      height: 40,
                                                      child: Material(
                                                        color: Colors.transparent,
                                                        child: IconButton(
                                                          padding: EdgeInsets.zero,
                                                          icon: const Icon(
                                                            Icons.clear,
                                                            size: 15,
                                                            color: Color(0xff858F9B),
                                                          ),
                                                          onPressed: () {
                                                            _productVariant.attributeValues.remove(value);
                                                            setState(() {});
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.only(left: 20, right: 10, top: 2, bottom: 5),
                                          margin: const EdgeInsets.only(top: 0, bottom: 0, left: 0),
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(20)),
                                              color: Color(0xffF0F1F3)),
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  value.nameGet,
                                                  style: const TextStyle(color: Color(0xff2C333A), fontSize: 13),
                                                ),
                                              ),
                                              ClipOval(
                                                child: Container(
                                                  width: 40,
                                                  height: 40,
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: IconButton(
                                                      padding: EdgeInsets.zero,
                                                      icon: const Icon(
                                                        Icons.clear,
                                                        size: 15,
                                                        color: Color(0xff858F9B),
                                                      ),
                                                      onPressed: () {
                                                        _productVariant.attributeValues.remove(value);
                                                        setState(() {});
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                },
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
              ClipOval(
                child: Container(
                  height: 50,
                  width: 50,
                  child: Material(
                    color: Colors.transparent,
                    child: IconButton(
                      iconSize: 18,
                      icon: const Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Color(0xff858F9B),
                      ),
                      onPressed: () async {
                        final ProductAttributeValue result = await Navigator.push<ProductAttributeValue>(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const ProductAttributeLinePage(
                                isSearch: true,
                              );
                            },
                          ),
                        );

                        if (result != null) {
                          if (!_productVariant.attributeValues.any((element) => element.id == result.id)) {
                            _productVariant.attributeValues.add(result);
                            setState(() {});
                          } else {
                            final Widget snackBar = customSnackBar(
                                message: S.of(context).alreadyHaveAttributeValue,
                                scaffoldKey: _scaffoldKey,
                                context: context);
                            _scaffoldKey.currentState.showSnackBar(snackBar);
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ///Xây dựng giao diện nhập Loại sản phẩm, Nhóm sản phẩm
  Widget _buildTypeGroup() {
    return _buildGroup(
        child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                S.of(context).productType,
                style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
              ),
            ),
            StatefulBuilder(
              builder: (BuildContext context, void Function(void Function()) setState) {
                return Container(
                  width: 160,
                  height: 40,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      icon: Row(
                        children: const <Widget>[
                          Icon(Icons.arrow_drop_down),
                          SizedBox(width: 10),
                        ],
                      ),
                      value: _productVariant.type,
                      isExpanded: true,
                      onChanged: (String value) {
                        _productVariant.showType = _mapTypes[value];
                        _productVariant.type = value;
                        setState(() {});
                      },
                      selectedItemBuilder: (BuildContext context) {
                        return _mapTypes.keys.map<Widget>((String item) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(_mapTypes[item],
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      style: const TextStyle(color: Color(0xff5A6271))),
                                ),
                              ),
                            ],
                          );
                        }).toList();
                      },
                      items: _mapTypes.keys
                          .map(
                            (key) => DropdownMenuItem<String>(
                              value: key,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(_mapTypes[key]),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        Divider(height: 1, color: Colors.grey.shade500),
        const SizedBox(height: 10),
        StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {
          return _buildNavigate(
              title: S.of(context).productCategory,
              note: _productVariant.categ != null
                  ? _productVariant.categ.name
                  : S.of(context).selectParam(S.of(context).productCategory.toLowerCase()),
              noteStyle: _productVariant.categ != null ? const TextStyle(color: Color(0xff2C333A), fontSize: 15) : null,
              onTap: () async {
                final ProductCategory result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ProductCategoriesPage(
                        onSelected: (ProductCategory productCategory) {},
                        searchModel: true,
                        selectedItems: _productVariant.categ != null ? [_productVariant.categ] : [],
                      );
                    },
                  ),
                );
                if (result != null) {
                  _productVariant.categ = result;
                  setState(() {});
                }
              });
        })
      ],
    ));
  }

  ///Xây dựng giao diện nhập số  'Giá bán', 'Chiết khấu bán', 'Giá mua mặc định', 'Chiết khấu mua'
  Widget _buildInputNumberGroup() {
    return _buildGroup(
        child: Column(
      children: [
        _buildNumberTextField(
            controller: _variantPriceController,
            title: S.of(context).variantPrice,
            uom: 'đ',
            focusNode: _variantPriceFocusNode),
        _buildNumberTextField(
          controller: _standardPriceController,
          title: S.of(context).standardPrice,
          uom: 'đ',
        )
      ],
    ));
  }

  ///Xây dựng giao diện nhập số  'Đơn vị mặc định', 'Đơn vị mua','Hiệu lực'
  Widget _buildUomGroup() {
    return _buildGroup(
        child: Column(
      children: [
        StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {
          return _buildCancelNavigate(
              title: S.of(context).defaultUnit,
              note: _productVariant.uOM != null ? _productVariant.uOM.name ?? '' : null,
              noteStyle: _productVariant.uOMPO != null
                  ? _productVariant.uOMPO.name != null
                      ? const TextStyle(color: Color(0xff2C333A), fontSize: 15)
                      : null
                  : null,
              hint: S.of(context).selectParam(S.of(context).defaultUnit.toLowerCase()),
              onDelete: () {
                _productVariant.uOM = null;
                setState(() {});
              },
              onTap: () async {
                final ProductUOM result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ProductUomsPage(
                        searchModel: true,
                        selectedItems: _productVariant.uOM != null ? [_productVariant.uOM] : [],
                        categoryId: _productVariant.uOMPO != null ? _productVariant.uOMPO.categoryId : null,
                      );
                    },
                  ),
                );
                if (result != null) {
                  _productVariant.uOM = result;
                  _productVariant.uOMId = result.id;
                  _productVariant.uOMName = result.name;
                  setState(() {});
                }
              });
        }),
        const SizedBox(height: 10),
        Container(color: Colors.grey.shade200, height: 1, width: double.infinity),
        const SizedBox(height: 10),
        StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return _buildCancelNavigate(
                title: S.of(context).purchaseUnit,
                onDelete: () {
                  _productVariant.uOMPO = null;
                  setState(() {});
                },
                note: _productVariant.uOMPO != null ? _productVariant.uOMPO.name ?? '' : null,
                hint: S.of(context).selectParam(S.of(context).purchaseUnit.toLowerCase()),
                noteStyle: _productVariant.uOMPO != null
                    ? _productVariant.uOMPO.name != null
                        ? const TextStyle(color: Color(0xff2C333A), fontSize: 15)
                        : null
                    : null,
                onTap: () async {
                  final ProductUOM result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ProductUomsPage(
                          searchModel: true,
                          selectedItems: _productVariant.uOMPO != null ? [_productVariant.uOMPO] : [],
                          categoryId: _productVariant.uOM != null ? _productVariant.uOM.categoryId : null,
                        );
                      },
                    ),
                  );
                  if (result != null) {
                    _productVariant.uOMPO = result;
                    _productVariant.uOMPOId = result.id;
                    _productVariant.uOMPOName = result.name;
                    setState(() {});
                  }
                });
          },
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.of(context).active,
              style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
            ),
            StatefulBuilder(
              builder: (BuildContext context, void Function(void Function()) setState) {
                return Row(
                  children: [
                    Text(
                      _productVariant.active ? S.of(context).using : S.of(context).expire,
                      style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
                    ),
                    const SizedBox(width: 10),
                    CustomSwitch(
                      value: _productVariant.active,
                      onToggle: (bool value) {
                        _productVariant.active = value;
                        setState(() {});
                      },
                      toggleSize: 25,
                      toggleColor: const Color(0xff28A745),
                      width: 40,
                      height: 18,
                      activeColor: const Color.fromARGB(96, 40, 167, 69),
                      inactiveColor: Colors.grey.shade200,
                    )
                  ],
                );
              },
            )
          ],
        ),
      ],
    ));
  }

  Widget _buildControlInvoice() {
    return _buildGroup(
      child: StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).controlInvoice,
              style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
            ),
            RadioListTile<String>(
              title:
                  Text(S.of(context).onReceiveQuantity, style: const TextStyle(color: Color(0xff2C333A), fontSize: 17)),
              value: "receive",
              groupValue: _productVariant.purchaseMethod,
              onChanged: (value) {
                setState(
                  () {
                    _productVariant.purchaseMethod = value;
                  },
                );
              },
            ),
            RadioListTile<String>(
              title: Text(S.of(context).onPurchaseQuantity,
                  style: const TextStyle(color: Color(0xff2C333A), fontSize: 17)),
              value: "purchase",
              groupValue: _productVariant.purchaseMethod,
              onChanged: (value) {
                setState(
                  () {
                    _productVariant.purchaseMethod = value;
                  },
                );
              },
            ),
          ],
        );
      }),
    );
  }

  ///Xây dựng giao diện navigate đến màn hình khác để chọn
  Widget _buildNavigate(
      {@required String title, @required String note, @required Function() onTap, TextStyle noteStyle}) {
    assert(title != null);
    assert(note != null);
    assert(onTap != null);
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
                ),
                const SizedBox(height: 7),
                Text(
                  note,
                  style: noteStyle ?? const TextStyle(color: Color(0xff929DAA), fontSize: 15),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 15, color: Color(0xff929DAA)),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  ///Xây dựng giao diện navigate đến màn hình khác để chọn
  Widget _buildCancelNavigate(
      {@required String title,
      String note,
      @required String hint,
      @required Function() onTap,
      TextStyle noteStyle,
      VoidCallback onDelete}) {
    assert(title != null);
    assert(onTap != null);
    assert(hint != null);
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
                ),
                const SizedBox(height: 7),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 4),
                    Text(
                      note ?? hint,
                      style: noteStyle ?? const TextStyle(color: Color(0xff929DAA), fontSize: 15),
                    ),
                    if (note != '' && note != null)
                      IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            onDelete?.call();
                          })
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 15, color: Color(0xff929DAA)),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _buildTextField({
    TextEditingController controller,
    FocusNode focusNode,
    Widget suffix,
    bool isRequire = false,
    String hint,
    Function(String) onTextChanged,
    EdgeInsets contentPadding = const EdgeInsets.only(right: 10),
    bool error = false,
    String title,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title ?? '', style: const TextStyle(color: Color(0xff929DAA), fontSize: 12)),
        Stack(
          children: [
            if (isRequire && controller.text == '')
              Positioned(
                  top: 11,
                  left: 0,
                  child: InkWell(
                    child: RichText(
                      text: TextSpan(style: DefaultTextStyle.of(context).style, children: [
                        TextSpan(
                          text: hint,
                          style: const TextStyle(color: Color(0xff929DAA), fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                        const TextSpan(
                          text: ' *',
                          style: TextStyle(color: Color(0xffEB3B5B), fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                      ]),
                      maxLines: 1,
                    ),
                    onTap: () {
                      if (focusNode != null) {
                        FocusScope.of(context).requestFocus(focusNode);
                      }
                    },
                  )),
            TextField(
              controller: controller,
              focusNode: focusNode,
              maxLines: 1,
              onChanged: onTextChanged,
              style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
              decoration: InputDecoration(
                contentPadding: contentPadding,
                enabledBorder: error
                    ? const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      )
                    : UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                hintText: isRequire ? '' : hint,
                hintStyle: const TextStyle(color: Color(0xff929DAA), fontSize: 17),
                focusedBorder: error
                    ? const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      )
                    : const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff28A745)),
                      ),
              ),
            ),
            if (suffix != null) Positioned(right: 0, top: 5, child: suffix),
          ],
        ),
      ],
    );
  }

  Widget _buildNumberTextField(
      {TextEditingController controller,
      FocusNode focusNode,
      Widget suffix,
      bool isRequire = false,
      String hint,
      EdgeInsets contentPadding = const EdgeInsets.only(right: 10),
      String uom,
      String title,
      RegExInputFormatter regExInputFormatter,
      Function() onTapSuffix}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Color(0xff929DAA), fontSize: 12)),
        StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Stack(
              children: [
                if (suffix != null) Positioned(right: 0, top: 5, child: suffix),
                Positioned(
                  top: 15,
                  left: 0,
                  child: InkWell(
                    onTap: () {
                      if (focusNode != null) {
                        FocusScope.of(context).requestFocus(focusNode);
                      }
                    },
                    child: Row(
                      children: [
                        Text(controller.text, style: const TextStyle(color: Colors.transparent, fontSize: 17)),
                        const SizedBox(width: 5),
                        Text(uom,
                            style: const TextStyle(
                              color: Color(0xff929DAA),
                              fontSize: 12,
                              decoration: TextDecoration.underline,
                            ))
                      ],
                    ),
                  ),
                ),
                if (isRequire && controller.text == '')
                  Positioned(
                      top: 11,
                      left: 0,
                      child: InkWell(
                        child: RichText(
                          text: TextSpan(style: DefaultTextStyle.of(context).style, children: [
                            TextSpan(
                              text: hint,
                              style:
                                  const TextStyle(color: Color(0xff929DAA), fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                            const TextSpan(
                              text: ' *',
                              style: TextStyle(color: Color(0xffEB3B5B), fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                          ]),
                          maxLines: 1,
                        ),
                        onTap: () {
                          if (focusNode != null) {
                            FocusScope.of(context).requestFocus(focusNode);
                          }
                        },
                      )),
                Container(
                  height: 50,
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    onChanged: (String text) {
                      setState(() {});
                    },
                    inputFormatters: regExInputFormatter != null
                        ? <TextInputFormatter>[regExInputFormatter]
                        : <TextInputFormatter>[],
                    style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
                    decoration: InputDecoration(
                      contentPadding: contentPadding,
                      suffix: onTapSuffix != null
                          ? SvgPicture.asset(
                              'assets/icon/tag_green.svg',
                              width: 20,
                              height: 20,
                              color: Colors.transparent,
                            )
                          : null,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      hintText: isRequire ? '' : hint,
                      hintStyle: const TextStyle(color: Color(0xff929DAA), fontSize: 17),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff28A745)),
                      ),
                    ),
                  ),
                ),
                if (onTapSuffix != null)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: ClipOval(
                      child: Container(
                        height: 50,
                        width: 50,
                        child: Material(
                          color: Colors.transparent,
                          child: IconButton(
                            iconSize: 30,
                            icon: SvgPicture.asset(
                              'assets/icon/tag_green.svg',
                              width: 20,
                              height: 20,
                              color: const Color(0xff858F9B),
                            ),
                            onPressed: () {
                              onTapSuffix?.call();
                            },
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            );
          },
        ),
      ],
    );
  }
}
