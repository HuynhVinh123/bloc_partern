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
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/load_status.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

///Màn hình xem nhóm sản phẩm
class ProductCategoryViewPage extends StatefulWidget {
  const ProductCategoryViewPage({Key key, this.productCategory}) : super(key: key);

  @override
  _ProductCategoryViewPageState createState() => _ProductCategoryViewPageState();
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
    _productCategoryAddEditBloc.add(ProductCategoryAddEditStarted(productCategory: widget.productCategory));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _propertyCostMethods = <String, String>{
      'average': S.of(context).averagePriceOfRights,
      'standard': S.of(context).standardPrice,
      'fifo': S.of(context).firstInFirstOut,
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
        S.of(context).productCategory,
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
            icon: const Icon(Icons.edit_rounded, color: Colors.white),
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
                _productCategoryAddEditBloc.add(ProductCategoryAddEditUpdateLocal(productCategory: productCategory));
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
    return BaseBlocListenerUi<ProductCategoryAddEditBloc, ProductCategoryAddEditState>(
      bloc: _productCategoryAddEditBloc,
      loadingState: ProductCategoryAddEditLoading,
      busyState: ProductCategoryAddEditBusy,
      errorState: ProductCategoryAddEditLoadFailure,
      buildWhen: (ProductCategoryAddEditState last, ProductCategoryAddEditState current) {
        return current is! ProductCategoryAddEditSaveError || current is! ProductCategoryAddEditDeleteError;
      },
      listener: (BuildContext context, ProductCategoryAddEditState state) {
        if (state is ProductCategoryAddEditDeleteError) {
          App.showDefaultDialog(
              title: S.of(context).error, context: context, type: AlertDialogType.error, content: state.error);
        } else if (state is ProductCategoryAddEditDeleteSuccess) {
          Navigator.of(context).pop(_productCategory);
        }
      },
      errorBuilder: (BuildContext context, ProductCategoryAddEditState state) {
        String error = S.of(context).canNotGetDataFromServer;
        if (state is ProductCategoryAddEditLoadFailure) {
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
                    _productCategoryAddEditBloc
                        .add(ProductCategoryAddEditStarted(productCategory: widget.productCategory));
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
                      title: S.of(context).rootCategory,
                      value: _productCategory.parent != null ? _productCategory.parent.name ?? '' : '')),
              Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: _buildFieldRow(
                      title: S.of(context).priceMethod,
                      value: _productCategory.propertyCostMethod != null && _productCategory.propertyCostMethod != ''
                          ? _propertyCostMethods[_productCategory.propertyCostMethod]
                          : '')),
              Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: _buildFieldRow(
                      title: S.of(context).order,
                      value: _productCategory.sequence != null ? _productCategory.sequence.toString() : '')),
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
              Flexible(child: Text(title, style: const TextStyle(color: Color(0xff2C333A), fontSize: 17))),
              Flexible(
                  child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Text(value, style: const TextStyle(color: Color(0xff6B7280), fontSize: 17)),
              )),
            ],
          ),
          const SizedBox(height: 10),
          Container(color: Colors.grey.shade200, height: 1, width: double.infinity),
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
                Text(S.of(context).productCategory.toUpperCase(),
                    style: const TextStyle(color: Color(0xff929DAA), fontSize: 15)),
                Text(productCategory.name, style: const TextStyle(color: Color(0xff2C333A), fontSize: 21)),
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
          color: _productCategory.isPos ? const Color(0xff28A745) : const Color(0xff6B7280),
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(S.of(context).productGroup_showOnPosOfSale,
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
              final bool result = await showGeneralDialog(
                useRootNavigator: false,
                pageBuilder: (context, animation, secondAnimation) {
                  return AlertDialog(
                    title: Text(S.current.confirm),
                    content:
                        Text(S.of(context).deleteTemporarySelectedParam(S.of(context).productCategory.toLowerCase())),
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
                _productCategoryAddEditBloc
                    .add(ProductCategoryAddEditDeleteTemporary(productCategory: _productCategory));
              }
            },
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 20),
                    const Icon(Icons.delete, color: Color(0xff929DAA), size: 23),
                    const SizedBox(width: 10),
                    Text(
                      S.of(context).deleteTemporary,
                      style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
                    )
                  ],
                ),
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
                        S.of(context).deleteTemporaryCategoryNotification,
                        style: const TextStyle(color: Color(0xff929DAA), fontSize: 13),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
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
                      content:
                          Text(S.of(context).deleteTemporarySelectedParam(S.of(context).productCategory.toLowerCase())),
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
                  _productCategoryAddEditBloc.add(ProductCategoryAddEditDeleted(productCategory: _productCategory));
                }
              },
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  const Icon(Icons.close, size: 23, color: Colors.red),
                  const SizedBox(width: 10),
                  Text(
                    S.of(context).deleteGroup,
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
}
