import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/ui/attribute_value/product_attribute_search_page.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/ui/product_attribute_line_action_page.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/add_edit/product_template_add_edit_bloc.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/add_edit/product_template_add_edit_event.dart';
import 'package:tpos_mobile/resources/app_colors.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

///Giao diện tab biến thể của [ProductTemplateAddEditPage]
class AttributesTab extends StatefulWidget {
  const AttributesTab({Key key, this.productTemplate}) : super(key: key);

  @override
  _AttributesTabState createState() => _AttributesTabState();
  final ProductTemplate productTemplate;
}

class _AttributesTabState extends State<AttributesTab> with AutomaticKeepAliveClientMixin {
  ProductTemplate _productTemplate;

  ProductTemplateAddEditBloc _productTemplateAddEditBloc;

  bool _isInsert = false;

  ProductAttribute _productAttributeLine;
  ProductAttribute _productAttributeLineEdit;

  int _indexEdit = 0;
  List<ProductAttributeValue> _productAttributes = [];

  @override
  void initState() {
    super.initState();
    _productTemplateAddEditBloc = BlocProvider.of<ProductTemplateAddEditBloc>(context);
    _productTemplate = widget.productTemplate;
  }

  @override
  void didUpdateWidget(covariant AttributesTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    _productTemplate = widget.productTemplate;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(
              children: [
                if (_productTemplate.productAttributeLines.isEmpty) _buildEmpty() else _buildAttributesGroup(),
                if (_isInsert) _buildInsertGroup() else if (_productAttributeLineEdit != null) _buildEditGroup(),
                const SizedBox(height: 200)
              ],
            ),
          ),
        ),
        Positioned(
          right: 10,
          bottom: 110,
          child: ClipOval(
            child: Container(
              width: 56,
              height: 56,
              child: Material(
                color: const Color(0xff28A745),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    _insert();
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _insert() {
    _isInsert = true;
    _productAttributeLineEdit = null;
    _productAttributes = [];
    setState(() {});
  }

  ///Xây dựng giao diện khi không có biến thể
  Widget _buildEmpty() {
    return _buildGroup(
        child: Column(
      children: [
        SvgPicture.asset('assets/icon/empty_attributes.svg'),
        const SizedBox(height: 10),
        Text(S.of(context).productHasNoProperty, style: const TextStyle(color: Color(0xff929DAA), fontSize: 15)),
        const SizedBox(height: 30),
        Container(color: Colors.grey.shade200, height: 1, width: double.infinity),
        const SizedBox(height: 10),
        AppButton(
          width: double.infinity,
          background: Colors.transparent,
          onPressed: () {
            _insert();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, color: Color(0xff28A745)),
              Text(S.of(context).addNew,
                  style: const TextStyle(color: Color(0xff28A745), fontSize: 15, fontWeight: FontWeight.w500)),
            ],
          ),
        )
      ],
    ));
  }

  ///Xây dựng giao diện nhóm gồm danh sách biển thể và nút thêm mới
  Widget _buildAttributesGroup() {
    return _buildGroup(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(S.of(context).attributes.toUpperCase(), style: const TextStyle(color: Color(0xff28A745))),
      const SizedBox(height: 10),
      _buildAttributes(),
      const SizedBox(height: 10),
      AppButton(
        onPressed: () {
          _insert();
        },
        width: double.infinity,
        background: Colors.transparent,
        child: Row(
          children: [
            const Icon(Icons.add, color: Color(0xff28A745)),
            Text(S.of(context).addNew,
                style: const TextStyle(color: Color(0xff28A745), fontSize: 15, fontWeight: FontWeight.w500)),
          ],
        ),
      )
    ]));
  }

  ///Xây dựng giao diện danh sách biên thể
  Widget _buildAttributes() {
    return Column(
        children: _productTemplate.productAttributeLines
            .map((ProductAttribute productAttributeLine) => _buildAttribute(productAttributeLine))
            .toList());
  }

  ///Xây dựng giao diện thêm biến thể
  Widget _buildInsertGroup() {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: _buildGroup(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(S.of(context).addNewParam(S.of(context).attribute).toUpperCase(),
                  style: const TextStyle(color: Color(0xff28A745))),
              const SizedBox(height: 10),
              InkWell(
                onTap: () async {
                  final ProductAttributeValue result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const ProductAttributeLineActionPage(isSearch: true);
                      },
                    ),
                  );

                  if (result != null) {
                    _productAttributeLine =
                        ProductAttribute(productAttribute: result, attributeId: result.id, attributeValues: []);
                    _productAttributes = [];
                    setState(() {});
                  }
                },
                child: Row(
                  children: [
                    Expanded(
                        child: Text(S.of(context).attribute,
                            style: const TextStyle(color: Color(0xff2C333A), fontSize: 17))),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (_productAttributeLine != null)
                            Row(
                              children: [
                                Text(
                                    _productAttributeLine != null
                                        ? _productAttributeLine.productAttribute != null
                                            ? _productAttributeLine.productAttribute.name ??
                                                S.of(context).selectParam(S.of(context).attribute.toLowerCase())
                                            : S.of(context).selectParam(S.of(context).attribute.toLowerCase())
                                        : S.of(context).selectParam(S.of(context).attribute.toLowerCase()),
                                    style: const TextStyle(color: Color(0xff929DAA), fontSize: 15)),
                                IconButton(
                                    icon: const Icon(Icons.close, color: Color(0xffEB3B5B)),
                                    onPressed: () {
                                      _productAttributeLine = null;
                                      setState(() {});
                                    })
                              ],
                            )
                          else
                            Text(
                                _productAttributeLine != null
                                    ? _productAttributeLine.name ??
                                        S.of(context).selectParam(S.of(context).attribute.toLowerCase())
                                    : S.of(context).selectParam(S.of(context).attribute.toLowerCase()),
                                style: const TextStyle(color: Color(0xff929DAA), fontSize: 15)),
                          const SizedBox(width: 10),
                          const Padding(
                            padding: EdgeInsets.only(top: 3),
                            child: Icon(Icons.arrow_forward_ios, size: 15, color: Color(0xff929DAA)),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(color: Colors.grey.shade200, height: 1, width: double.infinity),
              const SizedBox(height: 10),
              InkWell(
                onTap: () async {
                  if (_productAttributeLine != null) {
                    final ProductAttributeValue result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ProductAttributeValueSearchPage(
                            attributeId: _productAttributeLine.productAttribute.id,
                          );
                        },
                      ),
                    );

                    if (result != null) {
                      if (!_productAttributes
                          .any((ProductAttributeValue productAttribute) => productAttribute.id == result.id)) {
                        _productAttributes.add(result);
                        setState(() {});
                      }
                    }
                  }
                },
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(S.of(context).attributeValue,
                            style: const TextStyle(color: Color(0xff2C333A), fontSize: 17)),
                        if (_productAttributeLine != null && _productAttributes.isNotEmpty)
                          Container(
                            height: 50,
                            width: double.infinity,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  padding: const EdgeInsets.only(left: 10, right: 10, top: 0),
                                  margin: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(20)), color: Color(0xffF0F1F3)),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(_productAttributes[index].nameGet,
                                          style: const TextStyle(color: Color(0xff2C333A), fontSize: 13)),
                                      ClipOval(
                                        child: Container(
                                          width: 30,
                                          height: 30,
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
                                                _productAttributes.removeAt(index);
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
                              itemCount: _productAttributes.length,
                            ),
                          )
                        else
                          Text(S.of(context).selectParam(S.of(context).value.toLowerCase()),
                              style: const TextStyle(color: Color(0xff929DAA), fontSize: 15)),
                      ],
                    )),
                    const Icon(Icons.arrow_forward_ios, size: 15, color: Color(0xff929DAA)),
                    const SizedBox(width: 10)
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      borderRadius: 8,
                      height: 40,
                      onPressed: () {
                        _productAttributeLine = null;
                        _productAttributes = [];
                        _isInsert = false;
                        _productTemplateAddEditBloc
                            .add(ProductTemplateAddEditUpdateLocal(productTemplate: _productTemplate));
                      },
                      background: const Color(0xffF0F1F3),
                      child: Text(
                        S.of(context).cancel,
                        style: const TextStyle(color: Color(0xff2C333A), fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppButton(
                      height: 40,
                      borderRadius: 8,
                      onPressed: () {
                        if (_productAttributeLine != null) {
                          _productAttributeLine.attributeValues.clear();
                          _productAttributeLine.attributeValues.addAll(_productAttributes);
                          _productTemplate.productAttributeLines.add(_productAttributeLine);

                          _productAttributeLine = null;
                          _productAttributes = [];
                          _isInsert = false;
                          _productTemplateAddEditBloc
                              .add(ProductTemplateAddEditUpdateLocal(productTemplate: _productTemplate));
                        } else {
                          App.showToast(
                              title: S.of(context).selectParam(S.of(context).attribute.toLowerCase()),
                              type: AlertDialogType.error);
                        }
                      },
                      background: const Color(0xff28A745),
                      child: Text(
                        S.of(context).save,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              )
            ],
          )),
        );
      },
    );
  }

  ///Xây dựng giao diện sửa biến thể
  Widget _buildEditGroup() {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: _buildGroup(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(S.of(context).editParam(S.of(context).attribute).toUpperCase(),
                  style: const TextStyle(color: Color(0xff28A745))),
              const SizedBox(height: 10),
              InkWell(
                onTap: () async {
                  final ProductAttributeValue result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const ProductAttributeLineActionPage(isSearch: true);
                      },
                    ),
                  );

                  if (result != null) {
                    _productAttributeLineEdit =
                        ProductAttribute(productAttribute: result, attributeId: result.id, attributeValues: []);
                    _productAttributes = [];
                    setState(() {});
                  }
                },
                child: Row(
                  children: [
                    Expanded(
                        child: Text(S.of(context).attribute,
                            style: const TextStyle(color: Color(0xff2C333A), fontSize: 17))),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (_productAttributeLineEdit != null)
                            Row(
                              children: [
                                Text(
                                    _productAttributeLineEdit != null
                                        ? _productAttributeLineEdit.productAttribute.name ??
                                            S.of(context).selectParam(S.of(context).attribute.toLowerCase())
                                        : S.of(context).selectParam(S.of(context).attribute.toLowerCase()),
                                    style: const TextStyle(color: Color(0xff929DAA), fontSize: 15)),
                                IconButton(
                                    icon: const Icon(Icons.close, color: Color(0xffEB3B5B)),
                                    onPressed: () {
                                      _productAttributeLineEdit = null;
                                      setState(() {});
                                    })
                              ],
                            )
                          else
                            Text(
                                _productAttributeLineEdit != null
                                    ? _productAttributeLineEdit.productAttribute.name ??
                                        S.of(context).selectParam(S.of(context).attribute.toLowerCase())
                                    : S.of(context).selectParam(S.of(context).attribute.toLowerCase()),
                                style: const TextStyle(color: Color(0xff929DAA), fontSize: 15)),
                          const SizedBox(width: 10),
                          const Padding(
                            padding: EdgeInsets.only(top: 3),
                            child: Icon(Icons.arrow_forward_ios, size: 15, color: Color(0xff929DAA)),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(color: Colors.grey.shade200, height: 1, width: double.infinity),
              const SizedBox(height: 10),
              InkWell(
                onTap: () async {
                  if (_productAttributeLineEdit != null) {
                    final ProductAttributeValue result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ProductAttributeValueSearchPage(
                            attributeId: _productAttributeLineEdit.productAttribute.id,
                          );
                        },
                      ),
                    );

                    if (result != null) {
                      if (!_productAttributes
                          .any((ProductAttributeValue productAttribute) => productAttribute.id == result.id)) {
                        _productAttributes.add(result);
                        setState(() {});
                      }
                    }
                  }
                },
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(S.of(context).attributeValue,
                            style: const TextStyle(color: Color(0xff2C333A), fontSize: 17)),
                        if (_productAttributeLineEdit != null && _productAttributes.isNotEmpty)
                          Container(
                            height: 50,
                            width: double.infinity,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  padding: const EdgeInsets.only(left: 10, right: 10, top: 0),
                                  margin: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(13)), color: Color(0xffF0F1F3)),
                                  child: Row(
                                    children: [
                                      Text(
                                        _productAttributes[index].nameGet,
                                        style: const TextStyle(color: Color(0xff2C333A), fontSize: 13),
                                      ),
                                      ClipOval(
                                        child: Container(
                                          width: 30,
                                          height: 30,
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
                                                _productAttributes.removeAt(index);
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
                              itemCount: _productAttributes.length,
                            ),
                          )
                        else
                          Text(S.of(context).selectParam(S.of(context).value.toLowerCase()),
                              style: const TextStyle(color: Color(0xff929DAA), fontSize: 15)),
                      ],
                    )),
                    const Icon(Icons.arrow_forward_ios, size: 15, color: Color(0xff929DAA)),
                    const SizedBox(width: 10)
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      borderRadius: 8,
                      height: 40,
                      onPressed: () {
                        _productAttributeLine = null;
                        _productAttributes = [];
                        _isInsert = false;
                        _productAttributeLineEdit = null;
                        _productTemplateAddEditBloc
                            .add(ProductTemplateAddEditUpdateLocal(productTemplate: _productTemplate));
                      },
                      background: const Color(0xffF0F1F3),
                      child: Text(
                        S.of(context).cancel,
                        style: const TextStyle(color: Color(0xff2C333A), fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppButton(
                      height: 40,
                      borderRadius: 8,
                      onPressed: () {
                        if (_productAttributeLineEdit != null) {
                          _productAttributeLineEdit.attributeValues.clear();
                          _productAttributeLineEdit.attributeValues = _productAttributes;

                          _productTemplate.productAttributeLines[_indexEdit] = _productAttributeLineEdit;
                          _productAttributeLineEdit = null;
                          _productAttributes = [];
                          _isInsert = false;
                          _productTemplateAddEditBloc
                              .add(ProductTemplateAddEditUpdateLocal(productTemplate: _productTemplate));
                        } else {
                          App.showToast(
                              title: S.of(context).selectParam(S.of(context).attribute.toLowerCase()),
                              type: AlertDialogType.error);
                        }
                      },
                      background: const Color(0xff28A745),
                      child: Text(
                        S.of(context).save,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              )
            ],
          )),
        );
      },
    );
  }

  Widget _buildAttribute(ProductAttribute productAttributeLine) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: 90,
                  child: Text(productAttributeLine.productAttribute.name ?? '',
                      style: const TextStyle(color: Color(0xff2C333A), fontSize: 17))),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                        margin: const EdgeInsets.only(top: 5, bottom: 5),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(13)), color: Color(0xffF0F1F3)),
                        child: Text(
                          productAttributeLine.attributeValues[index].nameGet,
                          style: const TextStyle(color: Color(0xff2C333A), fontSize: 13),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(width: 10);
                    },
                    itemCount: productAttributeLine.attributeValues.length,
                  ),
                ),
              ),
              ClipOval(
                child: Container(
                  height: 50,
                  width: 50,
                  child: Material(
                    color: Colors.transparent,
                    child: IconButton(
                      iconSize: 30,
                      icon: const Icon(
                        Icons.more_vert,
                        size: 25,
                        color: Color(0xff858F9B),
                      ),
                      onPressed: () {
                        showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return _buildBottomSheet(context, productAttributeLine);
                            });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(color: Colors.grey.shade200, height: 1, width: double.infinity),
          const SizedBox(height: 10),
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

  ///Xây dựng giao diện bottom sheet
  Widget _buildBottomSheet(BuildContext context, ProductAttribute productAttributeLine) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: AppButton(
              background: Colors.transparent,
              onPressed: () {
                _productAttributeLineEdit = productAttributeLine;
                _indexEdit = _productTemplate.productAttributeLines.indexOf(productAttributeLine);
                _productAttributes = _productAttributeLineEdit.attributeValues;
                _isInsert = false;
                setState(() {});
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  const Icon(Icons.edit_sharp, color: Color(0xff929DAA), size: 23),
                  const SizedBox(width: 10),
                  Text(
                    S.of(context).edit,
                    style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: AppButton(
              background: Colors.transparent,
              onPressed: () async {
                final bool result = await showGeneralDialog(
                  useRootNavigator: true,
                  pageBuilder: (context, animation, secondAnimation) {
                    return AlertDialog(
                      title: Text(S.current.confirm),
                      content: Text(S.of(context).deleteThisConfirmParam(S.of(context).variant.toLowerCase())),
                      actions: [
                        RaisedButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          color: AppColors.backgroundColor,
                          child: Text(S.current.cancel),
                        ),
                        RaisedButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: Text(S.current.confirm),
                          color: AppColors.brand3,
                          textColor: Colors.white,
                        ),
                      ],
                    );
                  },
                  context: context,
                );

                if (result != null && result) {
                  _productTemplate.productAttributeLines.remove(productAttributeLine);
                  Navigator.pop(context);
                }
              },
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  const Icon(Icons.delete, size: 23, color: Colors.red),
                  const SizedBox(width: 10),
                  Text(
                    S.of(context).deleteParam(S.of(context).attribute.toLowerCase()),
                    style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
