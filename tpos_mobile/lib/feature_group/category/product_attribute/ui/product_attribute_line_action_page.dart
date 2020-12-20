import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/bloc/product_attribute_line/product_attribute_line_bloc.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/bloc/product_attribute_line/product_attribute_line_event.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/bloc/product_attribute_line/product_attribute_line_state.dart';
import 'package:tpos_mobile/resources/app_colors.dart';
import 'package:tpos_mobile/widgets/bloc_widget/base_bloc_listener_ui.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/custom_snack_bar.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/load_status.dart';
import 'package:tpos_mobile/widgets/search_app_bar.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

///[isSearch] dành cho chức năng tìm kiếm product attribute, nếu khác [true] thì cho phép trả về product attribute
///khi nhấn vào, khi ở chức năng tìm kiếm ta chỉ có thể thêm mới, chứ không được phép sửa và xóa
///[productAttributeLine] nếu thay đổi thông tin có id cùng với [productAttributeLine.id] thì ta cập nhật lại thông tin đó
class ProductAttributeLineActionPage extends StatefulWidget {
  const ProductAttributeLineActionPage({Key key, this.isSearch = false}) : super(key: key);

  @override
  _ProductAttributeLineActionPageState createState() => _ProductAttributeLineActionPageState();
  final bool isSearch;
}

class _ProductAttributeLineActionPageState extends State<ProductAttributeLineActionPage> {
  ProductAttributeLineBloc _productAttributeBloc;
  ProductAttributeValue _productAttribute;

  bool _isChange = false;
  String _keyword = '';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _productAttributeBloc = ProductAttributeLineBloc();
    _productAttributeBloc.add(ProductAttributeLineStarted());
  }

  @override
  void dispose() {
    _productAttributeBloc.close();
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.isSearch) {
          Navigator.pop(context);
        } else {
          Navigator.pop(context, _isChange);
        }
        return false;
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildAppBar() {
    return PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SearchAppBar(
          text: _keyword,
          onBack: () {
            if (widget.isSearch) {
              Navigator.pop(context);
            } else {
              Navigator.pop(context, _isChange);
            }
          },
          onKeyWordChanged: (String keyword) {
            if (_keyword != keyword) {
              _keyword = keyword;
              // _productAttributeBloc.close();
              // _productAttributeBloc = ProductAttributeLineBloc();
              setState(() {});
              _productAttributeBloc.add(ProductAttributeLineSearched(keyword: keyword));
            }
          },
          title: S.of(context).attribute,
          actions: [
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
                      _codeController.text = '';
                      _nameController.text = '';
                      _productAttribute = ProductAttributeValue(sequence: 0, name: '', code: '');

                      _productAttribute = await showDialog<ProductAttributeValue>(
                        context: context,
                        builder: (BuildContext context) {
                          return _buildDialogInputs(context, insert: true);
                        },
                        useRootNavigator: false,
                      );
                      if (_productAttribute != null) {
                        _codeController.text = '';
                        _nameController.text = '';
                        _productAttributeBloc.add(ProductAttributeInserted(productAttribute: _productAttribute));
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildBody() {
    return BaseBlocListenerUi<ProductAttributeLineBloc, ProductAttributeLineState>(
      bloc: _productAttributeBloc,
      loadingState: ProductAttributeLineLoading,
      busyState: ProductAttributeLineBusy,
      errorState: ProductAttributeLineLoadFailure,
      listener: (BuildContext context, ProductAttributeLineState state) {
        if (state is ProductAttributeInsertSuccess) {
          _isChange = true;
          final Widget snackBar =
              customSnackBar(message: S.of(context).successfullyParam(S.of(context).add), context: context);
          Scaffold.of(context).showSnackBar(snackBar);
        } else if (state is ProductAttributeInsertFailure) {
          App.showDefaultDialog(title: '', context: context, content: state.error, type: AlertDialogType.error);
        } else if (state is ProductAttributeUpdateFailure) {
          App.showDefaultDialog(title: '', context: context, content: state.error, type: AlertDialogType.error);
        } else if (state is ProductAttributeDeleteFailure) {
          App.showDefaultDialog(context: context, content: state.error, type: AlertDialogType.error);
        } else if (state is ProductAttributeUpdateSuccess) {
          _isChange = true;

          final Widget snackBar =
              customSnackBar(message: S.of(context).successfullyParam(S.of(context).edit), context: context);
          Scaffold.of(context).showSnackBar(snackBar);
        } else if (state is ProductAttributeDeleteSuccess) {
          _isChange = true;

          final Widget snackBar =
              customSnackBar(message: S.of(context).successfullyParam(S.of(context).delete), context: context);
          Scaffold.of(context).showSnackBar(snackBar);
        }
      },
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
                action: AppButton(
                  onPressed: () {
                    _productAttributeBloc.add(ProductAttributeLineRefreshed());
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
      builder: (BuildContext context, ProductAttributeLineState state) {
        return state.productAttributes.isEmpty ? _buildEmptyList() : _buildAttributes(state.productAttributes);
      },
    );
  }

  Widget _buildAttributes(List<ProductAttribute> attributes) {
    return ListView.separated(
      itemCount: attributes.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            if (widget.isSearch) {
              Navigator.of(context).pop(attributes[index].productAttribute);
            }
          },
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16, right: widget.isSearch ? 16 : 0, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            attributes[index].name,
                            style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
                          ),
                          Text(
                            '${attributes[index].attributeValues.length} ${S.of(context).value.toLowerCase()}',
                            style: const TextStyle(color: Color(0xff929DAA), fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    if (!widget.isSearch)
                      IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {
                            showModalBottomSheet<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return _buildBottomSheet(context, attributes[index]);
                                });
                          }),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(color: Colors.grey.shade200, height: 1, width: double.infinity),
            ],
          ),
        );
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
                content: S.of(context).searchNotFoundAttributeWithKeyword(_keyword),
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
                content: S.of(context).emptyNotificationParam(S.of(context).attribute.toLowerCase()),
                action: AppButton(
                  onPressed: () async {
                    _productAttribute = ProductAttributeValue(sequence: 0, name: '', code: '');
                    _productAttribute = await showDialog<ProductAttributeValue>(
                      context: context,
                      builder: (BuildContext context) {
                        return _buildDialogInputs(context);
                      },
                      useRootNavigator: false,
                    );
                    if (_productAttribute != null) {
                      _productAttributeBloc.add(ProductAttributeInserted(productAttribute: _productAttribute));
                    }
                  },
                  width: 250,
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
                          S.of(context).addNewParam(S.of(context).attribute.toLowerCase()),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ));
  }

  ///Giao diện sửa thuộc tính
  Widget _buildDialogInputs(BuildContext context, {bool insert = true}) {
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
                            children: [
                              _buildTextField(controller: _codeController, hint: S.of(context).attributeCode),
                              _buildTextField(controller: _nameController, hint: S.of(context).attributeName),
                              _buildSequence(),
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
                                      child: Center(
                                        child: Text(
                                          S.of(context).cancel,
                                          style: const TextStyle(color: Color(0xff3A3B3F)),
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
                                        if (_nameController.text == '') {
                                          App.showDefaultDialog(
                                              title: '',
                                              context: context,
                                              content: S
                                                  .of(context)
                                                  .canNotBeEmptyParam(S.of(context).attributeName.toLowerCase()),
                                              type: AlertDialogType.error);
                                        } else {
                                          _productAttribute.name = _nameController.text;
                                          _productAttribute.code = _codeController.text;

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
              style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
              decoration: InputDecoration(
                contentPadding: contentPadding,
                hintText: hint,
                enabledBorder: InputBorder.none,
                hintStyle: const TextStyle(color: Color(0xff929DAA), fontSize: 17),
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Container(color: Colors.grey.shade200, height: 1, width: double.infinity),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  ///Xây dựng giao diện nhập 'Thứ tự'
  Widget _buildSequence() {
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            Text(S.of(context).order, style: const TextStyle(color: Color(0xff929DAA), fontSize: 17)),
            Expanded(
              child: StatefulBuilder(
                builder: (BuildContext context, void Function(void Function()) setState) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppButton(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(6)),
                            border: Border.all(color: const Color(0xffE9EDF2))),
                        child: const Icon(
                          Icons.arrow_drop_down_sharp,
                          color: Color(0xff28A745),
                          size: 30,
                        ),
                        onPressed: () {
                          if (_productAttribute.sequence > 0) {
                            _productAttribute.sequence -= 1;
                            setState(() {});
                          }
                        },
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                          child: Container(
                        height: 50,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(6)),
                            border: Border.all(color: const Color(0xffE9EDF2))),
                        child: Text(
                          _productAttribute != null ? _productAttribute.sequence.toString() : '0',
                          style: const TextStyle(fontSize: 17, color: Color(0xff2C333A)),
                        ),
                      )),
                      const SizedBox(width: 10),
                      AppButton(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(6)),
                            border: Border.all(color: const Color(0xffE9EDF2))),
                        child: const Icon(
                          Icons.arrow_drop_up,
                          color: Color(0xff28A745),
                          size: 30,
                        ),
                        onPressed: () {
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
        Container(color: Colors.grey.shade200, height: 1, width: double.infinity),
        const SizedBox(height: 10),
      ],
    );
  }

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
              onPressed: () async {
                setState(() {});
                Navigator.pop(context);
                _productAttribute = productAttributeLine.productAttribute;
                _nameController.text = _productAttribute.name;
                _codeController.text = _productAttribute.code;
                _productAttribute = await showDialog<ProductAttributeValue>(
                  context: context,
                  builder: (BuildContext context) {
                    return _buildDialogInputs(context, insert: false);
                  },
                  useRootNavigator: false,
                );
                if (_productAttribute != null) {
                  _codeController.text = '';
                  _nameController.text = '';
                  _productAttributeBloc.add(ProductAttributeUpdated(productAttribute: _productAttribute));
                }
              },
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  const Icon(Icons.add, color: Color(0xff929DAA), size: 23),
                  const SizedBox(width: 10),
                  Text(
                    S.of(context).editParam(S.of(context).attribute.toLowerCase()),
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
                    final bool result = await App.showConfirm(
                        title: S.of(context).confirmDelete,
                        content: S.of(context).deleteSelectConfirmParam(S.of(context).attribute.toLowerCase()));

                    if (result != null && result) {
                      _productAttributeBloc.add(ProductAttributeDeleted(productAttributeLine: productAttributeLine));
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
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
