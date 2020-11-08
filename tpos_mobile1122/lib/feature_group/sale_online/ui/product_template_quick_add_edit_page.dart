/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'dart:async';
import 'dart:io';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/application/search_product_attribute_page.dart';
import 'package:tpos_mobile/feature_group/category/stock_change_product_quantity_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/product_category_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/product_unit_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/product_template_quick_add_edit_viewmodel.dart';
import 'package:tpos_mobile/helpers/barcode.dart';

import 'package:tpos_mobile/app.dart' as app;
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/helpers/tmt.dart';

import 'package:tpos_mobile/widgets/custom_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/form_field/input_number_field.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class ProductTemplateQuickAddEditPage extends StatefulWidget {
  const ProductTemplateQuickAddEditPage({this.closeWhenDone, this.productId});
  final bool closeWhenDone;
  final int productId;

  @override
  _ProductTemplateQuickAddEditPageState createState() =>
      _ProductTemplateQuickAddEditPageState(
          closeWhenDone: closeWhenDone, productId: productId);
}

class _ProductTemplateQuickAddEditPageState
    extends State<ProductTemplateQuickAddEditPage>
    with SingleTickerProviderStateMixin {
  _ProductTemplateQuickAddEditPageState(
      {this.closeWhenDone = false, this.productId});
  TabController _tabController;
  bool closeWhenDone;
  bool showAdd = false;
  bool edit = false;
  int productId;

  final GlobalKey<FormState> _key = GlobalKey();
  bool _validate = false;
  ProductTemplateQuickAddEditViewModel viewModel =
      ProductTemplateQuickAddEditViewModel();

  final TextEditingController _tenSpTextController = TextEditingController();
  final TextEditingController _maSpTextController = TextEditingController();
  final TextEditingController _maVachTextController = TextEditingController();
  final TextEditingController _khoiLuongTextController =
      TextEditingController();
  final MoneyMaskedTextController _giaBanTextController =
      MoneyMaskedTextController(
          decimalSeparator: '', precision: 0, thousandSeparator: '.');
  final MoneyMaskedTextController _giaVonTextController =
      MoneyMaskedTextController(
          decimalSeparator: '', precision: 0, thousandSeparator: '.');
  final TextEditingController _tonKhoController = TextEditingController();
  final TextEditingController _giaMuaMacDinhController =
      TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode _tenSpFocus = FocusNode();
  final FocusNode _maSpFocus = FocusNode();
  final FocusNode _maVachFocus = FocusNode();
  final FocusNode _khoiLuongFocus = FocusNode();
  final FocusNode _giaBanFocus = FocusNode();
  final FocusNode _giaVonFocus = FocusNode();
  final FocusNode _giaMuaMacDinhFocus = FocusNode();

  final decorateBox = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
  );

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    viewModel.product.id = productId;
    viewModel.init();
    viewModel.productStream.listen((product) {
      _tenSpTextController.text = viewModel.product.name;
      _maSpTextController.text = viewModel.product.defaultCode.toString();
      _maVachTextController.text = viewModel.product.barcode;
      _khoiLuongTextController.text = NumberFormat("###,###.###", App.locate)
          .format(viewModel.product.weight);
      _giaBanTextController.text =
          vietnameseCurrencyFormat(viewModel.product.listPrice);
      _giaVonTextController.text =
          vietnameseCurrencyFormat(viewModel.product.standardPrice);

      _tonKhoController.text = viewModel.product.initInventory.toString();

      _giaMuaMacDinhController.text =
          vietnameseCurrencyFormat(viewModel.product.purchasePrice);

      viewModel.isSaleOK = viewModel.product.saleOK;
      viewModel.isPurchaseOK = viewModel.product.purchaseOK;
      viewModel.isCombo = viewModel.product.isCombo;
      viewModel.isAvailableInPOS = viewModel.product.availableInPOS;
      viewModel.isEnableAll = viewModel.product.enableAll;
    });

    notifySubcrible = viewModel.notifyPropertyChangedController.listen((name) {
      setState(() {});
    });

    viewModel.dialogMessageController.listen((message) {
      registerDialogToView(context, message,
          scaffState: _scaffoldKey.currentState);
    });
    super.initState();

    viewModel.dialogMessageController.listen((message) {
      registerDialogToView(context, message,
          scaffState: _scaffoldKey.currentState);
    });
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
  void dispose() {
    notifySubcrible.cancel();
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
              icon: Icon(Icons.check),
              onPressed: () async {
                save();
              },
            ),
            PopupMenuButton(
              itemBuilder: (context) => <PopupMenuItem>[
                const PopupMenuItem(
                  child: Text("Sửa tồn kho thực tế"),
                  value: "edit_inventory",
                ),
              ],
              onSelected: (value) {
                switch (value) {
                  case "edit_inventory":
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StockChangeProductQuantityPage(
                          productTemplateId: viewModel.product?.id,
                        ),
                      ),
                    );
                    break;
                }
              },
            ),
          ],
          bottom: TabBar(
            unselectedLabelColor: Colors.white,
            labelColor: Colors.white,
            tabs: const [
              Tab(
                text: "Thông tin chung",
              ),
              Tab(
                text: "Biến thể",
              ),
            ],
            controller: _tabController,
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 53),
                child: TabBarView(
                  children: [
                    Container(color: Colors.grey.shade200, child: _showBody()),
                    _showBodyBienThe(),
                  ],
                  controller: _tabController,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 20,
                right: 20,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    padding: const EdgeInsets.all(15),
                    color: theme.primaryColor,
                    child: Text(
                      "LƯU",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      save();
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSelect() {
    return GestureDetector(
      onTap: () {
        setState(() {
          viewModel.product.imageUrl = null;
          _image = null;
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
                icon: Icon(Icons.add),
                onPressed: () async {},
              ),
            ),
          );
        });
      },
      child: Icon(
        Icons.close,
        color: Colors.white,
      ),
    );
  }

  Widget _showBody() {
    return StreamBuilder<ProductTemplate>(
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
                                  icon: Icon(Icons.add),
                                  onPressed: () async {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SimpleDialog(
                                            title: const Text("Menu"),
                                            children: <Widget>[
                                              ListTile(
                                                leading: Icon(Icons.camera),
                                                title: const Text(
                                                    "Chọn từ máy ảnh"),
                                                onTap: () {
                                                  getImage(ImageSource.camera);
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              ListTile(
                                                leading: Icon(Icons.image),
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
                      decoration: decorateBox,
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
                          const Divider(
                            height: 2,
                          ),
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
                          const Divider(
                            height: 2,
                          ),
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
                                  final barcode = await scanBarcode();
                                  if (barcode != null && !barcode.isError) {
                                    if (barcode.result != "") {
                                      setState(() {
                                        _maVachTextController.text =
                                            barcode.result;
                                      });
                                    }
                                  } else {
                                    app.App.showDefaultDialog(
                                        type: AlertDialogType.error,
                                        content: barcode.message,
                                        title: S.current.error);
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
                    // Loại sản phẩm
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: decorateBox,
                      child: Column(
                        children: <Widget>[
                          // Loại sản phẩm
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                const Expanded(
                                  flex: 3,
                                  child: Text(
                                    "Loại sản phẩm",
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
                                        viewModel.selectedProductType =
                                            newValue;
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
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(
                            height: 2,
                          ),
                          // Nhóm sản phẩm
                          ListTile(
                            title: const Text("Nhóm sản phẩm"),
                            subtitle: Text(viewModel.product?.categ?.name ??
                                "Chọn nhóm sản phẩm"),
                            trailing: Icon(Icons.keyboard_arrow_right),
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
                          const Divider(
                            height: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: decorateBox,
                      child: Column(
                        children: <Widget>[
                          // Khối lượng
                          Row(
                            children: <Widget>[
                              Icon(
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
                                  inputFormatters: [
                                    PercentInputFormat(
                                        locate: "vi_VN", format: "###,###.###"),
                                  ],
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
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
                          const Divider(
                            height: 2,
                          ),
                          // Giá bán
                          InputNumberField(
                              titleString: 'Giá bán',
                              hint: 'Nhập giá bán',
                              controller: _giaBanTextController,
                              icon: Icon(Icons.create),
                              hasPermission: viewModel.permissionPrice,
                              onTextChanged: (value) {
                                viewModel.product.listPrice =
                                    _giaVonTextController.numberValue;
                              }),
                          const Divider(height: 2),
                          // Giá vốn
                          InputNumberField(
                              titleString: 'Giá vốn',
                              hint: 'Nhập giá vốn',
                              controller: _giaVonTextController,
                              icon: Icon(Icons.create),
                              hasPermission: viewModel.permissionStandartPrice,
                              onTextChanged: (value) {
                                viewModel.product.standardPrice =
                                    _giaVonTextController.numberValue;
                              }),
                          const Divider(
                            height: 2,
                          ),
                          // Tồn kho

                          if (widget.productId == null)
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.attach_money,
                                  color: Colors.green,
                                ),
                                const Expanded(
                                  flex: 3,
                                  child: Text(
                                    "Tồn kho",
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: TextField(
                                    onChanged: (value) {
                                      viewModel.product.initInventory =
                                          App.convertToDouble(value, "vi_VN");
                                    },
                                    controller: _tonKhoController,
                                    onTap: () {
                                      _tonKhoController.selection =
                                          TextSelection(
                                              baseOffset: 0,
                                              extentOffset: _tonKhoController
                                                  .text.length);
                                    },
                                    textAlign: TextAlign.end,
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
                                      hintText: "Nhập tồn kho đầu",
                                      contentPadding: EdgeInsets.all(12),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          const Divider(
                            height: 2,
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.attach_money,
                                color: Colors.green,
                              ),
                              const Expanded(
                                flex: 3,
                                child: Text(
                                  "Giá mua mặc định",
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: TextField(
                                  controller: _giaMuaMacDinhController,
                                  onTap: () {
                                    _giaMuaMacDinhController.selection =
                                        TextSelection(
                                            baseOffset: 0,
                                            extentOffset:
                                                _giaMuaMacDinhController
                                                    .text.length);
                                  },
                                  textAlign: TextAlign.end,
                                  onEditingComplete: () {
                                    _giaMuaMacDinhFocus.unfocus();
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    CurrencyInputFormatter(),
                                  ],
                                  keyboardType:
                                      const TextInputType.numberWithOptions(),
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    hintText: "Nhập giá mua mặc định",
                                    contentPadding: EdgeInsets.all(12),
                                    border: InputBorder.none,
                                  ),
                                  focusNode: _giaMuaMacDinhFocus,
                                ),
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
                      decoration: decorateBox,
                      child: Column(
                        children: <Widget>[
                          //Đơn vị mặc định
                          ListTile(
                            title: const Text("Đơn vị mặc định"),
                            subtitle: Text(viewModel.product?.uOM?.name ??
                                "Chọn đơn vị sản phẩm"),
                            trailing: Icon(Icons.keyboard_arrow_right),
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
                            trailing: Icon(Icons.keyboard_arrow_right),
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
                          CheckboxListTile(
                            title: const Text("Hiệu lực"),
                            onChanged: (value) {
                              setState(() {
                                viewModel.product?.active = value;
                              });
                            },
                            value: viewModel.product?.active ?? false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    _buildOptionProduct()
                  ],
                ),
              ),
            ),
          );
        });
  }

  /// Có thể bán: SaleOK, Có thể mua: PucharseOK, Là combo : isCombo, Trên điểm bán hàng: AvailableInPOS, Cho phép bán trên các công ty khác: EnableAll
  Widget _buildOptionProduct() {
    return Container(
      decoration: decorateBox,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
            child: Text(
              "Cấu hình sản phẩm",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w700),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: CheckboxListTile(
                    title: const Text("Có thể bán"),
                    onChanged: (value) {
                      setState(() {
                        viewModel.isSaleOK = value;
                      });
                    },
                    value: viewModel.isSaleOK,
                    controlAffinity: ListTileControlAffinity.leading),
              ),
              Expanded(
                child: CheckboxListTile(
                    title: const Text("Có thể mua"),
                    onChanged: (value) {
                      setState(() {
                        viewModel.isPurchaseOK = value;
                      });
                    },
                    value: viewModel.isPurchaseOK,
                    controlAffinity: ListTileControlAffinity.leading),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: CheckboxListTile(
                    title: const Text("Là combo"),
                    onChanged: (value) {
                      setState(() {
                        viewModel.isCombo = value;
                      });
                    },
                    value: viewModel.isCombo,
                    controlAffinity: ListTileControlAffinity.leading),
              ),
              Expanded(
                child: CheckboxListTile(
                    title: const Text("Trên điểm bán hàng"),
                    onChanged: (value) {
                      setState(() {
                        viewModel.isAvailableInPOS = value;
                      });
                    },
                    value: viewModel.isAvailableInPOS,
                    controlAffinity: ListTileControlAffinity.leading),
              ),
            ],
          ),
          CheckboxListTile(
              title: const Text("Cho phép bán ở công ty khác"),
              onChanged: (value) {
                setState(() {
                  viewModel.isEnableAll = value;
                });
              },
              value: viewModel.isEnableAll,
              controlAffinity: ListTileControlAffinity.leading)
        ],
      ),
    );
  }

  Widget _showBodyBienThe() {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: viewModel.productAttributes != null
          ? SafeArea(
              child: Stack(
                children: <Widget>[
                  Visibility(
                    visible: showAdd,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 2),
                                blurRadius: 2,
                                color: Colors.grey[300])
                          ]),
                      height: 170,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            StreamBuilder<ProductAttribute>(
                                stream: viewModel.productAttributeStream,
                                initialData: viewModel.productAttribute,
                                builder: (context, snapshot) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SearchProductAttributePage(
                                                        "productAttribute"))).then(
                                            (value) {
                                          if (value != null) {
                                            viewModel.productAttribute = value;
                                            viewModel.deleteAllAttributeValue();
                                          }
                                        });
                                      },
                                      child: Container(
                                        height: 45,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            border: Border.all(
                                                color: Colors.grey[300])),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                snapshot.data.name ??
                                                    "Thuộc tính",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey[600]),
                                              ),
                                            ),
                                            Visibility(
                                              visible:
                                                  snapshot.data?.name != null,
                                              child: Container(
                                                width: 45,
                                                height: 45,
                                                child: InkWell(
                                                  onTap: () {
                                                    viewModel.productAttribute =
                                                        ProductAttribute(
                                                            name: null);
                                                  },
                                                  child: Icon(
                                                    Icons.close,
                                                    color: Colors.red,
                                                    size: 24,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 6,
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              size: 16,
                                              color: Colors.grey[600],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                            StreamBuilder<List<ProductAttribute>>(
                                stream: viewModel.productAttributeValuesStream,
                                initialData: viewModel.productAttributeValues,
                                builder: (context, snapshot) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0, right: 0),
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 50,
                                        padding: const EdgeInsets.only(
                                            left: 4, right: 0),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1,
                                                color: Colors.grey[400]),
                                            borderRadius:
                                                BorderRadius.circular(3)),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount:
                                                      snapshot.data != null
                                                          ? snapshot.data.length
                                                          : 0,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 2),
                                                      child: Center(
                                                        child: Container(
                                                          height: 35,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                          .grey[
                                                                      400])),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: <Widget>[
                                                              InkWell(
                                                                onTap: () {
                                                                  viewModel.deleteProductAttributeValue(
                                                                      snapshot.data[
                                                                          index]);
                                                                },
                                                                child: Icon(
                                                                  Icons.close,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                              ),
                                                              FilterChip(
//                          shadowColor: Colors.grey[500
                                                                label: Text(snapshot
                                                                        .data[
                                                                            index]
                                                                        .nameGet ??
                                                                    ''),
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,

                                                                onSelected:
                                                                    (bool
                                                                        value) {
//                                                        viewModel
//                                                            .deleteProductAttributeValue(
//                                                                snapshot.data[
//                                                                    index]);
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.green,
                                                  gradient: LinearGradient(
                                                      begin: Alignment.topRight,
                                                      end: Alignment.bottomLeft,
                                                      colors: [
                                                        Colors.blueGrey[400],
                                                        Colors.grey[400]
                                                      ])),
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              SearchProductAttributePage(
                                                                "productAttributeValue",
                                                                nameAttribute: viewModel
                                                                            .productAttribute ==
                                                                        null
                                                                    ? null
                                                                    : viewModel
                                                                        .productAttribute
                                                                        .name,
                                                              ))).then((value) {
                                                    if (value != null) {
                                                      viewModel
                                                              .productAttributeValuess =
                                                          value;
                                                    }
                                                  });
                                                },
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                          ],
                                        )),
                                  );
                                }),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  height: 30,
                                  width: 100,
                                  child: RaisedButton(
                                      color: Colors.grey[200],
                                      onPressed: () {
                                        viewModel.cancelAddEdit();
                                        setState(() {
                                          if (!edit) {
                                            showAdd = false;
                                          }
                                          edit = false;
                                        });
                                      },
                                      child: Text(
                                        "Hủy",
                                        style:
                                            TextStyle(color: Colors.grey[700]),
                                      )),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Container(
                                  height: 30,
                                  width: 100,
                                  color: const Color(0xFF28A745),
                                  child: RaisedButton(
                                      onPressed: () {
                                        if (viewModel.productAttribute.name !=
                                            null) {
                                          if (edit) {
                                            viewModel.editBienThe();
                                            setState(() {
                                              edit = false;
                                            });
                                          } else {
                                            viewModel.addBienThe();
                                          }
                                        }
                                      },
                                      child: Text(
                                        edit ? "Cập nhật" : "Thêm",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  StreamBuilder<List<ProductAttributeLine>>(
                      stream: viewModel.productAttributeListStream,
                      initialData: viewModel.productAttributes,
                      builder: (context, snapshot) {
                        return Padding(
                          padding: showAdd
                              ? const EdgeInsets.only(top: 172)
                              : const EdgeInsets.only(top: 2),
                          child: ListView.builder(
                              itemCount: viewModel.productAttributes.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            offset: const Offset(0, 2),
                                            blurRadius: 2,
                                            color: Colors.grey[300])
                                      ]),
                                  child: Dismissible(
                                    background: Container(
                                      color: Colors.green,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              "Xóa dòng này?",
                                              style: TextStyle(
                                                  color: Colors.white),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Icon(
                                            Icons.delete_forever,
                                            color: Colors.red,
                                            size: 30,
                                          )
                                        ],
                                      ),
                                    ),
                                    direction: DismissDirection.endToStart,
                                    key: UniqueKey(),
                                    confirmDismiss: (direction) async {
                                      viewModel.removeAttribute(
                                          viewModel.productAttributes[index]);
                                      return true;
                                    },
                                    child: InkWell(
                                      onTap: () {
                                        viewModel.addAllAttributeValue(viewModel
                                            .productAttributes[index]
                                            .attributeValues);
                                        viewModel.productAttribute = viewModel
                                            .productAttributes[index]
                                            .productAttribute;
                                        setState(() {
                                          showAdd = true;
                                          edit = true;
                                          viewModel.indexEdit = index;
                                        });
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          const SizedBox(
                                            width: 12,
                                          ),
                                          Text(
                                            viewModel.productAttributes[index]
                                                        .productAttribute !=
                                                    null
                                                ? viewModel
                                                    .productAttributes[index]
                                                    .productAttribute
                                                    .name
                                                : "",
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.green),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          SizedBox(
                                            child: Container(
                                              color: Colors.grey[300],
                                              height: 16,
                                              width: 1,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Expanded(
                                            child: Wrap(
                                                children: viewModel
                                                    .productAttributes[index]
                                                    .attributeValues
                                                    .map((item) {
                                              print(item.name);
                                              return Container(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: ChoiceChip(
                                                  label: Text(
                                                      "${item.attributeName} : ${item.name}"),
                                                  selected: true,
                                                  onSelected: (selected) {
                                                    setState(() {});
                                                  },
                                                ),
                                              );
                                            }).toList()),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        );
                      }),
                ],
              ),
            )
          : emptyProductAttributes(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
        onPressed: () {
          setState(() {
            showAdd = true;
            edit = false;
          });
        },
      ),
    );
  }

  Widget emptyProductAttributes() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 70,
            width: 70,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Transform.scale(
                scale: 1.65,
//                child: FlareActor(
//                  "images/empty_state.flr",
//                  alignment: Alignment.center,
//                  fit: BoxFit.fitWidth,
//                  animation: "idle",
//                ),
                child: Icon(Icons.outlined_flag),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Không có dữ liệu",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          RaisedButton(
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.add),
                const Text("Thêm một dòng"),
              ],
            ),
            onPressed: () {
              setState(() {
                showAdd = !showAdd;
                viewModel.productAttributes = [];
              });
            },
          ),
        ],
      ),
    );
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

    final String khoiLuong = _khoiLuongTextController.text.trim();
    viewModel.product.weight = App.convertToDouble(khoiLuong, "vi_VN");
    viewModel.product.standardPrice =
        double.tryParse(_giaVonTextController.text.trim().replaceAll(".", ""));

    viewModel.product.listPrice =
        double.tryParse(_giaBanTextController.text.trim().replaceAll(".", ""));
    viewModel.product.purchasePrice = double.tryParse(
        _giaMuaMacDinhController.text.trim().replaceAll(".", ""));
    if (_tabController.index == 0) {
      _sendToServer();
    }
    if (_tenSpTextController.text != "") {
//      await compute(viewModel.convertImageBase64, _image);
      await viewModel.save(_image);
      if (closeWhenDone == true) {
        Navigator.pop(context, viewModel.product);
      }
    }
  }
}
