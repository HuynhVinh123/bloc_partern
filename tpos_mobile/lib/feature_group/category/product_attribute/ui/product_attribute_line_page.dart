import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/bloc/product_attribute_line/product_attribute_line_bloc.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/bloc/product_attribute_line/product_attribute_line_event.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/bloc/product_attribute_line/product_attribute_line_state.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/ui/attribute_value/product_attribute_value_view_page.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/ui/product_attribute_line_action_page.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/ui/product_attribute_value_add_edit_page.dart';
import 'package:tpos_mobile/resources/app_colors.dart';
import 'package:tpos_mobile/widgets/bloc_widget/base_bloc_listener_ui.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/custom_expand_tile.dart';
import 'package:tpos_mobile/widgets/custom_snack_bar.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/dialog/number_input_dialog.dart';
import 'package:tpos_mobile/widgets/load_status.dart';
import 'package:tpos_mobile/widgets/search_app_bar.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

///Nếu [productTemplate] khác [null] thì danh sách sẽ hiện các biến thể thuộc sản phẩm này
///không thể thêm mới và sửa
///Nếu [productTemplate] bằng [null] thì danh sách sẽ hiện thị tất cả biến thể, có thể thêm mới và sửa
///Nếu [isSearch] nhấn vào các item sẽ trả về đổi tượng cho màn hình trước
class ProductAttributeLinePage extends StatefulWidget {
  const ProductAttributeLinePage({Key key, this.productTemplate, this.isSearch = false}) : super(key: key);

  @override
  _ProductAttributeLinePageState createState() => _ProductAttributeLinePageState();
  final ProductTemplate productTemplate;
  final bool isSearch;
}

class _ProductAttributeLinePageState extends State<ProductAttributeLinePage> {
  ProductAttributeLineBloc _productAttributeLineBloc;
  String _keyword = '';
  ProductAttribute _productAttribute;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  bool _isLoad = false;

  @override
  void initState() {
    super.initState();
    _productAttributeLineBloc = ProductAttributeLineBloc();
    _productAttributeLineBloc.add(ProductAttributeLineStarted(productTemplate: widget.productTemplate));
  }

  @override
  void dispose() {
    _productAttributeLineBloc.close();
    _nameController.dispose();
    _codeController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildAppBar() {
    return PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SearchAppBar(
          title: S.of(context).attributeValue,
          text: _keyword,
          onKeyWordChanged: (String keyword) {
            if (_keyword != keyword) {
              _keyword = keyword;
              _productAttributeLineBloc.add(ProductAttributeLineSearched(keyword: keyword));
            }
          },
          actions: widget.productTemplate == null
              ? [
                  ClipOval(
                    child: Container(
                      height: 50,
                      width: 50,
                      child: Material(
                        color: Colors.transparent,
                        child: IconButton(
                          iconSize: 25,
                          icon: const Icon(
                            Icons.folder_open_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const ProductAttributeLineActionPage();
                                },
                              ),
                            );
                          },
                        ),
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
                            Icons.add,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            if (_isLoad) {
                              showModalBottomSheet<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return _buildBottomSheet(context);
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              );
                            } else {
                              App.showDefaultDialog(
                                  title: S.of(context).error,
                                  context: context,
                                  type: AlertDialogType.error,
                                  content: S.of(context).canNotGetData);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ]
              : null,
        ));
  }

  Widget _buildBody() {
    return BaseBlocListenerUi<ProductAttributeLineBloc, ProductAttributeLineState>(
      bloc: _productAttributeLineBloc,
      loadingState: ProductAttributeLineLoading,
      busyState: ProductAttributeLineBusy,
      errorState: ProductAttributeLineLoadFailure,
      errorBuilder: (BuildContext context, ProductAttributeLineState state) {
        String error = S.of(context).canNotGetDataFromServer;
        if (state is ProductAttributeLineLoadFailure) {
          error = state.error ?? S.of(context).canNotGetDataFromServer;
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50 * (MediaQuery.of(context).size.height / 700)),
              LoadStatusWidget(
                statusName: S.of(context).loadDataError,
                content: error,
                statusIcon: SvgPicture.asset('assets/icon/error.svg', width: 170, height: 130),
                action: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: AppButton(
                    onPressed: () {
                      _productAttributeLineBloc
                          .add(ProductAttributeLineStarted(productTemplate: widget.productTemplate));
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
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
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
      },
      listener: (BuildContext context, ProductAttributeLineState state) {
        if (state is ProductAttributeValueDeleteSuccess) {
          final Widget snackBar = getCloseableSnackBar(message: S.of(context).deleteSuccessful, context: context);
          Scaffold.of(context).showSnackBar(snackBar);
        } else if (state is ProductAttributeValueDeleteSuccess) {
          final Widget snackBar = getCloseableSnackBar(
              message: S.of(context).addSuccessfulParam(S.current.attributeValue.toLowerCase()), context: context);
          Scaffold.of(context).showSnackBar(snackBar);
        } else if (state is ProductAttributeLineLoadSuccess) {
          _isLoad = true;
        }
      },
      builder: (BuildContext context, ProductAttributeLineState state) {
        return state.productAttributes.isEmpty ? _buildEmptyList() : _buildAttributes(state.productAttributes);
      },
    );
  }

  Widget _buildAttributes(List<ProductAttribute> attributes) {
    return ListView.separated(
      itemCount: attributes.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildAttributeItem(attributes[index]);
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 0);
      },
    );
  }

  ///Xây dựng giao diện trống
  Widget _buildEmptyList() {
    return _keyword != ''
        ? SingleChildScrollView(
            child: Column(
            children: [
              SizedBox(height: 50 * (MediaQuery.of(context).size.height / 700)),
              LoadStatusWidget(
                statusName: S.of(context).noData,
                content: S.of(context).searchNotFoundWithKeywordParam(_keyword, S.of(context).attributeValues),
                statusIcon: SvgPicture.asset('assets/icon/no-result.svg', width: 170, height: 130),
              ),
            ],
          ))
        : SingleChildScrollView(
            child: Column(
            children: [
              SizedBox(height: 50 * (MediaQuery.of(context).size.height / 700)),
              LoadStatusWidget.empty(
                statusName: S.of(context).noData,
                content: S.of(context).emptyNotificationParam(S.of(context).attributeValue.toLowerCase()),
                action: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: AppButton(
                    onPressed: () async {
                      final ProductAttributeValue productAttributeLine = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const ProductAttributeValueAddEditPage();
                          },
                        ),
                      );

                      if (productAttributeLine != null) {
                        setState(() {
                          _keyword = '';
                        });
                        _productAttributeLineBloc.add(ProductAttributeLineRefreshed());
                      }
                    },
                    width: null,
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 40, 167, 69),
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 23,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            S.of(context).addNewParam(S.of(context).attributeValue.toLowerCase()),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ));
  }

  ///Xây dựng giao diện giá trị thuộc tính
  Widget _buildProductAttributeLine(ProductAttribute attribute) {
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () {},
          contentPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 5, top: 5),
          title: Text(attribute.name ?? '', textAlign: TextAlign.start),
          leading: CircleAvatar(
            backgroundColor: const Color(0xffE9F6EC),
            child: Text(
              attribute != null && attribute.name != '' ? attribute.name.substring(0, 1) : '',
              style: const TextStyle(color: Color(0xff28A745)),
            ),
          ),
        ),
        Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            color: Colors.grey.shade200,
            height: 1,
            width: double.infinity),
      ],
    );
  }

  ///Xây dựng giao diện danh sách thuộc tính
  Widget _buildAttributeValues(ProductAttribute attribute) {
    return Column(
        children: attribute.attributeValues
            .map((ProductAttributeValue productAttributeValue) => _buildSlidable(
                  key: ValueKey<String>("ProductAttributeValue${productAttributeValue.id}"),
                  onEdit: () async {
                    final ProductAttributeValue result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ProductAttributeValueAddEditPage(productAttributeLine: productAttributeValue);
                        },
                      ),
                    );

                    if (result != null) {
                      _productAttributeLineBloc.add(ProductAttributeLineRefreshed());
                    }
                  },
                  onDelete: () async {
                    final bool result = await App.showConfirm(
                        title: S.of(context).confirmDelete,
                        content: S.of(context).deleteSelectConfirmParam(S.of(context).attributeValue.toLowerCase()));

                    if (result != null && result) {
                      _productAttributeLineBloc
                          .add(ProductAttributeValueDeleted(productAttributeValue: productAttributeValue));
                    }
                  },
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () async {
                          if (widget.isSearch) {
                            Navigator.pop(context, productAttributeValue);
                          } else {
                            final bool change = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ProductAttributeValueViewPage(productAttributeValue: productAttributeValue);
                                },
                              ),
                            );

                            if (change) {
                              _productAttributeLineBloc
                                  .add(ProductAttributeLineStarted(productTemplate: widget.productTemplate));
                            }
                          }
                        },
                        contentPadding: const EdgeInsets.only(left: 60, right: 16, bottom: 5, top: 5),
                        title: Text(productAttributeValue.nameGet ?? '', textAlign: TextAlign.start),
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xffE9F6EC),
                          child: Text(
                            attribute != null && attribute.name != '' ? attribute.name.substring(0, 1) : '',
                            style: const TextStyle(color: Color(0xff28A745)),
                          ),
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(left: 45, right: 10),
                          color: Colors.grey.shade200,
                          height: 1,
                          width: double.infinity),
                    ],
                  ),
                ))
            .toList());
  }

  Widget _buildAttributeItem(ProductAttribute productAttributeLine) {
    return productAttributeLine.attributeValues.isEmpty
        ? _buildProductAttributeLine(productAttributeLine)
        : _buildProductAttributeLineHasChildren(productAttributeLine);
  }

  ///Xây dựng giao diện productUom khi có đơn vị tính
  Widget _buildProductAttributeLineHasChildren(ProductAttribute productAttributeLine) {
    return Stack(
      children: [
        CustomExpandTile(
            update: false,
            contentPadding: const EdgeInsets.only(left: 16, right: 5, bottom: 5, top: 5),
            leading: CircleAvatar(
              backgroundColor: const Color(0xffE9F6EC),
              child: Text(
                productAttributeLine != null && productAttributeLine.name != ''
                    ? productAttributeLine.name.substring(0, 1)
                    : '',
                style: const TextStyle(color: Color(0xff28A745)),
              ),
            ),
            title: Text(productAttributeLine.name ?? '', textAlign: TextAlign.start),
            underLine: Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                color: Colors.grey.shade200,
                height: 1,
                width: double.infinity),
            body: _buildAttributeValues(productAttributeLine)),
        if (productAttributeLine.attributeValues.isNotEmpty)
          Positioned(
            top: 32,
            left: 43,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff28A745),
              ),
              padding: const EdgeInsets.all(5),
              child: Text(
                productAttributeLine.attributeValues.length.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ),
      ],
    );
  }

  ///Xây dựng giao diện có thể slide để xóa và sửa
  Widget _buildSlidable({ValueKey key, Widget child, Function onDelete, Function onEdit}) {
    return Slidable(
      key: key,
      secondaryActions: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          child: Padding(
            padding: const EdgeInsets.only(right: 2),
            child: Material(
              color: const Color(0xffF2F4F7),
              child: InkWell(
                onTap: () {
                  onEdit?.call();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Flexible(
                        child: Icon(
                      Icons.edit,
                      color: Color(0xff858F9B),
                    )),
                    Flexible(
                      child: Text(
                        S.of(context).edit,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(color: Color(0xff7E8595)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          child: Padding(
            padding: const EdgeInsets.only(left: 2, right: 2),
            child: Material(
              color: const Color(0xffEB3B5B),
              child: InkWell(
                onTap: () {
                  onDelete?.call();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Flexible(
                        child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    )),
                    Flexible(
                      child: Text(
                        S.of(context).delete,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
      actionPane: const SlidableStrechActionPane(),
      child: child,
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: AppButton(
              background: Colors.transparent,
              onPressed: () async {
                _codeController.text = '';
                _nameController.text = '';
                _productAttribute = ProductAttribute(sequence: 0, name: '', code: '');

                _productAttribute = await showDialog<ProductAttribute>(
                  context: context,
                  builder: (BuildContext context) {
                    return _buildDialogInputs(context: context, insert: true);
                  },
                  useRootNavigator: false,
                );
                if (_productAttribute != null) {
                  _codeController.text = '';
                  _nameController.text = '';
                  _productAttributeLineBloc.add(ProductAttributeInserted(productAttribute: _productAttribute));
                }
              },
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  SvgPicture.asset('assets/icon/variant.svg'),
                  const SizedBox(width: 23),
                  Text(
                    S.of(context).addParam(S.of(context).attribute.toLowerCase()),
                    style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: StatefulBuilder(
              builder: (BuildContext context, void Function(void Function()) setState) {
                return AppButton(
                  background: Colors.transparent,
                  onPressed: () async {
                    final ProductAttributeValue productAttributeLine = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const ProductAttributeValueAddEditPage();
                        },
                      ),
                    );

                    if (productAttributeLine != null) {
                      setState(() {
                        _keyword = '';
                      });
                      _productAttributeLineBloc.add(ProductAttributeLineRefreshed());
                    }
                  },
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      const Icon(Icons.add, size: 25, color: Color(0xff929DAA)),
                      const SizedBox(width: 20),
                      Text(
                        S.of(context).addParam(S.current.attributeValue.toLowerCase()),
                        style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  ///Giao diện sửa thuộc tính
  Widget _buildDialogInputs({BuildContext context, bool insert = true}) {
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
                              insert
                                  ? S.of(context).addParam(S.of(context).attribute.toLowerCase())
                                  : S.of(context).editParam(S.of(context).attribute.toLowerCase()),
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
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.current.attributeCode,
                                style: const TextStyle(color: Color(0xff929DAA), fontSize: 13),
                              ),
                              _buildTextField(
                                  controller: _codeController,
                                  focusNode: _focusNode,
                                  hint: S.of(context).enterParam(S.current.attributeCode.toLowerCase())),
                              Text(
                                S.current.attributeName,
                                style: const TextStyle(color: Color(0xff929DAA), fontSize: 13),
                              ),
                              _buildTextField(
                                  controller: _nameController,
                                  hint: S.of(context).enterParam(S.current.attributeName.toLowerCase())),
                              _buildSequence(context),
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 42,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(color: const Color(0xffC6C6C6), width: 1)),
                                    child: FlatButton(
                                      padding: const EdgeInsets.only(left: 0, right: 0),
                                      child: Center(
                                        child: Text(
                                          S.of(context).cancel,
                                          style: const TextStyle(color: Color(0xff2C333A)),
                                        ),
                                      ),
                                      onPressed: () async {
                                        final bool result = await showGeneralDialog(
                                          useRootNavigator: false,
                                          pageBuilder: (context, animation, secondAnimation) {
                                            return AlertDialog(
                                              title: Text(S.current.confirm),
                                              content: Text(S.of(context).cancelInput),
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
                                          Navigator.pop(context);
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    height: 42,
                                    decoration: BoxDecoration(
                                        color: const Color(0xff28A745),
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(color: const Color(0xff28A745), width: 1)),
                                    child: FlatButton(
                                      padding: const EdgeInsets.only(left: 0, right: 0),
                                      child: Center(
                                        child: Text(
                                          S.of(context).save,
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      onPressed: () {
                                        if (_nameController.text == '') {
                                          App.showDefaultDialog(
                                              title: S.of(context).warning,
                                              context: context,
                                              content: S.of(context).canNotBeEmptyParam(S.of(context).attributeName),
                                              type: AlertDialogType.warning);
                                        } else {
                                          _productAttribute.name = _nameController.text;
                                          _productAttribute.code = _codeController.text;
                                          _nameController.text = '';
                                          _codeController.text = '';
                                          Navigator.pop(context, _productAttribute);
                                        }
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

  ///Xây dựng giao diện cho textfield nhập
  Widget _buildTextField(
      {TextEditingController controller,
      String hint,
      Function(String) onTextChanged,
      FocusNode focusNode,
      EdgeInsets contentPadding = const EdgeInsets.only(right: 10)}) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 5),
          //   child: Text(hint, style: const TextStyle(color: Color(0xff929DAA), fontSize: 17)),
          // ),
          Container(
            height: 50,
            child: TextField(
              controller: controller,
              maxLines: 1,
              onChanged: onTextChanged,
              textAlign: TextAlign.start,
              focusNode: focusNode,
              style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
              decoration: InputDecoration(
                contentPadding: contentPadding,
                hintText: hint,
                hintStyle: const TextStyle(color: Color(0xff929DAA), fontSize: 17),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff28A745)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  ///Xây dựng giao diện nhập 'Thứ tự'
  Widget _buildSequence(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            Text(S.of(context).order, style: const TextStyle(color: Color(0xff2C333A), fontSize: 17)),
            const SizedBox(width: 10),
            Expanded(
              child: StatefulBuilder(
                builder: (BuildContext context, void Function(void Function()) setState) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppButton(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(6)),
                            border: Border.all(color: const Color(0xffE9EDF2))),
                        child: const Icon(
                          Icons.arrow_drop_down_sharp,
                          color: Color(0xff28A745),
                          size: 30,
                        ),
                        onPressed: () {
                          _productAttribute.sequence ??= 0;
                          if (_productAttribute.sequence > 0) {
                            _productAttribute.sequence -= 1;
                            setState(() {});
                          }
                        },
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(6)),
                          child: Material(
                            child: InkWell(
                              onTap: () async {
                                _productAttribute.sequence ??= 0;
                                final double number =
                                    await showNumberInputDialog(context, _productAttribute.sequence.toDouble());
                                if (number != null) {
                                  _productAttribute.sequence = number.toInt();
                                  setState(() {});
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 9, top: 9),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                                    border: Border.all(color: const Color(0xffE9EDF2))),
                                child: Text(
                                  _productAttribute != null ? _productAttribute.sequence.toString() : '0',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 17, color: Color(0xff2C333A)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      AppButton(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(6)),
                            border: Border.all(color: const Color(0xffE9EDF2))),
                        child: const Icon(
                          Icons.arrow_drop_up,
                          color: Color(0xff28A745),
                          size: 30,
                        ),
                        onPressed: () {
                          _productAttribute.sequence ??= 0;
                          _productAttribute.sequence += 1;
                          setState(() {});
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
