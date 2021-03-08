import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/bloc/add_edit/product_attribute_line_add_edit_bloc.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/bloc/add_edit/product_attribute_line_add_edit_event.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/bloc/add_edit/product_attribute_line_add_edit_state.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/ui/product_attribute_value_add_edit_page.dart';
import 'package:tpos_mobile/widgets/bloc_widget/base_bloc_listener_ui.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/load_status.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

///Xây dựng giao diện sửa giá trị thuộc tính [ProductAttributeValue]
class ProductAttributeValueViewPage extends StatefulWidget {
  const ProductAttributeValueViewPage({Key key, this.productAttributeValue}) : super(key: key);

  @override
  _ProductAttributeValueViewPageState createState() => _ProductAttributeValueViewPageState();
  final ProductAttributeValue productAttributeValue;
}

class _ProductAttributeValueViewPageState extends State<ProductAttributeValueViewPage> {
  bool _change = false;
  ProductAttributeValue _productAttributeValue;
  ProductAttributeValueAddEditBloc _productAttributeLineAddEditBloc;

  @override
  void initState() {
    _productAttributeLineAddEditBloc = ProductAttributeValueAddEditBloc();
    _productAttributeLineAddEditBloc
        .add(ProductAttributeValueAddEditStarted(productAttributeLine: widget.productAttributeValue));
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
      leading: BackButton(
        onPressed: () {
          Navigator.of(context).pop(_change);
        },
      ),
      actions: [
        IconButton(
            icon: const Icon(
              Icons.edit_rounded,
              color: Colors.white,
              size: 25,
            ),
            onPressed: () async {
              // _productAttributeValue = ProductAttribute(
              //     productAttribute: widget.productAttributeValue,
              //     attributeId: widget.productAttributeValue.id,
              //     attributeValues: null);
              final ProductAttributeValue result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ProductAttributeValueAddEditPage(productAttributeLine: _productAttributeValue);
                  },
                ),
              );

              if (result != null) {
                _change = true;
                _productAttributeLineAddEditBloc
                    .add(ProductAttributeValueAddEditStarted(productAttributeLine: _productAttributeValue));
              }
            }),
        IconButton(
            icon: const Icon(FontAwesomeIcons.trash, color: Colors.white, size: 18),
            onPressed: () async {
              final bool result = await App.showConfirm(
                  title: S.of(context).confirmDelete,
                  content: S.of(context).deleteSelectConfirmParam(S.of(context).attributeValue.toLowerCase()));

              if (result != null && result) {
                if (_productAttributeValue != null) {
                  _productAttributeLineAddEditBloc
                      .add(ProductAttributeValueDelete(productAttributeLine: _productAttributeValue));
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
    return BaseBlocListenerUi<ProductAttributeValueAddEditBloc, ProductAttributeValueAddEditState>(
      bloc: _productAttributeLineAddEditBloc,
      loadingState: ProductAttributeValueAddEditLoading,
      busyState: ProductAttributeValueAddEditBusy,
      errorState: ProductAttributeValueAddEditLoadFailure,
      listener: (BuildContext context, ProductAttributeValueAddEditState state) {
        if (state is ProductAttributeValueDeleteSuccess) {
          Navigator.of(context).pop(true);
        } else if (state is ProductAttributeValueDeleteError) {
          App.showDefaultDialog(
              title: S.of(context).error, context: context, type: AlertDialogType.error, content: state.error);
        } else if (state is ProductAttributeValueAddEditSaveError) {
          App.showDefaultDialog(
              title: S.of(context).error, context: context, type: AlertDialogType.error, content: state.error);
        }
      },
      errorBuilder: (BuildContext context, ProductAttributeValueAddEditState state) {
        String error = S.of(context).canNotGetDataFromServer;
        if (state is ProductAttributeValueAddEditLoadFailure) {
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
                action: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: AppButton(
                    onPressed: () {
                      _productAttributeValue = widget.productAttributeValue;
                      _productAttributeLineAddEditBloc
                          .add(ProductAttributeValueAddEditStarted(productAttributeLine: _productAttributeValue));
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
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
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
      builder: (BuildContext context, ProductAttributeValueAddEditState state) {
        _productAttributeValue = state.productAttributeLine;
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildAttribute(_productAttributeValue),
              Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: _buildFieldRow(
                      title: S.of(context).attributeCode,
                      value: _productAttributeValue.code != null && _productAttributeValue.code != ''
                          ? _productAttributeValue.code
                          : '------')),
              Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: _buildFieldRow(
                      title: S.of(context).order,
                      value: _productAttributeValue.sequence != null
                          ? _productAttributeValue.sequence.toString()
                          : '------')),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttribute(ProductAttributeValue productAttributeLine) {
    return Container(
      color: const Color(0xffF8F9FB),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(S.of(context).attribute.toUpperCase(),
                    style: const TextStyle(color: Color(0xff929DAA), fontSize: 15)),
                const SizedBox(height: 10),
                Text(productAttributeLine.nameGet ?? '',
                    style: const TextStyle(color: Color(0xff2C333A), fontSize: 17)),
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
          const SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Color(0xff2C333A), fontSize: 17)),
              const SizedBox(width: 10),
              Expanded(
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(value, style: const TextStyle(color: Color(0xff6B7280), fontSize: 17)))),
            ],
          ),
          const SizedBox(height: 15),
          Container(color: Colors.grey.shade200, height: 1, width: double.infinity),
          const SizedBox(height: 0),
        ],
      ),
    );
  }
}
