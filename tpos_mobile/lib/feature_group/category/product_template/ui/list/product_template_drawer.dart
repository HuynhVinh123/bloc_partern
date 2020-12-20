import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/product_category/ui/product_category_list_page.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/product_template_bloc.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/product_template_event.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/product_template_state.dart';
import 'package:tpos_mobile/feature_group/category/tag_list_page.dart';
import 'package:tpos_mobile/widgets/bloc_widget/base_bloc_listener_ui.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/custom_expand_tile.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

///Xây dựng giao diện end drawer cho product template
class ProductTemplateEndDrawer extends StatefulWidget {
  const ProductTemplateEndDrawer({Key key, this.productTemplateBloc}) : super(key: key);

  @override
  _ProductTemplateEndDrawerState createState() => _ProductTemplateEndDrawerState();
  final ProductTemplateBloc productTemplateBloc;
}

class _ProductTemplateEndDrawerState extends State<ProductTemplateEndDrawer> {
  bool _isFilterByCategory = false;
  bool _isFilterByProductPrice = false;
  bool _isFilterByTag = false;
  bool _isLoad = false;
  int _filterCount = 0;
  final BehaviorSubject<int> _filterCountSubject = BehaviorSubject<int>();
  List<ProductPrice> _productPrices = <ProductPrice>[];
  final List<Tag> _filterTags = <Tag>[];
  List<Tag> _tags = <Tag>[];
  final List<ProductCategory> _productCategories = <ProductCategory>[];
  ProductPrice _productPrice;

  @override
  void initState() {
    _filterCountSubject.sink.add(_filterCount);
    super.initState();
  }

  @override
  void dispose() {
    _filterCountSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 80),
      child: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            StreamBuilder<int>(
              stream: _filterCountSubject.stream,
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                return Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 18),
                  color: const Color.fromARGB(255, 0, 142, 48),
                  child: SafeArea(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 16),
                        Text(
                          S.of(context).productFilter,
                          style: const TextStyle(fontSize: 21, color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 33,
                          height: 23,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(13)), color: Colors.white),
                          child: Center(
                              child: Text(
                            _filterCount.toString(),
                            style: const TextStyle(color: Color.fromARGB(255, 0, 142, 48), fontSize: 16),
                          )),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Expanded(
              child: BaseBlocListenerUi<ProductTemplateBloc, ProductTemplateState>(
                buildWhen: (ProductTemplateState last, ProductTemplateState current) {
                  return current is ProductTemplateLoadSuccess ||
                      current is ProductTemplateLoading ||
                      current is ProductTemplateLoadFailure ||
                      current is ProductTemplateDeleteFailure ||
                      current is ProductTemplateBusy;
                },
                bloc: widget.productTemplateBloc,
                reload: () {
                  widget.productTemplateBloc.add(ProductTemplateRefreshed());
                },
                loadingState: ProductTemplateLoading,
                busyState: ProductTemplateBusy,
                // listener: (BuildContext context, state) {
                //   _isFilterByCategory = state.isFilterCategory;
                //   _isFilterByProductPrice = state.isFilterProductPrice;
                //   _isFilterByTag = state.isFilterTag;
                //   _filterTags.clear();
                //   _filterTags.addAll(state.filterTags);
                //   _productCategories.clear();
                //   _productCategories.addAll(state.productCategories);
                //   _productPrice = state.productPrice;
                //   _tags = state.tags;
                //   _productPrices = state.productPrices;
                // },
                errorStates: const [ProductTemplateLoadFailure],
                builder: (BuildContext context, state) {
                  _isFilterByCategory = state.isFilterCategory;
                  _isFilterByProductPrice = state.isFilterProductPrice;
                  _isFilterByTag = state.isFilterTag;
                  _tags = state.tags;
                  if (!_isLoad) {
                    _isLoad = true;
                    if (_isFilterByCategory) {
                      _filterCount += 1;
                    }
                    if (_isFilterByProductPrice) {
                      _filterCount += 1;
                    }
                    if (_isFilterByTag) {
                      _filterCount += 1;
                    }
                    _filterCountSubject.sink.add(_filterCount);
                  }
                  _productCategories.clear();
                  _productCategories.addAll(state.productCategories);
                  _productPrice = state.productPrice;
                  _filterTags.clear();
                  _filterTags.addAll(state.filterTags);

                  _productPrices = state.productPrices;

                  return Column(
                    children: [
                      Expanded(child: _buildFilterGroup()),
                      Row(
                        children: [
                          const SizedBox(width: 10),
                          Flexible(
                            child: AppButton(
                              onPressed: () {
                                widget.productTemplateBloc.add(ProductTemplateFiltered(
                                    isFilterByCategory: false, isFilterByProductPrice: false, isFilterByTag: false));
                              },
                              background: const Color(0xffF0F1F3),
                              child: Text(
                                S.of(context).resetFilter,
                                style: const TextStyle(color: Color(0xff2c333a), fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: StreamBuilder<int>(
                              stream: _filterCountSubject.stream,
                              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                                return AppButton(
                                  onPressed: () {
                                    widget.productTemplateBloc.add(ProductTemplateFiltered(
                                        isFilterByCategory: _isFilterByCategory,
                                        isFilterByProductPrice: _isFilterByProductPrice,
                                        isFilterByTag: _isFilterByTag));
                                    Navigator.of(context).pop();
                                  },
                                  background: const Color(0xff28A745),
                                  child: Text(
                                    '${S.of(context).applyFilter} ($_filterCount)',
                                    style: const TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                      const SizedBox(height: 20)
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///Xây dựng giao diện lọc  'Nhóm sản phẩm','Theo nhãn',
  Widget _buildFilterGroup() {
    return Column(
      children: [
        StatefulBuilder(
          builder: (a, setState) => _ItemCheck(
            check: _isFilterByCategory,
            name: S.of(context).filterByProductCategories,
            onCheckChanged: (bool value) {
              _isFilterByCategory = value;
              if (_isFilterByCategory) {
                _filterCount += 1;
                _filterCountSubject.sink.add(_filterCount);
              } else {
                _filterCount -= 1;
                _filterCountSubject.sink.add(_filterCount);
              }
            },
            body: Padding(
              padding: const EdgeInsets.only(left: 40, right: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _productCategories
                              .map(
                                  (ProductCategory productCategory) => _buildFilterItem(productCategory.name ?? '', () {
                                        setState(() {
                                          _productCategories.remove(productCategory);
                                        });

                                        widget.productTemplateBloc.add(ProductTemplateFilterAdded(
                                            productCategories: _productCategories,
                                            productPrice: _productPrice,
                                            filterTags: _filterTags));
                                      }))
                              .toList() +
                          [
                            _buildAddButton(S.of(context).addAnotherProductCategoryFilter, () async {
                              final ProductCategory productCategory = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProductCategoriesPage(
                                    searchModel: true,
                                  ),
                                ),
                              );
                              if (productCategory != null) {
                                if (_productCategories.isEmpty ||
                                    !_productCategories.any((item) => item.id == productCategory.id)) {
                                  setState(() {
                                    _productCategories.add(productCategory);
                                  });
                                  widget.productTemplateBloc.add(ProductTemplateFilterAdded(
                                      productCategories: _productCategories,
                                      productPrice: _productPrice,
                                      filterTags: _filterTags));
                                }
                              }
                            })
                          ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        _ItemCheck(
          check: _isFilterByProductPrice,
          name: S.of(context).filterByPriceList,
          onCheckChanged: (bool value) {
            _isFilterByProductPrice = value;
            if (_isFilterByProductPrice) {
              _filterCount += 1;
              _filterCountSubject.sink.add(_filterCount);
            } else {
              _filterCount -= 1;
              _filterCountSubject.sink.add(_filterCount);
            }
          },
          body: _buildDropDownProductPrice(),
        ),
        StatefulBuilder(
          builder: (a, setState) => _ItemCheck(
            check: _isFilterByTag,
            name: S.of(context).filterByTags,
            onCheckChanged: (bool value) {
              _isFilterByTag = value;
              if (_isFilterByTag) {
                _filterCount += 1;
                _filterCountSubject.sink.add(_filterCount);
              } else {
                _filterCount -= 1;
                _filterCountSubject.sink.add(_filterCount);
              }
            },
            body: Padding(
              padding: const EdgeInsets.only(left: 40, right: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      runAlignment: WrapAlignment.start,
                      spacing: 10,
                      runSpacing: 10,
                      children: _filterTags
                              .map((Tag tag) => _buildFilterItem(tag.name ?? '', () {
                                    setState(() {
                                      _filterTags.remove(tag);
                                    });
                                    widget.productTemplateBloc.add(ProductTemplateFilterAdded(
                                        productCategories: _productCategories,
                                        productPrice: _productPrice,
                                        filterTags: _filterTags));
                                  }))
                              .toList() +
                          [
                            _buildAddButton(S.of(context).addAnotherTagFilter, () async {
                              final Tag tag = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TagListPage(
                                    tags: _tags,
                                  ),
                                ),
                              );
                              if (tag != null) {
                                if (_filterTags.isEmpty || !_filterTags.any((item) => item.id == tag.id)) {
                                  setState(() {
                                    _filterTags.add(tag);
                                  });
                                  widget.productTemplateBloc.add(ProductTemplateFilterAdded(
                                      productCategories: _productCategories,
                                      productPrice: _productPrice,
                                      filterTags: _filterTags));
                                }
                              }
                            }),
                          ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropDownProductPrice() {
    return Container(
      height: 40,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1.0,
            color: Color.fromARGB(255, 242, 244, 247),
          ),
        ),
      ),
      child: StatefulBuilder(
        builder: (a, setState) => DropdownButtonHideUnderline(
          child: DropdownButton<ProductPrice>(
            icon: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const <Widget>[
                Icon(
                  Icons.arrow_drop_down,
                  color: Color.fromARGB(255, 133, 143, 155),
                ),
                SizedBox(width: 10),
              ],
            ),
            hint: Padding(
              padding: const EdgeInsets.only(left: 45, top: 5),
              child: Text(
                S.of(context).selectProductPriceFilter,
                style: const TextStyle(color: Color.fromARGB(255, 146, 157, 170)),
              ),
            ),
            value: _productPrice,
            isExpanded: true,
            onChanged: (ProductPrice productPrice) {
              setState(() {
                _productPrice = productPrice;
              });
              widget.productTemplateBloc.add(ProductTemplateFilterAdded(
                  productCategories: _productCategories, productPrice: _productPrice, filterTags: _filterTags));
            },
            selectedItemBuilder: (BuildContext context) {
              return _productPrices.map<Widget>((ProductPrice item) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(width: 42),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(item.name,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: const TextStyle(color: Color.fromARGB(255, 107, 114, 128))),
                      ),
                    ),
                    ClipOval(
                      child: Container(
                        height: 40,
                        width: 40,
                        child: Material(
                          color: Colors.transparent,
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Color.fromARGB(255, 107, 114, 128),
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _productPrice = null;
                              });
                              widget.productTemplateBloc.add(ProductTemplateFilterAdded(
                                  productCategories: _productCategories,
                                  productPrice: _productPrice,
                                  filterTags: _filterTags));
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList();
            },
            items: _productPrices
                .map(
                  (priceList) => DropdownMenuItem<ProductPrice>(
                    value: priceList,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        priceList.name,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterItem(String name, VoidCallback onDeleted) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 20, right: 5),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)), color: Color.fromARGB(255, 240, 241, 243)),
          child: Row(
            children: [
              Text(name, style: const TextStyle(color: Color.fromARGB(255, 44, 51, 58), fontSize: 15)),
              ClipOval(
                child: Container(
                  height: 35,
                  width: 40,
                  child: Material(
                    color: Colors.transparent,
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Color.fromARGB(255, 133, 143, 155),
                        size: 20,
                      ),
                      onPressed: () {
                        onDeleted?.call();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton(String name, VoidCallback addCallBack) {
    return Row(
      children: [
        AppButton(
          height: 35,
          width: null,
          onPressed: addCallBack,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color.fromARGB(255, 40, 167, 69)),
              borderRadius: const BorderRadius.all(Radius.circular(30))),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add, color: Color.fromARGB(255, 40, 167, 69)),
                Text(
                  name,
                  style: const TextStyle(color: Color.fromARGB(255, 40, 167, 69), fontSize: 15),
                ),
                const SizedBox(width: 5),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

///Xây dựng giao diện lọc điều kiện
class _ItemCheck extends StatefulWidget {
  const _ItemCheck({Key key, this.check = false, this.name, this.onCheckChanged, this.body}) : super(key: key);

  @override
  __ItemCheckState createState() => __ItemCheckState();
  final bool check;
  final String name;
  final Widget body;
  final Function(bool) onCheckChanged;
}

class __ItemCheckState extends State<_ItemCheck> {
  bool _check = false;

  @override
  void initState() {
    super.initState();
    _check = widget.check;
  }

  @override
  void didUpdateWidget(covariant _ItemCheck oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_check != widget.check) {
      setState(() {});
      _check = widget.check;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildExpanse(
        header: Row(
          children: [
            Checkbox(
              value: _check,
              onChanged: (bool value) {
                _check = value;
                setState(() {});
                widget.onCheckChanged?.call(value);
              },
            ),
            Text(widget.name ?? '', style: const TextStyle(color: Color.fromARGB(255, 44, 51, 58), fontSize: 15)),
          ],
        ),
        body: widget.body,
        expanse: _check,
      ),
    );
  }

  ///Xây dựng giao diện mở rộng
  /// [header] là phần đầu
  /// [body] là phần thân
  /// [expanse] có mở hay không
  Widget _buildExpanse({Widget header, Widget body, bool expanse = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 0),
      child: CustomExpandTitle(
        expanseWhenClick: false,
        expanse: expanse,
        iconSpace: 10,
        header: header,
        iconBuilder: (BuildContext context, bool expanse) {
          return RotatedBox(
            quarterTurns: expanse ? 1 : 0,
            child: const Icon(
              Icons.keyboard_arrow_down,
              color: Color.fromARGB(255, 167, 178, 191),
            ),
          );
        },
        body: body,
      ),
    );
  }
}
