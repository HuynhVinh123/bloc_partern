import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/bloc/attribute_value/product_attribute_bloc.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/bloc/attribute_value/product_attribute_event.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/bloc/attribute_value/product_attribute_state.dart';
import 'package:tpos_mobile/widgets/bloc_widget/base_bloc_listener_ui.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/load_status.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

///Xây dựng giao diện tìm kiếm giá trị thuộc tính  của thuộc tính khi truyền vào [attributeId]
///[insert] true thì cho phép chọn nhiều giá trị thuộc tính một lúc
///[removeAttribute] true thì set property productAttribute của dữ liệu trả về bằng null
class ProductAttributeValueSearchPage extends StatefulWidget {
  const ProductAttributeValueSearchPage(
      {Key key, @required this.attributeId, this.selectedItems, this.insert = false, this.removeAttribute = false})
      : super(key: key);

  @override
  _ProductAttributeValueSearchPageState createState() => _ProductAttributeValueSearchPageState();
  final int attributeId;
  final List<ProductAttributeValue> selectedItems;
  final bool insert;
  final bool removeAttribute;
}

class _ProductAttributeValueSearchPageState extends State<ProductAttributeValueSearchPage> {
  ProductAttributeBloc _productAttributeBloc;
  List<ProductAttributeValue> _selectedItems;

  @override
  void initState() {
    if (widget.insert) {
      _selectedItems = widget.selectedItems ?? [];
    }

    _productAttributeBloc = ProductAttributeBloc();
    _productAttributeBloc.add(ProductAttributeStarted(attributeId: widget.attributeId));
    super.initState();
  }

  @override
  void dispose() {
    _productAttributeBloc.close();
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
      title: Text(S.of(context).selectParam(S.of(context).attributeValue.toLowerCase())),
      actions: [
        if (widget.insert)
          IconButton(
            onPressed: () {
              Navigator.of(context).pop(_selectedItems);
            },
            icon: const Icon(Icons.check),
          )
      ],
    );
  }

  Widget _buildBody() {
    return BaseBlocListenerUi<ProductAttributeBloc, ProductAttributeState>(
      bloc: _productAttributeBloc,
      loadingState: ProductAttributeLoading,
      busyState: ProductAttributeBusy,
      errorState: ProductAttributeLoadFailure,
      errorBuilder: (BuildContext context, ProductAttributeState state) {
        String error = S.of(context).canNotGetDataFromServer;
        if (state is ProductAttributeLoadFailure) {
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
                      _productAttributeBloc.add(ProductAttributeStarted(attributeId: widget.attributeId));
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
      builder: (BuildContext context, ProductAttributeState state) {
        return Column(
          children: [
            Expanded(child: _buildAttributes(state.productAttributes)),
            if (widget.insert)
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 30),
                child: AppButton(
                  onPressed: () {
                    Navigator.of(context).pop(_selectedItems);
                  },
                  borderRadius: 8,
                  width: double.infinity,
                  height: 48,
                  background: const Color(0xff28A745),
                  child: Text(
                    S.current.insert,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildAttributes(List<ProductAttributeValue> productAttributes) {
    return ListView.separated(
      itemCount: productAttributes.length,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox();
      },
      itemBuilder: (BuildContext context, int index) {
        return _buildAttributeItem(productAttributes[index]);
      },
    );
  }

  Widget _buildAttributeItem(ProductAttributeValue productAttributeValue) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Column(
          children: <Widget>[
            const Divider(height: 2.0),
            ListTile(
              onTap: () {
                if (widget.insert) {
                  if (_selectedItems.any((ProductAttributeValue item) => item.id == productAttributeValue.id)) {
                    _selectedItems.removeWhere((element) => element.id == productAttributeValue.id);
                  } else {
                    if (widget.removeAttribute) {
                      productAttributeValue.productAttribute = null;
                    }
                    _selectedItems.add(productAttributeValue);
                  }
                  setState(() {});
                } else {
                  if (widget.removeAttribute) {
                    productAttributeValue.productAttribute = null;
                  }
                  Navigator.pop(context, productAttributeValue);
                }
              },
              contentPadding: const EdgeInsets.only(left: 13, right: 16, top: 5, bottom: 5),
              title: Text(productAttributeValue.nameGet ?? '', textAlign: TextAlign.start),
              leading: CircleAvatar(
                backgroundColor: const Color(0xffE9F6EC),
                child: Text(productAttributeValue.nameGet != null && productAttributeValue.nameGet != ''
                    ? productAttributeValue.nameGet.substring(0, 1)
                    : ''),
              ),
              trailing: _selectedItems.any((ProductAttributeValue item) => item.id == productAttributeValue.id)
                  ? const Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.check_circle,
                        color: Color(0xff28A745),
                        size: 20,
                      ),
                    )
                  : const SizedBox(),
            ),
          ],
        );
      },
    );
  }
}
