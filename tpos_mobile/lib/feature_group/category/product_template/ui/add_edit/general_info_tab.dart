import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/feature_group/category/product_category/ui/product_category_list_page.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/add_edit/product_template_add_edit_bloc.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/add_edit/product_template_add_edit_event.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/add_edit/product_template_add_edit_state.dart';
import 'package:tpos_mobile/feature_group/category/product_template/ui/add_edit/another_product_add_edit_info_page.dart';
import 'package:tpos_mobile/feature_group/category/product_uom/ui/product_uoms_page.dart';
import 'package:tpos_mobile/helpers/barcode_scan.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/custom_switch.dart';
import 'package:tpos_mobile/widgets/money_format_controller.dart';
import 'package:tpos_mobile/widgets/reg_ex_input_formatter.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

///Tab thông tin chung của màn hình thêm, sửa productTemplage
///[productTemplate] đối tượng product template hiện tại
///[isOpenKeyBoard] kiểm tra xem keyboard có mở không
///[errorName] kiểm tra xem nhập tên có hợp lện không khi lưu
class GeneralInfoTab extends StatefulWidget {
  const GeneralInfoTab(
      {Key key, this.productTemplate, this.isOpenKeyBoard = false, this.errorName, this.isInsert = true})
      : super(key: key);

  @override
  _GeneralInfoTabState createState() => _GeneralInfoTabState();

  final ProductTemplate productTemplate;
  final bool isOpenKeyBoard;
  final bool errorName;
  final bool isInsert;
}

class _GeneralInfoTabState extends State<GeneralInfoTab> with AutomaticKeepAliveClientMixin {
  final GlobalKey _toolTipKey = GlobalKey();
  ProductTemplateAddEditBloc _productTemplateAddEditBloc;
  ProductTemplate _productTemplate;
  final TextEditingController _productNameController = TextEditingController();
  final FocusNode _productNameFocusNode = FocusNode();
  final FocusNode _listPriceFocusNode = FocusNode();
  final FocusNode _purchasePriceFocusNode = FocusNode();
  final FocusNode _weightFocusNode = FocusNode();
  final FocusNode _volumeFocusNode = FocusNode();
  final FocusNode _initInventoryFocusNode = FocusNode();
  final FocusNode _standardPriceFocusNode = FocusNode();

  final TextEditingController _productCodeController = TextEditingController();
  final TextEditingController _barCodeController = TextEditingController();
  final CustomMoneyMaskedTextController _weightController = CustomMoneyMaskedTextController(
      minValue: 0, precision: 0, thousandSeparator: '.', decimalSeparator: '', defaultValue: 0);
  final TextEditingController _volumeController = TextEditingController();

  final CustomMoneyMaskedTextController _listPriceController = CustomMoneyMaskedTextController(
      minValue: 0, precision: 0, thousandSeparator: '.', decimalSeparator: '', defaultValue: 0);

  final CustomMoneyMaskedTextController _purchasePriceController =
      CustomMoneyMaskedTextController(minValue: 0, precision: 0, thousandSeparator: '.', decimalSeparator: '');

  final CustomMoneyMaskedTextController _standardPriceController =
      CustomMoneyMaskedTextController(minValue: 0, precision: 0, thousandSeparator: '.', decimalSeparator: '');
  final CustomMoneyMaskedTextController _initInventoryController =
      CustomMoneyMaskedTextController(minValue: 0, precision: 0, thousandSeparator: '.', decimalSeparator: '');

  final CustomMoneyMaskedTextController _dialogController = CustomMoneyMaskedTextController(
      minValue: 0, maxValue: 100, precision: 0, thousandSeparator: '.', decimalSeparator: '');

  // final RegExInputFormatter _weightValidator =
  //     RegExInputFormatter.withRegex('^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$');
  final RegExInputFormatter _volumeValidator =
      RegExInputFormatter.withRegex('^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$');

  Map<String, String> _mapTypes;

  bool _errorName = false;
  final ImagePicker picker = ImagePicker();

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

  @override
  void initState() {
    super.initState();
    _productTemplate = widget.productTemplate;
    _productNameController.text = _productTemplate.name ?? '';
    _productCodeController.text = _productTemplate.defaultCode ?? '';
    _barCodeController.text = _productTemplate.barcode ?? '';
    _listPriceController.text = _productTemplate.listPrice?.toStringAsFixed(0);
    _weightController.text = isNumeric(_productTemplate.weight.toStringAsFixed(0))
        ? _productTemplate.weight.toString()
        : _productTemplate.weight.toStringAsFixed(0);

    _volumeController.text = isNumeric(_productTemplate.volume.toStringAsFixed(2))
        ? _productTemplate.volume.toString()
        : _productTemplate.volume.toStringAsFixed(0);

    _purchasePriceController.text = _productTemplate.purchasePrice?.toStringAsFixed(0);

    _standardPriceController.text = _productTemplate.standardPrice?.toStringAsFixed(0);

    _initInventoryController.text = _productTemplate.initInventory?.toStringAsFixed(0);

    _productTemplateAddEditBloc = BlocProvider.of<ProductTemplateAddEditBloc>(context);

    _standardPriceController.addListener(() {
      _productTemplate.standardPrice = _standardPriceController.numberValue;
    });

    _initInventoryController.addListener(() {
      _productTemplate.initInventory = _initInventoryController.numberValue;
    });

    _weightController.addListener(() {
      _productTemplate.weight = double.tryParse(_weightController.text);
    });
    _volumeController.addListener(() {
      _productTemplate.volume = double.tryParse(_volumeController.text);
    });

    _productNameController.addListener(() {
      _productTemplate.name = _productNameController.text;
    });

    _productCodeController.addListener(() {
      _productTemplate.defaultCode = _productCodeController.text;
    });

    _barCodeController.addListener(() {
      _productTemplate.barcode = _productTemplate.barcode == '' ? null : _barCodeController.text;
    });

    _listPriceController.addListener(() {
      _productTemplate.listPrice = _listPriceController.numberValue;
    });

    _purchasePriceController.addListener(() {
      _productTemplate.purchasePrice = _purchasePriceController.numberValue;
    });
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
    super.dispose();

    _listPriceController.dispose();
    _purchasePriceController.dispose();
    _barCodeController.dispose();
    _productCodeController.dispose();
    _productNameController.dispose();
    _weightController.dispose();
    _volumeController.dispose();
    _dialogController.dispose();
    _standardPriceController.dispose();
    _initInventoryController.dispose();

    _productNameFocusNode.dispose();
    _listPriceFocusNode.dispose();
    _purchasePriceFocusNode.dispose();
    _weightFocusNode.dispose();
    _volumeFocusNode.dispose();
    _initInventoryFocusNode.dispose();
    _standardPriceFocusNode.dispose();
  }

  @override
  void didUpdateWidget(covariant GeneralInfoTab oldWidget) {
    if (widget.errorName != _errorName) {
      _errorName = widget.errorName;
      setState(() {});
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<ProductTemplateAddEditBloc, ProductTemplateAddEditState>(
      listener: (BuildContext context, ProductTemplateAddEditState state) {
        if (state is ProductTemplateAddEditNameError) {
          _productNameFocusNode.requestFocus();
        }
      },
      child: Padding(
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
                  _buildTypeGroup(),
                  const SizedBox(height: 10),
                  _buildInputNumberGroup(),
                  const SizedBox(height: 10),
                  _buildUomGroup(),
                  const SizedBox(height: 10),
                  _buildSettings(),
                  const SizedBox(height: 10),
                  _buildAnotherInfoGroup(),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      {TextEditingController controller,
      FocusNode focusNode,
      Widget suffix,
      bool isRequire = false,
      String hint,
      Function(String) onTextChanged,
      EdgeInsets contentPadding = const EdgeInsets.only(right: 10),
      bool error = false,
      String title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(title ?? '', style: const TextStyle(color: Color(0xff929DAA), fontSize: 12)),
          ),
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
        const SizedBox(height: 10),
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
              _productTemplateAddEditBloc.add(ProductTemplateAddEditUploadImage(file: File(pickedFile.path)));
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
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: <Widget>[
                  if (_productTemplate.id != 0 && _productTemplate.imageUrl != null && _productTemplate.imageUrl != '')
                    Container(
                      width: 100,
                      height: 100,
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: _productTemplate.imageUrl,
                            fit: BoxFit.cover,
                            imageBuilder: (BuildContext context, ImageProvider imageProvider) {
                              return Container(
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
                                            title: S.of(context).confirmDelete,
                                            content: S.of(context).deleteImageInquiry);

                                        if (result != null && result) {
                                          _productTemplate.image = null;
                                          _productTemplate.imageUrl = null;
                                          setState(() {});
                                        }
                                      }),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  else if (_productTemplate.image != null &&
                      _productTemplate.image != '' &&
                      (_productTemplate.imageUrl == null || _productTemplate.imageUrl == ''))
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                          color: Colors.grey.withAlpha(100),
                        ),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: MemoryImage(
                            _productTemplate.imageBytes,
                          ),
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
                                            title: S.of(context).confirmDelete,
                                            content: S.of(context).deleteImageInquiry);

                                        if (result != null && result) {
                                          _productTemplate.image = null;
                                          _productTemplate.imageUrl = null;
                                          setState(() {});
                                        }
                                      }),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                ] +
                _productTemplate.images
                    .map((ProductImage productImage) => _buildImage(productImage, () {
                          setState(() {});
                        }))
                    .toList() +
                [_buildInsertImageButton()],
          ),
        );
      },
    );
  }

  ///Xây dựng giao diện hình ảnh sản phẩm
  Widget _buildImage(ProductImage productImage, Function() onDelete) {
    assert(productImage != null);
    return Container(
      width: 100,
      height: 100,
      child: Stack(
        children: [
          Center(
            child: CachedNetworkImage(
              imageUrl: productImage.url,
              fit: BoxFit.cover,
              imageBuilder: (BuildContext context, ImageProvider imageProvider) {
                return Container(
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
                      onPressed: () {
                        _productTemplate.images.remove(productImage);
                        onDelete();
                      }),
                ),
              ),
            ),
          )
        ],
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
          StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {
            return _buildTextField(
                controller: _productNameController,
                hint: S.of(context).enterParam(S.of(context).productName.toLowerCase()),
                title: S.of(context).productName,
                isRequire: true,
                focusNode: _productNameFocusNode,
                error: _errorName,
                onTextChanged: (String text) {
                  setState(() {});
                  _productTemplate.name = _productNameController.text;
                });
          }),
          _buildTextField(
              controller: _productCodeController,
              hint: S.of(context).enterParam(S.of(context).productCode.toLowerCase()),
              title: S.of(context).productCode,
              contentPadding: const EdgeInsets.only(right: 55),
              suffix: GestureDetector(
                onTap: () {
                  final dynamic tooltip = _toolTipKey.currentState;
                  tooltip.ensureTooltipVisible();
                },
                child: Tooltip(
                  key: _toolTipKey,
                  message: S.of(context).emptyAutoGenerate,
                  decoration:
                      const BoxDecoration(color: Colors.green, borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Container(
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.info_outline,
                      color: Color(0xff28A745),
                    ),
                  ),
                ),
              ),
              onTextChanged: (String value) {
                _productTemplate.defaultCode = _productCodeController.text;
              }),
          StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return _buildTextField(
                  controller: _barCodeController,
                  hint: S.of(context).barcode,
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
                    _productTemplate.barcode = _barCodeController.text;
                  });
            },
          ),
        ],
      ),
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
                      value: _productTemplate.type,
                      isExpanded: true,
                      onChanged: (String value) {
                        _productTemplate.showType = _mapTypes[value];
                        _productTemplate.type = value;
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
        Divider(
          height: 1,
          color: Colors.grey.shade500,
        ),
        const SizedBox(height: 10),
        StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {
          return _buildNavigate(
              title: S.of(context).productCategory,
              note: _productTemplate.categ != null
                  ? _productTemplate.categ.name
                  : S.of(context).selectParam(S.of(context).productCategory.toLowerCase()),
              noteStyle:
                  _productTemplate.categ != null ? const TextStyle(color: Color(0xff2C333A), fontSize: 15) : null,
              onTap: () async {
                final ProductCategory result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ProductCategoriesPage(
                        onSelected: (ProductCategory productCategory) {},
                        searchModel: true,
                        selectedItems: _productTemplate.categ != null ? [_productTemplate.categ] : [],
                      );
                    },
                  ),
                );
                if (result != null) {
                  _productTemplate.categ = result;
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
            controller: _weightController,
            title: S.of(context).weight,
            uom: '',
            // regExInputFormatter: _weightValidator,
            focusNode: _weightFocusNode),
        _buildNumberTextField(
            controller: _volumeController,
            title: S.of(context).volume,
            uom: '',
            regExInputFormatter: _volumeValidator,
            focusNode: _volumeFocusNode),
        _buildNumberTextField(
            controller: _listPriceController,
            title: S.of(context).salePrice,
            uom: 'đ',
            focusNode: _listPriceFocusNode,
            onTapSuffix: () async {
              _dialogController.text =
                  _productTemplate.discountSale != null ? _productTemplate.discountSale.toStringAsFixed(0) : '';
              final String value = await showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  return _buildDialogInputs(
                      context: context,
                      title: S.of(context).addParam(S.of(context).discountSale.toLowerCase()),
                      hint: '${S.of(context).enterParam(S.of(context).discountSale.toLowerCase())} (%)');
                },
                useRootNavigator: false,
              );

              if (value != null) {
                _productTemplate.discountSale = _dialogController.numberValue;
              }
            }),
        _buildNumberTextField(
            controller: _purchasePriceController,
            title: S.of(context).purchasePrice,
            uom: 'đ',
            focusNode: _purchasePriceFocusNode,
            onTapSuffix: () async {
              _dialogController.text =
                  _productTemplate.discountPurchase != null ? _productTemplate.discountPurchase.toStringAsFixed(0) : '';
              final String value = await showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  return _buildDialogInputs(
                      context: context,
                      title: S.of(context).addParam(S.of(context).discountPurchase.toLowerCase()),
                      hint: '${S.of(context).enterParam(S.of(context).discountPurchase.toLowerCase())} (%)');
                },
                useRootNavigator: false,
              );

              if (value != null) {
                _productTemplate.discountPurchase = _dialogController.numberValue;
              }
            }),
        Row(
          children: [
            Expanded(
              child: _buildNumberTextField(
                controller: _standardPriceController,
                title: S.of(context).standardPrice,
                uom: 'đ',
              ),
            ),
            if (widget.isInsert) const SizedBox(width: 10),
            if (widget.isInsert)
              Expanded(
                child: _buildNumberTextField(
                  controller: _initInventoryController,
                  title: S.of(context).availableQuantity,
                  uom: '',
                ),
              ),
          ],
        )
      ],
    ));
  }

  ///Giao diện dialog nhập thông tin
  Widget _buildDialogInputs({@required BuildContext context, @required String title, @required String hint}) {
    assert(context != null);
    assert(title != null);
    assert(hint != null);

    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyText2,
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 16, right: 0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: Colors.white,
              ),
              // padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(color: Color(0xff2C333A), fontSize: 21),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                    iconSize: 30,
                                    icon: const Icon(
                                      Icons.close,
                                      color: Color(0xff929DAA),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }),
                              ),
                            ),
                            const SizedBox(width: 0)
                          ],
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Column(
                            children: [
                              StatefulBuilder(
                                builder: (BuildContext context, void Function(void Function()) setState) {
                                  return Container(
                                    height: 50,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: 10,
                                          left: 5,
                                          child: SvgPicture.asset(
                                            'assets/icon/tag_green.svg',
                                            width: 20,
                                            height: 20,
                                            color: const Color(0xff858F9B),
                                            // color: Colors.transparent,
                                          ),
                                        ),
                                        if (_dialogController.text != '')
                                          Positioned(
                                            top: 13,
                                            left: 30,
                                            child: Row(
                                              children: [
                                                Text(_dialogController.text,
                                                    style: const TextStyle(color: Colors.transparent, fontSize: 17)),
                                                const SizedBox(width: 10),
                                                const Text('%',
                                                    style: TextStyle(
                                                      color: Color(0xff929DAA),
                                                      fontSize: 12,
                                                      decoration: TextDecoration.underline,
                                                    ))
                                              ],
                                            ),
                                          ),
                                        TextField(
                                          controller: _dialogController,
                                          autofocus: true,
                                          maxLines: 1,
                                          onChanged: (String text) {
                                            setState(() {});
                                          },
                                          style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.only(right: 10, left: 5, bottom: 10),
                                            prefix: Padding(
                                              padding: const EdgeInsets.only(right: 10, bottom: 0),
                                              child: SvgPicture.asset(
                                                'assets/icon/tag_green.svg',
                                                width: 20,
                                                height: 20,
                                                color: Colors.transparent,
                                              ),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: Colors.grey.shade200),
                                            ),
                                            hintText: hint,
                                            hintStyle: const TextStyle(color: Color(0xff929DAA), fontSize: 17),
                                            focusedBorder: const UnderlineInputBorder(
                                              borderSide: BorderSide(color: Color(0xff28A745)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(color: const Color(0xffC6C6C6), width: 1)),
                                    child: FlatButton(
                                      padding: const EdgeInsets.only(left: 40, right: 40),
                                      child: const Center(
                                        child: Text(
                                          'Hủy',
                                          style: TextStyle(color: Color(0xff3A3B3F)),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(color: const Color(0xff28A745), width: 1)),
                                    child: FlatButton(
                                      padding: const EdgeInsets.only(left: 60, right: 60),
                                      child: Center(
                                        child: Text(
                                          S.of(context).save,
                                          style: const TextStyle(color: Color(0xff28A745)),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context, _dialogController.text);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20)
                ],
              ),
            ),
          ],
        ),
      ),
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

  ///Xây dựng giao diện nhập số  'Đơn vị mặc định', 'Đơn vị mua','Hiệu lực'
  Widget _buildUomGroup() {
    return _buildGroup(
        child: Column(
      children: [
        StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {
          return _buildCancelNavigate(
              title: S.of(context).defaultUnit,
              note: _productTemplate.uOM != null ? _productTemplate.uOM.name ?? '' : null,
              noteStyle: _productTemplate.uOMPO != null
                  ? _productTemplate.uOMPO.name != null
                      ? const TextStyle(color: Color(0xff2C333A), fontSize: 15)
                      : null
                  : null,
              hint: S.of(context).selectParam(S.of(context).defaultUnit.toLowerCase()),
              onDelete: () {
                _productTemplate.uOM = null;
                setState(() {});
              },
              onTap: () async {
                final ProductUOM result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ProductUomsPage(
                        searchModel: true,
                        selectedItems: _productTemplate.uOM != null ? [_productTemplate.uOM] : [],
                        categoryId: _productTemplate.uOMPO != null ? _productTemplate.uOMPO.categoryId : null,
                      );
                    },
                  ),
                );
                if (result != null) {
                  _productTemplate.uOM = result;
                  _productTemplate.uOMId = result.id;
                  _productTemplate.uOMName = result.name;
                  setState(() {});
                }
              });
        }),
        Container(color: Colors.grey.shade200, height: 1, width: double.infinity),
        const SizedBox(height: 10),
        StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return _buildCancelNavigate(
                title: S.of(context).purchaseUnit,
                onDelete: () {
                  _productTemplate.uOMPO = null;
                  setState(() {});
                },
                note: _productTemplate.uOMPO != null ? _productTemplate.uOMPO.name ?? '' : null,
                hint: S.of(context).selectParam(S.of(context).purchaseUnit.toLowerCase()),
                noteStyle: _productTemplate.uOMPO != null
                    ? _productTemplate.uOMPO.name != null
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
                          selectedItems: _productTemplate.uOMPO != null ? [_productTemplate.uOMPO] : [],
                          categoryId: _productTemplate.uOM != null ? _productTemplate.uOM.categoryId : null,
                        );
                      },
                    ),
                  );
                  if (result != null) {
                    _productTemplate.uOMPO = result;
                    _productTemplate.uOMPOId = result.id;
                    _productTemplate.uOMPOName = result.name;
                    setState(() {});
                  }
                });
          },
        ),
        Container(color: Colors.grey.shade200, height: 1, width: double.infinity),
        const SizedBox(height: 15),
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
                      _productTemplate.active ? S.of(context).using : S.of(context).expire,
                      style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
                    ),
                    const SizedBox(width: 10),
                    CustomSwitch(
                      value: _productTemplate.active,
                      onToggle: (bool value) {
                        _productTemplate.active = value;
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
        )
      ],
    ));
  }

  ///Xây dựng giao diện 'CẤU HÌNH SẢN PHẨM'
  Widget _buildSettings() {
    return _buildGroup(
        padding: const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 14),
              child: Text(
                S.of(context).productConfiguration,
                style: const TextStyle(color: Color(0xff28A745), fontSize: 17),
              ),
            ),
            Container(
              width: double.infinity,
              child: Wrap(
                children: [
                  StatefulBuilder(
                    builder: (BuildContext context, void Function(void Function()) setState) {
                      return _buildCheckRow(S.of(context).allowSale, (bool value) {
                        _productTemplate.saleOK = value;
                        setState(() {});
                      }, _productTemplate.saleOK);
                    },
                  ),
                  StatefulBuilder(
                    builder: (BuildContext context, void Function(void Function()) setState) {
                      return _buildCheckRow(S.of(context).allowPurchase, (bool value) {
                        _productTemplate.purchaseOK = value;
                        setState(() {});
                      }, _productTemplate.purchaseOK);
                    },
                  ),
                  StatefulBuilder(
                    builder: (BuildContext context, void Function(void Function()) setState) {
                      return _buildCheckRow(S.of(context).isCombo, (bool value) {
                        _productTemplate.isCombo = value;
                        setState(() {});
                      }, _productTemplate.isCombo);
                    },
                  ),
                  StatefulBuilder(
                    builder: (BuildContext context, void Function(void Function()) setState) {
                      return _buildCheckRow(S.of(context).availableInPOS, (bool value) {
                        _productTemplate.availableInPOS = value;
                        setState(() {});
                      }, _productTemplate.availableInPOS);
                    },
                  ),
                  StatefulBuilder(
                    builder: (BuildContext context, void Function(void Function()) setState) {
                      return _buildCheckRow(S.of(context).allowSaleInAnotherCompany, (bool value) {
                        _productTemplate.enableAll = value;
                        setState(() {});
                      }, _productTemplate.enableAll);
                    },
                  ),
                ],
              ),
            )
          ],
        ));
  }

  Widget _buildCheckRow(String name, Function(bool) onCheckChanged, bool value) {
    assert(name != null);
    assert(onCheckChanged != null);
    assert(value != null);
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 25,
      child: Row(
        children: [
          Checkbox(
              value: value,
              onChanged: (value) {
                onCheckChanged(value);
              }),
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

  Widget _buildAnotherInfoGroup() {
    return _buildGroup(
      child: _buildNavigate(
          title: S.of(context).otherInformation,
          note: S.of(context).descriptionInPos,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return AnotherProductInfoPage(
                    productTemplate: _productTemplate,
                  );
                },
              ),
            );
          }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
