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
import 'package:tpos_mobile/widgets/custom_dropdown.dart';
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

class _ProductCategoriesPageState extends State<ProductCategoriesPage>
    with AutomaticKeepAliveClientMixin {
  ProductCategoryBloc _productCategoryBloc;
  List<ProductCategory> _productCategories = [];
  List<ProductCategory> _allProductCategories = [];
  List<ProductCategory> _productCategoryExecutes = [];

  final Map<String, bool> _filterMap = <String, bool>{
    S.current.all: null,
    S.current.filterDisable: true,
    S.current.filterActive: false
  };

  String _search = '';
  bool _check = false;
  bool _deleteExecutes = false;
  bool _selectAll = false;
  String _filter = S.current.all;
  int _totalProductCategory = 0;
  double _paddingTop = 0;
  final BehaviorSubject<int> _selectCountSubject = BehaviorSubject<int>();
  final GlobalKey<SearchAppBarState> _searchKey =
      GlobalKey<SearchAppBarState>();

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
    super.build(context);
    _paddingTop = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildAppBar() {
    return SearchAppBar(
      key: _searchKey,
      title: S.current.productCategory,
      text: _search,
      hideBackWhenSearch: true,
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
                  if (_search != '') {
                    _searchKey.currentState.openSearch();
                  }
                  if (productCategory != null) {
                    _productCategoryBloc.add(ProductCategoryRefreshed());
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return BaseBlocListenerUi<ProductCategoryBloc, ProductCategoryState>(
      bloc: _productCategoryBloc,
      loadingState: ProductCategoryLoading,
      busyState: ProductCategoryBusy,
      errorState: ProductCategoryLoadFailure,
      errorBuilder: (BuildContext context, ProductCategoryState state) {
        String error = S.current.canNotGetDataFromServer;
        if (state is ProductCategoryLoadFailure) {
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
                      _productCategoryBloc
                          .add(ProductCategoryStarted(current: widget.current));
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
      listener: (BuildContext context, ProductCategoryState state) {
        if (state is ProductCategoryDeleteFailure) {
          App.showDefaultDialog(
              title: S.current
                  .canNotDeleteParam(S.current.productCategory.toLowerCase()),
              context: context,
              type: AlertDialogType.error,
              content: state.error);
        } else if (state is ProductCategoryDeleteSuccess) {
          final Widget snackBar = getCloseableSnackBar(
              message: S.current.deleteSuccessful, context: context);
          Scaffold.of(context).showSnackBar(snackBar);
          _productCategoryExecutes
              .removeWhere((element) => element.id == state.productCategory.id);
        } else if (state is ProductCategoryDeleteTemporarySuccess) {
          final Widget snackBar = getCloseableSnackBar(
              message: S.current.deleteSuccessful, context: context);
          Scaffold.of(context).showSnackBar(snackBar);
          _productCategoryExecutes.clear();
        } else if (state is ProductCategoryFilterSuccess) {
          _productCategoryExecutes.clear();
        }
      },
      builder: (BuildContext context, ProductCategoryState state) {
        if (state is ProductCategoryLoadSuccess) {
          _productCategories = state.productCategories;
          _totalProductCategory = state.total;
          _totalProductCategory = _productCategories.length;
          _allProductCategories = state.allProductCategories;
        }

        return Column(
          children: [
            if (_check) _buildCheckAction() else _buildUncheckAction(),
            Expanded(
                child: _productCategories.isEmpty
                    ? _buildEmptyList()
                    : _buildProductCategories()),
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
                        color: Color.fromARGB(255, 44, 51, 58),
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
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
                          if (!_selectAll) {
                            _productCategoryExecutes.clear();
                          } else {
                            _productCategoryExecutes =
                                _allProductCategories.clone();
                          }
                          setState(() {});
                        }),
                    Flexible(
                      child: Text(
                        '${S.current.selectAll} (${_allProductCategories.length})',
                        style: const TextStyle(
                            color: Color.fromARGB(255, 44, 51, 58),
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: AppButton(
                  borderRadius: 30,
                  height: 35,
                  width: null,
                  background: const Color.fromARGB(255, 40, 167, 69),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 10),
                      Text(
                        S.current
                            .selectParam(S.current.manipulation.toLowerCase()),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 5),
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
        const SizedBox(width: 10),
        Container(
          margin: const EdgeInsets.only(top: 5, bottom: 0),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Color.fromARGB(255, 248, 249, 251)),
          child: CustomDropdown<String>(
              selectedValue: _filter,
              offset: Offset(0, _paddingTop + 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(width: 10),
                  Container(
                    padding:
                        const EdgeInsets.only(bottom: 10, left: 5, top: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(_filter,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: const TextStyle(color: Color(0xff2C333A))),
                  ),
                  const Icon(Icons.arrow_drop_down),
                  const SizedBox(width: 10),
                ],
              ),
              onSelected: (String filter) {
                if (_filter != filter) {
                  _filter = filter;
                  _selectAll = false;
                  _productCategoryExecutes.clear();
                  _productCategoryBloc
                      .add(ProductCategoryFiltered(filter: _filterMap[filter]));
                }
              },
              itemBuilder: (BuildContext context) => _filterMap.keys
                  .map((String filter) => PopupMenuItem<String>(
                        value: filter,
                        child: Text(
                          filter,
                          style: const TextStyle(
                              color: Color(0xff2C333A), fontSize: 15),
                        ),
                      ))
                  .toList()),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                S.current.manipulation,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Color(0xff6B7280),
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
              Flexible(
                child: Text(
                  ' / ${_allProductCategories.length} ${S.current.products.toLowerCase()}',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 146, 157, 170),
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
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
                if ((_productCategoryExecutes.isEmpty && !_selectAll) ||
                    (_productCategories.isEmpty)) {
                  Navigator.of(context).pop();
                  App.showDefaultDialog(
                      title: S.current.warning,
                      context: context,
                      type: AlertDialogType.warning,
                      content: S.current.noSelectNotificationWarning(
                          S.current.productCategories.toLowerCase()));
                } else {
                  if (_selectAll) {
                    _productCategoryBloc.add(ProductCategoryTemporaryDeleted(
                        selectAll: true, isDelete: false));
                  } else {
                    _deleteExecutes = true;
                    _productCategoryBloc.add(ProductCategoryTemporaryDeleted(
                        productCategories: _productCategoryExecutes,
                        isDelete: false));
                  }

                  Navigator.of(context).pop();
                }
              },
              child: Row(
                children: [
                  const SizedBox(width: 14),
                  const Icon(
                    Icons.check_circle,
                    color: Color(0xff28A745),
                    size: 23,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    S.current.disableDeleteTemporary,
                    style:
                        const TextStyle(color: Color(0xff2C333A), fontSize: 17),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: AppButton(
              background: Colors.transparent,
              onPressed: () async {
                final bool result = await App.showConfirm(
                    title: S.current.confirmDelete,
                    content: S.current.deleteSelectConfirmParam(
                        S.current.productCategory.toLowerCase()));

                if (result != null && result) {
                  if ((_productCategoryExecutes.isEmpty && !_selectAll) ||
                      (_productCategories.isEmpty)) {
                    Navigator.of(context).pop();
                    App.showDefaultDialog(
                        title: S.current.warning,
                        context: context,
                        type: AlertDialogType.warning,
                        content: S.current.noSelectNotificationWarning(
                            S.current.productCategories.toLowerCase()));
                  } else {
                    if (_selectAll) {
                      _productCategoryBloc.add(
                          ProductCategoryTemporaryDeleted(selectAll: true));
                    } else {
                      _deleteExecutes = true;
                      _productCategoryBloc.add(ProductCategoryTemporaryDeleted(
                          productCategories: _productCategoryExecutes));
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
                    S.current.deleteTemporary,
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
                statusName: S.current.noData,
                content: _filterMap[_filter] != null
                    ? S.current.searchOrFilterNotMatchProductCategory(_search)
                    : S.current.searchNotMatchProductCategory(_search),
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
                content: _filterMap[_filter] != null
                    ? S.current.emptyFilterNotificationParam(
                        S.current.productCategory.toLowerCase())
                    : S.current.emptyNotificationParam(
                        S.current.productCategory.toLowerCase()),
                action: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: AppButton(
                    onPressed: () async {
                      final ProductCategory productCategory =
                          await Navigator.push(
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
                                S.current.productCategory.toLowerCase()),
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

  ///Xây dựng nhóm sản phẩm
  Widget _buildProductCategory(ProductCategory productCategory,
      {int level = 0}) {
    return productCategory.children.isNotEmpty
        ? _buildProductCategoryHasChild(productCategory, level: level)
        : _buildBasicProductCategory(productCategory, level: level);
  }

  ///Xây dựng giao diện productCategory khi không có con
  Widget _buildBasicProductCategory(ProductCategory productCategory,
      {int level = 0}) {
    return _buildSlidable(
      key: productCategory.id,
      onDelete: () async {
        final bool result = await App.showConfirm(
            title: S.current.confirmDelete,
            content: S.current.deleteSelectConfirmParam(
                S.current.productCategory.toLowerCase()));

        if (result != null && result) {
          _productCategoryBloc
              .add(ProductCategoryDeleted(productCategory: productCategory));
        }
      },
      onEdit: () async {
        final ProductCategory result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ProductCategoryAddEditPage(
                productCategory: productCategory,
              );
            },
          ),
        );

        if (result != null) {
          productCategory = result;
          _productCategoryBloc.add(ProductCategoryRefreshed());
        }
      },
      child: Column(
        children: [
          Stack(
            children: [
              ListTile(
                onTap: () async {
                  if (widget.searchModel) {
                    widget.onSelected?.call(productCategory);
                    Navigator.pop(context, productCategory);
                  } else {
                    final ProductCategory result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ProductCategoryViewPage(
                              productCategory: productCategory);
                        },
                      ),
                    );

                    if (result != null) {
                      productCategory = result;
                      _productCategoryBloc.add(ProductCategoryRefreshed());
                    }
                  }
                },
                contentPadding: EdgeInsets.only(
                    left: 40.0 * level + 5 + 16, top: 5, right: 5, bottom: 5),
                title: Row(
                  children: [
                    Expanded(
                        child: productCategory.isDelete
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productCategory.name ?? '',
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                        fontSize: 17, color: Color(0xff2C333A)),
                                  ),
                                  Text(
                                    S.current.invalid,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xff929DAA),
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                productCategory.name ?? '',
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                    fontSize: 17, color: Color(0xff2C333A)),
                              )),
                    if (widget.selectedItems != null &&
                        widget.selectedItems.any((ProductCategory item) =>
                            item.id == productCategory.id))
                      const Padding(
                        padding: EdgeInsets.only(right: 27, top: 3),
                        child: Icon(
                          Icons.check_circle,
                          color: Color(0xff28A745),
                          size: 23,
                        ),
                      )
                  ],
                ),
                leading: CircleAvatar(
                  backgroundColor: productCategory.isDelete
                      ? const Color(0xffE9EDF2)
                      : const Color(0xffE9F6EC),
                  child: Text(
                    productCategory != null && productCategory.name != ''
                        ? productCategory.name.substring(0, 1)
                        : '',
                    style: TextStyle(
                        color: productCategory.isDelete
                            ? const Color(0xff5A6271)
                            : const Color(0xff28A745)),
                  ),
                ),
                // leading: CircleAvatar(
                //   backgroundColor: const Color(0xffE9F6EC),
                //   child: Text(
                //     productCategory != null && productCategory.name != '' ? productCategory.name.substring(0, 1) : '',
                //     style: const TextStyle(color: Color(0xff28A745)),
                //   ),
                // ),
              ),
              if (_check)
                Positioned(
                  left: 5 + 40.0 * level,
                  top: 0,
                  child: StatefulBuilder(
                    builder: (BuildContext context,
                        void Function(void Function()) setStateLocal) {
                      final bool isSelected = _productCategoryExecutes
                          .any((element) => element.id == productCategory.id);
                      // if (_selectAll) {
                      //   isSelected = _selectAll;
                      // }
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
                                              ? const Color.fromARGB(
                                                  255, 40, 167, 69)
                                              : Colors.white,
                                          border: Border.all(
                                              color: isSelected
                                                  ? Colors.transparent
                                                  : Colors.grey)),
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
                                              ? const Color.fromARGB(
                                                  255, 40, 167, 69)
                                              : Colors.white,
                                          border: Border.all(
                                              color: isSelected
                                                  ? Colors.transparent
                                                  : Colors.grey)),
                                    ),
                              onPressed: () {
                                if (_selectAll) {
                                  _selectAll = false;
                                  _productCategoryExecutes.clear();
                                  _productCategoryExecutes =
                                      _allProductCategories.clone();
                                  _productCategoryExecutes.removeWhere(
                                      (element) =>
                                          element.id == productCategory.id);
                                  setState(() {});
                                } else {
                                  if (!_productCategoryExecutes.any((element) =>
                                      element.id == productCategory.id)) {
                                    _productCategoryExecutes
                                        .add(productCategory);
                                  } else {
                                    _productCategoryExecutes.removeWhere(
                                        (ProductCategory element) =>
                                            element.id == productCategory.id);
                                  }
                                  _selectCountSubject.sink
                                      .add(_productCategoryExecutes.length);
                                  setStateLocal(() {});
                                }

                                // if (_selectAll) {
                                //   _selectAll = false;
                                //   _productCategoryExecutes.clear();
                                //   _productCategoryExecutes = _allProductCategories.clone();
                                // }
                                //
                                // if (!isSelected) {
                                //   _productCategoryExecutes.add(productCategory);
                                // } else {
                                //   _productCategoryExecutes
                                //       .removeWhere((ProductCategory element) => element.id == productCategory.id);
                                // }
                                // _selectCountSubject.sink.add(_productCategoryExecutes.length);
                                // setStateLocal(() {});
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
          Container(
              margin: EdgeInsets.only(left: level != 0 ? 40.0 * level + 21 : 0),
              color: Colors.grey.shade200,
              height: 1,
              width: double.infinity),
        ],
      ),
    );
  }

  ///Xây dựng giao diện productCategory khi có con
  Widget _buildProductCategoryHasChild(ProductCategory productCategory,
      {int level = 0}) {
    return _buildSlidable(
      key: productCategory.id,
      onDelete: () async {
        final bool result = await App.showConfirm(
            title: S.current.confirmDelete,
            content: S.current.deleteSelectConfirmParam(
                S.current.productCategory.toLowerCase()));

        if (result != null && result) {
          _productCategoryBloc
              .add(ProductCategoryDeleted(productCategory: productCategory));
        }
      },
      onEdit: () async {
        final ProductCategory result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ProductCategoryAddEditPage(
                productCategory: productCategory,
              );
            },
          ),
        );

        if (result != null) {
          productCategory = result;
          _productCategoryBloc.add(ProductCategoryRefreshed());
        }
      },
      child: Stack(
        children: [
          CustomExpandTile(
            key: ValueKey<String>('Expand${productCategory.id}'),
            update: _search != '',
            expanse: _search != '',
            onTap: () async {
              if (widget.searchModel) {
                widget.onSelected?.call(productCategory);
                Navigator.pop(context, productCategory);
              } else {
                final ProductCategory result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ProductCategoryViewPage(
                          productCategory: productCategory);
                    },
                  ),
                );

                if (result != null) {
                  _productCategoryBloc.add(ProductCategoryRefreshed());
                }
              }
            },
            underLine: Container(
                margin:
                    EdgeInsets.only(left: level != 0 ? 40.0 * level + 21 : 0),
                color: Colors.grey.shade200,
                height: 1,
                width: double.infinity),
            body: _buildChildren(productCategory.children, level: level + 1),
            contentPadding: EdgeInsets.only(
                left: 40.0 * level + 21, bottom: 5, right: 0, top: 5),
            title: Row(
              children: [
                Expanded(
                    child: productCategory.isDelete
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productCategory.name ?? '',
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                    fontSize: 17, color: Color(0xff2C333A)),
                              ),
                              Text(
                                S.current.invalid,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xff929DAA),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            productCategory.name ?? '',
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                fontSize: 17, color: Color(0xff2C333A)),
                          )),
                if (widget.selectedItems != null &&
                    widget.selectedItems.any((ProductCategory item) =>
                        item.id == productCategory.id))
                  const Icon(
                    Icons.check_circle,
                    color: Color(0xff28A745),
                    size: 23,
                  )
              ],
            ),
            leading: CircleAvatar(
              backgroundColor: productCategory.isDelete
                  ? const Color(0xffE9EDF2)
                  : const Color(0xffE9F6EC),
              child: Text(
                productCategory != null && productCategory.name != ''
                    ? productCategory.name.substring(0, 1)
                    : '',
                style: TextStyle(
                    color: productCategory.isDelete
                        ? const Color(0xff5A6271)
                        : const Color(0xff28A745)),
              ),
            ),
          ),
          if (productCategory.children.isNotEmpty)
            Positioned(
              top: 32,
              left: 48 + 40.0 * level,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: productCategory.isDelete
                      ? const Color(0xff5A6271)
                      : const Color(0xff28A745),
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
              left: 5 + 40.0 * level,
              top: 0,
              child: StatefulBuilder(
                builder: (BuildContext context,
                    void Function(void Function()) setStateLocal) {
                  bool isSelected = false;
                  if (_check) {
                    isSelected = _productCategoryExecutes
                        .any((element) => element.id == productCategory.id);
                  }
                  // if (_selectAll) {
                  //   isSelected = _selectAll;
                  // }
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
                                          ? const Color.fromARGB(
                                              255, 40, 167, 69)
                                          : Colors.white,
                                      border: Border.all(
                                          color: isSelected
                                              ? Colors.transparent
                                              : Colors.grey)),
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
                                          ? const Color.fromARGB(
                                              255, 40, 167, 69)
                                          : Colors.white,
                                      border: Border.all(
                                          color: isSelected
                                              ? Colors.transparent
                                              : Colors.grey)),
                                ),
                          onPressed: () {
                            if (_selectAll) {
                              _selectAll = false;
                              _productCategoryExecutes.clear();
                              _productCategoryExecutes =
                                  _allProductCategories.clone();
                              _productCategoryExecutes.removeWhere((element) =>
                                  element.id == productCategory.id);
                              setState(() {});
                            } else {
                              if (!_productCategoryExecutes.any((element) =>
                                  element.id == productCategory.id)) {
                                _productCategoryExecutes.add(productCategory);
                              } else {
                                _productCategoryExecutes.removeWhere(
                                    (ProductCategory element) =>
                                        element.id == productCategory.id);
                              }
                              _selectCountSubject.sink
                                  .add(_productCategoryExecutes.length);
                              setStateLocal(() {});
                            }
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
    );
  }

  ///Xây dựng giao diện có thể slide để xóa và sửa
  Widget _buildSlidable(
      {int key, Widget child, Function onDelete, Function onEdit}) {
    return Slidable(
      key: ValueKey<int>(key),
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
                        S.current.edit,
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
                        S.current.delete,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
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

  ///Xây dựng giao diện danh sách con thuộc một nhóm sản phẩm
  Widget _buildChildren(List<ProductCategory> productCategories,
      {int level = 0}) {
    return Column(
      children: productCategories
          .map((ProductCategory productCategory) =>
              _buildProductCategory(productCategory, level: level))
          .toList(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
