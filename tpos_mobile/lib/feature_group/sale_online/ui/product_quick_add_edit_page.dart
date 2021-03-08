/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/product_category_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/product_unit_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/product_quick_add_edit_viewmodel.dart';
import 'package:tpos_mobile/helpers/barcode_scan.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/widgets/custom_widget.dart';

class ProductQuickAddEditPage extends StatefulWidget {
  const ProductQuickAddEditPage(
      {this.closeWhenDone, this.productId, this.onEditedProduct});
  final bool closeWhenDone;
  final int productId;
  final Function onEditedProduct;

  @override
  _ProductQuickAddEditPageState createState() => _ProductQuickAddEditPageState(
      closeWhenDone: closeWhenDone, productId: productId);
}

class _ProductQuickAddEditPageState extends State<ProductQuickAddEditPage> {
  _ProductQuickAddEditPageState({this.closeWhenDone = false, this.productId});
  bool closeWhenDone;
  int productId;

  final GlobalKey<FormState> _key = GlobalKey();
  bool _validate = false;
  ProductQuickAddEditViewModel viewModel = ProductQuickAddEditViewModel();

  final TextEditingController _tenSpTextController = TextEditingController();
  final TextEditingController _maSpTextController = TextEditingController();
  final TextEditingController _maVachTextController = TextEditingController();
  final TextEditingController _khoiLuongTextController =
      TextEditingController();
  final TextEditingController _giaBanTextController = TextEditingController();
  final TextEditingController _giaVonTextController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode _tenSpFocus = FocusNode();
  final FocusNode _maSpFocus = FocusNode();
  final FocusNode _maVachFocus = FocusNode();
  final FocusNode _khoiLuongFocus = FocusNode();
  final FocusNode _giaBanFocus = FocusNode();
  final FocusNode _giaVonFocus = FocusNode();

  @override
  void initState() {
    viewModel.product.id = productId;
    viewModel.init();
    viewModel.productStream.listen((product) {
      _tenSpTextController.text = viewModel.product.name;
      _maSpTextController.text = viewModel.product.defaultCode.toString();
      _maVachTextController.text = viewModel.product.barcode;
      _khoiLuongTextController.text =
          vietnameseCurrencyFormat(viewModel.product.weight);
      _giaBanTextController.text =
          vietnameseCurrencyFormat(viewModel.product.lstPrice);
      _giaVonTextController.text =
          vietnameseCurrencyFormat(viewModel.product.standardPrice);
    });
    super.initState();
  }

  File _image;
  Future getImage(ImageSource source) async {
    try {
      final image =
          await ImagePicker.pickImage(source: source, maxWidth: 400.0);
      setState(() {
        _image = image;
      });
    } catch (ex) {
      print(ex);
    }
  }

  StreamSubscription notifySubcrible;
  @override
  void didChangeDependencies() {
    notifySubcrible = viewModel.notifyPropertyChangedController.listen((name) {
      setState(() {});
    });

    viewModel.dialogMessageController.listen((message) {
      registerDialogToView(context, message,
          scaffState: _scaffoldKey.currentState);
    });

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    notifySubcrible.cancel();
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewBaseWidget(
      isBusyStream: viewModel.isBusyController,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: productId == null
              ? const Text("Thêm sản phẩm")
              : const Text("Sửa sản phẩm"),
          actions: <Widget>[
            FlatButton.icon(
              label: const Text("Lưu"),
              textColor: Colors.white,
              icon: const Icon(Icons.check),
              onPressed: () async {
                save();
              },
            ),
          ],
        ),
        body: Container(color: Colors.grey.shade200, child: _showBody()),
      ),
    );
  }

  Widget _buildImageSelect() {
    return GestureDetector(
      onTap: () {
        setState(() {
          viewModel.product.imageUrl = null;
          _image = null;
          Padding(
            padding: const EdgeInsets.all(3),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                color: Colors.green,
              )),
              height: 120,
              width: 120,
              child: IconButton(
                color: Colors.green,
                icon: const Icon(Icons.add),
                onPressed: () async {},
              ),
            ),
          );
        });
      },
      child: const Icon(
        Icons.close,
        color: Colors.white,
      ),
    );
  }

  Widget _showBody() {
    return StreamBuilder<Product>(
        stream: viewModel.productStream,
        initialData: viewModel.product,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Form(
                key: _key,
                autovalidate: _validate,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          height: 120,
                          child: Builder(builder: (context) {
                            if (_image != null) {
                              return Stack(
                                alignment: Alignment.topRight,
                                children: <Widget>[
                                  Image.file(_image),
                                  _buildImageSelect(),
                                ],
                              );
                            }
                            if (snapshot.data.imageUrl != null &&
                                snapshot.data.imageUrl != "") {
                              return Stack(
                                alignment: Alignment.topRight,
                                children: <Widget>[
                                  Image.network(
                                    snapshot.data.imageUrl,
                                    height: 120,
                                    width: 120,
                                  ),
                                  _buildImageSelect(),
                                ],
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.all(3),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                  color: Colors.green,
                                )),
                                height: 120,
                                width: 120,
                                child: IconButton(
                                  color: Colors.green,
                                  icon: const Icon(Icons.add),
                                  onPressed: () async {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SimpleDialog(
                                            title: const Text("Menu"),
                                            children: <Widget>[
                                              ListTile(
                                                leading:
                                                    const Icon(Icons.camera),
                                                title: const Text(
                                                    "Chọn từ máy ảnh"),
                                                onTap: () {
                                                  getImage(ImageSource.camera);
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              ListTile(
                                                leading:
                                                    const Icon(Icons.image),
                                                title: const Text(
                                                    "Chọn từ thư viện"),
                                                onTap: () {
                                                  getImage(ImageSource.gallery);
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                    const Divider(),
                    // Tên sản phẩm
                    Container(
                      padding: const EdgeInsets.all(5),
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            autofocus: false,
                            controller: _tenSpTextController,
                            onEditingComplete: () {
                              _tenSpFocus.unfocus();
                              FocusScope.of(context).requestFocus(_maSpFocus);
                            },
                            focusNode: _tenSpFocus,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(5),
                              icon: Icon(Icons.filter),
                              labelText: 'Tên sản phẩm',
                            ),
                            validator: validateName,
                          ),
                          const Divider(),
                          // Mã sản phẩm
                          TextFormField(
                            controller: _maSpTextController,
                            focusNode: _maSpFocus,
                            onFieldSubmitted: (term) {
                              _maSpFocus.unfocus();
                              FocusScope.of(context).requestFocus(_maVachFocus);
                            },
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(5),
                              icon: Icon(Icons.clear_all),
                              labelText: 'Mã sản phẩm',
                            ),
                          ),
                          const Divider(),
                          // Mã vạch
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: TextFormField(
                                  controller: _maVachTextController,
                                  focusNode: _maVachFocus,
                                  onFieldSubmitted: (term) {
                                    _maVachFocus.unfocus();
                                    FocusScope.of(context)
                                        .requestFocus(_khoiLuongFocus);
                                  },
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(5),
                                    icon: Icon(Icons.filter_list),
                                    labelText: 'Mã vạch',
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.center_focus_strong),
                                onPressed: () async {
                                  // final barcode = await scanBarcode();
                                  final barcode = await Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return BarcodeScan();
                                  }));
                                  if (barcode != null) {
                                    setState(() {
                                      _maVachTextController.text = barcode;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          // Loại sản phẩm
                          Row(
                            children: <Widget>[
                              const Expanded(
                                flex: 3,
                                child: Text(
                                  "Chọn loại sản phẩm",
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ),
                              DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isDense: true,
                                  hint: const Text("Chọn loại sản phẩm"),
                                  value: viewModel.selectedProductType,
                                  onChanged: (String newValue) {
                                    setState(() {
                                      viewModel.selectedProductType = newValue;
                                    });
                                  },
                                  items: viewModel.sorts.map((Map map) {
                                    return DropdownMenuItem<String>(
                                      value: map["name"],
                                      child: Text(
                                        map["name"],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),

                          const Divider(),
                          // Nhóm sản phẩm
                          ListTile(
                            title: const Text("Nhóm sản phẩm"),
                            subtitle: Text(viewModel.product?.categ?.name ??
                                "Chọn nhóm sản phẩm"),
                            trailing: const Icon(Icons.keyboard_arrow_right),
                            onTap: () async {
                              final ProductCategory result =
                                  await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const ProductCategoryPage();
                                  },
                                ),
                              );
                              if (result != null) {
                                viewModel.selectProductCategoryCommand(result);
                              }
                            },
                          ),
                          const Divider(),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          // Khối lượng
                          Row(
                            children: <Widget>[
                              const Icon(
                                Icons.transit_enterexit,
                                color: Colors.green,
                              ),
                              const Expanded(
                                flex: 3,
                                child: Text(
                                  "Khối lượng",
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: TextField(
                                  onChanged: (value) {
                                    viewModel.product.weight =
                                        int.tryParse(value) ?? 0;
                                  },
                                  onTap: () {
                                    _khoiLuongTextController.selection =
                                        TextSelection(
                                            baseOffset: 0,
                                            extentOffset:
                                                _khoiLuongTextController
                                                    .text.length);
                                  },
                                  controller: _khoiLuongTextController,
                                  textAlign: TextAlign.end,
                                  focusNode: _khoiLuongFocus,
                                  onEditingComplete: () {
                                    _khoiLuongFocus.unfocus();
                                    FocusScope.of(context)
                                        .requestFocus(_giaBanFocus);
                                  },
                                  inputFormatters: const [],
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          signed: true, decimal: true),
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    hintText: "Nhập khối lượng",
                                    contentPadding: EdgeInsets.all(12),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          // Giá bán
                          Row(
                            children: <Widget>[
                              const Icon(
                                Icons.attach_money,
                                color: Colors.green,
                              ),
                              const Expanded(
                                flex: 3,
                                child: Text(
                                  "Giá bán",
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: TextField(
                                  onChanged: (value) {
                                    viewModel.product.lstPrice =
                                        double.tryParse(value) ?? 0;
                                  },
                                  controller: _giaBanTextController,
                                  onTap: () {
                                    _giaBanTextController.selection =
                                        TextSelection(
                                            baseOffset: 0,
                                            extentOffset: _giaBanTextController
                                                .text.length);
                                  },
                                  textAlign: TextAlign.end,
                                  focusNode: _giaBanFocus,
                                  onEditingComplete: () {
                                    _giaBanFocus.unfocus();
                                    FocusScope.of(context)
                                        .requestFocus(_giaVonFocus);
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    CurrencyInputFormatter(),
                                  ],
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true, signed: true),
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    hintText: "Nhập giá bán",
                                    contentPadding: EdgeInsets.all(12),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          // Giá vốn
                          Row(
                            children: <Widget>[
                              const Icon(
                                Icons.attach_money,
                                color: Colors.green,
                              ),
                              const Expanded(
                                flex: 3,
                                child: Text(
                                  "Giá vốn",
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: TextField(
                                  onChanged: (value) {
                                    viewModel.product.standardPrice =
                                        double.tryParse(value) ?? 0;
                                  },
                                  controller: _giaVonTextController,
                                  onTap: () {
                                    _giaVonTextController.selection =
                                        TextSelection(
                                            baseOffset: 0,
                                            extentOffset: _giaVonTextController
                                                .text.length);
                                  },
                                  textAlign: TextAlign.end,
                                  focusNode: _giaVonFocus,
                                  onEditingComplete: () {
                                    _giaVonFocus.unfocus();
                                    FocusScope.of(context)
                                        .requestFocus(_tenSpFocus);
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    CurrencyInputFormatter(),
                                  ],
                                  keyboardType:
                                      const TextInputType.numberWithOptions(),
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    hintText: "Nhập giá vốn",
                                    contentPadding: EdgeInsets.all(12),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          //Đơn vị mặc định
                          ListTile(
                            title: const Text("Đơn vị mặc định"),
                            subtitle: Text(viewModel.product?.uOM?.name ??
                                "Chọn đơn vị sản phẩm"),
                            trailing: const Icon(Icons.keyboard_arrow_right),
                            onTap: () async {
                              final ProductUOM result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const ProductUnitPage();
                                  },
                                ),
                              );
                              if (result != null) {
                                viewModel.selectUomCommand(result);
                                viewModel.selectUomPCommand(result);
                              }
                            },
                          ),
                          //Đơn vị mua
                          ListTile(
                            title: const Text("Đơn vị mua"),
                            subtitle: Text(viewModel.product?.uOMPO?.name ??
                                "Chọn đơn vị sản phẩm"),
                            trailing: const Icon(Icons.keyboard_arrow_right),
                            onTap: () async {
                              final ProductUOM result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ProductUnitPage(
                                      uomCateogoryId:
                                          viewModel.product.uOM.categoryId,
                                    );
                                  },
                                ),
                              );
                              if (result != null) {
                                viewModel.selectUomPCommand(result);
                              }
                            },
                          ),
                        ],
                      ),
                    ),

                    // Button
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              padding: const EdgeInsets.all(15),
                              color: Colors.green,
                              child: const Text(
                                "Lưu",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                save();
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: OutlineButton(
                              borderSide: const BorderSide(color: Colors.green),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              padding: const EdgeInsets.all(15),
                              child: const Text(
                                "Đóng",
                                style: TextStyle(color: Colors.green),
                              ),
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  String validateName(String value) {
    if (value.isEmpty) {
      return "Tên sản phẩm không được bỏ trống";
    }
    return null;
  }

  void _sendToServer() {
    if (_key.currentState.validate()) {
      // No any error in validation
      _key.currentState.save();
    } else {
      // validation error
      setState(() {
        _validate = true;
      });
    }
  }

  Future<void> save() async {
    viewModel.product.name = _tenSpTextController.text;
    viewModel.product.defaultCode = _maSpTextController.text.trim();
    viewModel.product.barcode = _maVachTextController.text.trim();
    viewModel.product.weight = double.tryParse(
        _khoiLuongTextController.text.trim().replaceAll(".", ""));
    viewModel.product.standardPrice =
        double.tryParse(_giaVonTextController.text.trim().replaceAll(".", ""));

    viewModel.product.lstPrice =
        double.tryParse(_giaBanTextController.text.trim().replaceAll(".", ""));
    _sendToServer();
    if (_tenSpTextController.text != "") {
//      await compute(viewModel.convertImageBase64, _image);
      await viewModel.save(_image);
      if (widget.onEditedProduct != null)
        widget.onEditedProduct(viewModel.product);
      if (closeWhenDone == true) {
        Navigator.pop(context, viewModel.product);
      }
    }
  }
}
