import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/feature_group/tpage/settings/blocs/product/product_bloc.dart';
import 'package:tpos_mobile/feature_group/tpage/settings/blocs/product/product_event.dart';
import 'package:tpos_mobile/feature_group/tpage/settings/blocs/product/product_state.dart';
import 'package:tpos_mobile/feature_group/tpage/settings/uis/products/product_item.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/page_state/page_state.dart';
import 'package:tpos_mobile/widgets/page_state/page_state_type.dart';

class TPageProductListPage extends StatefulWidget {
  @override
  _TPageProductListPageState createState() => _TPageProductListPageState();
}

class _TPageProductListPageState extends State<TPageProductListPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusSearch = FocusNode();
  final ProductBloc _bloc = ProductBloc();
  final int top = 20;
  int skip = 0;
  final BehaviorSubject _behaviorSubject = BehaviorSubject();

  @override
  void initState() {
    super.initState();
    _behaviorSubject
        .debounceTime(const Duration(milliseconds: 500))
        .listen((value) {
      _bloc.add(ProductLoaded(skip: skip, top: top, keySearch: value));
    });

    _bloc.add(ProductLoaded(skip: skip, top: top));
  }

  /// Thực hiện add keyword search cho sản phẩm
  void onKeyWord(String value) {
    _behaviorSubject.add(value);
  }

  /// Thực hiện laod lại dữ liệu
  void onReloadData({int skipReload = 0, int topReload}) {
    _bloc.add(ProductLoaded(
        skip: skipReload,
        top: topReload ?? top,
        keySearch: _searchController.text));
  }

  @override
  Widget build(BuildContext context) {
    return BlocUiProvider<ProductBloc>(
      listen: (state) {
        if (state is ProductLoadFailure) {
          App.showDefaultDialog(
              content: state.content,
              title: state.title,
              context: context,
              type: AlertDialogType.error);
        } else if (state is ActionSuccess) {
          App.showToast(
              title: state.title, context: context, message: state.content);
          onReloadData(topReload: state.countProduct);
        } else if (state is ActionFailed) {
          App.showDefaultDialog(
              content: state.content,
              title: state.title,
              context: context,
              type: AlertDialogType.error);
        }
      },
      bloc: _bloc,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFEBEDEF),
          appBar: AppBar(
            title: const Text("Sản phẩm"),
          ),
          body: BlocLoadingScreen<ProductBloc>(
              busyStates: const [ProductLoading], child: _buildBody()),
        ),
      ),
    );
  }

  /// UI hiển thị thông tin của page
  Widget _buildBody() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 11,
          ),
          _buildSearchProduct(),
          const SizedBox(
            height: 18,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: const [
                Expanded(
                  child: Text(
                    "SẢN PHẨM",
                    style: TextStyle(color: Color(0xFF28A745), fontSize: 15),
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                  child: Text(
                    "THÊM VÀO PAGE",
                    style: TextStyle(color: Color(0xFF28A745), fontSize: 15),
                    textAlign: TextAlign.right,
                  ),
                )
              ],
            ),
          ),
          Flexible(
            child: BlocBuilder<ProductBloc, ProductState>(
                buildWhen: (prevState, currState) {
              if (currState is ProductLoadSuccess ||
                  currState is ProductLoadFailure) {
                return true;
              }
              return false;
            }, builder: (context, state) {
              if (state is ProductLoadSuccess) {
                return _buildListProduct(state);
              } else if (state is ProductLoadFailure) {
                return _buildFailed();
              }
              return const SizedBox();
            }),
          )
        ],
      ),
    );
  }

  /// UI hiển thị thông báo khi mất mạng hoặc load lỗi
  Widget _buildFailed() {
    return Container(
        margin: const EdgeInsets.only(top: 8),
        color: Colors.white,
        child: SingleChildScrollView(
          child: AppPageState(
            type: PageStateType.dataError,
            actions: [
              Container(
                width: 120,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: const Color(0xFF008E30),
                ),
                child: FlatButton(
                    onPressed: () {
                      onReloadData();
                    },
                    child: const Text(
                      "Tải lại",
                      style: TextStyle(color: Colors.white),
                    )),
              )
            ],
          ),
        ));
  }

  /// UI hiển thị thanh search
  Widget _buildSearchProduct() {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 16, right: 13),
            decoration: BoxDecoration(
                color: const Color(0xFFF8F9FB),
                borderRadius: BorderRadius.circular(24)),
            height: 40,
            child: Row(
              children: <Widget>[
                const SizedBox(
                  width: 12,
                ),
                const Icon(
                  Icons.search,
                  color: Color(0xFF5A6271),
                  size: 20,
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Center(
                    child: Container(
                        height: 35,
                        margin: const EdgeInsets.only(top: 0),
                        child: Center(
                          child: TextField(
                              controller: _searchController,
                              onChanged: (value) {
                                setState(() {});
                                onKeyWord(value);
                              },
                              focusNode: _focusSearch,
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(0),
                                  isDense: true,
                                  hintText: "Tìm kiếm sản phẩm",
                                  hintStyle: TextStyle(
                                      color: Color(0xFF929DAA), fontSize: 14),
                                  border: InputBorder.none)),
                        )),
                  ),
                ),
                Visibility(
                  visible: _searchController.text != "",
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 18,
                    ),
                    onPressed: () {
                      setState(() {
                        _searchController.text = "";
                      });
                      onReloadData();
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        Badge(
          badgeColor: Colors.redAccent,
          badgeContent: const Text(
            "0",
            style: TextStyle(color: Colors.white),
          ),
          child: Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
                color: Color(0xFFF8F9FB), shape: BoxShape.circle),
            child: Icon(
              Icons.filter_list,
              color: Colors.grey[600],
            ),
          ),
        ),
        const SizedBox(
          width: 24,
        ),
      ],
    );
  }

  /// UI hiển thị danh sách sản phẩm
  Widget _buildListProduct(ProductLoadSuccess state) {
    return state.products.isEmpty
        ? SingleChildScrollView(
            child: AppPageState(
              actions: [
                Container(
                  width: 120,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: const Color(0xFF008E30),
                  ),
                  child: FlatButton(
                      onPressed: () {
                        onReloadData();
                      },
                      child: const Text(
                        "Tải lại",
                        style: TextStyle(color: Colors.white),
                      )),
                )
              ],
            ),
          )
        : RefreshIndicator(
            onRefresh: () async {
              onReloadData();
              return true;
            },
            child: ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index) => const Divider(),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  return _buildItemProduct(state, index);
                }),
          );
  }

  /// UI hiển thị từng item trong danh sách sản phẩm
  Widget _buildItemProduct(ProductLoadSuccess state, int index) {
    return state.products[index].uOMName == "temp"
        ? _buildButtonLoadMore(state.products)
        : ProductItem(
            onPress: () {
              FocusScope.of(context).unfocus();
            },
            productTPageInfo: state.products[index],
            onChangeSelected: (value) {
              FocusScope.of(context).unfocus();
              final int productLength = state.products.length;
              _bloc.add(StatusProductUpdated(
                  productId: state.products[index].id,
                  countProduct:
                      state.products[productLength - 1].uOMName == "temp"
                          ? productLength - 1
                          : productLength));
            },
          );
  }

  /// Hiển thị button để thực hiện loadmore
  Widget _buildButtonLoadMore(List<Product> products) {
    return BlocBuilder<ProductBloc, ProductState>(builder: (context, state) {
      if (state is ProductLoadMoreLoading) {
        return Center(
          child: SpinKitCircle(
            color: Theme.of(context).primaryColor,
          ),
        );
      }
      return Center(
        child: Container(
            margin:
                const EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 8),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(3)),
            height: 45,
            child: FlatButton(
              onPressed: () {
                skip += top;
                _bloc.add(ProductLoadMoreLoaded(
                    skip: skip,
                    top: top,
                    productTPages: products,
                    keySearch: _searchController.text));
              },
              color: Colors.blueGrey,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: <Widget>[
                    /// Tải thêm
                    const Text("Tải thêm",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    const SizedBox(
                      width: 12,
                    ),
                    const Icon(
                      Icons.save_alt,
                      color: Colors.white,
                      size: 18,
                    )
                  ],
                ),
              ),
            )),
      );
    });
  }
}
