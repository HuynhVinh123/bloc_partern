import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/product_category_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/product_category_add_edit_viewmodel.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/app_core/ui_base/ui_vm_base.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class ProductCategoryAddEditPage extends StatefulWidget {
  const ProductCategoryAddEditPage(
      {this.closeWhenDone, this.productCategoryId, this.onEdited});
  final int productCategoryId;
  final bool closeWhenDone;
  final Function(ProductCategory) onEdited;

  @override
  _ProductCategoryAddEditPageState createState() =>
      _ProductCategoryAddEditPageState();
}

class _ProductCategoryAddEditPageState
    extends State<ProductCategoryAddEditPage> {
  _ProductCategoryAddEditPageState();

  ProductCategoryAddEditViewModel viewModel = ProductCategoryAddEditViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _key = GlobalKey();
  bool _validate = false;

  final TextEditingController _nameTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return UIViewModelBase(
      viewModel: viewModel,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: widget.productCategoryId == null
              ? Text(S.current.productGroup_AddProductCategory)
              : Text(S.current.productGroup_EditProductCategory),
          actions: <Widget>[
            FlatButton.icon(
              label: Text(S.current.save),
              textColor: Colors.white,
              icon: const Icon(Icons.check),
              onPressed: () async {
                viewModel.productCategory.name =
                    _nameTextEditingController.text.trim();
                _sendToServer();
                if (_nameTextEditingController.text != "") {
                  await viewModel.save();
                  if (widget.closeWhenDone == true) {
                    Navigator.pop(context, viewModel.productCategory);
                  }
                }
                if (widget.onEdited != null)
                  widget.onEdited(viewModel.productCategory);
              },
            ),
          ],
        ),
        body: Container(color: Colors.grey.shade200, child: _showBody()),
      ),
    );
  }

  Widget _showBody() {
    return StreamBuilder<ProductCategory>(
      stream: viewModel.productCategoryStream,
      initialData: viewModel.productCategory,
      builder: (context, snapshot) {
        return Form(
          key: _key,
          autovalidate: _validate,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Text(
                  S.current.productGroup_note,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
                const Divider(),
                TextFormField(
                  controller: _nameTextEditingController,
                  autofocus: false,
                  onEditingComplete: () {},
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(5),
                    icon: const Icon(Icons.sort),
                    labelText: S.current.groupName,
                  ),
                  validator: validateName,
                ),
                const Divider(),
                // Nhóm sản phẩm
                ListTile(
                  title: Text(S.current.parentGroup),
                  subtitle: Text(viewModel.productCategory?.parent?.name ??
                      S.current.chooseParentGroup),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                  onTap: () async {
                    final ProductCategory result = await Navigator.push(
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
                Row(
                  children: <Widget>[
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isDense: true,
                          hint: Text(S.current.priceList),
                          value: viewModel.selectedPrice,
                          onChanged: (String newValue) {
                            setState(() {
                              viewModel.selectedPrice = newValue;
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
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: StreamBuilder(
                        stream: viewModel.productCategoryQuantityStream,
                        initialData: viewModel.ordinalNumber,
                        builder: (_, data) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                "${S.current.productGroup_position}: ${viewModel.ordinalNumber} ",
                                style: const TextStyle(fontSize: 16.0),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    width: 30,
                                    height: 20,
                                    child: RaisedButton(
                                      padding: const EdgeInsets.all(0),
                                      child:
                                          const Icon(Icons.keyboard_arrow_up),
                                      onPressed: () {
                                        viewModel.ordinalNumber += 1;
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    child: RaisedButton(
                                      child: const Icon(
                                        Icons.keyboard_arrow_down,
                                      ),
                                      padding: const EdgeInsets.all(0),
                                      onPressed: () {
                                        if (viewModel.ordinalNumber > 0)
                                          viewModel.ordinalNumber -= 1;
                                      },
                                    ),
                                    width: 30,
                                    height: 20,
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    value: viewModel.isActive,
                    title: Text(S.current.productGroup_showOnPosOfSale),
                    onChanged: (bool value) {
                      viewModel.isCheckActive(value);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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

  String validateName(String value) {
    if (value.isEmpty) {
      return S.current.mailTemplate_GroupNameCannotBeEmpty;
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

  @override
  void initState() {
    viewModel.productCategory.id = widget.productCategoryId;
    viewModel.init();
    viewModel.productCategoryStream.listen((productCategory) {
      _nameTextEditingController.text = viewModel.productCategory.name;
    });

    super.initState();
  }

  @override
  void dispose() {
    viewModel.dispose();
    notifySubcrible.cancel();
    super.dispose();
  }
}
