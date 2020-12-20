import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/feature_group/category/product_category/bloc/product_category_bloc.dart';
import 'package:tpos_mobile/feature_group/category/product_category/bloc/product_category_event.dart';
import 'package:tpos_mobile/feature_group/category/product_category/bloc/product_category_state.dart';
import 'package:tpos_mobile/feature_group/category/product_category/ui/product_category_add_edit_page.dart';
import 'package:tpos_mobile/feature_group/category/product_category/ui/product_category_view_page.dart';
import 'package:tpos_mobile/widgets/bloc_widget/base_bloc_listener_ui.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/custom_expand_tile.dart';
import 'package:tpos_mobile/widgets/custom_snack_bar.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/load_status.dart';
import 'package:tpos_mobile/widgets/search_app_bar.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

///Danh sách nhóm sản phẩm
class ProductCategoriesPage extends StatefulWidget {
  const ProductCategoriesPage(
      {Key key,
      this.searchModel = false,
      this.onSelected,
      this.selectedItems = const <ProductCategory>[],
      this.current})
      : super(key: key);

  @override
  _ProductCategoriesPageState createState() => _ProductCategoriesPageState();
  final bool searchModel;

  final ProductCategory current;

  final Function(ProductCategory) onSelected;

  final List<ProductCategory> selectedItems;
}

class _ProductCategoriesPageState extends State<ProductCategoriesPage> {
  ProductCategoryBloc _productCategoryBloc;
  List<ProductCategory> _productCategories;
  final List<ProductCategory> _productCategoryExecutes = [];
  String _search = '';
  bool _check = false;
  bool _selectAll = false;
  int _totalProductCategory = 0;

  final BehaviorSubject<int> _selectCountSubject = BehaviorSubject<int>();

  @override
  void initState() {
    _productCategoryBloc = ProductCategoryBloc();
    _productCategoryBloc.add(ProductCategoryStarted(current: widget.current));
    super.initState();
  }

  @override
  void dispose() {
    _productCategoryBloc.close();
    _selectCountSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: SearchAppBar(
        title: S.of(context).productCategory,
        text: _search,
        onKeyWordChanged: (String search) {
          if (_search != search) {
            _search = search;
            _productCategoryBloc.add(ProductCategorySearched(keyword: _search));
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
                    final ProductCategory productCategory = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const ProductCategoryAddEditPage();
                        },
                      ),
                    );

                    if (productCategory != null) {
                      _productCategoryBloc.add(ProductCategoryRefreshed());
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
    return BaseBlocListenerUi<ProductCategoryBloc, ProductCategoryState>(
      bloc: _productCategoryBloc,
      loadingState: ProductCategoryLoading,
      busyState: ProductCategoryBusy,
      errorBuilder: (BuildContext context, ProductCategoryState state) {
        String error = S.of(context).canNotGetDataFromServer;
        if (state is ProductCategoryLoadFailure) {
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
                    _productCategoryBloc.add(ProductCategoryStarted(current: widget.current));
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
      buildWhen: (ProductCategoryState last, ProductCategoryState current) {
        return current is! ProductCategoryDeleteFailure;
      },
      listener: (BuildContext context, ProductCategoryState state) {
        if (state is ProductCategoryDeleteFailure) {
          App.showDefaultDialog(
              title: S.of(context).error, context: context, type: AlertDialogType.error, content: state.error);
        } else if (state is ProductCategoryDeleteSuccess) {
          final Widget snackBar = customSnackBar(message: S.of(context).deleteSuccessful, context: context);
          Scaffold.of(context).showSnackBar(snackBar);
        }
      },
      builder: (BuildContext context, ProductCategoryState state) {
        if (state is ProductCategoryLoadSuccess) {
          _productCategories = state.productCategories;
          _totalProductCategory = state.total;
        }
        return Column(
          children: [
            if (_check) _buildCheckAction() else _buildUncheckAction(),
            Expanded(child: _productCategories.isEmpty ? _buildEmptyList() : _buildProductCategories()),
          ],
        );
      },
    );
  }

  ///Xây dựng giao diện khi chọn thao tác
  Widget _buildCheckAction() {
    return Row(
      children: [
        CircularCheckBox(
            value: _check,
            activeColor: const Color.fromARGB(255, 40, 167, 69),
            materialTapTargetSize: MaterialTapTargetSize.padded,
            onChanged: (bool value) {
              _check = value;
              setState(() {});
            }),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StreamBuilder<int>(
                stream: _selectCountSubject.stream,
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  return Text(
                    _productCategoryExecutes.length.toString(),
                    style: const TextStyle(
                        color: Color.fromARGB(255, 44, 51, 58), fontSize: 15, fontWeight: FontWeight.w500),
                  );
                },
              ),
              Flexible(
                child: Row(
                  children: [
                    CircularCheckBox(
                        value: _selectAll,
                        activeColor: const Color.fromARGB(255, 40, 167, 69),
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        onChanged: (bool value) {
                          _selectAll = value;
                          setState(() {});
                        }),
                    Flexible(
                      child: Text(
                        '${S.of(context).selectAll} ($_totalProductCategory)',
                        style: const TextStyle(
                            color: Color.fromARGB(255, 44, 51, 58), fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              AppButton(
                borderRadius: 30,
                height: 35,
                width: null,
                background: const Color.fromARGB(255, 40, 167, 69),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 10),
                    Text(
                      S.of(context).selectParam(S.of(context).manipulation.toLowerCase()),
                      style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    )
                  ],
                ),
                onPressed: () {
                  showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return _buildBottomSheet(context);
                      });
                },
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ],
    );
  }

  ///Xây dựng giao diện khi không chọn thao tác
  Widget _buildUncheckAction() {
    return Row(
      children: [
        CircularCheckBox(
            value: _check,
            activeColor: const Color.fromARGB(255, 40, 167, 69),
            materialTapTargetSize: MaterialTapTargetSize.padded,
            onChanged: (bool x) {
              _check = x;
              setState(() {});
            }),
        Flexible(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                S.of(context).manipulation,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Color.fromARGB(255, 107, 114, 128), fontSize: 15, fontWeight: FontWeight.w500),
              ),
              Flexible(
                child: Text(
                  ' / $_totalProductCategory ${S.of(context).products.toLowerCase()}',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 146, 157, 170), fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
      ],
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
                final bool result = await App.showConfirm(
                    title: S.of(context).confirmDelete,
                    content: S.of(context).deleteSelectConfirmParam(S.of(context).productCategory.toLowerCase()));

                if (result != null && result) {
                  if (_productCategoryExecutes.isEmpty && !_selectAll) {
                    Navigator.of(context).pop();
                    App.showDefaultDialog(
                        title: S.of(context).error,
                        context: context,
                        type: AlertDialogType.error,
                        content: S.of(context).notSelectNotification(S.of(context).productCategory.toLowerCase()));
                  } else {
                    if (_selectAll) {
                      _productCategoryBloc.add(ProductCategoryTemporaryDeleted(selectAll: true));
                    } else {
                      _productCategoryBloc
                          .add(ProductCategoryTemporaryDeleted(productCategories: _productCategoryExecutes));
                    }

                    Navigator.of(context).pop();
                  }
                }
              },
              child: Row(
                children: [
                  const SizedBox(width: 14),
                  const Icon(
                    Icons.auto_delete_sharp,
                    // color: Colors.white,
                    size: 23,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    S.of(context).deleteTemporary,
                    style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
                  )
                ],
              ),
            ),
          ),
          // Container(
          //   height: 50,
          //   width: MediaQuery.of(context).size.width,
          //   child: AppButton(
          //     background: Colors.transparent,
          //     onPressed: () async {
          //       final bool result = await App.showConfirm(
          //           title: 'Xác nhận xóa', content: 'Bạn có muốn xóa các sản phẩm được chọn không?');
          //
          //       if (result != null && result) {
          //         // _productCategoryBloc.add(ProductCategoryDeleted(productCategories: ))
          //
          //       }
          //     },
          //     child: Row(
          //       children: const [
          //         SizedBox(width: 10),
          //         Icon(
          //           Icons.delete,
          //           size: 23,
          //           color: Colors.red,
          //         ),
          //         SizedBox(width: 10),
          //         Text(
          //           'Xóa',
          //           style: TextStyle(color: Color(0xff2C333A), fontSize: 17),
          //         )
          //       ],
          //     ),
          //   ),
          // ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProductCategories() {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: ListView.separated(
        itemCount: _productCategories.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildProductCategory(_productCategories[index]);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 0);
        },
      ),
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
                statusName: S.of(context).searchNotFound,
                content: S.of(context).searchNotMatchProductCategory(_search),
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
                content: S.of(context).emptyNotificationParam(S.of(context).productCategory.toLowerCase()),
                action: AppButton(
                  onPressed: () async {
                    final ProductCategory productCategory = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const ProductCategoryAddEditPage();
                        },
                      ),
                    );

                    if (productCategory != null) {
                      _productCategoryBloc.add(ProductCategoryRefreshed());
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
                          S.of(context).addNewParam(S.of(context).productCategory.toLowerCase()),
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

  ///Xây dựng nhóm sản phẩm
  Widget _buildProductCategory(ProductCategory productCategory, {int level = 0}) {
    return productCategory.children.isNotEmpty
        ? _buildProductCategoryHasChild(productCategory, level: level)
        : _buildBasicProductCategory(productCategory, level: level);
  }

  ///Xây dựng giao diện productCategory khi không có con
  Widget _buildBasicProductCategory(ProductCategory productCategory, {int level = 0}) {
    return Slidable(
      key: ValueKey<int>(productCategory.id),
      secondaryActions: [
        InkWell(
          onTap: () async {
            final bool result = await App.showConfirm(
                title: S.of(context).confirmDelete,
                content: S.of(context).deleteSelectConfirmParam(S.of(context).productCategory.toLowerCase()));

            if (result != null && result) {
              _productCategoryBloc.add(ProductCategoryDeleted(productCategory: productCategory));
            }
          },
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Center(
              child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraint) {
                final double width = constraint.biggest.width > 14 ? 14 : constraint.biggest.width;
                return Column(
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
                        style: TextStyle(color: Colors.white, fontSize: 14 * width / 14),
                      ),
                    )
                  ],
                );
              }),
            ),
          ),
        ),
      ],
      actionPane: const SlidableStrechActionPane(),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 40.0 * level),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: ListTile(
                      onTap: () async {
                        if (widget.searchModel) {
                          widget.onSelected?.call(productCategory);
                          Navigator.pop(context, productCategory);
                        } else {
                          final ProductCategory result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ProductCategoryViewPage(productCategory: productCategory);
                              },
                            ),
                          );

                          if (result != null) {
                            productCategory = result;
                            _productCategoryBloc.add(ProductCategoryRefreshed());
                          }
                        }
                      },
                      contentPadding: const EdgeInsets.all(5),
                      title: Text(productCategory.name ?? '', textAlign: TextAlign.start),
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xffE9F6EC),
                        child: Text(
                          productCategory != null && productCategory.name != ''
                              ? productCategory.name.substring(0, 1)
                              : '',
                          style: const TextStyle(color: Color(0xff28A745)),
                        ),
                      ),
                    ),
                  ),
                  if (_check)
                    Positioned(
                      left: 5,
                      top: 0,
                      child: StatefulBuilder(
                        builder: (BuildContext context, void Function(void Function()) setState) {
                          bool isSelected = false;
                          if (_check) {
                            isSelected = _productCategoryExecutes.any((element) => element.id == productCategory.id);
                          }
                          if (_selectAll) {
                            isSelected = _selectAll;
                          }
                          return ClipOval(
                            child: Container(
                              height: 40,
                              width: 40,
                              child: Material(
                                color: Colors.transparent,
                                child: IconButton(
                                  iconSize: 20,
                                  icon: isSelected
                                      ? Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: isSelected ? const Color.fromARGB(255, 40, 167, 69) : Colors.white,
                                              border: Border.all(color: isSelected ? Colors.transparent : Colors.grey)),
                                          child: const Icon(
                                            Icons.check,
                                            size: 20.0,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: isSelected ? const Color.fromARGB(255, 40, 167, 69) : Colors.white,
                                              border: Border.all(color: isSelected ? Colors.transparent : Colors.grey)),
                                        ),
                                  onPressed: () {
                                    if (!isSelected) {
                                      _productCategoryExecutes.add(productCategory);
                                    } else {
                                      _productCategoryExecutes
                                          .removeWhere((ProductCategory element) => element.id == productCategory.id);
                                    }
                                    _selectCountSubject.sink.add(_productCategoryExecutes.length);
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                ],
              ),
            ),
          ),
          if (widget.selectedItems != null &&
              widget.selectedItems.any((ProductCategory item) => item.id == productCategory.id))
            const Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(
                FontAwesomeIcons.checkCircle,
                color: Color(0xff28A745),
                size: 20,
              ),
            )
        ],
      ),
    );
  }

  ///Xây dựng giao diện productCategory khi có con
  Widget _buildProductCategoryHasChild(ProductCategory productCategory, {int level = 0}) {
    return Slidable(
      key: ValueKey<int>(productCategory.id),
      secondaryActions: [
        InkWell(
          onTap: () async {
            final bool result = await App.showConfirm(
                title: S.of(context).confirmDelete,
                content: S.of(context).deleteSelectConfirmParam(S.of(context).productCategory.toLowerCase()));

            if (result != null && result) {
              _productCategoryBloc.add(ProductCategoryDeleted(productCategory: productCategory));
            }
          },
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Center(
              child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraint) {
                final double width = constraint.biggest.width > 14 ? 14 : constraint.biggest.width;
                return Column(
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
                        style: TextStyle(color: Colors.white, fontSize: 14 * width / 14),
                      ),
                    )
                  ],
                );
              }),
            ),
          ),
        ),
      ],
      actionPane: const SlidableStrechActionPane(),
      child: _buildExpanse(
          underLinePadding: EdgeInsets.only(left: 40.0 * level),
          header: Row(
            children: [
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 40.0 * level),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: ListTile(
                          onTap: () async {
                            if (widget.searchModel) {
                              widget.onSelected?.call(productCategory);
                              Navigator.pop(context, productCategory);
                            } else {
                              final ProductCategory result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ProductCategoryViewPage(productCategory: productCategory);
                                  },
                                ),
                              );

                              if (result != null) {
                                _productCategoryBloc.add(ProductCategoryRefreshed());
                              }
                            }
                          },
                          contentPadding: const EdgeInsets.all(5),
                          title: Text(productCategory.name ?? '', textAlign: TextAlign.start),
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xffE9F6EC),
                            child: Text(
                              productCategory != null && productCategory.name != ''
                                  ? productCategory.name.substring(0, 1)
                                  : '',
                              style: const TextStyle(color: Color(0xff28A745)),
                            ),
                          ),
                        ),
                      ),
                      if (productCategory.children.isNotEmpty)
                        Positioned(
                          bottom: 8,
                          left: 48,
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xff28A745),
                            ),
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              productCategory.children.length.toString(),
                              style: const TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          ),
                        ),
                      if (_check)
                        Positioned(
                          left: 5,
                          top: 0,
                          child: StatefulBuilder(
                            builder: (BuildContext context, void Function(void Function()) setState) {
                              bool isSelected = false;
                              if (_check) {
                                isSelected =
                                    _productCategoryExecutes.any((element) => element.id == productCategory.id);
                              }
                              if (_selectAll) {
                                isSelected = _selectAll;
                              }
                              return ClipOval(
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: IconButton(
                                      iconSize: 20,
                                      icon: isSelected
                                          ? Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: isSelected
                                                      ? const Color.fromARGB(255, 40, 167, 69)
                                                      : Colors.white,
                                                  border:
                                                      Border.all(color: isSelected ? Colors.transparent : Colors.grey)),
                                              child: const Icon(
                                                Icons.check,
                                                size: 20.0,
                                                color: Colors.white,
                                              ),
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: isSelected
                                                      ? const Color.fromARGB(255, 40, 167, 69)
                                                      : Colors.white,
                                                  border:
                                                      Border.all(color: isSelected ? Colors.transparent : Colors.grey)),
                                            ),
                                      onPressed: () {
                                        if (!isSelected) {
                                          _productCategoryExecutes.add(productCategory);
                                        } else {
                                          _productCategoryExecutes.removeWhere(
                                              (ProductCategory element) => element.id == productCategory.id);
                                        }
                                        _selectCountSubject.sink.add(_productCategoryExecutes.length);
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                    ],
                  ),
                ),
              ),
              if (widget.selectedItems != null &&
                  widget.selectedItems.any((ProductCategory item) => item.id == productCategory.id))
                const Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(
                    FontAwesomeIcons.checkCircle,
                    color: Color(0xff28A745),
                    size: 20,
                  ),
                )
            ],
          ),
          body: _buildChildren(productCategory.children, level: level + 1)),
    );
  }

  ///Xây dựng giao diện danh sách con thuộc một nhóm sản phẩm
  Widget _buildChildren(List<ProductCategory> productCategories, {int level = 0}) {
    return Column(
      children: productCategories
          .map((ProductCategory productCategory) => _buildProductCategory(productCategory, level: level))
          .toList(),
    );
  }

  ///Xây dựng giao diện mở rộng khi nhấn vào sẽ mở ra
  /// [header] là phần đầu
  /// [body] là phần thân
  /// [expanse] có mở ra lúc khởi tạo hay k và sau đó k thể cập nhật chỉ mở rông được bằng cách nhấn
  Widget _buildExpanse(
      {Widget header, Widget body, bool expanse = false, EdgeInsets underLinePadding = const EdgeInsets.all(0)}) {
    return CustomExpandTitle(
      expanseWhenClick: true,
      update: false,
      expanse: expanse,
      iconSpace: 10,
      headerBuilder: (BuildContext context, bool expanse) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(child: header),
                RotatedBox(
                  quarterTurns: expanse ? 2 : 0,
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color.fromARGB(255, 167, 178, 191),
                  ),
                ),
                const SizedBox(width: 16)
              ],
            ),
            Container(margin: underLinePadding, color: Colors.grey.shade200, height: 1, width: double.infinity),
            // const Divider(height: 2.0),
          ],
        );
      },
      body: body,
    );
  }
}
