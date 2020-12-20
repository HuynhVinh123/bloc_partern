import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/bloc/add_edit/product_attribute_line_add_edit_bloc.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/bloc/add_edit/product_attribute_line_add_edit_event.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/bloc/add_edit/product_attribute_line_add_edit_state.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/ui/product_attribute_line_action_page.dart';
import 'package:tpos_mobile/widgets/bloc_widget/base_bloc_listener_ui.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/load_status.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

///Xây dựng giao diện sửa thuộc tính [ProductAttributeValue]
class ProductAttributeAddEditPage extends StatefulWidget {
  const ProductAttributeAddEditPage({Key key, this.productAttributeLine}) : super(key: key);

  @override
  _ProductAttributeAddEditPageState createState() => _ProductAttributeAddEditPageState();
  final ProductAttribute productAttributeLine;
}

class _ProductAttributeAddEditPageState extends State<ProductAttributeAddEditPage> {
  ProductAttribute _productAttributeLine;

  ProductAttributeLineAddEditBloc _productAttributeLineAddEditBloc;
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    _productAttributeLineAddEditBloc = ProductAttributeLineAddEditBloc();
    _productAttributeLineAddEditBloc
        .add(ProductAttributeLineAddEditStarted(productAttributeLine: widget.productAttributeLine));
    super.initState();
  }

  @override
  void dispose() {
    _productAttributeLineAddEditBloc.close();
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
    return AppBar(
      title: Text(
        widget.productAttributeLine != null
            ? S.of(context).editNormalParam(S.of(context).attributeValue.toLowerCase())
            : S.of(context).addParam(S.of(context).attributeValue.toLowerCase()),
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
    return BaseBlocListenerUi<ProductAttributeLineAddEditBloc, ProductAttributeLineAddEditState>(
      bloc: _productAttributeLineAddEditBloc,
      loadingState: ProductAttributeLineAddEditLoading,
      busyState: ProductAttributeLineAddEditBusy,
      errorState: ProductAttributeLineAddEditLoadFailure,
      listener: (BuildContext context, ProductAttributeLineAddEditState state) {
        if (state is ProductAttributeLineAddEditSaveSuccess) {
          Navigator.of(context).pop(state.productAttributeLine);
        } else if (state is ProductAttributeLineAddEditSaveError) {
          App.showDefaultDialog(title: '', context: context, content: state.error, type: AlertDialogType.error);
        } else if (state is ProductAttributeLineAddEditLoadSuccess) {
          _productAttributeLine = state.productAttributeLine;
          _nameController.text = state.productAttributeLine.name;
          _codeController.text = state.productAttributeLine.code;
        }
      },
      errorBuilder: (BuildContext context, ProductAttributeLineAddEditState state) {
        String error = S.of(context).canNotGetDataFromServer;
        if (state is ProductAttributeLineAddEditLoadFailure) {
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
                    _productAttributeLineAddEditBloc
                        .add(ProductAttributeLineAddEditStarted(productAttributeLine: widget.productAttributeLine));
                  },
                  width: 180,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 40, 167, 69),
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          FontAwesomeIcons.sync,
                          color: Colors.white,
                          size: 23,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Tải lại trang',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
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
      builder: (BuildContext context, ProductAttributeLineAddEditState state) {
        _productAttributeLine = state.productAttributeLine;
        _productAttributeLine.sequence ??= 0;
        return Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildAttribute(),
                    _buildInputs(),
                    _buildSequence(),
                  ],
                ),
              ),
              _buildButton(),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        );
      },
    );
  }

  ///Xây dựng giao diện chọn 'Thuộc tính'
  Widget _buildAttribute() {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return InkWell(
          onTap: () async {
            final ProductAttributeValue result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const ProductAttributeLineActionPage(isSearch: true);
                },
              ),
            );
            if (result != null) {
              _productAttributeLine.productAttribute = result;
              _productAttributeLine.attributeId = result.id;

              setState(() {});
            }
          },
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(S.of(context).attribute, style: const TextStyle(color: Color(0xff2C333A), fontSize: 17)),
                      Text(
                          _productAttributeLine.productAttribute != null
                              ? _productAttributeLine.productAttribute.name ?? ''
                              : S.of(context).selectParam(S.of(context).attribute.toLowerCase()),
                          style: const TextStyle(color: Color(0xff929DAA), fontSize: 15)),
                    ],
                  )),
                  const Icon(Icons.arrow_forward_ios, size: 15, color: Color(0xff929DAA)),
                  const SizedBox(width: 10)
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

  ///Xây dựng giao diện nhập 'Giá trị','Mã giá trị'
  Widget _buildInputs() {
    return Column(
      children: [
        _buildTextField(controller: _nameController, hint: S.of(context).value),
        const SizedBox(height: 5),
        _buildTextField(controller: _codeController, hint: S.of(context).attributeValueCode),
      ],
    );
  }

  ///Xây dựng giao diện nhập 'Thứ tự'
  Widget _buildSequence() {
    return Column(
      children: [
        const SizedBox(height: 10),
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
                      AppButton(
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(6)),
                            border: Border.all(color: const Color(0xffE9EDF2))),
                        child: const Icon(
                          Icons.arrow_drop_down_sharp,
                          color: Color(0xff28A745),
                        ),
                        onPressed: () {
                          if (_productAttributeLine.sequence > 0) {
                            _productAttributeLine.sequence -= 1;
                            setState(() {});
                          }
                        },
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                          child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(6)),
                            border: Border.all(color: const Color(0xffE9EDF2))),
                        child: Text(
                          _productAttributeLine.sequence.toString(),
                          style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
                        ),
                      )),
                      const SizedBox(width: 10),
                      AppButton(
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(6)),
                            border: Border.all(color: const Color(0xffE9EDF2))),
                        child: const Icon(
                          Icons.arrow_drop_up,
                          color: Color(0xff28A745),
                        ),
                        onPressed: () {
                          _productAttributeLine.sequence += 1;
                          setState(() {});
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(color: Colors.grey.shade200, height: 1, width: double.infinity),
        const SizedBox(height: 10),
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
        widget.productAttributeLine != null ? S.of(context).edit : S.of(context).add,
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  void save() {
    if (_nameController.text == '') {
      App.showDefaultDialog(
          title: S.of(context).error,
          context: context,
          type: AlertDialogType.error,
          content: S.of(context).canNotBeEmptyParam(S.of(context).attributeValue));
      return;
    }

    if (_productAttributeLine != null) {
      _productAttributeLine.name = _nameController.text;
      _productAttributeLine.code = _codeController.text;

      _productAttributeLineAddEditBloc
          .add(ProductAttributeLineAddEditSaved(productAttributeLine: _productAttributeLine));
    } else {
      App.showDefaultDialog(
          title: S.of(context).error,
          context: context,
          type: AlertDialogType.error,
          content: S.of(context).canNotGetData);
    }
  }

  Widget _buildTextField(
      {TextEditingController controller,
      String hint,
      Function(String) onTextChanged,
      EdgeInsets contentPadding = const EdgeInsets.only(right: 10)}) {
    return TextField(
      controller: controller,
      maxLines: 1,
      onChanged: onTextChanged,
      style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
      decoration: InputDecoration(
        contentPadding: contentPadding,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xff929DAA), fontSize: 17),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xff28A745)),
        ),
      ),
    );
  }
}
