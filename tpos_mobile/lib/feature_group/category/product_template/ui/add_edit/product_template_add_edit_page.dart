import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/add_edit/product_template_add_edit_bloc.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/add_edit/product_template_add_edit_event.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/add_edit/product_template_add_edit_state.dart';
import 'package:tpos_mobile/feature_group/category/product_template/ui/add_edit/attributes_tab.dart';
import 'package:tpos_mobile/feature_group/category/product_template/ui/add_edit/general_info_tab.dart';
import 'package:tpos_mobile/widgets/bloc_widget/base_bloc_listener_ui.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/load_status.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

///Xây dựng giao diện sửa thông tin sản phẩm [ProductTemplate]
class ProductTemplateAddEditPage extends StatefulWidget {
  const ProductTemplateAddEditPage({Key key, this.productTemplate})
      : super(key: key);

  final ProductTemplate productTemplate;

  @override
  _ProductTemplateAddEditPageState createState() =>
      _ProductTemplateAddEditPageState();
}

class _ProductTemplateAddEditPageState
    extends State<ProductTemplateAddEditPage> {
  final PageController _pageController = PageController(initialPage: 0);

  ProductTemplateAddEditBloc _productTemplateAddEditBloc;
  int _currentIndex = 0;

  List<String> tabs;
  UserPermission _userPermission;
  String _saveTitle = S.current.save;
  ProductTemplate _productTemplate;

  @override
  void initState() {
    super.initState();
    _productTemplateAddEditBloc = ProductTemplateAddEditBloc();
    _productTemplateAddEditBloc.add(
        ProductTemplateAddEditStarted(productTemplate: widget.productTemplate));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    tabs ??= <String>[S.of(context).generalInformation, S.of(context).variant];
  }

  @override
  void dispose() {
    _pageController.dispose();
    _productTemplateAddEditBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, false);
        return false;
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          backgroundColor: const Color(0xffebedef),
          appBar: _buildAppbar(),
          body: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildAppbar() {
    return AppBar(
      leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context, false);
          }),
      title: Text(
        widget.productTemplate != null
            ? S.of(context).editProduct
            : S.of(context).insertProduct,
        style: const TextStyle(color: Colors.white, fontSize: 21),
      ),
      actions: [
        IconButton(
            icon: const Icon(Icons.check, color: Colors.white, size: 30),
            onPressed: () {
              if (_productTemplate != null) {
                _productTemplateAddEditBloc.add(ProductTemplateAddEditSaved());
              } else {
                App.showDefaultDialog(
                    title: S.of(context).error,
                    context: context,
                    type: AlertDialogType.error,
                    content: S.of(context).canNotGetData);
              }
            }),
      ],
    );
  }

  Widget _buildBody() {
    final bool isOpenKeyBoard = MediaQuery.of(context).viewInsets.bottom != 0;
    return BlocProvider<ProductTemplateAddEditBloc>.value(
      value: _productTemplateAddEditBloc,
      child: BaseBlocListenerUi<ProductTemplateAddEditBloc,
          ProductTemplateAddEditState>(
        loadingState: ProductTemplateAddEditLoading,
        bloc: _productTemplateAddEditBloc,
        busyState: ProductTemplateAddEditBusy,
        errorState: ProductTemplateAddEditLoadFailure,
        // buildWhen: (ProductTemplateAddEditState last, ProductTemplateAddEditState current) {
        //   return !(current is ProductTemplateAddEditSaveError || current is ProductTemplateAddEditUploadImageError);
        // },
        listener: (BuildContext context, ProductTemplateAddEditState state) {
          if (state is ProductTemplateAddEditSaveSuccess) {
            Navigator.pop(context, true);
          } else if (state is ProductTemplateAddEditSaveError) {
            App.showDefaultDialog(
                title: S.of(context).error,
                context: context,
                type: AlertDialogType.error,
                content: state.error);
          } else if (state is ProductTemplateAddEditNameEmpty) {
            App.showToast(
                title: S.current.warning,
                context: context,
                message: S
                    .of(context)
                    .pleaseEnterParam(S.current.productName.toLowerCase()),
                type: AlertDialogType.warning);
          } else if (state is ProductTemplateAddEditChangeUOMError) {
            App.showDefaultDialog(
                title: S.of(context).error,
                context: context,
                type: AlertDialogType.error,
                content: state.error);
          }
        },
        errorBuilder:
            (BuildContext context, ProductTemplateAddEditState state) {
          String error = S.of(context).canNotGetDataFromServer;
          if (state is ProductTemplateAddEditLoadFailure) {
            error = state.error ?? S.of(context).canNotGetDataFromServer;
          }

          return Container(
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                    height: 50 * (MediaQuery.of(context).size.height / 700)),
                LoadStatusWidget(
                  statusName: S.of(context).loadDataError,
                  content: error,
                  statusIcon: SvgPicture.asset('assets/icon/error.svg',
                      width: 170, height: 130),
                  action: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: AppButton(
                      onPressed: () {
                        _productTemplateAddEditBloc.add(
                            ProductTemplateAddEditStarted(
                                productTemplate: widget.productTemplate));
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
        builder: (BuildContext context, ProductTemplateAddEditState state) {
          bool errorName = false;
          if (state is ProductTemplateAddEditNameEmpty) {
            errorName = true;
          }
          _userPermission = state.userPermission;
          _productTemplate = state.productTemplate;

          return Stack(
            children: [
              Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      children: [
                        Expanded(
                            child: _buildHeaderTab(
                                S.of(context).generalInformation, true, 0)),
                        Expanded(
                            child: _buildHeaderTab(
                                S.of(context).variant, false, 1)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _pageController,
                      children: [
                        GeneralInfoTab(
                          isInsert: widget.productTemplate == null,
                          productTemplate: state.productTemplate,
                          isOpenKeyBoard: isOpenKeyBoard,
                          errorName: errorName,
                          userPermission: state.userPermission,
                        ),
                        AttributesTab(
                          productTemplate: state.productTemplate,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              if (!isOpenKeyBoard)
                Positioned(
                  bottom: 30,
                  left: 10,
                  right: 10,
                  child: AppButton(
                    onPressed: () {
                      _productTemplateAddEditBloc
                          .add(ProductTemplateAddEditSaved());
                    },
                    borderRadius: 8,
                    width: double.infinity,
                    height: 48,
                    background: const Color(0xff28A745),
                    child: Text(
                      _saveTitle,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  ///Xây dụng giao diện header tab
  Widget _buildHeaderTab(String name, bool isSelected, int index) {
    return InkWell(
      onTap: () {
        if (_currentIndex != index) {
          _currentIndex = index;
          if (_currentIndex == 1) {
            _saveTitle = S.current.saveProduct;
          } else {
            _saveTitle = S.current.save;
          }
          FocusScope.of(context).unfocus();
          _pageController.animateToPage(index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.linear);
          setState(() {});
        }
      },
      child: Container(
          height: 55,
          width: double.infinity,
          padding: const EdgeInsets.only(left: 10, top: 15, bottom: 15),
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(
              width: 2,
              color: _currentIndex == index
                  ? const Color(0xff28A745)
                  : Colors.transparent,
            ),
          )),
          child: Center(
            child: Text(
              name,
              style: TextStyle(
                  color: _currentIndex == index
                      ? const Color(0xff28A745)
                      : const Color(0xff929DAA),
                  fontSize: 15),
            ),
          )),
    );
  }
}
