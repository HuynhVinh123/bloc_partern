import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/feature_group/category/product_uom/ui/product_uom_add_edit_page.dart';
import 'package:tpos_mobile/feature_group/category/product_uom_category/bloc/product_uom_category_bloc.dart';
import 'package:tpos_mobile/feature_group/category/product_uom_category/bloc/product_uom_category_event.dart';
import 'package:tpos_mobile/feature_group/category/product_uom_category/bloc/product_uom_category_state.dart';
import 'package:tpos_mobile/widgets/bloc_widget/base_bloc_listener_ui.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/custom_snack_bar.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/load_status.dart';
import 'package:tpos_mobile/widgets/search_app_bar.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

///Màn hình danh sách nhóm đơn vị tính
///[searchModel]: dùng cho chức năng tìm kiếm
class ProductUomCategoriesPage extends StatefulWidget {
  const ProductUomCategoriesPage({Key key, this.searchModel = false})
      : super(key: key);

  @override
  _ProductUomCategoriesPageState createState() =>
      _ProductUomCategoriesPageState();
  final bool searchModel;
}

class _ProductUomCategoriesPageState extends State<ProductUomCategoriesPage> {
  final TextEditingController _nameController = TextEditingController();
  ProductUomCategoryBloc _productUomCategoryBloc;
  final FocusNode _focusNode = FocusNode();
  String _search = '';
  List<ProductUomCategory> _productUomCategories;

  bool _change = false;

  @override
  void initState() {
    _productUomCategoryBloc = ProductUomCategoryBloc();
    _productUomCategoryBloc.add(ProductUomCategoryStarted());
    super.initState();
  }

  @override
  void dispose() {
    _productUomCategoryBloc.close();
    _nameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.searchModel) {
          Navigator.of(context).pop();
        } else {
          Navigator.of(context).pop(_change);
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: SearchAppBar(
        title: S.current.unitCategory,
        text: _search,
        onBack: () {
          if (widget.searchModel) {
            Navigator.of(context).pop();
          } else {
            Navigator.of(context).pop(_change);
          }
        },
        onKeyWordChanged: (String search) {
          if (_search != search) {
            _search = search;
            _productUomCategoryBloc
                .add(ProductUomCategorySearched(search: _search));
          }
        },
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
                    ProductUomCategory productUomCategory =
                        ProductUomCategory(id: 0);
                    _nameController.text = '';
                    _focusNode.requestFocus();
                    productUomCategory = await showDialog<ProductUomCategory>(
                      context: context,
                      builder: (BuildContext context) {
                        return _buildDialogInputs(context, productUomCategory);
                      },
                      useRootNavigator: false,
                    );
                    if (productUomCategory != null) {
                      _change = true;
                      _productUomCategoryBloc.add(ProductUomCategoryInserted(
                          productUomCategory: productUomCategory));
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return BaseBlocListenerUi<ProductUomCategoryBloc, ProductUomCategoryState>(
      bloc: _productUomCategoryBloc,
      loadingState: ProductUomCategoryLoading,
      busyState: ProductUomCategoryBusy,
      errorState: ProductUomCategoryLoadFailure,
      listener: (BuildContext context, ProductUomCategoryState state) {
        if (state is ProductUomCategoryInsertSuccess) {
          _change = true;
          final Widget snackBar = getCloseableSnackBar(
              message: S.current.successfullyParam(S.current.add),
              context: context);
          Scaffold.of(context).showSnackBar(snackBar);
        } else if (state is ProductUomCategoryActionFailure) {
          App.showDefaultDialog(
              title: '',
              context: context,
              content: state.error,
              type: AlertDialogType.error);
        } else if (state is ProductUomCategoryUpdateSuccess) {
          _change = true;

          final Widget snackBar = getCloseableSnackBar(
              message: S.current.successfullyParam(S.current.edit),
              context: context);
          Scaffold.of(context).showSnackBar(snackBar);
        } else if (state is ProductUomCategoryDeleteSuccess) {
          _change = true;

          final Widget snackBar = getCloseableSnackBar(
              message: S.current.successfullyParam(S.current.delete),
              context: context);
          Scaffold.of(context).showSnackBar(snackBar);
        }
      },
      errorBuilder: (BuildContext context, ProductUomCategoryState state) {
        String error = S.current.canNotGetDataFromServer;
        if (state is ProductUomCategoryLoadFailure) {
          error = state.error ?? S.current.canNotGetDataFromServer;
        }

        return SingleChildScrollView(
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
                      _productUomCategoryBloc.add(ProductUomCategoryStarted());
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
      },
      builder: (BuildContext context, ProductUomCategoryState state) {
        if (state is ProductUomCategoryLoadSuccess) {
          _productUomCategories = state.productUomCategories;
        }
        return _productUomCategories.isEmpty
            ? _buildEmptyList()
            : _buildProductUomCategories(_productUomCategories);
      },
    );
  }

  Widget _buildProductUomCategories(
      List<ProductUomCategory> productUomCategories) {
    return ListView.separated(
      itemCount: productUomCategories.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildProductUomCategory(productUomCategories[index]);
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 0);
      },
    );
  }

  ///Xây dựng giao diện trống
  Widget _buildEmptyList() {
    return _search != ''
        ? SingleChildScrollView(
            child: Column(
            children: [
              SizedBox(height: 50 * (MediaQuery.of(context).size.height / 700)),
              LoadStatusWidget(
                statusName: S.current.searchNotFound,
                content: S.current.searchNotFoundWithKeywordParam(
                    _search, S.current.unitCategories.toLowerCase()),
                statusIcon: SvgPicture.asset('assets/icon/no-result.svg',
                    width: 170, height: 130),
              ),
            ],
          ))
        : SingleChildScrollView(
            child: Column(
            children: [
              SizedBox(height: 50 * (MediaQuery.of(context).size.height / 700)),
              LoadStatusWidget.empty(
                statusName: S.current.noData,
                content: S.current.emptyNotificationParam(
                    S.current.unitCategory.toLowerCase()),
                action: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: AppButton(
                    onPressed: () async {
                      ProductUomCategory productUomCategory =
                          ProductUomCategory(id: 0);
                      _nameController.text = '';

                      productUomCategory = await showDialog<ProductUomCategory>(
                        context: context,
                        builder: (BuildContext context) {
                          return _buildDialogInputs(
                              context, productUomCategory);
                        },
                        useRootNavigator: false,
                      );
                      if (productUomCategory != null) {
                        _change = true;
                        _productUomCategoryBloc.add(ProductUomCategoryInserted(
                            productUomCategory: productUomCategory));
                      }
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
                            Icons.add,
                            color: Colors.white,
                            size: 23,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            S.current.addNewParam(
                                S.current.unitCategory.toLowerCase()),
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
          ));
  }

  ///Giao diện nhóm đơn vị tính
  Widget _buildProductUomCategory(ProductUomCategory productUomCategory) {
    return InkWell(
      onTap: () {
        if (widget.searchModel) {
          Navigator.of(context).pop(productUomCategory);
        }
      },
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: 16, right: widget.searchModel ? 16 : 0, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productUomCategory.name,
                        style: const TextStyle(
                            color: Color(0xff2C333A), fontSize: 17),
                      ),
                      Text(
                        '${productUomCategory.productUoms.length} ${S.current.value.toLowerCase()}',
                        style: const TextStyle(
                            color: Color(0xff929DAA), fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                if (!widget.searchModel)
                  IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {
                        showModalBottomSheet<void>(
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            backgroundColor: Colors.white,
                            builder: (BuildContext context) {
                              return _buildBottomSheet(
                                  context, productUomCategory);
                            });
                      }),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
              color: Colors.grey.shade200, height: 1, width: double.infinity),
        ],
      ),
    );
  }

  ///Xây dựng giao diện hiện dialog thêm nhóm đơn vị tính
  Widget _buildDialogInputs(
      BuildContext context, ProductUomCategory productUomCategory,
      {bool insert = true}) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _focusNode.requestFocus());

    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyText2,
      child: Padding(
        padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 16, right: 0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              insert
                                  ? S.current.addParam(
                                      S.current.unitCategory.toLowerCase())
                                  : S.current.editParam(
                                      S.current.unitCategory.toLowerCase()),
                              style: const TextStyle(
                                  color: Color(0xff2C333A), fontSize: 21),
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
                            const SizedBox(width: 5)
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Column(
                            children: [
                              _buildTextField(
                                  controller: _nameController,
                                  hint: S.current.enterUnitCategoryName),
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: const Color(0xffC6C6C6),
                                            width: 1)),
                                    child: FlatButton(
                                      padding: const EdgeInsets.only(
                                          left: 0, right: 0),
                                      child: Center(
                                        child: Text(
                                          S.current.cancel,
                                          style: const TextStyle(
                                              color: Color(0xff3A3B3F)),
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
                                        border: Border.all(
                                            color: const Color(0xff28A745),
                                            width: 1)),
                                    child: FlatButton(
                                      padding: const EdgeInsets.only(
                                          left: 0, right: 0),
                                      child: Center(
                                        child: Text(
                                          S.current.save,
                                          style: const TextStyle(
                                              color: Color(0xff28A745)),
                                        ),
                                      ),
                                      onPressed: () {
                                        if (_nameController.text == '') {
                                          App.showDefaultDialog(
                                              title: S.of(context).warning,
                                              context: context,
                                              type: AlertDialogType.warning,
                                              content: S.current
                                                  .pleaseEnterParam(S
                                                      .current.unitCategoryName
                                                      .toLowerCase()));
                                          return;
                                        }

                                        Navigator.of(context).pop(
                                            ProductUomCategory(
                                                name: _nameController.text,
                                                id: productUomCategory.id));
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
      EdgeInsets contentPadding = const EdgeInsets.only(right: 10, left: 5)}) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Container(
            height: 50,
            child: TextField(
              controller: controller,
              maxLines: 1,
              focusNode: _focusNode,
              onChanged: onTextChanged,
              textAlign: TextAlign.start,
              style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
              decoration: InputDecoration(
                contentPadding: contentPadding,
                hintText: hint,
                enabledBorder: InputBorder.none,
                hintStyle:
                    const TextStyle(color: Color(0xff929DAA), fontSize: 17),
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Container(
              color: Colors.grey.shade200, height: 1, width: double.infinity),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  ///Giao diện bottom sheet thực hiện thao tác thêm đơn vị tính cho nhóm đơn vị tính được chọn,
  /// hoặc xóa nhóm đơn vị tính
  Widget _buildBottomSheet(
      BuildContext context, ProductUomCategory productUomCategory) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            height: 50,
            width: double.infinity,
            child: AppButton(
              background: Colors.transparent,
              onPressed: () async {
                _nameController.text = productUomCategory?.name ?? '';

                final ProductUomCategory result =
                    await showDialog<ProductUomCategory>(
                  context: context,
                  builder: (BuildContext context) {
                    return _buildDialogInputs(context, productUomCategory,
                        insert: false);
                  },
                  useRootNavigator: false,
                );
                if (result != null) {
                  productUomCategory = result;
                  _change = true;
                  _productUomCategoryBloc.add(ProductUomCategoryUpdated(
                      productUomCategory: productUomCategory));
                  Navigator.pop(context);
                }
              },
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  const Icon(Icons.edit, color: Colors.blue, size: 23),
                  const SizedBox(width: 10),
                  Text(
                    S.current.editParam(S.current.unitCategory.toLowerCase()),
                    style:
                        const TextStyle(color: Color(0xff2C333A), fontSize: 17),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 50,
            width: double.infinity,
            child: AppButton(
              background: Colors.transparent,
              onPressed: () async {
                setState(() {});
                Navigator.pop(context);
                final ProductUOM productUom = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ProductUomAddEditPage(
                          productUomCategory: productUomCategory);
                    },
                  ),
                );

                if (productUom != null) {
                  _change = true;
                  productUomCategory.productUoms.add(productUom);
                  _productUomCategoryBloc.add(ProductUomCategoryRefreshed());
                }
              },
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  const Icon(Icons.add, color: Color(0xff929DAA), size: 23),
                  const SizedBox(width: 10),
                  Text(
                    S.current.addUnitToCategories,
                    style:
                        const TextStyle(color: Color(0xff2C333A), fontSize: 17),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 50,
            width: double.infinity,
            child: AppButton(
              background: Colors.transparent,
              onPressed: () async {
                final bool result = await App.showConfirm(
                    title: S.current.confirmDelete,
                    content: S.current.deleteSelectConfirmParam(
                        S.current.unitCategory.toLowerCase()));

                if (result != null && result) {
                  _productUomCategoryBloc.add(ProductUomCategoryDeleted(
                      productUomCategory: productUomCategory));
                  Navigator.pop(context);
                }
              },
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  // Icon(Icons.delete, size: 23, color: Colors.red),
                  SvgPicture.asset('assets/icon/delete.svg'),
                  const SizedBox(width: 10),
                  Text(
                    S.current.deleteUnitCategory,
                    style:
                        const TextStyle(color: Color(0xff2C333A), fontSize: 17),
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
}
