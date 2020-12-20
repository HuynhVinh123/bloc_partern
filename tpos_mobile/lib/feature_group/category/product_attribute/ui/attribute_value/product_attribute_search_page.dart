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
class ProductAttributeValueSearchPage extends StatefulWidget {
  const ProductAttributeValueSearchPage({Key key, @required this.attributeId}) : super(key: key);

  @override
  _ProductAttributeValueSearchPageState createState() => _ProductAttributeValueSearchPageState();
  final int attributeId;
}

class _ProductAttributeValueSearchPageState extends State<ProductAttributeValueSearchPage> {
  ProductAttributeBloc _productAttributeBloc;

  @override
  void initState() {
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
    );
  }

  Widget _buildBody() {
    return BaseBlocListenerUi<ProductAttributeBloc, ProductAttributeState>(
      bloc: _productAttributeBloc,
      loadingState: ProductAttributeLoading,
      busyState: ProductAttributeBusy,
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
                action: AppButton(
                  onPressed: () {
                    _productAttributeBloc.add(ProductAttributeStarted(attributeId: widget.attributeId));
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
      builder: (BuildContext context, ProductAttributeState state) {
        return _buildAttributes(state.productAttributes);
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

  Widget _buildAttributeItem(ProductAttributeValue productAttribute) {
    return Column(
      children: <Widget>[
        const Divider(height: 2.0),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: ListTile(
            onTap: () {
              Navigator.pop(context, productAttribute);
            },
            contentPadding: const EdgeInsets.all(5),
            title: Text(productAttribute.nameGet ?? '', textAlign: TextAlign.start),
            leading: CircleAvatar(
              backgroundColor: const Color(0xffE9F6EC),
              child: Text(productAttribute.nameGet != null && productAttribute.nameGet != ''
                  ? productAttribute.nameGet.substring(0, 1)
                  : ''),
            ),
          ),
        ),
      ],
    );
  }
}
