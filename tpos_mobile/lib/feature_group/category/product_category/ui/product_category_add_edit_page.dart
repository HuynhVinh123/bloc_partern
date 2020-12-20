import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/feature_group/category/product_category/bloc/add_edit/product_category_add_edit_bloc.dart';
import 'package:tpos_mobile/feature_group/category/product_category/bloc/add_edit/product_category_add_edit_event.dart';
import 'package:tpos_mobile/feature_group/category/product_category/bloc/add_edit/product_category_add_edit_state.dart';
import 'package:tpos_mobile/feature_group/category/product_category/ui/product_category_list_page.dart';
import 'package:tpos_mobile/widgets/bloc_widget/base_bloc_listener_ui.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/custom_dropdown.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/load_status.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

///Xây dựng màn hình sửa thông tin nhóm sản phẩm
class ProductCategoryAddEditPage extends StatefulWidget {
  const ProductCategoryAddEditPage({Key key, this.productCategory}) : super(key: key);

  @override
  _ProductCategoryAddEditPageState createState() => _ProductCategoryAddEditPageState();
  final ProductCategory productCategory;
}

class _ProductCategoryAddEditPageState extends State<ProductCategoryAddEditPage> {
  ProductCategory _productCategory;

  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  ProductCategoryAddEditBloc _productCategoryAddEditBloc;

  Map<String, String> _propertyCostMethods = <String, String>{
    'average': 'Bình quân giá quyền',
    'standard': 'Giá cố định',
    'fifo': 'Nhập trước xuất trước',
  };

  String _propertyCost = 'standard';

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
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        widget.productCategory != null
            ? S.of(context).editNormalParam(S.of(context).productCategory.toLowerCase())
            : S.of(context).addParam(S.of(context).productCategory.toLowerCase()),
        style: const TextStyle(color: Colors.white, fontSize: 21),
      ),
      leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          }),
      actions: [
        IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: () {
              save();
            })
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
      errorBuilder: (BuildContext context, ProductCategoryAddEditState state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50 * (MediaQuery.of(context).size.height / 700)),
              LoadStatusWidget(
                statusName: S.of(context).loadDataError,
                content: S.of(context).canNotGetDataFromServer,
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
      listener: (BuildContext context, ProductCategoryAddEditState state) {
        if (state is ProductCategoryAddEditSaveSuccess) {
          _productCategory = state.productCategory;
          Navigator.of(context).pop(_productCategory);
        } else if (state is ProductCategoryAddEditLoadSuccess) {
          _productCategory = state.productCategory;
          _nameController.text = _productCategory.name;
          _propertyCost = _productCategory.propertyCostMethod;
          if (state is ProductCategoryAddEditNameError) {
            App.showDefaultDialog(
                title: S.of(context).error,
                context: context,
                type: AlertDialogType.error,
                content: S.of(context).canNotBeEmptyParam(S.of(context).name));
          }
        } else if (state is ProductCategoryAddEditSaveError) {
          App.showDefaultDialog(
              title: S.of(context).error, context: context, type: AlertDialogType.error, content: state.error);
        }
      },
      builder: (BuildContext context, ProductCategoryAddEditState state) {
        bool errorName = false;
        if (state is ProductCategoryAddEditLoadSuccess) {
          _productCategory = state.productCategory;
          if (state is ProductCategoryAddEditNameError) {
            errorName = true;
          }
        }
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 0, top: 10), child: _buildNote()),
                    Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 10),
                        child: _buildInputName(error: errorName)),
                    Padding(padding: const EdgeInsets.only(left: 16, right: 16), child: _buildSelectParent()),
                    Padding(padding: const EdgeInsets.only(left: 16, right: 12), child: _buildPropertyCostMethod()),
                    Padding(padding: const EdgeInsets.only(left: 16, right: 16), child: _buildSequence()),
                    Padding(padding: const EdgeInsets.only(left: 10, right: 16), child: _buildCheckPos()),
                    const SizedBox(
                      height: 80,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: _buildButton(),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        );
      },
    );
  }

  ///Xây dựng giao diện thông báo cho người dùng
  Widget _buildNote() {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xffFFF9E6),
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          border: Border.all(color: const Color(0xffFFE599))),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      child: Row(
        children: [
          SvgPicture.asset('assets/icon/warning.svg'),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              S.of(context).canNotChangePriceMethod,
              style: const TextStyle(color: Color(0xff2C333A), fontSize: 15),
            ),
          )
        ],
      ),
    );
  }

  ///Xây dựng giao diện nhập tên nhóm sản phẩm
  Widget _buildInputName({bool error = false}) {
    return TextField(
      controller: _nameController,
      focusNode: _nameFocusNode,
      maxLines: 1,
      style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(right: 10, bottom: 10),
        enabledBorder: error
            ? const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              )
            : UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
        hintText: S.of(context).productCategoryName,
        hintStyle: const TextStyle(color: Color(0xff929DAA), fontSize: 17),
        focusedBorder: error
            ? const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              )
            : const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xff28A745)),
              ),
      ),
    );
  }

  ///Giao diện chọn nhóm cha
  Widget _buildSelectParent() {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return InkWell(
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final ProductCategory result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ProductCategoriesPage(
                    searchModel: true,
                    selectedItems: _productCategory.parent != null ? [_productCategory.parent] : [],
                    current: _productCategory,
                  );
                },
              ),
            );

            if (result != null) {
              _productCategory.parent = result;
              _productCategory.parentId = result.id;
              setState(() {});
            }
          },
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(S.of(context).rootCategory,
                            style: const TextStyle(color: Color(0xff2C333A), fontSize: 17)),
                        const SizedBox(height: 7),
                        if (_productCategory.parent != null)
                          Text(_productCategory.parent.name ?? '',
                              style: const TextStyle(color: Color(0xff929DAA), fontSize: 15))
                        else
                          Text(S.of(context).selectParam(S.of(context).rootProductCategory.toLowerCase()),
                              style: const TextStyle(color: Color(0xff929DAA), fontSize: 15)),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 15, color: Color(0xff929DAA)),
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 10),
              Container(color: Colors.grey.shade200, height: 1, width: double.infinity),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  ///Chọn phương pháp giá
  Widget _buildPropertyCostMethod() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                S.of(context).priceMethod,
                style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
              ),
            ),
            StatefulBuilder(
              builder: (BuildContext context, void Function(void Function()) setState) {
                return Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)), color: Color.fromARGB(255, 248, 249, 251)),
                  child: CustomDropdown<String>(
                      selectedValue: _propertyCost,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.only(top: 5, left: 5),
                            alignment: Alignment.centerLeft,
                            child: Text(_propertyCostMethods[_propertyCost],
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style: const TextStyle(color: Color(0xff5A6271), fontSize: 15)),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 5, left: 0),
                            child: Icon(
                              Icons.arrow_drop_down,
                              color: Color(0xff858F9B),
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                      onSelected: (String selectedOrderBy) {
                        _propertyCost = selectedOrderBy;
                        setState(() {});
                      },
                      itemBuilder: (BuildContext context) => _propertyCostMethods.keys
                          .map((String action) => PopupMenuItem<String>(
                                value: action,
                                child: Text(
                                  _propertyCostMethods[action],
                                  style: const TextStyle(color: Color(0xff5A6271), fontSize: 15),
                                ),
                              ))
                          .toList()),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(color: Colors.grey.shade200, height: 1, width: double.infinity),
        const SizedBox(height: 10),
      ],
    );
  }

  ///Xây dựng giao diện nhập 'Thứ tự'
  Widget _buildSequence() {
    return Column(
      children: [
        const SizedBox(height: 5),
        Row(
          children: [
            Text(S.of(context).order, style: const TextStyle(color: Color(0xff2C333A), fontSize: 17)),
            Expanded(
              child: StatefulBuilder(
                builder: (BuildContext context, void Function(void Function()) setState) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 40,
                        child: AppButton(
                          width: 40,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(6)),
                              border: Border.all(color: const Color(0xffE9EDF2))),
                          child: const Icon(
                            Icons.arrow_drop_down_sharp,
                            color: Color(0xffA7B2BF),
                          ),
                          onPressed: () {
                            if (_productCategory.sequence > 0) {
                              _productCategory.sequence -= 1;
                              setState(() {});
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                          child: Container(
                        padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(6)),
                            border: Border.all(color: const Color(0xffE9EDF2))),
                        child: Text(
                          _productCategory.sequence.toString(),
                          style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
                        ),
                      )),
                      const SizedBox(width: 10),
                      Container(
                        height: 40,
                        child: AppButton(
                          width: 40,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(6)),
                              border: Border.all(color: const Color(0xffE9EDF2))),
                          child: const Icon(
                            Icons.arrow_drop_up,
                            color: Color(0xff28A745),
                          ),
                          onPressed: () {
                            _productCategory.sequence += 1;
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Container(color: Colors.grey.shade200, height: 1, width: double.infinity),
        const SizedBox(height: 10),
      ],
    );
  }

  ///Chọn hiện trên điểm bán hàng hay không
  Widget _buildCheckPos() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Checkbox(
              onChanged: (bool value) {
                _productCategory.isPos = value;
                setState(() {});
              },
              value: _productCategory.isPos,
            );
          },
        ),
        Text(
          S.of(context).productGroup_showOnPosOfSale,
          style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
        ),
      ],
    );
  }

  ///Giao diện nút lưu
  Widget _buildButton() {
    return AppButton(
      width: double.infinity,
      onPressed: () {
        save();
      },
      background: const Color(0xff28A745),
      child: Text(
        widget.productCategory != null ? S.of(context).edit : S.of(context).add,
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  ///Lưu thông tin
  void save() {
    if (_productCategory != null) {
      _productCategory.name = _nameController.text;
      _productCategory.propertyCostMethod = _propertyCost;
      _productCategoryAddEditBloc.add(ProductCategoryAddEditSaved(productCategory: _productCategory));
    } else {
      App.showDefaultDialog(
          title:  S.of(context).error, context: context, type: AlertDialogType.error, content:  S.of(context).canNotGetData);
    }
  }
}
