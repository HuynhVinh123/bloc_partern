import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/feature_group/category/product_category/bloc/add_edit/product_category_add_edit_bloc.dart';
import 'package:tpos_mobile/feature_group/category/product_category/bloc/add_edit/product_category_add_edit_event.dart';
import 'package:tpos_mobile/feature_group/category/product_category/bloc/add_edit/product_category_add_edit_state.dart';
import 'package:tpos_mobile/feature_group/category/product_category/ui/product_category_add_edit_page.dart';
import 'package:tpos_mobile/resources/app_colors.dart';
import 'package:tpos_mobile/widgets/bloc_widget/base_bloc_listener_ui.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/custom_snack_bar.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/load_status.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

///Màn hình xem nhóm sản phẩm
class ProductCategoryViewPage extends StatefulWidget {
  const ProductCategoryViewPage({Key key, this.productCategory})
      : super(key: key);

  @override
  _ProductCategoryViewPageState createState() =>
      _ProductCategoryViewPageState();
  final ProductCategory productCategory;
}

class _ProductCategoryViewPageState extends State<ProductCategoryViewPage> {
  bool _change = false;
  ProductCategoryAddEditBloc _productCategoryAddEditBloc;
  ProductCategory _productCategory;

  Map<String, String> _propertyCostMethods;

  @override
  void initState() {
    _productCategoryAddEditBloc = ProductCategoryAddEditBloc();
    _productCategoryAddEditBloc.add(
        ProductCategoryAddEditStarted(productCategory: widget.productCategory));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _propertyCostMethods = <String, String>{
      'average': S.current.averagePriceOfRights,
      'standard': S.current.standardPrice,
      'fifo': S.current.firstInFirstOut,
    };
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _productCategoryAddEditBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_change) {
          Navigator.of(context).pop(_productCategory);
        } else {
          Navigator.of(context).pop();
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
    return AppBar(
      title: Text(
        S.current.productCategory,
        style: const TextStyle(color: Colors.white, fontSize: 21),
      ),
      leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (_change) {
              Navigator.of(context).pop(_productCategory);
            } else {
              Navigator.of(context).pop();
            }
          }),
      actions: [
        IconButton(
            icon: const Icon(
              Icons.edit_rounded,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () async {
              final ProductCategory productCategory = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ProductCategoryAddEditPage(
                      productCategory: widget.productCategory,
                    );
                  },
                ),
              );

              if (productCategory != null) {
                _change = true;
                _productCategoryAddEditBloc.add(
                    ProductCategoryAddEditUpdateLocal(
                        productCategory: productCategory));
              }
            }),
        IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () async {
              showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return _buildBottomSheet(context);
                  });
            }),
      ],
    );
  }

  Widget _buildBody() {
    return BaseBlocListenerUi<ProductCategoryAddEditBloc,
        ProductCategoryAddEditState>(
      bloc: _productCategoryAddEditBloc,
      loadingState: ProductCategoryAddEditLoading,
      busyState: ProductCategoryAddEditBusy,
      errorState: ProductCategoryAddEditLoadFailure,
      listener: (BuildContext context, ProductCategoryAddEditState state) {
        if (state is ProductCategoryAddEditDeleteError) {
          App.showDefaultDialog(
              title: S.current
                  .canNotDeleteParam(S.current.productCategory.toLowerCase()),
              context: context,
              type: AlertDialogType.error,
              content: state.error);
        } else if (state is ProductCategoryAddEditDeleteSuccess) {
          final Widget snackBar = getCloseableSnackBar(
              message: S.current.successfullyParam(S.current.delete),
              context: context);
          Scaffold.of(context).showSnackBar(snackBar);
          Navigator.of(context).pop(_productCategory);
        } else if (state is ProductCategoryAddEditSaveError) {
          App.showDefaultDialog(
              title: S.current.error,
              context: context,
              type: AlertDialogType.error,
              content: state.error);
        } else if (state is ProductCategoryAddEditDeleteTemporarySuccess) {
          final Widget snackBar = getCloseableSnackBar(
              message: state.isDelete
                  ? S.current.successfullyParam(S.current.delete)
                  : S.current
                      .successfullyParam(S.current.disableDeleteTemporary),
              context: context);
          Scaffold.of(context).showSnackBar(snackBar);
          Navigator.of(context).pop(_productCategory);
        }
      },
      errorBuilder: (BuildContext context, ProductCategoryAddEditState state) {
        String error = S.current.canNotGetDataFromServer;
        if (state is ProductCategoryAddEditLoadFailure) {
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
                      _productCategoryAddEditBloc.add(
                          ProductCategoryAddEditStarted(
                              productCategory: widget.productCategory));
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
      builder: (BuildContext context, ProductCategoryAddEditState state) {
        if (state is ProductCategoryAddEditLoadSuccess) {
          _productCategory = state.productCategory;
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(_productCategory),
              Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: _buildFieldRow(
                      title: S.current.rootCategory,
                      value: _productCategory.parent != null
                          ? _productCategory.parent.name ?? '---------'
                          : '---------')),
              Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: _buildFieldRow(
                      title: S.current.priceMethod,
                      value: _productCategory.propertyCostMethod != null &&
                              _productCategory.propertyCostMethod != '---------'
                          ? _propertyCostMethods[
                              _productCategory.propertyCostMethod]
                          : '---------')),
              Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: _buildFieldRow(
                      title: S.current.order,
                      value: _productCategory.sequence != null
                          ? _productCategory.sequence.toString()
                          : '---------')),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: _buildShowInPos(),
              )
            ],
          ),
        );
      },
    );
  }

  ///Xây dựng giao diện hiện thị trường dữ liệu theo dạng hàng
  Widget _buildFieldRow({String title, String value}) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: Text(title,
                      style: const TextStyle(
                          color: Color(0xff2C333A), fontSize: 17))),
              Flexible(
                  child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Text(value,
                    style: const TextStyle(
                        color: Color(0xff6B7280), fontSize: 17)),
              )),
            ],
          ),
          const SizedBox(height: 10),
          Container(
              color: Colors.grey.shade200, height: 1, width: double.infinity),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  ///Xây dựng tên của nhóm sản phẩm đứng đầu
  Widget _buildHeader(ProductCategory productCategory) {
    return Container(
      color: const Color(0xffF8F9FB),
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(S.current.productCategory.toUpperCase(),
                    style: const TextStyle(
                        color: Color(0xff929DAA), fontSize: 15)),
                Text(productCategory.name,
                    style: const TextStyle(
                        color: Color(0xff2C333A), fontSize: 21)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          SvgPicture.asset('assets/icon/product_category.svg'),
        ],
      ),
    );
  }

  ///Xây dựng giao diện chọn hiện trên điểm bán hàng
  Widget _buildShowInPos() {
    return Row(
      children: [
        Icon(
          FontAwesomeIcons.checkCircle,
          color: _productCategory.isPos
              ? const Color(0xff28A745)
              : const Color(0xff6B7280),
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(S.current.productGroup_showOnPosOfSale,
            style: const TextStyle(color: Color(0xff2C333A), fontSize: 17)),
      ],
    );
  }

  ///Xây dựng giao diện bottom sheet có xóa tạm và xóa
  Widget _buildBottomSheet(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          InkWell(
            onTap: () async {
              Navigator.pop(context);
              _productCategoryAddEditBloc.add(
                  ProductCategoryAddEditDeleteTemporary(
                      productCategory: _productCategory, isDelete: false));
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  const Icon(Icons.check_circle,
                      color: Color(0xff28A745), size: 23),
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
          const SizedBox(height: 5),
          InkWell(
            onTap: () async {
              final bool result = await showGeneralDialog(
                useRootNavigator: false,
                pageBuilder: (context, animation, secondAnimation) {
                  return AlertDialog(
                    title: Text(S.current.confirm),
                    content: Text(S.current.deleteTemporarySelectedParam(
                        S.current.productCategory.toLowerCase())),
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
                _productCategoryAddEditBloc.add(
                    ProductCategoryAddEditDeleteTemporary(
                        productCategory: _productCategory));
              }
            },
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 20),
                    const Icon(Icons.delete,
                        color: Color(0xff929DAA), size: 23),
                    const SizedBox(width: 10),
                    Text(
                      S.current.deleteTemporary,
                      style: const TextStyle(
                          color: Color(0xff2C333A), fontSize: 17),
                    )
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const SizedBox(width: 50),
                    const Icon(
                      Icons.info,
                      color: Color(0xff929DAA),
                      size: 20,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        S.current.deleteTemporaryCategoryNotification,
                        style: const TextStyle(
                            color: Color(0xff929DAA), fontSize: 13),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 5),
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: AppButton(
              background: Colors.transparent,
              onPressed: () async {
                final bool result = await showGeneralDialog(
                  useRootNavigator: false,
                  pageBuilder: (context, animation, secondAnimation) {
                    return AlertDialog(
                      title: Text(S.current.confirm),
                      content: Text(S.current.deleteTemporarySelectedParam(
                          S.current.productCategory.toLowerCase())),
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
                  _productCategoryAddEditBloc.add(ProductCategoryAddEditDeleted(
                      productCategory: _productCategory));
                }
              },
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  const Icon(Icons.close, size: 23, color: Colors.red),
                  const SizedBox(width: 10),
                  Text(
                    S.current.deleteGroup,
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
