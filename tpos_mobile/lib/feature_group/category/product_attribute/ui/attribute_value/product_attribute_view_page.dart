import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/bloc/add_edit/product_attribute_line_add_edit_bloc.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/bloc/add_edit/product_attribute_line_add_edit_event.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/bloc/add_edit/product_attribute_line_add_edit_state.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/ui/product_attribute_add_edit_page.dart';
import 'package:tpos_mobile/widgets/bloc_widget/base_bloc_listener_ui.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/load_status.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

///Xây dựng giao diện sửa giá trị thuộc tính [ProductAttributeValue]
class ProductAttributeViewPage extends StatefulWidget {
  const ProductAttributeViewPage({Key key, this.productAttribute}) : super(key: key);

  @override
  _ProductAttributeViewPageState createState() => _ProductAttributeViewPageState();
  final ProductAttributeValue productAttribute;
}

class _ProductAttributeViewPageState extends State<ProductAttributeViewPage> {
  bool _change = false;
  ProductAttribute _productAttributeLine;
  ProductAttributeLineAddEditBloc _productAttributeLineAddEditBloc;

  @override
  void initState() {
    _productAttributeLineAddEditBloc = ProductAttributeLineAddEditBloc();
    _productAttributeLineAddEditBloc.add(ProductAttributeLineAddEditStarted(
        productAttributeLine: ProductAttribute(
            productAttribute: widget.productAttribute,
            attributeId: widget.productAttribute.id,
            attributeValues: null)));
    super.initState();
  }

  @override
  void dispose() {
    _productAttributeLineAddEditBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(_change);
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
        S.of(context).attributeValue,
        style: const TextStyle(color: Colors.white, fontSize: 21),
      ),
      leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(_change);
          }),
      actions: [
        IconButton(
            icon: const Icon(Icons.edit_rounded, color: Colors.white),
            onPressed: () async {
              _productAttributeLine = ProductAttribute(
                  productAttribute: widget.productAttribute,
                  attributeId: widget.productAttribute.id,
                  attributeValues: null);
              final ProductAttribute productAttributeLine = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ProductAttributeAddEditPage(productAttributeLine: _productAttributeLine);
                  },
                ),
              );

              if (productAttributeLine != null) {
                _change = true;
                _productAttributeLineAddEditBloc
                    .add(ProductAttributeLineAddEditStarted(productAttributeLine: _productAttributeLine));
              }
            }),
        IconButton(
            icon: const Icon(FontAwesomeIcons.trash, color: Colors.white),
            onPressed: () async {
              final bool result = await App.showConfirm(
                  title: S.of(context).confirmDelete,
                  content: S.of(context).deleteSelectConfirmParam(S.of(context).attributeValue.toLowerCase()));

              if (result != null && result) {
                if (_productAttributeLine != null) {
                  _productAttributeLineAddEditBloc
                      .add(ProductAttributeValueDelete(productAttributeLine: _productAttributeLine));
                } else {
                  App.showDefaultDialog(
                      title: S.of(context).error,
                      context: context,
                      type: AlertDialogType.error,
                      content: S.of(context).canNotGetData);
                }
              }
            }),
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
        if (state is ProductAttributeValueDeleteSuccess) {
          Navigator.of(context).pop(true);
        } else if (state is ProductAttributeValueDeleteError) {
          App.showDefaultDialog(
              title: S.of(context).error, context: context, type: AlertDialogType.error, content: state.error);
        } else if (state is ProductAttributeLineAddEditSaveError) {
          App.showDefaultDialog(
              title: S.of(context).error, context: context, type: AlertDialogType.error, content: state.error);
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
                    _productAttributeLine = ProductAttribute(
                        productAttribute: widget.productAttribute,
                        attributeId: widget.productAttribute.id,
                        attributeValues: null);
                    _productAttributeLineAddEditBloc
                        .add(ProductAttributeLineAddEditStarted(productAttributeLine: _productAttributeLine));
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
      builder: (BuildContext context, ProductAttributeLineAddEditState state) {
        _productAttributeLine = state.productAttributeLine;
        return SingleChildScrollView(
          child: Column(
            children: [
              _buildAttribute(_productAttributeLine),
              Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: _buildFieldRow(title: S.of(context).attributeCode, value: _productAttributeLine.code ?? '')),
              Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: _buildFieldRow(
                      title: S.of(context).order,
                      value: _productAttributeLine.sequence != null ? _productAttributeLine.sequence.toString() : '')),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttribute(ProductAttribute productAttributeLine) {
    return Container(
      color: const Color(0xffF8F9FB),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(S.of(context).attribute.toUpperCase(),
                    style: const TextStyle(color: Color(0xff929DAA), fontSize: 15)),
                Text(productAttributeLine.nameGet, style: const TextStyle(color: Color(0xff2C333A), fontSize: 21)),
                const SizedBox(height: 10)
              ],
            ),
          ),
          const SizedBox(width: 10),
          SvgPicture.asset('assets/icon/attribute.svg'),
        ],
      ),
    );
  }

  ///Xây dựng giao diện hiện thị trường dữ liệu theo dạng hàng
  Widget _buildFieldRow({String title, String value}) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Color(0xff2C333A), fontSize: 17)),
              const SizedBox(width: 10),
              Flexible(
                child: Row(
                  children: [
                    Flexible(child: Text(value, style: const TextStyle(color: Color(0xff6B7280), fontSize: 17))),
                    const SizedBox(width: 15),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(color: Colors.grey.shade200, height: 1, width: double.infinity),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
