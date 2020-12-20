import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/feature_group/category/product_uom/bloc/add_edit/product_uom_add_edit_bloc.dart';
import 'package:tpos_mobile/feature_group/category/product_uom/bloc/add_edit/product_uom_add_edit_event.dart';
import 'package:tpos_mobile/feature_group/category/product_uom/bloc/add_edit/product_uom_add_edit_state.dart';
import 'package:tpos_mobile/feature_group/category/product_uom_category/ui/product_uom_categories_page.dart';
import 'package:tpos_mobile/widgets/bloc_widget/base_bloc_listener_ui.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/custom_dropdown.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/load_status.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

///Xây dựng màn hình sửa thông tin nhóm sản phẩm
class ProductUomAddEditPage extends StatefulWidget {
  const ProductUomAddEditPage({Key key, this.productUom, this.productUomCategory}) : super(key: key);

  @override
  _ProductUomAddEditPageState createState() => _ProductUomAddEditPageState();
  final ProductUOM productUom;
  final ProductUomCategory productUomCategory;
}

class _ProductUomAddEditPageState extends State<ProductUomAddEditPage> {
  ProductUOM _productUom;

  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  ProductUomAddEditBloc _productUomAddEditBloc;

  Map<String, String> _uomTypes;

  void initState() {
    _productUomAddEditBloc = ProductUomAddEditBloc();
    _productUomAddEditBloc
        .add(ProductUomAddEditStarted(productUom: widget.productUom, productUomCategory: widget.productUomCategory));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _uomTypes = <String, String>{
      'bigger': S.of(context).largerOriginalUnit,
      'reference': S.of(context).originalUnitOfGroup,
      'smaller': S.of(context).smallerOriginalUnit,
    };
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _productUomAddEditBloc.close();
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
        widget.productUom != null
            ? S.of(context).editNormalParam(S.of(context).unit.toLowerCase())
            : S.of(context).addParam(S.of(context).unit.toLowerCase()),
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
    return BaseBlocListenerUi<ProductUomAddEditBloc, ProductUomAddEditState>(
      bloc: _productUomAddEditBloc,
      loadingState: ProductUomAddEditLoading,
      busyState: ProductUomAddEditBusy,
      errorState: ProductUomAddEditLoadFailure,
      buildWhen: (ProductUomAddEditState last, ProductUomAddEditState current) {
        return current is! ProductUomAddEditSaveError || current is! ProductUomAddEditDeleteError;
      },
      errorBuilder: (BuildContext context, ProductUomAddEditState state) {
        String error = S.of(context).canNotGetDataFromServer;
        if (state is ProductUomAddEditLoadFailure) {
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
                    _productUomAddEditBloc.add(ProductUomAddEditStarted(
                        productUom: widget.productUom, productUomCategory: widget.productUomCategory));
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
      listener: (BuildContext context, ProductUomAddEditState state) {
        if (state is ProductUomAddEditSaveSuccess) {
          _productUom = state.productUom;
          Navigator.of(context).pop(_productUom);
        } else if (state is ProductUomAddEditLoadSuccess) {
          _productUom = state.productUom;
          _nameController.text = _productUom.name;
        } else if (state is ProductUomAddEditSaveError) {
          App.showDefaultDialog(
              title: S.of(context).error, context: context, type: AlertDialogType.error, content: state.error);
        }
      },
      builder: (BuildContext context, ProductUomAddEditState state) {
        if (state is ProductUomAddEditLoadSuccess) {
          _productUom = state.productUom;
        }

        bool error = false;
        if (state is ProductUomAddEditNameError) {
          error = true;
        }
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 10),
                        child: _buildInputName(error: error)),
                    Padding(padding: const EdgeInsets.only(left: 16, right: 16), child: _buildSelectCategory()),
                    Padding(padding: const EdgeInsets.only(left: 16, right: 12), child: _buildUomType()),
                    if (_productUom.uOMType != 'reference')
                      Padding(padding: const EdgeInsets.only(left: 16, right: 16), child: _buildFactor()),
                    Padding(padding: const EdgeInsets.only(left: 16, right: 16), child: _buildRounding()),
                    Padding(padding: const EdgeInsets.only(left: 0, right: 16), child: _buildActive()),
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
        hintText: S.of(context).unitName,
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

  ///Giao diện chọn nhóm đơn vị tính
  Widget _buildSelectCategory() {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return IgnorePointer(
          ignoring: widget.productUomCategory != null,
          child: InkWell(
            onTap: () async {
              if (widget.productUomCategory == null) {
                final ProductUomCategory result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const ProductUomCategoriesPage(searchModel: true);
                    },
                  ),
                );

                if (result != null) {
                  _productUom.productUomCategory = result;
                  _productUom.categoryId = result.id;
                  _productUom.categoryName = result.name;
                  setState(() {});
                }
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
                          Text(S.of(context).rootProductCategory,
                              style: const TextStyle(color: Color(0xff2C333A), fontSize: 17)),
                          const SizedBox(height: 7),
                          if (_productUom.productUomCategory != null)
                            Text(_productUom.productUomCategory.name ?? '',
                                style: const TextStyle(color: Color(0xff929DAA), fontSize: 15))
                          else
                            Text(S.of(context).selectParam(S.of(context).rootProductCategory),
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
          ),
        );
      },
    );
  }

  ///Chọn loại
  Widget _buildUomType() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                S.of(context).type,
                style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)), color: Color.fromARGB(255, 248, 249, 251)),
              child: CustomDropdown<String>(
                  selectedValue: _productUom.uOMType,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.only(top: 5, left: 5),
                        alignment: Alignment.centerLeft,
                        child: Text(_uomTypes[_productUom.uOMType],
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: const TextStyle(color: Color(0xff5A6271), fontSize: 15)),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 8, left: 0),
                        child: Icon(
                          Icons.arrow_drop_down,
                          color: Color(0xff858F9B),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  onSelected: (String value) {
                    _productUom.uOMType = value;
                    if (_productUom.uOMType == 'bigger') {
                      _productUom.showFactor = _productUom.factorInv;
                    } else if (_productUom.uOMType == 'smaller') {
                      _productUom.showFactor = _productUom.factor;
                    }
                    setState(() {});
                  },
                  itemBuilder: (BuildContext context) => _uomTypes.keys
                      .map((String action) => PopupMenuItem<String>(
                            value: action,
                            child: Text(
                              _uomTypes[action],
                              style: const TextStyle(color: Color(0xff5A6271), fontSize: 15),
                            ),
                          ))
                      .toList()),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(color: Colors.grey.shade200, height: 1, width: double.infinity),
        const SizedBox(height: 10),
      ],
    );
  }

  ///Xây dựng giao diện nhập 'tỉ lệ'
  Widget _buildFactor() {
    return Column(
      children: [
        const SizedBox(height: 5),
        Row(
          children: [
            Text(S.of(context).factor, style: const TextStyle(color: Color(0xff2C333A), fontSize: 17)),
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
                            if (_productUom.showFactor > 0) {
                              _productUom.showFactor -= 1;
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
                          _productUom.showFactor.toStringAsFixed(2),
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
                            _productUom.showFactor += 1;
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

  ///Xây dựng giao diện nhập 'Làm tròn'
  Widget _buildRounding() {
    return Column(
      children: [
        const SizedBox(height: 5),
        Row(
          children: [
            Text(S.of(context).rounding, style: const TextStyle(color: Color(0xff2C333A), fontSize: 17)),
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
                            if (_productUom.rounding > 0) {
                              _productUom.rounding -= 0.01;
                              if (_productUom.rounding < 0) {
                                _productUom.rounding = 0;
                              }
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
                          _productUom.rounding.toStringAsFixed(2),
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
                            _productUom.rounding += 0.01;
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
  Widget _buildActive() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Checkbox(
              onChanged: (bool value) {
                _productUom.active = value;
                setState(() {});
              },
              value: _productUom.active,
            );
          },
        ),
        Text(
          S.of(context).active,
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
        widget.productUom != null ? S.of(context).edit : S.of(context).add,
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  ///Lưu thông tin
  void save() {
    if (_productUom != null) {
      _productUom.name = _nameController.text;
      _productUom.showUOMType = _uomTypes[_productUom.uOMType];
      if (_productUom.uOMType == 'bigger') {
        _productUom.factorInv = _productUom.showFactor;
      } else if (_productUom.uOMType == 'smaller') {
        _productUom.factor = _productUom.showFactor;
      }
      _productUomAddEditBloc.add(ProductUomAddEditSaved(productUom: _productUom));
    } else {
      App.showDefaultDialog(
          title: S.of(context).error,
          context: context,
          type: AlertDialogType.error,
          content: S.of(context).canNotGetData);
    }
  }
}
