import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/feature_group/category/attribute_value_price/bloc/details/attribute_value_price_details_bloc.dart';
import 'package:tpos_mobile/feature_group/category/attribute_value_price/bloc/details/attribute_value_price_details_event.dart';
import 'package:tpos_mobile/feature_group/category/attribute_value_price/bloc/details/attribute_value_price_details_state.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/ui/product_attribute_line_action_page.dart';
import 'package:tpos_mobile/widgets/bloc_widget/base_bloc_listener_ui.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/load_status.dart';
import 'package:tpos_mobile/widgets/money_format_controller.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class AttributeValuePriceDetailsAddEditPage extends StatefulWidget {
  const AttributeValuePriceDetailsAddEditPage({Key key, this.productAttributeValue, this.productTemplateId})
      : super(key: key);

  @override
  _AttributeValuePriceDetailsAddEditPageState createState() => _AttributeValuePriceDetailsAddEditPageState();
  final ProductAttributeValue productAttributeValue;
  final int productTemplateId;
}

class _AttributeValuePriceDetailsAddEditPageState extends State<AttributeValuePriceDetailsAddEditPage> {
  ProductAttributeValue _productAttributeValue;
  AttributeValuePriceDetailsBloc _attributeValuePriceDetailsBloc;
  final TextEditingController _valueController = TextEditingController();
  final FocusNode _extraPriceFocusNode = FocusNode();
  final CustomMoneyMaskedTextController _extraPriceController = CustomMoneyMaskedTextController(
    minValue: 0,
    precision: 0,
    thousandSeparator: '.',
    decimalSeparator: '',
  );

  @override
  void initState() {
    _attributeValuePriceDetailsBloc = AttributeValuePriceDetailsBloc();
    _attributeValuePriceDetailsBloc.add(AttributeValuePriceDetailsInitial(
        productAttributeValueId: widget.productAttributeValue?.id, productTemplateId: widget.productTemplateId));
    super.initState();
  }

  @override
  void dispose() {
    _attributeValuePriceDetailsBloc.close();
    _valueController.dispose();
    _extraPriceFocusNode.dispose();
    _extraPriceController.dispose();
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
        widget.productAttributeValue != null
            ? S.of(context).addNewParam(S.of(context).variantPrice)
            : S.of(context).editNormalParam(S.of(context).variantPrice),
        style: const TextStyle(color: Colors.white, fontSize: 21),
      ),
      leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          }),
      actions: [
        IconButton(
            iconSize: 30,
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: () {
              save();
            })
      ],
    );
  }

  void save() {
    if (_productAttributeValue != null) {
      _productAttributeValue.name = _valueController.text;
      _productAttributeValue.priceExtra = _extraPriceController.numberValue;
      _attributeValuePriceDetailsBloc
          .add(AttributeValuePriceDetailsSaved(productAttributeValue: _productAttributeValue));
    } else {
      App.showDefaultDialog(
          title: S.of(context).error,
          context: context,
          type: AlertDialogType.error,
          content: S.of(context).canNotGetData);
    }
  }

  Widget _buildBody() {
    return BaseBlocListenerUi<AttributeValuePriceDetailsBloc, AttributeValuePriceDetailsState>(
      loadingState: AttributeValuePriceDetailsLoading,
      busyState: AttributeValuePriceDetailsBusy,
      bloc: _attributeValuePriceDetailsBloc,
      errorState: AttributeValuePriceDetailsLoadFailure,
      errorBuilder: (BuildContext context, AttributeValuePriceDetailsState state) {
        String error = S.of(context).canNotGetDataFromServer;
        if (state is AttributeValuePriceDetailsLoadFailure) {
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
                    _attributeValuePriceDetailsBloc.add(AttributeValuePriceDetailsInitial(
                        productAttributeValueId: widget.productAttributeValue?.id,
                        productTemplateId: widget.productTemplateId));
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
      listener: (BuildContext context, AttributeValuePriceDetailsState state) {
        if (state is AttributeValuePriceDetailsSaveFailure) {
          App.showDefaultDialog(
              title: S.of(context).error, context: context, type: AlertDialogType.error, content: state.error);
        } else if (state is AttributeValuePriceDetailsSaveSuccess) {
          Navigator.pop(context, state.productAttributeValue);
          // final Widget snackBar = customSnackBar(message: 'Lưu thành công', context: context);
          // Scaffold.of(context).showSnackBar(snackBar);
        } else if (state is AttributeValuePriceDetailsLoadSuccess) {
          _productAttributeValue = state.productAttributeValue;
          _extraPriceController.text = _productAttributeValue.priceExtra?.toStringAsFixed(0);
          _valueController.text = _productAttributeValue.name;
        }
      },
      builder: (BuildContext context, AttributeValuePriceDetailsState state) {
        if (state is AttributeValuePriceDetailsLoadSuccess) {
          _productAttributeValue = state.productAttributeValue;
        }

        return Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    StatefulBuilder(
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
                              _productAttributeValue.productAttribute = ProductAttribute(
                                  id: result.id,
                                  code: result.code,
                                  sequence: result.sequence,
                                  createVariant: result.createVariant);
                              _productAttributeValue.attributeName = result.name;
                              _productAttributeValue.attributeId = result.id;
                              _attributeValuePriceDetailsBloc.add(
                                  AttributeValuePriceDetailsUpdateLocal(productAttributeValue: _productAttributeValue));
                              setState(() {});
                            }
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(S.of(context).attribute,
                                    style: const TextStyle(color: Color(0xff2C333A), fontSize: 17)),
                              ),
                              Row(
                                children: [
                                  Text(
                                    _productAttributeValue.attributeName ??
                                        S.of(context).selectParam(S.of(context).attribute.toLowerCase()),
                                    style: _productAttributeValue.attributeName != null
                                        ? const TextStyle(color: Color(0xff2C333A), fontSize: 17)
                                        : const TextStyle(color: Color(0xff929DAA), fontSize: 17),
                                  ),
                                  const SizedBox(width: 10),
                                  const Icon(Icons.arrow_forward_ios, size: 15, color: Color(0xff929DAA)),
                                ],
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Container(color: Colors.grey.shade200, height: 1, width: double.infinity),
                    Row(
                      children: [
                        Text(S.of(context).value, style: const TextStyle(color: Color(0xff2C333A), fontSize: 17)),
                        Expanded(
                          child: TextField(
                            textAlign: TextAlign.end,
                            controller: _valueController,
                            maxLines: 1,
                            style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 20, right: 10),
                                hintStyle: const TextStyle(color: Color(0xff929DAA), fontSize: 17),
                                hintText: S.of(context).enterParam(S.of(context).value.toLowerCase()),
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none),
                          ),
                        ),
                      ],
                    ),
                    Container(color: Colors.grey.shade200, height: 1, width: double.infinity),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(S.of(context).extraPrice, style: const TextStyle(color: Color(0xff2C333A), fontSize: 17)),
                        Expanded(
                          child: StatefulBuilder(
                            builder: (BuildContext context, void Function(void Function()) setState) {
                              return Stack(
                                children: [
                                  if (_extraPriceController.text == '')
                                    Positioned(
                                        top: 11,
                                        right: 11,
                                        child: InkWell(
                                          child: RichText(
                                            text: TextSpan(style: DefaultTextStyle.of(context).style, children: [
                                              TextSpan(
                                                text: S.of(context).enterExtraPrice,
                                                style: const TextStyle(
                                                    color: Color(0xff929DAA),
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                              const TextSpan(
                                                text: ' đ',
                                                style: TextStyle(
                                                    color: Color(0xff929DAA),
                                                    decoration: TextDecoration.underline,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                            ]),
                                            maxLines: 1,
                                          ),
                                          onTap: () {
                                            if (_extraPriceFocusNode != null) {
                                              FocusScope.of(context).requestFocus(_extraPriceFocusNode);
                                            }
                                          },
                                        )),
                                  TextField(
                                    textAlign: TextAlign.end,
                                    controller: _extraPriceController,
                                    focusNode: _extraPriceFocusNode,
                                    maxLines: 1,
                                    onChanged: (String text) {
                                      setState(() {});
                                    },
                                    style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
                                    decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.only(left: 20, right: 10),
                                        hintStyle: TextStyle(color: Color(0xff929DAA), fontSize: 17),
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none),
                                  ),
                                ],
                              );
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              _buildButton(),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
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
        widget.productAttributeValue != null ? S.of(context).edit : S.of(context).add,
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}
