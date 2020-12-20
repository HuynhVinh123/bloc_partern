import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/product_uom/bloc/product_uom_bloc.dart';
import 'package:tpos_mobile/feature_group/category/product_uom/bloc/product_uom_event.dart';
import 'package:tpos_mobile/feature_group/category/product_uom/bloc/product_uom_state.dart';
import 'package:tpos_mobile/feature_group/category/product_uom/ui/product_uom_add_edit_page.dart';
import 'package:tpos_mobile/feature_group/category/product_uom/ui/product_uom_view_page.dart';
import 'package:tpos_mobile/feature_group/category/product_uom_category/ui/product_uom_categories_page.dart';
import 'package:tpos_mobile/widgets/bloc_widget/base_bloc_listener_ui.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/custom_expand_tile.dart';
import 'package:tpos_mobile/widgets/load_status.dart';
import 'package:tpos_mobile/widgets/search_app_bar.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

///Màn hình danh sách đơn vị tính
///[searchModel] nếu true thì khi ta nhấn vào đơn vị tính sẽ trả về kết quả đơn vị tính đó cho màn hình phía trước
///[onSelected] gọi khi ta chọn vào đơn vị tính
///[selectedItems] danh sách các sản phẩm đã chọn, danh sách sẽ đánh dấu các sản phẩm đã được chọn
///[categoryId] chỉ hiện thị danh sách của nhóm đơn vị đó
class ProductUomsPage extends StatefulWidget {
  const ProductUomsPage(
      {Key key, this.searchModel = false, this.onSelected, this.selectedItems = const <ProductUOM>[], this.categoryId})
      : super(key: key);

  @override
  _ProductUomsPageState createState() => _ProductUomsPageState();
  final bool searchModel;
  final Function(ProductUOM) onSelected;

  final List<ProductUOM> selectedItems;
  final int categoryId;
}

class _ProductUomsPageState extends State<ProductUomsPage> {
  ProductUomBloc _productUomBloc;
  List<ProductUomCategory> _productUomCategories;
  String _search = '';

  @override
  void initState() {
    _productUomBloc = ProductUomBloc();
    _productUomBloc.add(ProductUomStarted(categoryId: widget.categoryId));
    super.initState();
  }

  @override
  void dispose() {
    _productUomBloc.close();
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
        title: S.of(context).unit,
        text: _search,
        onKeyWordChanged: (String search) {
          if (_search != search) {
            _search = search;
            _productUomBloc.add(ProductUomSearched(search: _search));
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
                    Icons.folder_open_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    final bool change = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const ProductUomCategoriesPage();
                        },
                      ),
                    );

                    if (change != null && change) {
                      _productUomBloc.add(ProductUomRefreshed());
                    }
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
                    final ProductUOM productUom = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const ProductUomAddEditPage();
                        },
                      ),
                    );

                    if (productUom != null) {
                      _productUomBloc.add(ProductUomRefreshed());
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
    return BaseBlocListenerUi<ProductUomBloc, ProductUomState>(
      bloc: _productUomBloc,
      loadingState: ProductUomLoading,
      busyState: ProductUomBusy,
      errorBuilder: (BuildContext context, ProductUomState state) {
        String error = S.of(context).canNotGetDataFromServer;
        if (state is ProductUomLoadFailure) {
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
                    _productUomBloc.add(ProductUomRefreshed());
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
      builder: (BuildContext context, ProductUomState state) {
        if (state is ProductUomLoadSuccess) {
          _productUomCategories = state.productUomCategories;
        }
        return _productUomCategories.isEmpty ? _buildEmptyList() : _buildProductCategories();
      },
    );
  }

  Widget _buildProductCategories() {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: ListView.separated(
        itemCount: _productUomCategories.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildProductUomCategory(_productUomCategories[index]);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 0);
        },
      ),
    );
  }

  Widget _buildProductUomCategory(ProductUomCategory productUomCategory) {
    return productUomCategory.productUoms.isNotEmpty
        ? _buildProductUomCategoryHasChildren(productUomCategory)
        : _buildProductUomCategoryNoChild(productUomCategory);
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
                content: S.of(context).searchNotFoundWithKeywordParam(_search, S.of(context).units.toLowerCase()),
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
                content: S.of(context).emptyNotificationParam(S.of(context).unit.toLowerCase()),
                action: AppButton(
                  onPressed: () async {
                    final ProductUOM productUom = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const ProductUomAddEditPage();
                        },
                      ),
                    );

                    if (productUom != null) {
                      _productUomBloc.add(ProductUomRefreshed());
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
                      children:  [
                        const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 23,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          S.of(context).addNewParam(S.of(context).unit.toLowerCase()),
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

  ///Xây dựng giao diện đơn vị tính
  Widget _buildProductUOM(ProductUOM productUom) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 56.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ListTile(
                  onTap: () async {
                    if (widget.searchModel) {
                      widget.onSelected?.call(productUom);
                      Navigator.pop(context, productUom);
                    } else {
                      final ProductUOM result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ProductUomViewPage(productUom: productUom);
                          },
                        ),
                      );

                      if (result != null) {
                        _productUomBloc.add(ProductUomRefreshed());
                      }
                    }
                  },
                  contentPadding: const EdgeInsets.all(5),
                  title: Text(productUom.name ?? '', textAlign: TextAlign.start),
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xffE9F6EC),
                    child: Text(
                      productUom != null && productUom.name != '' ? productUom.name.substring(0, 1) : '',
                      style: const TextStyle(color: Color(0xff28A745)),
                    ),
                  ),
                ),
              ),
              if (widget.selectedItems != null &&
                  widget.selectedItems.any((ProductUOM item) => item.id == productUom.id))
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
          Container(color: Colors.grey.shade200, height: 1, width: double.infinity),
        ],
      ),
    );
  }

  ///Xây dựng giao diện nhóm đơn vị tính không có đơn vị tính
  Widget _buildProductUomCategoryNoChild(ProductUomCategory productUomCategory) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 16),
      child: Column(
        children: [
          ListTile(
            onTap: () async {},
            contentPadding: const EdgeInsets.all(5),
            title: Text(productUomCategory.name ?? '', textAlign: TextAlign.start),
            leading: CircleAvatar(
              backgroundColor: const Color(0xffE9F6EC),
              child: Text(
                productUomCategory != null && productUomCategory.name != ''
                    ? productUomCategory.name.substring(0, 1)
                    : '',
                style: const TextStyle(color: Color(0xff28A745)),
              ),
            ),
          ),
          Container(color: Colors.grey.shade200, height: 1, width: double.infinity),
        ],
      ),
    );
  }

  ///Xây dựng giao diện productUom khi có đơn vị tính
  Widget _buildProductUomCategoryHasChildren(ProductUomCategory productUomCategory) {
    return _buildExpanse(
        expanse: _search != '' || widget.searchModel,
        underLinePadding: const EdgeInsets.only(left: 16),
        header: Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 16),
          child: Stack(
            children: [
              ListTile(
                onTap: () async {},
                contentPadding: const EdgeInsets.all(5),
                title: Text(productUomCategory.name ?? '', textAlign: TextAlign.start),
                leading: CircleAvatar(
                  backgroundColor: const Color(0xffE9F6EC),
                  child: Text(
                    productUomCategory != null && productUomCategory.name != ''
                        ? productUomCategory.name.substring(0, 1)
                        : '',
                    style: const TextStyle(color: Color(0xff28A745)),
                  ),
                ),
              ),
              if (productUomCategory.productUoms.isNotEmpty)
                Positioned(
                  bottom: 8,
                  left: 32,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xff28A745),
                    ),
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      productUomCategory.productUoms.length.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ),
            ],
          ),
        ),
        body: _buildChildren(productUomCategory.productUoms));
  }

  ///Xây dựng giao diện danh sách con thuộc một đơn vị tính
  Widget _buildChildren(List<ProductUOM> productUoms) {
    return Column(
      children: productUoms.map((ProductUOM productUom) => _buildProductUOM(productUom)).toList(),
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
      update: true,
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
