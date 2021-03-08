import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tmt_flutter_untils/sources/num_utils/num_extensions.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/product_template_bloc.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/product_template_event.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/product_template_state.dart';
import 'package:tpos_mobile/feature_group/category/product_template/ui/add_edit/product_template_add_edit_page.dart';
import 'package:tpos_mobile/feature_group/category/product_template/ui/details/product_template_details_page.dart';
import 'package:tpos_mobile/feature_group/category/product_template/ui/list/custom_product_sliver.dart';
import 'package:tpos_mobile/feature_group/category/product_template/ui/list/product_template_drawer.dart';
import 'package:tpos_mobile/feature_group/category/product_template_tags/ui/tag_product_search_page.dart';
import 'package:tpos_mobile/src/tpos_apis/models/product_search_order_by.dart';
import 'package:tpos_mobile/widgets/bloc_widget/base_bloc_listener_ui.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/custom_dropdown.dart';
import 'package:tpos_mobile/widgets/custom_snack_bar.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/load_status.dart';
import 'package:tpos_mobile/widgets/loading_indicator.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

///Xây dựng giao diện danh sách productTemplate
///Khi ở chế độ [isSearchMode] thì chạm vào 1 item sẽ đóng trang hiện tại nếu
///[popWhenSelect] = true và Invoke callback [onSelected] (Chú ý onSelected != null)
class ProductTemplateListPage extends StatefulWidget {
  const ProductTemplateListPage(
      {Key key, this.isSearchMode = false, this.popWhenSelect = true, this.onSelected, this.keyword = ''})
      : super(key: key);

  @override
  _ProductTemplateListPageState createState() => _ProductTemplateListPageState();
  final bool isSearchMode;
  final bool popWhenSelect;
  final String keyword;
  final Function(ProductTemplate selectedProductTemplate) onSelected;
}

class _ProductTemplateListPageState extends State<ProductTemplateListPage> {
  ProductTemplateBloc _productTemplateBloc;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _tabController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<Tag> _selectedTags = [];
  String _keyword = '';
  bool _check = false;
  bool _selectAll = false;
  bool _listView = true;

  List<ProductTemplate> _productTemplates = <ProductTemplate>[];
  List<ProductTemplate> _productTemplateExecutes = <ProductTemplate>[];
  BaseListOrderBy _orderBy = BaseListOrderBy.DATE_CREATED_DECREASE;
  Map<BaseListOrderBy, String> _orderByList;

  @override
  void initState() {
    super.initState();
    _keyword = widget.keyword;
    _productTemplateBloc = ProductTemplateBloc();
    _productTemplateBloc.add(ProductTemplateStarted(search: _keyword));
  }

  @override
  void dispose() {
    super.dispose();
    _productTemplateBloc.close();
    _scrollController.dispose();
    _refreshController.dispose();
    _tabController.dispose();
    _focusNode.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _orderByList = {
      BaseListOrderBy.DATE_CREATED_DECREASE: S.of(context).newest,
      BaseListOrderBy.DATE_CREATED_INCREASE: S.of(context).oldest,
      BaseListOrderBy.NAME_ASC: S.of(context).nameAscending,
      BaseListOrderBy.NAME_DESC: S.of(context).nameDescending,
      BaseListOrderBy.PRICE_ASC: S.of(context).priceAscending,
      BaseListOrderBy.PRICE_DESC: S.of(context).priceDescending,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(),
      endDrawer: ProductTemplateEndDrawer(productTemplateBloc: _productTemplateBloc),
    );
  }

  Widget _buildBody() {
    return CustomProductSliver(
        productTemplateBloc: _productTemplateBloc,
        filter: _productTemplates != null ? _buildFilter() : const SizedBox(),
        scrollController: _scrollController,
        keyword: _keyword,
        autoFocus: widget.isSearchMode,
        onKeyWordChanged: (String keyword) {
          if (_keyword != keyword) {
            _keyword = keyword;
            // _productTemplateBloc = ProductTemplateBloc();
            // setState(() {});
            _productTemplateBloc.add(ProductTemplateSearched(search: _keyword));
          }
        },
        child: BaseBlocListenerUi<ProductTemplateBloc, ProductTemplateState>(
            errorBuilder: (BuildContext context, ProductTemplateState state) {
              String error = S.of(context).loadDataError;
              if (state is ProductTemplateLoadFailure) {
                error = state.error ?? S.of(context).loadDataError;
              }
              return SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    // if (_check) _buildCheckAction() else _buildUncheckAction(),
                    SizedBox(height: 50 * (MediaQuery.of(context).size.height / 700)),
                    LoadStatusWidget(
                      statusName: S.of(context).loadDataError,
                      content: error,
                      statusIcon: SvgPicture.asset('assets/icon/error.svg', width: 170, height: 130),
                      action: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: AppButton(
                          onPressed: () {
                            _productTemplateBloc.add(ProductTemplateRefreshed());
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  FontAwesomeIcons.sync,
                                  color: Colors.white,
                                  size: 23,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  S.of(context).refreshPage,
                                  style:
                                      const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
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
            bloc: _productTemplateBloc,
            listener: (BuildContext context, ProductTemplateState state) {
              if (state is ProductTemplateDeleteSuccess) {
                final Widget snackBar = getCloseableSnackBar(message: S.of(context).deleteSuccessful, context: context);
                Scaffold.of(context).showSnackBar(snackBar);
              } else if (state is ProductTemplateDeleteFailure) {
                App.showDefaultDialog(title: '', context: context, content: state.error, type: AlertDialogType.error);
              } else if (state is ProductTemplateAssignTagFailure) {
                App.showDefaultDialog(title: '', context: context, content: state.error, type: AlertDialogType.error);
              } else if (state is ProductTemplateAssignTagSuccess) {
                final Widget snackBar =
                    getCloseableSnackBar(message: S.of(context).assignTagSuccessful, context: context);
                Scaffold.of(context).showSnackBar(snackBar);
              }
            },
            loadingState: ProductTemplateLoading,
            busyState: ProductTemplateBusy,
            errorStates: const [ProductTemplateLoadFailure],
            builder: (BuildContext context, ProductTemplateState state) {
              _productTemplates = state.productTemplates;
              _productTemplateExecutes = state.productTemplateExecutes;
              _orderBy = state.orderBy;
              _selectAll = state.selectedAll;
              if (state is ProductTemplateLoadNoMore) {
                _refreshController.loadNoData();
              } else {
                _refreshController.loadComplete();
              }

              return _productTemplates != null
                  ? _productTemplates.isNotEmpty
                      ? _buildProductTemplateList()
                      : _buildEmptyList()
                  : const SizedBox();
            }));
  }

  Widget _buildFilter() {
    return BlocBuilder<ProductTemplateBloc, ProductTemplateState>(
        cubit: _productTemplateBloc,
        builder: (BuildContext context, ProductTemplateState state) {
          return _check ? _buildCheckAction() : _buildUncheckAction();
        });
  }

  ///Xây dựng giao diện khi không chọn thao tác
  Widget _buildUncheckAction() {
    return Container(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                const SizedBox(width: 5),
                CircularCheckBox(
                    value: _check,
                    activeColor: const Color.fromARGB(255, 40, 167, 69),
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    onChanged: (bool x) {
                      _check = x;
                      setState(() {});
                    }),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        S.of(context).manipulation,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 107, 114, 128), fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      Expanded(
                        child: Text(
                          '/ ${_productTemplates.length} ${S.of(context).products.toLowerCase()}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 146, 157, 170), fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)), color: Color.fromARGB(255, 248, 249, 251)),
                    child: CustomDropdown<BaseListOrderBy>(
                        selectedValue: _orderBy,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.only(bottom: 3, left: 5),
                              alignment: Alignment.centerLeft,
                              child: Text(_orderByList[_orderBy],
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  style: const TextStyle(color: Color.fromARGB(255, 107, 114, 128))),
                            ),
                            const Icon(Icons.arrow_drop_down),
                            const SizedBox(width: 10),
                          ],
                        ),
                        onSelected: (BaseListOrderBy selectedOrderBy) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          _productTemplateBloc.add(ProductTemplateSorted(orderBy: selectedOrderBy));
                        },
                        itemBuilder: (BuildContext context) => _orderByList.keys
                            .map((BaseListOrderBy action) => PopupMenuItem<BaseListOrderBy>(
                                  value: action,
                                  child: Text(
                                    _orderByList[action],
                                    style: const TextStyle(color: Color(0xff2C333A), fontSize: 15),
                                  ),
                                ))
                            .toList()),
                  ),
                ),
                const SizedBox(width: 10),
                ClipOval(
                  child: Container(
                    height: 40,
                    width: 40,
                    child: Material(
                      color: const Color.fromARGB(255, 248, 249, 251),
                      child: IconButton(
                        splashColor: Colors.green,
                        tooltip: S.of(context).horizontalList,
                        icon: Icon(
                          _listView ? FontAwesomeIcons.thLarge : FontAwesomeIcons.list,
                          color: const Color.fromARGB(255, 107, 114, 128),
                          size: 20,
                        ),
                        onPressed: () {
                          _listView = !_listView;
                          setState(() {});
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///Xây dựng giao diện khi chọn thao tác
  Widget _buildCheckAction() {
    return Container(
      height: 60,
      child: Row(
        children: [
          const SizedBox(width: 5),
          CircularCheckBox(
              value: _check,
              activeColor: const Color.fromARGB(255, 40, 167, 69),
              materialTapTargetSize: MaterialTapTargetSize.padded,
              onChanged: (bool value) {
                _check = value;
                if (!_check) {
                  _productTemplateBloc.add(ProductTemplateSelectAll(check: value));
                }
                setState(() {});
              }),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectAll ? _productTemplates.length.toString() : _productTemplateExecutes.length.toString(),
                  style: const TextStyle(
                      color: Color.fromARGB(255, 44, 51, 58), fontSize: 15, fontWeight: FontWeight.w500),
                ),
                Flexible(
                  child: Row(
                    children: [
                      StatefulBuilder(
                        builder: (BuildContext context, void Function(void Function()) setState) {
                          return CircularCheckBox(
                              value: _selectAll,
                              activeColor: const Color.fromARGB(255, 40, 167, 69),
                              materialTapTargetSize: MaterialTapTargetSize.padded,
                              onChanged: (bool value) {
                                setState(() {});
                                _productTemplateBloc.add(ProductTemplateSelectAll(check: value));
                              });
                        },
                      ),
                      Flexible(
                        child: Text(
                          '${S.of(context).selectAll} (${_productTemplates.length})',
                          style: const TextStyle(
                              color: Color.fromARGB(255, 44, 51, 58), fontSize: 15, fontWeight: FontWeight.w500),
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
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    background: const Color.fromARGB(255, 40, 167, 69),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 10),
                        Text(
                          S.of(context).manipulation,
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
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///Xây dựng danh sách product template
  Widget _buildProductTemplateList() {
    return SmartRefresher(
        enablePullDown: false,
        enablePullUp: true,
        header: CustomHeader(
          builder: (BuildContext context, RefreshStatus mode) {
            Widget body;
            if (mode == RefreshStatus.idle) {
              body = Text(
                S.of(context).pullDownToRefresh,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              );
            } else if (mode == RefreshStatus.canRefresh) {
              body = Text(
                S.of(context).releaseToGetData,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              );
            }
            return Container(
              height: 50,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text(
                S.of(context).pullUpToGetMoreData,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              );
            } else if (mode == LoadStatus.loading) {
              body = const LoadingIndicator();
            } else if (mode == LoadStatus.canLoading) {
              body = Text(
                S.of(context).releaseToGetMoreData,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              );
            } else {
              body = Text(
                S.of(context).noMoreData,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              );
            }
            return Container(
              height: 50,
              child: Center(child: body),
            );
          },
        ),
        onRefresh: () async {},
        onLoading: () async {
          _productTemplateBloc.add(ProductTemplateLoadedMore());
        },
        child: _listView
            ? SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                    children:
                        // [if (_productTemplates != null) _buildFilter() else const SizedBox()] +
                        _productTemplates
                            .map((ProductTemplate productTemplate) => InkWell(
                                  onLongPress: () {
                                    if (!_check) {
                                      _check = true;
                                      setState(() {});
                                    }
                                    final bool isSelected = _productTemplateExecutes
                                        .any((ProductTemplate item) => productTemplate.id == item.id);
                                    if (!isSelected) {
                                      _productTemplateBloc
                                          .add(ProductTemplateExecuteAdded(productTemplate: productTemplate));
                                    } else {
                                      _productTemplateBloc
                                          .add(ProductTemplateExecuteRemoved(productTemplate: productTemplate));
                                    }
                                  },
                                  onTap: () async {
                                    if (widget.isSearchMode) {
                                      widget.onSelected?.call(productTemplate);
                                      if (widget.popWhenSelect) {
                                        Navigator.of(context).pop();
                                      }
                                    } else {
                                      final bool isChange = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProductTemplateDetailsPage(
                                            productTemplate: productTemplate,
                                          ),
                                        ),
                                      );
                                      if (isChange != null && isChange) {
                                        _productTemplateBloc.add(ProductTemplateRefreshed());
                                      }
                                    }
                                  },
                                  child: _ProductTemplateItem(
                                    onAddTag: () async {
                                      _selectedTags = [];
                                      if (productTemplate.tags != null && productTemplate.tags.isNotEmpty) {
                                        _selectedTags.addAll(productTemplate.tags);
                                      }


                                      List<Tag> result;
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return TagProductListPage(
                                              selectedItems: _selectedTags,
                                              onSelected: (List<Tag> tags) {
                                                result = tags;
                                              },
                                            );
                                          },
                                        ),
                                      );

                                      if (result != null) {
                                        _productTemplateBloc.add(
                                            ProductTemplateAssignTag(tags: result, productTemplate: productTemplate));
                                      }
                                    },
                                    gridView: false,
                                    isUserCheck: _check,
                                    isSelected: _selectAll ||
                                        _productTemplateExecutes
                                            .any((ProductTemplate item) => productTemplate.id == item.id),
                                    productTemplateBloc: _productTemplateBloc,
                                    key: ValueKey<int>(productTemplate.id),
                                    productTemplate: productTemplate,
                                  ),
                                ))
                            .toList()),
              )
            : SingleChildScrollView(
                controller: _scrollController,
                child: Column(children: [
                  // if (_productTemplates != null) _buildFilter() else const SizedBox(),
                  Wrap(
                      children: _productTemplates
                          .map((ProductTemplate productTemplate) => InkWell(
                                onLongPress: () {
                                  if (!_check) {
                                    _check = true;
                                    setState(() {});
                                  }
                                  final bool isSelected = _productTemplateExecutes
                                      .any((ProductTemplate item) => productTemplate.id == item.id);
                                  if (!isSelected) {
                                    _productTemplateBloc
                                        .add(ProductTemplateExecuteAdded(productTemplate: productTemplate));
                                  } else {
                                    _productTemplateBloc
                                        .add(ProductTemplateExecuteRemoved(productTemplate: productTemplate));
                                  }
                                },
                                onTap: () async {
                                  if (widget.isSearchMode) {
                                    widget.onSelected?.call(productTemplate);
                                    if (widget.popWhenSelect) {
                                      Navigator.of(context).pop();
                                    }
                                  } else {
                                    final bool isChange = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductTemplateDetailsPage(
                                          productTemplate: productTemplate,
                                        ),
                                      ),
                                    );
                                    if (isChange != null && isChange) {
                                      _productTemplateBloc.add(ProductTemplateRefreshed());
                                    }
                                  }
                                },
                                child: _ProductTemplateItem(
                                  gridView: true,
                                  isUserCheck: _check,
                                  isSelected: _selectAll ||
                                      _productTemplateExecutes
                                          .any((ProductTemplate item) => productTemplate.id == item.id),
                                  productTemplateBloc: _productTemplateBloc,
                                  key: ValueKey<int>(productTemplate.id),
                                  productTemplate: productTemplate,
                                ),
                              ))
                          .toList())
                ]),
              ));
  }

  Widget _buildEmptyList() {
    return SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // if (_check) _buildCheckAction() else _buildUncheckAction(),
            SizedBox(height: 50 * (MediaQuery.of(context).size.height / 700)),
            LoadStatusWidget(
              statusName: S.of(context).searchNotFound,
              content: '${S.of(context).searchNotFoundWithKeyword} "$_keyword". ${S.of(context).searchProductAgain}',
              statusIcon: SvgPicture.asset('assets/icon/no-result.svg', width: 170, height: 130),
              action: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: AppButton(
                  onPressed: () {
                    _productTemplateBloc.add(ProductTemplateRefreshed());
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
        ));
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
              onPressed: () {
                ///TODO: thêm chức năng in mã vạch
              },
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  const Icon(
                    FontAwesomeIcons.print,
                    // color: Colors.white,
                    size: 23,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    S.of(context).printBarcode,
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
                final bool result = await App.showConfirm(
                    title: S.of(context).confirmDelete, content: S.of(context).productsDeleteConfirm);

                if (result != null && result) {
                  _productTemplateBloc.add(ProductTemplateDeleteSelected());
                  Navigator.of(context).pop();
                }
              },
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.delete,
                    size: 23,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    S.of(context).delete,
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

  Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) {
      buffer.write('ff');
    }
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  Widget _buildTag(Tag tag, {Function onDelete}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/icon/tag_green.svg',
          width: 16,
          height: 16,
          color: fromHex(tag.color),
        ),
        const SizedBox(width: 5),
        Text(
          tag.name,
          style: TextStyle(color: fromHex(tag.color)),
        ),
        ClipOval(
          child: Material(
            color: Colors.transparent,
            child: IconButton(
              iconSize: 20,
              icon: const Icon(
                Icons.clear,
                color: Color(0xffA7B2BF),
              ),
              onPressed: () async {
                onDelete?.call();
              },
            ),
          ),
        )
      ],
    );
  }
}

class _ProductTemplateItem extends StatelessWidget {
  const _ProductTemplateItem(
      {Key key,
      this.productTemplate,
      this.gridView,
      this.isUserCheck = false,
      this.productTemplateBloc,
      this.isSelected = false,
      this.onAddTag})
      : super(key: key);

  final ProductTemplate productTemplate;
  final bool gridView;
  final bool isUserCheck;
  final bool isSelected;
  final ProductTemplateBloc productTemplateBloc;
  final Function onAddTag;

  @override
  Widget build(BuildContext context) {
    return gridView ? _buildGridLayout(context) : _buildListLayout(context);
  }

  Widget _buildListLayout(BuildContext context) {
    return _buildActionSlide(
      key: ValueKey<int>(productTemplate.id),
      onDelete: () async {
        final bool result =
            await App.showConfirm(title: S.of(context).confirmDelete, content: S.of(context).productsDeleteConfirm);

        if (result != null && result) {
          productTemplateBloc.add(ProductTemplateRemoved(productTemplate: productTemplate));
        }
      },
      onEdit: () async {
        final bool isInsert = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (context) => ProductTemplateAddEditPage(
              productTemplate: productTemplate,
            ),
          ),
        );

        if (isInsert != null && isInsert) {
          productTemplateBloc.add(ProductTemplateRefreshed());
        }
      },
      onAddTag: () {
        onAddTag?.call();
      },
      child: Container(
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(width: 1.0, color: Color.fromARGB(255, 242, 244, 247)))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 10, left: 16),
              child: Container(
                width: 80,
                height: 80,
                // padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 13,
                      child: productTemplate.imageUrl != null && productTemplate.imageUrl != ''
                          ? CachedNetworkImage(
                              width: 60,
                              height: 60,
                              imageUrl: productTemplate.imageUrl,
                              progressIndicatorBuilder: (context, url, downloadProgress) =>
                                  CircularProgressIndicator(value: downloadProgress.progress),
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
                              errorWidget: (context, url, error) => Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                    color: const Color(0xffF8F9FB),
                                    border: Border.all(
                                      color: const Color(0xffF8F9FB),
                                    )),
                                child: SvgPicture.asset('assets/icon/empty-image-product.svg',
                                    width: 60, height: 60, fit: BoxFit.cover),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  color: const Color(0xffF8F9FB),
                                  border: Border.all(
                                    color: const Color(0xffF8F9FB),
                                  )),
                              child: SvgPicture.asset('assets/icon/empty-image-product.svg',
                                  width: 60, height: 60, fit: BoxFit.cover),
                            ),
                    ),
                    if (isUserCheck)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: ClipOval(
                          child: Container(
                            height: 40,
                            width: 40,
                            child: Material(
                              color: Colors.transparent,
                              child: IconButton(
                                iconSize: 25,
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
                                    productTemplateBloc
                                        .add(ProductTemplateExecuteAdded(productTemplate: productTemplate));
                                  } else {
                                    productTemplateBloc
                                        .add(ProductTemplateExecuteRemoved(productTemplate: productTemplate));
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),
            // const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 13),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  productTemplate.nameGet ?? '',
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 44, 51, 58),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: RichText(
                                  maxLines: null,
                                  text: TextSpan(
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: productTemplate.uOMName ?? '',
                                        style: const TextStyle(
                                            color: Color.fromARGB(255, 146, 157, 170),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const TextSpan(
                                        text: ' - ',
                                        style: TextStyle(
                                            color: Color.fromARGB(255, 146, 157, 170),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      TextSpan(
                                        text: S.of(context).realQuantity + ': ',
                                        style: const TextStyle(
                                            color: Color.fromARGB(255, 146, 157, 170),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      TextSpan(
                                        text: productTemplate.qtyAvailable.toVietnameseCurrencyFormat(
                                            null, Localizations.localeOf(context).languageCode),
                                        style: TextStyle(
                                            color: productTemplate.active
                                                ? productTemplate.qtyAvailable > 0
                                                    ? const Color.fromARGB(255, 40, 167, 69)
                                                    : const Color.fromARGB(255, 235, 59, 91)
                                                : const Color(0xffA7B2BF),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (productTemplate.tags.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: _buildTags(productTemplate.tags),
                            )
                          else
                            const SizedBox(),
                          if (!productTemplate.active)
                            Row(
                              children: [
                                Text(
                                  S.of(context).invalidProduct,
                                  style: const TextStyle(
                                      color: Color(0xffA7B2BF), fontSize: 15, fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      productTemplate.listPrice
                          .toVietnameseCurrencyFormat(null, Localizations.localeOf(context).languageCode),
                      style: TextStyle(
                          color: productTemplate.active
                              ? const Color.fromARGB(255, 107, 114, 128)
                              : const Color(0xffA7B2BF),
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildGridLayout(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width / 2,
      height: 280,
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.grey.withAlpha(50))),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.width / 2,
                    // padding: const EdgeInsets.only(top: 15, bottom: 15, left: 0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: productTemplate.imageUrl != null && productTemplate.imageUrl != ''
                        ? CachedNetworkImage(
                            imageUrl: productTemplate.imageUrl,
                            fit: BoxFit.cover,
                            imageBuilder: (BuildContext context, ImageProvider imageProvider) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10), topRight: Radius.circular(10)),
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
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                  color: const Color(0xfff8f9fb),
                                  border: Border.all(
                                    width: 1,
                                    color: const Color(0xffF8F9FB),
                                  )),
                              child: SvgPicture.asset('assets/icon/empty-image-product.svg',
                                  width: 50, height: 50, fit: BoxFit.cover),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                color: const Color(0xfff8f9fb),
                                border: Border.all(
                                  width: 1,
                                  color: const Color(0xffF8F9FB),
                                )),
                            child: SvgPicture.asset('assets/icon/empty-image-product.svg',
                                width: 50, height: 50, fit: BoxFit.cover),
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5, bottom: 12),
                  child: Column(
                    children: [
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              productTemplate.nameGet,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              maxLines: 5,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 44, 51, 58), fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: RichText(
                              maxLines: 2,
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                    text: productTemplate.uOMName ?? '',
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 146, 157, 170),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const TextSpan(
                                    text: ' - ',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 146, 157, 170),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  TextSpan(
                                    text: S.of(context).realQuantity + ': ',
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 146, 157, 170),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  TextSpan(
                                    text: productTemplate.qtyAvailable
                                        .toVietnameseCurrencyFormat(null, Localizations.localeOf(context).languageCode),
                                    style: TextStyle(
                                        color: productTemplate.active
                                            ? productTemplate.qtyAvailable > 0
                                                ? const Color.fromARGB(255, 40, 167, 69)
                                                : const Color.fromARGB(255, 235, 59, 91)
                                            : const Color(0xffA7B2BF),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      if (!productTemplate.active)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  S.of(context).invalidProduct,
                                  style: const TextStyle(
                                      color: Color(0xffA7B2BF), fontSize: 15, fontStyle: FontStyle.italic),
                                ),
                              ),
                            ],
                          ),
                        ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              productTemplate.listPrice
                                  .toVietnameseCurrencyFormat(null, Localizations.localeOf(context).languageCode),
                              style: TextStyle(
                                  color: productTemplate.active
                                      ? const Color.fromARGB(255, 107, 114, 128)
                                      : const Color(0xffA7B2BF),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // const SizedBox(height: 5),
                // if (productTemplate.tags.isNotEmpty)
                //   Wrap(
                //     spacing: 10,
                //     children: productTemplate.tags.map((Tag tag) => _buildTag(tag)).toList(),
                //   )
                // else
                //   const SizedBox()
              ],
            ),
          ),
          if (isUserCheck)
            Positioned(
              right: 10,
              top: 10,
              child: InkWell(
                onTap: () {
                  if (!isSelected) {
                    productTemplateBloc.add(ProductTemplateExecuteAdded(productTemplate: productTemplate));
                  } else {
                    productTemplateBloc.add(ProductTemplateExecuteRemoved(productTemplate: productTemplate));
                  }
                },
                child: ClipOval(
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? const Color.fromARGB(255, 40, 167, 69) : Colors.white,
                        border: Border.all(color: isSelected ? Colors.transparent : Colors.grey)),
                    child: Container(
                      child: isSelected
                          ? const Center(
                              child: Icon(
                                Icons.check,
                                size: 23.0,
                                color: Colors.white,
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionSlide({Key key, Widget child, Function onEdit, Function onDelete, Function onAddTag}) {
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
                  onAddTag?.call();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset('assets/icon/tag_green.svg',
                        color: const Color(0xff858F9B), width: 20, height: 20),
                    const SizedBox(height: 2),
                    Flexible(
                      child: Text(
                        S.current.addTag,
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

  Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) {
      buffer.write('ff');
    }
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  Widget _buildTags(List<Tag> tags) {
    return Container(
      width: double.infinity,
      child: Wrap(
        spacing: 10,
        runSpacing: 5,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.start,
        runAlignment: WrapAlignment.center,
        children: tags.map((Tag tag) => _buildTag(tag)).toList(),
      ),
    );
  }

  Widget _buildTag(Tag tag) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/icon/tag_green.svg',
          width: 16,
          height: 16,
          color: fromHex(tag.color),
        ),
        const SizedBox(width: 5),
        Text(
          tag.name,
          style: TextStyle(color: fromHex(tag.color)),
        ),
      ],
    );
  }
}
